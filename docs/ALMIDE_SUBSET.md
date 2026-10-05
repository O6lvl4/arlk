# The Almide subset Arlk models

`arlk absorb-almide PROGRAM.almd` turns the pure functions of an Almide program into Arlk
definitions ([src/almide_src.almd](../src/almide_src.almd)), so that properties of the program can be
stated and proved in Arlk. This page says which programs it accepts, what they mean, and what a
proof about them does and does not establish.

Pinned: the subset `arlk-almide-1`, read with the syntax of Almide 0.64.0 (the version CI pins).

## Grammar

```
program  ::= decl*
decl     ::= "type" Name generics? "=" ("|" Ctor ("(" type ("," type)* ")")?)+
           | "local"? "fn" name generics? "(" (x ":" type ("," x ":" type)*)? ")" "->" type "=" expr
           | "effect fn" ... | "test" ...                  outside the model: listed, not translated
generics ::= "[" Name ("," Name)* "]"
type     ::= Name ("[" type ("," type)* "]")?              List[A], Bool, the file's types, generics
expr     ::= primary ("+" primary)*                        `+` joins lists
primary  ::= x | f "(" expr,* ")" | Ctor | Ctor "(" expr,* ")"
           | "[" expr,* "]" | "true" | "false" | "(" expr ")"
           | "if" expr "then" expr "else" expr
           | "match" x "{" (pattern "=>" expr ","?)* "}"   only as a function's body or an arm's body
pattern  ::= "_" | x | Ctor | Ctor "(" pattern,* ")" | "true" | "false"
           | "[" "]" | "[" pattern,+ ("," ".." x)? "]"
```

Calls go only to functions of the same file. Everything else is refused at the place it is
written, as `file:line:col: ... is not in the Almide subset Arlk models`: integers, floats and
strings (and their literals and operators), `Int`/`String`/`Map`/`Set`/option types, blocks and
`let`/`var`, `mut` parameters, loops, closures and pipes, method calls, fallible results (`T!`),
guards in arms, records, and imports. There is no machine arithmetic in the subset; a program that
needs numbers declares them, e.g. `type Nat = | Zero | Succ(Nat)`.

## Semantics

A function means the Arlk function its translation defines; the built-ins mean their definitions in
[lib/almide.arlk](../lib/almide.arlk):

| Almide | Arlk |
|---|---|
| `type T[A] = \| C(X, Y)` | `type T(A: Type): Type = \| C(a1: X, a2: Y)` |
| `List[A]`, `[]`, `[a, b]`, patterns `[]`, `[h, ..t]` | `List(A)`, `List.nil`, `List.cons(a, List.cons(b, List.nil))`, `nil`, `cons(h, t)` |
| `xs + ys` | `append(xs, ys)` (recursion on `xs`) |
| `Bool`, `true`, `false`, `if c then a else b` | `Bool`, `Bool.tt`, `Bool.ff`, `ite(c, a, b)` |
| `match x { ... }` | Arlk's `match`: arms in order, nested patterns |
| `fn f[A](x: T) -> R = e` | `def f[A: Type](x: T) -> R = e` |

Arlk accepts a definition only if its recursion is structural, so every function of an accepted
program is total: evaluation terminates on every finite input. A program whose recursion is not
structural is rejected by the checker (`structural recursion`), not given a meaning.

## What a proof establishes

[examples/almide/reverse_proof.arlk](../examples/almide/reverse_proof.arlk) proves, about
[examples/almide/reverse.almd](../examples/almide/reverse.almd), that `reverse` keeps the length of
every list, resting on no assumptions (`axioms` lists none). The model it is checked against,
[examples/almide/reverse.arlk](../examples/almide/reverse.arlk), starts with the SHA-256 of the
program's bytes and the program itself, and names the source lines of each definition;
`arlk absorb-almide reverse.almd --verify reverse.arlk` checks that the model is still exactly the
translation of the program. Changing `reverse` to drop elements makes the model stale and the old
proof fail to check ([tools/almide-check.sh](../tools/almide-check.sh), run by CI). The result can
be bundled and replayed like any other (`arlk bundle reverse_proof.reverse_length ...`); the
bundled model carries the program's bytes and hash.

What it rests on beyond Arlk's checker: that the translator parses the subset as Almide does and
maps each construct to the definition above (the table is the subset's semantics, and the
translator is in the trusted base of such a result). It is a statement about the program's meaning
in this semantics. **It is not a statement about the executable the Almide compiler builds.** CI
runs the compiled program on an example and compares the output with the model's evaluation; that
tests the model, it does not prove that compilation preserves it.

## Later stages

Executable correctness is a separate claim, with its own milestones: the correspondence between
this model and Almide's own IR for the subset; preservation for one lowering pass at a time; then
the emitted Rust, with the Rust compiler and runtime as stated assumptions. Until that chain
exists, no result here is about compiled code.
