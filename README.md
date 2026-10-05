# Arlk(アルク)

A small proof language and checker written in [Almide](https://github.com/almide/almide).

Arlk aims to be a **logic translator with a trusted core**. The kernel is small, and different
logics live in separate *rooms* on top of it. The checker always tells you which assumptions
a theorem actually rests on.

Arlk is meant for programmers, not only mathematicians. Its syntax reads like code (`fun`, `->`,
`symbol`, `rule`, `room`), Unicode is only an optional alias, and errors say what was expected
and what was found.

**Lean 4 is absorbed, not linked.** Lean's whole `Init.Data.Nat.Basic` module (308 of its 310
theorems, 822 declarations with their dependencies) has been translated into Arlk source and is
checked by Arlk's kernel alone, in about 40 seconds. See [Absorbing Lean](#absorbing-lean).

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

## Absorbing Lean

```
tools/lean-export/Export.lean     Lean side: write a declaration and its dependencies as JSON
arlk absorb EXPORT.json -o F      Arlk side: turn that JSON into Arlk source
arlk check F                      check it; Lean is not involved
```

```
$ cd tools/lean-export && lean --run Export.lean Nat.add_zero > ../../absorbed/lean/nat_add_zero.json
$ ./arlk absorb absorbed/lean/nat_add_zero.json -o absorbed/lean/nat_add_zero.arlk
$ ./arlk check absorbed/lean/nat_add_zero.arlk
✓ theorem Init.Nat.add_zero : lean.El lean.l0 (lean.pi lean.l1 lean.l0 Nat (fun (n : lean.El lean.l1 Nat) => Eq@1 Nat (HAdd.hAdd@0@0@0 Nat Nat Nat (instHAdd@0 Nat instAddNat) n (OfNat.ofNat@0 Nat Nat.zero (instOfNatNat Nat.zero))) n))
#axioms Init.Nat.add_zero
  rooms:   lean, Init
  ...
ok: absorbed/lean/nat_add_zero.arlk (52 declarations)
```

How it works:

- **Lean's type theory is the `lean` room**, written in Arlk itself (see the top of
  [nat_add_zero.arlk](absorbed/lean/nat_add_zero.arlk)). A universe level is a value of `Lvl`, the
  types of universe `l` are values of `Univ l`, `El l A` turns one into an Arlk type, and Lean's
  function types are values `pi a b A B` that a rule unfolds into Arlk function types. `imax`,
  which makes functions into `Prop` propositions, is a pair of rewrite rules.
- **Everything else is the `Init` room**: 33 declarations from Lean's prelude, including `Nat`,
  `Eq`, the `HAdd`/`Add`/`OfNat` classes, `Nat.rec`, the structural recursion machinery
  (`Nat.below`, `Nat.brecOn`), `Nat.add` and `rfl`. Inductive types become symbols, recursors get
  one rewrite rule per constructor, and class projections get one rule each.
- **Universe polymorphism is removed** by instantiating each constant at the levels it is used at.
  `Eq@1` is `Eq.{1}`.
- **Nothing on the way is trusted.** The exporter and `arlk absorb` only produce text. The tests
  in `spec/absorb_test.almd` show that a false statement (`n + 1 = n`) is rejected and that
  deleting one projection rule breaks the proof. The proof really goes through Lean's definitions
  of `+` and `0`.

What the `lean` room already covers, beyond the basics:

| Lean kernel feature | How Arlk does it |
|---|---|
| Definitional proof irrelevance | `irrelevant [P : Univ lz] El lz P.` A room may declare that all values of a type family are equal. Lean's room does, and a Rocq room would not. |
| K-like reduction (`Eq.rec` on any proof of `a = a`) | The exporter emits a rule whose major premise is a variable. Proof irrelevance makes it type-check. |
| Quotients (`Quot.lift`, `Quot.ind`) | Ordinary rewrite rules. `Quot.sound` stays an axiom and shows up in `#axioms`. |
| Projections, including into `Prop` | One rule per projection function. |

| Module | Theorems | Declarations | Time |
|---|---|---|---|
| `Nat.add_zero` | 1 | 33 | < 0.1 s |
| `Init.Data.Nat.Basic` | 308 of 310 | 822 | ~40 s |

The two theorems left out are universe-polymorphic. Not absorbed yet: universe polymorphism
(constants are instantiated at concrete levels instead), structure eta, and Lean's fast kernel
arithmetic on numerals (numerals are spelled out as `Nat.succ` chains).

`tools/check-absorbed.sh` checks every absorbed file.

## Usage

```
almide build src/main.almd -o arlk
./arlk check examples/logic.arlk
./arlk check examples/nat.arlk

./arlk check absorbed/lean/nat_add_zero.arlk

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
2. **Bridges between rooms.** Declare a translation from room A to room B, check that it
   preserves typing, and transport theorems along it. This draws on institution theory and MMT.
3. **Absorbing Lean 4** (started: `Nat.add_zero` checks). The goal is not to interoperate with Lean but to take it over. Lean's
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
| [almide#3392](https://github.com/almide/almide/issues/3392) wasm: fallible lambda calling a same-module fn walls | none yet: `spec/` runs on native only |
| [almide#3393](https://github.com/almide/almide/issues/3393) `almide fmt` moves trailing comments and collapses variants | sources are not run through `almide fmt` for now |
| [almide#3397](https://github.com/almide/almide/issues/3397) native `list.slice` clones the whole list per call | copy ranges with `list.get` in the lexer |
