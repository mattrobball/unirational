#!/usr/bin/env python3
"""Replayable verifier for CONE_VS_PATTERN.

Default: stored artefacts only (open_demands, vanish, functionals, I3
membership of the stored 37-vectors, Rabinowitsch leading ideals).
--live: rebuild the 37-cell at p=331 and re-check T(w)=0 at one sealed
dead rid-2 child versus T(w)≠0 at one live child.

Machine markers: CONE_VS_PATTERN_VERIFY_OK / ALLGREEN
"""
from __future__ import annotations

import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
SCR = os.path.join(HERE, "scripts")
sys.path.insert(0, SCR)

import paths  # noqa: E402
from framelib import i3_contains, lam3_row  # noqa: E402

fails = []
checks = []


def check(name, cond, detail=""):
    checks.append(name)
    if cond:
        print("  OK  %s %s" % (name, detail))
    else:
        print("  FAIL %s %s" % (name, detail))
        fails.append(name)


def loadj(name):
    p = os.path.join(RES, name)
    if not os.path.isfile(p):
        return None
    return json.load(open(p))


def main():
    live = "--live" in sys.argv
    print("CONE_VS_PATTERN verifier", flush=True)

    th = open(os.path.join(HERE, "THEOREM.md")).read()
    check("H1 headline OPEN", "Problem E remains OPEN" in th)
    check("H2 excludes no degree", "excludes no degree" in th)
    check("H3 no REPORT.md", not os.path.isfile(os.path.join(HERE, "REPORT.md")))
    check("H4 registration present",
          os.path.isfile(os.path.join(HERE, "REGISTRATION_SNIPPET.md")))
    check("H5 Not claimed section", "Not claimed" in th)
    check("H6 FLAG not claim", "FLAG" in th or "FLAGGED" in th)

    print("[A] extraction / rigidity")
    for p in (331, 661):
        ext = loadj("open_demands_p%d.json" % p)
        check("A1 p=%d extract present" % p, ext is not None)
        if not ext:
            continue
        check("A2 p=%d 22 patterns" % p, ext.get("n_survivors") == 22)
        check("A3 p=%d 14 forced-deeper" % p,
              len(ext.get("forced_deeper_rows") or []) == 14,
              str(ext.get("forced_deeper_rows")))
        rig = ext.get("level_rigidity") or {}
        check("A4 p=%d rigidity 0 at 0..3" % p,
              all(int(rig.get(str(k), -1)) == 0 for k in range(4)),
              str(rig))
        Vpath = os.path.join(RES, "functionals_p%d.npy" % p)
        check("A5 p=%d functionals npy" % p, os.path.isfile(Vpath))
        if os.path.isfile(Vpath):
            V = np.load(Vpath)
            check("A6 p=%d npy rows match" % p,
                  V.shape == (ext["n_functionals"], 37),
                  str(V.shape))

    print("[B] vanishing certificates")
    for p in (331, 661):
        van = loadj("vanish_p%d.json" % p)
        ext = loadj("open_demands_p%d.json" % p)
        check("B1 p=%d vanish present" % p, van is not None)
        if not van or not ext:
            continue
        check("B2 p=%d I3 rank 1380" % p,
              (van.get("I3_anchor") or {}).get("rank_ok") is True)
        check("B3 p=%d 22 dead" % p, van.get("n_patterns_dead") == 22)
        check("B4 p=%d 0 live" % p, van.get("n_patterns_live") == 0)
        check("B5 p=%d flag on" % p, van.get("flag_d35_exclusion") is True)
        check("B6 p=%d headline OPEN" % p,
              "remains OPEN" in (van.get("headline") or ""))
        # replay I3 membership on stored vectors
        V = np.load(os.path.join(RES, "functionals_p%d.npy" % p)) % p
        basis = np.load(os.path.join(paths.D35L_RES, "I3_echelon_p%d.npy" % p)) % p
        pivs = [int(x) for x in np.load(
            os.path.join(paths.D35L_RES, "I3_pivots_p%d.npy" % p))]
        n_z37 = 0
        n_i3 = 0
        for f in ext["functionals"]:
            vec = V[f["fid"]]
            z37 = not bool(np.any(vec % p))
            if z37:
                n_z37 += 1
            elif i3_contains(lam3_row(vec, p), basis, pivs, p):
                n_i3 += 1
        check("B7 p=%d replay Z37 count" % p, n_z37 == van.get("n_Z37"),
              "%s vs %s" % (n_z37, van.get("n_Z37")))
        check("B8 p=%d replay I3 extras" % p, n_i3 == van.get("n_I3"),
              "%s vs %s" % (n_i3, van.get("n_I3")))
        # every pattern DEAD
        check("B9 p=%d all pattern DEAD" % p,
              all(pt["verdict"] == "DEAD" for pt in van["patterns"]))
        # rid-2 kill present
        check("B10 p=%d rid2 kill" % p,
              all(pt.get("why") == "rid2_keep_vanishes_on_V"
                  for pt in van["patterns"]))

    print("[C] Rabinowitsch control is tautological")
    for p in (331, 661):
        van = loadj("vanish_p%d.json" % p)
        if not van:
            continue
        rab = van.get("rabinowitsch_control") or {}
        runs = rab.get("runs") or []
        check("C1 p=%d rabin present" % p, len(runs) >= 2)
        check("C2 p=%d all tautological" % p,
              all(r.get("interpretation") == "TAUTOLOGICAL_EMPTY" for r in runs),
              str([r.get("label") for r in runs]))
        # stored leading ideals
        for lab in ("random", "z37", "none"):
            op = os.path.join(RES, "rabin_m20_%s_p%d.out" % (lab, p))
            if os.path.isfile(op):
                txt = open(op).read()
                check("C3 p=%d %s lead=1" % (p, lab), "[1]:" in txt)

    print("[D] summary / no claim")
    summ = loadj("summary.json")
    check("D1 summary present", summ is not None)
    if summ:
        check("D2 summary headline OPEN", "remains OPEN" in summ.get("headline", ""))
        check("D3 no exclusion claimed", summ.get("any_exclusion_claimed") is False)

    if live:
        print("[L] live T(w) sanity at p=331")
        import slicelib as SL
        from framelib import load_seeds_and_cell
        from s1enum import Stage1
        from s3sweep import FullSweep
        cell = load_seeds_and_cell(331)
        p = 331
        E = Stage1(p)
        S2 = FullSweep(E, 2)
        comp0 = np.array(S2.slots[0][2], dtype=np.int64) % p
        ws = {}
        for kid in S2.kids:
            idx = int(kid["idx"])
            if idx in (6232, 8100):
                q0 = np.array(kid["qs"][0][0], dtype=np.int64) % p
                ws[idx] = (q0 @ comp0) % p
        check("L1 kids found", set(ws) == {6232, 8100}, str(sorted(ws)))
        if set(ws) == {6232, 8100}:
            W = np.array([ws[6232], ws[8100]], dtype=np.int64) % p
            seeds = SL.jet_rows(
                cell["fr"], cell["A6"], cell["C6"], W, np.zeros_like(W),
                1, deg=35)[:, :, :, 0] % p
            T = np.tensordot(cell["B37"], seeds, axes=(1, 0)) % p
            check("L2 dead T nnz 0", int(np.count_nonzero(T[:, 0, :] % p)) == 0)
            check("L3 live T nnz >0", int(np.count_nonzero(T[:, 1, :] % p)) > 0)

    print("checks=%d fails=%d" % (len(checks), len(fails)))
    if fails:
        print("CONE_VS_PATTERN_VERIFY_FAIL")
        print("failed:", fails)
        sys.exit(1)
    print("CONE_VS_PATTERN_VERIFY_OK")
    print("ALLGREEN")


if __name__ == "__main__":
    main()
