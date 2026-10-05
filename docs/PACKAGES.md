# Packages

A package is an already checked library and its checked views, made reusable by a second project
through a local, versioned, data-only manifest. Packages work offline: there is no registry, nothing
is downloaded, and nothing is run.

```
arlk package pin PKG.arlkpkg        fill in source hashes and export identities
arlk package verify PKG.arlkpkg     resolve, check, and compare a package with its pins
arlk project DIR [--bundle OUT]     check DIR/arlk-project.txt against the packages it requires
```

## A package manifest

```
arlk-package: 1
name: views-abc
version: 1.0.0
semantics: arlk-kernel-1
root: ..                                     # sources are relative to this; none may leave it
requires: std 1.0.0 <SHA-256 of std's manifest> std.arlkpkg
source: <SHA-256> examples/views.arlk        # in checking order
export-room: c                               # rooms a requirer may `use`
export-claim: c.agree <claim identity>       # the bundle claim-id of #15
export-view: c.ac <view identity>            # SHA-256 of the checked view (images, carried, via, rests on)
assumes: c.agree (none) <SHA-256 of its full assumption inventory>
```

`arlk package pin` writes every hash and identity: it checks the package (and what it requires)
first, so only a checked package can be pinned. A manifest is data. Any key other than these is
refused, and no field names a command, script or hook.

## A project manifest

```
arlk-project: 1
name: client-a
requires: std 1.0.0 <SHA-256> ../../../packages/std.arlkpkg
requires: views-abc 1.0.0 <SHA-256> ../../../packages/views-abc.arlkpkg
allow-room: b                                # optional: rooms whose symbols/rules claims may rest on
source: main.arlk
claim: client_a.keep_comm
```

`arlk project DIR` loads every package in dependency order and verifies, for each one:

1. Its manifest hash, name, version and semantics against the pin of whatever requires it.
2. Every source's hash. Every path must stay inside the package root.
3. No room is declared by two packages.
4. Checking every source from scratch, into one environment: inductive types are admitted again
   and views are checked again.
5. Each export identity and assumption footprint, recomputed and compared with its pin.

Then it checks the project's own files, which may `use` only the rooms exported by the packages
it requires directly (or its own rooms). For each claim, it prints the routes it took (the
exported views, with their images and what they rest on) and the complete assumption inventory.
It refuses a claim that rests on a symbol or rule of a room the project does not allow. The
default allows none: such a claim may rest on inductive types and definitions only. A package
update whose claim newly rests on more is refused in the same way.

A package reached along several paths (a diamond) is loaded once. Paths are resolved relative to
the manifest that names them, so loading does not depend on the working directory.

| Exit | Meaning |
|---|---|
| 1 | a declaration fails to check |
| 3 | integrity: a hash differs, or a path leaves its root |
| 4 | identity: an export, view or assumption list differs from its pin |
| 5 | version: manifest format, semantics, or required version |
| 6 | missing: a manifest or source is not there |
| 7 | out of budget |
| 8 | a dependency cycle (the chain is named) |
| 9 | conflict: two different packages with one name, a room declared twice, a room used but not exported |
| 10 | a claim rests on assumptions the project does not allow |

## Results that travel

`arlk project DIR --bundle OUT` writes a bundle of #15. Its manifest also records each package
(name, version, manifest hash) and the project manifest's hash, and copies the package manifests
into `OUT/pkg/`. It adds a `provenance-id` over the claim identity, the packages and the project.
`arlk replay OUT` performs the usual fresh check from the bundled sources. It also verifies:

- each bundled package manifest against its recorded hash;
- that every source the package pins is among the bundle's sources;
- every export identity, again, in the replayed environment;
- the provenance identity (`--expect` accepts it as well as the claim-id).

## What is trusted

The same as for any check: the kernel, the inductive-type admission, the view checks (see
[TRUST.md](TRUST.md)). A package's recorded identities are claims to be verified, never
authority. A populated environment is never deserialized; every load checks every source again.
Sharing checking work across processes would be a separate, incremental-checking design (#21).

## Examples

- [packages/std.arlkpkg](../packages/std.arlkpkg): the native library ([STDLIB.md](STDLIB.md)).
- [packages/views-abc.arlkpkg](../packages/views-abc.arlkpkg): the views of
  [examples/views.arlk](../examples/views.arlk), exporting the composed view `c.ac`.
- [examples/projects/client-a](../examples/projects/client-a) and
  [client-b](../examples/projects/client-b): two projects on both packages, each proving a new
  theorem through the view, with no assumption.

[tools/package-check.sh](../tools/package-check.sh), run by CI, covers the cases above in fresh
processes from `/`. These include:

- a diamond;
- every failure status;
- the allowed-assumption policy, including a dependency update;
- a bundle and its replay;
- tampering with a source, a view image, a pinned hash, an assumption list, a bundled package or
  the recorded provenance;
- a path that leaves its root;
- a manifest with a non-data key.
