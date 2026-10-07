#!/usr/bin/env bash
# Agda's side of the absorption: confirm that Agda accepts each module in
# absorbed/agda (when Agda is installed), then that `arlk absorb-agda`
# still writes the committed translation and the kernel accepts it.
#
#   tools/agda-export/check.sh ARLK [AGDA]
#
# Agda is optional: without it, only the Arlk side is checked. Nothing in
# Agda is trusted either way; the translation is checked by the kernel.
set -uo pipefail
arlk="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
agda="${2:-$(command -v agda || true)}"
cd "$(dirname "$0")/../.."
work="$(mktemp -d)"
fails=0
for src in absorbed/agda/*.agda; do
  name="$(basename "$src" .agda)"
  out="absorbed/agda/$(echo "$name" | tr '[:upper:]' '[:lower:]').arlk"
  if [ -n "$agda" ]; then
    if (cd absorbed/agda && "$agda" "$(basename "$src")" >"$work/$name.agda.log" 2>&1); then echo "pass  agda accepts $src"; else echo "FAIL  agda rejects $src (see $work/$name.agda.log)"; fails=1; fi
    rm -rf absorbed/agda/_build absorbed/agda/*.agdai
  else
    echo "skip  agda not installed: $src not run through Agda"
  fi
  (cd absorbed/agda && "$arlk" absorb-agda "$(basename "$src")" -o "$work/$name.arlk" >/dev/null) || { echo "FAIL  absorb-agda $src"; fails=1; continue; }
  if cmp -s "$work/$name.arlk" "$out"; then echo "pass  $out is what absorb-agda writes"; else echo "FAIL  $out differs from absorb-agda's output"; diff "$out" "$work/$name.arlk" | head -20; fails=1; fi
  if "$arlk" qed "$out" >"$work/$name.check.log" 2>&1; then echo "pass  kernel accepts $out ($(tail -1 "$work/$name.check.log" | sed -E 's/.*\(([0-9]+) declarations\)/\1/') declarations)"; else echo "FAIL  kernel rejects $out"; tail -3 "$work/$name.check.log"; fails=1; fi
done
# A wrong proof in the Agda source is rejected after absorption.
sed 's/^+-assoc (suc a) b c = cong suc (+-assoc a b c)/+-assoc (suc a) b c = cong suc (+-comm a b)/' absorbed/agda/Arith.agda >"$work/Bad.agda"
sed -i.bak 's/^module Arith/module Bad/' "$work/Bad.agda"
(cd "$work" && "$arlk" absorb-agda Bad.agda -o Bad.arlk >/dev/null)
if "$arlk" qed "$work/Bad.arlk" >"$work/bad.log" 2>&1; then echo "FAIL  a wrong Agda proof was accepted"; fails=1; elif grep -q "type mismatch" "$work/bad.log"; then echo "pass  a wrong Agda proof is rejected"; else echo "FAIL  a wrong Agda proof is rejected for another reason"; fails=1; fi
# An absurd pattern where the case is possible: `≤-pred ()` claims no
# constructor fits `suc m ≤ suc n`, but s≤s does; the kernel side refuses.
sed 's/^≤-pred (s≤s p) = p/≤-pred ()/; s/^module Order/module BadOrder/' absorbed/agda/Order.agda >"$work/BadOrder.agda"
if (cd "$work" && "$arlk" absorb-agda BadOrder.agda -o BadOrder.arlk >/dev/null) && "$arlk" qed "$work/BadOrder.arlk" >"$work/badorder.log" 2>&1; then echo "FAIL  a wrong absurd pattern was accepted"; fails=1; elif grep -q "no arm for" "$work/badorder.log"; then echo "pass  a wrong absurd pattern is rejected"; else echo "FAIL  a wrong absurd pattern failed for another reason"; tail -2 "$work/badorder.log"; fails=1; fi
# A wrong `with` arm: filter keeps nothing, so evens-ok is false.
sed 's/^\.\.\. | true  = x ∷ filter p xs/... | true  = filter p xs/; s/^module Records/module BadWith/' absorbed/agda/Records.agda >"$work/BadWith.agda"
if cmp -s absorbed/agda/Records.agda "$work/BadWith.agda"; then echo "FAIL  the with mutation did not apply"; fails=1; fi
if (cd "$work" && "$arlk" absorb-agda BadWith.agda -o BadWith.arlk >/dev/null) && "$arlk" qed "$work/BadWith.arlk" >"$work/badwith.log" 2>&1; then echo "FAIL  a wrong with arm was accepted"; fails=1; elif grep -q "BadWith.arlk:$(grep -n '^def evens_ok' "$work/BadWith.arlk" | cut -d: -f1): type mismatch" "$work/badwith.log"; then echo "pass  a wrong with arm is rejected (evens-ok)"; else echo "FAIL  a wrong with arm failed for another reason"; tail -2 "$work/badwith.log"; fails=1; fi
# Corecursion that steps wrongly: from n no longer counts up, so third is false.
sed 's/^tail (from n) = from (suc n)/tail (from n) = from n/; s/^module Streams/module BadStreams/' absorbed/agda/Streams.agda >"$work/BadStreams.agda"
if cmp -s absorbed/agda/Streams.agda "$work/BadStreams.agda"; then echo "FAIL  the Streams mutation did not apply"; fails=1; fi
if (cd "$work" && "$arlk" absorb-agda BadStreams.agda -o BadStreams.arlk >/dev/null) && "$arlk" qed "$work/BadStreams.arlk" >"$work/badstreams.log" 2>&1; then echo "FAIL  a wrong corecursive step was accepted"; fails=1; elif grep -q "BadStreams.arlk:$(grep -n '^def third' "$work/BadStreams.arlk" | cut -d: -f1): type mismatch" "$work/badstreams.log"; then echo "pass  a wrong corecursive step is rejected (third)"; else echo "FAIL  a wrong corecursive step failed for another reason"; tail -2 "$work/badstreams.log"; fails=1; fi
# A rewrite that leaves the goal unproved: without +-suc, m + suc n is not suc (m + n).
sed 's/^+-comm (suc m) n rewrite +-comm m n | +-suc n m = refl/+-comm (suc m) n rewrite +-comm m n = refl/; s/^module Rewriting/module BadRewrite/' absorbed/agda/Rewriting.agda >"$work/BadRewrite.agda"
if cmp -s absorbed/agda/Rewriting.agda "$work/BadRewrite.agda"; then echo "FAIL  the rewrite mutation did not apply"; fails=1; fi
if (cd "$work" && "$arlk" absorb-agda BadRewrite.agda -o BadRewrite.arlk >/dev/null) && "$arlk" qed "$work/BadRewrite.arlk" >"$work/badrewrite.log" 2>&1; then echo "FAIL  a rewrite that does not prove the goal was accepted"; fails=1; elif grep -q "type mismatch" "$work/badrewrite.log"; then echo "pass  a rewrite that does not prove the goal is rejected"; else echo "FAIL  the wrong rewrite was rejected for another reason (see $work/badrewrite.log)"; fails=1; fi
# A helper in `where` that proves the wrong equation.
sed 's/^    lemma a b c = swap b a c/    lemma a b c = swap a b c/; s/^module Rewriting/module BadWhere/' absorbed/agda/Rewriting.agda >"$work/BadWhere.agda"
if cmp -s absorbed/agda/Rewriting.agda "$work/BadWhere.agda"; then echo "FAIL  the where mutation did not apply"; fails=1; fi
if (cd "$work" && "$arlk" absorb-agda BadWhere.agda -o BadWhere.arlk >/dev/null) && "$arlk" qed "$work/BadWhere.arlk" >"$work/badwhere.log" 2>&1; then echo "FAIL  a wrong where helper was accepted"; fails=1; elif grep -q "type mismatch" "$work/badwhere.log"; then echo "pass  a wrong where helper is rejected"; else echo "FAIL  the wrong where helper was rejected for another reason (see $work/badwhere.log)"; fails=1; fi
# `with … in eq` whose arm uses the wrong case's equation.
sed 's/^\.\.\. | true  = inj₁ (zero-of-true n eq)/... | true  = inj₂ eq/; s/^module Inspect/module BadInspect/' absorbed/agda/Inspect.agda >"$work/BadInspect.agda"
if cmp -s absorbed/agda/Inspect.agda "$work/BadInspect.agda"; then echo "FAIL  the inspect mutation did not apply"; fails=1; fi
if (cd "$work" && "$arlk" absorb-agda BadInspect.agda -o BadInspect.arlk >/dev/null) && "$arlk" qed "$work/BadInspect.arlk" >"$work/badinspect.log" 2>&1; then echo "FAIL  a wrong use of a with-in equation was accepted"; fails=1; elif grep -q "type mismatch" "$work/badinspect.log"; then echo "pass  a wrong use of a with-in equation is rejected"; else echo "FAIL  the wrong with-in use was rejected for another reason (see $work/badinspect.log)"; fails=1; fi
# The transport: Agda's +-comm proves nat.add_comm, with nothing assumed.
if "$arlk" qed absorbed/agda/arith.arlk lib/std/eq.arlk lib/std/nat.arlk examples/agda_transport.arlk >"$work/tr.log" 2>&1 && grep -q "symbols: (none)" "$work/tr.log"; then echo "pass  transport from Agda, no symbols"; else echo "FAIL  transport from Agda (see $work/tr.log)"; fails=1; fi
exit $fails
