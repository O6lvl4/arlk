#!/usr/bin/env python3
"""Audit a plain Arlk bundle against a separately trusted exact-proof policy.

No code or configuration is imported from the candidate. This is not a sandbox,
a signature, an independent kernel, or a compiler-correctness proof. See
../docs/PROOF_AUDIT.md for the trust boundary and policy format.
"""
import argparse
import hashlib
import json
import math
import os
from pathlib import Path, PurePosixPath
import re
import resource
import stat
import subprocess
import tempfile

MAX_FILE = 16 * 1024 * 1024
MAX_TOTAL = 64 * 1024 * 1024
HASH = re.compile(r"[0-9a-f]{64}\Z")
SINGLE = {"arlk-bundle", "semantics", "claim", "statement", "claim-id", "recorded"}
MULTI = {"source", "dep", "assumes"}


class Rejected(ValueError):
    pass


def require(ok, why):
    if not ok:
        raise Rejected(why)


def sha(data):
    return hashlib.sha256(data).hexdigest()


def unique_object(pairs):
    obj = {}
    for key, value in pairs:
        require(key not in obj, f"duplicate JSON key: {key}")
        obj[key] = value
    return obj


def relative(value):
    require(isinstance(value, str) and value != "", "path must be nonempty text")
    p = PurePosixPath(value)
    require(not p.is_absolute() and str(p) == value and ".." not in value
            and all(re.fullmatch(r"[A-Za-z0-9_.-]+", s) for s in p.parts),
            f"unsafe relative path: {value}")
    return p


def read_regular(path):
    """Walk all components without following symlinks; read a bounded file."""
    path = Path(os.path.abspath(path))  # Do not resolve symlinks.
    fd = os.open(path.anchor, os.O_RDONLY | os.O_DIRECTORY)
    try:
        for part in path.parts[1:-1]:
            child = os.open(part, os.O_RDONLY | os.O_DIRECTORY | os.O_NOFOLLOW, dir_fd=fd)
            os.close(fd)
            fd = child
        child = os.open(path.name, os.O_RDONLY | os.O_NOFOLLOW | os.O_NONBLOCK, dir_fd=fd)
        with os.fdopen(child, "rb") as stream:
            require(stat.S_ISREG(os.fstat(stream.fileno()).st_mode), f"not a regular file: {path}")
            data = stream.read(MAX_FILE + 1)
            require(len(data) <= MAX_FILE, f"file exceeds {MAX_FILE} bytes: {path}")
            return data
    finally:
        os.close(fd)


def policy_from(data):
    p = json.loads(data, object_pairs_hook=unique_object)
    require(isinstance(p, dict) and set(p) == {
        "format", "claim", "claim_id", "permitted_symbols", "permitted_rules", "models"
    }, "unknown or missing policy field")
    require(type(p["format"]) is int and p["format"] == 1, "unsupported audit policy format")
    require(isinstance(p["claim"], str) and re.fullmatch(r"[A-Za-z_][A-Za-z0-9_.]*", p["claim"]),
            "invalid claim name")
    require(isinstance(p["claim_id"], str) and HASH.fullmatch(p["claim_id"]), "invalid claim ID")
    for field in ("permitted_symbols", "permitted_rules"):
        values = p[field]
        require(isinstance(values, list) and all(isinstance(v, str) and v and "\n" not in v for v in values),
                f"invalid {field}")
        require(len(values) == len(set(values)), f"duplicate {field}")
    require(isinstance(p["models"], list), "models must be a list")
    seen = set()
    for m in p["models"]:
        require(isinstance(m, dict) and set(m) == {"source", "sha256", "model"}, "invalid model binding")
        relative(m["source"])
        relative(m["model"])
        require(m["source"].endswith(".almd"), "model source must be .almd")
        require(isinstance(m["sha256"], str) and HASH.fullmatch(m["sha256"]), "invalid source SHA-256")
        require(m["model"] not in seen, "duplicate model binding")
        seen.add(m["model"])
    return p


def manifest_from(data):
    fields = {key: [] for key in MULTI}
    for line in data.decode("utf-8").splitlines():
        require(": " in line, "malformed manifest line")
        key, value = line.split(": ", 1)
        require(key in SINGLE | MULTI, f"unsupported manifest field: {key} (plain bundles only)")
        if key in SINGLE:
            require(key not in fields, f"duplicate manifest field: {key}")
            fields[key] = value
        else:
            fields[key].append(value)
    require(SINGLE <= fields.keys(), "missing manifest field")
    require(fields["arlk-bundle"] == "1", "unsupported bundle format")
    require(HASH.fullmatch(fields["claim-id"]), "invalid manifest claim ID")
    sources = {}
    for entry in fields["source"]:
        parts = entry.split(" ", 2)
        require(len(parts) == 3 and HASH.fullmatch(parts[0]), "invalid source entry")
        h, path, _ = parts
        relative(path)
        require(path.startswith("src/") and path.endswith(".arlk"), "bundle holds only src/*.arlk")
        require(path not in sources, f"duplicate source path: {path}")
        sources[path] = h
    require(0 < len(sources) <= 128, "bundle must list 1..128 sources")
    names = set()
    for entry in fields["dep"]:
        parts = entry.split(" ", 1)
        require(len(parts) == 2 and HASH.fullmatch(parts[0]) and parts[1], "invalid dependency entry")
        require(parts[1] not in names, f"duplicate dependency: {parts[1]}")
        names.add(parts[1])
    fields["sources"] = sources
    return fields


def assumptions_from(lines, claim):
    """Read only the manifest inventory that replay has recomputed and matched."""
    require(lines and lines[0] == "axioms " + claim, "invalid assumptions header")
    symbols, rules = None, None
    seen = set()
    for line in lines[1:]:
        if line.startswith("           ["):
            require(rules is not None and rules, "unexpected rule continuation")
            rules.append(line.strip())
            continue
        require(": " in line, "unknown assumption inventory line")
        key, value = line.strip().split(":", 1)
        value = value.strip()
        require(key not in seen, f"duplicate assumption field: {key}")
        seen.add(key)
        if key == "symbols":
            symbols = [] if value == "(none)" else value.split(", ")
        elif key == "rules":
            require(value == "(none)" or value.startswith("["), "invalid rules inventory")
            rules = [] if value == "(none)" else [value]
        else:
            require(key in {"rooms", "types", "through"}, f"unpermitted assumption category: {key}")
    require(symbols is not None and rules is not None, "missing symbol/rule inventory")
    return {"symbols": symbols, "rules": rules}


def run_checker(command, timeout):
    # The executable is trusted, candidate sources are data. A timeout is not a
    # proof rejection. Logs are diagnostic and never parsed as proof evidence.
    with tempfile.TemporaryFile() as log:
        try:
            result = subprocess.run(command, stdout=log, stderr=subprocess.STDOUT,
                                    timeout=timeout, check=False,
                                    preexec_fn=lambda: resource.setrlimit(resource.RLIMIT_FSIZE, (MAX_FILE, MAX_FILE)))
            code, timed_out = result.returncode, False
        except subprocess.TimeoutExpired:
            code, timed_out = None, True
        log.seek(0, os.SEEK_END)
        size = log.tell()
        log.seek(max(0, size - 16384))
        output = log.read().decode("utf-8", errors="replace")
    return {"exit_code": code, "timed_out": timed_out, "output_tail": output,
            "output_truncated": size > 16384, "output_limit_reached": size >= MAX_FILE}


def checker_outcome(result, failure_codes):
    if (result["timed_out"] or result["output_limit_reached"]
            or result["exit_code"] not in {0, *failure_codes}):
        return "inconclusive"
    return "passed" if result["exit_code"] == 0 else "failed"


def audit(args):
    report = {"format": 1, "outcome": "rejected", "checks": {
        name: "not_run" for name in ("policy", "snapshot", "replay", "assumptions", "source_models")
    }, "scope": "exact Arlk claim and requested source bindings; compiler executable correctness is not established"}
    stage = "policy"
    try:
        data = read_regular(args.policy)
        report["policy_sha256"] = sha(data)
        p = policy_from(data)
        report["claim"] = p["claim"]
        report["expected_claim_id"] = p["claim_id"]
        checker = Path(args.arlk).absolute()
        # Caller selects a trusted executable. This digest is an identifier,
        # not certification of the binary or an attestation of this JSON.
        report["checker"] = {"path": str(checker), "sha256": sha(read_regular(checker))}
        report["checks"][stage] = "passed"
        with tempfile.TemporaryDirectory(prefix="arlk-proof-audit-") as tmp:
            stage = "snapshot"
            snapshot = Path(tmp) / "bundle"
            snapshot.mkdir()
            raw = read_regular(Path(args.bundle) / "manifest.txt")
            report["manifest_sha256"] = sha(raw)
            m = manifest_from(raw)
            require(m["claim"] == p["claim"], "bundle names a different theorem")
            (snapshot / "manifest.txt").write_bytes(raw)
            total = len(raw)
            for path, expected in m["sources"].items():
                content = read_regular(Path(args.bundle) / path)
                total += len(content)
                require(total <= MAX_TOTAL, "bundle exceeds audit size limit")
                require(sha(content) == expected, f"stale source hash: {path}")
                dest = snapshot / path
                dest.parent.mkdir(parents=True, exist_ok=True)
                dest.write_bytes(content)
            report["sources"] = m["sources"]
            originals = []
            for i, binding in enumerate(p["models"]):
                require(binding["model"] in m["sources"], "bound model is not a replayed source")
                content = read_regular(Path(args.source_root) / binding["source"])
                require(sha(content) == binding["sha256"], f"stale original source: {binding['source']}")
                dest = Path(tmp) / "originals" / str(i) / Path(binding["source"]).name
                dest.parent.mkdir(parents=True)
                dest.write_bytes(content)
                originals.append(dest)
            report["checks"][stage] = "passed"
            stage = "replay"
            result = run_checker([str(checker), "replay", str(snapshot), "--expect", p["claim_id"]], args.timeout)
            report["replay"] = result
            status = checker_outcome(result, {1, 3, 4, 5, 6})
            if status == "inconclusive":
                report["outcome"] = "inconclusive"
            require(status == "passed", "checker replay did not succeed")
            report["checks"][stage] = "passed"
            report["statement"] = m["statement"]
            report["semantics"] = m["semantics"]
            stage = "assumptions"
            inventory = assumptions_from(m["assumes"], p["claim"])
            report["assumptions"] = inventory
            for kind in ("symbols", "rules"):
                extra = set(inventory[kind]) - set(p["permitted_" + kind])
                require(not extra, f"unpermitted {kind}: {', '.join(sorted(extra))}")
            report["checks"][stage] = "passed"
            stage = "source_models"
            report["source_models"] = []
            for binding, source in zip(p["models"], originals):
                result = run_checker([str(checker), "absorb-almide", str(source), "--verify",
                                      str(snapshot / binding["model"])], args.timeout)
                report["source_models"].append({**binding, **result})
                status = checker_outcome(result, {1})
                if status == "inconclusive":
                    report["outcome"] = "inconclusive"
                require(status == "passed", "source/model verification did not succeed")
            report["checks"][stage] = "passed"
            report["source_model_boundary"] = "verified" if p["models"] else "not_requested"
            report["outcome"] = "accepted"
    except (Rejected, OSError, UnicodeError, json.JSONDecodeError) as error:
        report["checks"][stage] = "inconclusive" if report["outcome"] == "inconclusive" else "failed"
        report["error"] = str(error)
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("policy", help="separately trusted JSON policy, never candidate supplied")
    parser.add_argument("bundle", help="untrusted plain Arlk bundle")
    parser.add_argument("--arlk", required=True, help="trusted checker executable path")
    parser.add_argument("--source-root", default=".", help="root of trusted original source paths")
    parser.add_argument("--timeout", type=float, default=60, help="seconds per checker command (default 60)")
    args = parser.parse_args()
    if not math.isfinite(args.timeout) or args.timeout <= 0:
        parser.error("timeout must be finite and positive")
    report = audit(args)
    print(json.dumps(report, indent=2, ensure_ascii=False))
    return 0 if report["outcome"] == "accepted" else (2 if report["outcome"] == "inconclusive" else 1)


if __name__ == "__main__":
    raise SystemExit(main())
