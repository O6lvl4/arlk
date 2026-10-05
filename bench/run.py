#!/usr/bin/env python3
# The measurement runner of the benchmark (#17). See bench/README.md.
#
#   bench/run.py --arlk ./arlk --out DIR [--batches 5] [--per 3] [--seed 20261005]
#                [--lanes arlk,scale,reuse] [--hol-bool FILE]
#                [--lane NAME=TEMPLATE ...] [--build "almide build src/main.almd -o arlk"]
#
# Every run is a fresh process started by bench/launch (built from
# bench/launch.c), which reports the exit status, the wall time and the
# child's peak RSS. Jobs run in batches; within a batch the order of
# (job, repetition) is shuffled with a seeded generator, so the order is
# random but reproducible. The page cache is warm (nothing is dropped);
# no claim is made about cold caches.
#
# Writes into DIR:
#   raw.csv        one row per run: batch, position, lane, job, rep, status,
#                  outcome, wall_s, maxrss_kib
#   summary.json   per job: expected outcome, outcomes seen, median/min/max
#                  wall and RSS, per-batch medians
#   summary.md     the same as a table
#   reuse.json     cross-logic track: claim identity, route, assumptions
#   environment.txt  machine, toolchain, hashes of binary and inputs, flags,
#                  seed, cache state, setup (build) time when measured
#
# Outcomes: pass, reject (exit 1 for another reason), budget (out of
# budget), timeout, crash (signal), error. Budget exhaustion is its own
# outcome and is never folded into pass or dropped from the tables. A job
# whose outcome differs from its expected outcome is listed and makes the
# runner exit 1; timings never do.
import argparse, hashlib, json, os, platform, random, shlex, statistics, subprocess, sys

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
STD = ["lib/std/eq.arlk", "lib/std/logic.arlk", "lib/std/nat.arlk", "lib/almide.arlk", "lib/std/list.arlk"]


def sha256(path):
    h = hashlib.sha256()
    with open(path, "rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def sh(cmd):
    try:
        return subprocess.run(cmd, shell=True, capture_output=True, text=True, timeout=60).stdout.strip()
    except Exception:
        return ""


def build_launcher(out):
    exe = os.path.join(out, "launch")
    subprocess.run(["cc", "-O2", "-o", exe, os.path.join(ROOT, "bench", "launch.c")], check=True)
    return exe


def jobs_for(lanes, arlk, out, hol_bool, extra):
    """(lane, name, argv, expected outcome, timeout seconds, inputs)"""
    jobs = []
    if "arlk" in lanes:
        empty = os.path.join(out, "empty.arlk")
        with open(empty, "w") as f:
            f.write("room empty\n")
        fx = "bench/fixtures"
        for name, files in [
            ("empty", [empty]),
            ("reverse-baseline", [f"{fx}/reverse/baseline.arlk"]),
            ("reverse-accumulator", [f"{fx}/reverse/accumulator.arlk"]),
            ("sort", [f"{fx}/sort/sort.arlk"]),
            ("std-library", STD),
            ("std-reverse", STD + ["examples/std/reverse.arlk"]),
            ("std-sort", STD + ["examples/std/sort.arlk"]),
        ]:
            jobs.append(("arlk-check", name, [arlk, "check"] + files, "pass", 120, files))
    if "scale" in lanes:
        sdir = os.path.join(out, "scale")
        names = subprocess.run([sys.executable, os.path.join(ROOT, "bench", "scale.py"), sdir],
                               check=True, capture_output=True, text=True).stdout.split()
        for name in names:
            path = os.path.join(sdir, name + ".arlk")
            # The numeral family's two largest sizes are deeper than the
            # elaborator's bound: they must end as budget, not crash.
            expected = "budget" if name in ("numeral-1600", "numeral-6400") else "pass"
            jobs.append(("arlk-scale", name, [arlk, "check", path], expected, 300, [path]))
    if "reuse" in lanes:
        transport = ["lib/core.arlk", "absorbed/lean/init_data_nat_basic.arlk", "absorbed/rocq/init_peano.arlk", "examples/transport.arlk"]
        jobs.append(("arlk-reuse", "lean-to-rocq-transport", [arlk, "check"] + transport, "pass", 1200, transport))
        jobs.append(("arlk-reuse", "two-view-composition", [arlk, "check", "examples/views.arlk"], "pass", 120, ["examples/views.arlk"]))
        if hol_bool:
            hol = ["lib/hol.arlk", hol_bool, "examples/hol_types.arlk"]
            jobs.append(("arlk-reuse", "hol-to-native-view", [arlk, "check"] + hol, "pass", 600, hol))
    for spec in extra:
        # NAME=TEMPLATE, {file} replaced by each fixture of the same family;
        # used for lanes of other tools (Bend frontend, --verdict, replay).
        name, template = spec.split("=", 1)
        for fixture in ["bench/fixtures/reverse/baseline", "bench/fixtures/reverse/accumulator", "bench/fixtures/sort/sort"]:
            argv = [a.replace("{file}", fixture) for a in shlex.split(template)]
            jobs.append((name, os.path.basename(fixture), argv, "pass", 600, []))
    return jobs


def outcome(status, log):
    if status == "timeout":
        return "timeout"
    if status.startswith("signal:"):
        return "crash"
    code = int(status.split(":", 1)[1])
    if code == 0:
        return "pass"
    try:
        text = open(log, encoding="utf-8", errors="replace").read()
    except OSError:
        text = ""
    if code == 7 or "out of budget" in text:
        return "budget"
    if code == 1:
        return "reject"
    return "error"


def reuse_identities(arlk, out, hol_bool):
    """Bundle the destination claim of each reuse job; record its identity."""
    cases = [
        ("lean-to-rocq-transport", "transport.rocq_add_comm",
         ["lib/core.arlk", "absorbed/lean/init_data_nat_basic.arlk", "absorbed/rocq/init_peano.arlk", "examples/transport.arlk"],
         "Lean Nat.add_comm, read on Rocq's nat through checked translations"),
        ("two-view-composition", "c.agree", ["examples/views.arlk"],
         "a.k read in c through the composed view a -> b -> c"),
    ]
    if hol_bool:
        cases.append(("hol-to-native-view", "holtypes.em", ["lib/hol.arlk", hol_bool, "examples/hol_types.arlk"],
                      "excluded middle, from OpenTheory's bool theory through the HOL view"))
    result = {}
    for name, claim, files, what in cases:
        d = os.path.join(out, "bundle-" + name)
        p = subprocess.run([arlk, "bundle", claim] + files + ["-o", d], capture_output=True, text=True)
        entry = {"claim": claim, "what": what, "bundled": p.returncode == 0}
        manifest = os.path.join(d, "manifest.txt")
        if os.path.exists(manifest):
            for line in open(manifest, encoding="utf-8"):
                key, _, value = line.rstrip("\n").partition(": ")
                if key in ("claim-id", "statement", "semantics"):
                    entry[key] = value
                elif key == "assumes":
                    entry.setdefault("assumptions", []).append(value)
        check = subprocess.run([arlk, "check"] + files, capture_output=True, text=True).stdout
        entry["routes"] = [l for l in check.splitlines() if l.startswith("route ")]
        entry["views"] = [l for l in check.splitlines() if l.startswith("view ")]
        result[name] = entry
    return result


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--arlk", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--batches", type=int, default=5)
    ap.add_argument("--per", type=int, default=3)
    ap.add_argument("--seed", type=int, default=20261005)
    ap.add_argument("--lanes", default="arlk,scale,reuse")
    ap.add_argument("--hol-bool", default="")
    ap.add_argument("--lane", action="append", default=[])
    ap.add_argument("--build", default="")
    a = ap.parse_args()
    os.chdir(ROOT)
    out = os.path.abspath(a.out)
    os.makedirs(os.path.join(out, "logs"), exist_ok=True)
    arlk = os.path.abspath(a.arlk)
    launch = build_launcher(out)
    lanes = set(a.lanes.split(","))

    setup = {}
    if a.build:
        r = subprocess.run([launch, "3600", os.path.join(out, "logs", "build.log")] + shlex.split(a.build),
                           capture_output=True, text=True).stdout.split()
        setup = {"command": a.build, "status": r[0], "wall_s": float(r[1]), "maxrss_kib": int(r[2])}

    jobs = jobs_for(lanes, arlk, out, a.hol_bool, a.lane)
    rng = random.Random(a.seed)
    rows = []
    for b in range(a.batches):
        order = [(j, r) for j in range(len(jobs)) for r in range(a.per)]
        rng.shuffle(order)
        for pos, (j, r) in enumerate(order):
            lane, name, argv, expected, timeout, _ = jobs[j]
            log = os.path.join(out, "logs", f"{lane}-{name}-b{b}-r{r}.log")
            line = subprocess.run([launch, str(timeout), log] + argv, capture_output=True, text=True).stdout.split()
            status, wall, rss = line[0], float(line[1]), int(line[2])
            rows.append({"batch": b, "position": pos, "lane": lane, "job": name, "rep": r,
                         "status": status, "outcome": outcome(status, log), "wall_s": wall, "maxrss_kib": rss})

    with open(os.path.join(out, "raw.csv"), "w") as f:
        keys = ["batch", "position", "lane", "job", "rep", "status", "outcome", "wall_s", "maxrss_kib"]
        f.write(",".join(keys) + "\n")
        for row in rows:
            f.write(",".join(str(row[k]) for k in keys) + "\n")

    summary, unexpected = [], []
    for lane, name, argv, expected, timeout, inputs in jobs:
        mine = [r for r in rows if r["lane"] == lane and r["job"] == name]
        outcomes = sorted({r["outcome"] for r in mine})
        walls = [r["wall_s"] for r in mine]
        rss = [r["maxrss_kib"] for r in mine]
        per_batch = [statistics.median([r["wall_s"] for r in mine if r["batch"] == b]) for b in range(a.batches)]
        entry = {"lane": lane, "job": name, "expected": expected, "outcomes": outcomes, "runs": len(mine),
                 "wall_median_s": statistics.median(walls), "wall_min_s": min(walls), "wall_max_s": max(walls),
                 "batch_medians_s": per_batch, "maxrss_median_kib": statistics.median(rss), "maxrss_max_kib": max(rss),
                 "timeout_s": timeout, "command": [os.path.relpath(x, ROOT) if os.path.isabs(x) else x for x in argv]}
        summary.append(entry)
        if outcomes != [expected]:
            unexpected.append(f"{lane}/{name}: expected {expected}, saw {', '.join(outcomes)}")
    with open(os.path.join(out, "summary.json"), "w") as f:
        json.dump({"seed": a.seed, "batches": a.batches, "per_batch": a.per, "setup": setup,
                   "jobs": summary, "unexpected": unexpected}, f, indent=2)
    with open(os.path.join(out, "summary.md"), "w") as f:
        f.write("| lane | job | outcome | median s | min s | max s | median RSS KiB | runs |\n|---|---|---|---:|---:|---:|---:|---:|\n")
        for e in summary:
            f.write(f"| {e['lane']} | {e['job']} | {', '.join(e['outcomes'])} | {e['wall_median_s']:.4f} | {e['wall_min_s']:.4f} | "
                    f"{e['wall_max_s']:.4f} | {e['maxrss_median_kib']:.0f} | {e['runs']} |\n")

    if "reuse" in lanes:
        with open(os.path.join(out, "reuse.json"), "w") as f:
            json.dump(reuse_identities(arlk, out, a.hol_bool), f, indent=2)

    inputs = sorted({p for job in jobs for p in job[5]})
    with open(os.path.join(out, "environment.txt"), "w") as f:
        f.write(f"machine: {platform.platform()} {platform.machine()}\n")
        f.write(f"cpu: {sh('sysctl -n machdep.cpu.brand_string') or sh('grep -m1 \"model name\" /proc/cpuinfo')}\n")
        f.write(f"almide: {sh('almide --version')}\nrustc: {sh('rustc --version')}\n")
        f.write(f"arlk: {sha256(arlk)} {a.arlk}\nlauncher: bench/launch.c {sha256(os.path.join(ROOT, 'bench', 'launch.c'))}\n")
        f.write(f"revision: {sh('git rev-parse HEAD')}\n")
        f.write(f"seed: {a.seed}\nbatches: {a.batches}\nper batch: {a.per}\n")
        f.write("cache: warm (no cache is dropped; no cold-cache claim)\n")
        f.write(f"lanes: {a.lanes} {' '.join(a.lane)}\n")
        if setup:
            f.write(f"setup: {json.dumps(setup)}\n")
        for p in inputs:
            f.write(f"input: {sha256(p)} {os.path.relpath(p, ROOT) if os.path.isabs(p) else p}\n")

    print(open(os.path.join(out, "summary.md")).read())
    for u in unexpected:
        print("UNEXPECTED", u)
    sys.exit(1 if unexpected else 0)


if __name__ == "__main__":
    main()
