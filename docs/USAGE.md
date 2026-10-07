# Usage and workflows

Build prerequisites and the pinned CI toolchain are in [docs/TOOLCHAIN.md](TOOLCHAIN.md).
Commands below run from the repository root; use `./arlk`, or put the built binary on `PATH`
when a command is written as `arlk`. Uppercase names are placeholders for your own files or claim.

`arlk qed FILE...` checks every proof in the files, in order, and exits 0 only when all of what
was to be shown is shown (1 when something is rejected, 2 on a usage error). `arlk check` is the
same command under its earlier name and keeps working.

[tools/ci.sh](../tools/ci.sh) runs the build, tests, native examples, committed absorbed libraries,
OpenTheory library checks, and rejection fixtures. Lean and Rocq are not needed to recheck the
committed `.arlk` sources. `Corelib.Init` is expected to pass completely; the separate daily Rocq
standard-library workflow checks `PeanoNat` and `Lists.List` against fixed baselines. Recorded coverage lives in
[docs/COVERAGE.md](COVERAGE.md#recorded-results). A green run establishes those checks on that
commit, not a soundness proof; see [docs/TRUST.md](TRUST.md).

```
almide build src/main.almd -o arlk
./arlk qed examples/logic.arlk
./arlk qed examples/nat.arlk

./arlk qed lib/core.arlk absorbed/lean/nat_add_zero.arlk
./arlk qed lib/core.arlk absorbed/rocq/init_peano.arlk
./arlk qed absorbed/metamath/set_prop.arlk
./arlk absorb-mm set.mm --upto stoic4b -o out.arlk
./arlk bundle CLAIM FILE... -o DIR && ./arlk replay DIR
./arlk absorb-almide examples/almide/reverse.almd --verify examples/almide/reverse.arlk
./arlk qed lib/hol.arlk
tools/opentheory/fetch.sh base-1.221 otlib > order.txt && ./arlk absorb-hol $(cat order.txt) -o base.arlk
tools/check-absorbed.sh

almide test            # kernel and absorb tests (spec/): good proofs pass, bad ones are rejected
almide test src/       # unit tests of term, syntax, pretty, absorb
```

## The native standard library

[lib/std](../lib/std) holds equality (`refl`, `symm`, `trans`, `cong`, `subst`), propositions and
evidence types, naturals with addition's laws, lists (the List of Almide's model, with length
and append's laws), and well-founded recursion (`Acc`, `WellFounded`, `fix` and its unfolding law,
`<` on Nat, measures), all proved from inductive types alone: no symbol, rule or axiom. A native client
loads only the files it needs and redeclares none of it; see [docs/STDLIB.md](STDLIB.md).

```
arlk qed lib/std/eq.arlk lib/std/logic.arlk lib/std/nat.arlk lib/almide.arlk lib/std/list.arlk examples/std/sort.arlk
```

Quotient types live beside it in [lib/quot.arlk](../lib/quot.arlk): Lean's `Quot`, `Quot.mk`, `Quot.lift`
(which computes on a class), `Quot.ind` and `Quot.sound`, declared as assumptions that `axioms` lists,
and function extensionality (`funext`) proved from them. [examples/std/quot.arlk](../examples/std/quot.arlk)
builds the integers as pairs of naturals up to `a + d = c + b`, lifts negation to classes and proves
`neg(neg(z)) = z` for every integer.

## Editors: `arlk lsp`

`arlk lsp` is a language server (Language Server Protocol, on standard input and output). On open,
change and save it checks the document with every declaration kept going and reports each failure
on its line; hovering a name shows its type. The files a document needs come from its comment line
`arlk qed A.arlk B.arlk THIS.arlk` (the convention the examples and the library already follow),
relative to the workspace root. It runs the same checker as `arlk qed`
([src/lsp.almd](../src/lsp.almd); [tools/lsp/smoke.py](../tools/lsp/smoke.py) drives a session in CI).

## Incremental checking

`arlk session STEP_DIR...` checks a sequence of edits in one process. It reuses each declaration
that an edit cannot have affected, and says why each other one was checked again. Proofs are opaque
to their users, so editing a proof checks one declaration. Changing a definition, rule, type, room
or view checks everything that rests on it. After every edit, the result must be identical to a
fresh check (`arlk qed --digest`); CI checks this over 29 edits of every kind. See
[docs/INCREMENTAL.md](INCREMENTAL.md).

## Packages: checked libraries and views, reused

A project names the packages it requires in a data-only manifest, each pinned by hash. A package
pins its sources and the identities of what it exports: claims, checked views, assumption
footprints. `arlk project DIR` checks everything again from scratch, in dependency order,
recomputes every pinned identity, shows the routes and assumptions behind each claim, and refuses
a claim that rests on assumptions the project does not allow. The result can travel as a bundle
bound to its packages. See [docs/PACKAGES.md](PACKAGES.md).

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
machine integers: [docs/ALMIDE_SUBSET.md](ALMIDE_SUBSET.md)) and writes its functions as Arlk
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
$ arlk qed lib/almide.arlk examples/almide/reverse.arlk examples/almide/reverse_proof.arlk
✓ theorem reverse_proof.reverse_length: (A: Type, xs: almide.List[0](A)) -> Eq[1](Nat, length(A, almide_reverse.reverse(A, xs)), length(A, xs))
axioms reverse_proof.reverse_length
  symbols: (none)
```

`reverse` terminates on every list (its translated definition uses checked structural
recursion) and keeps its length, with no assumptions at all. A version that drops elements makes
the model stale (`absorb-almide --verify`) and the proof fail; CI checks both, and compares the
model with the compiled program on an example. This is a theorem about the program's meaning in the
subset's semantics, not about the executable the compiler builds; that needs a preservation proof
for the compiler, which is later work.

## Proof bundles: a result that travels

```
arlk bundle transport.rocq_add_comm lib/core.arlk absorbed/lean/init_data_nat_basic.arlk \
            absorbed/rocq/init_peano.arlk examples/transport.arlk -o add_comm
arlk replay add_comm                        # elsewhere, later: no Lean, Rocq, network or search
```

Use `arlk replay add_comm --expect ID` when you have obtained the expected full identity
from a trusted source outside the candidate bundle.

A bundle is data: the source files a result was checked from, and a manifest with their SHA-256,
the claim and its statement, a hash of every declaration it depends on, its assumption inventory
(what `axioms` prints) and a claim identity over all of these. The recorded "checked" is only
metadata: `replay` verifies the hashes, checks every file again from scratch (inductive types are
admitted again, views checked again), recomputes the statement, dependencies, assumptions and
identity, and compares them with the manifest. Each kind of failure has its own exit status: 1 the
proof does not check, 3 a file does not match its hash or is not a bundled source, 4 the claim,
a dependency, the assumptions or the expected identity differ, 5 an unsupported format or checker
semantics (`--revalidate` checks it again under this checker, and says so), 6 a file is missing, 7
a budget ran out. Nothing in a bundle is run. [tools/bundle-check.sh](../tools/bundle-check.sh),
run by CI, bundles the Lean→Rocq arithmetic result and a composed-view result, replays them from
a clean directory, and tampers with a proof, a claim, a view image, a dependency hash, the
assumption inventory, the paths and the versions, each of which must fail as stated.

A matching identity means: the same claim, resting on the same declarations and assumptions,
checked by a checker of the same semantics. It does not mean that the sources say what their
authors meant; that is the separate obligation described in [docs/TRUST.md](TRUST.md).

For a separately trusted acceptance policy, [proof audits](PROOF_AUDIT.md) pin an
expected bundle identity, restrict its assumptions, and verify a bundled Almide model against
the original source bytes. The existing reverse-length proof is the first checked example;
the JSON report records fresh verifier outcomes and makes the model/executable boundary explicit.
