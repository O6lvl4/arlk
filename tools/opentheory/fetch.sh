#!/usr/bin/env bash
# Download an OpenTheory package and everything it is built from, as plain
# files (no OpenTheory tool or HOL system is run). Prints the articles in an
# order where every theory comes after the theories it imports.
#
#   tools/opentheory/fetch.sh base-1.221 DIR
set -euo pipefail
pkg="$1"; dir="$2"
site="http://opentheory.gilith.com/opentheory/packages"
mkdir -p "$dir"
seen=" "
visit() {
  local p="$1"
  case "$seen" in *" $p "*) return;; esac
  seen="$seen$p "
  if [ ! -d "$dir/$p" ]; then
    mkdir -p "$dir/$p"
    curl -sfL -m 120 "$site/$p/$p.tgz" | tar xz -C "$dir/$p"
    # Some packages unpack into a directory of their own name, some not.
    if [ -d "$dir/$p/$p" ]; then
      mv "$dir/$p/$p"/* "$dir/$p/" && rmdir "$dir/$p/$p"
    fi
  fi
  local thy
  thy=$(ls "$dir/$p"/*.thy)
  # Sub-packages, in the order the theory file lists them (a block that
  # imports earlier blocks comes after them).
  local subs
  subs=$(sed -nE 's/^[[:space:]]*package:[[:space:]]*([^[:space:]]+).*/\1/p' "$thy")
  for sub in $subs; do
    visit "$sub"
  done
  sed -nE 's/^[[:space:]]*article:[[:space:]]*"(.*)".*/\1/p' "$thy" | while read -r art; do
    echo "$dir/$p/$art"
  done
}
visit "$pkg"
