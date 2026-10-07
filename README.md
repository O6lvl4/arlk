# Arlk (アルク)

A proof language and checker written in [Almide](https://github.com/almide/almide).
Write proofs in programmer-friendly syntax, recheck selected libraries from other provers,
and carry results between theories through checked views, with their assumptions visible.

## Quick start

Use the [pinned Almide and Rust toolchain](docs/TOOLCHAIN.md#build-prerequisites).
From the repository root, build the checker and run a self-contained proof:

```sh
almide build src/main.almd -o arlk
./arlk check examples/logic.arlk
```

Then try an equation chain from [examples/calc.arlk](examples/calc.arlk):

```arlk
room calcdemo uses eq, logic, nat

theorem rotate(a: Nat, b: Nat, c: Nat) -> Eq(Nat, add(add(a, b), c), add(add(b, c), a)) = calc add(add(a, b), c) {
  = add(a, add(b, c)) by add_assoc(a, b, c),
  = add(add(b, c), a) by add_comm(a, add(b, c)),
}

axioms rotate
```

Run the checked-in file with the standard-library files it uses, in order:

```sh
./arlk check lib/std/eq.arlk lib/std/logic.arlk lib/std/nat.arlk examples/calc.arlk
```

The proof changes `(a + b) + c` into `(b + c) + a`, using associativity and commutativity.
Each `calc` step becomes a proof term checked by the kernel. `axioms rotate` reports its
dependencies; this example uses native inductive types and proved lemmas, with no
hand-declared symbols or rewrite rules. No external prover is needed for these examples.

## What can I do with it?

- **Write and check proofs.** Dependent types, inductive families, records, pattern matching,
  equation chains, `rewrite`, `by simp`, induction, and bounded proof search.
  Start with the [language guide](docs/LANGUAGE.md) and [native standard library](docs/STDLIB.md)
- **Reuse work from other provers.** Absorb Lean and Rocq exports, Metamath databases and
  OpenTheory articles; translate supported Agda and Isabelle source fragments.
  Read the [import guide](docs/ABSORBING.md) and [exact coverage and gaps](docs/COVERAGE.md)
- **Connect theories explicitly.** Keep assumptions in separate *rooms*, then use checked
  views or a proved correspondence. The [Lean–Rocq bridge](examples/bridge.arlk) and
  [transport example](examples/transport.arlk) reuse Lean arithmetic on Rocq's numbers.
  See [bridges and views](docs/VIEWS.md)
- **Prove properties of small Almide programs.** Translate the supported pure subset into
  an Arlk model and check a property such as preservation of list length.
  See the [subset and source/model boundary](docs/ALMIDE_SUBSET.md)
- **Hand someone a result they can recheck.** Bundle sources, claim identities and assumption
  inventories; replay them from scratch. Use a separate trusted policy for an
  [exact-proof audit](docs/PROOF_AUDIT.md)

## How it fits together

The kernel checks terms using dependent function types, universes and conversion, including
user-declared rewrite rules (λΠ-calculus modulo rewriting). Native inductive types have
additional admission checks. Elaborators and proof tools produce terms for the kernel to check.

A room holds one theory's symbols, definitions, rules and theorems. It sees only rooms it
explicitly uses, and is sealed when left. `axioms NAME` follows a result's dependencies and
lists the assumptions it rests on. A view maps one room into another; translated proofs are
checked again in their destination.

Lean and Rocq imports currently share [lib/core.arlk](lib/core.arlk), an explicit encoding
with cumulative universes and proof irrelevance. Native Arlk proofs do not need that encoding.
See the [design and language details](docs/LANGUAGE.md#design).

## What a successful check does—and doesn't—establish

A result is checked relative to its theory and assumptions. Arlk does not support every feature
or library of the systems above; [COVERAGE.md](docs/COVERAGE.md) records the supported fragments,
measured library checks and remaining work.

- **Rewrite rules and declared symbols are assumptions.** Rules are type-checked, but general
  confluence, termination and full subject reduction are not established
- **Imported meanings need separate scrutiny.** Checking emitted proofs does not certify that
  an exporter faithfully encoded the source logic or intended statement
- **Program proofs concern the translated model.** They do not prove that an Almide-compiled
  executable preserves the model's semantics
- **The checker has a trusted implementation.** Kernel code, native type admission and the
  runtime/toolchain remain in the trusted base. Passing tests are not a soundness proof

Read the [trust map](docs/TRUST.md) before relying on a result. Budget exhaustion is reported
as a failed check, never silently accepted as a proof.

## Where to go next

- [Language guide](docs/LANGUAGE.md): syntax, universes, recursion, tactics and examples
- [Standard library](docs/STDLIB.md): equality, logic, naturals, lists and well-founded recursion
- [Absorbing prover libraries](docs/ABSORBING.md): formats, encodings and commands
- [Coverage and roadmap](docs/COVERAGE.md): supported features, library results and gaps
- [Bridges and views](docs/VIEWS.md): interpreting and transporting proofs between theories
- [Usage and workflows](docs/USAGE.md): command examples, the language server and proof bundles
- [Packages](docs/PACKAGES.md) and [incremental checking](docs/INCREMENTAL.md): reuse and edit cycles
- [Almide subset](docs/ALMIDE_SUBSET.md) and [proof audits](docs/PROOF_AUDIT.md): source-bound models
- [Toolchain](docs/TOOLCHAIN.md) and [trust map](docs/TRUST.md): reproducibility and assumptions

## Development checks

```sh
almide test
almide test src/
tools/ci.sh
```

The full CI script builds Arlk, checks examples and absorbed libraries, counts tests on each
supported backend, and checks that deliberately invalid inputs fail for the expected reason.
Some checks fetch pinned data or take substantial time; see [TOOLCHAIN.md](docs/TOOLCHAIN.md).
Run `ARLK_FULL=1 tools/ci.sh` to include the larger optional Lean list-library check.

The [push CI workflow](.github/workflows/ci.yml) and separate daily
[Lean](.github/workflows/lean.yml), [Rocq](.github/workflows/rocq.yml) and
[Metamath](.github/workflows/setmm.yml) workflows define what is checked for each run.
