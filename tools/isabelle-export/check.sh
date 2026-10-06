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
for src in absorbed/isabelle/*.thy; do
  name="$(basename "$src" .thy)"
  out="absorbed/isabelle/$(echo "$name" | tr '[:upper:]' '[:lower:]').arlk"
  (cd absorbed/isabelle && "$arlk" absorb-isabelle "$(basename "$src")" -o "$work/$name.arlk" >/dev/null) || { echo "FAIL  absorb-isabelle $src"; fails=1; continue; }
  if cmp -s "$work/$name.arlk" "$out"; then echo "pass  $out is what absorb-isabelle writes"; else echo "FAIL  $out differs from absorb-isabelle's output"; diff "$out" "$work/$name.arlk" | head -20; fails=1; fi
  if "$arlk" check lib/std/eq.arlk "$out" >"$work/$name.check.log" 2>&1; then echo "pass  kernel accepts $out ($(tail -1 "$work/$name.check.log" | sed -E 's/.*\(([0-9]+) declarations\)/\1/') declarations)"; else echo "FAIL  kernel rejects $out"; tail -3 "$work/$name.check.log"; fails=1; fi
done
# A false lemma cannot be proved by replaying its proof method.
sed 's/^lemma rev_rev: "rev (rev xs) = xs"/lemma rev_rev: "rev (rev xs) = rev xs"/' absorbed/isabelle/Arith.thy >"$work/Bad.thy"
sed -i.bak 's/^theory Arith/theory Bad/' "$work/Bad.thy"
(cd "$work" && "$arlk" absorb-isabelle Bad.thy -o Bad.arlk >/dev/null)
if "$arlk" check lib/std/eq.arlk "$work/Bad.arlk" >"$work/bad.log" 2>&1; then echo "FAIL  a false lemma was accepted"; fails=1; elif grep -q "simp could not prove it" "$work/bad.log"; then echo "pass  a false lemma is rejected"; else echo "FAIL  a false lemma is rejected for another reason"; tail -3 "$work/bad.log"; fails=1; fi
# The transport: Isabelle's add_comm proves nat.add_comm, with nothing assumed.
if "$arlk" check lib/std/eq.arlk lib/std/nat.arlk absorbed/isabelle/arith.arlk examples/isabelle_transport.arlk >"$work/tr.log" 2>&1 && grep -q "symbols: (none)" "$work/tr.log"; then echo "pass  transport from Isabelle, no symbols"; else echo "FAIL  transport from Isabelle (see $work/tr.log)"; fails=1; fi
exit $fails
