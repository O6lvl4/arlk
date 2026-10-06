#!/bin/bash
# Every Almide test file, on each backend, counted rather than read off exit
# statuses (almide/almide#3449: `almide test --json` exits 0 on a failure).
#
#   native  every file runs natively (wasmtime hidden from PATH) and reports
#           `pass` for exactly as many tests as it has `test` blocks;
#   wasm    every file runs on WASM with all of its tests passing, except the
#           files listed in tools/toolchain/wasm-walls, which the compiler
#           still declines to lower; a listed file must still be declined, so
#           the list only shrinks.
#
# Usage: tools/toolchain-check.sh [LOGDIR]. Prints one line per file and
# backend, and exits non-zero on any failure, missing count or unexpected skip.
set -u
cd "$(dirname "$0")/.."
LOGS=${1:-ci-logs/toolchain}
mkdir -p "$LOGS"
ALMIDE=$(command -v almide) || { echo "almide not on PATH"; exit 1; }
WALLS=tools/toolchain/wasm-walls

# A PATH with almide and the Rust toolchain but no wasmtime.
NATIVE_BIN=$(mktemp -d)
trap 'rm -rf "$NATIVE_BIN"' EXIT
ln -s "$ALMIDE" "$NATIVE_BIN/almide"
NATIVE_PATH="$NATIVE_BIN:$(dirname "$(command -v cargo)"):/usr/bin:/bin"

bad=0
report() { # file backend outcome detail
  printf '%-26s %-6s %-5s %s\n' "$1" "$2" "$3" "$4"
  if [ "$3" != "ok" ] && [ "$3" != "wall" ]; then bad=1; fi
}

files="$(ls spec/*.almd) $(grep -l '^test ' src/*.almd)"
for f in $files; do
  want=$(grep -c '^test ' "$f")
  log="$LOGS/$(echo "$f" | tr / _)"

  # Native.
  env PATH="$NATIVE_PATH" almide test "$f" --json >"$log.native" 2>&1
  line=$(grep '^{"file"' "$log.native" | tail -1)
  status=$(echo "$line" | sed -n 's/.*"status":"\([a-z]*\)".*/\1/p')
  got=$(echo "$line" | sed -n 's/.*"tests":\([0-9]*\).*/\1/p')
  if [ "$status" = "pass" ] && [ "$got" = "$want" ]; then report "$f" native ok "$got/$want tests"
  else report "$f" native FAIL "status=${status:-none} tests=${got:-none}/$want (see $log.native)"; fi

  # WASM.
  ALMIDE_WALL_REASON=1 almide test "$f" --target wasm >"$log.wasm" 2>&1
  passed=$(sed -n "s#^$f: \([0-9]*\) tests* passed.*#\1#p" "$log.wasm" | tail -1)
  walled=$(grep -c "^WALL $f " "$log.wasm")
  listed=$(grep -v "^#" "$WALLS" | grep -cx "$f")
  if [ "$listed" = 1 ]; then
    if [ "$walled" -ge 1 ]; then report "$f" wasm wall "$(sed -n 's/^\[wall\] [^:]*: //p' "$log.wasm" | head -1)"
    elif [ "$passed" = "$want" ]; then report "$f" wasm LOWER "now runs on wasm ($passed/$want): remove it from $WALLS"
    else report "$f" wasm FAIL "listed as walled, but neither walled nor passed (see $log.wasm)"; fi
  elif [ "$passed" = "$want" ] && grep -q '^1 passed, 0 failed' "$log.wasm"; then report "$f" wasm ok "$passed/$want tests"
  else report "$f" wasm FAIL "passed=${passed:-none}/$want walled=$walled (see $log.wasm)"; fi
done

exit $bad
