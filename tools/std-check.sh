#!/usr/bin/env bash
# The native standard library (lib/std, #18) and its clients:
#   - the library checks from its own files, with no symbol, rule or axiom;
#   - the reverse and sort clients check against it, and the Almide model
#     shares its List (examples/std/almide_bridge.arlk);
#   - semantic mutations of the clients are rejected for the right reason;
#   - token counts (client and library apart) and check times are printed.
#
#   tools/std-check.sh ARLK WORKDIR
set -uo pipefail
arlk="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
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
lacks() { # name text file
  if grep -qF -- "$2" "$3"; then echo "FAIL  $1: '$2' in $3"; fails=1; else echo "pass  $1"; fi
}
mutate() { # name source sed-expression -> $work/name.arlk
  sed "$3" "$2" >"$work/$1.arlk"
  if cmp -s "$2" "$work/$1.arlk"; then echo "FAIL  $1: the edit did not apply"; fails=1; fi
}
EQ=lib/std/eq.arlk; LOGIC=lib/std/logic.arlk; NAT=lib/std/nat.arlk; AL=lib/almide.arlk; LIST=lib/std/list.arlk; WF=lib/std/wf.arlk
REV=examples/std/reverse.arlk; SORT=examples/std/sort.arlk; WFX=examples/std/wf.arlk

expect library 0 "$arlk" check $EQ $LOGIC $NAT $WF $AL $LIST
printf 'room audit uses eq, nat, almide, list, wf\naxioms wf.fix_eq\naxioms wf.lt_wf\naxioms list.append_assoc\naxioms list.length_snoc\naxioms nat.add_comm\naxioms nat.add_assoc\naxioms eq.cong2\naxioms eq.subst\n' >"$work/audit.arlk"
expect library-audit 0 "$arlk" check $EQ $LOGIC $NAT $WF $AL $LIST "$work/audit.arlk"
lacks library-has-no-symbols "symbols: eq." "$work/library-audit.log"
contains library-rests-on-types-only "symbols: (none)" "$work/library-audit.log"
lacks library-has-no-rules "rules:   eq" "$work/library-audit.log"
if grep -nE '^(symbol|rule) ' lib/std/*.arlk; then echo "FAIL  lib/std declares a symbol or rule"; fails=1; else echo "pass  lib/std declares no symbol or rule"; fi

expect reverse 0 "$arlk" check $EQ $NAT $AL $LIST $REV
expect sort 0 "$arlk" check $EQ $LOGIC $NAT $AL $LIST $SORT
expect almide-bridge 0 "$arlk" check $EQ $NAT $AL $LIST $REV examples/almide/reverse.arlk examples/std/almide_bridge.arlk
expect wf 0 "$arlk" check $EQ $LOGIC $NAT $WF $AL $LIST $WFX
for f in reverse sort almide-bridge wf; do contains "$f-no-symbols" "symbols: (none)" "$work/$f.log"; lacks "$f-no-symbol-names" "symbols: reverse" "$work/$f.log"; done

# Semantic negative controls.
mutate rev-drops $REV 's/cons(h, t) => append(rev(t), List.cons(h, List.nil)),/cons(h, t) => rev(t),/'
expect rev-drops 1 "$arlk" check $EQ $NAT $AL $LIST "$work/rev-drops.arlk"
contains rev-drops-why "type mismatch" "$work/rev-drops.log"
mutate rev-false-law $REV 's/^theorem rev_length\[u, A: Type(u)\](xs: List(A)) -> Eq(Nat, length(rev(xs)), length(xs))/theorem rev_length[u, A: Type(u)](xs: List(A)) -> Eq(Nat, length(rev(xs)), Nat.succ(length(xs)))/'
expect rev-false-law 1 "$arlk" check $EQ $NAT $AL $LIST "$work/rev-false-law.arlk"
contains rev-false-law-why "type mismatch" "$work/rev-false-law.log"
mutate rev-corrupt-proof $REV 's/cong_succ(rev_length(t))),/rev_length(t)),/'
expect rev-corrupt-proof 1 "$arlk" check $EQ $NAT $AL $LIST "$work/rev-corrupt-proof.arlk"
contains rev-corrupt-proof-why "type mismatch" "$work/rev-corrupt-proof.log"
mutate acc-drops $REV 's/cons(h, t) => go(t, List.cons(h, acc)),/cons(h, t) => go(t, acc),/'
expect acc-drops 1 "$arlk" check $EQ $NAT $AL $LIST "$work/acc-drops.arlk"
contains acc-drops-why "type mismatch" "$work/acc-drops.log"

# Wrong order: the smaller element goes second.
mutate sort-wrong-order $SORT 's/left(e) => List.cons(x, List.cons(h, t)),/left(e) => List.cons(h, List.cons(x, t)),/'
expect sort-wrong-order 1 "$arlk" check $EQ $LOGIC $NAT $AL $LIST "$work/sort-wrong-order.arlk" --keep-going
line=$(grep -n '^def sorted_ins_fin' $SORT | cut -d: -f1)
contains sort-wrong-order-in-sortedness "sort-wrong-order.arlk:$line:" "$work/sort-wrong-order.log"
# A dropped insertion (sort(t) for insert(h, sort(t))): the result is still
# ordered, so the order proof is taken out and only multiplicities can
# catch it, on exactly one declaration.
mutate sort-drops $SORT 's/cons(h, t) => insert(h, sort(t)),/cons(h, t) => sort(t),/; /^theorem sort_sorted/,/^}/d; /^axioms sort_sorted/d'
expect sort-drops 1 "$arlk" check $EQ $LOGIC $NAT $AL $LIST "$work/sort-drops.arlk" --keep-going
line=$(grep -n '^theorem sort_perm' "$work/sort-drops.arlk" | cut -d: -f1)
contains sort-drops-in-counts "sort-drops.arlk:$line:" "$work/sort-drops.log"
if [ "$(grep '^✗' "$work/sort-drops.log" | grep -vc 'unknown name sort_perm')" = 1 ]; then echo "pass  sort-drops-only-in-counts"; else echo "FAIL  sort-drops-only-in-counts: see $work/sort-drops.log"; fails=1; fi
# Well-founded recursion: a wrong result, a call without its proof, a call
# that does not decrease.
mutate wf-wrong-quotient $WFX 's/^theorem seven_div_two: Eq(Nat, div(n7, n2), n3)/theorem seven_div_two: Eq(Nat, div(n7, n2), n4)/'
expect wf-wrong-quotient 1 "$arlk" check $EQ $LOGIC $NAT $WF $AL $LIST "$work/wf-wrong-quotient.arlk"
contains wf-wrong-quotient-why "type mismatch" "$work/wf-wrong-quotient.log"
mutate wf-no-proof $WFX 's/gcd(Nat.succ(k), mod(a, k), mod_lt(a, k))/gcd(Nat.succ(k), mod(a, k))/'
expect wf-no-proof 1 "$arlk" check $EQ $LOGIC $NAT $WF $AL $LIST "$work/wf-no-proof.arlk"
contains wf-no-proof-why "a proof that the decreasing one is smaller" "$work/wf-no-proof.log"
mutate wf-not-smaller $WFX 's/msort(alt(List.cons(a, List.cons(b, t)), Bool.tt), alt_shorter/msort(List.cons(a, List.cons(b, t)), alt_shorter/'
expect wf-not-smaller 1 "$arlk" check $EQ $LOGIC $NAT $WF $AL $LIST "$work/wf-not-smaller.arlk"
contains wf-not-smaller-why "mismatch" "$work/wf-not-smaller.log"
# A false equality in the library itself.
mutate false-add $NAT 's/^theorem add_zero(n: Nat) -> Eq(Nat, add(n, Nat.zero), n)/theorem add_zero(n: Nat) -> Eq(Nat, add(n, Nat.zero), Nat.succ(n))/'
expect false-add 1 "$arlk" check $EQ "$work/false-add.arlk"
contains false-add-why "type mismatch" "$work/false-add.log"

echo
echo "tokens lines file (clients, then the library they load)"
python3 tools/tokens.py $REV $SORT examples/std/almide_bridge.arlk $WFX $EQ $LOGIC $NAT $WF $AL $LIST
echo
echo "check time, seconds (fresh process, this machine; advisory)"
for job in "reverse:$EQ $NAT $AL $LIST $REV" "sort:$EQ $LOGIC $NAT $AL $LIST $SORT" "wf:$EQ $LOGIC $NAT $WF $AL $LIST $WFX" "library:$EQ $LOGIC $NAT $WF $AL $LIST"; do
  name="${job%%:*}"; files="${job#*:}"
  start=$(date +%s.%N 2>/dev/null || date +%s)
  "$arlk" check $files >/dev/null 2>&1
  end=$(date +%s.%N 2>/dev/null || date +%s)
  echo "$name $(echo "$end - $start" | bc 2>/dev/null || echo '?')"
done
exit $fails
