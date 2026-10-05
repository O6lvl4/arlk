#!/usr/bin/env python3
# Deterministic scaling families for Arlk (#17). Each file is a complete,
# self-contained room that checks with the default budget unless noted, so
# the families differ only in size. Nothing is random.
#
#   bench/scale.py OUTDIR      writes OUTDIR/<family>-<n>.arlk, prints the names
#
#   decls-N    N theorems in a chain, each using the one before
#   term-N     one proof term with N nested trans steps (term size)
#   shared-N   N theorems that all rest on the same 10-lemma chain
#   numeral-N  add(N, N) = 2N by computation alone (conversion work); the
#              largest size is meant to exhaust the budget, which must show
#              up as status exit:7, never as a pass or a missing row
import os, sys

HEAD = """room scale
type Nat: Type = | zero | succ(pred: Nat)
type Eq[u](A: Sort(u), a: A): (b: A) -> Sort(0) = | refl: Eq(A, a, a)
def add(m: Nat, n: Nat) -> Nat = match m {
  zero => n,
  succ(k) => Nat.succ(add(k, n)),
}
theorem trans[u, A: Sort(u), x: A, y: A, z: A](h: Eq(A, x, y), k: Eq(A, y, z)) -> Eq(A, x, z) =
  Eq.rec((z': A, e: Eq(A, y, z')) => Eq(A, x, z'), h, z, k)
theorem cong_succ[m: Nat, n: Nat](h: Eq(Nat, m, n)) -> Eq(Nat, Nat.succ(m), Nat.succ(n)) =
  Eq.rec((n': Nat, e: Eq(Nat, m, n')) => Eq(Nat, Nat.succ(m), Nat.succ(n')), Eq.refl, n, h)
theorem add_zero(n: Nat) -> Eq(Nat, add(n, Nat.zero), n) = match n {
  zero => Eq.refl,
  succ(k) => cong_succ(add_zero(k)),
}
"""

def decls(n):
    out = [HEAD, "theorem l0(n: Nat) -> Eq(Nat, add(n, Nat.zero), n) = add_zero(n)\n"]
    for i in range(1, n):
        out.append(f"theorem l{i}(n: Nat) -> Eq(Nat, add(n, Nat.zero), n) = trans(l{i-1}(n), Eq.refl)\n")
    out.append(f"axioms l{n-1}\n")
    return "".join(out)

def term(n):
    body = "add_zero(n)"
    for _ in range(n):
        body = f"trans({body}, Eq.refl)"
    return HEAD + f"theorem big(n: Nat) -> Eq(Nat, add(n, Nat.zero), n) = {body}\n"

def shared(n):
    out = [HEAD, "theorem s0(n: Nat) -> Eq(Nat, add(n, Nat.zero), n) = add_zero(n)\n"]
    for i in range(1, 10):
        out.append(f"theorem s{i}(n: Nat) -> Eq(Nat, add(n, Nat.zero), n) = trans(s{i-1}(n), Eq.refl)\n")
    for i in range(n):
        out.append(f"theorem c{i}(n: Nat) -> Eq(Nat, Nat.succ(add(n, Nat.zero)), Nat.succ(n)) = cong_succ(s9(n))\n")
    return "".join(out)

def num(k):
    return "Nat.zero" if k == 0 else "N%d" % k

def numeral(n):
    # Numerals as a chain of definitions (N1 = succ(zero), ...), so the
    # source stays linear in n while the computation grows.
    out = [HEAD]
    for k in range(1, 2 * n + 1):
        out.append(f"def N{k}: Nat = Nat.succ({num(k - 1)})\n")
    out.append(f"theorem sum: Eq(Nat, add({num(n)}, {num(n)}), {num(2 * n)}) = Eq.refl\n")
    return "".join(out)

FAMILIES = {
    "decls": (decls, [100, 200, 400, 800]),
    "term": (term, [50, 100, 200, 400]),
    "shared": (shared, [100, 200, 400, 800]),
    "numeral": (numeral, [100, 400, 1600, 6400]),
}

def main():
    out = sys.argv[1]
    os.makedirs(out, exist_ok=True)
    for fam, (gen, sizes) in FAMILIES.items():
        for n in sizes:
            name = f"{fam}-{n}"
            with open(os.path.join(out, name + ".arlk"), "w") as f:
                f.write(gen(n))
            print(name)

if __name__ == "__main__":
    main()
