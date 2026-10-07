#!/usr/bin/env python3
"""Compare a check of an absorbed Rocq export with its baseline.

    tools/rocq-baseline.py EXPORT.json ABSORBED.arlk CHECK.log EXPECTED-FAILURES

A target (a name the export was asked for) fails when the exporter skipped
it or the check (with --keep-going) reported its declaration as failed. The run passes only when the failing
targets are exactly the listed ones: a new failure is a regression, and a
listed target that now checks must be removed from the list, so the list
only shrinks. Prints the counts and any difference.
"""
import json
import re
import sys


def main() -> int:
    export_path, arlk_path, log_path, expected_path = sys.argv[1:5]
    export = json.load(open(export_path))
    log = open(log_path, encoding="utf-8").read()
    if not re.search(r"^(ok: |\d+ failed, \d+ declarations checked)", log, re.M):
        print("the check did not finish (no summary line)")
        return 1
    # The declaration starting at each line of the absorbed file.
    starts = {}
    for i, line in enumerate(open(arlk_path, encoding="utf-8"), 1):
        m = re.match(r"(?:symbol|def|theorem|structure) ([^\s:(]+)", line)
        if m:
            starts[i] = m.group(1)
    failed = set()
    for n in re.findall(r"^✗ [^\n]*?\.arlk:(\d+): ", log, re.M):
        if int(n) in starts:
            failed.add(starts[int(n)])
    targets = export["targets"]
    skipped = [s["name"] for s in export.get("skipped", [])]
    # Targets are Rocq's full names; declarations drop the Corelib root.
    def decl(t):
        return t.split(".", 1)[1] if t.startswith("Corelib.") else t
    declared = set(starts.values())
    # A target checks when its declaration is in the file and did not fail.
    failing = sorted(set(skipped) | {t for t in targets if decl(t) in failed or decl(t) not in declared})
    expected = sorted({l.strip() for l in open(expected_path) if l.strip() and not l.startswith("#")})
    print(f"{len(targets) + len(skipped)} targets: {len(targets) + len(skipped) - len(failing)} check, {len(failing)} do not ({len(skipped)} not exported)")
    new = sorted(set(failing) - set(expected))
    fixed = sorted(set(expected) - set(failing))
    for n in new:
        print(f"new failure: {n}")
    for n in fixed:
        print(f"now checks, remove it from {expected_path}: {n}")
    return 1 if new or fixed else 0


if __name__ == "__main__":
    sys.exit(main())
