# Language guide

Start with the [README quick start](../README.md#quick-start). The snippets below explain
individual constructs; linked example files contain complete runnable developments.

## A room with its own logic

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
$ arlk qed examples/logic.arlk
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
numerals zero, succ                    write n for succ(...succ(zero)) (n times); 1000000 costs no memory
numerals zero computes { add: f, ... } compute f on two literals instead of unfolding it (an assumption)
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
calc a { = b by h, = c }               a chain of equations, joined by `trans` (Lean's `calc`,
                                       Agda's `≡⟨ h ⟩`, Isar's `also`/`finally`); a step with no
                                       `by` holds by computation (`Eq.refl`)
rewrite h1, h2 { e }                   e proves the goal with each equation's left side replaced
                                       by its right side (Lean's `rw`, Agda's `rewrite`)
_                                      a hole the elaborator fills
?                                      an open goal: checking stops and shows its type, its context
                                       (β-reduced, in the names the room uses), and a visible theorem
                                       that closes it if a quick search finds one
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
works, while a direct structural `match` for `even` recursing two constructors deep is refused.
Use the well-founded `decreasing` form below for that course-of-values recursion. A match on a call, `match even(n) { yes => ..., no => ... }`, splits on
its value, and where the goal mentions `even(n)` each arm sees the case it is in instead, as Agda's
`with` does: `not(not(even(n))) = even(n)` is proved by `Eq.refl` in both arms. A parameter of an indexed family (`xs: Vec(A, n)`) can be matched when
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

**Numerals.** `numerals Nat.zero, Nat.succ` lets `0`, `1`, `1000000` stand for `Nat.succ` applied
that many times to `Nat.zero`. A literal is a single constant (`Nat.zero#1000000`) that the kernel
unfolds one `succ` at a time, only as far as a reduction needs, so a big literal is as cheap as a
small one. Absorbed Lean libraries declare it for `Nat`.
`numerals Nat.zero computes { add: add, mul: mul, ble: ble, true: B.yes, false: B.no }` goes one step
further, as Lean's kernel does: `mul(123456, 654321)` is answered by multiplying the numbers. That
`mul` is multiplication is then an assumption: the declaration is checked on small literals, and
`axioms` lists every theorem that relies on it.

**Coinductive types.** `codata Stream(A: Type) = { head: A, tail: Stream(A) }` declares infinite
values whose fields may be the type again (streams, infinite trees with several such fields). It is
defined, not assumed (src/codata.almd): a value is what each path down through its recursive fields
leads to (`Stream.Path`), `Stream.corec(h, t, seed)` builds one from a seed and a step per field, and
the destructors compute on it, so `Stream.tail(Stream.corec(h, t, s))` is `Stream.corec(h, t, t(s))`
by conversion. Bisimilar values are equal by function extensionality:
[examples/std/stream.arlk](../examples/std/stream.arlk) proves the coinduction principle by induction on
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
[examples/data.arlk](../examples/data.arlk).

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
reduction ([src/mutual.almd](../src/mutual.almd)). The family goes through the usual admission:
strict positivity across the whole group, universes, and elimination. Each type, constructor and
mutual recursor (`Tree.rec` takes a motive per type and a minor per constructor) is a generated
definition that the kernel checks, and the recursors compute. A group of functions becomes one
structurally recursive definition on the family, whose result type is picked by the tag, so
recursion stays structural. A proposition group (`Even`/`Odd`) can only be matched to build proofs,
as in Lean and Rocq. Types of a group may have different indices (at most one each, for now): the
family is then indexed by the tag and a value of that tag's index type. A function may cover only
some types of a group, or match on just one of them. The types of a group share their parameters
and live in one universe. See [examples/mutual.arlk](../examples/mutual.arlk).

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
([docs/TRUST.md](TRUST.md)). See [examples/nested.arlk](../examples/nested.arlk).

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
[lib/std/wf.arlk](../lib/std/wf.arlk), defined from the recursor of `Acc` (nothing assumed), and its
unfolding law `div.unfold` is proved for it. The accessibility proofs build `Acc.intro` without
looking at the proofs of `<` they are given, so closed calls compute in the kernel: `div(7, 2) = 3`
and `gcd(12, 8) = 4` are checked by `Eq.refl`, and so is a merge sort on a list. Theorems can be
`decreasing` too (well-founded induction). A call two or more constructors down
(course-of-values recursion, `even(n + 2) = even(n)`) is the same thing with `lt_wf`, the proof
being `k < k + 2`; `even.unfold` gives its equation for every n. A `match` may split the value of a
call (`match le_dec(m, n) { ... }`). See [examples/std/wf.arlk](../examples/std/wf.arlk).

Remaining work includes more general index unification, direct course-of-values recursion in
structural `match`, and reading Lean and Rocq libraries directly into the native features instead
of through the `core` encoding. Nested types and well-founded recursion are already supported;
see [docs/COVERAGE.md](COVERAGE.md) for their boundaries.
