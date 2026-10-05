#!/usr/bin/env bash
# Packages (#20), each case in a fresh process, offline (no Lean, Rocq or
# OpenTheory executable is used):
#   - two projects consume the same native library and the same checked
#     cross-logic view, each proving a new theorem, from an unrelated
#     working directory, with the same output every time;
#   - a diamond is loaded once; a missing package, a cycle, two packages
#     with one name, a room declared twice, a room used but not exported,
#     and a wrong version each fail with their own exit status;
#   - a claim resting on assumptions the project does not allow is
#     refused, also after a dependency update;
#   - the result travels as a bundle bound to its packages and replays;
#   - tampering with a source, an exported view, a pinned hash, or a
#     declared assumption list is caught; paths stay inside their root;
#     manifests cannot carry anything but data.
#
#   tools/package-check.sh ARLK WORKDIR
set -uo pipefail
arlk="$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
rm -rf "$2"; mkdir -p "$2"; work="$(cd "$2" && pwd)"
cd "$(dirname "$0")/.."
repo="$(pwd)"
fails=0
expect() { # name status cmd...
  local name="$1" want="$2"; shift 2
  (cd / && "$@") >"$work/$name.log" 2>&1
  local got=$?
  if [ "$got" = "$want" ]; then echo "pass  $name (exit $got)"; else echo "FAIL  $name: exit $got, wanted $want (see $work/$name.log)"; fails=1; fi
}
contains() { # name text file
  if grep -qF -- "$2" "$3"; then echo "pass  $1"; else echo "FAIL  $1: '$2' not in $3"; fails=1; fi
}
sha() { shasum -a 256 "$1" | cut -d' ' -f1; }

# The shipped packages verify, and the two projects check.
expect std-verifies 0 "$arlk" package verify "$repo/packages/std.arlkpkg"
expect views-verifies 0 "$arlk" package verify "$repo/packages/views-abc.arlkpkg"
expect client-a 0 "$arlk" project "$repo/examples/projects/client-a"
expect client-b 0 "$arlk" project "$repo/examples/projects/client-b"
contains client-a-new-theorem "axioms client_a.keep_comm" "$work/client-a.log"
contains client-b-new-theorem "axioms client_b.agree_snoc" "$work/client-b.log"
contains client-a-uses-the-view "c.ac.a.k" "$work/client-a.log"
contains client-b-uses-the-view-claim "c.agree" "$work/client-b.log"
contains route-is-shown "via: b.ab, c.bc" "$work/client-a.log"
expect client-a-again 0 "$arlk" project "$repo/examples/projects/client-a"
if cmp -s "$work/client-a.log" "$work/client-a-again.log"; then echo "pass  deterministic output"; else echo "FAIL  output differs between runs"; fails=1; fi

# Scratch packages over copies of the shipped ones.
P="$work/pk"; mkdir -p "$P/src"
cp packages/std.arlkpkg packages/views-abc.arlkpkg "$P/"
sed -i.bak 's|^root: \.\./lib$|root: '"$repo"'/lib|' "$P/std.arlkpkg"
sed -i.bak 's|^root: \.\.$|root: '"$repo"'|' "$P/views-abc.arlkpkg"
STD=$(sha "$P/std.arlkpkg"); V=$(sha "$P/views-abc.arlkpkg")
project() { # dir requires-lines... (then source/claim lines appended by caller)
  local d="$1"; shift; mkdir -p "$d"
  { echo "arlk-project: 1"; echo "name: $(basename "$d")"; for r in "$@"; do echo "$r"; done; } >"$d/arlk-project.txt"
}

# A diamond: left and right both require std; std is loaded once.
for side in left right; do
  printf 'room %s uses nat, eq\ntheorem %s_comm(m: Nat, n: Nat) -> Eq(Nat, add(m, n), add(n, m)) = add_comm(m, n)\n' "$side" "$side" >"$P/src/$side.arlk"
  printf 'arlk-package: 1\nname: %s\nversion: 1.0.0\nsemantics: arlk-kernel-1\nroot: src\nrequires: std 1.0.0 %s std.arlkpkg\nsource: - %s.arlk\nexport-room: %s\nexport-claim: %s.%s_comm -\n' "$side" "$STD" "$side" "$side" "$side" "$side" >"$P/$side.arlkpkg"
  expect "pin-$side" 0 "$arlk" package pin "$P/$side.arlkpkg"
done
project "$work/diamond" "requires: left 1.0.0 $(sha "$P/left.arlkpkg") $P/left.arlkpkg" "requires: right 1.0.0 $(sha "$P/right.arlkpkg") $P/right.arlkpkg" "requires: std 1.0.0 $STD $P/std.arlkpkg"
printf 'room both uses left, right, nat, eq\ntheorem same(m: Nat, n: Nat) -> Eq(Nat, add(m, n), add(n, m)) = trans(left.left_comm(m, n), trans(right.right_comm(n, m), left.left_comm(m, n)))\n' >"$work/diamond/main.arlk"
printf 'source: main.arlk\nclaim: both.same\n' >>"$work/diamond/arlk-project.txt"
expect diamond 0 "$arlk" project "$work/diamond"
n=$(grep -c '^✓ package std ' "$work/diamond.log"); if [ "$n" = 1 ]; then echo "pass  diamond loads std once"; else echo "FAIL  diamond loads std $n times"; fails=1; fi

# Missing, wrong version, cycle.
project "$work/missing" "requires: std 1.0.0 $STD $P/nothing-here.arlkpkg"; echo "source: main.arlk" >>"$work/missing/arlk-project.txt"; echo "room m" >"$work/missing/main.arlk"
expect missing-package 6 "$arlk" project "$work/missing"
project "$work/version" "requires: std 2.0.0 $STD $P/std.arlkpkg"; echo "room m" >"$work/version/main.arlk"
expect wrong-version 5 "$arlk" project "$work/version"
printf 'arlk-package: 1\nname: ping\nversion: 1\nsemantics: arlk-kernel-1\nrequires: pong 1 0000 pong.arlkpkg\n' >"$P/ping.arlkpkg"
printf 'arlk-package: 1\nname: pong\nversion: 1\nsemantics: arlk-kernel-1\nrequires: ping 1 %s ping.arlkpkg\n' "$(sha "$P/ping.arlkpkg")" >"$P/pong.arlkpkg"
printf 'arlk-package: 1\nname: ping\nversion: 1\nsemantics: arlk-kernel-1\nrequires: pong 1 %s pong.arlkpkg\n' "$(sha "$P/pong.arlkpkg")" >"$P/ping2.arlkpkg"
project "$work/cycle" "requires: ping 1 $(sha "$P/ping2.arlkpkg") $P/ping2.arlkpkg"
expect cycle 8 "$arlk" project "$work/cycle"
contains cycle-named "ping -> pong -> ping" "$work/cycle.log"

# Two packages named std with different content.
sed 's/^export-claim: eq.trans .*$/export-claim: eq.symm -/' "$P/std.arlkpkg" >"$P/std-other.arlkpkg"
expect pin-std-other 0 "$arlk" package pin "$P/std-other.arlkpkg"
sed "s|requires: std 1.0.0 $STD std.arlkpkg|requires: std 1.0.0 $(sha "$P/std-other.arlkpkg") std-other.arlkpkg|" "$P/right.arlkpkg" >"$P/right-other.arlkpkg"
project "$work/twostd" "requires: left 1.0.0 $(sha "$P/left.arlkpkg") $P/left.arlkpkg" "requires: right 1.0.0 $(sha "$P/right-other.arlkpkg") $P/right-other.arlkpkg"
expect same-name-different-content 9 "$arlk" project "$work/twostd"
contains same-name-named "two different packages are named std" "$work/same-name-different-content.log"

# A room declared by two packages.
printf 'room nat\ndef extra: Type = Type\n' >"$P/src/natagain.arlk"
printf 'arlk-package: 1\nname: natagain\nversion: 1\nsemantics: arlk-kernel-1\nroot: src\nsource: %s natagain.arlk\n' "$(sha "$P/src/natagain.arlk")" >"$P/natagain.arlkpkg"
project "$work/rooms" "requires: std 1.0.0 $STD $P/std.arlkpkg" "requires: natagain 1 $(sha "$P/natagain.arlkpkg") $P/natagain.arlkpkg"
expect room-declared-twice 9 "$arlk" project "$work/rooms"

# A room used but not exported (std's rooms are exported; views-abc's a is not).
project "$work/unexported" "requires: views-abc 1.0.0 $V $P/views-abc.arlkpkg"
printf 'room u uses a\n' >"$work/unexported/main.arlk"; echo "source: main.arlk" >>"$work/unexported/arlk-project.txt"
expect room-not-exported 9 "$arlk" project "$work/unexported"

# Assumptions: b.ab.a.k rests on b's symbols. Refused unless b is allowed.
mkdir -p "$work/assume"
printf 'room v uses c\ntheorem kk(p: Sort(0), q: Sort(0)) -> p -> q -> p = c.agree2(p, q)\n' >"$work/assume/main.arlk"
project "$work/assume" "requires: views-abc 1.0.0 $V $P/views-abc.arlkpkg"
printf 'source: main.arlk\nclaim: v.kk\n' >>"$work/assume/arlk-project.txt"
expect allowed-by-default 0 "$arlk" project "$work/assume"
# A package update whose claim now rests on b's symbols (a -> b only):
sed 's/^theorem agree2(p: Sort(0), q: Sort(0)) -> p -> q -> p = bc.b.ab.a.k(p, q)$/theorem agree2(p: Sort(0), q: Sort(0)) -> p -> q -> p = bc.b.ab.a.k(p, q)\nroom c2 uses b\ntheorem agree3(p: b.Form, q: b.Form) -> b.Holds(b.arrow(p, b.arrow(q, p))) = b.ab.a.k(p, q)/' "$repo/examples/views.arlk" >"$P/src/views2.arlk"
printf 'arlk-package: 1\nname: views-abc\nversion: 1.1.0\nsemantics: arlk-kernel-1\nroot: src\nsource: - views2.arlk\nexport-room: b\nexport-room: c\nexport-room: c2\nexport-claim: c2.agree3 -\n' >"$P/views2.arlkpkg"
expect pin-views-update 0 "$arlk" package pin "$P/views2.arlkpkg"
contains update-declares-b "assumes: c2.agree3 b " "$P/views2.arlkpkg"
mkdir -p "$work/update"
printf 'room v uses c2, b\ntheorem kk(p: b.Form, q: b.Form) -> b.Holds(b.arrow(p, b.arrow(q, p))) = c2.agree3(p, q)\n' >"$work/update/main.arlk"
project "$work/update" "requires: views-abc 1.1.0 $(sha "$P/views2.arlkpkg") $P/views2.arlkpkg"
printf 'source: main.arlk\nclaim: v.kk\n' >>"$work/update/arlk-project.txt"
expect update-exceeds-allowed 10 "$arlk" project "$work/update"
echo "allow-room: b" >>"$work/update/arlk-project.txt"
expect update-allowed-explicitly 0 "$arlk" project "$work/update"

# The result as a bundle, bound to its packages, replayed from the bundle.
expect bundle 0 "$arlk" project "$repo/examples/projects/client-a" --bundle "$work/bundle-a"
contains bundle-records-packages "package: std 1.0.0" "$work/bundle-a/manifest.txt"
contains bundle-records-project "project: client-a" "$work/bundle-a/manifest.txt"
expect replay 0 "$arlk" replay "$work/bundle-a"
contains replay-verifies-packages "package: views-abc 1.0.0" "$work/replay.log"
prov=$(sed -n 's/^provenance-id: //p' "$work/bundle-a/manifest.txt")
expect replay-expect-provenance 0 "$arlk" replay "$work/bundle-a" --expect "$prov"
cp -R "$work/bundle-a" "$work/bundle-forged"; sed -i.bak 's/^package: std 1.0.0 /package: std 9.9.9 /' "$work/bundle-forged/manifest.txt"
expect forged-provenance 4 "$arlk" replay "$work/bundle-forged"
cp -R "$work/bundle-a" "$work/bundle-pkg"; echo "# edited" >>"$work/bundle-pkg/pkg/std.arlkpkg"
expect tampered-bundled-package 3 "$arlk" replay "$work/bundle-pkg"

# Tampering.
T="$work/tamper"; mkdir -p "$T/src"
cp "$repo/examples/views.arlk" "$T/src/views.arlk"
printf 'arlk-package: 1\nname: views-abc\nversion: 1.0.0\nsemantics: arlk-kernel-1\nroot: src\nsource: - views.arlk\nexport-room: c\nexport-view: c.ac -\nexport-claim: c.agree -\n' >"$T/v.arlkpkg"
expect pin-tamper-base 0 "$arlk" package pin "$T/v.arlkpkg"
# A source edited after pinning.
cp "$T/src/views.arlk" "$T/src/views.orig"; echo "// edited" >>"$T/src/views.arlk"
expect tampered-source 3 "$arlk" package verify "$T/v.arlkpkg"
cp "$T/src/views.orig" "$T/src/views.arlk"
# An exported view's image changed, with the source hash updated as a forger would.
sed -i.bak 's/^  Holds = (p: Sort(0)) => p,$/  Holds = (p: Sort(0)) => ((x: Sort(0)) => x)(p),/' "$T/src/views.arlk"
sed "s|^source: [0-9a-f]* views.arlk|source: $(sha "$T/src/views.arlk") views.arlk|" "$T/v.arlkpkg" >"$T/v-image.arlkpkg"
expect tampered-view-image-or-claim 4 "$arlk" package verify "$T/v-image.arlkpkg"
cp "$T/src/views.orig" "$T/src/views.arlk"
# A declared assumption list edited.
sed 's/^assumes: c.agree (none) /assumes: c.agree b /' "$T/v.arlkpkg" >"$T/v-assumes.arlkpkg"
expect tampered-assumptions 4 "$arlk" package verify "$T/v-assumes.arlkpkg"
# A dependency pinned by a hash its manifest does not have.
project "$work/badpin" "requires: std 1.0.0 0000000000000000000000000000000000000000000000000000000000000000 $P/std.arlkpkg"
expect tampered-dependency-hash 3 "$arlk" project "$work/badpin"
# A source outside the package root.
printf 'arlk-package: 1\nname: escape\nversion: 1\nsemantics: arlk-kernel-1\nroot: src\nsource: - ../../../etc/hosts\n' >"$T/escape.arlkpkg"
expect path-outside-root 3 "$arlk" package pin "$T/escape.arlkpkg"
# A manifest is data: anything but the documented keys is refused.
printf 'arlk-package: 1\nname: x\nversion: 1\nsemantics: arlk-kernel-1\nrun: rm -rf /\n' >"$T/code.arlkpkg"
expect manifest-is-data 5 "$arlk" package verify "$T/code.arlkpkg"

exit $fails
