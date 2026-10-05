# Benchmark: native proofs, scaling, and cross-logic reuse

A small, reproducible benchmark (#17). It measures what a fixed set of checks costs, and keeps
the checks themselves as CI gates, so an improvement can be measured without changing the
theorem, its assumptions, how the checker is launched, or what is trusted.

Timings are observations of exact pinned files on one machine. They are not performance promises,
and not a ranking of provers: Arlk and Bend have different foundations and trust boundaries.

## What is checked

All fixtures use arbitrary finite lists of Peano naturals. None imports a library, adds an axiom,
admits a goal, or assumes machine integers.

| Fixture | Property |
|---|---|
| `fixtures/reverse/baseline` | `len(rev(xs)) = len(xs)` for every list, `rev` by `snoc` |
| `fixtures/reverse/accumulator` | the same, `rev` with an accumulator |
| `fixtures/sort/sort` | `SortedB(sort(xs), zero)` (nondecreasing, carrying the lower bound) and `count(x, sort(xs)) = count(x, xs)` for every `x` and `xs` (duplicates kept) |

These are length preservation only for reverse (the identity also has it), and order plus
multiplicities for sort. Full reversal semantics, accumulator equivalence and stability are not
claimed. The `.arlk` and `.bend` fixtures are verbatim from #17, pinned by SHA-256 in
[manifest.txt](manifest.txt). `examples/std/*.arlk` state the same claims on the shared library
([docs/STDLIB.md](../docs/STDLIB.md)).

## Correctness gates (CI)

[controls.sh](controls.sh) is run by CI (`tools/ci.sh`). It checks that:

- the inputs match the manifest;
- every Arlk fixture checks, with no symbol or rule in its assumption inventory;
- eight semantic mutations are each rejected with a type mismatch at the declaration that should
  catch them:
  - reverse, both implementations: drop an element, state a false law, corrupt a proof step;
  - sort: wrong order, rejected in the order proof;
  - sort: dropped insertion, with the order proof taken out so that only the multiplicity proof can
    catch it.

With `BEND` set to a Bend command (for example `bun bend2/main.ts` at the pinned checkout), the
Bend fixtures run with `--verdict`, and three Bend mutations must be rejected. CI does not set it.

`bench/run.py --batches 1 --per 1` also runs in CI. The runner exits 1 when a job's outcome
(pass, budget, ...) differs from what it expects, so that is a gate as well; its timings are
advisory and never fail CI.

## Measurement

```
bench/run.py --arlk ./arlk --out DIR [--batches 5 --per 3 --seed 20261005]
             [--lanes arlk,scale,reuse] [--hol-bool opentheory-bool.arlk]
             [--lane 'bend-verdict=bun /path/bend2/main.ts {file}.bend --verdict']
             [--build 'almide build src/main.almd -o arlk']
```

- **Fresh processes.** Every run is a fresh process started by [launch.c](launch.c), a small native
  launcher that reports the exit status, the wall time (monotonic clock) and `ru_maxrss` from
  `wait4()` on the child. That is the largest child's peak RSS, not the RSS of a whole process
  tree. Linux reports it in KiB and macOS in bytes; the launcher prints KiB. Because the launcher
  is native, no interpreter heap sits under the child's RSS before `exec`.
- **Order.** Jobs run in batches (default 5). Within a batch, the order of (job, repetition)
  (default 3 repetitions) is shuffled by a generator seeded with `--seed`, so the order is random but
  reproducible.
- **Cache.** The page cache is warm: nothing is dropped, and there is no cold-cache claim.
- **Outputs.**
  - `raw.csv`: every run.
  - `summary.json` / `summary.md`: per job, the median, min and max time and RSS, and the per-batch
    medians.
  - `environment.txt`: machine, toolchain, hashes of the binary and every input, seed, flags, and
    setup time if `--build` was given (build cost is recorded apart from checking).
  - `reuse.json`: see below.
- **Outcomes.** Each run is classified as pass, reject, budget, timeout, crash or error. Budget
  exhaustion is an outcome of its own: it is never counted as a pass and never dropped from the
  tables.
- **Lanes:**
  - `arlk-check`: the fixtures, the shared library and its clients, and an empty room (startup).
  - `arlk-scale`: the scaling families of [scale.py](scale.py), generated deterministically:
    - `decls-N`: a chain of N theorems;
    - `term-N`: one proof term with N nested steps;
    - `shared-N`: N theorems on one shared lemma chain;
    - `numeral-N`: `add(N, N) = 2N` by computation alone. Its two largest sizes must end as budget,
      not crash.
  - `arlk-reuse`: the cross-logic track below.
  - `--lane NAME=TEMPLATE`: any other tool, such as the Bend source frontend, standalone
    `--verdict`, or replay of emitted BendTT certificates. Each tool is its own lane, reported
    separately and never merged into Arlk's numbers.

## Cross-logic reuse track

This track is separate from the native track. Its tasks are not comparable to a native proof, and
no speed ratio is drawn between them.

| Job | Destination claim | Route |
|---|---|---|
| `lean-to-rocq-transport` | `transport.rocq_add_comm`: Lean's `Nat.add_comm` read on Rocq's `nat` | checked translations both ways (examples/transport.arlk) |
| `two-view-composition` | `c.agree`: `a.k` read in `c` | `a -> b -> c`, composed from two checked views (examples/views.arlk) |
| `hol-to-native-view` (with `--hol-bool`) | `holtypes.em`: excluded middle from OpenTheory's bool theory | the HOL view into Arlk's types (examples/hol_types.arlk) |

For each job, `reuse.json` records:

- the destination claim and its statement;
- its claim identity (the bundle `claim-id` of #15);
- the semantics version;
- the complete assumption inventory;
- the routes and views the check printed.

A change in any of these is a change of the result, not of its speed.

## Implementation-change challenge

[change.py](change.py) replaces the snoc reverse by the accumulator reverse, keeping the claim.
For each language and section, it reports the lexical tokens removed and added (the counting of
[tools/tokens.py](../tools/tokens.py)), and checks that both Arlk versions pass. These are counts of
changed source, not a measure of human effort.

| language | section | before | after | removed | added |
|---|---|---:|---:|---:|---:|
| arlk | PROGRAM | 114 | 127 | 36 | 49 |
| arlk | PROOF | 122 | 229 | 35 | 142 |
| arlk | all | 479 | 599 | 71 | 191 |
| bend | PROGRAM | 123 | 134 | 53 | 64 |
| bend | PROOF | 170 | 323 | 68 | 221 |
| bend | all | 325 | 489 | 121 | 285 |
