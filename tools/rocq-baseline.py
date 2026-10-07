#!/usr/bin/env python3
"""Compare a check of an absorbed Rocq export with its baseline.

    tools/rocq-baseline.py EXPORT.json CHECK.log EXPECTED-FAILURES

A target (a name the export was asked for) fails when the exporter skipped
it or the check did not accept it. The run passes only when the failing
targets are exactly the listed ones: a new failure is a regression, and a
listed target that now checks must be removed from the list, so the list
only shrinks. Prints the counts and any difference.
"""
import json
import re
import sys


def main() -> int:
    export_path, log_path, expected_path = sys.argv[1:4]
    export = json.load(open(export_path))
    log = open(log_path, encoding="utf-8").read()
    if not re.search(r"^(ok: |\d+ failed, \d+ declarations checked)", log, re.M):
        print("the check did not finish (no summary line)")
        return 1
    # A checked name may carry the export's root room first (Corelib.).
    names = re.findall(r"^✓ \w+ ([^:\s]+):", log, re.M)
    checked = set(names) | {n.split(".", 1)[1] for n in names if "." in n}
    targets = export["targets"]
    skipped = [s["name"] for s in export.get("skipped", [])]
    failing = sorted(set(skipped) | {t for t in targets if t not in checked})
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
