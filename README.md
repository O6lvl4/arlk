# Arlk(アルク)

A small proof language and checker written in [Almide](https://github.com/almide/almide).

Arlk aims to be a **logic translator with a trusted core**. The kernel is small, and different
logics live in separate *rooms* on top of it. The checker always tells you which assumptions
a theorem actually rests on.

Arlk is meant for programmers, not only mathematicians. **It reads like Almide**: declarations look
like function signatures, a call is `f(a, b)`, a function is `(x: A) => body`, a function type
is `(x: A) -> B`. Unicode is only an optional alias, and errors say what was expected and what
was found.

**Lean 4, Rocq and Metamath are absorbed, not linked, and Lean and Rocq meet in one place.**

- Lean's whole `Init.Data.Nat.Basic` module (308 of its 310 theorems, 823 declarations with their
  dependencies) is translated into Arlk source and checked by Arlk's kernel alone.
- Rocq's `Corelib.Init` (Logic, Datatypes, Peano, Nat, Specif, Wf: 969 of 973 declarations) is
  checked the same way.
- Metamath's `set.mm`: its whole propositional calculus (1776 theorems, from `ax-mp` to `stoic4b`)
  is read straight from the database, proofs included, and checked by the same kernel.
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
| **Kernel** | The λΠ-calculus modulo rewriting, the same core as Dedukti/Lambdapi. It has de Bruijn terms, β/δ/rule reduction, η-aware conversion with lazy unfolding, declared proof irrelevance, and bidirectional type inference. |
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
logic.Prf                              a qualified name (another room's symbol)
Nat.add   Eq@1                         names may contain dots and @ (absorbed names use both)
// comment
```

Unicode aliases: `→` for `->`, `⇒` for `=>`. Declarations need no terminator: each one starts with
its keyword.

## Universes and inductive types

Arlk's kernel has its own universe hierarchy and inductive types, implemented in Almide, not
borrowed from a prover. They are the core of Lean's, Rocq's and Agda's kernels:

```
// Sort(0) is Prop (impredicative, proofs irrelevant), Type is Sort(1), Type(u) is Sort(u + 1).
// Universe parameters are written like Almide generics.
def id[u](A: Sort(u), x: A) -> A = x

type Nat: Type =
  | zero
  | succ(n: Nat)

type Eq[u](A: Sort(u), a: A): (b: A) -> Sort(0) =
  | refl: Eq[u](A, a, a)

type Vec[u](A: Type(u)): (n: Nat) -> Type(u) =
  | vnil: Vec[u](A, Nat.zero)
  | vcons(n: Nat, x: A, xs: Vec[u](A, n)): Vec[u](A, Nat.succ(n))

def add(m: Nat, n: Nat) -> Nat =
  Nat.rec[1]((k: Nat) => Nat, m, (k: Nat, r: Nat) => Nat.succ(r), n)

theorem one_plus_one: Eq[1](Nat, add(Nat.succ(Nat.zero), Nat.succ(Nat.zero)), Nat.succ(Nat.succ(Nat.zero))) =
  Eq.refl[1](Nat, Nat.succ(Nat.succ(Nat.zero)))
```

A `type` declaration gives the type former, its constructors (`Nat.succ`), the recursor
(`Nat.rec`) and one computation rule per constructor. Before anything is added the kernel checks
that the type is admissible: constructors build the type at its own parameters, the type occurs
only strictly positively, arguments fit the type's universe, and a proposition eliminates into
`Type` only when it is a subsingleton (`And`, `Eq`, `False` may; `Or`, `Exists` may not, exactly as
in Lean). Propositions with one argument-free constructor (`Eq`) also get K-style computation. The
generated recursor and rules are then checked by the kernel like any declaration, and a rejected
type leaves nothing behind. See [examples/data.arlk](examples/data.arlk).

Next on this road: universe and argument inference (so `Nat.rec[1](...)` and `List.cons[0](Nat, ...)`
lose their bookkeeping), pattern-matching definitions compiled to recursors, structures with
projections, mutual and nested types, and reading Lean and Rocq libraries directly into these native
features instead of through the `core` encoding.

## Absorbing provers

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
| Dummy variables | replaced by a variable of the same typecode (sound without `$d`) |
| `$d` distinct-variable conditions | not yet: needed from predicate calculus on |

Metamath's definitions (`df-an`, `df-bi`, ...) are axioms there, and they stay symbols here, so
`axioms` lists exactly the ones a theorem depends on.

### Results

| Library | Declarations checked | Time |
|---|---|---|
| Lean `Nat.add_zero` | 53 (with dependencies) | < 0.1 s |
| Lean `Init.Data.Nat.Basic` | 823, including 308 of the module's 310 theorems | ~40 s |
| Rocq `Corelib.Init.Peano` | 118, all of them | < 0.5 s |
| Rocq `Corelib.Init` (Logic, Datatypes, Peano, Nat, Specif, Wf) | 969 of 973 | ~55 s |
| Metamath `set.mm`, propositional calculus | 1818: 1776 theorems and their axioms | 0.6 s |

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

## Usage

```
almide build src/main.almd -o arlk
./arlk check examples/logic.arlk
./arlk check examples/nat.arlk

./arlk check lib/core.arlk absorbed/lean/nat_add_zero.arlk
./arlk check lib/core.arlk absorbed/rocq/init_peano.arlk
./arlk check absorbed/metamath/set_prop.arlk
./arlk absorb-mm set.mm --upto stoic4b -o out.arlk
tools/check-absorbed.sh

almide test            # kernel and absorb tests (spec/): good proofs pass, bad ones are rejected
almide test src/       # unit tests of term, syntax, pretty, absorb
```

## What the kernel trusts (read this before believing a result)

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
- **λΠ only.** There are no universes or polymorphism in the core. Richer logics, Lean's
  included, are *encoded* in rooms, as Dedukti does.

## Roadmap

1. **Kernel hardening.** Confluence and termination checks for rules, and checking subject
   reduction properly instead of trusting the declared variable types.
2. **Bridges between rooms** (started: [examples/bridge.arlk](examples/bridge.arlk)). Next, declare
   a translation from room A to room B as a first-class object, check that it preserves typing,
   and transport whole theories along it. This draws on institution theory and MMT.
3. **Absorbing Lean 4 and Rocq** (started: Lean's `Init.Data.Nat.Basic` and Rocq's
   `Corelib.Init` check). The goal is not to interoperate with Lean but to take it over. Lean's
   type theory (universes, inductive types and their recursors, proof-irrelevant `Prop`,
   quotients) becomes one room, `lean`, encoded in Arlk's own core. Lean's declarations, Mathlib
   included, are translated into that room once and from then on are checked by Arlk's kernel
   alone. Lean is needed only as the source of the original text, never to trust a result. The
   translation starts from Lean's kernel export, the same way
   [lean4-rust-backend](https://github.com/O6lvl4/lean4-rust-backend) takes Lean's compiler IR out
   as JSON and rebuilds it outside Lean. Metamath has started too (set.mm's propositional
   calculus); next for it is `$d` and predicate calculus up to ZFC. After that: Isabelle/HOL, Agda, and Dedukti `.dk` files, each
   into a room of its own.
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
