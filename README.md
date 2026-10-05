# Arlk(アルク)

A small proof language and checker written in [Almide](https://github.com/almide/almide).

Arlk aims to be a **logic translator with a trusted core**. The kernel is small, and different
logics live in separate *rooms* on top of it. The checker always tells you which assumptions
a theorem actually rests on.

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
| **Rules** | Rewrite rules may only extend symbols of the *current* room. Each rule is type-checked (left and right sides must have convertible types under the declared variable types). |
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
-- comment
```

Unicode aliases: `→` for `->`, `λ` for `fun`, `⇒` for `=>`, `↪` for `-->`.

Every declaration ends with `.` **followed by whitespace**. `a.b` with no space is a qualified name.

## Usage

```
almide build src/main.almd -o arlk
./arlk check examples/logic.arlk
./arlk check examples/nat.arlk

almide test            # kernel tests (spec/): good proofs pass, bad ones are rejected
almide test src/       # unit tests of term, syntax, pretty
```

## What the kernel trusts (read this before believing a result)

- **Rules are assumptions.** A rule is type-checked against its declared variable types, but Arlk
  does not yet check confluence, termination, or full subject reduction. A bad rule set can make
  a room inconsistent. That is why rules appear in `#axioms`.
- **Non-terminating rules make the checker incomplete, not unsound.** Reduction has a fuel bound.
  When it runs out, conversion fails, and a proof that would need more steps is rejected.
- **Symbols are assumptions.** The checker cannot tell a type former (`Nat`) from a logical
  axiom (`excluded_middle`). Both show up in `#axioms`.
- **λΠ only.** There are no universes or polymorphism in the core. Richer logics are *encoded*
  in rooms, as Dedukti does.

## Roadmap

1. **Kernel hardening.** Confluence and termination checks for rules, and checking subject
   reduction properly instead of trusting the declared variable types.
2. **Bridges between rooms.** Declare a translation from room A to room B, check that it
   preserves typing, and transport theorems along it. This draws on institution theory and MMT.
3. **Absorbing Lean 4.** The goal is not to interoperate with Lean but to take it over. Lean's
   type theory (universes, inductive types and their recursors, proof-irrelevant `Prop`,
   quotients) becomes one room, `lean`, encoded in Arlk's own core. Lean's declarations, Mathlib
   included, are translated into that room once and from then on are checked by Arlk's kernel
   alone. Lean is needed only as the source of the original text, never to trust a result. The
   translation starts from Lean's kernel export, the same way
   [lean4-rust-backend](https://github.com/O6lvl4/lean4-rust-backend) takes Lean's compiler IR out
   as JSON and rebuilds it outside Lean. Other provers (Rocq, Isabelle/HOL, Dedukti `.dk`) follow
   the same path into rooms of their own.
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
| [almide#3392](https://github.com/almide/almide/issues/3392) wasm: fallible lambda calling a same-module fn walls | none yet: `spec/kernel_test.almd` runs on native only |
