#!/usr/bin/env bash
# Build the Rocq export plugin. Then, from a .v file:
#   Declare ML Module "rocq-arlk-export.plugin".
#   Arlk Export "out.json" plus_n_O plus_n_Sm.
# and run it with: OCAMLPATH=$PWD/src rocq c -I src file.v
set -euo pipefail
cd "$(dirname "$0")"
rocq makefile -f _CoqProject -o Makefile.rocq
make -f Makefile.rocq
