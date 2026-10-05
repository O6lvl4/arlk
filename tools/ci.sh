#!/usr/bin/env bash
# Everything CI checks, runnable locally: build, tests, native examples,
# absorbed libraries (Lean, Rocq, Metamath; no prover is run), the known
# Rocq Init baseline, and inputs that must be rejected for a stated reason.
#
#   tools/ci.sh            # logs go to ci-logs/, a summary is printed
#
# A stage passes only for the intended outcome: a rejection fixture that is
# accepted, crashes, times out or fails for another reason is a failure.
set -uo pipefail
cd "$(dirname "$0")/.."
LOGS="${LOG_DIR:-ci-logs}"
mkdir -p "$LOGS"
results=()
failed=0

# `timeout` where there is one (Linux), perl's alarm otherwise (macOS).
limit() {
  local secs="$1"; shift
  if command -v timeout >/dev/null 2>&1; then timeout "$secs" "$@"
  else perl -e 'alarm shift; exec @ARGV or die' "$secs" "$@"; fi
}

record() { # name status detail
  results+=("$(printf '%-8s %-44s %s' "$2" "$1" "$3")")
  if [ "$2" != "pass" ]; then failed=1; fi
}

# A command that must succeed (exit 0) within the time limit.
must_pass() { # name secs cmd...
  local name="$1" secs="$2"; shift 2
  local log="$LOGS/${name//[^A-Za-z0-9_.-]/_}.log"
  limit "$secs" "$@" >"$log" 2>&1
  local code=$?
  case "$code" in
    0) record "$name" pass "$(tail -1 "$log" | cut -c1-80)" ;;
    124|142) record "$name" TIMEOUT "after ${secs}s, see $log" ;;
    *) record "$name" FAIL "exit $code, see $log" ;;
  esac
}

# A command that must fail (exit 1) with `want` in its output.
must_reject() { # name secs want cmd...
  local name="$1" secs="$2" want="$3"; shift 3
  local log="$LOGS/${name//[^A-Za-z0-9_.-]/_}.log"
  limit "$secs" "$@" >"$log" 2>&1
  local code=$?
  if [ "$code" = 1 ] && grep -qF -- "$want" "$log"; then record "$name" pass "rejected: $want"
  elif [ "$code" = 0 ]; then record "$name" FAIL "accepted, but must be rejected ($want)"
  elif [ "$code" = 124 ] || [ "$code" = 142 ]; then record "$name" TIMEOUT "after ${secs}s, see $log"
  elif [ "$code" = 1 ]; then record "$name" FAIL "rejected for another reason, see $log"
  else record "$name" CRASH "exit $code, see $log"; fi
}

{
  echo "revision: $(git rev-parse HEAD 2>/dev/null || echo unknown)"
  echo "almide:   $(almide --version)"
  echo "rustc:    $(rustc --version 2>/dev/null || echo none)"
  echo "os:       $(uname -sm)"
} | tee "$LOGS/versions.txt"

must_pass build 1200 almide build src/main.almd -o arlk
if [ ! -x ./arlk ]; then
  printf '%s\n' "${results[@]}"; echo "build failed"; exit 1
fi

must_pass "almide test (spec)" 3600 almide test
must_pass "almide test src/" 1800 almide test src/

for f in examples/logic.arlk examples/nat.arlk examples/data.arlk; do
  must_pass "example $f" 300 ./arlk check "$f"
done

must_pass "Lean Nat.add_zero" 300 ./arlk check lib/core.arlk absorbed/lean/nat_add_zero.arlk
must_pass "Rocq Init.Peano" 300 ./arlk check lib/core.arlk absorbed/rocq/init_peano.arlk
must_pass "Lean Nat.Basic + Rocq + bridge" 1200 ./arlk check lib/core.arlk absorbed/lean/init_data_nat_basic.arlk absorbed/rocq/init_peano.arlk examples/bridge.arlk
must_pass "Metamath set.mm propositional" 300 ./arlk check absorbed/metamath/set_prop.arlk

# Rocq's Corelib.Init is not fully supported: exactly the four known
# declarations fail (sig/sigT at Prop, see the README). Anything else is a
# regression, including a declaration that starts to pass unannounced.
log="$LOGS/rocq-init.log"
limit 1800 ./arlk check lib/core.arlk absorbed/rocq/init.arlk --keep-going >"$log" 2>&1
grep '^✗' "$log" | sed -E 's/^✗ ([^:]+:[0-9]+): ([^(]*).*/\1: \2/' | sed -E 's/ +$//' >"$LOGS/rocq-init.failures"
if diff -u absorbed/rocq/init.expected-failures "$LOGS/rocq-init.failures" >"$LOGS/rocq-init.diff" && grep -q '^4 failed, 969 declarations checked' "$log"; then
  record "Rocq Corelib.Init (known baseline)" pass "4 known failures, 969 checked"
else
  record "Rocq Corelib.Init (known baseline)" FAIL "differs from the baseline, see $LOGS/rocq-init.diff"
fi

for f in spec/fixtures/reject/*.arlk; do
  want="$(sed -nE 's|^// expect: (.*)$|\1|p' "$f" | head -1)"
  must_reject "reject $(basename "$f")" 120 "$want" ./arlk check "$f"
done
must_reject "reject negative-numeral.json" 60 "negative" ./arlk absorb spec/fixtures/reject/negative-numeral.json

echo
printf '%s\n' "${results[@]}" | tee "$LOGS/summary.txt"
if [ "$failed" = 0 ]; then echo "all stages passed"; else echo "some stages failed"; fi
exit "$failed"
