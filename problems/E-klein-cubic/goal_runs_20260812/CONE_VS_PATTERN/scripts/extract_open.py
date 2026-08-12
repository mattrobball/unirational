#!/usr/bin/env python3
"""Extract OPEN (required-nonzero) functionals for the 22 patterns.

Rid-1 (plus-row, a=(34,1)): Reynolds jet along the attaching pair, U0
component at the delivery level. Every functional is rigidity-checked
(transverse W^- component vanishes on all 637 seeds).

Rid-2 (line-row, a=(35,0)): evaluation T(w) at the child point on the
minus-line. A keep requires the 5-vector to be nonzero.

Depth rule (DEPTH_TABLE_GENERAL, T4): periods 1, 2, 3 occur. A vanishing
level-0 reading means the value is delivered deeper; the label changes
with depth only when period > 1.

Usage: python3 extract_open.py [p]
"""
from __future__ import annotations

import json
import os
import sys

import numpy as np

import paths
import slicelib as SL
from framelib import (
    assign_from_embed, inv_mod, lab_eq, load_seeds_and_cell, nullspace_rows,
    on37, vec5p,
)
from s1enum import Stage1
from s3jet import chi_arc_of, value_at_level
from s3sweep import FullSweep

RES = paths.RES
DEG = paths.DEG
SURV_IDS = paths.SURV_IDS
# levels 0..3 use t^1..t^4, so J >= 5. Level 4 (t^5) fails rigidity
# (2544/31850 at p=331): the reading is not confined to the character
# line, so it is not a functional we may use.
JMAX = 5
KAPPA_MAX = 3


def label_at(S, a, kid, kappa, chi):
    U = value_at_level(S, a, kid, kappa, None, chi)
    if U is None:
        return None
    return S.own_frame(kid, U)


def build_rid1_records(cell):
    p = cell["p"]
    fr, A6, C6 = cell["fr"], cell["A6"], cell["C6"]
    E = Stage1(p)
    S1 = FullSweep(E, 1)
    Z1 = np.array(S1.sig, dtype=np.int64) % p
    hits = [i for i in range(660)
            if np.array_equal(fr["RHO"][i] % p, Z1)]
    assert hits, "TIGHTEN/D34 realization mismatch"
    inv2 = pow(2, p - 2, p)
    Pminus = ((np.eye(5, dtype=np.int64) - Z1) * inv2) % p
    Wp1 = nullspace_rows((Z1 - np.eye(5, dtype=np.int64)) % p, p)
    assert Wp1.shape[0] == 3
    comp0 = np.array(S1.slots[0][2], dtype=np.int64) % p
    comp1 = np.array(S1.slots[1][2], dtype=np.int64) % p
    a35 = (34, 1)
    recs = []
    for kid in S1.kids:
        chi, per = chi_arc_of(S1, kid)
        U0 = S1.value(a35, kid, None)
        if U0 is None or kid.get("mu") is None:
            continue
        lab0 = S1.own_frame(kid, U0)
        if lab0 is None:
            continue
        q0 = np.array(kid["qs"][0][0], dtype=np.int64) % p
        q1 = np.array(kid["qs"][1][0], dtype=np.int64) % p
        w = (q0 @ comp0) % p
        y = ((q1 @ comp1) @ Pminus.T) % p
        if not np.any(y % p):
            continue
        U0v = vec5p(U0, p)
        others = [vec5p(U, p) for (_chi, U) in kid["lines"]
                  if not np.array_equal(vec5p(U, p), U0v)]
        if not others:
            continue
        cycle = [label_at(S1, a35, kid, k, chi) for k in range(per)]
        levels_for = {}
        for k, lab in enumerate(cycle):
            if lab is None:
                continue
            key = json.dumps(lab, sort_keys=True)
            levels_for.setdefault(key, []).append(k)
        recs.append(dict(
            kid_idx=int(kid["idx"]), row=int(kid["row"]),
            w=w, y=y, U0=U0v, Ut=others[0], lab0=lab0,
            period=int(per), cycle=cycle, levels_for=levels_for,
        ))
    return recs, Wp1, S1


def jets_and_functionals(cell, recs, Wp1):
    """level_lams[kappa] is (637, nrecs); rigidity 0 is fatal."""
    p = cell["p"]
    fr, A6, C6 = cell["fr"], cell["A6"], cell["C6"]
    ns = A6.shape[0]
    Wm = np.array([r["w"] for r in recs], dtype=np.int64) % p
    Ym = np.array([r["y"] for r in recs], dtype=np.int64) % p
    print("  rid1 jet_rows nrecs=%d J=%d ..." % (len(recs), JMAX), flush=True)
    JALL = SL.jet_rows(fr, A6, C6, Wm, Ym, JMAX, deg=DEG) % p
    CINVS = []
    rig = {}
    level_lams = {}
    for j, r in enumerate(recs):
        Bmat = np.concatenate([r["U0"][None, :], r["Ut"][None, :],
                               Wp1], axis=0) % p
        CINVS.append(inv_mod(Bmat.T % p, p).T % p)
    for kappa in range(0, KAPPA_MAX + 1):
        lam = np.zeros((ns, len(recs)), dtype=np.int64)
        rb = 0
        for j, r in enumerate(recs):
            comp = (JALL[:, j, :, kappa + 1] @ CINVS[j]) % p
            lam[:, j] = comp[:, 0]
            rb += int(np.count_nonzero(comp[:, 1] % p))
        level_lams[kappa] = lam
        rig[kappa] = rb
        print("  level-%d rigidity violations: %d / %d"
              % (kappa, rb, ns * len(recs)), flush=True)
        assert rb == 0, "level-%d rigidity failed" % kappa
    return level_lams, rig


def forced_deeper_rows(cell, recs, lam0):
    p = cell["p"]
    K0 = ((cell["NUL"] % p) @ lam0) % p
    zero_on_slice = {}
    for j, r in enumerate(recs):
        zero_on_slice.setdefault(r["row"], []).append(
            not bool(np.any(K0[:, j] % p)))
    dead = sorted(r0 for r0, zs in zero_on_slice.items() if all(zs))
    live = sorted(r0 for r0, zs in zero_on_slice.items() if not all(zs))
    assert len(dead) == 14 and len(zero_on_slice) == 18, (
        len(dead), len(zero_on_slice), dead)
    return dead, live


def build_rid2_records(cell):
    """Line-row children at a=(35,0): evaluation T(w), 5 components."""
    p = cell["p"]
    fr, A6, C6 = cell["fr"], cell["A6"], cell["C6"]
    E = Stage1(p)
    S2 = FullSweep(E, 2)
    comp0 = np.array(S2.slots[0][2], dtype=np.int64) % p
    a350 = (35, 0)
    recs = []
    for kid in S2.kids:
        U0 = S2.value(a350, kid, None)
        lab0 = S2.own_frame(kid, U0) if U0 is not None else None
        q0 = np.array(kid["qs"][0][0], dtype=np.int64) % p
        w = (q0 @ comp0) % p
        recs.append(dict(
            kid_idx=int(kid["idx"]), row=int(kid["row"]),
            w=w, lab0=lab0,
        ))
    W = np.array([r["w"] for r in recs], dtype=np.int64) % p
    print("  rid2 jet_rows nrecs=%d J=1 ..." % len(recs), flush=True)
    J1 = SL.jet_rows(fr, A6, C6, W, np.zeros_like(W), 1, deg=DEG)
    EVAL = J1.reshape(A6.shape[0], len(recs), 5) % p
    return recs, EVAL


def pack_fun(fid, kind, **meta):
    d = {"fid": fid, "kind": kind}
    d.update(meta)
    return d


def main(p):
    print("== extract open demands p=%d" % p, flush=True)
    cell = load_seeds_and_cell(p)
    print("  universal six: rank %d -> 37-cell" % cell["r6"], flush=True)

    recs1, Wp1, _S1 = build_rid1_records(cell)
    print("  rid1 value-defined kids: %d" % len(recs1), flush=True)
    level_lams, rig = jets_and_functionals(cell, recs1, Wp1)
    dead_rows, live_rows = forced_deeper_rows(cell, recs1, level_lams[0])
    print("  forced-deeper rows: %d %s" % (len(dead_rows), dead_rows))
    print("  live rows: %s" % live_rows)

    recs2, EVAL2 = build_rid2_records(cell)
    print("  rid2 kids: %d" % len(recs2), flush=True)

    # unique functionals on the 37-cell: list of 37-vectors + meta
    funs = []
    fun_index = {}  # key -> fid

    def add_linear(kind, lam_amb, **meta):
        v37 = on37(cell, lam_amb)
        key = (kind, tuple(int(x) for x in v37))
        if key in fun_index:
            return fun_index[key]
        fid = len(funs)
        fun_index[key] = fid
        zero37 = not bool(np.any(v37 % p))
        funs.append(pack_fun(
            fid, kind, zero_on_37cell=zero37,
            vec37=[int(x) for x in v37], **meta))
        return fid

    content = json.load(open(os.path.join(
        paths.AUDIT_RES, "patterns_r5_content_p%d.json" % p)))
    pats = {pt["id"]: pt for pt in content["patterns"]}
    for sid in SURV_IDS:
        assert sid in pats, "missing survivor %d" % sid

    patterns = []
    for sid in SURV_IDS:
        pt = pats[sid]
        branches = [e for e in pt["embedded_ff"]["1"] if e["a35"] == [34, 1]]
        assert branches, "survivor %d has no (34,1) embed" % sid
        bres = []
        for bi, entry in enumerate(branches):
            asg = assign_from_embed(entry)
            opens = []
            for j, r in enumerate(recs1):
                row = r["row"]
                if row not in asg:
                    continue
                V = asg[row]
                per = r["period"]
                key = json.dumps(V, sort_keys=True)
                levs = r["levels_for"].get(key, [])
                is_dead = row in dead_rows
                if not is_dead:
                    # live row: keep lab0 is open at level 0;
                    # a flip is closed (not extracted here).
                    if lab_eq(V, r["lab0"]):
                        fid = add_linear(
                            "rid1_live_keep_k0", level_lams[0][:, j],
                            kid_idx=r["kid_idx"], row=row, kappa=0,
                            period=per)
                        opens.append({
                            "role": "live_keep_level0",
                            "kid_idx": r["kid_idx"], "row": row,
                            "period": per, "kappa": 0, "fid": fid,
                            "kill_rule": "this_one",
                        })
                    continue
                # forced-deeper
                if per == 1:
                    # residual nonvanishing at the first computed
                    # deeper level; all computed deeper levels are
                    # required if they all vanish on the 37-cell.
                    fids = []
                    first_nz = None
                    for kappa in range(1, KAPPA_MAX + 1):
                        fid = add_linear(
                            "rid1_p1_deeper", level_lams[kappa][:, j],
                            kid_idx=r["kid_idx"], row=row, kappa=kappa,
                            period=1)
                        fids.append((kappa, fid))
                        if not funs[fid]["zero_on_37cell"] and first_nz is None:
                            first_nz = (kappa, fid)
                    if first_nz is None:
                        # every computed deeper jet vanishes on the
                        # 37-cell (hence on V). That kills the keep.
                        for kappa, fid in fids:
                            opens.append({
                                "role": "period1_deeper_all_vanish",
                                "kid_idx": r["kid_idx"], "row": row,
                                "period": 1, "kappa": kappa, "fid": fid,
                                "kill_rule": "all_of_these",
                            })
                    else:
                        opens.append({
                            "role": "period1_deeper_first_nz",
                            "kid_idx": r["kid_idx"], "row": row,
                            "period": 1, "kappa": first_nz[0],
                            "fid": first_nz[1],
                            "kill_rule": "this_one",
                        })
                    continue
                # period > 1
                if not levs:
                    opens.append({
                        "role": "unmatched_label",
                        "kid_idx": r["kid_idx"], "row": row,
                        "period": per, "fid": None,
                        "kill_rule": "unmatched_dead",
                        "note": "assigned label not in cycle",
                    })
                    continue
                only_mod0 = all(k % per == 0 for k in levs)
                if only_mod0:
                    # lab0 keep: value recurs at kappa = period, 2*period, ...
                    # impose the first computed recurrence if in range
                    kappa = per
                    if kappa <= KAPPA_MAX:
                        fid = add_linear(
                            "rid1_mod0_recurrence", level_lams[kappa][:, j],
                            kid_idx=r["kid_idx"], row=row, kappa=kappa,
                            period=per)
                        opens.append({
                            "role": "period_gt1_lab0_recurrence",
                            "kid_idx": r["kid_idx"], "row": row,
                            "period": per, "kappa": kappa, "fid": fid,
                            "kill_rule": "this_one",
                        })
                    else:
                        opens.append({
                            "role": "period_gt1_lab0_recurrence_untested",
                            "kid_idx": r["kid_idx"], "row": row,
                            "period": per, "kappa": kappa, "fid": None,
                            "kill_rule": "untested",
                        })
                else:
                    for kappa in levs:
                        if kappa > KAPPA_MAX:
                            continue
                        fid = add_linear(
                            "rid1_nonmod0", level_lams[kappa][:, j],
                            kid_idx=r["kid_idx"], row=row, kappa=kappa,
                            period=per)
                        opens.append({
                            "role": "period_gt1_nonmod0",
                            "kid_idx": r["kid_idx"], "row": row,
                            "period": per, "kappa": kappa, "fid": fid,
                            "levels": levs, "kill_rule": "this_one",
                        })
            bres.append({
                "branch": bi,
                "content_key": entry.get("content_key"),
                "n_assigned": int(entry.get("n_assigned") or len(asg)),
                "open_demands": opens,
                "n_open": len(opens),
            })

        # rid-2 keeps: T(w) != 0 (5 linear forms; kill iff all vanish)
        e2s = [e for e in pt["embedded_ff"].get("2", []) if e["a35"] == [35, 0]]
        line_opens = []
        for ei, entry in enumerate(e2s):
            asg = assign_from_embed(entry)
            for j, r in enumerate(recs2):
                if r["row"] not in asg or r["lab0"] is None:
                    continue
                if not lab_eq(asg[r["row"]], r["lab0"]):
                    continue  # flip: closed, already rank-0 extra
                fids = []
                for c in range(5):
                    fid = add_linear(
                        "rid2_keep_eval", EVAL2[:, j, c],
                        kid_idx=r["kid_idx"], row=r["row"], component=c)
                    fids.append(fid)
                line_opens.append({
                    "role": "rid2_keep_T_nonzero",
                    "kid_idx": r["kid_idx"], "row": r["row"],
                    "embed": ei, "fids": fids,
                    "kill_rule": "all_components",
                })
        patterns.append({
            "id": sid,
            "content_hash": pt["content_hash"],
            "sealed_hash": pt["sealed_hash"],
            "rid1_branches": bres,
            "rid2_open": line_opens,
        })
        print("  id %d: rid1 opens %s  rid2 keeps %d  unique_funs=%d"
              % (sid, [b["n_open"] for b in bres], len(line_opens),
                 len(funs)), flush=True)

    # save 37-vectors densely
    V = np.zeros((len(funs), 37), dtype=np.int64)
    for f in funs:
        V[f["fid"]] = np.array(f["vec37"], dtype=np.int64)
        # drop the long vec from JSON (npy is the record)
        f["vec37"] = "see functionals_p%d.npy row fid" % p
    np.save(os.path.join(RES, "functionals_p%d.npy" % p), V)

    n_zero = sum(1 for f in funs if f["zero_on_37cell"])
    out = {
        "p": p,
        "n_survivors": 22,
        "forced_deeper_rows": dead_rows,
        "live_rows_level0": live_rows,
        "n_rid1_recs": len(recs1),
        "n_rid2_recs": len(recs2),
        "level_rigidity": {str(k): int(v) for k, v in rig.items()},
        "JMAX": JMAX,
        "kappa_max": KAPPA_MAX,
        "n_functionals": len(funs),
        "n_zero_on_37cell": n_zero,
        "functionals": funs,
        "patterns": patterns,
        "note": (
            "OPEN demands only. A pattern is unrealizable on V if every "
            "realizing branch has a required-nonzero reading that vanishes "
            "on V. rid-2 keep is a 5-vector: vanishes iff all components do."
        ),
    }
    path = os.path.join(RES, "open_demands_p%d.json" % p)
    with open(path, "w") as f:
        json.dump(out, f, indent=1)
    print("  wrote", path, "funs", len(funs), "zero_on_37", n_zero)
    return out


if __name__ == "__main__":
    main(int(sys.argv[1]) if len(sys.argv) > 1 else 331)
