#!/usr/bin/env bash
# Everything CI checks, runnable locally: build, tests, native examples,
# absorbed libraries (Lean, Rocq, Metamath, HOL via OpenTheory; no prover is
# run), the known
# Rocq Init baseline, and inputs that must be rejected for a stated reason.
#
#   tools/ci.sh            # logs go to ci-logs/, a summary is printed
#
# A stage passes only for the intended outcome: a rejection fixture that is
# accepted, crashes, times out or fails for another reason is a failure.
set -uo pipefail
cd "$(dirname "$0")/.."
ROOT="$(pwd)"
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
  echo "wasmtime: $(wasmtime --version 2>/dev/null || echo none)"
  echo "os:       $(uname -sm)"
} | tee "$LOGS/versions.txt"

must_pass build 1200 almide build src/main.almd -o arlk
if [ ! -x ./arlk ]; then
  printf '%s\n' "${results[@]}"; echo "build failed"; exit 1
fi

must_pass "almide test (spec)" 3600 almide test
must_pass "almide test src/" 1800 almide test src/

for f in examples/logic.arlk examples/nat.arlk examples/data.arlk examples/mutual.arlk examples/nested.arlk; do
  must_pass "example $f" 300 ./arlk check "$f"
done

must_pass "Lean Nat.add_zero" 300 ./arlk check lib/core.arlk absorbed/lean/nat_add_zero.arlk
must_pass "Rocq Init.Peano" 300 ./arlk check lib/core.arlk absorbed/rocq/init_peano.arlk
must_pass "Lean Nat.Basic + Rocq + bridge" 1200 ./arlk check lib/core.arlk absorbed/lean/init_data_nat_basic.arlk absorbed/rocq/init_peano.arlk examples/bridge.arlk
must_pass "Metamath set.mm propositional" 300 ./arlk check absorbed/metamath/set_prop.arlk
must_pass "HOL foundation" 60 ./arlk check lib/hol.arlk
must_pass "Agda absorption and transport" 600 tools/agda-export/check.sh ./arlk
must_pass "Isabelle absorption (proofs replayed by simp)" 600 tools/isabelle-export/check.sh ./arlk

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

# Lean's Init.Data.Nat.Lemmas: 1564 of 1573 declarations check. Exactly
# the known failures (two roots in Nat.Linear's reflection proofs, out of
# budget; the rest depend on them) are allowed.
log="$LOGS/lean-nat-lemmas.log"
limit 2400 ./arlk check lib/core.arlk absorbed/lean/init_data_nat_lemmas.arlk --keep-going >"$log" 2>&1
grep '^✗' "$log" | sed -E 's/^✗ ([^:]+:[0-9]+): ([^(]*).*/\1: \2/' | sed -E 's/ +$//' >"$LOGS/lean-nat-lemmas.failures"
if diff -u absorbed/lean/init_data_nat_lemmas.expected-failures "$LOGS/lean-nat-lemmas.failures" >"$LOGS/lean-nat-lemmas.diff" && grep -q '^9 failed, 1564 declarations checked' "$log"; then
  record "Lean Init.Data.Nat.Lemmas (known baseline)" pass "9 known failures, 1564 checked"
else
  record "Lean Init.Data.Nat.Lemmas (known baseline)" FAIL "differs from the baseline, see $LOGS/lean-nat-lemmas.diff"
fi

# Lean's theorems on Rocq's numbers (examples/transport.arlk): checked, and
# a broken translation or a false preservation lemma must be rejected.
LIBS="lib/core.arlk absorbed/lean/init_data_nat_basic.arlk absorbed/rocq/init_peano.arlk"
must_pass "transport: Rocq add_comm from Lean" 1200 ./arlk check $LIBS examples/transport.arlk
tampered() { # name sed-expression
  sed "$2" examples/transport.arlk >"$LOGS/transport-$1.arlk"
  if cmp -s examples/transport.arlk "$LOGS/transport-$1.arlk"; then
    record "transport tampered: $1" FAIL "the edit did not apply"
  else
    must_reject "transport tampered: $1" 1200 "type mismatch" ./arlk check $LIBS "$LOGS/transport-$1.arlk"
  fi
}
tampered broken-to_lean 's/(x: RN, r: LN) => Nat.succ(r)/(x: RN, r: LN) => r/'
tampered false-add_hom 's/^theorem add_hom(n: LN, m: LN) -> REq(to_rocq(ladd(n, m)), radd(to_rocq(n), to_rocq(m)))/theorem add_hom(n: LN, m: LN) -> REq(to_rocq(ladd(n, m)), radd(to_rocq(m), to_rocq(m)))/'

# OpenTheory's standard library (the HOL family's: HOL Light, HOL4, ...):
# fetched as article files, pinned by checksum, absorbed and checked. No
# HOL system or OpenTheory tool is run. A false statement among the absorbed
# theorems must be rejected.
OT="$LOGS/opentheory"
if limit 900 tools/opentheory/fetch.sh base-1.221 "$OT" >"$LOGS/opentheory.articles" 2>"$LOGS/opentheory-fetch.log" \
   && (cd "$OT" && shasum -a 256 -c "$ROOT/tools/opentheory/base-1.221.sha256") >"$LOGS/opentheory-sha.log" 2>&1; then
  record "OpenTheory base-1.221 (fetched, pinned)" pass "$(wc -l <"$LOGS/opentheory.articles" | tr -d ' ') articles, checksums match"
  ARTS=()
  while IFS= read -r a; do ARTS+=("$a"); done <"$LOGS/opentheory.articles"
  must_pass "OpenTheory: absorb base-1.221" 1800 ./arlk absorb-hol "${ARTS[@]}" -o "$LOGS/opentheory-base.arlk"
  must_pass "OpenTheory: check base-1.221" 2400 ./arlk check lib/hol.arlk "$LOGS/opentheory-base.arlk"
  must_pass "OpenTheory: absorb bool, unit" 300 ./arlk absorb-hol "${ARTS[@]:0:8}" -o "$LOGS/opentheory-bool.arlk"
  ot_tampered() { # name sed-expression
    sed "$2" "$LOGS/opentheory-bool.arlk" >"$LOGS/opentheory-$1.arlk"
    if cmp -s "$LOGS/opentheory-bool.arlk" "$LOGS/opentheory-$1.arlk"; then
      record "OpenTheory tampered: $1" FAIL "the edit did not apply"
    else
      must_reject "OpenTheory tampered: $1" 300 "type mismatch" ./arlk check lib/hol.arlk "$LOGS/opentheory-$1.arlk"
    fi
  }
  ot_tampered false-definition 's/^theorem bool_def.thm1: Prf(eq(bool)(Data.Bool.F, /theorem bool_def.thm1: Prf(eq(bool)(Data.Bool.T, /'
  ot_tampered contradiction 's/^theorem bool_class.thm1: Prf(Data.Bool.forall(bool)((t_7: Tm(bool)) => Data.Bool.or(t_7, /theorem bool_class.thm1: Prf(Data.Bool.forall(bool)((t_7: Tm(bool)) => Data.Bool.and(t_7, /'
  # HOL read in Arlk's own type theory (a checked view): excluded middle,
  # proved by HOL, as a native theorem. A view that reads every HOL
  # statement as true must be rejected.
  must_pass "HOL in types: excluded middle" 300 ./arlk check lib/hol.arlk "$LOGS/opentheory-bool.arlk" examples/hol_types.arlk
  sed 's/^  Prf = (p: Sort(0)) => p,$/  Prf = (p: Sort(0)) => True,/' examples/hol_types.arlk >"$LOGS/hol_types-trivial.arlk"
  if cmp -s examples/hol_types.arlk "$LOGS/hol_types-trivial.arlk"; then
    record "HOL in types tampered: trivial view" FAIL "the edit did not apply"
  else
    must_reject "HOL in types tampered: trivial view" 300 "type mismatch" ./arlk check lib/hol.arlk "$LOGS/opentheory-bool.arlk" "$LOGS/hol_types-trivial.arlk"
  fi
else
  record "OpenTheory base-1.221 (fetched, pinned)" FAIL "see $LOGS/opentheory-fetch.log and opentheory-sha.log"
fi

# Proof bundles (#15): two results bundled and replayed from the bundle
# alone; every kind of tampering caught with its own exit status.
must_pass "views: route found and composed" 120 ./arlk check examples/views.arlk
must_pass "proof bundles: replay and tampering" 1200 tools/bundle-check.sh ./arlk "$LOGS/bundles"

# The native standard library and its clients, with negative controls (#18).
must_pass "native standard library and clients" 600 tools/std-check.sh ./arlk "$LOGS/std"

# Incremental checking (#21): a session of edits, each step identical to a
# fresh check; the scale table is advisory.
must_pass "incremental checking equals a fresh check" 900 python3 tools/session_check.py ./arlk "$LOGS/session" --scale

# Packages (#20): two projects on shared packages, every failure status,
# the assumption policy, bundles bound to packages, tampering.
must_pass "packages and projects" 900 tools/package-check.sh ./arlk "$LOGS/packages"

# Benchmark gates (#17): pinned inputs, fixtures check, semantic mutations
# rejected; one quick measurement pass whose outcomes (not timings) must
# match (budget exhaustion where expected, never a crash).
must_pass "benchmark controls" 600 bench/controls.sh ./arlk "$LOGS/bench-controls"
must_pass "benchmark outcomes (timings advisory)" 1800 python3 bench/run.py --arlk ./arlk --out "$LOGS/bench" --batches 1 --per 1 --lanes arlk,scale
must_pass "benchmark change challenge" 300 python3 bench/change.py ./arlk

# An Almide program verified through the subset's semantics (#16).
must_pass "Almide program: reverse keeps length" 1200 tools/almide-check.sh ./arlk "$LOGS/almide"

for f in spec/fixtures/reject/*.arlk; do
  want="$(sed -nE 's|^// expect: (.*)$|\1|p' "$f" | head -1)"
  must_reject "reject $(basename "$f")" 120 "$want" ./arlk check "$f"
done
must_reject "reject negative-numeral.json" 60 "negative" ./arlk absorb spec/fixtures/reject/negative-numeral.json

echo
printf '%s\n' "${results[@]}" | tee "$LOGS/summary.txt"
if [ "$failed" = 0 ]; then echo "all stages passed"; else echo "some stages failed"; fi
exit "$failed"
