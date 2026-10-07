# What Arlk takes from each prover

Arlk aims to handle what Lean, Rocq, Agda, Isabelle/HOL and Metamath (and the HOL family through
OpenTheory) can express, in one kernel and one Almide-like language. This page lists, system by
system, which of their features Arlk has natively, which it reads when absorbing that system's
libraries, and what is missing. "Native" means usable in Arlk's own syntax (`type`, `def`,
`theorem`, `match`); "absorbed" means checked when it arrives from the other system. Everything here
is implemented in Almide, in this repository; no prover runs behind Arlk.

The trusted base is listed in [TRUST.md](TRUST.md). [Recorded results](#recorded-results) below collect library coverage and timings;
[ABSORBING.md](ABSORBING.md) explains the encodings and how to run the importers.

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
| Well-founded recursion (`decreasing x by W`), `fix` and its unfolding law; course-of-values recursion (calls on deeper subterms) through it | native, from `Acc` (adds no trust) | `checker.add_wf_def`, `lib/std/wf.arlk` |
| Rewriting tactic (`by simp`, `by induction x simp`) | native, produces checked terms | `simp.almd` |
| Equational chains (`calc`; Lean's `calc`, Agda's `≡⟨⟩` reasoning, Isar's `also`/`finally`) | native, a chain of `trans` (adds no trust) | `syntax.calc` |
| Rewriting the goal with an equation (`rewrite h { … }`; Lean's `rw`, Agda's `rewrite`) | native, the goal's occurrences abstracted and carried by the equality's recursor (adds no trust) | `elab.rewrite` |
| Proof search (`search`) | native, produces checked terms | `search.almd` |
| Views and translations between theories | native | `checker.add_view`, `translate` |
| Quotient types (Lean's `Quot`, `Quot.lift` computing), function extensionality | native, declared assumptions (`funext` proved from `Quot.sound`) | `lib/quot.arlk` |
| Coinductive types of record shape (`codata`: streams, infinite trees), corecursion, coinduction by bisimulation | native, defined from paths (adds no trust); coinduction from `funext` | `codata.almd`, `examples/std/stream.arlk` |
| Numerals (`numerals Nat.zero, Nat.succ`: `1000000` as one constant unfolded lazily) | native, abbreviations (adds no trust) | `kernel.numeral_step` |
| Arithmetic on literals (`numerals Nat.zero computes { add: Nat.add, ... }`), as Lean's kernel accelerates `Nat` | native, declared assumption checked on small literals; absorbed for Lean's `Nat` operations | `kernel.computed` |
| Coinductive types with several constructors (colists), guarded corecursion by copatterns, setoid rewriting | missing | |

## Lean 4

| Lean feature | Status |
|---|---|
| Inductive types, recursors, K-like reduction | absorbed (symbols and rules); native equivalents |
| Nested inductive types (`Lean.Syntax` over `Array`/`List`), unit-like structures (`PUnit`, `True`) with their η |  absorbed: auxiliary recursors (`rec_1`, `rec_2`) with their rules, structures without fields declared `structure S = S.mk()` |
| Structures, projections, structure η | absorbed (`structure` declarations, η in conversion and in recursor matching; the exporter exports every projection of a structure it uses, so η is declared wherever Lean has it); native records with η |
| Quotients | absorbed (`Quot.lift`/`Quot.ind` rules, `Quot.sound` an axiom); native in `lib/quot.arlk` |
| Nested and mutual inductives | native; absorbed as Lean's kernel declares them (symbols and rules) |
| Well-founded recursion (`termination_by`) | native (`decreasing x by W`); absorbed as the kernel terms Lean compiles it to |
| Universe polymorphism | native; absorbed constants are instantiated per use |
| `Init.Data.Nat.Lemmas` | all 1573 declarations check |
| `Init.Data.List.Lemmas` (universe-polymorphic theorems exported at their lowest universes) | all 688 theorems exported, string literals included (`String.mk` of `Char.ofNat`s); all 2617 declarations check |
| `Init.SimpLemmas`, `Init.PropLemmas`, `Init.Data.Bool`, `Init.Data.Sum.Lemmas`, `Init.Data.Option.Lemmas`, `Init.Data.Int.Lemmas`, `Init.Data.Int.Order`, `Init.Data.Nat.Dvd`, `Init.Data.Nat.Gcd`, `Init.Data.Prod`, `Init.Data.Char.Lemmas`, `Init.Core` | each module whole (2136 theorems): every declaration checks |
| `Init.Data.Fin.Lemmas` (298 theorems), `Init.Data.Nat.Bitwise.Lemmas` (120), `Init.Data.List.Nat.Basic` (30) | every declaration checks (14 to 20 minutes each); not committed (69 MB of Arlk): exported from Lean, absorbed and checked daily in CI ([lean.yml](../.github/workflows/lean.yml)) |
| `Init.Data.String.Lemmas` | not exported: its proofs project out of `Exists` (a non-structure), which the exporter does not translate yet |
| Tactics, elaboration | not absorbed (Lean's kernel terms are); Arlk has `by simp` and `search` of its own |

## Rocq

| Rocq feature | Status |
|---|---|
| Inductive types, `match`, `fix` (also over indexed families) | absorbed (lambda-lifted symbols with rules) |
| Universe constraints, template polymorphism, cumulativity | absorbed (levels numbered, instances per level, explicit `lift`) |
| `Corelib.Init` | all 753 declarations (436 targets) check (`sig`/`sigT` lowered into `Prop` included) |
| `Stdlib.Arith.PeanoNat` | 1194 of 1207 targets check (6 of the others use `SProp`); daily in CI against a fixed baseline ([rocq.yml](../.github/workflows/rocq.yml)) |
| `Stdlib.Lists.List` | 456 of 470 targets check (6 of the others use `SProp`); daily in CI the same way |
| `SProp`, primitive projections, cofixpoints, primitive integers | missing |

## Agda

| Agda feature | Status |
|---|---|
| `data` with parameters and indices, pattern matching by clauses, implicit arguments, mixfix operators | absorbed from source (`arlk absorb-agda`), and native |
| Dependent pattern matching on equality (`sym refl = refl`) | absorbed (index refinement in `match`) |
| Absurd patterns `()` (also in a later argument), dependent matching on `≤`-like families | absorbed (impossible arms left out, checked by Arlk's match) |
| Records (`constructor`, `field`, `open R`), projections | absorbed (a type with one constructor, a projection per field) |
| `with` on a value, in functions and in proofs whose goal mentions it | absorbed (`match` on the call, which abstracts the call where the goal mentions it); `with … | inspect` is missing |
| `rewrite e₁ \| e₂`, `let … in`, point-free clauses (`f = λ x → …`), implicit patterns `{n}`, helpers in `where` | absorbed (Arlk's `rewrite e₁, e₂ { … }`, a block, η-expansion, a declaration of its own before the function; a helper that uses the clause's variables is not supported) |
| Coinductive records and definitions by copatterns (guarded corecursion by a state) | absorbed (Arlk `codata` and `corec`) |
| Instance arguments, sized types, cubical features, `--without-K` | missing |
| `absorbed/agda/Order.agda` (`≤`, `≤-pred`, `¬s≤z ()`) | 15 of 15 declarations check; Agda 2.8.0.2 accepts the source |
| `absorbed/agda/Records.agda` (`Pair` with projections, `filter` by `with`, a proof by `with`) | 27 of 27 declarations check; Agda 2.8.0.2 accepts the source |
| `absorbed/agda/Streams.agda` (coinductive `Stream`, `repeat`/`from`/`map` by copatterns) | all declarations check; Agda 2.8.0.2 accepts the source |
| `absorbed/agda/Rewriting.agda` (`+-comm`, `+-assoc`, `*-suc` by `rewrite` and `where` helpers, `let`, a point-free definition) | all declarations check; Agda 2.8.0.2 accepts the source |
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
| Isar `proof - have ... show ?thesis ... qed`, labelled steps, `have ... for x`, calculational chains (`also have "... = c"`, `finally`) | absorbed: each step a theorem of its own replayed by simp, the statement by simp with the steps |
| Isar steps inside induction cases, other premises, type classes, locales, the rest of Main | missing |
| `absorbed/isabelle/Arith.thy`, `absorbed/isabelle/Lists.thy` | all declarations check; Isabelle2025-2 accepts the sources |
| HOL's inference rules (HOL Light, HOL4, ...) | absorbed from OpenTheory articles into `lib/hol.arlk`'s encoding: the base library (see [recorded results](#recorded-results)) |

## Metamath

| Metamath feature | Status |
|---|---|
| Syntax axioms as constructors, `$p` proofs as terms, `$d` conditions as `Apart` facts | absorbed (`arlk absorb-mm`) |
| `set.mm` | the whole database (commit 584b685, 47 913 theorems): every theorem checks, none fail, in 12 parts (`arlk chunk`), about 17 CPU-hours; in CI the propositional part (1818) on every push, and the whole of it in 24 parallel parts daily (.github/workflows/setmm.yml) |
| `iset.mm` (intuitionistic) | the whole database (commit 584b685, 16 444 theorems): every theorem checks, none fail; in CI daily in 4 parallel parts with the same coverage check as set.mm |

## Between systems

| Transport | Where |
|---|---|
| Lean's naturals and Rocq's, as the same theory (a bridge and views) | [examples/bridge.arlk](../examples/bridge.arlk), [examples/transport.arlk](../examples/transport.arlk) |
| Agda's `+-comm` to Arlk's `nat.add_comm` | [examples/agda_transport.arlk](../examples/agda_transport.arlk) |
| HOL in Arlk's types (excluded middle carried by a view) | [examples/hol_types.arlk](../examples/hol_types.arlk) |
| Isabelle's `add_comm` to Arlk's `nat.add_comm` | [examples/isabelle_transport.arlk](../examples/isabelle_transport.arlk) |
| Metamath's propositional calculus in Arlk's logic (Peirce's law from set.mm, resting on excluded middle alone) | [examples/metamath_logic.arlk](../examples/metamath_logic.arlk) |
| Metamath's arithmetic to the others | missing |

## Recorded results

These are the repository's recorded library checks and illustrative timings, not a fresh
benchmark for every checkout or machine. The push and daily workflows identify which checks
run on a particular commit. Source-system support is limited to the features listed above.


| Library | Declarations checked | Time |
|---|---|---|
| Lean `Nat.add_zero` | 53 (with dependencies) | < 0.1 s |
| Lean `Init.Data.Nat.Basic` (310 theorems, universe-polymorphic ones at their lowest universes) | all 823 | ~30 s |
| Lean `Init.Data.Nat.Lemmas` (881 theorems: arithmetic, order, division, `Nat.Linear`) | all 1573 | ~5 min |
| Lean `Init.SimpLemmas`, `Init.PropLemmas`, `Init.Data.Bool`, `Init.Data.Sum.Lemmas`, `Init.Data.Option.Lemmas`, `Init.Data.Int.Lemmas`, `Init.Data.Int.Order`, `Init.Data.Nat.Dvd`, `Init.Data.Nat.Gcd`, `Init.Data.Prod`, `Init.Data.Char.Lemmas`, `Init.Core` (each module whole: 2136 theorems) | all of them | ~16 min together |
| Lean `Init.Data.List.Lemmas` (688 theorems at their lowest universes, string literals included; `ARLK_FULL=1` in CI) | all 2617 | ~13 min |
| Rocq `Corelib.Init.Peano` | 99, all of them | < 0.5 s |
| Rocq `Corelib.Init` (Logic, Datatypes, Peano, Nat, Specif, Wf) | all 753 (436 targets) | ~20 s |
| Rocq `Stdlib.Arith.PeanoNat` (1207 targets; exported from Rocq 9.2 in CI, not committed) | 1194 targets check (6 of the rest use `SProp`); the rest are a fixed baseline | ~2 min |
| Rocq `Stdlib.Lists.List` (470 targets; the same) | 456 targets check (6 of the rest use `SProp`) | ~1 min |
| Agda `Arith`, `Order`, `Records`, `Streams` (from source: laws, `≤`, records, `with`, coinduction) | all of them | < 0.5 s |
| Isabelle `Arith`, `Lists` (own and Main's naturals and lists, Isar; proofs replayed by `simp`) | all of them | < 1 s |
| Metamath `set.mm`, propositional calculus | 1818: 1776 theorems and their axioms | 0.6 s |
| Metamath `set.mm`, the whole database (commit 584b685; absorbed, not committed) | 47 913 theorems, all of them, in 12 parts | absorb 17 min, check ~17 CPU-hours (parts: 24 min to 3.7 h) |
| Metamath `iset.mm` (intuitionistic logic and set theory), the whole database (commit 584b685; checked daily in CI) | 16 444 theorems, all of them, in 4 parts | absorb 87 s, parts 11 to 16 min |
| OpenTheory `base-1.221` (HOL: bool, pairs, lists, natural numbers, words, reals ...), fetched in CI | 91 319: 1340 theorems, 14 009 lemmas, 75 651 term abbreviations, 223 definitions | absorb ~3.5 min, check ~3.5 min |


`Rewriting.agda` is also checked by the Agda check script; no timing is recorded here.

## Roadmap

The missing rows above define the coverage roadmap. Broader priorities:

1. **Kernel hardening.** Confluence and termination checks for user rewrite rules, and checking
   subject reduction instead of trusting a rule's declared variable types.
2. **The rest of each library.** Lean: `Init` as a whole (some modules, such as `String.Lemmas`,
   the exporter cannot translate yet), universe polymorphism kept rather than
   instantiated. Rocq: the rest of the standard library, `SProp`, primitive projections,
   cofixpoints. Agda:
   `with … | inspect`, instance arguments. Isabelle: Isar steps inside induction cases,
   premises other than equations, type classes, more of Main. Metamath: reduce the cost of its heaviest checks; the pinned databases already have full recorded coverage.
3. **Coinduction beyond records.** Coinductive types with several constructors (colists) and
   guarded corecursion that is not a state machine.
4. **Speed.** Checking is dominated by copying terms (Almide copies a recursive value that is used
   again, almide/almide#3434). The kernel avoids it where it can: it describes a term for an error
   only when a failed declaration is checked again for its message. Recorded library timings are
   above; compiler issues and retained workarounds are in [docs/TOOLCHAIN.md](TOOLCHAIN.md).
5. **Natural language layer.** Pair each theorem with a statement in natural language, and
   track where the formal statement and the intended meaning may differ.
