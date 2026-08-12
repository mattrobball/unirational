#!/usr/bin/env python3
"""Replayable verifier for CONE_PROBE_AUDIT. python3 only. No slicelib."""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
SCR = os.path.join(HERE, "scripts")
sys.path.insert(0, SCR)

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
    print("CONE_PROBE_AUDIT verifier", flush=True)
    check("no slicelib", "slicelib" not in sys.modules)

    th = open(os.path.join(HERE, "THEOREM.md")).read()
    check("H1 headline OPEN", "Problem E remains OPEN" in th)
    check("H2 excludes no degree", "excludes no degree" in th)
    check("H3 no REPORT.md", not os.path.isfile(os.path.join(HERE, "REPORT.md")))
    check("H4 registration present",
          os.path.isfile(os.path.join(HERE, "REGISTRATION_SNIPPET.md")))
    check("H5 Not claimed", "Not claimed" in th)
    check("H6 honesty", "Honesty" in th)
    check("H7 exit ledger", "CONE-PROBE-AUDIT-R3-CORRECTED" in th)
    check("H8 dimV modular", "dim V ≤ 17" in th or "dim V <= 17" in th)

    print("[R1]")
    r1 = loadj("r1_summary.json")
    check("R1 summary", r1 is not None)
    check("R1 CONFIRMED", (r1 or {}).get("verdict") == "CONFIRMED")
    for p in (331, 661):
        rec = (r1 or {}).get("primes", {}).get(str(p)) or loadj("r1_p%d.json" % p)
        check("R1 p=%d present" % p, rec is not None)
        if not rec:
            continue
        check("R1 p=%d rank5" % p, rec.get("all_cell_rank5") is True,
              str(rec.get("cell_ranks")))
        check("R1 p=%d Euler" % p, rec.get("all_euler") is True)
        check("R1 p=%d ambient5" % p, rec.get("all_ambient_rank5") is True)

    print("[R2/R3]")
    r23 = loadj("r2r3_summary.json")
    check("R2 CONFIRMED", (r23 or {}).get("R2") == "CONFIRMED")
    check("R3 machine CONFIRMED", (r23 or {}).get("R3_machine") == "CONFIRMED")
    want = {6: 56, 8: 120, 10: 220, 18: 1140, 19: 1330, 20: 1380, 22: 1380}
    for p in (331, 661):
        rec = ((r23 or {}).get("primes") or {}).get(str(p)) or loadj("r2r3_p%d.json" % p)
        check("R2 p=%d present" % p, rec is not None)
        if not rec:
            continue
        check("R2 p=%d P3=1380" % p, rec.get("P3_sampled") == 1380)
        by_m = {}
        for s in rec.get("sections") or []:
            by_m.setdefault(s["m"], []).append(s["rank"])
        for m, r in want.items():
            ranks = by_m.get(m) or []
            check("R2 p=%d m=%d rank %d" % (p, m, r),
                  ranks and all(x == r for x in ranks), str(ranks))
        fr = rec.get("free") or {}
        check("R3 p=%d m=18 full" % p, (fr.get("18") or {}).get("all_full") is True)
        check("R3 p=%d m=19 full" % p, (fr.get("19") or {}).get("all_full") is True)

    print("[R4]")
    r4 = loadj("r4_summary.json")
    check("R4 CONFIRMED", (r4 or {}).get("verdict") == "CONFIRMED")
    check("R4 dimV<=17 modular", (r4 or {}).get("dimV_le_17_modular") is True)
    dlead = (r4 or {}).get("director") or {}
    check("R4 director 0-dim", dlead.get("zero_dimensional") is True)
    check("R4 director 20 pures",
          dlead.get("criterion_applies") is True
          and dlead.get("exponent_multiset_matches_readme") is True)
    from leadparse import parse_leading_ideal
    import paths
    sealed = parse_leading_ideal(
        os.path.join(paths.DIR_PROBES, "cone_m20_lead.out"))
    check("R4 sealed reparse 0-dim", sealed.get("zero_dimensional") is True)
    check("R4 sealed nlead 11201", sealed.get("nlead") == 11201,
          str(sealed.get("nlead")))
    for p in (331, 661):
        own = ((r4 or {}).get("own") or {}).get(str(p)) or {}
        check("R4 own p=%d 0-dim" % p, own.get("zero_dimensional") is True)
        check("R4 own p=%d rank 1380" % p, own.get("restricted_rank") == 1380)
        lp = os.path.join(RES, "own_cone_m20_p%d_lead.out" % p)
        parsed = parse_leading_ideal(lp)
        check("R4 own p=%d lead reparse" % p,
              parsed.get("zero_dimensional") is True
              and parsed.get("nvars") == 20,
              "missing=%s" % parsed.get("missing_pure"))

    print("[R5]")
    from hilbert import degree_of_regularity, macaulay_columns
    r5 = loadj("r5_hilbert.json")
    check("R5 CONFIRMED", (r5 or {}).get("verdict") == "CONFIRMED")
    for m, claimed, cols in ((55, 21, None), (520, 7, 32224114), (1380, 5, 749398)):
        dreg, _ = degree_of_regularity(37, m, dmax=40)
        check("R5 m=%d dreg=%d" % (m, claimed), dreg == claimed, str(dreg))
        if cols is not None:
            check("R5 m=%d columns" % m, macaulay_columns(37, dreg) == cols)

    if live:
        print("[LIVE]")
        from cell37 import cell37, load_AC
        from frame import build_frame
        from linalg import rref_rank
        from reynolds import covariant_jacobian, covariant_value
        import numpy as np
        p = 331
        fr = build_frame(p, verbose=False)
        A, C = load_AC()
        B = cell37(p)["B37"]
        rng = np.random.default_rng(99)
        c = rng.integers(1, p, size=37)
        vec = (c @ B) % p
        w = rng.integers(1, p, size=5)
        J = covariant_jacobian(fr, A, C, vec, w)
        Tw = covariant_value(fr, A, C, vec, w)
        check("LIVE Euler", bool(np.array_equal((J @ w) % p, (35 * Tw) % p)))
        check("LIVE rank5", rref_rank(J, p) == 5)
        check("LIVE no slicelib", "slicelib" not in sys.modules)

    print()
    if fails:
        print("CONE_PROBE_AUDIT_VERIFY_FAIL %d/%d" % (len(fails), len(checks)))
        for f in fails:
            print("  ", f)
        return 1
    print("CONE_PROBE_AUDIT_VERIFY_OK")
    print("ALLGREEN")
    return 0


if __name__ == "__main__":
    sys.exit(main())
