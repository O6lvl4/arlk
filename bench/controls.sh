#!/usr/bin/env bash
# Correctness gates of the benchmark (#17), run by CI:
#   - the inputs are the pinned ones (bench/manifest.txt hashes);
#   - every fixture checks, with no symbol or rule in its inventory;
#   - each semantic mutation is rejected, for a relevant proof error.
# With BEND set to a Bend command (e.g. "bun /path/bend2/main.ts"), the Bend
# fixtures and their mutations are run too (frontend and --verdict).
#
#   bench/controls.sh ARLK WORKDIR
set -uo pipefail
arlk="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
rm -rf "$2"; mkdir -p "$2"; work="$(cd "$2" && pwd)"
cd "$(dirname "$0")/.."
fails=0
pass() { echo "pass  $1"; }
fail() { echo "FAIL  $1"; fails=1; }

# Pinned inputs.
while read -r h path _; do
  case "$h" in ''|'#'*) continue ;; esac
  got=$(shasum -a 256 "$path" | cut -d' ' -f1)
  if [ "$got" = "$h" ]; then pass "pinned $path"; else fail "pinned $path: $got, manifest says $h"; fi
done < bench/manifest.txt

F=bench/fixtures
for f in $F/reverse/baseline.arlk $F/reverse/accumulator.arlk $F/sort/sort.arlk; do
  n=$(basename "$(dirname "$f")")-$(basename "$f" .arlk)
  if "$arlk" check "$f" >"$work/$n.log" 2>&1; then pass "$n checks"; else fail "$n checks (see $work/$n.log)"; fi
  if grep -q '^  symbols: (none)' "$work/$n.log" && grep -q '^  rules:   (none)' "$work/$n.log" && ! grep -qE '^  (symbols|rules): +[^( ]' "$work/$n.log"; then pass "$n rests on no symbol or rule"; else fail "$n inventory (see $work/$n.log)"; fi
done

# mutant NAME FILE SED WANT [LINE-OF-DECL]: rejected with WANT in the log,
# at the given declaration when one is named.
mutant() {
  local name="$1" file="$2" expr="$3" want="$4" decl="${5:-}"
  sed "$expr" "$file" >"$work/$name.arlk"
  if cmp -s "$file" "$work/$name.arlk"; then fail "$name: the edit did not apply"; return; fi
  "$arlk" check "$work/$name.arlk" --keep-going >"$work/$name.log" 2>&1
  local code=$?
  if [ "$code" != 1 ]; then fail "$name: exit $code, wanted 1 (see $work/$name.log)"; return; fi
  if ! grep -qF -- "$want" "$work/$name.log"; then fail "$name: rejected, but not for '$want' (see $work/$name.log)"; return; fi
  if [ -n "$decl" ]; then
    local line; line=$(grep -n "$decl" "$work/$name.arlk" | head -1 | cut -d: -f1)
    if ! grep -q "^✗ $work/$name.arlk:$line:" "$work/$name.log"; then fail "$name: not rejected at '$decl' (see $work/$name.log)"; return; fi
  fi
  pass "$name rejected ($want)"
}

for impl in baseline accumulator; do
  f=$F/reverse/$impl.arlk
  if [ $impl = baseline ]; then
    mutant "reverse-$impl-drops-element" $f 's/con(h, t) => snoc(rev(t), h),/con(h, t) => rev(t),/' "type mismatch" '^theorem rev_length'
    mutant "reverse-$impl-corrupt-proof" $f 's/con(h, t) => trans(len_snoc(rev(t), h), cong_s(rev_length(t))),/con(h, t) => trans(len_snoc(rev(t), h), rev_length(t)),/' "type mismatch" '^theorem rev_length'
  else
    mutant "reverse-$impl-drops-element" $f 's/con(h, t) => go(t, L.con(h, acc)),/con(h, t) => go(t, acc),/' "type mismatch" '^theorem go_length'
    mutant "reverse-$impl-corrupt-proof" $f 's/trans(go_length(xs, L.nil), add_z(len(xs)))/go_length(xs, L.nil)/' "type mismatch" '^theorem rev_length'
  fi
  mutant "reverse-$impl-false-law" $f 's/^theorem rev_length(xs: L) -> Eq(N, len(rev(xs)), len(xs))/theorem rev_length(xs: L) -> Eq(N, len(rev(xs)), N.s(len(xs)))/' "type mismatch" '^theorem rev_length'
done
S=$F/sort/sort.arlk
mutant sort-wrong-order $S 's/left(e) => List.cons(x, List.cons(h, t)),/left(e) => List.cons(h, List.cons(x, t)),/' "type mismatch" '^def sorted_ins_fin'
# Dropped insertion, with the order proof taken out so that only the
# multiplicity proof can reject it.
mutant sort-dropped-insertion $S 's/cons(h, t) => insert(h, sort(t)),/cons(h, t) => sort(t),/; /^theorem sort_sorted/,/^}/d; /^axioms sort_sorted/d' "type mismatch" '^theorem sort_perm'

if [ -n "${BEND:-}" ]; then
  for f in $F/reverse/baseline.bend $F/reverse/accumulator.bend $F/sort/sort.bend; do
    n=$(basename "$f" .bend)
    if BEND_NO_TELEMETRY=1 $BEND "$f" --verdict >"$work/bend-$n.log" 2>&1; then pass "bend $n --verdict"; else fail "bend $n --verdict (see $work/bend-$n.log)"; fi
  done
  bmut() { # name file sed
    sed "$3" "$2" >"$work/$1.bend"
    if cmp -s "$2" "$work/$1.bend"; then fail "$1: the edit did not apply"; return; fi
    if BEND_NO_TELEMETRY=1 $BEND "$work/$1.bend" --verdict >"$work/$1.log" 2>&1; then fail "$1 accepted"; else pass "$1 rejected"; fi
  }
  bmut bend-reverse-baseline-drops-element $F/reverse/baseline.bend 's/      snoc(rev(t), h)/      rev(t)/'
  bmut bend-reverse-accumulator-drops-element $F/reverse/accumulator.bend 's/      go(t, Con{h, acc})/      go(t, acc)/'
  bmut bend-sort-wrong-order $F/sort/sort.bend 's/      Con{x, Con{h, t}}/      Con{h, Con{x, t}}/'
else
  echo "skip  Bend lanes (set BEND to a Bend command to run them)"
fi
exit $fails
