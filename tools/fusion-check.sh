#!/usr/bin/env bash
# An Almide program, one proof using Agda + Isabelle, and adversarial replay.
# No external prover is needed. All checks run through Arlk's kernel.
# Usage: tools/fusion-check.sh ARLK WORKDIR
set -uo pipefail
arlk="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
mkdir -p "$2"
work="$(mktemp -d "$(cd "$2" && pwd)/fusion.XXXXXX")"
cd "$(dirname "$0")/.."
fails=0
expect() { # name status cmd...
  local name="$1" want="$2"; shift 2
  "$@" >"$work/$name.log" 2>&1
  local got=$?
  if [ "$got" = "$want" ]; then echo "pass  $name (exit $got)"
  else echo "FAIL  $name: exit $got, wanted $want (see $work/$name.log)"; fails=1; fi
}
contains() {
  if grep -qF -- "$2" "$3"; then echo "pass  $1"
  else echo "FAIL  $1: '$2' not in $3"; fails=1; fi
}
mutate() { # source target old new: fail if the test silently stopped mutating
  python3 - "$@" <<'PY'
import pathlib, sys
source, target, old, new = sys.argv[1:]
text = pathlib.Path(source).read_text()
if text.count(old) != 1:
    raise SystemExit(f"mutation must match exactly once: {old!r}")
pathlib.Path(target).write_text(text.replace(old, new))
PY
  if [ "$?" != 0 ]; then fails=1; return 1; fi
}
rehash() { # a forger also changes the source hash: replay must still recheck
  python3 - "$1" "$2" <<'PY'
import hashlib, pathlib, sys
bundle, relative = pathlib.Path(sys.argv[1]), sys.argv[2]
manifest = bundle / "manifest.txt"
digest = hashlib.sha256((bundle / relative).read_bytes()).hexdigest()
lines = manifest.read_text().splitlines()
found = 0
for i, line in enumerate(lines):
    fields = line.split()
    if len(fields) >= 3 and fields[0] == "source:" and fields[2] == relative:
        fields[1] = digest
        lines[i] = " ".join(fields)
        found += 1
if found != 1:
    raise SystemExit("expected exactly one source entry")
manifest.write_text("\n".join(lines) + "\n")
PY
  if [ "$?" != 0 ]; then fails=1; return 1; fi
}
inventory() { # require the exact final claim's assumptions and both systems
  python3 - "$1" <<'PY'
import pathlib, re, sys
lines = pathlib.Path(sys.argv[1]).read_text().splitlines()
assert "claim: batch_proof.flush_length" in lines
assert "assumes:   symbols: (none)" in lines
assert "assumes:   rules:   (none)" in lines
dependencies = {line.split(maxsplit=2)[2] for line in lines
                if re.fullmatch(r"dep: [0-9a-f]{64} .+", line)}
for name in ["agda.Arith.plusplus_length", "isabelle.Lists.itrev_rev", "isabelle.Main.length_rev"]:
    assert name in dependencies, f"final proof must depend on {name}"
    print(f"final proof depends on {name}")
PY
}

P=examples/almide
libs=(lib/std/eq.arlk lib/std/nat.arlk lib/almide.arlk lib/std/list.arlk
      absorbed/agda/arith.arlk examples/agda_transport.arlk
      lib/isabelle_main.arlk absorbed/isabelle/lists.arlk)

# Bind both absorbed sources and the exact program bytes to the checked model.
expect agda-source 0 sh -c "cd absorbed/agda && '$arlk' absorb-agda Arith.agda -o '$work/agda.arlk'"
expect agda-translation 0 cmp absorbed/agda/arith.arlk "$work/agda.arlk"
expect isabelle-source 0 sh -c "cd absorbed/isabelle && '$arlk' absorb-isabelle Lists.thy -o '$work/isabelle.arlk'"
expect isabelle-translation 0 cmp absorbed/isabelle/lists.arlk "$work/isabelle.arlk"
expect isabelle-main 0 "$arlk" absorb-isabelle --main -o "$work/main.arlk"
expect isabelle-main-translation 0 cmp lib/isabelle_main.arlk "$work/main.arlk"
expect program-model 0 "$arlk" absorb-almide "$P/batch.almd" --verify "$P/batch.arlk"
expect fused-proof 0 "$arlk" check "${libs[@]}" "$P/batch.arlk" "$P/batch_proof.arlk"

expect bundle 0 "$arlk" bundle batch_proof.flush_length "${libs[@]}" "$P/batch.arlk" "$P/batch_proof.arlk" -o "$work/bundle"
manifest="$work/bundle/manifest.txt"
expect dependency-and-assumption-inventory 0 inventory "$manifest"
if ! source_hash=$(shasum -a 256 "$P/batch.almd" | cut -d' ' -f1) || [[ ! "$source_hash" =~ ^[0-9a-f]{64}$ ]]; then
  echo "FAIL  cannot hash the Almide source"; exit 1
fi
contains bundle-carries-program-hash "almide-source-sha256: $source_hash" "$work/bundle/src/8-batch.arlk"
id=$(sed -n 's/^claim-id: //p' "$manifest")
if [[ ! "$id" =~ ^[0-9a-f]{64}$ ]]; then echo "FAIL  missing or malformed claim identity"; exit 1; fi
expect replay 0 sh -c "cd / && '$arlk' replay '$work/bundle' --expect '$id'"
expect wrong-claim 4 "$arlk" replay "$work/bundle" --expect 0000

# A program that drops each pending element makes the committed model stale,
# and cannot satisfy the original program-to-Isabelle preservation proof.
mutate "$P/batch.almd" "$work/batch.almd" 'flush(t, [h] + ready)' 'flush(t, ready)'
expect stale-program-model 1 "$arlk" absorb-almide "$work/batch.almd" --verify "$P/batch.arlk"
expect absorb-dropping-program 0 "$arlk" absorb-almide "$work/batch.almd" -o "$work/batch.arlk"
expect dropping-program 1 "$arlk" check "${libs[@]}" "$work/batch.arlk" "$P/batch_proof.arlk"
contains dropping-program-reason "simp could not prove it" "$work/dropping-program.log"

# This edit keeps the length but gets the order wrong. The Isabelle bridge
# must still reject it, so the order theorem is more than a count check.
mkdir "$work/order"
mutate "$P/batch.almd" "$work/order/batch.almd" 'flush(t, [h] + ready)' 'flush(t, ready + [h])'
expect absorb-reordering-program 0 "$arlk" absorb-almide "$work/order/batch.almd" -o "$work/order/batch.arlk"
expect reordering-program 1 "$arlk" check "${libs[@]}" "$work/order/batch.arlk" "$P/batch_proof.arlk"
contains reordering-program-reason "simp could not prove it" "$work/reordering-program.log"

# The two systems cannot merely be mentioned: their endpoints and bridges
# have to line up with the exact program/property being checked.
mutate "$P/batch_proof.arlk" "$work/wrong-inputs.arlk" 'agda.Arith.plusplus_length(encode(xs), encode(ys))' 'agda.Arith.plusplus_length(encode(xs), encode(xs))'
expect mismatched-lemma-inputs 1 "$arlk" check "${libs[@]}" "$P/batch.arlk" "$work/wrong-inputs.arlk"
contains mismatched-inputs-reason "type mismatch" "$work/mismatched-lemma-inputs.log"
mutate "$P/batch_proof.arlk" "$work/broken-bridge.arlk" 'cons(h, t) => isabelle.Main.list.Cons(h, encode(t)),' 'cons(h, t) => encode(t),'
expect broken-list-bridge 1 "$arlk" check "${libs[@]}" "$P/batch.arlk" "$work/broken-bridge.arlk"
contains broken-bridge-reason "simp could not prove it" "$work/broken-list-bridge.log"

# A native-only replacement is a valid proof, but is not the promised
# two-system proof. Test that the provenance gate notices this distinction.
mutate "$P/batch_proof.arlk" "$work/native-only.arlk" 'agda_list_bridge.length_append(isabelle_list_bridge.reversed(pending), ready)' 'list.length_append(isabelle_list_bridge.reversed(pending), ready)'
expect native-replacement-is-valid 0 "$arlk" bundle batch_proof.flush_length "${libs[@]}" "$P/batch.arlk" "$work/native-only.arlk" -o "$work/native-only"
expect missing-agda-provenance 1 inventory "$work/native-only/manifest.txt"
contains missing-agda-reason "final proof must depend on agda.Arith.plusplus_length" "$work/missing-agda-provenance.log"

# Replaying elsewhere cannot trust a claimed hash, dependency or inventory.
cp -R "$work/bundle" "$work/tampered"
cp "$work/wrong-inputs.arlk" "$work/tampered/src/9-batch_proof.arlk"
expect edited-source 3 "$arlk" replay "$work/tampered"
rehash "$work/tampered" src/9-batch_proof.arlk
expect forged-proof-rehashed 1 "$arlk" replay "$work/tampered"
contains forged-proof-reason "type mismatch" "$work/forged-proof-rehashed.log"
cp -R "$work/bundle" "$work/inventory"
mutate "$work/inventory/manifest.txt" "$work/inventory/manifest.txt" 'assumes:   symbols: (none)' 'assumes:   symbols: invented.axiom'
expect edited-assumptions 4 "$arlk" replay "$work/inventory"
cp -R "$work/bundle" "$work/dependency"
old=$(grep -E '^dep: [0-9a-f]+ agda.Arith.plusplus_length$' "$manifest")
mutate "$work/dependency/manifest.txt" "$work/dependency/manifest.txt" "$old" 'dep: 0000 agda.Arith.plusplus_length'
expect edited-dependency 4 "$arlk" replay "$work/dependency"

# A compiled example is only a model-consistency test, not a proof about
# compilation. CI has almide; an offline proof-only run can omit it.
if command -v almide >/dev/null 2>&1; then
  expect compiled-example 0 almide run "$P/batch.almd"
  contains compiled-example-order 'Green Red Blue' "$work/compiled-example.log"
else
  echo "skip  compiled example (almide not on PATH); proof and replay still checked"
fi

echo "Fusion logs and replayable bundle: $work"
exit "$fails"
