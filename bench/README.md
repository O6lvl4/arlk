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

## Measured

One run of `bench/run.py --hol-bool …` (5 batches × 3 runs, seed 20261005) at 70de056, on an Apple
M4 Pro laptop (macOS 26.3). The page cache was warm. One unrelated single-threaded job was running
on another core, so the timings are advisory. The build (`almide build`, incremental) took 0.42 s
and is not counted. RSS is the child's peak.

| lane | job | outcome | median s | min s | max s | median RSS KiB | runs |
|---|---|---|---:|---:|---:|---:|---:|
| arlk-check | empty | pass | 0.0023 | 0.0020 | 0.0068 | 2192 | 15 |
| arlk-check | reverse-baseline | pass | 0.0124 | 0.0108 | 0.0200 | 4016 | 15 |
| arlk-check | reverse-accumulator | pass | 0.0165 | 0.0137 | 0.2373 | 4320 | 15 |
| arlk-check | sort | pass | 0.0602 | 0.0556 | 0.0860 | 6160 | 15 |
| arlk-check | std-library | pass | 0.0591 | 0.0524 | 0.0857 | 5456 | 15 |
| arlk-check | std-reverse | pass | 0.0792 | 0.0686 | 0.1092 | 5584 | 15 |
| arlk-check | std-sort | pass | 0.1235 | 0.1126 | 0.1797 | 6720 | 15 |
| arlk-scale | decls-100 | pass | 0.0323 | 0.0292 | 0.0395 | 4944 | 15 |
| arlk-scale | decls-200 | pass | 0.0573 | 0.0508 | 0.0708 | 6064 | 15 |
| arlk-scale | decls-400 | pass | 0.1018 | 0.0954 | 0.1131 | 8160 | 15 |
| arlk-scale | decls-800 | pass | 0.1966 | 0.1847 | 0.2645 | 12448 | 15 |
| arlk-scale | term-50 | pass | 0.0254 | 0.0224 | 0.0352 | 11536 | 15 |
| arlk-scale | term-100 | pass | 0.0593 | 0.0542 | 0.0843 | 32432 | 15 |
| arlk-scale | term-200 | pass | 0.1866 | 0.1790 | 0.2530 | 114320 | 15 |
| arlk-scale | term-400 | pass | 0.6462 | 0.6154 | 0.7968 | 439392 | 15 |
| arlk-scale | shared-100 | pass | 0.0269 | 0.0247 | 0.0308 | 5040 | 15 |
| arlk-scale | shared-200 | pass | 0.0422 | 0.0389 | 0.0762 | 6208 | 15 |
| arlk-scale | shared-400 | pass | 0.0758 | 0.0706 | 0.0900 | 8352 | 15 |
| arlk-scale | shared-800 | pass | 0.1391 | 0.1298 | 0.1618 | 12720 | 15 |
| arlk-scale | numeral-100 | pass | 0.0255 | 0.0222 | 0.0427 | 6384 | 15 |
| arlk-scale | numeral-400 | pass | 0.0743 | 0.0700 | 0.0932 | 14160 | 15 |
| arlk-scale | numeral-1600 | budget | 0.0922 | 0.0815 | 0.1088 | 23696 | 15 |
| arlk-scale | numeral-6400 | budget | 0.1777 | 0.1682 | 0.3800 | 55824 | 15 |
| arlk-reuse | lean-to-rocq-transport | pass | 31.8907 | 29.7599 | 65.6144 | 156672 | 15 |
| arlk-reuse | two-view-composition | pass | 0.0036 | 0.0033 | 0.0092 | 3360 | 15 |
| arlk-reuse | hol-to-native-view | pass | 2.9629 | 2.6906 | 6.6243 | 151728 | 15 |

Observations, not claims:

- **Startup.** An empty room takes 2 ms. The #17 fixtures take 12, 17 and 60 ms on this machine.
  The issue measured 15, 19 and 79 ms on its Linux host at cc7ba40; the two are not comparable.
- **Declarations.** `decls`/`shared` grow linearly: 800 theorems in 0.20 s. Before 70de056 the
  elaborator copied the whole environment for every declaration, and 800 took 1.19 s.
- **Proof-term depth.** `term-N` grows quadratically in memory: 439 MB at 400 nested steps at
  70de056. Since then, several sources have been removed:
  - substituting non-dependent arguments, in the kernel and the elaborator;
  - taking spines in `zonk`;
  - a copying `size_upto`;
  - printing terms when unification is postponed;
  - copying hole maps for backtracking (now an undo trail).

  `term-400` is down to 261 MB, a single implicit argument nested 1600 deep from 2.5 GB to 0.56 GB,
  and the peak for Lean `Nat.Lemmas` from 2.3 GB to 1.2 GB. The rest is Almide copying an argument
  that is used again after a call (almide/almide#3434).
- **Numerals.** `numeral-1600` and `numeral-6400` exceed the unification depth and end as budget,
  every run, in under 0.4 s. Before 70de056, 6400 overflowed the native stack.
- **Cross-logic reuse.** It is dominated by checking the absorbed libraries: Lean `Nat.Basic` plus
  Rocq `Init.Peano` take about 30 s, the OpenTheory bool theory about 3 s. The composed view
  alone takes 4 ms.
