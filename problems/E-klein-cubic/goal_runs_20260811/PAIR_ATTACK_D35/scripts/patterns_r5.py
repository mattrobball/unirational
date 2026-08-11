#!/usr/bin/env python3
"""Regenerate the 756 corrected sigma-band patterns at residue 5 mod 6.

The STAGE1_STRATIFIED coherent count at d ≡ 5 (mod 6) factors as

    total = 23 · IMM1 · 756 ,

and the 756 is exactly the number of solutions of the largest (51-row) block
of the multi-valued constraint graph after the two full-flag tables have been
replaced by their stratified residue-5 contributions.

Each pattern is tagged with the multidegree classes of every compatible
full-flag contribution (so Layer 1 can branch on m without the first-class
assignment bug).

Usage:  python3 patterns_r5.py [p]
"""
import hashlib
import json
import os
import sys
import time
from collections import defaultdict

import paths  # noqa: F401
import paths as _p
sys.path.insert(0, _p.STRAT)
sys.path.insert(0, _p.TIGHTEN)
sys.path.insert(0, _p.COMPLEX)

from s1enum import Stage1  # noqa: E402
from s1recount import (  # noqa: E402
    build_tables, coherent_count, forced_sweeps,
)
from s3residue_strat import (  # noqa: E402
    full_flag_rows, IMM1,
)
from s3sweep import FullSweep  # noqa: E402
from s3sat import classes  # noqa: E402
from s3jet import contribution_stratified  # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")


def _canon_val(v):
    if isinstance(v, (list, tuple)):
        return tuple(_canon_val(x) for x in v)
    return v


def _assign_key(assign):
    return tuple(sorted((r, _canon_val(v)) for r, v in assign.items()))


def multidegree_for_d35(rho):
    rho = list(rho)
    s = sum(rho)
    need = 35 - s
    assert need % 6 == 0 and need >= 0, (rho, need)
    out = list(rho)
    out[0] += need
    return out


def enumerate_block(E, tables, ids):
    """Like count_block but returns the list of full assignments."""
    ids = sorted(ids)
    idset = set(ids)
    cons = [(a, ta, b, tb) for (a, ta, b, tb) in E.cons
            if a in idset and b in idset]
    rel = []
    for rid, tab in tables.items():
        rs = set()
        for a in tab:
            rs |= set(a)
        if (rs | {rid}) & idset:
            rel.append(rid)
    forced = set(forced_sweeps(E))
    order = sorted(ids, key=lambda i: (
        0 if i in tables else 1,
        -len(set().union(*[set(a) for a in tables[i]])
             if tables.get(i) else set()),
        len(E.dom[i]), i))
    val = {}
    sols = []

    def sweeping(s):
        if s in forced:
            return True
        if s not in val:
            return None
        v = val[s]
        return v[0] == "dom" and v[1] == "L"

    def tables_ok():
        for s in rel:
            st = sweeping(s)
            if st is False or st is None:
                continue
            hit = False
            for a in tables[s]:
                if all(val.get(r0) in (None, v) for r0, v in a.items()):
                    hit = True
                    break
            if not hit:
                return False
        return True

    def rec(k):
        if k == len(order):
            if tables_ok():
                sols.append(dict(val))
            return
        i = order[k]
        for v in E.dom[i]:
            val[i] = v
            good = True
            for (a, ta, b, tb) in cons:
                if a in val and b in val and (a == i or b == i):
                    if not E.img_contains(val[a], ta, val[b], tb):
                        good = False
                        break
            if good and tables_ok():
                rec(k + 1)
            val.pop(i, None)

    rec(0)
    return sols


def build_tagged_ff_tables(E):
    """Full-flag residue-5 tables with multidegree tags on every entry.

    Returns
      tables_plain[rid] = list of assignment dicts  (for coherent_count)
      tagged[rid] = list of {assign, rho, a0, a35, m_or_nu, key}
    """
    tables_plain = {}
    tagged = {}
    for rid in full_flag_rows(E):
        S = FullSweep(E, rid)
        cls, mins, R, ok = classes(S, box=11)
        assert ok
        plain, tag = [], []
        seen = set()
        for rho, reps in cls.items():
            if sum(rho) % 6 != 5:
                continue
            a0 = min(reps, key=sum)
            a35 = multidegree_for_d35(rho)
            # D_P dims [3,2]: m = a35[1]; D_L dims [2,3]: nu_slot = a35[0]
            m_or_nu = a35[1] if S.dims == [3, 2] else a35[0]
            for c in contribution_stratified(S, a0, E):
                k = _assign_key(c)
                if k in seen:
                    # same assignment from another multidegree: record both
                    # (contribution can coincide across classes)
                    for t in tag:
                        if t["key"] == k:
                            t["alt_classes"].append({
                                "rho": list(rho), "a0": list(a0),
                                "a35": a35, "m_or_nu": m_or_nu,
                            })
                    continue
                seen.add(k)
                plain.append(c)
                tag.append({
                    "assign": c,
                    "key": k,
                    "rho": list(rho),
                    "a0": list(a0),
                    "a35": a35,
                    "m_or_nu": m_or_nu,
                    "dims": list(S.dims),
                    "n_assigned": len(c),
                    "assigned_rows": sorted(c.keys()),
                    "alt_classes": [],
                })
        tables_plain[rid] = plain
        tagged[rid] = tag
    return tables_plain, tagged


def compatible_tagged(sol, tagged_rid):
    """Indices of tagged entries compatible with a core solution."""
    hits = []
    for idx, t in enumerate(tagged_rid):
        a = t["assign"]
        if all(sol.get(r0) in (None, v) or sol.get(r0) == v
               for r0, v in a.items()):
            ok = True
            for r0, v in a.items():
                if r0 in sol and sol[r0] != v:
                    ok = False
                    break
            if ok:
                hits.append(idx)
    return hits


def build_patterns(p=331, verbose=True):
    t0 = time.time()
    E = Stage1(p)
    if verbose:
        print("[pat] Stage1 p=%d  [%.1fs]" % (p, time.time() - t0), flush=True)
    base, meta = build_tables(E)
    if verbose:
        print("[pat] base tables  [%.1fs]" % (time.time() - t0), flush=True)

    ff_plain, ff_tagged = build_tagged_ff_tables(E)
    if verbose:
        for rid in full_flag_rows(E):
            print("[pat]   ff rid %d residue-5 patterns: %d  classes: %s"
                  % (rid, len(ff_plain[rid]),
                     sorted(set(t["m_or_nu"] for t in ff_tagged[rid]))),
                  flush=True)
        print("[pat] tagged ff tables  [%.1fs]" % (time.time() - t0), flush=True)

    tables = dict(base)
    for rid, plain in ff_plain.items():
        tables[rid] = plain

    tot, blocks = coherent_count(E, tables)
    K = tot // (23 * IMM1)
    core = max(blocks, key=lambda b: b["size"])
    if verbose:
        print("[pat] total=%d  K=%d  core size=%d solutions=%d  [%.1fs]"
              % (tot, K, core["size"], core["solutions"], time.time() - t0),
              flush=True)
    assert K == 756, K
    assert core["solutions"] == 756, core

    if verbose:
        print("[pat] enumerating 756 core solutions...", flush=True)
    sols = enumerate_block(E, tables, core["rows"])
    assert len(sols) == 756, len(sols)
    if verbose:
        print("[pat] enumerated %d  [%.1fs]" % (len(sols), time.time() - t0),
              flush=True)

    ff = full_flag_rows(E)
    patterns = []
    groups = defaultdict(list)
    m_hist = defaultdict(int)

    for i, sol in enumerate(sols):
        compat = {}
        m_options_P = set()
        m_options_L = set()
        a35_P = []
        a35_L = []
        targets_meta = []
        for rid in ff:
            hits = compatible_tagged(sol, ff_tagged[rid])
            compat[rid] = hits
            for idx in hits:
                t = ff_tagged[rid][idx]
                if t["dims"] == [3, 2]:
                    m_options_P.add(t["m_or_nu"])
                    a35_P.append(t["a35"])
                    for alt in t["alt_classes"]:
                        m_options_P.add(alt["m_or_nu"])
                        a35_P.append(alt["a35"])
                else:
                    m_options_L.add(t["m_or_nu"])
                    a35_L.append(t["a35"])
                    for alt in t["alt_classes"]:
                        m_options_L.add(alt["m_or_nu"])
                        a35_L.append(alt["a35"])
                targets_meta.append({
                    "rid": rid, "idx": idx,
                    "m_or_nu": t["m_or_nu"], "a35": t["a35"],
                    "n_assigned": t["n_assigned"],
                })
        # minimal m among compatible D_P classes (weakest order condition)
        min_m = min(m_options_P) if m_options_P else None
        max_m = max(m_options_P) if m_options_P else None
        m_hist[min_m] += 1
        # group by (sorted m options, sorted L options, compat idx sets)
        sig = (
            tuple(sorted(m_options_P)),
            tuple(sorted(m_options_L)),
            tuple(sorted((rid, tuple(compat[rid])) for rid in ff)),
        )
        gkey = hashlib.sha1(repr(sig).encode()).hexdigest()[:12]
        h = hashlib.sha1(repr(sorted(
            (r, _canon_val(v)) for r, v in sol.items())).encode()).hexdigest()[:16]
        rec = {
            "id": i,
            "hash": h,
            "compat_ff": {str(rid): compat[rid] for rid in ff},
            "m_options_P": sorted(m_options_P),
            "m_options_L": sorted(m_options_L),
            "min_m": min_m,
            "max_m": max_m,
            "a35_P_options": [list(x) for x in
                              sorted({tuple(a) for a in a35_P})],
            "a35_L_options": [list(x) for x in
                              sorted({tuple(a) for a in a35_L})],
            "group_key": gkey,
            "targets_meta": targets_meta,
        }
        patterns.append(rec)
        groups[gkey].append(i)

    for rec in patterns:
        rec["group_size"] = len(groups[rec["group_key"]])
        rec["group_rep"] = (rec["id"] == min(groups[rec["group_key"]]))

    # ff_pats for compile_tree value extraction
    ff_pats = {rid: [t["assign"] for t in ff_tagged[rid]] for rid in ff}
    ff_lead = {
        rid: [{
            "rho": t["rho"], "a0": t["a0"], "a35": t["a35"],
            "m_or_nu": t["m_or_nu"], "n_assigned": t["n_assigned"],
            "assigned_rows": t["assigned_rows"],
        } for t in ff_tagged[rid]]
        for rid in ff
    }

    summary = {
        "prime": p,
        "residue": 5,
        "K": 756,
        "total_coherent": tot,
        "IMM1": IMM1,
        "core_rows": core["rows"],
        "core_size": core["size"],
        "n_patterns": len(patterns),
        "n_groups": len(groups),
        "full_flag_rows": ff,
        "ff_table_sizes": {str(rid): len(ff_pats[rid]) for rid in ff},
        "m_hist_by_min_m": {str(k): v for k, v in sorted(m_hist.items(),
                              key=lambda kv: (kv[0] is None, kv[0]))},
        "ff_leading_data": {
            str(rid): ff_lead[rid] for rid in ff
        },
        "blocks": blocks,
        "wall_s": round(time.time() - t0, 2),
    }
    if verbose:
        print("[pat] min_m histogram: %s" % summary["m_hist_by_min_m"],
              flush=True)
        print("[pat] groups=%d  [%.1fs]" % (len(groups), time.time() - t0),
              flush=True)
    return patterns, summary, groups, tables, E, ff_pats, ff_lead, ff_tagged


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    os.makedirs(RES, exist_ok=True)
    patterns, summary, groups, tables, E, ff_pats, ff_lead, ff_tagged = \
        build_patterns(p)
    with open(os.path.join(RES, "patterns_r5_p%d.json" % p), "w") as fh:
        json.dump({"summary": summary, "patterns": patterns}, fh)
    with open(os.path.join(RES, "patterns_r5_summary_p%d.json" % p), "w") as fh:
        json.dump(summary, fh, indent=1, sort_keys=True)
    reps = [patterns[i] for i in sorted(min(v) for v in groups.values())]
    with open(os.path.join(RES, "pattern_groups_r5_p%d.json" % p), "w") as fh:
        json.dump({
            "n_groups": len(reps),
            "n_patterns": 756,
            "reps": reps,
            "group_sizes": sorted((len(v) for v in groups.values()),
                                  reverse=True),
        }, fh, indent=1)
    print("PATTERNS_OK n=%d groups=%d K=%d m_hist=%s" % (
        len(patterns), len(reps), summary["K"], summary["m_hist_by_min_m"]))


if __name__ == "__main__":
    main()
