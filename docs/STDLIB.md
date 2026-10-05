# The native standard library

`lib/std` is a small foundation for native proofs: equality, propositions, naturals and lists, with
the lemmas proofs about programs keep needing. Everything in it is an inductive type, a definition
or a theorem proved from those types: no `symbol`, no `rule`, no axiom (CI checks this, and
`axioms` on any of its theorems lists no symbols and no rules). It is checked by the same kernel,
with the same inductive-type admission, as a client's own file. It is separate from
`lib/core.arlk`, which encodes the logics of absorbed provers and has a different trust role.

## Loading

Files are loaded in order, each after what it uses. Load only what a client needs:

| Room | File | Needs |
|---|---|---|
| `eq` | `lib/std/eq.arlk` | — |
| `logic` | `lib/std/logic.arlk` | — |
| `nat` | `lib/std/nat.arlk` | `eq` |
| `almide` | `lib/almide.arlk` | — |
| `list` | `lib/std/list.arlk` | `eq`, `nat`, `almide` |

```
arlk check lib/std/eq.arlk lib/std/nat.arlk lib/almide.arlk lib/std/list.arlk YOUR.arlk
```

A client names the rooms it uses: `room mine uses eq, nat, almide, list`. Nothing from `core`,
Lean, Rocq or HOL is loaded.

## API

Universe levels (`u`, `v`) and the arguments in `[...]` are implicit: they are inferred at each use.

**eq**: `Eq[u](A: Sort(u), a: A): (b: A) -> Sort(0)` with `Eq.refl`.

| Name | Statement |
|---|---|
| `subst(P, h, px)` | from `h: Eq(A, x, y)` and `px: P(x)`, `P(y)` |
| `symm(h)` | `Eq(A, x, y) -> Eq(A, y, x)` |
| `trans(h, k)` | `Eq(A, x, y) -> Eq(A, y, z) -> Eq(A, x, z)` |
| `cong(f, h)` | `Eq(A, x, y) -> Eq(B, f(x), f(y))` |
| `cong2(f, h, k)` | `Eq(A, a, a') -> Eq(B, b, b') -> Eq(C, f(a, b), f(a', b'))` |

**logic**: in Prop, `True` (`intro`), `False`, `And` (`intro(left, right)`), `Or` (`inl`, `inr`;
eliminates only into Prop), `Not(a) = a -> False`, `Iff` (`intro(mp, mpr)`), `Exists[u](A, P)`
(`intro(w, h)`); `absurd(A, h)`, `and_swap`, `or_swap`. In Type, for evidence a computation carries:
`Unit` (`unit`), `Empty`, `Prod[u, v](A, B)` (`pair(fst, snd)`), `Sum[u, v](A, B)` (`left`,
`right`), `elim_empty(A, h)`.

**nat**: `Nat` (`zero`, `succ(pred)`); `add` recursing on its first argument, `pred`.

| Name | Statement |
|---|---|
| `cong_succ(h)` | `Eq(Nat, m, n) -> Eq(Nat, succ(m), succ(n))` |
| `succ_inj(h)` | `Eq(Nat, succ(m), succ(n)) -> Eq(Nat, m, n)` |
| `zero_add(n)` | `add(zero, n) = n` (by computation) |
| `add_zero(n)` | `add(n, zero) = n` |
| `add_succ(m, n)` | `add(m, succ(n)) = succ(add(m, n))` |
| `add_comm(m, n)` | `add(m, n) = add(n, m)` |
| `add_assoc(a, b, c)` | `add(add(a, b), c) = add(a, add(b, c))` |

**list**: lists are `almide.List(A)` (`nil`, `cons(head, tail)`), the meaning of Almide's
`List[A]`, with `append` (Almide's `xs + ys`), `Bool` (`tt`, `ff`) and `ite` from
[lib/almide.arlk](../lib/almide.arlk). There is one list type: a proof about a modeled Almide
program and a native proof use the same `List`, and the subset's semantics
([ALMIDE_SUBSET.md](ALMIDE_SUBSET.md)) are unchanged. Defined here: `length`, `map`.

| Name | Statement |
|---|---|
| `append_nil(xs)` | `append(xs, nil) = xs` |
| `append_assoc(xs, ys, zs)` | `append(append(xs, ys), zs) = append(xs, append(ys, zs))` |
| `length_append(xs, ys)` | `length(append(xs, ys)) = add(length(xs), length(ys))` |
| `length_snoc(xs, x)` | `length(append(xs, [x])) = succ(length(xs))` |
| `length_map(f, xs)` | `length(map(f, xs)) = length(xs)` |

## Clients

- [examples/std/reverse.arlk](../examples/std/reverse.arlk): two reverses (by `append`, and with an
  accumulator) keep the length of every list. Length preservation only; the identity also has it.
- [examples/std/sort.arlk](../examples/std/sort.arlk): insertion sort on lists of naturals returns
  an ordered list (`SortedB(sort(xs), zero)`, nondecreasing, carrying its lower bound) in which every
  natural occurs as often as in the input (`count(x, sort(xs)) = count(x, xs)`).
- [examples/std/almide_bridge.arlk](../examples/std/almide_bridge.arlk): the reverse of the modeled
  Almide program ([examples/almide](../examples/almide)) is the native `rev` on every list, so the
  native length proof is a proof about the program, and the library's lemmas apply to the model
  with no conversion.

[tools/std-check.sh](../tools/std-check.sh), run by CI, checks the library and the clients, confirms
that no symbol or rule is involved, and checks that semantic mutations are rejected for the right
reason: a reverse that drops elements, a false length law, a corrupted proof step, an accumulator
that drops elements, a sort that puts the larger element first (rejected in the order proof), a sort
that drops insertions with the order proof taken out (rejected in exactly the multiplicity proof),
and a false `add_zero` in the library. It also prints lexical token counts (client and library
apart, by [tools/tokens.py](../tools/tokens.py)) and fresh-process check times, which are advisory.

## Measured

Lexical tokens ([tools/tokens.py](../tools/tokens.py), the counting of #17) at the commit that added
the library:

| File | Tokens | Code lines |
|---|---:|---:|
| examples/std/reverse.arlk (two reverses, four theorems, two claims of #17) | 458 | 24 |
| examples/std/sort.arlk | 1316 | 92 |
| lib/std/eq.arlk | 552 | 13 |
| lib/std/logic.arlk | 469 | 31 |
| lib/std/nat.arlk | 439 | 31 |
| lib/almide.arlk | 146 | 15 |
| lib/std/list.arlk | 543 | 27 |

The sort client used by #17 had 1714 tokens, 390 of them local foundation; on the library it has
1316, with no local equality, naturals, lists or evidence types. The library itself is 2149 tokens,
loaded once for any number of clients; the sort client uses `eq`, `logic`, `nat`, `almide` and
`list` (its dependency closure in `axioms` lists `eq.trans`, `eq.symm`, `eq.cong` and the types).
These are source measurements, not a measure of human effort. Checking the library alone took
0.06 s, the reverse client with it 0.08 s, the sort client with it 0.14 s (one fresh process each,
one Apple-silicon laptop; advisory).
