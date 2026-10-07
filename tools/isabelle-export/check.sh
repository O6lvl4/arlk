#!/usr/bin/env bash
# Isabelle's side of the absorption: confirm that Isabelle accepts the
# theories in absorbed/isabelle (when Isabelle is installed), then that
# `arlk absorb-isabelle` still writes the committed translation and the
# kernel accepts it, its proofs replayed by Arlk's simp.
#
#   tools/isabelle-export/check.sh ARLK [ISABELLE]
#
# Isabelle is optional: without it, only the Arlk side is checked.
set -uo pipefail
arlk="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
isa="${2:-$(command -v isabelle || true)}"
cd "$(dirname "$0")/../.."
work="$(mktemp -d)"
fails=0
if [ -n "$isa" ]; then
  if "$isa" build -D absorbed/isabelle >"$work/isabelle.log" 2>&1; then echo "pass  Isabelle accepts absorbed/isabelle"; else echo "FAIL  Isabelle rejects absorbed/isabelle (see $work/isabelle.log)"; fails=1; fi
else
  echo "skip  isabelle not installed: the theories are not run through Isabelle"
fi
# Main's fragment is what `absorb-isabelle --main` writes, and checks.
"$arlk" absorb-isabelle --main -o "$work/main.arlk" >/dev/null
if cmp -s "$work/main.arlk" lib/isabelle_main.arlk; then echo "pass  lib/isabelle_main.arlk is what absorb-isabelle --main writes"; else echo "FAIL  lib/isabelle_main.arlk differs from absorb-isabelle --main"; diff lib/isabelle_main.arlk "$work/main.arlk" | head -20; fails=1; fi
for src in absorbed/isabelle/*.thy; do
  name="$(basename "$src" .thy)"
  out="absorbed/isabelle/$(echo "$name" | tr '[:upper:]' '[:lower:]').arlk"
  (cd absorbed/isabelle && "$arlk" absorb-isabelle "$(basename "$src")" -o "$work/$name.arlk" >/dev/null) || { echo "FAIL  absorb-isabelle $src"; fails=1; continue; }
  if cmp -s "$work/$name.arlk" "$out"; then echo "pass  $out is what absorb-isabelle writes"; else echo "FAIL  $out differs from absorb-isabelle's output"; diff "$out" "$work/$name.arlk" | head -20; fails=1; fi
  if "$arlk" qed lib/std/eq.arlk lib/isabelle_main.arlk "$out" >"$work/$name.check.log" 2>&1; then echo "pass  kernel accepts $out ($(tail -1 "$work/$name.check.log" | sed -E 's/.*\(([0-9]+) declarations\)/\1/') declarations)"; else echo "FAIL  kernel rejects $out"; tail -3 "$work/$name.check.log"; fails=1; fi
done
# A false lemma cannot be proved by replaying its proof method.
sed 's/^lemma rev_rev: "rev (rev xs) = xs"/lemma rev_rev: "rev (rev xs) = rev xs"/' absorbed/isabelle/Arith.thy >"$work/Bad.thy"
sed -i.bak 's/^theory Arith/theory Bad/' "$work/Bad.thy"
(cd "$work" && "$arlk" absorb-isabelle Bad.thy -o Bad.arlk >/dev/null)
if "$arlk" qed lib/std/eq.arlk lib/isabelle_main.arlk "$work/Bad.arlk" >"$work/bad.log" 2>&1; then echo "FAIL  a false lemma was accepted"; fails=1; elif grep -q "simp could not prove it" "$work/bad.log"; then echo "pass  a false lemma is rejected"; else echo "FAIL  a false lemma is rejected for another reason"; tail -3 "$work/bad.log"; fails=1; fi
# Main's fragment: a false lemma over Main's lists fails too, and a lemma
# whose proof needs a lemma it is not given (add.commute) is not proved.
sed 's/^lemma rev_two: "rev \[a, b\] = \[b, a\]"/lemma rev_two: "rev [a, b] = [a, b]"/; s/^theory Lists/theory BadLists/' absorbed/isabelle/Lists.thy >"$work/BadLists.thy"
if cmp -s absorbed/isabelle/Lists.thy "$work/BadLists.thy"; then echo "FAIL  the Lists mutation did not apply"; fails=1; fi
(cd "$work" && "$arlk" absorb-isabelle BadLists.thy -o BadLists.arlk >/dev/null)
if "$arlk" qed lib/std/eq.arlk lib/isabelle_main.arlk "$work/BadLists.arlk" >"$work/badlists.log" 2>&1; then echo "FAIL  a false lemma over Main was accepted"; fails=1; elif grep -q "simp could not prove it" "$work/badlists.log"; then echo "pass  a false lemma over Main is rejected"; else echo "FAIL  a false lemma over Main failed for another reason"; tail -2 "$work/badlists.log"; fails=1; fi
sed 's/thus ?case by (simp add: add.commute)/thus ?case by simp/; s/^theory Lists/theory NoComm/' absorbed/isabelle/Lists.thy >"$work/NoComm.thy"
(cd "$work" && "$arlk" absorb-isabelle NoComm.thy -o NoComm.arlk >/dev/null)
if "$arlk" qed lib/std/eq.arlk lib/isabelle_main.arlk "$work/NoComm.arlk" >"$work/nocomm.log" 2>&1; then echo "FAIL  total_rev was proved without add.commute"; fails=1; elif grep -q "simp could not prove it" "$work/nocomm.log"; then echo "pass  total_rev needs add.commute"; else echo "FAIL  total_rev without add.commute failed for another reason"; tail -2 "$work/nocomm.log"; fails=1; fi
# A premise is what proves rev_cong: without it the lemma is false.
sed 's/^lemma rev_cong: "xs = ys \\<Longrightarrow> rev xs = rev ys"/lemma rev_cong: "rev xs = rev ys"/; s/^theory Lists/theory NoPrem/' absorbed/isabelle/Lists.thy >"$work/NoPrem.thy"
if cmp -s absorbed/isabelle/Lists.thy "$work/NoPrem.thy"; then echo "FAIL  the premise mutation did not apply"; fails=1; fi
(cd "$work" && "$arlk" absorb-isabelle NoPrem.thy -o NoPrem.arlk >/dev/null)
if "$arlk" qed lib/std/eq.arlk lib/isabelle_main.arlk "$work/NoPrem.arlk" >"$work/noprem.log" 2>&1; then echo "FAIL  rev_cong was proved without its premise"; fails=1; elif grep -q "simp could not prove it" "$work/noprem.log"; then echo "pass  rev_cong needs its premise"; else echo "FAIL  rev_cong without its premise failed for another reason"; tail -2 "$work/noprem.log"; fails=1; fi
# A wrong step in an Isar chain (`... = rev xs` where it is `rev (rev xs)`)
# is a false lemma of its own, so the chain is not proved.
sed 's/^  also have "... = rev (rev xs)" by simp/  also have "... = rev xs" by simp/; s/^theory Lists/theory BadStep/' absorbed/isabelle/Lists.thy >"$work/BadStep.thy"
if cmp -s absorbed/isabelle/Lists.thy "$work/BadStep.thy"; then echo "FAIL  the Isar step mutation did not apply"; fails=1; fi
(cd "$work" && "$arlk" absorb-isabelle BadStep.thy -o BadStep.arlk >/dev/null)
if "$arlk" qed lib/std/eq.arlk lib/isabelle_main.arlk "$work/BadStep.arlk" >"$work/badstep.log" 2>&1; then echo "FAIL  a wrong Isar step was accepted"; fails=1; elif grep -q "simp could not prove it" "$work/badstep.log"; then echo "pass  a wrong Isar step is rejected"; else echo "FAIL  a wrong Isar step failed for another reason"; tail -3 "$work/badstep.log"; fails=1; fi
# The transport: Isabelle's add_comm proves nat.add_comm, with nothing assumed.
if "$arlk" qed lib/std/eq.arlk lib/std/nat.arlk lib/isabelle_main.arlk absorbed/isabelle/arith.arlk examples/isabelle_transport.arlk >"$work/tr.log" 2>&1 && grep -q "symbols: (none)" "$work/tr.log"; then echo "pass  transport from Isabelle, no symbols"; else echo "FAIL  transport from Isabelle (see $work/tr.log)"; fails=1; fi
exit $fails
