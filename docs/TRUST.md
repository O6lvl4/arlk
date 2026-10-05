# What a result rests on

This is a map of Arlk's trusted base: which code a checked result depends on being correct, and
which inputs are assumptions a result is relative to. It describes the code as it is; it is not a
soundness proof, and a passing test suite is not one either.

## 1. Term checking — trusted

[src/kernel.almd](../src/kernel.almd) and [src/term.almd](../src/term.almd).

| Part | Where |
|---|---|
| Terms, de Bruijn substitution | `term.almd`: `shift`, `instantiate`, `subst` |
| Universe levels: `max`, `imax`, parameters, decided for every parameter value | `term.almd`: `level_leq`, `level_eq` |
| Typing: sorts (`Sort(u) : Sort(u + 1)`), Π types at `imax`, constants at their universe instance | `kernel.almd`: `infer`, `check`, `expect_sort` |
| Reduction: β, δ (defs, by height), rewrite rules | `kernel.almd`: `reduce`, `rewrite`, `try_rule`, `match_pat` |
| Structure eta for declared structures (`structure S = S.mk(S.f1, ...)`): in conversion, and in matching a rule's constructor pattern against a value of S (not for the projections' own rules) | `kernel.almd`: `eta_pairs`, `struct_expand`, `struct_params` |
| Conversion: lazy δ, η, η for non-recursive records (`p ≡ P.mk(p.x, p.y)`), proof irrelevance (Prop, and declared `irrelevant` types) | `kernel.almd`: `conv`, `record_eta`, `eta_pairs`, `irrelevant_eq`, `is_prop` |
| Resource limits: one work budget per declaration, bounded nesting (including reductions inside rule matching), exhaustion reported as an error, never as a normal form | `kernel.almd`: `Budget`, `spend`, `enter`, `enter_by` |
| Holes are never accepted: a term containing a metavariable or an unsolved level is rejected | `kernel.almd`: `infer` (`Meta`, `level_has_meta`) |
| Name resolution and room visibility | `kernel.almd`: `resolve_const` |

A rewrite also pays for the size of the term it builds (up to 10 000 per step), so a rule that keeps
growing the term (`f(x) = f(f(x))`) exhausts the budget instead of copying ever larger terms.
Exhaustion makes the checker incomplete (a proof needing more work is rejected), not unsound.
Regression tests: [spec/kernel_test.almd](../spec/kernel_test.almd), issues #1, #3, #7.

## 2. Declarations — trusted

[src/checker.almd](../src/checker.almd) turns parsed declarations into environment entries. Every
`symbol` type, `def`/`theorem` body and rule is checked by part 1 before it is added
(`examine`, then `commit`), and a failing declaration leaves the environment unchanged.

Rules are checked to preserve types under their declared variables (`add_rule`); linearity,
bracket scoping and "rules only on this room's symbols" are checked in `rule_lhs`.

## 3. Native inductive types — trusted

A `type` declaration adds new theory, so it has its own obligations beyond term checking.

| Obligation | Where | Tests |
|---|---|---|
| Constructors build the type at its own (uniform) parameters; the type is absent from its own indices | `checker.almd`: `admissible` | "constructors build the type itself…" |
| Strict positivity | `checker.almd`: `positive` | "a type in a negative position is rejected…" |
| Constructor arguments fit the type's universe (unless it is a proposition) | `checker.almd`: `admissible` | "constructor arguments must fit…" |
| Elimination from Prop into larger universes only for subsingletons; K only for propositions with one argument-free constructor | `checker.almd`: `admissible` → `Plan` | "propositions eliminate into Type only when…" |
| The recursor and its computation rules follow the standard schema | [src/inductive.almd](../src/inductive.almd): `eliminator`, `iota`, `k_rule` | "an inductive type gets a recursor that computes" |
| Record projections are defined, not assumed (by a match, so they are checked like any def) | `inductive.almd`: `projections` | "records: …" |
| All or nothing: a rejected type is rolled back | `checker.almd`: `process`, `rollback` | "…and leaves nothing behind" |
| Nested types: an occurrence inside another type's parameters (`List(Rose)`) is allowed only in a type without indices, at arguments depending only on the outer parameters; the type must stay strictly positive in every constructor of that type at those arguments, and the occurrences found there are followed in turn | `checker.almd`: `positive`, `nested_occurrence`, `nested_closure`, `occurrence_ctors` | "a type nested in a negative position…" |
| Nested types: a motive per occurrence, a minor per constructor of the type and of each occurrence, one recursor per occurrence (`T.rec_k`), the rules computing each on its constructors | `checker.almd`: `arg_kind`, `nested_layout`; `inductive.almd`: `nested_eliminator` | "a nested type gets a recursor…", "nesting goes through several levels…" |

The generated constructors, recursor and rules are then checked by part 1 like any declaration.
That retyping establishes that each rule preserves types; it does **not** establish
admissibility or that the generator emitted the intended schema. Those rest on `admissible` and
`inductive.almd`, which are therefore in the trusted base and are the main audit target for this
feature. Nested types follow Lean's reading: they are admitted when the equivalent mutual group
(the type, and a copy of each type it is nested in, specialised to its arguments) would be, and
their recursor is that group's, with the copies replaced by the real types. `T.cases`, the case
split used by `match`, is defined from the recursor and checked, not assumed. Mutual types are not
handled here at all: see part 4.

In `axioms`, symbols generated by `type` declarations are listed under `types: … (from type
declarations)`, apart from hand-declared `symbols:` and `rules:`. The listing says what a result
uses; it does not certify that those declarations are admissible — that is the job of the
checks above.

## 4. Elaboration and pattern matching — not trusted

[src/elab.almd](../src/elab.almd) (implicit arguments, universe levels, `_` holes, field access,
record values) and [src/patterns.almd](../src/patterns.almd) (`match` compiled to recursors) produce
ordinary terms that go through part 1. A wrong inference or a wrong compilation is a type error,
never a false theorem; a term with unresolved holes is rejected (by `elab.complete`, and again by
the kernel). Structural recursion is enforced by construction: a `match` only produces recursor
applications, and a recursive call that is not on a constructor argument has no translation.

Mutual types and mutually recursive functions ([src/mutual.almd](../src/mutual.almd)) add
nothing either. A group of types is encoded as one indexed family, which is admitted by part 3 like
any other type. Its types, constructors and recursors, and the single definition a group of
functions becomes, are ordinary definitions, checked by part 1. A wrong encoding fails to check;
it cannot make a false theorem true. Functions over a nested type (`add_nested_defs`) are compiled to
applications of its recursors, likewise checked by part 1.

Well-founded recursion (`decreasing x by W`, `checker.add_wf_def`) adds nothing: a definition
becomes a `step` definition and an application of `fix`, which [lib/std/wf.arlk](../lib/std/wf.arlk)
defines from the recursor of `Acc`; both, and the unfolding law, are checked by part 1. The
elaborator also accepts two proofs of one proposition as equal (`elab.proofs_agree`, asking the
kernel's `irrelevant_eq`), which only helps it find terms the kernel then checks.

## 4a. Proof search — not trusted

`search` ([src/search.almd](../src/search.almd)) only proposes a term; the declaration is then
checked by part 1 like a written proof (`check` in `checker.examine`). It uses only hypotheses
in scope and the lemmas listed, and adds no declarations.

## 4b. Views and translation — not trusted

`view` and `translate` ([src/checker.almd](../src/checker.almd): `add_view`, `carry`,
`carry_decl`, `translate`) check each image against its symbol's translated type and each source
rule by conversion, and every carried definition and theorem is checked again by part 1 before
it is added. A wrong view or a wrong translation is a type error; the result of `translate`
rests on the target room's assumptions (which `axioms` lists), not on the source's.

## 5. Assumptions a result is relative to — not established by Arlk

* **Hand-declared `symbol`s and `rule`s**, including user rewrite rules (no confluence,
  termination or full subject-reduction check), declared `irrelevant` types, and `structure`
  declarations (every value of S is its constructor applied to its projections; checked only in
  that the names are this room's symbols, the constructor builds S, and each projection computes
  to its field). They appear in `axioms`. `arlk absorb` declares a structure for each Lean
  constructor all of whose projections it exports, as Lean's kernel has eta for every structure.
* **Imported theories.** [lib/core.arlk](../lib/core.arlk) (the shared foundation for Lean and Rocq),
  the absorbed Lean/Rocq libraries' symbols and rules, Metamath's axioms and the `Apart`/`fresh`
  facts about Metamath syntax, and for HOL [lib/hol.arlk](../lib/hol.arlk) (HOL's inference rules as
  symbols, `trans` and `sym` proved from them), the axioms an OpenTheory article assumes and the
  type definitions it makes (a symbol for the type, its bijections and their two axioms, each
  next to a checked proof that the defining predicate is inhabited). A check of an absorbed library is relative to these; that the
  emitted declarations faithfully encode the source logic, and that an emitted statement means
  what the source statement means, are separate obligations (issue #5). The exporters
  (tools/lean-export, tools/rocq-export) and `arlk absorb`/`absorb-mm`/`absorb-hol`/`absorb-agda` only
  produce text. `absorb-agda` ([src/agda.almd](../src/agda.almd)) reads Agda source, not Agda's
  checked terms: its output is ordinary types and definitions, so it rests on no assumption at
  all, and whether it means what the Agda module means is the translation's obligation (Agda
  accepting the source, tools/agda-export/check.sh, is evidence, not proof). In particular the OpenTheory reader ([src/hol.almd](../src/hol.almd)) is not trusted: it
  runs the article and writes proofs, lemmas, term abbreviations (checked `def`s) and constant
  definitions (checked `def`s); a mistake there is a type error, not a theorem. The statement of an
  exported HOL theorem is written from the article's own `thm` command, and its HOL meaning rests
  on the encoding in lib/hol.arlk (a HOL term of type `a` is a value of `Tm(a)`, a theorem
  `Γ ⊦ φ` is a function from proofs of `Γ` to a proof of `φ`).

## 6. Below Arlk

The Almide compiler and its Rust backend, and the Rust toolchain and OS, run all of the above.
Arlk works around known Almide code-generation bugs (listed in the README); a miscompile in the
kernel could make two different terms compare equal (almide/almide#3405 was one such bug, worked
around in `conv`). The test suite exercises the checker on good and bad proofs; it does not prove
the compiler correct.

## 7. Proof bundles

`arlk bundle` and `arlk replay` ([src/bundle.almd](../src/bundle.almd), src/main.almd) add nothing
to the trusted base: replay checks the bundled sources again with parts 1–3 and recomputes every
fact it compares. What a bundle's hashes establish is *identity*: the same sources, the same
claim, the same dependencies and assumptions, the same checker semantics. They do not establish
*fidelity*: that an absorbed library encodes its source logic faithfully, or that a statement means
what its author intended (part 5). A bundle whose hashes all match can still be about the wrong
statement; reading the claim and its assumption inventory is still the reader's job.

## 8. Almide programs

A result about an Almide program ([docs/ALMIDE_SUBSET.md](ALMIDE_SUBSET.md)) rests, beyond parts
1–3, on the translator [src/almide_src.almd](../src/almide_src.almd): that it reads the subset as
Almide does and maps each construct to its meaning in [lib/almide.arlk](../lib/almide.arlk). The
model records the program's SHA-256 and bytes, and `absorb-almide --verify` re-derives it. Such a
result is about the program's meaning in the subset's semantics, not about compiled code.

## 9. Packages

`arlk package` and `arlk project` ([src/package.almd](../src/package.almd),
[docs/PACKAGES.md](PACKAGES.md)) add nothing to the trusted base either. A manifest is data. Every
source it names is hashed and checked again with parts 1–3, and every identity it pins (claims,
views, assumption footprints) is recomputed and compared. A populated environment is never loaded
from anywhere. Identities print every name fully qualified, so a claim's identity does not depend
on the room the environment is in when it is computed. What a matching package establishes is the
identity of part 7, nothing more. The allowed-room policy of a project is a filter on the assumption
inventory, which is computed by the same dependency walk as `axioms`.
