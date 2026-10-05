# Arlk(アルク)

A small proof language and checker written in [Almide](https://github.com/almide/almide).

Arlk aims to be a **logic translator with a trusted core**. The kernel is small, and different
logics live in separate *rooms* on top of it. The checker always tells you which assumptions
a theorem actually rests on.

Arlk is meant for programmers, not only mathematicians. Its syntax reads like code (`fun`, `->`,
`symbol`, `rule`, `room`), Unicode is only an optional alias, and errors say what was expected
and what was found.

**Lean 4 and Rocq are absorbed, not linked, and they meet in one place.**

- Lean's whole `Init.Data.Nat.Basic` module (308 of its 310 theorems, 822 declarations with their
  dependencies) is translated into Arlk source and checked by Arlk's kernel alone.
- Rocq's `Corelib.Init.Peano` (26 of 33 declarations) is checked the same way.
- Both sit on one shared foundation, [lib/core.arlk](lib/core.arlk). That foundation has Rocq's
  cumulative universes *and* Lean's proof irrelevance, so a single proof can use both libraries.
  [examples/bridge.arlk](examples/bridge.arlk) turns Lean's theorem `Nat.add_comm` into a statement
  about Rocq's equality on Rocq's numbers.

See [Absorbing provers](#absorbing-provers) and [The bridge](#the-bridge).

```
room logic.

symbol Prop : Type.
symbol Prf : Prop -> Type.
symbol imp : Prop -> Prop -> Prop.
rule [a : Prop, b : Prop] Prf (imp a b) --> Prf a -> Prf b.

theorem s : (a b c : Prop) -> Prf (imp (imp a (imp b c)) (imp (imp a b) (imp a c))) :=
  fun (a b c : Prop) (f : Prf (imp a (imp b c))) (g : Prf (imp a b)) (x : Prf a) => f x (g x).

#axioms s.
```

```
$ arlk check examples/logic.arlk
✓ theorem logic.s : (a : Prop) -> (b : Prop) -> (c : Prop) -> Prf (imp (imp a (imp b c)) (imp (imp a b) (imp a c)))
#axioms logic.s
  rooms:   logic
  symbols: logic.Prop, logic.Prf, logic.imp
  rules:   [logic:11] Prf (imp a b) --> Prf a -> Prf b
```

## Design

| Layer | What it is |
|---|---|
| **Kernel** | The λΠ-calculus modulo rewriting, the same core as Dedukti/Lambdapi. It has de Bruijn terms, β/δ/rule reduction, η-aware conversion, and bidirectional type inference. |
| **Rooms** | Namespaces that hold one theory each: its symbols, definitions, rules and theorems. A room sees only the rooms it `uses` (transitively). **Rooms are sealed once left**, so no later room can add symbols or rules to them. |
| **Rules** | Rewrite rules may only extend symbols of the *current* room. Each rule is type-checked (left and right sides must have convertible types under the declared variable types). A pattern may contain `{t}`, a subterm fixed by typing that is checked by conversion instead of matched, as in Dedukti. |
| **Dependency tracking** | `#axioms name` walks everything a theorem uses through defs and theorems. It reports the symbols assumed, the rules relied on, and the rooms involved. |

Why these choices are explained in the design discussion behind this project: a strongest checker
cannot merge every logic into one, because some foundations contradict each other (for example
univalence vs UIP). It can keep each logic in its own room, build bridges between rooms, and
always say which room a result depends on.

## Language

```
room NAME.                         start a room (sees nothing)
room NAME uses A, B.               start a room that sees A, B and what they see

symbol c : T.                      assume a constant (opaque)
def c : T := t.                    a definition (unfolds during conversion)
theorem c : T := t.                a checked proof (opaque afterwards)
rule [x : A, y : B] lhs --> rhs.   a rewrite rule on a symbol of this room
                                   ({t} in lhs: must be convertible to t, not matched)

#check t.                          print the type of t
#eval t.                           print the normal form of t
#axioms c.                         print what c depends on
```

Terms:

```
Type                               the sort of types
(x : A) -> B   (x y : A) -> B      dependent function type
A -> B                             non-dependent function type
fun (x : A) (y : B) => t           function (λ also works)
f a b                              application
logic.Prf                          a qualified name (another room's symbol)
Nat.add   Eq@1                     names may contain dots and @ (absorbed names use both)
-- comment
```

Unicode aliases: `→` for `->`, `λ` for `fun`, `⇒` for `=>`, `↪` for `-->`.

Every declaration ends with `.` **followed by whitespace**. `a.b` with no space is a qualified name.

## Absorbing provers

```
tools/lean-export/Export.lean      Lean side: a declaration (or module) and its dependencies as JSON
tools/rocq-export/                 Rocq side: a plugin, `Arlk Export "out.json" name...`
arlk absorb EXPORT.json -o F       Arlk side: turn that JSON into Arlk source
arlk check lib/core.arlk F         check it; neither prover is involved
```

```
$ ./arlk check lib/core.arlk absorbed/lean/nat_add_zero.arlk
✓ theorem Init.Nat.add_zero : core.El core.l0 (core.pi core.l1 core.l0 Nat (fun (n : core.El core.l1 Nat) => Eq@1 Nat (HAdd.hAdd@0@0@0 ... n (OfNat.ofNat@0 Nat Nat.zero ...)) n))
ok: lib/core.arlk absorbed/lean/nat_add_zero.arlk (53 declarations)

$ ./arlk check lib/core.arlk absorbed/rocq/init_peano.arlk
✓ theorem Corelib.Init.Peano.plus_n_O : core.El core.l0 (core.pi core.l1 core.l0 Init.Datatypes.nat (fun (n : ...) => Init.Logic.eq (core.lift core.l1 core.l2 Init.Datatypes.nat) n (Init.Nat.add n Init.Datatypes.nat.O)))
ok: lib/core.arlk absorbed/rocq/init_peano.arlk (93 declarations)
```

### The shared foundation

[lib/core.arlk](lib/core.arlk) is the trusted theory both provers are translated into, written by
hand to be read. A universe level is a value of `Lvl`, the types of universe `l` are values of
`Univ l`, `El l A` turns one into an Arlk type, and function types are values `pi a b A B` that a
rule unfolds into Arlk function types. Level 0 is `Prop`, level 1 is Lean's `Type` and Rocq's
`Set`.

| Feature | Comes from | In Arlk |
|---|---|---|
| Impredicative `Prop` | both | `imax`: a function type into level 0 is at level 0 |
| Cumulative universes | Rocq | `lift a b A` moves a type up; the Rocq exporter inserts it wherever Rocq's kernel used subtyping |
| Definitional proof irrelevance | Lean | `irrelevant [P : Univ lz] El lz P.` |

Having both is consistent: Rocq with proof irrelevance and Lean with cumulativity both hold in
the set-theoretic model with inaccessible cardinals. Each one shows up in `#axioms` when a theorem
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
| `match` | a lambda-lifted symbol with one rule per constructor (as in Dedukti's CoqInE) |
| `fix` | lambda-lifted symbols whose rules fire only on a constructor, as Rocq's guard condition expects |
| Cumulativity | explicit `lift`, computed in the encoding's own level arithmetic |
| Fixpoints over indexed families, primitive projections, cofixpoints, primitive integers | not yet |

### Results

| Library | Theorems | Declarations | Time |
|---|---|---|---|
| Lean `Nat.add_zero` | 1 | 33 | < 0.1 s |
| Lean `Init.Data.Nat.Basic` | 308 of 310 | 822 | ~40 s |
| Rocq `Corelib.Init.Peano` | 26 of 33 | 97 | < 0.2 s |

Nothing on the way is trusted. The exporters and `arlk absorb` only produce text. The tests in
`spec/absorb_test.almd` show that a false statement is rejected, that deleting one rule breaks a
Lean proof (it really computes through Lean's definitions of `+` and `0`), and that lifting Rocq's
`nat` *down* a universe is rejected.

## The bridge

[examples/bridge.arlk](examples/bridge.arlk) loads Lean's library and Rocq's library into one
environment and works across them:

```
def to_rocq : core.El core.l1 LeanNat -> core.El core.l1 RocqNat :=      -- Lean's recursor,
  fun (n : core.El core.l1 LeanNat) =>                                     -- Rocq's constructors
    Nat.rec@1 (fun (k : core.El core.l1 Nat) => Init.Datatypes.nat)
      Init.Datatypes.nat.O
      (fun (k : core.El core.l1 Nat) (r : core.El core.l1 Init.Datatypes.nat) => Init.Datatypes.nat.S r)
      n.

theorem add_comm_in_rocq :                                                 -- Rocq's equality,
  (n m : core.El core.l1 LeanNat) ->                                       -- proved by Lean's
    core.El core.l0 (rocq_eq (to_rocq (lean_add n m)) (to_rocq (lean_add m n))) :=   -- Nat.add_comm
  fun (n m : core.El core.l1 LeanNat) =>
    Eq.rec@0@1 Nat (lean_add n m)
      (fun (b : core.El core.l1 Nat) (h : core.El core.l0 (Eq@1 Nat (lean_add n m) b)) => rocq_eq (to_rocq (lean_add n m)) (to_rocq b))
      (Init.Logic.eq.eq_refl (core.lift core.l1 core.l2 RocqNat) (to_rocq (lean_add n m)))
      (lean_add m n)
      (Nat.add_comm n m).
```

```
$ ./arlk check lib/core.arlk absorbed/lean/init_data_nat_basic.arlk absorbed/rocq/init_peano.arlk examples/bridge.arlk
to_rocq (lean_add (Init.Nat.succ Init.Nat.zero) (Init.Nat.succ Init.Nat.zero)) ⇝ Corelib.Init.Datatypes.nat.S (Corelib.Init.Datatypes.nat.S Corelib.Init.Datatypes.nat.O)
✓ theorem bridge.add_zero_in_rocq : ...
✓ theorem bridge.add_comm_in_rocq : ...
#axioms bridge.add_comm_in_rocq
  rooms:   core, Init, Corelib
ok: ... (903 declarations)
```

`tools/check-absorbed.sh` checks every absorbed library and the bridge.

## Usage

```
almide build src/main.almd -o arlk
./arlk check examples/logic.arlk
./arlk check examples/nat.arlk

./arlk check lib/core.arlk absorbed/lean/nat_add_zero.arlk
./arlk check lib/core.arlk absorbed/rocq/init_peano.arlk
tools/check-absorbed.sh

almide test            # kernel and absorb tests (spec/): good proofs pass, bad ones are rejected
almide test src/       # unit tests of term, syntax, pretty, absorb
```

## What the kernel trusts (read this before believing a result)

- **Rules are assumptions.** A rule is type-checked against its declared variable types, but Arlk
  does not yet check confluence, termination, or full subject reduction. A bad rule set can make
  a room inconsistent. That is why rules appear in `#axioms`.
- **Non-terminating rules make the checker incomplete, not unsound.** Reduction has a fuel bound.
  When it runs out, conversion fails, and a proof that would need more steps is rejected.
- **Symbols are assumptions.** The checker cannot tell a type former (`Nat`) from a logical
  axiom (`excluded_middle`). Both show up in `#axioms`.
- **λΠ only.** There are no universes or polymorphism in the core. Richer logics, Lean's
  included, are *encoded* in rooms, as Dedukti does.

## Roadmap

1. **Kernel hardening.** Confluence and termination checks for rules, and checking subject
   reduction properly instead of trusting the declared variable types.
2. **Bridges between rooms** (started: [examples/bridge.arlk](examples/bridge.arlk)). Next, declare
   a translation from room A to room B as a first-class object, check that it preserves typing,
   and transport whole theories along it. This draws on institution theory and MMT.
3. **Absorbing Lean 4 and Rocq** (started: Lean's `Init.Data.Nat.Basic` and Rocq's
   `Corelib.Init.Peano` check). The goal is not to interoperate with Lean but to take it over. Lean's
   type theory (universes, inductive types and their recursors, proof-irrelevant `Prop`,
   quotients) becomes one room, `lean`, encoded in Arlk's own core. Lean's declarations, Mathlib
   included, are translated into that room once and from then on are checked by Arlk's kernel
   alone. Lean is needed only as the source of the original text, never to trust a result. The
   translation starts from Lean's kernel export, the same way
   [lean4-rust-backend](https://github.com/O6lvl4/lean4-rust-backend) takes Lean's compiler IR out
   as JSON and rebuilds it outside Lean. Next: Metamath (ZFC), Isabelle/HOL, Agda, and Dedukti
   `.dk` files, each into a room of its own.
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
