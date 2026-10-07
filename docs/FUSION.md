# Agda and Isabelle in one program proof

[batch.almd](../examples/almide/batch.almd) flushes a pending batch, stored in
reverse order, in front of a ready batch. It is a tail-recursive Almide function:

```almide
fn flush[A](pending: List[A], ready: List[A]) -> List[A] = match pending {
  [] => ready,
  [h, ..t] => flush(t, [h] + ready),
}
```

[batch_proof.arlk](../examples/almide/batch_proof.arlk) checks its order and
length for **all finite lists and all element types in the modeled subset**.
This is one composed proof, rather than two independent demonstrations:

1. Isabelle's absorbed `Lists.itrev_rev` identifies the program's result as
   the reversal of `pending`, followed by `ready`. Checked encoding/decoding
   functions preserve the list constructors, append and the accumulator loop.
2. Agda's absorbed `Arith.plusplus_length` gives the length of that append.
   Checked bridges carry Agda's list type, natural numbers and equality into
   the native list/number/equality used by the program model.
3. Isabelle Main's `length_rev` supplies the remaining reversal-length step.

The final claim is `batch_proof.flush_length`:

```text
length(flush(pending, ready)) = add(length(pending), length(ready))
```

Its dependency inventory includes all three imported lemmas. The separate
`isabelle_list_bridge.flush_order` theorem states the exact output order;
length equality alone would not establish which elements are present.
The native `list.length_append` theorem is not used to replace Agda's law.

## Run and replay

After building Arlk, run from the repository root:

```sh
tools/fusion-check.sh ./arlk /tmp/arlk-fusion
```

The command prints its fresh work directory, containing logs and `bundle/`.
It checks the source-to-model translations, the full proof and the absence of
assumed symbols; creates a proof bundle; and replays it from `/`, without
reading the original repository. The manifest records the claim identity,
source hashes, dependency identities and assumption inventory. The bundled
Almide model includes the original program bytes and their SHA-256.

To replay that result yourself, substitute the printed directory:

```sh
./arlk replay /tmp/arlk-fusion/fusion.XXXXXX/bundle
```

The same script is a CI gate. It also requires rejection of:

- a program edit that drops pending elements, both as a stale model and as a
  freshly translated program that no longer satisfies the bridge
- an edit that keeps the length but puts the elements in the wrong order
- a same-system lemma applied to mismatched list inputs
- a bridge that discards list elements
- changed bundled proof bytes, including a forged proof with a recomputed hash
- a changed assumption inventory, dependency identity or expected claim ID

It also checks that replacing Agda's contribution with a valid native lemma
is caught by the provenance gate, even though the mathematical proof still
checks. When Almide is available, the compiled example must print
`Green Red Blue`; that single example is not a proof of compilation.

No kernel rule, assumed theorem or foreign proof oracle is added.

## What the result means

The proof has no hand-declared symbols or rewrite assumptions; it depends on
the admitted inductive types and checked definitions listed by `axioms`.
Agda source is translated into Arlk definitions, while Isabelle's proof
methods are replayed by Arlk's own proof-producing `simp`. This does **not**
mean Arlk imports either system's complete logic. The check script verifies
that the committed translations match the source, but does not run Agda or
Isabelle themselves; their existing optional source checks are separate.
Main's `length_rev` is a checked Arlk encoding of the Isabelle law, not an
Isabelle proof object. Portable replay checks the bundled Arlk sources; it
does not rerun the Agda/Isabelle source translators or carry the original
foreign-source files. Their source-to-translation checks happen in the script
before bundling.

The existing translator still labels generated models `almide 0.64.0`, while
the subset page names 0.67.0. This version-label inconsistency is not resolved
here; the model is verified against the emitter's exact output, and that label
must not be read as the compiler version used to build or run Arlk.

As with every [Almide subset proof](ALMIDE_SUBSET.md), the program claim is
about the source model's meaning. It does not prove correctness of the
compiled executable. Source hashes and bundle replay establish identity, not
the faithfulness of the translators; see [TRUST.md](TRUST.md), parts 5, 7 and 8.
