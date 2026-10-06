# Arlk(アルク)

A small proof language and checker written in [Almide](https://github.com/almide/almide).

Arlk aims to be a **logic translator with a trusted core**. The kernel is small, and different
logics live in separate *rooms* on top of it. The checker always tells you which assumptions
a theorem actually rests on.

Arlk is meant for programmers, not only mathematicians. **It reads like Almide**: declarations look
like function signatures, a call is `f(a, b)`, a function is `(x: A) => body`, a function type
is `(x: A) -> B`. Unicode is only an optional alias, and errors say what was expected and what
was found.

**Lean 4, Rocq, Metamath and HOL are absorbed, not linked, and Lean and Rocq meet in one place.**

- Lean's whole `Init.Data.Nat.Basic` module (308 of its 310 theorems, 823 declarations with their
  dependencies) is translated into Arlk source and checked by Arlk's kernel alone.
- Rocq's `Corelib.Init` (Logic, Datatypes, Peano, Nat, Specif, Wf: 969 of 973 declarations) is
  checked the same way.
- Metamath's `set.mm`: its whole propositional calculus (1776 theorems, from `ax-mp` to `stoic4b`)
  is read straight from the database, proofs included, and checked by the same kernel.
- HOL, the logic of HOL Light, HOL4 and Isabelle/HOL: OpenTheory's whole standard library
  (`base-1.221`: 95 articles, 2.7 million proof commands, from Booleans through lists, natural
  numbers and the reals) is run by Arlk's own article reader and checked by the same kernel, with
  1340 theorems proved and only HOL's three axioms assumed.
- One logic can be read in another by a checked *view*. HOL read in Arlk's own type theory carries
  HOL's proof of excluded middle into a native theorem, `em(p: Sort(0)) -> Or(p, Not(p))`, that
  rests on exactly Lean's classical axioms (function and propositional extensionality, choice).
- Lean and Rocq sit on one shared foundation, [lib/core.arlk](lib/core.arlk). That foundation has Rocq's
  cumulative universes *and* Lean's proof irrelevance, so a single proof can use both libraries.
  [examples/bridge.arlk](examples/bridge.arlk) turns Lean's theorem `Nat.add_comm` into a statement
  about Rocq's equality on Rocq's numbers.

See [Absorbing provers](#absorbing-provers) and [The bridge](#the-bridge).

```
room logic

symbol Prop: Type
symbol Prf(p: Prop) -> Type
symbol imp(a: Prop, b: Prop) -> Prop
rule Prf(imp(a, b)) = Prf(a) -> Prf(b)  where a: Prop, b: Prop

// Thanks to the rule, a proof of an implication is just a function.
theorem s(a: Prop, b: Prop, c: Prop) -> Prf(imp(imp(a, imp(b, c)), imp(imp(a, b), imp(a, c)))) =
  (f: Prf(imp(a, imp(b, c))), g: Prf(imp(a, b)), x: Prf(a)) => f(x, g(x))

axioms s
```

```
$ arlk check examples/logic.arlk
✓ theorem logic.s: (a: Prop, b: Prop, c: Prop) -> Prf(imp(imp(a, imp(b, c)), imp(imp(a, b), imp(a, c))))
axioms logic.s
  rooms:   logic
  symbols: logic.Prop, logic.Prf, logic.imp
  rules:   [logic:11] Prf(imp(a, b)) = Prf(a) -> Prf(b)
```

## Design

| Layer | What it is |
|---|---|
| **Kernel** | The λΠ-calculus modulo rewriting, the same core as Dedukti/Lambdapi. It has de Bruijn terms, β/δ/rule reduction, η-aware conversion (functions and records) with lazy unfolding, declared proof irrelevance, and bidirectional type inference. |
| **Rooms** | Namespaces that hold one theory each: its symbols, definitions, rules and theorems. A room sees only the rooms it `uses` (transitively). **Rooms are sealed once left**, so no later room can add rules to an earlier one's symbols. |
| **Rules** | Rewrite rules may only extend symbols of the *current* room. Each rule is type-checked (left and right sides must have convertible types under the declared variable types). A pattern may contain `{t}`: a subterm that is not matched but checked by conversion, so typing can fix it. |
| **Dependency tracking** | `axioms name` walks everything a theorem uses through defs and theorems. It reports the symbols assumed, the rules relied on, and the rooms involved. |

Why these choices are explained in the design discussion behind this project: a strongest checker
cannot merge every logic into one, because some foundations contradict each other (for example
univalence vs UIP). It can keep each logic in its own room, build bridges between rooms, and
always say which room a result depends on.

## Language

```
room NAME                              start a room (sees nothing)
room NAME uses A, B                    start a room that sees A, B and what they see

symbol f(x: A, y: B) -> T              assume a constant (opaque); also `symbol c: T`
def f(x: A) -> T = body                a definition (unfolds during conversion); also `def c: T = t`
theorem f(x: A) -> T = proof           a checked proof (opaque afterwards)
rule lhs = rhs  where x: A, y: B       a rewrite rule on a symbol of this room
                                       ({t} in lhs: must be convertible to t, not matched)
irrelevant T  where x: A               values of T are all equal (definitional proof irrelevance)
type T(params) = | c(x: A) ...         an inductive type (see below); `type P = { x: A }` a record
codata T(params) = { x: A, r: T(...) }  a coinductive type: infinite values, built by T.corec
view V from S { sym = t, ... }         read room S here: each symbol of S as a term of this room
translate V name                       carry name (from a room built on S) here along V, checked again
view V from S via v1, v2               compose two views (S read in R by v1, R read here by v2), checked
views                                  list the views: mapped and carried symbols, what each rests on
routes from S                          list the ways (at most two views) from S into this room
theorem t(...) -> T = search(l, ...)   find a proof (bounded search), print it, check it like a written one

check t                                print the type of t
eval t                                 print the normal form of t
axioms c                               print what c depends on
```

Terms:

```
Type                                   the sort of types
(x: A, y: B) -> C                      dependent function type
A -> B    (A, B) -> C                  non-dependent function types
(x: A, y: B) => t                      function
f(a, b)   f(a)(b)                      call (the same thing)
match x { c(a) => t, _ => u }        pattern matching (structural recursion), see below
{ let h: A = e  let k = e'  t }      a block: named steps of a proof (like Isar's `have`)
_                                      a hole the elaborator fills
?                                      an open goal: checking stops and shows its type, its context,
                                       and a visible theorem that closes it if a quick search finds one
logic.Prf                              a qualified name (another room's symbol)
Nat.add   Eq@1                         names may contain dots and @ (absorbed names use both)
// comment
```

Unicode aliases: `→` for `->`, `⇒` for `=>`. Declarations need no terminator: each one starts with
its keyword.

An unknown name is reported with the visible names spelled almost the same (`did you mean add_zero?`)
or the rooms that declare it (`add uses nat`).

## Universes, inductive types and inference

Arlk's kernel has its own universe hierarchy and inductive types, implemented in Almide, not
borrowed from a prover. They are the core of Lean's, Rocq's and Agda's kernels:

```
// Sort(0) is Prop (impredicative, proofs irrelevant), Type is Sort(1), Type(u) is Sort(u + 1).
// Universe parameters and implicit parameters go in [...], like Almide's generics.
def id[u, A: Sort(u)](x: A) -> A = x

type Nat: Type =
  | zero
  | succ(n: Nat)

type Eq[u](A: Sort(u), a: A): (b: A) -> Sort(0) =
  | refl: Eq(A, a, a)

type List[u](A: Type(u)): Type(u) =
  | nil
  | cons(head: A, tail: List(A))

// Almide's match: compiled to the recursor, structural recursion only.
def map[u, v, A: Type(u), B: Type(v)](f: A -> B, xs: List(A)) -> List(B) = match xs {
  nil => List.nil,
  cons(h, t) => List.cons(f(h), map(f, t)),
}

def add(m: Nat, n: Nat) -> Nat = match n {
  zero => m,
  succ(k) => Nat.succ(add(m, k)),
}

theorem one_plus_one: Eq(Nat, add(Nat.succ(Nat.zero), Nat.succ(Nat.zero)), Nat.succ(Nat.succ(Nat.zero))) = Eq.refl

// A theorem proved by match is a proof by induction: zero_add(k) is the hypothesis for k.
theorem zero_add(n: Nat) -> Eq(Nat, add(Nat.zero, n), n) = match n {
  zero => Eq.refl,
  succ(k) => cong(Nat.succ, add(Nat.zero, k), k, zero_add(k)),
}
```

**Inductive types.** A `type` declaration gives the type former, its constructors (`Nat.succ`),
the recursor (`Nat.rec`) and one computation rule per constructor. Before anything is added the
kernel checks that the type is admissible: constructors build the type at its own parameters, the
type occurs only strictly positively, arguments fit the type's universe, and a proposition
eliminates into `Type` only when it is a subsingleton (`And`, `Eq`, `False` may; `Or`, `Exists` may
not, exactly as in Lean). Propositions with one argument-free constructor (`Eq`) also get K-style
computation. The generated recursor and rules are then checked by the kernel like any
declaration, and a rejected type leaves nothing behind.

**Pattern matching.** A definition whose body is `match x { ... }` on one of its parameters is
compiled to x's recursor (src/patterns.almd): each arm becomes a minor premise, and a recursive
call on an argument the arm took apart becomes the induction hypothesis. Anything else that calls
the definition is rejected, so definitions always terminate. Parameters after the matched one may
change in recursive calls (an accumulator) and travel through the motive. Arms may use short
constructor names and `_` for the rest; a missing case is an error.

Patterns nest (`succ(succ(m)) => m`), arms are tried in order, and an arm's body may itself be a
`match` on any variable in scope; both become case splits by the inner type's recursor, with the
arm's own type as the motive (pattern-matrix compilation, as in Agda and Lean). Recursion stays
structural on the fields the definition's match takes apart, so `le(m, n)` matching both arguments
works, while `even` recursing two constructors deep is refused (it needs course-of-values
recursion, not there yet). A parameter of an indexed family (`xs: Vec(A, n)`) can be matched when
its indices are parameters before it: the motive generalises them, and a recursive call passes the
field's own index (`vmap(f, m, rest)`). Indices may also be constructor patterns over such
parameters, as in Agda; a constructor whose indices clash with them needs no arm:

```
def tail(A: Type, n: Nat, v: Vec(A, Nat.succ(n))) -> Vec(A, n) = match v {
  cons(_, x, xs) => xs,                  // nil is impossible: its index is zero
}
theorem not_succ_le_zero(m: Nat, h: Le(Nat.succ(m), Nat.zero)) -> False = match h {
}
```

The motive inverts the index patterns by cases (small inversion), so this adds nothing to the
kernel. A constructor whose index is a variable where the pattern has a constructor, or a variable
that occurs twice in the patterns, is refused with a message (it would need equations).

**Records.** `type Point = { x: Nat, y: Nat }` is a type with one constructor `Point.mk` and a
projection per field, defined by a match; a field's type may mention earlier fields
(`type Sigma[u, v](A: Type(u), B: A -> Type(v)): Type(max(u, v)) = { fst: A, snd: B(fst) }`).
As in Almide, `p.x` reads a field and `Point { x: a, y: b }` builds a value.

**Coinductive types.** `codata Stream(A: Type) = { head: A, tail: Stream(A) }` declares infinite
values whose fields may be the type again (streams, infinite trees with several such fields). It is
defined, not assumed (src/codata.almd): a value is what each path down through its recursive fields
leads to (`Stream.Path`), `Stream.corec(h, t, seed)` builds one from a seed and a step per field, and
the destructors compute on it, so `Stream.tail(Stream.corec(h, t, s))` is `Stream.corec(h, t, t(s))`
by conversion. Bisimilar values are equal by function extensionality:
[examples/std/stream.arlk](examples/std/stream.arlk) proves the coinduction principle by induction on
paths and uses it for `map(id, s) = s`.

**Proof search.** `theorem t(...) -> T = search` or `search(lemma, ..., depth: n)` looks for an
ordinary proof term (src/search.almd): it introduces function types, and applies hypotheses (most
recent first) and the listed lemmas, matching their conclusions with the goal and searching for the
proofs they need. It only searches for proofs: a value that matching does not fix (a middle point,
a number) is reported as a side goal, never guessed. It never uses a lemma that was not listed and
never adds anything. The result is printed (`✓ found by search: compose = ... => g(f(h))`), so it
can replace the `search`, and it is checked by the kernel like a written proof. A failure is
reported as inconclusive within the budget, not as a proof that no proof exists.

**Rewriting: `by simp`.** Isabelle's `simp`, for equations:

```
theorem add_zero(n: Nat) -> Eq(Nat, add(n, Nat.zero), n) = by induction n simp
theorem add_comm(m: Nat, n: Nat) -> Eq(Nat, add(m, n), add(n, m)) = by induction m simp(add_zero, add_succ)
```

`by simp(l1, ...)` proves an equation by rewriting both sides, innermost first, with the listed
equations, the equations in scope (an induction hypothesis among them) and the cases of every
definition it meets (`add(succ(k), n) = succ(add(k, n))`, read back from the definition), until
nothing applies; the results must then be convertible. A rule whose sides differ only by the order
of their variables (`add(m, n) = add(n, m)`) is used only when it makes the term smaller in a fixed
order, as Isabelle does, so it cannot loop. `by induction x simp(...)` is a `match` on x with that
proof in every case. The proof is an ordinary term built from `cong`, `trans` and `symm` over the
equality's recursor (src/simp.almd), checked by the kernel; a failure shows what each side
rewrote to.

**Inference.** The elaborator (src/elab.almd) fills in implicit arguments, universe levels and `_`
holes by unification (higher-order patterns with pruning, first-order approximation, postponed
equations, as in Lean and Agda): `List.cons(x, xs)` is
`List.cons[0](Nat, x, xs)`, `Eq.refl` finds its type and value from the statement. The elaborator
is not trusted: its output is a complete kernel term, checked like a hand-written one, so a wrong
inference is a type error, never a false theorem. What it cannot infer it reports. See
[examples/data.arlk](examples/data.arlk).

**Mutual types and functions.** Types that refer to each other are written one after the other,
as in Almide, and so are the functions on them:

```
type Tree: Type =
  | node(x: Nat, kids: Forest)
type Forest: Type =
  | nil
  | cons(t: Tree, rest: Forest)

def tree_size(t: Tree) -> Nat = match t {
  node(x, kids) => Nat.succ(forest_size(kids)),
}
def forest_size(f: Forest) -> Nat = match f {
  nil => Nat.zero,
  cons(t, rest) => add(tree_size(t), forest_size(rest)),
}
```

A group of types is encoded as one family indexed by which type is meant, which is the standard
reduction ([src/mutual.almd](src/mutual.almd)). The family goes through the usual admission:
strict positivity across the whole group, universes, and elimination. Each type, constructor and
mutual recursor (`Tree.rec` takes a motive per type and a minor per constructor) is a generated
definition that the kernel checks, and the recursors compute. A group of functions becomes one
structurally recursive definition on the family, whose result type is picked by the tag, so
recursion stays structural. A proposition group (`Even`/`Odd`) can only be matched to build proofs,
as in Lean and Rocq. Types of a group may have different indices (at most one each, for now): the
family is then indexed by the tag and a value of that tag's index type. A function may cover only
some types of a group, or match on just one of them. The types of a group share their parameters
and live in one universe. See [examples/mutual.arlk](examples/mutual.arlk).

**Nested types.** A type may occur among the parameters of another inductive type, as in Lean:

```
type Rose: Type =
  | node(kids: List(Rose))

def size(r: Rose) -> Nat = match r {
  node(kids) => Nat.succ(sizes(kids)),
}
def sizes(l: List(Rose)) -> Nat = match l {
  nil => Nat.zero,
  cons(h, t) => add(size(h), sizes(t)),
}
```

`List(Rose)` is the ordinary `List`, not a copy. The checker follows `Rose` through `List`'s
constructors at `A := Rose` (it must stay strictly positive there, and further occurrences found
on the way, like `List(List(T))`, are followed too), then gives `Rose.rec` a motive for each
occurrence and a companion recursor per occurrence (`Rose.rec_1` on `List(Rose)`), which compute.
Functions, and proofs by induction, recurse through all of them together, one per type, like
mutual ones; a match that does not recurse uses `Rose.cases`. The outer type has no indices and is
not a proposition, and it can be nested only in types without indices, at arguments that depend
only on its parameters. Unlike mutual types this is new theory, so it is part of the trusted base
([docs/TRUST.md](docs/TRUST.md)). See [examples/nested.arlk](examples/nested.arlk).

**Well-founded recursion.** A function may recurse on a value that is smaller by a well-founded
relation rather than structurally (Lean's `termination_by`):

```
def div(n: Nat, d: Nat) -> Nat decreasing n by lt_wf = match d {
  zero => Nat.zero,
  succ(k) => match le_dec(Nat.succ(k), n) {
    yes(h) => Nat.succ(div(sub(n, Nat.succ(k)), Nat.succ(k), sub_lt(n, k, ...))),
    no(h) => Nat.zero,
  },
}
```

`decreasing n by W` names the parameter and a proof W that its relation is well-founded
(`lt_wf` for `<`, `measure_wf(f)` for any measure into Nat); each recursive call passes, last, a
proof that its n is smaller, and a call without one is rejected. The definition becomes `fix` from
[lib/std/wf.arlk](lib/std/wf.arlk), defined from the recursor of `Acc` (nothing assumed), and its
unfolding law `div.unfold` is proved for it. The accessibility proofs build `Acc.intro` without
looking at the proofs of `<` they are given, so closed calls compute in the kernel: `div(7, 2) = 3`
and `gcd(12, 8) = 4` are checked by `Eq.refl`, and so is a merge sort on a list. Theorems can be
`decreasing` too (well-founded induction). A `match` may split the value of a call (`match
le_dec(m, n) { ... }`). See [examples/std/wf.arlk](examples/std/wf.arlk).

Next on this road: unification of indices and course-of-values recursion in `match`, nested types,
and reading Lean and Rocq libraries directly into these native features instead of through the
`core` encoding.

## Absorbing provers

What Arlk takes from each system, natively and when absorbing it, and what is missing:
[docs/COVERAGE.md](docs/COVERAGE.md).

```
tools/lean-export/Export.lean      Lean side: a declaration (or module) and its dependencies as JSON
tools/rocq-export/                 Rocq side: a plugin, `Arlk Export "out.json" name...`
arlk absorb EXPORT.json -o F       Arlk side: turn that JSON into Arlk source
arlk check lib/core.arlk F         check it; neither prover is involved
```

```
$ ./arlk check lib/core.arlk absorbed/lean/nat_add_zero.arlk
✓ theorem Init.Nat.add_zero: core.El(core.l0, core.pi(core.l1, core.l0, Nat, (n: core.El(core.l1, Nat)) => Eq@1(Nat, HAdd.hAdd@0@0@0(..., n, OfNat.ofNat@0(Nat, Nat.zero, ...)), n)))
ok: lib/core.arlk absorbed/lean/nat_add_zero.arlk (53 declarations)

$ ./arlk check lib/core.arlk absorbed/rocq/init_peano.arlk
✓ theorem Corelib.Init.Peano.plus_n_O: core.El(core.l0, core.pi(core.l1, core.l0, Init.Datatypes.nat, (n: ...) => Init.Logic.eq@2(core.lift(core.l1, core.l2, Init.Datatypes.nat), n, Init.Nat.add(n, Init.Datatypes.nat.O))))
ok: lib/core.arlk absorbed/rocq/init_peano.arlk (118 declarations)
```

### The shared foundation

[lib/core.arlk](lib/core.arlk) is the trusted theory both provers are translated into, written by
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
| Template polymorphism (`eq`, `prod`, `sig`, ...) | one instance per level it is used at (`eq@2`), floored at its declared levels |
| `match` | a lambda-lifted symbol with one rule per constructor (as in Dedukti's CoqInE); convertible matches share one symbol |
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
reference verifier mmverify.py ([spec/fixtures/metamath](spec/fixtures/metamath)): obligations in
normal and compressed proofs, setvars named with punctuation, fresh dummies, and rejection of a
missing `$d`, of a use collapsing two distinct variables and of an unconstrained dummy. The large
run below covers set.mm up to the construction of the positive fractions; it is development
evidence, not part of the test suite. The `Apart_*`, `apart_*` and `fresh_*` declarations are
assumptions about Metamath's syntax that `axioms` lists, like the database's own axioms.

Metamath's definitions (`df-an`, `df-bi`, ...) are axioms there, and they stay symbols here, so
`axioms` lists exactly the ones a theorem depends on.

### HOL (via OpenTheory)

OpenTheory is the proof exchange format of the HOL family. An *article* is a program for a stack
machine whose commands build types, terms and theorems with HOL's primitive inference rules.
`arlk absorb-hol` is an article reader written in Almide ([src/hol.almd](src/hol.almd)): it runs the
article itself and writes down, for every theorem, a proof over [lib/hol.arlk](lib/hol.arlk). No
HOL system and no OpenTheory tool is run; [tools/opentheory/fetch.sh](tools/opentheory/fetch.sh)
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
ok: lib/hol.arlk base.arlk (91319 declarations)
```

What the base library rests on (`axioms` on any of its theorems): room `hol`, HOL's three axioms
(extensionality, choice and infinity, which the articles assume and the reader reports as
`axiom_*.axiom*` symbols), and the type definitions (the new types with their `abs_rep`/`rep_abs`
axioms, each next to its checked `nonempty` theorem).

### Agda

Agda's checked terms are not exported (that needs a Haskell backend); instead `arlk absorb-agda`
([src/agda.almd](src/agda.almd)) reads an Agda module's source, in a subset (`data` with
parameters and indices, `record` with `open`, `infix` declarations, signatures with implicit
arguments, clauses by pattern matching with absurd patterns `()` and `with`, binary mixfix
operators, `λ`, `Set`), and writes the same development as Arlk types and definitions: clauses
become a case tree of `match`es (an absurd clause leaves its arm out, for Arlk's match to find
impossible; `with e` becomes `match e`), a record becomes a type with one constructor and a
projection per field, `_+_` becomes `plus`, implicit arguments are inferred at uses. The result rests on no assumption; a mistranslation is a type
error. [tools/agda-export/check.sh](tools/agda-export/check.sh) runs Agda on the source when it is
installed, regenerates the translation and checks it, and checks that a wrong proof in the source
is rejected. [examples/agda_transport.arlk](examples/agda_transport.arlk) uses Agda's `+-comm` to
prove Arlk's own `nat.add_comm` again, through the isomorphism of the two naturals.

```
$ ./arlk absorb-agda absorbed/agda/Arith.agda -o absorbed/agda/arith.arlk
$ ./arlk check absorbed/agda/arith.arlk
ok: absorbed/agda/arith.arlk (27 declarations)
```

A `coinductive` record becomes Arlk `codata`, and a definition by copatterns (`head (from n) = n`,
`tail (from n) = from (suc n)`) becomes corecursion with the changing argument as the seed.
[absorbed/agda](absorbed/agda) holds four modules, all accepted by Agda 2.8.0.2 and checked in full:
`Arith` (naturals, lists, equality and their laws), `Order` (`_≤_` as an indexed family, `≤-pred`,
`¬s≤z ()`), `Records` (a record with projections, `open`, `filter` by `with`) and `Streams` (a
coinductive record, `repeat`, `from` and `map` by copatterns, facts by computation).

### Isabelle/HOL

`arlk absorb-isabelle` ([src/isabelle.almd](src/isabelle.almd)) reads an Isabelle theory's source,
in a subset (`datatype` with type variables, `fun`/`primrec`/`definition` by equations,
`lemma`s stating equations, `[simp]`, `declare`, Main's `nat` and `'a list` with `0`, `Suc`,
numerals, `+`, `*`, `#`, `@`, `[a, b]`, `rev`, `length`, `map`), and writes Arlk types, definitions
and theorems; the variables' types are found by unification, as Isabelle does. Main's fragment is
itself absorbed from Isabelle equations into [lib/isabelle_main.arlk](lib/isabelle_main.arlk)
(`arlk absorb-isabelle --main`), with the `[simp]` lemmas of Main that proofs rely on, each proved
by Arlk's simp; a theory's own function of the same name shadows Main's.
A lemma's proof is its Isabelle proof method replayed by Arlk's own `simp`: `by (induction xs)
auto` becomes `by induction xs simp(...)` with the lemmas marked `[simp]` so far and those given by
`simp add:` (Main's `add.commute` included); every function's equations are used, as in
Isabelle. `arbitrary:` needs nothing more (the variables after the induction variable are
generalised in its hypothesis), and a structured Isar proof (`proof (induction xs) case Nil ...
next ... qed`) is replayed the same way, from its induction and the lemmas it adds. A method that Arlk's `simp`
cannot replay is a failed check, so a false lemma cannot get through, and nothing of Isabelle is
trusted. Equality is Arlk's native one (lib/std/eq.arlk), not lib/hol.arlk's encoding: the HOL
room reads OpenTheory articles (proofs in HOL's own rules), this one reads Isabelle source (proofs
re-found by rewriting). [tools/isabelle-export/check.sh](tools/isabelle-export/check.sh) runs
Isabelle on the theory when it is installed, regenerates the translation, checks it, and checks
that a false lemma is rejected.

```
$ ./arlk absorb-isabelle absorbed/isabelle/Lists.thy -o absorbed/isabelle/lists.arlk
$ ./arlk check lib/std/eq.arlk lib/isabelle_main.arlk absorbed/isabelle/lists.arlk
✓ theorem isabelle.Lists.total_rev: (xs: isabelle.Main.list(isabelle.Main.nat)) -> eq.Eq[1](isabelle.Main.nat, total(isabelle.Main.rev(isabelle.Main.nat, xs)), total(xs))
ok: lib/std/eq.arlk lib/isabelle_main.arlk absorbed/isabelle/lists.arlk (47 declarations)
```

[absorbed/isabelle](absorbed/isabelle) holds `Arith` (its own naturals and sequences) and `Lists`
(Main's lists and numbers, `itrev` by generalised induction, `total_rev` by an Isar proof with
`add.commute`); Isabelle2025-2 accepts both, and both check in full.

### Results

| Library | Declarations checked | Time |
|---|---|---|
| Lean `Nat.add_zero` | 53 (with dependencies) | < 0.1 s |
| Lean `Init.Data.Nat.Basic` | 823, including 308 of the module's 310 theorems | ~30 s |
| Lean `Init.Data.Nat.Lemmas` (881 theorems: arithmetic, order, division, `Nat.Linear`) | 1564 of 1573 (two roots run out of budget, in `Nat.Linear`'s reflection proofs) | ~10.5 min |
| Rocq `Corelib.Init.Peano` | 118, all of them | < 0.5 s |
| Rocq `Corelib.Init` (Logic, Datatypes, Peano, Nat, Specif, Wf) | 969 of 973 | ~30 s |
| Agda `Arith` (naturals, lists, equality and their laws; from source) | 27, all of them | < 0.1 s |
| Isabelle `Arith` (naturals, sequences, append, reverse; proofs replayed by `simp`) | 29, all of them | < 0.5 s |
| Metamath `set.mm`, propositional calculus | 1818: 1776 theorems and their axioms | 0.6 s |
| Metamath `set.mm` up to `unitssre` (line 150 000: predicate calculus, ZF, ordinals, the construction of ℚ⁺), not committed | 14 389 | ~7.5 min |
| OpenTheory `base-1.221` (HOL: bool, pairs, lists, natural numbers, words, reals ...), fetched in CI | 91 319: 1340 theorems, 14 009 lemmas, 75 651 term abbreviations, 223 definitions | absorb ~3.5 min, check ~3.5 min |

The 4 Rocq declarations that fail are the projections of `sig`/`sigT` used at `Prop`, where
template polymorphism drops a type to `Prop` in a way the exporter does not yet reproduce.

**What a successful check means.** Arlk checks the emitted proof terms without running Lean, Rocq
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
(so an emitted recursor rule is derived, not assumed), and checked interpretations of one room into
another.

## The bridge

[examples/bridge.arlk](examples/bridge.arlk) loads Lean's library and Rocq's library into one
environment and works across them:

```
// Lean's recursor, Rocq's constructors.
def to_rocq(n: core.El(core.l1, LeanNat)) -> core.El(core.l1, RocqNat) =
  Nat.rec@1(
    (k: core.El(core.l1, Nat)) => Init.Datatypes.nat,
    Init.Datatypes.nat.O,
    (k: core.El(core.l1, Nat), r: core.El(core.l1, Init.Datatypes.nat)) => Init.Datatypes.nat.S(r),
    n)

// Rocq's equality, proved by Lean's Nat.add_comm.
theorem add_comm_in_rocq(n: core.El(core.l1, LeanNat), m: core.El(core.l1, LeanNat))
  -> core.El(core.l0, rocq_eq(to_rocq(lean_add(n, m)), to_rocq(lean_add(m, n)))) =
  Eq.rec@0@1(
    Nat,
    lean_add(n, m),
    (b: core.El(core.l1, Nat), h: core.El(core.l0, Eq@1(Nat, lean_add(n, m), b))) => rocq_eq(to_rocq(lean_add(n, m)), to_rocq(b)),
    Init.Logic.eq.eq_refl@2(core.lift(core.l1, core.l2, RocqNat), to_rocq(lean_add(n, m))),
    lean_add(m, n),
    Nat.add_comm(n, m))
```

```
$ ./arlk check lib/core.arlk absorbed/lean/init_data_nat_basic.arlk absorbed/rocq/init_peano.arlk examples/bridge.arlk
to_rocq(lean_add(Init.Nat.succ(Init.Nat.zero), Init.Nat.succ(Init.Nat.zero))) = Corelib.Init.Datatypes.nat.S(Corelib.Init.Datatypes.nat.S(Corelib.Init.Datatypes.nat.O))
✓ theorem bridge.add_zero_in_rocq: ...
✓ theorem bridge.add_comm_in_rocq: ...
axioms bridge.add_comm_in_rocq
  rooms:   core, Init, Corelib
ok: ... (928 declarations)
```

`tools/check-absorbed.sh` checks every absorbed library and the bridge.

## Views: one logic read in another

A *view* interprets one room in another: each symbol of the source gets a term of the current room,
and Arlk checks every image against the symbol's type (as the view translates it) and every rule of
the source by conversion. `translate` then carries a declaration of any room built on the source,
with everything it uses, into the current room, where it is **checked again**. A view is never
trusted: a wrong one makes a translation fail, it cannot make a false theorem.

[examples/hol_types.arlk](examples/hol_types.arlk) reads HOL (room `hol`, which absorbed OpenTheory
libraries are checked against) in Arlk's native type theory:

```
type HType: Sort(2) = { carrier: Type, point: carrier }      // HOL's types are inhabited

view hol_types from hol {
  Ty = HType,
  bool = hbool,                     // HType { carrier: Sort(0), point: True }
  Tm = (a: HType) => a.carrier,     // so HOL's rule Tm(arr(a, b)) = Tm(a) -> Tm(b) holds by computation
  eq = heq,                         // Eq
  Prf = (p: Sort(0)) => p,
  eq_mp = cast, mk_comb = congr,    // theorems here
  abs = habs, deduct_antisym = hdeduct, select = hselect,   // funext, propext, choice
  ...
  opentheory.axiom_extensionality.axiom1 = eta_ax,          // HOL's own axioms, proved here
  opentheory.axiom_choice.axiom1 = choice_ax,
}

translate hol_types opentheory.bool_class.thm1   // ∀t. t ∨ ¬t, proved in HOL from choice

theorem em(p: Sort(0)) -> Or(p, Not(p)) = ...   // read with Arlk's Or, Not and False
```

```
$ ./arlk check lib/hol.arlk bool.arlk examples/hol_types.arlk
✓ view holtypes.hol_types: hol in holtypes, 12 symbols mapped
✓ translated holtypes.hol_types.opentheory.bool_class.thm1: ... (197 declarations carried)
✓ theorem holtypes.em: (p: Sort(0)) -> Or(p, Not(p))
axioms holtypes.em
  rooms:   holtypes
  symbols: holtypes.funext, holtypes.propext, holtypes.epsilon, holtypes.epsilon_spec
```

Excluded middle in Arlk's own logic, proved by HOL's library and resting on exactly the axioms Lean
assumes.

Views can be found and composed. `views` lists every view with what it maps, what it carries as
assumptions and what its images rest on; `routes from S` lists the ways from room S into the
current room through at most two views, each with the assumptions it rests on, and when there are
several it shows them all and picks none. `view ac from a via ab, bc` composes two views: each
image of `ab` is carried along `bc`, and the result goes through the same checks as a written view,
so a theorem translated along `ac` is the one translated along `ab` and then `bc`. Discovery only
proposes: nothing is used until it is declared and checked. CI rejects a degenerate view that reads every HOL statement as true, and
[spec/fixtures/reject](spec/fixtures/reject) has views with a wrongly typed image, a broken rule,
and an attempt to replace a theorem.

### Lean's theorems about Rocq's numbers

[examples/transport.arlk](examples/transport.arlk) goes further: a checked correspondence between
the two libraries' natural numbers, built once, and then theorems about **Rocq's own addition on
arbitrary Rocq numbers, in Rocq's equality**, proved by Lean's theorems:

```
def to_rocq(n: LN) -> RN = Nat.rec@1(...)                    // Lean's recursor, Rocq's numbers
def to_lean(a: RN) -> LN = Init.Datatypes.nat_rect(...)      // Rocq's recursor, Lean's numbers

theorem round_trip(a: RN) -> REq(to_rocq(to_lean(a)), a)                              // Rocq induction
theorem add_hom(n: LN, m: LN) -> REq(to_rocq(ladd(n, m)), radd(to_rocq(n), to_rocq(m)))  // Lean induction
theorem transport(n: LN, m: LN, h: LEq(n, m)) -> REq(to_rocq(n), to_rocq(m))

theorem rocq_add_comm(a: RN, b: RN) -> REq(radd(a, b), radd(b, a))            // by Lean's Nat.add_comm
theorem rocq_add_assoc(a: RN, b: RN, c: RN) -> REq(radd(radd(a, b), c), radd(a, radd(b, c)))  // Nat.add_assoc
```

Here `RN` is Rocq's `nat`, `radd` is Rocq's `Init.Nat.add` and `REq` is Rocq's `eq`. Every step is a
checked definition or theorem; the correspondence adds no assumption, so `axioms` lists only what
the two absorbed libraries already assume, with Lean's `Init.Nat.add_comm` among the theorems used.
CI also checks that a broken translation (`to_lean` forgetting `succ`) or a false preservation
lemma is rejected.

## Usage

CI (`.github/workflows/ci.yml`) runs [tools/ci.sh](tools/ci.sh) on a pinned toolchain (Almide
v0.64.0 by checksum, Rust 1.96.1): build, both test suites, the native examples, the committed
absorbed libraries without any prover, OpenTheory's base library (fetched by checksum, absorbed
and checked, with two false statements that must be rejected), the exact known baseline of Rocq `Corelib.Init` (four
declarations fail, see above), and the inputs in [spec/fixtures/reject](spec/fixtures/reject),
each of which must be rejected for its stated reason under a timeout. `tools/ci.sh` runs the same
stages locally. A green run says these checks passed on that commit; it is not a soundness proof
(see [docs/TRUST.md](docs/TRUST.md)).

```
almide build src/main.almd -o arlk
./arlk check examples/logic.arlk
./arlk check examples/nat.arlk

./arlk check lib/core.arlk absorbed/lean/nat_add_zero.arlk
./arlk check lib/core.arlk absorbed/rocq/init_peano.arlk
./arlk check absorbed/metamath/set_prop.arlk
./arlk absorb-mm set.mm --upto stoic4b -o out.arlk
./arlk bundle CLAIM FILE... -o DIR && ./arlk replay DIR
./arlk absorb-almide examples/almide/reverse.almd --verify examples/almide/reverse.arlk
./arlk check lib/hol.arlk
tools/opentheory/fetch.sh base-1.221 otlib > order.txt && ./arlk absorb-hol $(cat order.txt) -o base.arlk
tools/check-absorbed.sh

almide test            # kernel and absorb tests (spec/): good proofs pass, bad ones are rejected
almide test src/       # unit tests of term, syntax, pretty, absorb
```

## The native standard library

[lib/std](lib/std) holds equality (`refl`, `symm`, `trans`, `cong`, `subst`), propositions and
evidence types, naturals with addition's laws, lists (the List of Almide's model, with length
and append's laws), and well-founded recursion (`Acc`, `WellFounded`, `fix` and its unfolding law,
`<` on Nat, measures), all proved from inductive types alone: no symbol, rule or axiom. A native client
loads only the files it needs and redeclares none of it; see [docs/STDLIB.md](docs/STDLIB.md).

```
arlk check lib/std/eq.arlk lib/std/logic.arlk lib/std/nat.arlk lib/almide.arlk lib/std/list.arlk examples/std/sort.arlk
```

Quotient types live beside it in [lib/quot.arlk](lib/quot.arlk): Lean's `Quot`, `Quot.mk`, `Quot.lift`
(which computes on a class), `Quot.ind` and `Quot.sound`, declared as assumptions that `axioms` lists,
and function extensionality (`funext`) proved from them. [examples/std/quot.arlk](examples/std/quot.arlk)
builds the integers as pairs of naturals up to `a + d = c + b`, lifts negation to classes and proves
`neg(neg(z)) = z` for every integer.

## Editors: `arlk lsp`

`arlk lsp` is a language server (Language Server Protocol, on standard input and output). On open,
change and save it checks the document with every declaration kept going and reports each failure
on its line; hovering a name shows its type. The files a document needs come from its comment line
`arlk check A.arlk B.arlk THIS.arlk` (the convention the examples and the library already follow),
relative to the workspace root. It runs the same checker as `arlk check`
([src/lsp.almd](src/lsp.almd); [tools/lsp/smoke.py](tools/lsp/smoke.py) drives a session in CI).

## Incremental checking

`arlk session STEP_DIR...` checks a sequence of edits in one process. It reuses each declaration
that an edit cannot have affected, and says why each other one was checked again. Proofs are opaque
to their users, so editing a proof checks one declaration. Changing a definition, rule, type, room
or view checks everything that rests on it. After every edit, the result must be identical to a
fresh check (`arlk check --digest`); CI checks this over 29 edits of every kind. See
[docs/INCREMENTAL.md](docs/INCREMENTAL.md).

## Packages: checked libraries and views, reused

A project names the packages it requires in a data-only manifest, each pinned by hash. A package
pins its sources and the identities of what it exports: claims, checked views, assumption
footprints. `arlk project DIR` checks everything again from scratch, in dependency order,
recomputes every pinned identity, shows the routes and assumptions behind each claim, and refuses
a claim that rests on assumptions the project does not allow. The result can travel as a bundle
bound to its packages. See [docs/PACKAGES.md](docs/PACKAGES.md).

```
$ arlk project examples/projects/client-a
✓ package std 1.0.0 (7b4d…): 5 sources, exports verified
✓ package views-abc 1.0.0 (ed3e…): 1 sources, exports verified
✓ project client-a: 1 source files checked
view c.ac: a in c
  …
  via: b.ab, c.bc
  rests on: (nothing)
axioms client_a.keep_comm
  symbols: (none)
  …
  allowed: rests only on inductive types and definitions
```

## Almide programs, verified

Arlk is written in Almide, and it can reason about Almide programs. `arlk absorb-almide` reads a
program in a small pure subset of Almide (variant types, lists, `match`, structural recursion; no
machine integers: [docs/ALMIDE_SUBSET.md](docs/ALMIDE_SUBSET.md)) and writes its functions as Arlk
definitions, with the program's SHA-256 and bytes in the header and a source-line trace on each
definition. Anything outside the subset is refused where it is written.

```almide
fn reverse[A](xs: List[A]) -> List[A] = match xs {     // examples/almide/reverse.almd
  [] => [],
  [h, ..t] => reverse(t) + [h],
}
```

```
$ arlk absorb-almide examples/almide/reverse.almd -o examples/almide/reverse.arlk
$ arlk check lib/almide.arlk examples/almide/reverse.arlk examples/almide/reverse_proof.arlk
✓ theorem reverse_proof.reverse_length: (A: Type, xs: almide.List[0](A)) -> Eq[1](Nat, length(A, almide_reverse.reverse(A, xs)), length(A, xs))
axioms reverse_proof.reverse_length
  symbols: (none)
```

`reverse` terminates on every list (Arlk accepted its definition, and accepts only structural
recursion) and keeps its length, with no assumptions at all. A version that drops elements makes
the model stale (`absorb-almide --verify`) and the proof fail; CI checks both, and compares the
model with the compiled program on an example. This is a theorem about the program's meaning in the
subset's semantics, not about the executable the compiler builds; that needs a preservation proof
for the compiler, which is later work.

## Proof bundles: a result that travels

```
arlk bundle transport.rocq_add_comm lib/core.arlk absorbed/lean/init_data_nat_basic.arlk \
            absorbed/rocq/init_peano.arlk examples/transport.arlk -o add_comm
arlk replay add_comm --expect d2c2fb9e...      # elsewhere, later: no Lean, Rocq, network or search
```

A bundle is data: the source files a result was checked from, and a manifest with their SHA-256,
the claim and its statement, a hash of every declaration it depends on, its assumption inventory
(what `axioms` prints) and a claim identity over all of these. The recorded "checked" is only
metadata: `replay` verifies the hashes, checks every file again from scratch (inductive types are
admitted again, views checked again), recomputes the statement, dependencies, assumptions and
identity, and compares them with the manifest. Each kind of failure has its own exit status: 1 the
proof does not check, 3 a file does not match its hash or is not a bundled source, 4 the claim,
a dependency, the assumptions or the expected identity differ, 5 an unsupported format or checker
semantics (`--revalidate` checks it again under this checker, and says so), 6 a file is missing, 7
a budget ran out. Nothing in a bundle is run. [tools/bundle-check.sh](tools/bundle-check.sh),
run by CI, bundles the Lean→Rocq arithmetic result and a composed-view result, replays them from
a clean directory, and tampers with a proof, a claim, a view image, a dependency hash, the
assumption inventory, the paths and the versions, each of which must fail as stated.

A matching identity means: the same claim, resting on the same declarations and assumptions,
checked by a checker of the same semantics. It does not mean that the sources say what their
authors meant; that is the separate obligation described in [docs/TRUST.md](docs/TRUST.md).

## What the kernel trusts (read this before believing a result)

The full map of the trusted base, with the code each guarantee rests on, is in
[docs/TRUST.md](docs/TRUST.md). In short:

- **Rules are assumptions.** A rule is type-checked against its declared variable types, but Arlk
  does not yet check confluence, termination, or full subject reduction. A bad rule set can make
  a room inconsistent. That is why rules appear in `axioms`.
- **Non-terminating rules make the checker incomplete, not unsound, and never stuck.** Every
  declaration gets one work budget, shared by all reduction, conversion and normalisation it
  triggers, and nesting is bounded too. Running out rejects the declaration with an explicit
  "out of budget" error; an unfinished reduction is never taken as a normal form.
- **Imported theories are assumptions too.** What an absorbed library's check establishes, and what
  it does not, is spelled out under [Results](#results).
- **Symbols are assumptions.** The checker cannot tell a type former (`Nat`) from a logical
  axiom (`excluded_middle`). Both show up in `axioms`.
- **Native type theory.** The kernel has universes (`Sort(u)`, impredicative and
  proof-irrelevant Prop), universe polymorphism and rewrite rules. Absorbed Lean and Rocq
  libraries still go through the `core` encoding (lib/core.arlk); native code does not.
- **Inductive types are admitted by checks outside term typing.** Positivity, universe fit, the
  Prop elimination restriction and the generated recursor schema (checker.almd `admissible`,
  inductive.almd) are part of the trusted base; retyping the generated rules does not replace them.
- **The elaborator and the match compiler are not trusted.** Their output is a complete term,
  checked by the kernel.

## Roadmap

1. **Kernel hardening.** Confluence and termination checks for rules, and checking subject
   reduction properly instead of trusting the declared variable types.
2. **Bridges between rooms.** Done: hand-built bridges ([examples/bridge.arlk](examples/bridge.arlk),
   [examples/transport.arlk](examples/transport.arlk)) and checked views that carry theories
   along (`view`/`translate`, [examples/hol_types.arlk](examples/hol_types.arlk)), in the spirit of
   MMT's views and institution theory. Next: views between absorbed libraries (HOL's numbers as
   Lean's), universe-polymorphic views, and carrying rewrite rules along a view.
3. **Absorbing Lean 4 and Rocq** (started: Lean's `Init.Data.Nat.Basic` and Rocq's
   `Corelib.Init` check). The goal is not to interoperate with Lean but to take it over. Lean's
   type theory (universes, inductive types and their recursors, proof-irrelevant `Prop`,
   quotients) becomes one room, `lean`, encoded in Arlk's own core. Lean's declarations, Mathlib
   included, are translated into that room once and from then on are checked by Arlk's kernel
   alone. Lean is needed only as the source of the original text, never to trust a result. The
   translation starts from Lean's kernel export, the same way
   [lean4-rust-backend](https://github.com/O6lvl4/lean4-rust-backend) takes Lean's compiler IR out
   as JSON and rebuilds it outside Lean. Metamath has started too (set.mm's propositional
   calculus, `$d`, and set.mm well into ZF), and HOL (OpenTheory's standard library). Next: Isabelle's
   own theories (HOL is its logic; its proof terms are the way in), Agda, and Dedukti `.dk` files,
   each into a room of its own.
4. **Natural language layer.** Pair each theorem with a statement in natural language, and
   track where the formal statement and the intended meaning may differ.

## Almide issues found while building Arlk

| Issue | Workaround in Arlk |
|---|---|
| [almide#3384](https://github.com/almide/almide/issues/3384) selective import of constructors ICEs | import the type only |
| [almide#3385](https://github.com/almide/almide/issues/3385) `-> T!` tail lift differs between `if` and `match` | explicit `ok(...)` on every branch |
| [almide#3387](https://github.com/almide/almide/issues/3387) `ok(` / `err(` / `some(` reject a newline after `(` | keep the argument on one line |
| [almide#3388](https://github.com/almide/almide/issues/3388) selective import of a top-level `let` | write `Sort(0)` / `Sort(1)` instead of named constants |
| [almide#3389](https://github.com/almide/almide/issues/3389) cheatsheet recommends a nonexistent `list.each` | `for` loop |
| [almide#3390](https://github.com/almide/almide/issues/3390) native codegen: tuple match on recursive variants | nested `match` in `conv` |
| [almide#3391](https://github.com/almide/almide/issues/3391) wasm: `o?.field` walls | `is_symbol` helper |
| [almide#3392](https://github.com/almide/almide/issues/3392) wasm: fallible lambda calling a same-module fn walls | none yet: `spec/` runs on native only |
| [almide#3393](https://github.com/almide/almide/issues/3393) `almide fmt` moves trailing comments and collapses variants | sources are not run through `almide fmt` for now |
| [almide#3397](https://github.com/almide/almide/issues/3397) native `list.slice` clones the whole list per call | copy ranges with `list.get` in the lexer |
| [almide#3400](https://github.com/almide/almide/issues/3400) native codegen drops the element of a one-element list pattern over a variant | nested `match` on the element |
| [almide#3401](https://github.com/almide/almide/issues/3401) same-named types in two modules resolve to the other module's type | `metamath.almd` names its record `Proving`, not `Ctx` |
| [almide#3402](https://github.com/almide/almide/issues/3402) recursive call with swapped params passes `&E` for `E` | bind the swapped arguments with `let` first (`metamath.apart`) |
| [almide#3404](https://github.com/almide/almide/issues/3404) functional `map.set` on a record field copies the whole map | the kernel commits each declaration in place (`mut env`, `map.insert`) |
| [almide#3405](https://github.com/almide/almide/issues/3405) two arguments calling a `mut`-param fn share one hoisted value (miscompile) | one `let` per argument in `conv` |
| [almide#3409](https://github.com/almide/almide/issues/3409) `map.get(m, k) ?? k` borrows and moves `k` in one call | `match` on the lookup |
| [almide#3410](https://github.com/almide/almide/issues/3410) a lambda capturing a `mut` parameter lowers to `c.get()` | `for` loop with `list.push` in `elab.constant` |
| [almide#3413](https://github.com/almide/almide/issues/3413) native build panics on a list pattern nested in a variant pattern | `ty_arg` / `pair` helpers in `hol.almd` |
| [almide#3414](https://github.com/almide/almide/issues/3414) a guard on a variable bound in a nested variant pattern runs before the binding | test the variable in the arm body (`hol.dest_eq`) |
| [almide#3415](https://github.com/almide/almide/issues/3415) `err(..)` in a let-bound match takes the enclosing `Unit!` type | one small function per object kind (`pop_tyop`, `as_ty`, ...) |
| [almide#3416](https://github.com/almide/almide/issues/3416) tuple-of-variants match leaves recursive payloads boxed | one value at a time (`as_list`, `as_var`) |
| [almide#3421](https://github.com/almide/almide/issues/3421) a variant pattern nested in `some(...)` leaves payloads boxed | fetch, then match (`patterns.sub_at`) |
| [almide#3431](https://github.com/almide/almide/issues/3431) a closure passing a captured `var` to a `mut` parameter emits `.get()` on `&mut` | explicit loop (`session.first_changed`) |
| [almide#3434](https://github.com/almide/almide/issues/3434) an argument used again after a call is deep-copied at the call | describe terms before checking them (`kernel.brief`), substitute only dependent arguments |
| [almide#3437](https://github.com/almide/almide/issues/3437) comparing a match-arm binding of a recursive variant with `==` emits `&T == T` | compare the scrutinee itself (`checker.shape`) |
| [almide#3439](https://github.com/almide/almide/issues/3439) same-named types in two modules still clash (as #3401) | `agda.almd`'s types are prefixed (`AExpr`, `ACx`, ...) |
| [almide#3440](https://github.com/almide/almide/issues/3440) a list from a tuple binding is moved by `|> list.map` in a loop | map once before the loop (`agda.absorb`) |
