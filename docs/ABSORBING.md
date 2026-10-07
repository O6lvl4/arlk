# Absorbing prover libraries

What Arlk takes from each system, natively and when absorbing it, and what is missing:
[docs/COVERAGE.md](COVERAGE.md).

```
tools/lean-export/Export.lean      Lean side: a declaration (or module) and its dependencies as JSON
tools/rocq-export/                 Rocq side: a plugin, `Arlk Export "out.json" name...`
arlk absorb EXPORT.json -o F       Arlk side: turn that JSON into Arlk source
arlk check lib/core.arlk F         check it; neither prover is involved
```

```
$ ./arlk check lib/core.arlk absorbed/lean/nat_add_zero.arlk
✓ theorem Init.Nat.add_zero: core.El(core.l0, core.pi(core.l1, core.l0, Nat, (n: core.El(core.l1, Nat)) => Eq@1(Nat, HAdd.hAdd@0@0@0(..., n, OfNat.ofNat@0(Nat, Nat.zero, ...)), n)))

$ ./arlk check lib/core.arlk absorbed/rocq/init_peano.arlk
✓ theorem Corelib.Init.Peano.plus_n_O: core.El(core.l0, core.pi(core.l1, core.l0, Init.Datatypes.nat, (n: ...) => Init.Logic.eq@1(Init.Datatypes.nat, n, Init.Nat.add(n, Init.Datatypes.nat.O))))
```

### The shared foundation

[lib/core.arlk](../lib/core.arlk) is the trusted theory both provers are translated into, written by
hand to be read. A universe level is a value of `Lvl`, the types of universe `l` are values of
`Univ(l)`, `El(l, A)` turns one into an Arlk type, and function types are values `pi(a, b, A, B)`
that a rule unfolds into Arlk function types. Level 0 is `Prop`, level 1 is Lean's `Type` and
Rocq's `Set`.

| Feature | Comes from | In Arlk |
|---|---|---|
| Impredicative `Prop` | both | `imax`: a function type into level 0 is at level 0 |
| Cumulative universes | Rocq | `lift(a, b, A)` moves a type up; the Rocq exporter inserts it wherever Rocq's kernel used subtyping |
| Definitional proof irrelevance | Lean | `irrelevant El(lz, P)  where P: Univ(lz)` |

Having both is consistent: Rocq with proof irrelevance and Lean with cumulativity both hold in
the set-theoretic model with inaccessible cardinals. Each one shows up in `axioms` when a theorem
uses it.

### Lean

| Lean kernel feature | How it is absorbed |
|---|---|
| Inductive types, recursors | symbols, and one rewrite rule per constructor |
| K-like reduction (`Eq.rec` on any proof of `a = a`) | a rule whose major premise is a variable; proof irrelevance makes it type-check |
| Quotients (`Quot.lift`, `Quot.ind`) | rewrite rules; `Quot.sound` stays an axiom |
| Projections, including into `Prop` | one rule per projection function |
| Universe polymorphism | not yet: each constant is instantiated at the levels it is used at (`Eq@1` is `Eq.{1}`) |

### Rocq

| Rocq kernel feature | How it is absorbed |
|---|---|
| Universe variables with constraints | numbered by the longest path from `Set` in Rocq's universe graph, which satisfies every constraint |
| Template polymorphism (`eq`, `prod`, `sig`, ...) | one instance per level its arguments live at (`eq@1` on `nat`), `Prop` when Rocq lowers it there |
| Monomorphic constants and inductives over sorts (`eq_trans (A : Type@{u})`, `PER`) | the same: an instance per level of their arguments (`eq_trans@1`), so a lemma used on `nat` states facts about `eq@1` |
| Universe-polymorphic constants | one instance per universe instance (`Unconvertible@1`) |
| `match` | the inductive's case eliminator at the motive's level (`nat.case@1(P, b_O, b_S, n)`), one rule per constructor, so matches with convertible branches are convertible, as in Rocq |
| `fix`, including over indexed families | lambda-lifted symbols whose rules fire only on a constructor, as Rocq's guard condition expects |
| Cumulativity | explicit `lift`, computed in the encoding's own level arithmetic |
| `SProp`, primitive projections, cofixpoints, primitive integers | not yet |

### Metamath

`arlk absorb-mm set.mm --upto LABEL` reads a Metamath database directly; no export step and no
Metamath tool is involved.

| Metamath | In Arlk |
|---|---|
| Typecodes `wff`, `setvar`, `class` | types |
| `\|- φ` | the type `Prf(φ)` |
| Syntax axiom `wi $a wff ( ph -> ps ) $.` | constructor `symbol wi(ph: wff, ps: wff) -> wff` |
| Logical axiom with hypotheses (`ax-mp`) | `symbol ax_mp(ph: wff, ps: wff, min: Prf(ph), maj: Prf(wi(ph, ps))) -> Prf(ps)` |
| Theorem and its proof (normal or compressed) | `theorem a1i(ph: wff, ps: wff, a1i_1: Prf(ph)) -> Prf(wi(ps, ph)) = ax_mp(...)` |
| Math strings | parsed with the database's own syntax axioms |
| `$d x ph` distinct-variable conditions | a parameter `dv_ph_x: Apart_wff_setvar(ph, x)` that every use must prove; the proof is built from the user's own `$d` facts and facts about syntax (`apart_*` per constructor, symmetry), so a use that identifies variables has no proof |
| Dummy variables | with `$d` conditions: chosen fresh (`fresh_setvar(...)`, apart from what they must avoid); without: replaced by a variable of the same typecode |
| Includes `$[ file $]` | inlined (once each), as Metamath specifies |

Status of `$d`: regression-tested on small fixtures whose verdicts were cross-checked with the
reference verifier mmverify.py ([spec/fixtures/metamath](../spec/fixtures/metamath)): obligations in
normal and compressed proofs, setvars named with punctuation, fresh dummies, and rejection of a
missing `$d`, of a use collapsing two distinct variables and of an unconstrained dummy. For large databases,
`arlk chunk setmm.arlk --part K/N` writes part K of N, which
proves its share of the theorems and assumes the earlier ones by their exact statements, so all N
parts passing means every theorem was checked once (docs/TRUST.md, "Checking in parts").
[.github/workflows/setmm.yml](../.github/workflows/setmm.yml) does this daily in parallel, and
checks that the parts cover every theorem. See [docs/COVERAGE.md](COVERAGE.md#recorded-results)
for the pinned databases and recorded coverage. The `Apart_*`, `apart_*` and `fresh_*` declarations are
assumptions about Metamath's syntax that `axioms` lists, like the database's own axioms.

Metamath's definitions (`df-an`, `df-bi`, ...) are axioms there, and they stay symbols here, so
`axioms` lists exactly the ones a theorem depends on.

### HOL (via OpenTheory)

OpenTheory is the proof exchange format of the HOL family. An *article* is a program for a stack
machine whose commands build types, terms and theorems with HOL's primitive inference rules.
`arlk absorb-hol` is an article reader written in Almide ([src/hol.almd](../src/hol.almd)): it runs the
article itself and writes down, for every theorem, a proof over [lib/hol.arlk](../lib/hol.arlk). No
HOL system and no OpenTheory tool is run; [tools/opentheory/fetch.sh](../tools/opentheory/fetch.sh)
only downloads the packages, which CI pins by checksum.

| HOL | In Arlk |
|---|---|
| Types, terms of type `a` | `Ty`, `Tm(a)`, with the rule `Tm(arr(a, b)) = Tm(a) -> Tm(b)`, so HOL's λ, application, β and α are Arlk's own |
| A theorem `Γ ⊦ φ` | a proof of `Prf(φ)` under one variable per hypothesis (hypotheses are numbered up to α); `assume` is a variable, discharging is a λ |
| `refl`, `appThm`, `absThm`, `eqMp`, `deductAntisym` | the symbols `refl`, `mk_comb`, `abs`, `eq_mp`, `deduct_antisym` of room `hol` |
| `trans`, `sym`, `betaConv`, `proveHyp` | theorems proved in room `hol`, conversion, and application |
| `subst` (types, then terms) | the proof, abstracted over its type variables, variables and hypotheses, applied to the instances; bound variables are renamed as HOL renames them |
| `defineConst`, `defineConstList` | a checked `def`; the defining theorem is reflexivity |
| `defineTypeOp` | symbols for the type and its two bijections with their two axioms (HOL's principle of type definition), next to a checked proof that the defining predicate is inhabited |
| `axiom` | the theorem of an earlier article with that statement, or else a reported symbol |
| A theorem the article keeps (`def`) | a lemma, checked once |
| A large term (articles share terms, text does not) | a `def` over its free variables, one per α-class, unfolded by the kernel when needed |

A name a later article defines again (HOL Light's `recspace`) is a new constant or type: the reader
keeps definitions apart by identity, not by name.

```
$ tools/opentheory/fetch.sh base-1.221 otlib > order.txt
$ ./arlk absorb-hol $(cat order.txt) -o base.arlk
$ ./arlk check lib/hol.arlk base.arlk
✓ theorem opentheory.bool_class.thm1: hol.Prf(Data.Bool.forall(hol.bool, (t_7: hol.Tm(hol.bool)) => Data.Bool.or(t_7, Data.Bool.not(t_7))))
...
```

What the base library rests on (`axioms` on any of its theorems): room `hol`, HOL's three axioms
(extensionality, choice and infinity, which the articles assume and the reader reports as
`axiom_*.axiom*` symbols), and the type definitions (the new types with their `abs_rep`/`rep_abs`
axioms, each next to its checked `nonempty` theorem).

### Agda

Agda's checked terms are not exported (that needs a Haskell backend); instead `arlk absorb-agda`
([src/agda.almd](../src/agda.almd)) reads an Agda module's source, in a subset (`data` with
parameters and indices, `record` with `open`, `infix` declarations, signatures with implicit
arguments, clauses by pattern matching with absurd patterns `()` and `with`, binary mixfix
operators, `λ`, `Set`), and writes the same development as Arlk types and definitions: clauses
become a case tree of `match`es (an absurd clause leaves its arm out, for Arlk's match to find
impossible; `with e` becomes `match e`), a record becomes a type with one constructor and a
projection per field, `_+_` becomes `plus`, implicit arguments are inferred at uses. The emitted native proofs are checked by Arlk. This checks the translated statements,
not that the source-to-Arlk translation preserves their intended meaning. [tools/agda-export/check.sh](../tools/agda-export/check.sh) runs Agda on the source when it is
installed, regenerates the translation and checks it, and checks that a wrong proof in the source
is rejected. [examples/agda_transport.arlk](../examples/agda_transport.arlk) uses Agda's `+-comm` to
prove Arlk's own `nat.add_comm` again, through the isomorphism of the two naturals.

```
$ ./arlk absorb-agda absorbed/agda/Arith.agda -o absorbed/agda/arith.arlk
$ ./arlk check absorbed/agda/arith.arlk
```

A `coinductive` record becomes Arlk `codata`, and a definition by copatterns (`head (from n) = n`,
`tail (from n) = from (suc n)`) becomes corecursion with the changing argument as the seed.
[absorbed/agda](../absorbed/agda) contains `Arith` (naturals, lists, equality and their laws),
`Order` (`_≤_`, absurd patterns), `Records` (projections, `open`, `with`), `Streams`
(coinductive records and copatterns), and `Rewriting` (`rewrite`, `let`, point-free clauses
and `where` helpers). Supported source features and recorded checks are listed in
[docs/COVERAGE.md](COVERAGE.md#agda).

### Isabelle/HOL

`arlk absorb-isabelle` ([src/isabelle.almd](../src/isabelle.almd)) reads an Isabelle theory's source,
in a subset (`datatype` with type variables, `fun`/`primrec`/`definition` by equations,
`lemma`s stating equations, `[simp]`, `declare`, Main's `nat` and `'a list` with `0`, `Suc`,
numerals, `+`, `*`, `#`, `@`, `[a, b]`, `rev`, `length`, `map`), and writes Arlk types, definitions
and theorems; the variables' types are found by unification, as Isabelle does. Main's fragment is
itself absorbed from Isabelle equations into [lib/isabelle_main.arlk](../lib/isabelle_main.arlk)
(`arlk absorb-isabelle --main`), with the `[simp]` lemmas of Main that proofs rely on, each proved
by Arlk's simp; a theory's own function of the same name shadows Main's.
A lemma's proof is its Isabelle proof method replayed by Arlk's own `simp`: `by (induction xs)
auto` becomes `by induction xs simp(...)` with the lemmas marked `[simp]` so far and those given by
`simp add:` (Main's `add.commute` included); every function's equations are used, as in
Isabelle. `arbitrary:` needs nothing more (the variables after the induction variable are
generalised in its hypothesis), an equational premise (`xs = ys ⟹ ...`) becomes a hypothesis that
simp rewrites with, and a structured Isar proof (`proof (induction xs) case Nil ...
next ... qed`) is replayed the same way, from its induction and the lemmas it adds. In
`proof - ... qed`, each `have` (labelled or not, with `for x` to generalise) is a theorem of its
own proved by its method, a chain `also have "... = c"` reads `...` as the previous step's
right-hand side, and `show ?thesis` is simp with every step. A method that Arlk's `simp`
cannot replay is a failed check. The resulting proof is checked in Arlk; the correspondence
between the source statement and the translated statement remains a separate obligation. Equality is Arlk's native one (lib/std/eq.arlk), not lib/hol.arlk's encoding: the HOL
room reads OpenTheory articles (proofs in HOL's own rules), this one reads Isabelle source (proofs
re-found by rewriting). [tools/isabelle-export/check.sh](../tools/isabelle-export/check.sh) runs
Isabelle on the theory when it is installed, regenerates the translation, checks it, and checks
that a false lemma is rejected.

```
$ ./arlk absorb-isabelle absorbed/isabelle/Lists.thy -o absorbed/isabelle/lists.arlk
$ ./arlk check lib/std/eq.arlk lib/isabelle_main.arlk absorbed/isabelle/lists.arlk
✓ theorem isabelle.Lists.total_rev: (xs: isabelle.Main.list(isabelle.Main.nat)) -> eq.Eq[1](isabelle.Main.nat, total(isabelle.Main.rev(isabelle.Main.nat, xs)), total(xs))
```

[absorbed/isabelle](../absorbed/isabelle) holds `Arith` (its own naturals and sequences) and `Lists`
(Main's lists and numbers, `itrev` by generalised induction, `total_rev` by an Isar proof with
`add.commute`); Isabelle2025-2 accepts both, and both check in full.

## What a successful check means

Arlk checks the emitted proof terms without running Lean, Rocq
or a Metamath verifier, and the exporters and `arlk absorb` are not part of that check: they only
produce text. But they produce *theory* as well as proofs: symbols for inductive types and
constructors, rewrite rules for recursors, projections and matches, Metamath's axioms, and the
`Apart`/`fresh` facts about Metamath syntax. A check is relative to those emitted assumptions, which
`axioms` lists. Two things are separate obligations, not established by the check:

- that the emitted symbols and rules faithfully encode the source logic (for example, that a
  recursor rule is the one Lean's kernel has), and
- that an emitted statement means what the source statement means.

Today these rest on reading the exporters and the emitted files, which are plain text for that
reason. The tests in `spec/absorb_test.almd` and `spec/metamath_test.almd` show that the check
itself bites: a false statement is rejected, deleting one rule breaks a Lean proof (it really
computes through Lean's definitions of `+` and `0`), lifting Rocq's `nat` *down* a universe is
rejected, and a Metamath theorem with a changed statement or a missing hypothesis is rejected.
Stronger certification is on the roadmap: checked schemas for inductive types and their recursors
(so an emitted recursor rule is derived, not assumed), and further checked interpretations between source theories. Existing views are described in
[docs/VIEWS.md](VIEWS.md).
