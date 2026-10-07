#!/usr/bin/env bash
# Check every absorbed library, and the Lean–Rocq bridge, with the Arlk
# kernel alone (no Lean, Rocq or Metamath verifier needed).
set -euo pipefail
cd "$(dirname "$0")/.."
almide build src/main.almd -o arlk
./arlk qed lib/core.arlk absorbed/lean/nat_add_zero.arlk | tail -1
./arlk qed lib/core.arlk absorbed/rocq/init_peano.arlk | tail -1
./arlk qed lib/core.arlk absorbed/lean/init_data_nat_basic.arlk absorbed/rocq/init_peano.arlk examples/bridge.arlk | tail -1
./arlk qed absorbed/metamath/set_prop.arlk | tail -1
