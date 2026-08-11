"""STAGE1_COMPLEX_MAPS -- the multidegree-saturation probe.

THEOREM.md sec.15.6(1) flags that the evaluation-coherence tables are computed
only to a multidegree cutoff (the producer's default is 4 for two-slot rows,
6 for one-slot rows), and asserts that the total is unchanged at maxdeg 3, 4, 5
and 6.  Before the PR #32 adjudication that assertion had no artifact and no
check.  This script is the artifact: it re-runs the recount at a UNIFORM maxdeg
across all fifteen sweep-capable rows -- below the default in one slot-class and
above it in the other -- and prints the total each time.

    python3 scripts/s1saturation.py 331    # ~15 min, writes to stdout

Recorded output: results/saturation_probe_331.txt.

This is evidence of stability, NOT a proof of saturation; sec.15.6(1)'s Tier-3
flag stands.
"""
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

from s1enum import Stage1                                       # noqa: E402
from s1recount import build_tables, coherent_count, sweep_rows  # noqa: E402

PUBLISHED = 1088847395778723840000

p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
E = Stage1(p, verbose=False)
rids = sweep_rows(E)
print("sweep rows:", rids, flush=True)

out = {}
for md in (3, 4, 5, 6):
    t = time.time()
    tables, meta = build_tables(E, maxdeg={r: md for r in rids})
    total, blocks = coherent_count(E, tables)
    core = max(blocks, key=lambda b: b["size"])
    rf = sum(m["rigid_fail"] for m in meta.values())
    out[md] = total
    print("maxdeg=%d  total=%d  core=(%d rows, %d patterns)  rigid_fail=%d  %.0fs"
          % (md, total, core["size"], core["solutions"], rf, time.time() - t),
          flush=True)

print("\nSTABLE ACROSS maxdeg 3,4,5,6:", len(set(out.values())) == 1)
print("equals the packet's published total %d:" % PUBLISHED,
      all(v == PUBLISHED for v in out.values()))
