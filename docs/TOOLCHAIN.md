# The pinned Almide toolchain

CI builds Almide from the exact source commit
[`963df767bc9c1ef7f4e7cc3d6f0662073e66baec`](https://github.com/almide/almide/commit/963df767bc9c1ef7f4e7cc3d6f0662073e66baec)
(0.67.0 development; the batch merged in almide/almide#3443) with `cargo build --release --locked`
and Rust 1.96.1, and logs the built binary's SHA-256. The source pin is authoritative; a release
with the same version label need not contain the same fixes. wasmtime v47.0.2 is pinned by checksum.

## Build prerequisites

For the native checker, install Git, Rust through `rustup`, and Almide at the CI source pin.
From a directory outside the Arlk checkout:

```sh
rustup toolchain install 1.96.1 --profile minimal
export RUSTUP_TOOLCHAIN=1.96.1
git clone https://github.com/almide/almide.git almide-src
git -C almide-src checkout 963df767bc9c1ef7f4e7cc3d6f0662073e66baec
(cd almide-src && cargo build --release --locked)
export PATH="$(pwd)/almide-src/target/release:$PATH"
```

Then return to the Arlk checkout and run the [quick start](../README.md#quick-start).
The native example does not need Lean, Rocq, Agda, Isabelle, OpenTheory, or wasmtime.
For the complete checks, follow [.github/workflows/ci.yml](../.github/workflows/ci.yml),
including its checksum-pinned wasmtime installation, then run `tools/ci.sh`. Those checks also
use shell utilities, Python 3, and network access to fetch the pinned OpenTheory articles.

## Test-count verification

[tools/toolchain-check.sh](../tools/toolchain-check.sh) runs every test file natively (wasmtime
hidden) and on WASM, and passes only when each file reports as many passing tests as it has `test`
blocks. It does not trust exit statuses: `almide test --json` exits 0 when a test fails
(almide/almide#3449). The files the compiler declines to lower to WASM are listed in
[tools/toolchain/wasm-walls](../tools/toolchain/wasm-walls). A listed file that starts running on
WASM fails the check until it is removed from the list, so the list only shrinks.

## Historical comparison: v0.64.0 and 963df767b

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

In that historical source snapshot, the rest of `tools/ci.sh` gave the same results with both compilers: Lean `Nat.Lemmas` 9 failed,
1564 checked; Rocq `Corelib.Init` 4 failed, 969 checked; every example, check script and rejection
fixture. Peak memory of the whole local run with 963df767b was 6.5 GB, from the Lean check.

These failure counts describe that old comparison, not the current baseline. See
[COVERAGE.md](COVERAGE.md#recorded-results) and `tools/ci.sh` for the current expectations.

Arlk's workarounds for Almide bugs listed below are kept.
Each one is to be removed only in its own change, with a test showing it is no longer needed.

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
| [almide#3400](https://github.com/almide/almide/issues/3400) native codegen drops the element of a one-element list pattern over a variant | nested `match` on the element |
| [almide#3401](https://github.com/almide/almide/issues/3401) same-named types in two modules resolve to the other module's type | `metamath.almd` names its record `Proving`, not `Ctx` |
| [almide#3402](https://github.com/almide/almide/issues/3402) recursive call with swapped params passes `&E` for `E` | bind the swapped arguments with `let` first (`metamath.apart`) |
| [almide#3404](https://github.com/almide/almide/issues/3404) functional `map.set` on a record field copies the whole map | the kernel commits each declaration in place (`mut env`, `map.insert`) |
| [almide#3405](https://github.com/almide/almide/issues/3405) two arguments calling a `mut`-param fn share one hoisted value (miscompile) | one `let` per argument in `conv` |
| [almide#3409](https://github.com/almide/almide/issues/3409) `map.get(m, k) ?? k` borrows and moves `k` in one call | `match` on the lookup |
| [almide#3410](https://github.com/almide/almide/issues/3410) a lambda capturing a `mut` parameter lowers to `c.get()` | `for` loop with `list.push` in `elab.constant` |
| [almide#3413](https://github.com/almide/almide/issues/3413) native build panics on a list pattern nested in a variant pattern | `ty_arg` / `pair` helpers in `hol.almd` |
| [almide#3414](https://github.com/almide/almide/issues/3414) a guard on a variable bound in a nested variant pattern runs before the binding | test the variable in the arm body (`hol.dest_eq`) |
| [almide#3415](https://github.com/almide/almide/issues/3415) `err(..)` in a let-bound match takes the enclosing `Unit!` type | one small function per object kind (`pop_tyop`, `as_ty`, ...) |
| [almide#3416](https://github.com/almide/almide/issues/3416) tuple-of-variants match leaves recursive payloads boxed | one value at a time (`as_list`, `as_var`) |
| [almide#3421](https://github.com/almide/almide/issues/3421) a variant pattern nested in `some(...)` leaves payloads boxed | fetch, then match (`patterns.sub_at`) |
| [almide#3431](https://github.com/almide/almide/issues/3431) a closure passing a captured `var` to a `mut` parameter emits `.get()` on `&mut` | explicit loop (`session.first_changed`) |
| [almide#3434](https://github.com/almide/almide/issues/3434) an argument used again after a call is deep-copied at the call | describe terms only during diagnostic rechecks of failed declarations; substitute only dependent arguments |
| [almide#3437](https://github.com/almide/almide/issues/3437) comparing a match-arm binding of a recursive variant with `==` emits `&T == T` | compare the scrutinee itself (`checker.shape`) |
| [almide#3439](https://github.com/almide/almide/issues/3439) same-named types in two modules still clash (as #3401) | `agda.almd`'s types are prefixed (`AExpr`, `ACx`, ...) |
| [almide#3440](https://github.com/almide/almide/issues/3440) a list from a tuple binding is moved by `|> list.map` in a loop | map once before the loop (`agda.absorb`) |
| [almide#3449](https://github.com/almide/almide/issues/3449) `almide test --json` exits 0 when a test fails | `tools/toolchain-check.sh` counts passed tests instead of reading exit statuses |
| [almide#3450](https://github.com/almide/almide/issues/3450) wasm: `==` on nested distinct types walls (`hold-depth-i32`) | the six files that compare a `Decl` run natively (`tools/toolchain/wasm-walls`) |
