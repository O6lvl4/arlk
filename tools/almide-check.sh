#!/usr/bin/env bash
# An Almide program, verified through the subset's semantics (#16):
#   - the committed model is exactly the translation of the program's bytes,
#   - the property checks against it, and travels as a bundle,
#   - a length-breaking edit of the program makes the old proof fail,
#   - constructs outside the subset are refused where they are written,
#   - the model agrees with the compiled program on an example (a test of
#     the model, not a proof that compilation preserves it).
#
#   tools/almide-check.sh ARLK WORKDIR
set -uo pipefail
arlk="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
# Absolute: the replays run from another directory.
rm -rf "$2"; mkdir -p "$2"; work="$(cd "$2" && pwd)"
cd "$(dirname "$0")/.."
fails=0
expect() { # name status cmd...
  local name="$1" want="$2"; shift 2
  "$@" >"$work/$name.log" 2>&1
  local got=$?
  if [ "$got" = "$want" ]; then echo "pass  $name (exit $got)"; else echo "FAIL  $name: exit $got, wanted $want (see $work/$name.log)"; fails=1; fi
}
contains() { # name text file
  if grep -qF -- "$2" "$3"; then echo "pass  $1"; else echo "FAIL  $1: '$2' not in $3"; fails=1; fi
}
P=examples/almide

expect model-is-the-translation 0 "$arlk" absorb-almide $P/reverse.almd --verify $P/reverse.arlk
expect property-checks 0 "$arlk" qed lib/almide.arlk $P/reverse.arlk $P/reverse_proof.arlk
expect bundle 0 "$arlk" bundle reverse_proof.reverse_length lib/almide.arlk $P/reverse.arlk $P/reverse_proof.arlk -o "$work/bundle"
expect replay 0 sh -c "cd / && '$arlk' replay '$work/bundle'"
contains bundle-carries-the-source-hash "almide-source-sha256: $(shasum -a 256 $P/reverse.almd | cut -d' ' -f1)" "$work/bundle/src/1-reverse.arlk"

# A reverse that drops elements: the old model is stale, and the old proof
# does not check against the new model.
sed 's/\[h, \.\.t\] => reverse(t) + \[h\],/[h, ..t] => reverse(t),/' $P/reverse.almd >"$work/reverse.almd"
if cmp -s $P/reverse.almd "$work/reverse.almd"; then echo "FAIL  the edit did not apply"; fails=1; fi
expect old-model-is-stale 1 "$arlk" absorb-almide "$work/reverse.almd" --verify $P/reverse.arlk
expect absorb-broken 0 "$arlk" absorb-almide "$work/reverse.almd" -o "$work/reverse.arlk"
expect old-proof-fails 1 "$arlk" qed lib/almide.arlk "$work/reverse.arlk" $P/reverse_proof.arlk
contains old-proof-fails-for-the-property "type mismatch" "$work/old-proof-fails.log"

# Outside the subset: refused where it is written.
printf 'fn double(n: Int) -> Int = n + n\n' >"$work/int.almd"
expect integers-refused 1 "$arlk" absorb-almide "$work/int.almd"
contains integers-refused-here "int.almd:1:14: the type Int" "$work/integers-refused.log"
printf 'type N =\n  | Z\n  | S(N)\n\nfn f(n: N) -> N = {\n  let m = n\n  m\n}\n' >"$work/block.almd"
expect blocks-refused 1 "$arlk" absorb-almide "$work/block.almd"
contains blocks-refused-here "block.almd:5:19: a block" "$work/blocks-refused.log"
printf 'type N =\n  | Z\n  | S(N)\n\nfn loop(n: N) -> N = match n {\n  Z => Z,\n  S(m) => loop(S(m)),\n}\n' >"$work/loop.almd"
expect absorb-loop 0 "$arlk" absorb-almide "$work/loop.almd" -o "$work/loop.arlk"
expect non-structural-refused 1 "$arlk" qed lib/almide.arlk "$work/loop.arlk"
contains non-structural-refused-why "structural recursion" "$work/non-structural-refused.log"

# The model against the compiled program, on the example main prints.
if command -v almide >/dev/null 2>&1; then
  expect compiled-program-runs 0 almide run $P/reverse.almd
  compiled=$(grep -E '^(Red|Green|Blue)( |$)' "$work/compiled-program-runs.log" | tail -1)
  { cat $P/reverse.arlk; printf '\nroom diff uses almide, almide_reverse\neval reverse(List.cons(Color.Red, List.cons(Color.Green, List.cons(Color.Blue, List.cons(Color.Blue, List.nil)))))\n'; } >"$work/diff.arlk"
  expect model-evaluates 0 "$arlk" qed lib/almide.arlk "$work/diff.arlk"
  model=$(grep -F 'reverse(' "$work/model-evaluates.log" | grep -F ' = ' | sed 's/.* = //' | grep -oE 'Color\.(Red|Green|Blue)' | sed 's/Color\.//' | tr '\n' ' ' | sed 's/ $//')
  if [ "$compiled" = "$model" ] && [ -n "$model" ]; then echo "pass  model agrees with the compiled program: $model"; else echo "FAIL  compiled '$compiled', model '$model'"; fails=1; fi
fi

exit $fails
