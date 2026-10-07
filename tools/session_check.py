#!/usr/bin/env python3
# Incremental checking (#21), against a fresh check after every edit.
#
#   tools/session_check.py ARLK WORKDIR [--scale]
#
# Builds a deterministic sequence of edits (each step a directory with
# files.txt), runs them through one `arlk session` process, and after every
# step compares the session's digest with a fresh process's
# `arlk qed --digest` of the same files: outcomes, statements, proofs,
# assumption inventories and diagnostics must be identical. Each step also
# states what must be checked again (and why) and what may be reused.
#
# With --scale, also measures no-op, local proof edit and shared
# dependency edit at increasing sizes, beside a fresh full check (printed,
# advisory).
import os, re, shutil, subprocess, sys, time

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ARLK = os.path.abspath(sys.argv[1])
WORK = os.path.abspath(sys.argv[2])
fails = 0


def say(ok, what):
    global fails
    print(("pass  " if ok else "FAIL  ") + what)
    if not ok:
        fails = 1


BASE = {
    "eq.arlk": open(os.path.join(ROOT, "lib/std/eq.arlk")).read(),
    "nat.arlk": open(os.path.join(ROOT, "lib/std/nat.arlk")).read(),
    "almide.arlk": open(os.path.join(ROOT, "lib/almide.arlk")).read(),
    "list.arlk": open(os.path.join(ROOT, "lib/std/list.arlk")).read(),
    "reverse.arlk": open(os.path.join(ROOT, "examples/std/reverse.arlk")).read(),
    "extra.arlk": """room extra uses eq, nat
symbol Tok: Type
symbol t0: Tok
symbol tick(x: Tok) -> Tok
symbol P(x: Tok) -> Sort(0)
symbol p0: P(t0)
theorem uses_tick: P(t0) = p0
type Box: Type =
  | box(n: Nat)
def unbox(b: Box) -> Nat = match b {
  box(n) => n,
}
theorem unbox_box(n: Nat) -> Eq(Nat, unbox(Box.box(n)), n) = Eq.refl
""",
    "views.arlk": open(os.path.join(ROOT, "examples/views.arlk")).read(),
}
ORDER = ["eq.arlk", "nat.arlk", "almide.arlk", "list.arlk", "reverse.arlk", "extra.arlk", "views.arlk"]


def edit(files, name, old, new):
    assert old in files[name], (name, old)
    out = dict(files)
    out[name] = files[name].replace(old, new, 1)
    return out


# (label, files, order, expectations): expectations are
#   ("reuse-at-least", n), ("check-at-most", n), ("checked", "file:line" or substring of a reason),
#   ("fails", "file:line"), ("same-as", step index)
steps = []


def step(label, files, order=ORDER, **exp):
    steps.append((label, files, order, exp))


s0 = dict(BASE)
step("initial", s0)
# Nothing changed: only rooms, rules, views, translations and directives
# (always checked) are checked again.
step("no-op", s0, reuse_at_least=50, only_always=True)
# A proof edited, its statement kept: only that unit is checked again.
s_body = edit(s0, "reverse.arlk", "cons(h, t) => trans(length_snoc(rev(t), h), cong_succ(rev_length(t))),",
              "cons(h, t) => trans(length_snoc(rev(t), h), cong(Nat.succ, rev_length(t))),")
step("proof body", s_body, reasons=["reverse.arlk:26: new or edited"], not_checked=["reverse.arlk:40"])
step("revert proof body", s0, same_as=0)
# A statement made false: it is rejected, and everything resting on it
# is checked again (and now fails).
s_stmt = edit(s0, "nat.arlk", "theorem add_zero(n: Nat) -> Eq(Nat, add(n, Nat.zero), n) = match n {",
              "theorem add_zero(n: Nat) -> Eq(Nat, add(n, Nat.zero), Nat.succ(n)) = match n {")
step("false statement", s_stmt, fails=["nat.arlk:33", "nat.arlk:43", "reverse.arlk:26"], reasons=["nat.arlk:43"])
step("revert statement (accepted again)", s0, same_as=0)
# A definition's body: everything that computes with it is checked again.
s_def = edit(s0, "nat.arlk", "  succ(k) => Nat.succ(add(k, n)),", "  succ(k) => add(k, Nat.succ(n)),")
step("definition body", s_def, reasons=["rests on nat.add, which changed"])
step("revert definition", s0, same_as=0)
# A type's constructors: its users are checked again.
s_ind = edit(s0, "extra.arlk", "  | box(n: Nat)\n", "  | box(n: Nat)\n  | empty\n")
step("type constructor", s_ind, reasons=["extra.arlk"], fails=["extra.arlk:11"])
s_pos = edit(s0, "extra.arlk", "  | box(n: Nat)\n", "  | box(n: Nat)\n  | bad(f: Box -> Nat)\n")
step("positivity", s_pos, fails=["extra.arlk:8"])
step("revert type", s0, same_as=0)
# Universe parameters of a lemma.
s_univ = edit(s0, "eq.arlk", "theorem symm[u, A: Sort(u), x: A, y: A]", "theorem symm[A: Type, x: A, y: A]")
step("universe parameters", s_univ, reasons=["rests on eq.symm, which changed"])
step("revert universes", s0, same_as=0)
# A rewrite rule added: what mentions its head is checked again.
s_rule = edit(s0, "extra.arlk", "theorem uses_tick: P(t0) = p0\n",
              "rule tick(x) = x  where x: Tok\ntheorem uses_tick: P(t0) = p0\ntheorem by_rule: P(tick(t0)) = p0\n")
step("rewrite rule added", s_rule, reasons=["extra.arlk"])
s_rule2 = edit(s_rule, "extra.arlk", "rule tick(x) = x  where x: Tok\n", "")
step("rewrite rule removed", s_rule2, fails=["extra.arlk:8"])
step("revert rule", s0, same_as=0)
# Proof irrelevance declared for a type.
s_irr = edit(s0, "extra.arlk", "theorem uses_tick: P(t0) = p0\n",
             "irrelevant Tok\ntheorem uses_tick: P(t0) = p0\ntheorem any_tok: P(tick(t0)) = p0\n")
step("irrelevance declared", s_irr, reasons=["extra.arlk"])
step("revert irrelevance", s0, same_as=0)
# Room visibility: the header lists fewer rooms; its units are checked again.
s_room = edit(s0, "reverse.arlk", "room reverse uses eq, nat, almide, list", "room reverse uses eq, nat, almide")
step("room visibility", s_room, fails=["reverse.arlk:26"])
step("revert room", s0, same_as=0)
# A view's image changed (to an equal term): views and what uses them.
s_view = edit(s0, "views.arlk", "  Holds = (p: Sort(0)) => p,", "  Holds = (p: Sort(0)) => ((x: Sort(0)) => x)(p),")
step("view image", s_view, reasons=["views.arlk"])
s_view_bad = edit(s0, "views.arlk", "  Holds = (p: Sort(0)) => p,", "  Holds = (p: Sort(0)) => p -> p,")
step("view image broken", s_view_bad, fails=["views.arlk"])
step("revert view", s0, same_as=0)
# A declaration added that a later name could now resolve to.
s_shadow = edit(s0, "reverse.arlk", "// PROGRAM\n", "// PROGRAM\ndef length_snoc: Nat = Nat.zero\n")
step("name added that later units may resolve to", s_shadow, reasons=["may resolve differently"])
step("revert addition", s0, same_as=0)
# Dependency order: list before nat (list uses nat).
order2 = ["eq.arlk", "almide.arlk", "list.arlk", "nat.arlk", "reverse.arlk", "extra.arlk", "views.arlk"]
step("dependency order", s0, order=order2, fails=["list.arlk:10"])
step("revert order", s0, same_as=0)
# A declaration removed: what used it fails (unknown name), not a stale success.
s_rm = edit(s0, "list.arlk", "theorem length_map", "theorem length_map_renamed")
step("declaration renamed away", s_rm, reasons=["list.arlk"])
step("final revert", s0, same_as=0)


def write_step(i, files, order):
    d = os.path.join(WORK, "step-%02d" % i)
    os.makedirs(d, exist_ok=True)
    for n in order:
        with open(os.path.join(d, n), "w") as f:
            f.write(files[n])
    with open(os.path.join(d, "files.txt"), "w") as f:
        f.write("\n".join(order) + "\n")
    return d


def main():
    shutil.rmtree(WORK, ignore_errors=True)
    os.makedirs(WORK)
    dirs = [write_step(i, f, o) for i, (_, f, o, _) in enumerate(steps)]
    out = subprocess.run([ARLK, "session"] + dirs, capture_output=True, text=True, cwd="/")
    with open(os.path.join(WORK, "session.log"), "w") as f:
        f.write(out.stdout + out.stderr)
    say(out.returncode == 0, f"session ran (exit {out.returncode})")
    blocks = re.split(r"^(?=step \d+ )", out.stdout, flags=re.M)[1:]
    say(len(blocks) == len(steps), f"{len(blocks)} of {len(steps)} steps reported")
    digests = []
    for i, ((label, files, order, exp), block) in enumerate(zip(steps, blocks)):
        head = block.splitlines()[0]
        m = re.search(r"checked (\d+), reused (\d+)", head)
        checked, reused = int(m.group(1)), int(m.group(2))
        sd = re.search(r"^digest: (\w+)", block, re.M).group(1)
        digests.append(sd)
        fresh = subprocess.run([ARLK, "check"] + [os.path.join(dirs[i], n) for n in order] + ["--digest"],
                               capture_output=True, text=True, cwd="/")
        fd = re.search(r"^digest: (\w+)", fresh.stdout, re.M)
        with open(os.path.join(WORK, "fresh-%02d.txt" % i), "w") as f:
            f.write(fresh.stdout)
        ok = fd is not None and fd.group(1) == sd
        say(ok, f"step {i:2} {label}: same as a fresh check (checked {checked}, reused {reused})")
        reasons = [l for l in block.splitlines() if l.startswith("  check ")]
        for want in exp.get("reasons", []):
            say(any(want in r for r in reasons), f"step {i:2} {label}: checked again because of `{want}`")
        for want in exp.get("not_checked", []):
            say(not any(want + ":" in r for r in reasons), f"step {i:2} {label}: {want} reused")
        for want in exp.get("fails", []):
            say(any(l.startswith("failed ") and want in l for l in fresh.stdout.splitlines()),
                f"step {i:2} {label}: {want} rejected")
        if "reuse_at_least" in exp:
            say(reused >= exp["reuse_at_least"], f"step {i:2} {label}: reused {reused} >= {exp['reuse_at_least']}")
        if exp.get("only_always"):
            others = [r for r in reasons if "always checked" not in r]
            say(not others, f"step {i:2} {label}: only always-checked units checked again ({len(others)} others)")
        if "check_at_most" in exp:
            say(checked <= exp["check_at_most"], f"step {i:2} {label}: checked {checked} <= {exp['check_at_most']}")
        if "same_as" in exp:
            say(sd == digests[exp["same_as"]], f"step {i:2} {label}: back to step {exp['same_as']}'s result")
    if "--scale" in sys.argv:
        scale()
    sys.exit(fails)


def scale():
    print("\nsize  fresh_ms  noop_ms  noop_checked  proof_edit_ms  proof_checked  shared_edit_ms  shared_checked")
    for n in (100, 200, 400, 800):
        body = ["room s", "type Nat: Type = | zero | succ(pred: Nat)",
                "type Eq[u](A: Sort(u), a: A): (b: A) -> Sort(0) = | refl: Eq(A, a, a)",
                "def add(m: Nat, n: Nat) -> Nat = match m {", "  zero => n,", "  succ(k) => Nat.succ(add(k, n)),", "}",
                "theorem trans[u, A: Sort(u), x: A, y: A, z: A](h: Eq(A, x, y), k: Eq(A, y, z)) -> Eq(A, x, z) =",
                "  Eq.rec((z': A, e: Eq(A, y, z')) => Eq(A, x, z'), h, z, k)",
                "theorem l0(n: Nat) -> Eq(Nat, add(Nat.zero, n), n) = Eq.refl"]
        for i in range(1, n):
            body.append(f"theorem l{i}(n: Nat) -> Eq(Nat, add(Nat.zero, n), n) = trans(l{i-1}(n), Eq.refl)")
        base = "\n".join(body) + "\n"
        proof = base.replace(f"theorem l{n-1}(n: Nat) -> Eq(Nat, add(Nat.zero, n), n) = trans(l{n-2}(n), Eq.refl)",
                             f"theorem l{n-1}(n: Nat) -> Eq(Nat, add(Nat.zero, n), n) = trans(Eq.refl, l{n-2}(n))")
        # Every theorem computes with add: changing its body (keeping
        # add(zero, n) = n) checks them all again.
        shared = base.replace("  succ(k) => Nat.succ(add(k, n)),", "  succ(k) => add(k, Nat.succ(n)),")
        dirs = []
        for k, text in enumerate([base, base, proof, base, shared]):
            d = os.path.join(WORK, f"scale-{n}-{k}")
            os.makedirs(d, exist_ok=True)
            open(os.path.join(d, "s.arlk"), "w").write(text)
            open(os.path.join(d, "files.txt"), "w").write("s.arlk\n")
            dirs.append(d)
        t = time.monotonic()
        subprocess.run([ARLK, "check", os.path.join(dirs[0], "s.arlk")], capture_output=True)
        fresh_ms = (time.monotonic() - t) * 1000
        out = subprocess.run([ARLK, "session"] + dirs, capture_output=True, text=True).stdout
        rows = re.findall(r"checked (\d+), reused (\d+), (\d+) ms", out)
        print(f"{n:4}  {fresh_ms:8.0f}  {rows[1][2]:>7}  {rows[1][0]:>12}  {rows[2][2]:>13}  {rows[2][0]:>13}  {rows[4][2]:>14}  {rows[4][0]:>14}")


if __name__ == "__main__":
    main()
