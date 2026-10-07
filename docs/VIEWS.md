# Bridges and checked views

Arlk can keep theories in separate rooms and explicitly relate them. See
[TRUST.md](TRUST.md) for the assumptions and interpretation boundary.

## The bridge

[examples/bridge.arlk](../examples/bridge.arlk) loads Lean's library and Rocq's library into one
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
    Init.Logic.eq.eq_refl@1(RocqNat, to_rocq(lean_add(n, m))),
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
```

`tools/check-absorbed.sh` checks every absorbed library and the bridge.

## Views: one logic read in another

A *view* interprets one room in another: each symbol of the source gets a term of the current room,
and Arlk checks every image against the symbol's type (as the view translates it) and every rule of
the source by conversion. `translate` then carries a declaration of any room built on the source,
with everything it uses, into the current room, where it is **checked again**. The translated proof
is checked relative to the destination room's assumptions. A checked view does not by itself
certify that this interpretation is the one a reader intended.

[examples/hol_types.arlk](../examples/hol_types.arlk) reads HOL (room `hol`, which absorbed OpenTheory
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

[examples/metamath_logic.arlk](../examples/metamath_logic.arlk) does the same for Metamath: set.mm's
propositional calculus (`wff`, `Prf`, `wn`, `wi`, ax-mp, ax-1, ax-2, ax-3) read as Arlk's propositions,
with ax-3 proved from excluded middle. set.mm's proof of Peirce's law, carried over, becomes
`theorem peirce_law(p, q) -> ((p -> q) -> p) -> p`, and `axioms peirce_law` lists `mmlogic.em` alone.

Excluded middle in Arlk's own logic, proved by HOL's library and resting on exactly the axioms Lean
assumes.

Views can be found and composed. `views` lists every view with what it maps, what it carries as
assumptions and what its images rest on; `routes from S` lists the ways from room S into the
current room through at most two views, each with the assumptions it rests on, and when there are
several it shows them all and picks none. `view ac from a via ab, bc` composes two views: each
image of `ab` is carried along `bc`, and the result goes through the same checks as a written view,
so a theorem translated along `ac` is the one translated along `ab` and then `bc`. Discovery only
proposes: nothing is used until it is declared and checked. CI rejects a degenerate view that reads every HOL statement as true, and
[spec/fixtures/reject](../spec/fixtures/reject) has views with a wrongly typed image, a broken rule,
and an attempt to replace a theorem.

### Lean's theorems about Rocq's numbers

[examples/transport.arlk](../examples/transport.arlk) goes further: a checked correspondence between
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
