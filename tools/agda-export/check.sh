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
  if "$arlk" check "$out" >"$work/$name.check.log" 2>&1; then echo "pass  kernel accepts $out ($(tail -1 "$work/$name.check.log" | sed -E 's/.*\(([0-9]+) declarations\)/\1/') declarations)"; else echo "FAIL  kernel rejects $out"; tail -3 "$work/$name.check.log"; fails=1; fi
done
# A wrong proof in the Agda source is rejected after absorption.
sed 's/^+-assoc (suc a) b c = cong suc (+-assoc a b c)/+-assoc (suc a) b c = cong suc (+-comm a b)/' absorbed/agda/Arith.agda >"$work/Bad.agda"
sed -i.bak 's/^module Arith/module Bad/' "$work/Bad.agda"
(cd "$work" && "$arlk" absorb-agda Bad.agda -o Bad.arlk >/dev/null)
if "$arlk" check "$work/Bad.arlk" >"$work/bad.log" 2>&1; then echo "FAIL  a wrong Agda proof was accepted"; fails=1; elif grep -q "type mismatch" "$work/bad.log"; then echo "pass  a wrong Agda proof is rejected"; else echo "FAIL  a wrong Agda proof is rejected for another reason"; fails=1; fi
# The transport: Agda's +-comm proves nat.add_comm, with nothing assumed.
if "$arlk" check absorbed/agda/arith.arlk lib/std/eq.arlk lib/std/nat.arlk examples/agda_transport.arlk >"$work/tr.log" 2>&1 && grep -q "symbols: (none)" "$work/tr.log"; then echo "pass  transport from Agda, no symbols"; else echo "FAIL  transport from Agda (see $work/tr.log)"; fails=1; fi
exit $fails
