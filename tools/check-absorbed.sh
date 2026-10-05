#!/usr/bin/env bash
# Check every absorbed file with the Arlk kernel alone (no Lean needed).
set -euo pipefail
cd "$(dirname "$0")/.."
almide build src/main.almd -o arlk
for f in absorbed/*/*.arlk; do
  ./arlk check "$f" | tail -1
done
