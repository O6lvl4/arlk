#!/usr/bin/env python3
# The implementation-change challenge (#17): change reverse from the
# snoc version to the accumulator version, keeping the claim
# (len(rev(xs)) = len(xs) for every list), and report what actually changed.
#
#   bench/change.py [ARLK]
#
# For each language: lexical tokens (tools/tokens.py's counting) removed
# and added per section (FOUNDATION, PROGRAM, PROOF, AUDIT), from a token
# diff of the two fixtures; and, for Arlk, that both versions check. These
# are counts of changed source, not of human effort.
import difflib, os, re, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
TOKEN = re.compile(r"[A-Za-z_][A-Za-z_0-9.]*|[0-9]+|->|=>|==|<>|[^\s]")


def sections(path):
    comment = "#" if path.endswith(".bend") else "//"
    out, cur = {}, "HEADER"
    for line in open(path, encoding="utf-8"):
        m = re.match(r"\s*" + re.escape(comment) + r"\s*(FOUNDATION|PROGRAM|PROOF|AUDIT|PROPERTY)\b", line)
        if m:
            cur = m.group(1)
            continue
        code = line.split(comment, 1)[0]
        out.setdefault(cur, []).extend(TOKEN.findall(code))
    return out


def diff(a, b):
    removed = added = 0
    for op, i1, i2, j1, j2 in difflib.SequenceMatcher(None, a, b, autojunk=False).get_opcodes():
        if op in ("replace", "delete"):
            removed += i2 - i1
        if op in ("replace", "insert"):
            added += j2 - j1
    return removed, added


def main():
    arlk = sys.argv[1] if len(sys.argv) > 1 else None
    os.chdir(ROOT)
    print("| language | section | before | after | removed | added |\n|---|---|---:|---:|---:|---:|")
    for ext in ("arlk", "bend"):
        a = sections(f"bench/fixtures/reverse/baseline.{ext}")
        b = sections(f"bench/fixtures/reverse/accumulator.{ext}")
        total = [0, 0, 0, 0]
        for sec in sorted(set(a) | set(b)):
            x, y = a.get(sec, []), b.get(sec, [])
            r, d = diff(x, y)
            total = [total[0] + len(x), total[1] + len(y), total[2] + r, total[3] + d]
            print(f"| {ext} | {sec} | {len(x)} | {len(y)} | {r} | {d} |")
        print(f"| {ext} | all | {total[0]} | {total[1]} | {total[2]} | {total[3]} |")
    if arlk:
        for f in ("baseline", "accumulator"):
            code = subprocess.run([arlk, "check", f"bench/fixtures/reverse/{f}.arlk"], capture_output=True).returncode
            print(f"check reverse/{f}.arlk: {'pass' if code == 0 else 'FAIL'}")
            if code != 0:
                sys.exit(1)


if __name__ == "__main__":
    main()
