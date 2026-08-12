#!/usr/bin/env python3
"""Produce COCYCLE_COHERENCE artefacts: audit + summary.

If the audit returns COCYCLE-ALREADY-IMPLIED, no triangle-layer re-count is
performed (workorder §B.1 stop).  J-table and degree-35 bookkeeping are
recorded as identity (no cut).
"""
import json
import os
import sys

import paths
from audit_implied import run as audit_run


def main():
    primes = [int(x) for x in sys.argv[1:]] or [331, 661]
    audits = {}
    for p in primes:
        audits[str(p)] = audit_run(p, verbose=True)

    verdicts = {p: audits[p]["verdict"] for p in audits}
    assert len(set(verdicts.values())) == 1, verdicts
    verdict = next(iter(verdicts.values()))

    # J before = sealed TUPLE_JOINT_RESIDUE; after = same if already-implied
    j_before = list(paths.J_TABLE)
    if verdict == "COCYCLE-ALREADY-IMPLIED":
        j_after = list(paths.J_TABLE)
        triangle_layer_size = 0
        cut = [0] * 6
        d35 = dict(
            residue=5,
            J_before=paths.J_TABLE[5],
            J_after=paths.J_TABLE[5],
            cut=0,
            anchor_22="unchanged",
            dead_1242_bookkeeping="unchanged",
            note="triangle layer already implied; no re-sieve",
        )
    else:
        raise SystemExit(
            "COCYCLE-NOT-IMPLIED path not executed in this produce.py; "
            "implement triangle layer + J re-count first."
        )

    summary = dict(
        headline="Problem E remains OPEN; this packet excludes no degree.",
        verdict=verdict,
        primes=primes,
        n_orbit_edges={p: audits[p]["n_orbit_edges"] for p in audits},
        n_triangles={p: audits[p]["n_triangles"] for p in audits},
        n_missing_direct={p: audits[p]["n_missing_direct"] for p in audits},
        bfs_fail={p: audits[p]["bfs_tree"]["n_fail"] for p in audits},
        geo_fail={p: audits[p]["geometric_2chain"]["n_fail"] for p in audits},
        eval_arc_fail={p: audits[p]["eval_arc"]["n_arc_failures"] for p in audits},
        core_solutions={p: audits[p]["core_solutions"] for p in audits},
        triangle_layer_size=triangle_layer_size,
        J_sealed=paths.J_TABLE,
        K_sealed=paths.K_TABLE,
        J_before=j_before,
        J_after=j_after,
        cut_per_residue=cut,
        per_class=[
            dict(d_mod6=e, J_before=j_before[e], J_after=j_after[e],
                 cut=cut[e], zero=(j_after[e] == 0))
            for e in range(6)
        ],
        d35=d35,
        any_zero=False,
        zeros=[],
        cross_prime_agree=all(
            audits[str(primes[0])][k] == audits[str(p)][k]
            for p in primes[1:]
            for k in ("verdict", "n_orbit_edges", "n_triangles",
                      "n_missing_direct", "core_solutions")
        ),
        exits=[
            "COCYCLE-ALREADY-IMPLIED",
            "COCYCLE-NO-DEGREE-EXCLUSION",
            "COCYCLE-J-IDENTITY",
            "COCYCLE-D35-UNCHANGED",
        ],
    )

    os.makedirs(paths.RESULTS, exist_ok=True)
    with open(os.path.join(paths.RESULTS, "audit_implied.json"), "w") as f:
        json.dump(audits, f, indent=2, default=str)
    with open(os.path.join(paths.RESULTS, "summary.json"), "w") as f:
        json.dump(summary, f, indent=2)
    with open(os.path.join(paths.RESULTS, "j_table.txt"), "w") as f:
        f.write("residue  J_before  J_after  cut\n")
        for e in range(6):
            f.write("%7d  %8d  %7d  %3d\n"
                    % (e, j_before[e], j_after[e], cut[e]))
        f.write("\nverdict: %s\n" % verdict)
        f.write("triangle_layer_size: %d\n" % triangle_layer_size)
        f.write("d35: %s\n" % json.dumps(d35))
    print("SUMMARY verdict=%s J_after=%s" % (verdict, j_after))


if __name__ == "__main__":
    main()
