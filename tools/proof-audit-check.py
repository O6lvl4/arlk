#!/usr/bin/env python3
"""Regression tests using a real, caller-selected Arlk checker (no network)."""
import copy
import importlib.util
import json
from pathlib import Path
import shutil
import subprocess
import sys
import tempfile
from types import SimpleNamespace
import unittest

ROOT = Path(__file__).resolve().parents[1]
ARLK = Path(sys.argv.pop(1)).resolve() if len(sys.argv) > 1 else ROOT / "arlk"
spec = importlib.util.spec_from_file_location("proof_audit", ROOT / "tools/proof-audit.py")
audit = importlib.util.module_from_spec(spec)
spec.loader.exec_module(audit)


class ProofAuditTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.shared = tempfile.TemporaryDirectory(prefix="arlk-audit-test-")
        cls.base = Path(cls.shared.name) / "reverse"
        cls.bundle(cls.base, "reverse_proof.reverse_length", "lib/almide.arlk",
                   "examples/almide/reverse.arlk", "examples/almide/reverse_proof.arlk")
        cls.policy = json.loads((ROOT / "examples/almide/reverse.audit.json").read_text())

    @classmethod
    def tearDownClass(cls):
        cls.shared.cleanup()

    @staticmethod
    def bundle(dest, claim, *files):
        result = subprocess.run([str(ARLK), "bundle", claim, *map(str, files), "-o", str(dest)],
                                cwd=ROOT, capture_output=True, text=True, timeout=60)
        if result.returncode:
            raise AssertionError(result.stdout + result.stderr)

    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory(prefix="arlk-audit-case-")
        self.addCleanup(self.tmp.cleanup)
        self.work = Path(self.tmp.name)
        self.candidate = self.work / "candidate"
        shutil.copytree(self.base, self.candidate)
        self.p = copy.deepcopy(self.policy)
        self.args = SimpleNamespace(policy=self.work / "policy.json", bundle=self.candidate,
                                    arlk=ARLK, source_root=ROOT, timeout=60)

    def run_audit(self):
        self.args.policy.write_text(json.dumps(self.p))
        return audit.audit(self.args)

    def reject(self, stage, message):
        result = self.run_audit()
        self.assertEqual(result["outcome"], "rejected", result)
        self.assertEqual(result["checks"][stage], "failed", result)
        self.assertIn(message, result["error"])
        return result

    def edit_manifest(self, edit):
        p = self.candidate / "manifest.txt"
        p.write_text(edit(p.read_text()))

    def rehash(self, path):
        h = audit.sha((self.candidate / path).read_bytes())
        self.edit_manifest(lambda text: "\n".join(
            "source: " + h + " " + line.split(" ", 2)[2]
            if line.startswith("source: ") and line.split(" ", 3)[2] == path else line
            for line in text.splitlines()) + "\n")

    def test_existing_reverse_claim_and_source_model(self):
        r = self.run_audit()
        self.assertEqual(r["outcome"], "accepted", r)
        self.assertEqual(set(r["checks"].values()), {"passed"})
        self.assertEqual(r["replay"]["exit_code"], 0)
        self.assertEqual(r["source_models"][0]["exit_code"], 0)
        self.assertEqual(r["checker"]["sha256"], audit.sha(ARLK.read_bytes()))

    def test_cli_json(self):
        self.args.policy.write_text(json.dumps(self.p))
        r = subprocess.run([sys.executable, str(ROOT / "tools/proof-audit.py"),
                            str(self.args.policy), str(self.candidate), "--arlk", str(ARLK),
                            "--source-root", str(ROOT)], capture_output=True, text=True, timeout=60)
        self.assertEqual(r.returncode, 0, r.stderr + r.stdout)
        self.assertEqual(json.loads(r.stdout)["outcome"], "accepted")

    def test_wrong_theorem(self):
        self.edit_manifest(lambda t: t.replace("claim: reverse_proof.reverse_length", "claim: reverse_proof.trans"))
        self.reject("snapshot", "different theorem")

    def test_wrong_expected_identity(self):
        self.p["claim_id"] = "0" * 64
        self.reject("replay", "replay did not succeed")

    def test_stale_bundled_source_hash(self):
        with (self.candidate / "src/1-reverse.arlk").open("a") as f:
            f.write("\n// stale\n")
        self.reject("snapshot", "stale source hash")

    def test_rehashed_invalid_proof(self):
        path = "src/2-reverse_proof.arlk"
        src = self.candidate / path
        text = src.read_text()
        self.assertIn("cong_succ(length(reverse(t)), length(t), reverse_length(t))", text)
        src.write_text(text.replace("cong_succ(length(reverse(t)), length(t), reverse_length(t))", "Eq.refl"))
        self.rehash(path)
        r = self.reject("replay", "replay did not succeed")
        self.assertEqual(r["replay"]["exit_code"], 1, r)

    def test_changed_dependency(self):
        self.edit_manifest(lambda t: t.replace("dep: ", "dep: bad-hash ", 1))
        self.reject("snapshot", "invalid dependency")

    def test_changed_dependency_hash(self):
        def edit(text):
            return "\n".join("dep: " + "0" * 64 + " " + line.split(" ", 2)[2]
                             if line.startswith("dep: ") else line for line in text.splitlines()) + "\n"
        self.edit_manifest(edit)
        self.reject("replay", "replay did not succeed")

    def test_self_consistent_unpermitted_axiom(self):
        source = self.work / "axiom.arlk"
        source.write_text("room audit\nsymbol P: Sort(0)\nsymbol extra: P\ntheorem goal: P = extra\n")
        self.candidate = self.work / "axiom-bundle"
        self.bundle(self.candidate, "audit.goal", source)
        self.args.bundle = self.candidate
        m = audit.manifest_from((self.candidate / "manifest.txt").read_bytes())
        self.p.update(claim="audit.goal", claim_id=m["claim-id"], models=[], permitted_symbols=["audit.P"])
        r = self.reject("assumptions", "audit.extra")
        self.assertEqual(r["checks"]["replay"], "passed")
        self.p["permitted_symbols"].append("audit.extra")
        self.assertEqual(self.run_audit()["outcome"], "accepted")

    def test_stale_original_hash(self):
        source = self.work / "examples/almide/reverse.almd"
        source.parent.mkdir(parents=True)
        source.write_bytes((ROOT / "examples/almide/reverse.almd").read_bytes() + b"\n// changed\n")
        self.args.source_root = self.work
        self.reject("snapshot", "stale original source")

    def test_stale_model_after_valid_replay(self):
        path = "src/1-reverse.arlk"
        with (self.candidate / path).open("a") as f:
            f.write("\n// model metadata edit\n")
        self.rehash(path)
        r = self.reject("source_models", "source/model verification did not succeed")
        self.assertEqual(r["checks"]["replay"], "passed")

    def test_model_sidecar_is_not_evidence(self):
        self.p["models"][0]["model"] = "src/sidecar.arlk"
        shutil.copyfile(self.candidate / "src/1-reverse.arlk", self.candidate / "src/sidecar.arlk")
        self.reject("snapshot", "not a replayed source")

    def test_candidate_recorded_success_is_only_metadata(self):
        self.edit_manifest(lambda t: "\n".join("recorded: verified by every kernel" if line.startswith("recorded:") else line
                                             for line in t.splitlines()) + "\n")
        self.p["claim_id"] = "0" * 64
        self.reject("replay", "replay did not succeed")

    def test_duplicate_policy_key(self):
        with self.assertRaisesRegex(audit.Rejected, "duplicate JSON key"):
            audit.policy_from(b'{"format":1,"format":1}')

    def test_unknown_policy_key(self):
        self.p["execute"] = "ignored.sh"
        self.reject("policy", "unknown or missing")

    def test_duplicate_manifest_key(self):
        self.edit_manifest(lambda t: t + "claim: reverse_proof.reverse_length\n")
        self.reject("snapshot", "duplicate manifest field")

    def test_unknown_or_package_manifest_fields(self):
        for field in ("execute", "package", "project", "provenance-id"):
            with self.subTest(field=field):
                shutil.copyfile(self.base / "manifest.txt", self.candidate / "manifest.txt")
                self.edit_manifest(lambda t: t + field + ": ignored\n")
                self.reject("snapshot", "unsupported manifest field")

    def test_duplicate_source(self):
        self.edit_manifest(lambda t: t + next(x for x in t.splitlines() if x.startswith("source:")) + "\n")
        self.reject("snapshot", "duplicate source")

    def test_duplicate_dependency(self):
        self.edit_manifest(lambda t: t + next(x for x in t.splitlines() if x.startswith("dep:")) + "\n")
        self.reject("snapshot", "duplicate dependency")

    def test_traversal(self):
        self.edit_manifest(lambda t: t.replace("src/1-reverse.arlk", "src/../../reverse.arlk"))
        self.reject("snapshot", "unsafe relative")

    def test_symlink_file(self):
        src = self.candidate / "src/1-reverse.arlk"
        src.unlink()
        src.symlink_to(self.base / "src/1-reverse.arlk")
        self.reject("snapshot", "symbolic links")

    def test_symlink_directory(self):
        shutil.rmtree(self.candidate / "src")
        (self.candidate / "src").symlink_to(self.base / "src", target_is_directory=True)
        self.reject("snapshot", "directory")

    def test_computed_literals_denied(self):
        with self.assertRaisesRegex(audit.Rejected, "unpermitted assumption category"):
            audit.assumptions_from(["axioms x", "  rooms: x", "  symbols: (none)",
                                    "  rules:   (none)", "  computed on literals: x.n (numerals ... computes)"], "x")

    def test_rules_inventory(self):
        r = audit.assumptions_from(["axioms x", "  rooms: x", "  symbols: x.T", "  rules:   [r1] a = b",
                                   "           [r2] b = c"], "x")
        self.assertEqual(r["rules"], ["[r1] a = b", "[r2] b = c"])

    def test_timeout_is_inconclusive(self):
        self.args.timeout = 0.000001
        r = self.run_audit()
        self.assertEqual(r["outcome"], "inconclusive", r)
        self.assertTrue(r["replay"]["timed_out"])

    def test_checker_crash_is_inconclusive(self):
        checker = self.work / "crashing-checker"
        checker.write_text("#!/bin/sh\nkill -KILL $$\n")
        checker.chmod(0o700)
        self.args.arlk = checker
        r = self.run_audit()
        self.assertEqual(r["outcome"], "inconclusive", r)
        self.assertEqual(r["checks"]["replay"], "inconclusive")
        self.assertLess(r["replay"]["exit_code"], 0)

    def test_unexpected_checker_exit_is_inconclusive(self):
        checker = self.work / "broken-checker"
        checker.write_text("#!/bin/sh\nexit 120\n")
        checker.chmod(0o700)
        self.args.arlk = checker
        self.assertEqual(self.run_audit()["outcome"], "inconclusive")

    def test_log_cap_is_inconclusive_even_if_checker_exits_zero(self):
        checker = self.work / "noisy-checker"
        checker.write_text("#!" + sys.executable + "\nimport os\nos.write(1, b'x' * " + str(audit.MAX_FILE) + ")\n")
        checker.chmod(0o700)
        self.args.arlk = checker
        r = self.run_audit()
        self.assertEqual(r["outcome"], "inconclusive", r)
        self.assertTrue(r["replay"]["output_limit_reached"])

    def test_valid_proof_of_different_statement_is_rejected(self):
        source = self.work / "other.arlk"
        source.write_text("room reverse_proof\ntheorem reverse_length(p: Sort(0), h: p) -> p = h\n")
        self.candidate = self.work / "other-bundle"
        self.bundle(self.candidate, "reverse_proof.reverse_length", source)
        self.args.bundle = self.candidate
        self.p["models"] = []
        r = self.reject("replay", "replay did not succeed")
        self.assertEqual(r["replay"]["exit_code"], 4)


if __name__ == "__main__":
    unittest.main(verbosity=2)
