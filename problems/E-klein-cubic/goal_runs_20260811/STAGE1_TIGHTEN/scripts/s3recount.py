"""STAGE1_TIGHTEN -- the residue-indexed recount of the sigma-band core.

With psi = trivial (STAGE2 Lemma 0.1) and  sum_r a_r = d  (all slots included),
the component classes of M_S available to a covariant of degree d are exactly the
realized residue classes rho mod 6 with  sum_r rho_r = d (mod 6).  So the whole
sigma-band coherence problem becomes a function of  d mod 6, and the STAGE1 core
count 43008 splits per residue.
"""
import os
import sys
from collections import defaultdict

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from s3sweep import FullSweep                     # noqa: E402
from s3sat import classes, contribution           # noqa: E402
from s1recount import coherent_count, sweep_rows  # noqa: E402


def build_residue_tables(E, box=17, verbose=False):
    """tables[e][rid] = the coherence table of row rid for covariant degree d = e
    (mod 6), under psi = trivial and sum a_r = d."""
    per_row = {}
    for rid in sweep_rows(E):
        S = FullSweep(E, rid)
        b = box if S.nslot <= 2 else 11
        cls, mins, R, ok = classes(S, box=b)
        assert ok, ("realized set is not the 6-step up-set", rid)
        rows = defaultdict(list)
        for rho, reps in cls.items():
            a = min(reps, key=sum)
            c = contribution(S, a, E)
            if c is None:
                continue                      # not the restriction of a section
            if any(v not in E.dom[r0] for r0, v in c.items()):
                continue                      # value outside the arc-consistent domain
            rows[sum(rho) % 6].append((rho, a, c))
        per_row[rid] = dict(rows)
        if verbose:
            print("  #%02d  classes per (sum rho mod 6): %s" %
                  (rid, {e: len(v) for e, v in sorted(rows.items())}), flush=True)
    tables = {}
    for e in range(6):
        tables[e] = {rid: [c for (_r, _a, c) in per_row[rid].get(e, [])]
                     for rid in per_row}
    return tables, per_row


def residue_counts(E, tables, verbose=False):
    out = {}
    for e in range(6):
        t = {rid: tab for rid, tab in tables[e].items() if tab}
        empty = [rid for rid, tab in tables[e].items() if not tab]
        if empty:
            out[e] = dict(total=0, empty_rows=empty)
            continue
        tot, blocks = coherent_count(E, t)
        core = max(blocks, key=lambda b: b["size"])
        out[e] = dict(total=tot, core=core["solutions"], core_size=core["size"],
                      blocks=[(b["size"], b["solutions"]) for b in blocks])
        if verbose:
            print("  d = %d (mod 6):  coherent total %d, core block %d rows -> %d"
                  % (e, tot, core["size"], core["solutions"]), flush=True)
    return out
