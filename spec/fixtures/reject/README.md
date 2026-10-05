# Inputs Arlk must reject

Each `.arlk` file starts with `// expect: TEXT`: checking it must fail (exit status 1) with TEXT in
the error. `tools/ci.sh` runs each under a timeout and fails if a file is accepted, crashes, times
out or is rejected for another reason. `negative-numeral.json` is input to `arlk absorb` (issue #4)
and must be refused with "negative".
