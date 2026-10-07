# An independent policy for a proof bundle

`tools/proof-audit.py` adds an **exact-proof audit** around the existing `arlk replay`.
Its JSON policy is chosen by the reviewer, outside the candidate bundle. It pins the
expected theorem and declaration/dependency identity, restricts hand-declared
assumptions, and can bind a bundled model to an original Almide source.

The design is inspired by [Lean Comparator](https://github.com/leanprover/comparator),
as used by [OpenAI's mathematical proof collection](https://github.com/openai/math/tree/main/lean/ComparatorChallenges).
No upstream source code is copied and neither repository is a runtime dependency.
This wrapper does not implement Comparator's comparison of independently compiled
Lean environments, sandboxing, alternative-proof acceptance, or external kernels.

## Try the existing reverse-length proof

From the repository root, with a built, trusted checker:

```sh
./arlk bundle reverse_proof.reverse_length lib/almide.arlk \
  examples/almide/reverse.arlk examples/almide/reverse_proof.arlk -o /tmp/reverse-bundle
python3 tools/proof-audit.py examples/almide/reverse.audit.json /tmp/reverse-bundle \
  --arlk ./arlk --source-root . > /tmp/reverse-audit.json
python3 tools/proof-audit-check.py ./arlk
```

The bundled proof already exists: reverse preserves list length. The new result is
an auditable connection between that exact accepted claim, its assumptions, the
original source bytes, and the checked model. The policy permits no hand-declared
symbols or rewrite rules for this example.

The tool requires Python 3.9+ and a POSIX system providing directory-relative
no-follow opens and file-size resource limits (tested on Linux). Paths must not
traverse symlinks, including parent directories; use canonical physical paths when
an OS exposes a directory through an alias. No packages or network are needed.

## The trusted policy

`examples/almide/reverse.audit.json` contains:

- `format`: policy format `1`
- `claim`: the fully qualified expected declaration name
- `claim_id`: a separately reviewed, 64-character lowercase SHA-256 identity from
  an accepted bundle. It covers the exact statement, the claim's own declaration
  and proof, all recorded dependency fingerprints, and the assumption inventory
- `permitted_symbols`: exact hand-declared names allowed in that claim's
  transitive assumption inventory
- `permitted_rules`: exact rule inventory strings, including `[rule-id]`, allowed
  in that claim's transitive assumption inventory
- `models`: optional bindings, each with `source` (relative to `--source-root`),
  `sha256` (original source bytes), and `model` (an exact manifest-listed bundled
  source path). The original source's basename is preserved for translation

Empty allowlists mean no such assumptions are permitted. Native inductive types
still rely on Arlk's admission checks. Computation-on-literals assumptions and
unknown inventory categories are always rejected in this first version.
Unrelated unused declarations are outside the selected claim's assumption policy.

Do not take the policy or checker executable from the candidate, regenerate pins
inside a checking job, or automatically bless a new identity on failure. A proof,
dependency, source, or checker change needs review. Even another valid proof may
have a different identity. The policy owner must also review that the theorem
actually expresses the desired property about the bound model: merely listing a
model among the proof's sources does not establish that semantic relationship.

## What happens and what the report means

1. Strictly parse the trusted policy and candidate manifest. Unknown or duplicate
   fields, source paths, and dependency names fail closed. Version 1 supports plain
   bundles only; package/project/provenance manifests are explicitly rejected
2. Copy only manifest-listed regular source files into a private temporary
   snapshot. Reject traversal, symlinks, special files, and stale source hashes.
   Snapshot each bound original source and check its trusted hash too
3. Run the selected checker on that snapshot with `replay --expect CLAIM_ID`.
   Replay rechecks all sources and recomputes the statement, dependencies, and
   assumption inventory. The bundle's `recorded: checked` text is never evidence
4. Enforce the external assumption allowlists against the inventory that replay
   has just recomputed and matched
5. Run `absorb-almide ORIGINAL --verify BUNDLED_MODEL` for each binding, using the
   same original bytes that were hashed. A valid sidecar model cannot satisfy it

Standard output is JSON, including policy/manifest/source/checker SHA-256 values,
the checked statement and semantics, each command's actual exit code, diagnostic
output tails, and explicit passed/failed/inconclusive/not-run stages. No requested
model bindings is reported as `source_model_boundary: not_requested`.

Exit `0` means all requested audit conditions passed; `1` means the audit was not
accepted (including malformed input or checker failure); `2` means a checker
command timed out, exhausted its proof budget/log limit, crashed, or returned an
unexpected exit code. Neither rejection nor an
inconclusive result establishes that the proposition is false. A normal audit
failure still prints JSON; invalid CLI arguments use argparse's usage error.

Each input file and checker log is limited to 16 MiB, bundled sources to 64 MiB in
total and 128 files, and each checker command to 60 seconds by default. These are
operational bounds for small proofs, not a security sandbox.

## Trust boundary

This is fresh replay under the selected Arlk checker, not an independent kernel
or signed attestation. The checker executable, Python wrapper, policy, original
source tree, OS, and Arlk's [trusted base](TRUST.md) remain trusted and must not be
modifiable by the candidate. The executable's hash identifies its bytes; it does
not certify their origin or correctness. Treat exported reports as ordinary,
unsigned evidence records, not as self-authenticating certificates.

The source/model check establishes that the bundled model is the current
translator's output for those exact source bytes. The reverse-length theorem is
about that model's pure subset semantics. It does not prove the translator itself
correct, compiler semantic preservation, machine-code correctness, effectful
`main`, or arbitrary Almide behavior outside the [modeled subset](ALMIDE_SUBSET.md).
