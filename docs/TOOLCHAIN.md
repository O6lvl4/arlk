# The pinned Almide toolchain

CI builds Almide from the exact source commit
[`963df767bc9c1ef7f4e7cc3d6f0662073e66baec`](https://github.com/almide/almide/commit/963df767bc9c1ef7f4e7cc3d6f0662073e66baec)
(0.67.0 development; the batch merged in almide/almide#3443) with `cargo build --release --locked`
and Rust 1.96.1, and logs the built binary's SHA-256. No published release contains #3443 yet;
when one does, CI should pin that release by checksum instead. wasmtime v47.0.2 is pinned by
checksum.

[tools/toolchain-check.sh](../tools/toolchain-check.sh) runs every test file natively (wasmtime
hidden) and on WASM, and passes only when each file reports as many passing tests as it has `test`
blocks. It does not trust exit statuses: `almide test --json` exits 0 when a test fails
(almide/almide#3449). The files the compiler declines to lower to WASM are listed in
[tools/toolchain/wasm-walls](../tools/toolchain/wasm-walls). A listed file that starts running on
WASM fails the check until it is removed from the list, so the list only shrinks.

## v0.64.0 and 963df767b on the same sources

Both compilers ran on the same Arlk sources (b54bd0a's tree before the absorbed files were
regenerated), with the same wasmtime v47.0.2, on macOS arm64.

| File | v0.64.0 native | v0.64.0 WASM | 963df767b native | 963df767b WASM |
|---|---|---|---|---|
| spec/absorb_test.almd | 6/7 (*) | walled | 6/7 (*) | walled (#3450) |
| spec/isabelle_test.almd | 3/3 | walled | 3/3 | walled (#3450) |
| spec/kernel_test.almd | 113/113 | walled | 113/113 | walled (#3450) |
| spec/metamath_test.almd | 7/7 | walled | 7/7 | walled (#3450) |
| src/absorb.almd | 4/4 | 4/4 | 4/4 | 4/4 |
| src/agda.almd | 4/4 | walled | 4/4 | walled (#3450) |
| src/almide_src.almd | 2/2 | 2/2 | 2/2 | 2/2 |
| src/bundle.almd | 2/2 | 2/2 | 2/2 | 2/2 |
| src/hol.almd | 4/4 | walled | 4/4 | **4/4** |
| src/inductive.almd | **fails to build** | 1/1 | 1/1 | 1/1 |
| src/lsp.almd | 2/2 | 2/2 | 2/2 | 2/2 |
| src/metamath.almd | 3/3 | walled | 3/3 | **3/3** |
| src/package.almd | 3/3 | walled | 3/3 | **3/3** |
| src/pretty.almd | **fails to build** | 5/5 | 5/5 | 5/5 |
| src/syntax.almd | 11/11 | walled | 11/11 | walled (#3450) |
| src/term.almd | 4/4 | 4/4 | 4/4 | 4/4 |

(*) One test compares a committed absorbed file that the tree under test had not regenerated yet;
the same on both, and 7/7 once regenerated (the full run below).

No file that ran on WASM with v0.64.0 stops running with 963df767b; three more run. Every file
now builds and passes natively (v0.64.0's native build of two of them stops with Rust type errors in the generated code, the
boxing of imported recursive variants of almide/almide#3422).
All six files still walled compare an Arlk AST value with `assert_eq`, which exceeds the WASM
emitter's fixed pool of held slots (almide/almide#3450).

The rest of `tools/ci.sh` gives the same results with both compilers: Lean `Nat.Lemmas` 9 failed,
1564 checked; Rocq `Corelib.Init` 4 failed, 969 checked; every example, check script and rejection
fixture. Peak memory of the whole local run with 963df767b was 6.5 GB, from the Lean check.

Arlk's workarounds for Almide bugs (README, "Almide issues found while building Arlk") are kept.
Each one is to be removed only in its own change, with a test showing it is no longer needed.
