#!/usr/bin/env bash
# `arlk qed` and its earlier name `arlk check` (O6lvl4/arlk#26): the
# same output and exit status for every kind of invocation.
#
#   tools/cli-qed-check.sh ARLK
set -uo pipefail
arlk="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
cd "$(dirname "$0")/.."
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
fails=0
EQ=lib/std/eq.arlk; LOGIC=lib/std/logic.arlk; NAT=lib/std/nat.arlk
printf 'room bad uses eq, nat\ntheorem wrong(n: Nat) -> Eq(Nat, n, Nat.succ(n)) = Eq.refl\ntheorem wrong2(n: Nat) -> Eq(Nat, Nat.zero, Nat.succ(n)) = Eq.refl\n' >"$work/bad.arlk"

# name want-exit args...: both verbs give want-exit and the same output
# (milliseconds in --timing normalised).
same() {
  local name="$1" want="$2"; shift 2
  "$arlk" qed "$@" >"$work/v.out" 2>&1; local v=$?
  "$arlk" check "$@" >"$work/c.out" 2>&1; local c=$?
  # Timings vary, and so does which declarations are the slowest: the
  # timing summary is compared with its milliseconds blanked, the list of
  # slowest declarations left out.
  sed -E '/^ +[0-9]+ ms +line [0-9]+$/d; s/[0-9]+ ms/N ms/g' "$work/v.out" >"$work/v.norm"
  sed -E '/^ +[0-9]+ ms +line [0-9]+$/d; s/[0-9]+ ms/N ms/g' "$work/c.out" >"$work/c.norm"
  if [ "$v" != "$want" ] || [ "$c" != "$want" ]; then echo "FAIL  $name: exit qed=$v check=$c, wanted $want"; fails=1
  elif ! cmp -s "$work/v.norm" "$work/c.norm"; then echo "FAIL  $name: qed and check print differently"; diff "$work/v.norm" "$work/c.norm" | head -5; fails=1
  else echo "pass  $name (exit $want)"; fi
}

same valid 0 $EQ $LOGIC $NAT
same rejected 1 $EQ $LOGIC $NAT "$work/bad.arlk"
same out-of-order 1 $NAT $EQ
same keep-going 1 $EQ $LOGIC $NAT "$work/bad.arlk" --keep-going
same timing 0 $EQ $LOGIC $NAT --timing
same digest 0 $EQ $LOGIC $NAT --digest
same missing-file 1 "$work/none.arlk"
same no-files 2
# --keep-going reports both failures, the first alone stops at one.
"$arlk" qed $EQ $LOGIC $NAT "$work/bad.arlk" --keep-going >"$work/kg.out" 2>&1
if [ "$(grep -c '^✗' "$work/kg.out")" = 2 ]; then echo "pass  keep-going reports both failures"; else echo "FAIL  keep-going: $(grep -c '^✗' "$work/kg.out") failures reported"; fails=1; fi
# The help names qed first, and check as its earlier name.
"$arlk" >"$work/help.out" 2>&1
if grep -q '^ *arlk qed FILE.arlk' "$work/help.out" && grep -q '`arlk check` is the same command' "$work/help.out"; then echo "pass  usage names qed, and check as an alias"; else echo "FAIL  usage text"; fails=1; fi
exit $fails
