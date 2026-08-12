#!/usr/bin/env python3
"""Replayable verifier for CONE_D3738.

Default: stored artefacts (anchors, free rungs, msolve leading ideals).
  python3 verifier.py
  python3 verifier.py --live    # rebuild post-cut cells at p=331

Machine markers: CONE_D3738_VERIFY_OK / ALLGREEN
"""
from __future__ import annotations

import glob
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
SCR = os.path.join(HERE, "scripts")
sys.path.insert(0, SCR)
import paths  # noqa: E402
import cone_lib as L  # noqa: E402

T0 = time.time()
fails = []
checks = []


def check(name, cond, detail=""):
    checks.append(name)
    if cond:
        print("  OK  %s %s" % (name, detail))
    else:
        print("  FAIL %s %s" % (name, detail))
        fails.append(name)


def load(name):
    path = os.path.join(RES, name)
    if not os.path.exists(path):
        return None
    with open(path) as f:
        return json.load(f)


def main():
    live = "--live" in sys.argv
    print("CONE_D3738 verifier", flush=True)

    th_path = os.path.join(HERE, "THEOREM.md")
    if os.path.isfile(th_path):
        th = open(th_path).read()
        check("H1 headline OPEN", "Problem E remains OPEN" in th)
        check("H2 excludes no degree", "excludes no degree" in th)
        check("H3 Not claimed", "Not claimed" in th)
    else:
        check("H1 THEOREM.md present (deferred until artefacts land)", False)
    check("H4 no REPORT.md", not os.path.isfile(os.path.join(HERE, "REPORT.md")))
    check("H5 registration present",
          os.path.isfile(os.path.join(HERE, "REGISTRATION_SNIPPET.md")))

    print("[A] fatal anchors")
    for d, precut, postcut, p3k, p3 in (
        (37, 121, 120, 119, 2642),
        (38, 151, 150, 151, 3285),
    ):
        for p in (331, 661):
            cell = load("cell_d%d_p%d.json" % (d, p))
            if cell is None:
                check("A0 d=%d p=%d cell artefact" % (d, p), p != 331,
                      "missing" if p == 331 else "optional 661 not yet")
                continue
            check("A1 d=%d p=%d precut %d" % (d, p, precut),
                  cell.get("cell_dim") == precut, str(cell.get("cell_dim")))
            check("A2 d=%d p=%d postcut %d" % (d, p, postcut),
                  cell.get("new_dim") == postcut, str(cell.get("new_dim")))
            check("A3 d=%d p=%d cut rank 1" % (d, p),
                  cell.get("cut_rank") == 1, str(cell.get("cut_rank")))
            check("A4 d=%d p=%d cut sat" % (d, p), cell.get("sat_ok") is True)
            check("A5 d=%d p=%d flip K %d" % (d, p, p3k),
                  cell.get("K_flip") == p3k, str(cell.get("K_flip")))
            check("A6 d=%d p=%d C11 census 60" % (d, p),
                  cell.get("census_n_points") == 60)
            p3f = load("p3_Kflip_d%d_p%d.json" % (d, p))
            if p3f is None:
                check("A7 d=%d p=%d P3 artefact" % (d, p), p != 331,
                      "missing" if p == 331 else "optional 661 not yet")
                continue
            check("A8 d=%d p=%d P3=%d" % (d, p, p3),
                  p3f.get("P3") == p3, str(p3f.get("P3")))
            check("A9 d=%d p=%d P3 saturated" % (d, p),
                  p3f.get("saturated") is True)
            check("A10 d=%d p=%d P3 K=%d" % (d, p, p3k),
                  p3f.get("K") == p3k, str(p3f.get("K")))
            check("A11 d=%d p=%d P3 <= I(3d)" % (d, p),
                  p3f.get("P3", 10 ** 9) <= paths.I_3D[d])

    print("[B] cut-cell P3 and free rungs")
    for d, N in ((37, 120), (38, 150)):
        for p in (331, 661):
            p3c = load("p3_Kcut_d%d_p%d.json" % (d, p))
            if p3c:
                check("B1 d=%d p=%d P3 on cut-cell" % (d, p), True,
                      "P3=%s sat=%s" % (p3c.get("P3"), p3c.get("saturated")))
                check("B2 d=%d p=%d Kcut=%d" % (d, p, N), p3c.get("K") == N)
                check("B3 d=%d p=%d P3_cut <= sealed" % (d, p),
                      p3c.get("P3", 10 ** 9) <= paths.SEALED_P3[d])
            free = load("free_rungs_d%d_p%d.json" % (d, p))
            if free is None:
                continue
            check("B4 d=%d p=%d N=%d" % (d, p, N), free.get("N") == N)
            for s in free.get("sections", []):
                m = s["m"]
                nmon = L.nmon3(m)
                check("B5 d=%d p=%d m=%d bookkeeping" % (d, p, m),
                      s["rank"] + s["HF_L3"] == s["dim_sym3"] == nmon,
                      "rank=%s HF=%s" % (s["rank"], s["HF_L3"]))
                if s.get("free"):
                    check("B6 d=%d p=%d m=%d free bound" % (d, p, m),
                          s.get("dim_V_le") == N - m)
            if free.get("best_free_m"):
                check("B7 d=%d p=%d best free = N-m" % (d, p),
                      free["best_free_bound"] == N - free["best_free_m"])

    print("[C] msolve rungs (full span)")
    for d, N in ((37, 120), (38, 150)):
        for p in (331, 661):
            msj = sorted(glob.glob(os.path.join(
                RES, "msolve_d%d_m*_p%d.json" % (d, p))))
            for path in msj:
                r = json.load(open(path))
                m = r["m"]
                check("C1 d=%d p=%d m=%d full-span" % (d, p, m),
                      r.get("full_span_rule") is True)
                if r.get("verdict") == "cleared":
                    leadp = os.path.join(
                        RES, "cone_d%d_m%d_p%d_lead.out" % (d, m, p))
                    check("C2 d=%d p=%d m=%d leading file" % (d, p, m),
                          os.path.exists(leadp))
                    if os.path.exists(leadp):
                        parsed = L.parse_leading_pure_powers(open(leadp).read(), m)
                        check("C3 d=%d p=%d m=%d pure powers" % (d, p, m),
                              parsed["zero_dimensional"], str(parsed["missing"]))
                        check("C4 d=%d p=%d m=%d bound N-m" % (d, p, m),
                              r.get("dim_V_le") == N - m)
                elif r.get("verdict") == "timeout":
                    check("C5 d=%d p=%d m=%d timeout honest" % (d, p, m),
                          r.get("timeout") is True)
                else:
                    check("C6 d=%d p=%d m=%d verdict recorded" % (d, p, m),
                          r.get("verdict") is not None, str(r.get("verdict")))

    print("[D] summary + honesty")
    sm = load("summary.json") or load("summary_p331.json")
    check("D1 summary present", sm is not None)
    if sm:
        check("D2 no exclusion flag", sm.get("flagged_exclusion") is False)
        check("D3 headline open", "OPEN" in (sm.get("headline") or ""))

    if live:
        print("[LIVE] rebuild cells at p=331")
        import produce
        fr = produce.build_frame(331)
        for d, precut, postcut in ((37, 121, 120), (38, 151, 150)):
            rec, A, C, NUL, Bflip, Bcut, _ = produce.load_or_build_cells(
                fr, d, 331, force=True)
            check("L1 d=%d live precut %d" % (d, precut), rec["cell_dim"] == precut)
            check("L2 d=%d live postcut %d" % (d, postcut), rec["new_dim"] == postcut)
            check("L3 d=%d live flip K" % d,
                  rec["K_flip"] == paths.SEALED_P3_K[d])

    print()
    if fails:
        print("CONE_D3738_VERIFY_FAIL %d/%d  %s"
              % (len(fails), len(checks), fails))
        return 1
    print("CONE_D3738_VERIFY_OK")
    print("ALLGREEN  %d checks  %.1fs" % (len(checks), time.time() - T0))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
