# What Arlk takes from each prover

Arlk aims to handle what Lean, Rocq, Agda, Isabelle/HOL and Metamath (and the HOL family through
OpenTheory) can express, in one kernel and one Almide-like language. This page lists, system by
system, which of their features Arlk has natively, which it reads when absorbing that system's
libraries, and what is missing. "Native" means usable in Arlk's own syntax (`type`, `def`,
`theorem`, `match`); "absorbed" means checked when it arrives from the other system. Everything here
is implemented in Almide, in this repository; no prover runs behind Arlk.

The trusted base is listed in [TRUST.md](TRUST.md). Measured results are in the README's
"Results" table.

## The kernel's own logic

| Feature | Status | Where |
|---|---|---|
| Dependent functions, universes `Sort(u)` with `max`/`imax`, universe-polymorphic constants | native | `kernel.almd`, `term.almd` |
| Impredicative `Prop`, proof irrelevance | native | `kernel.irrelevant_eq` |
| Inductive families (parameters, indices), recursors with computation rules, large elimination for subsingletons, K for equality | native | `inductive.almd`, `checker.admissible` |
| Mutual inductive types (also with different index telescopes) | native, encoded as one family (adds no trust) | `mutual.almd` |
| Nested inductive types (`List(Rose)`), Lean's reading | native, trusted | `checker.nested_*`, `inductive.nested_eliminator` |
| Records with η | native | `kernel.eta_pairs` |
| Structure η for absorbed structures (`structure S = S.mk(...)`) | absorbed (Lean), declared assumption | `kernel.struct_expand` |
| Rewrite rules (λΠ modulo rewriting) | native, assumptions listed by `axioms` | `kernel.rewrite` |
| Structural recursion by `match` (nested patterns, inner matches, matches on a call's value) | native | `patterns.almd` |
| Dependent pattern matching on indexed families: constructor patterns in indices (unification by cases), impossible arms left out, `match h { }` | native, compiled to recursors (adds no trust) | `patterns.invert` |
| Well-founded recursion (`decreasing x by W`), `fix` and its unfolding law | native, from `Acc` (adds no trust) | `checker.add_wf_def`, `lib/std/wf.arlk` |
| Rewriting tactic (`by simp`, `by induction x simp`) | native, produces checked terms | `simp.almd` |
| Proof search (`search`) | native, produces checked terms | `search.almd` |
| Views and translations between theories | native | `checker.add_view`, `translate` |
| Quotient types (Lean's `Quot`, `Quot.lift` computing), function extensionality | native, declared assumptions (`funext` proved from `Quot.sound`) | `lib/quot.arlk` |
| Coinductive types of record shape (`codata`: streams, infinite trees), corecursion, coinduction by bisimulation | native, defined from paths (adds no trust); coinduction from `funext` | `codata.almd`, `examples/std/stream.arlk` |
| Coinductive types with several constructors (colists), guarded corecursion by copatterns, setoid rewriting | missing | |

## Lean 4

| Lean feature | Status |
|---|---|
| Inductive types, recursors, K-like reduction | absorbed (symbols and rules); native equivalents |
| Structures, projections, structure η | absorbed (`structure` declarations, η in conversion and in recursor matching; the exporter exports every projection of a structure it uses, so η is declared wherever Lean has it); native records with η |
| Quotients | absorbed (`Quot.lift`/`Quot.ind` rules, `Quot.sound` an axiom); native in `lib/quot.arlk` |
| Nested and mutual inductives | native; absorbed as Lean's kernel declares them (symbols and rules) |
| Well-founded recursion (`termination_by`) | native (`decreasing x by W`); absorbed as the kernel terms Lean compiles it to |
| Universe polymorphism | native; absorbed constants are instantiated per use |
| `Init.Data.Nat.Lemmas` | 1564 of 1573 declarations check; two roots run out of budget |
| `Init.Data.List.Lemmas` (universe-polymorphic theorems exported at their lowest universes) | 2221 of 2236 declarations check; four roots run out of budget; 119 theorems with string literals not exported yet |
| Tactics, elaboration | not absorbed (Lean's kernel terms are); Arlk has `by simp` and `search` of its own |

## Rocq

| Rocq feature | Status |
|---|---|
| Inductive types, `match`, `fix` (also over indexed families) | absorbed (lambda-lifted symbols with rules) |
| Universe constraints, template polymorphism, cumulativity | absorbed (levels numbered, instances per level, explicit `lift`) |
| `Corelib.Init` | 969 of 973 declarations check (`sig`/`sigT` at `Prop` missing) |
| `SProp`, primitive projections, cofixpoints, primitive integers | missing |

## Agda

| Agda feature | Status |
|---|---|
| `data` with parameters and indices, pattern matching by clauses, implicit arguments, mixfix operators | absorbed from source (`arlk absorb-agda`), and native |
| Dependent pattern matching on equality (`sym refl = refl`) | absorbed (index refinement in `match`) |
| Absurd patterns `()` (also in a later argument), dependent matching on `≤`-like families | absorbed (impossible arms left out, checked by Arlk's match) |
| Records (`constructor`, `field`, `open R`), projections | absorbed (a type with one constructor, a projection per field) |
| `with` on a value in a function | absorbed (`match` on the call); `with` that must abstract the value in the goal of a proof is missing |
| Coinductive records and definitions by copatterns (guarded corecursion by a state) | absorbed (Arlk `codata` and `corec`) |
| Instance arguments, sized types, cubical features, `--without-K` | missing |
| `absorbed/agda/Order.agda` (`≤`, `≤-pred`, `¬s≤z ()`) | 15 of 15 declarations check; Agda 2.8.0.2 accepts the source |
| `absorbed/agda/Records.agda` (`Pair` with projections, `filter` by `with`) | 26 of 26 declarations check; Agda 2.8.0.2 accepts the source |
| `absorbed/agda/Streams.agda` (coinductive `Stream`, `repeat`/`from`/`map` by copatterns) | all declarations check; Agda 2.8.0.2 accepts the source |
| `absorbed/agda/Arith.agda` | 27 of 27 declarations check; Agda 2.8.0.2 accepts the source; its `+-comm` proves Arlk's `nat.add_comm` again ([examples/agda_transport.arlk](../examples/agda_transport.arlk)) |

## Isabelle/HOL

| Isabelle feature | Status |
|---|---|
| `datatype`, `fun`/`primrec`/`definition` by equations | absorbed from source (`arlk absorb-isabelle`) |
| Proof methods `simp`, `auto`, `(induction x)`, `simp add:` | replayed by Arlk's `simp`, so a false lemma cannot pass |
| `[simp]` sets, `declare` | absorbed |
| Main's `nat` and `'a list` (`0`, `Suc`, numerals, `+`, `*`, `#`, `@`, `[a, b]`, `rev`, `length`, `map`) and their `[simp]` lemmas | absorbed into `lib/isabelle_main.arlk` (defined by Isabelle's equations, lemmas proved by Arlk's simp) |
| Type inference for a lemma's variables | by unification, as Isabelle |
| Isar proofs of the shape `proof (induction x) case ... show ?case by simp ... qed`, `arbitrary:` | replayed by Arlk's simp |
| Equational premises (`xs = ys ⟹ rev xs = rev ys`) | absorbed as hypotheses that simp rewrites with |
| Isar with intermediate `have` steps, other premises, type classes, locales, the rest of Main | missing |
| `absorbed/isabelle/Arith.thy`, `absorbed/isabelle/Lists.thy` | all declarations check; Isabelle2025-2 accepts the sources |
| HOL's inference rules (HOL Light, HOL4, ...) | absorbed from OpenTheory articles into `lib/hol.arlk`'s encoding: the base library, 91 193 declarations |

## Metamath

| Metamath feature | Status |
|---|---|
| Syntax axioms as constructors, `$p` proofs as terms, `$d` conditions as `Apart` facts | absorbed (`arlk absorb-mm`) |
| `set.mm` | the propositional part (1818) in CI; up to `unitssre` (14 389) checked; the whole database is absorbed (794 MB of Arlk) and being checked |
| `iset.mm` (intuitionistic) | the whole database: 18 661 declarations check, none fail (absorb 89 s, check 48 min; not in CI) |

## Between systems

| Transport | Where |
|---|---|
| Lean's naturals and Rocq's, as the same theory (a bridge and views) | [examples/bridge.arlk](../examples/bridge.arlk), [examples/transport.arlk](../examples/transport.arlk) |
| Agda's `+-comm` to Arlk's `nat.add_comm` | [examples/agda_transport.arlk](../examples/agda_transport.arlk) |
| HOL in Arlk's types (excluded middle carried by a view) | [examples/hol_types.arlk](../examples/hol_types.arlk) |
| Isabelle's `add_comm` to Arlk's `nat.add_comm` | [examples/isabelle_transport.arlk](../examples/isabelle_transport.arlk) |
| Metamath's arithmetic to the others | missing |
