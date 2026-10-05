#!/usr/bin/env bash
# Proof bundles (#15): bundle two checked results, replay them from the
# bundle alone, and make sure every kind of tampering is caught, each with
# its own exit status.
#
#   tools/bundle-check.sh ARLK WORKDIR
set -uo pipefail
arlk="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"; work="$2"
cd "$(dirname "$0")/.."
rm -rf "$work"; mkdir -p "$work"
fails=0
expect() { # name status cmd...
  local name="$1" want="$2"; shift 2
  "$@" >"$work/$name.log" 2>&1
  local got=$?
  if [ "$got" = "$want" ]; then echo "pass  $name (exit $got)"; else echo "FAIL  $name: exit $got, wanted $want (see $work/$name.log)"; fails=1; fi
}
copy() { rm -rf "$work/$2"; cp -R "$work/$1" "$work/$2"; }
# Replace a line's statement and re-hash the source, as a forger would.
rehash() { # bundle file
  local h; h=$(shasum -a 256 "$work/$1/$2" | cut -d' ' -f1)
  perl -i -pe "s|^source: \\S+ \\Q$2\\E |source: $h $2 |" "$work/$1/manifest.txt"
}

expect bundle-transport 0 "$arlk" bundle transport.rocq_add_comm lib/core.arlk absorbed/lean/init_data_nat_basic.arlk absorbed/rocq/init_peano.arlk examples/transport.arlk -o "$work/transport"
expect bundle-view 0 "$arlk" bundle c.agree examples/views.arlk -o "$work/view"
id=$(sed -n 's/^claim-id: //p' "$work/view/manifest.txt")

# Replayed from a clean directory, from the bundle alone.
expect replay-transport 0 sh -c "cd / && '$arlk' replay '$work/transport'"
expect replay-view 0 sh -c "cd / && '$arlk' replay '$work/view' --expect $id"
expect wrong-expected-id 4 "$arlk" replay "$work/view" --expect 0000

copy view edited; perl -i -pe 's/\(x: Prf\(p\), y: Prf\(q\)\) => x/(x: Prf(p), y: Prf(q)) => y/' "$work/edited/src/0-views.arlk"
expect tampered-source 3 "$arlk" replay "$work/edited"
rehash edited src/0-views.arlk
expect forged-proof-rehashed 1 "$arlk" replay "$work/edited"

copy view goal; perl -i -pe 's/^theorem agree\(p: Sort\(0\), q: Sort\(0\)\) -> p -> q -> p = ac.a.k\(p, q\)/theorem agree(p: Sort(0), q: Sort(0)) -> p -> p = (x: p) => x/' "$work/goal/src/0-views.arlk"
rehash goal src/0-views.arlk
expect changed-claim-rehashed 4 "$arlk" replay "$work/goal"

copy view image; perl -i -pe 's/^  Holds = \(p: Sort\(0\)\) => p,/  Holds = (p: Sort(0)) => p -> p,/' "$work/image/src/0-views.arlk"
rehash image src/0-views.arlk
expect changed-view-image 1 "$arlk" replay "$work/image"

copy view inventory; perl -i -pe 's/^assumes:   rooms:.*/assumes:   rooms:   nothing/' "$work/inventory/manifest.txt"
expect edited-assumptions 4 "$arlk" replay "$work/inventory"

copy view dep; perl -i -pe 's/^dep: [0-9a-f]+ c.ac.a.k$/dep: 0000 c.ac.a.k/' "$work/dep/manifest.txt"
expect edited-dependency 4 "$arlk" replay "$work/dep"

copy view missing; rm "$work/missing/src/0-views.arlk"
expect missing-source 6 "$arlk" replay "$work/missing"

copy view escape; perl -i -pe 's| src/0-views.arlk | src/../../etc.arlk |' "$work/escape/manifest.txt"
expect path-outside-bundle 3 "$arlk" replay "$work/escape"

copy view script; perl -i -pe 's| src/0-views.arlk | src/run.sh |' "$work/script/manifest.txt"
expect non-source-payload 3 "$arlk" replay "$work/script"

copy view version; perl -i -pe 's/^semantics: .*/semantics: arlk-kernel-0/' "$work/version/manifest.txt"
expect other-semantics 5 "$arlk" replay "$work/version"
expect other-semantics-revalidated 0 "$arlk" replay "$work/version" --revalidate

copy view format; perl -i -pe 's/^arlk-bundle: 1/arlk-bundle: 99/' "$work/format/manifest.txt"
expect unsupported-format 5 "$arlk" replay "$work/format"

copy view loop; printf '\nroom loopy\nsymbol A: Type\nsymbol a: A\nsymbol f(x: A) -> A\nrule f(x) = f(f(x))  where x: A\neval f(a)\n' >>"$work/loop/src/0-views.arlk"
rehash loop src/0-views.arlk
expect out-of-budget 7 "$arlk" replay "$work/loop"

exit $fails
