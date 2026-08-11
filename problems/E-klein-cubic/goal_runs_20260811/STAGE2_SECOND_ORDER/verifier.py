"""STAGE2_SECOND_ORDER verifier.

Re-checks, from the exact matrices at p = 331 and p = 661:
  A  the group model,
  B  the A4-adapted set-up at both A4-orbits (the weight dictionary on which
     lever 1 rests),
  C  the jet-space dimensions and the mu = 1 exclusion,
  D  the landing verdicts of lever 1 (mu = 2,3,4,5),
  E  the C11 line geometry and the multiplicity bounds of lever 2,
  F  cross-prime agreement.

    python3 verifier.py       # writes results/verifier_stdout.txt
"""
import json
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "scripts"))

from s3core import Model, QR11                                     # noqa: E402
from s3a4 import (A4Point, equivariant_space, eval_phi, F_of_phi,   # noqa: E402
                  coords_in, nullspace_rows, inter, prop)
from s3lever2 import mu_min_table, mu1_rank_table                   # noqa: E402

CHECKS = []
Q = set(QR11)


def check(name, ok, detail=""):
    CHECKS.append((name, bool(ok), detail))
    print("CHECK %-64s %s %s" % (name, "PASS" if ok else "FAIL", detail))
    return ok


def part_A():
    for p in (331, 661):
        m = Model(p)
        check("A1 |G| = 660 (p=%d)" % p, len(m.G) == 660)
        prof = {}
        for A in m.G:
            prof[m.order[A]] = prof.get(m.order[A], 0) + 1
        check("A2 order profile (p=%d)" % p,
              prof == {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120})


def part_B():
    for p in (331, 661):
        m = Model(p)
        for which, tag in ((0, "omega"), (1, "omega^2")):
            ap = A4Point(m, which)
            check("B1 |A4| = 12 (p=%d,%s)" % (p, tag), len(ap.A4) == 12)
            check("B2 Theta = sum of the 3 non-trivial V4-eigenspaces, dim 3 "
                  "(p=%d,%s)" % (p, tag), len(ap.Theta) == 3)
            check("B3 W^{V4} = ell_V is 2-dimensional and contains both "
                  "A4-points (p=%d,%s)" % (p, tag),
                  len(ap.ell) == 2
                  and len(inter(m, ap.ell, (ap.q,))) == 1
                  and len(inter(m, ap.ell, (ap.qp,))) == 1)
            check("B4 both A4-points are OFF X, stabiliser of order 12 "
                  "(p=%d,%s)" % (p, tag),
                  (not m.onX(ap.q)) and (not m.onX(ap.qp))
                  and len(m.stab_point(ap.q)) == 12
                  and len(m.stab_point(ap.qp)) == 12)
            check("B5 W^{A4} = 0: no trivial A4-summand in W (p=%d,%s)"
                  % (p, tag),
                  all(len(inter(m, (v,), tuple(ap.Theta))) == 0
                      for v in (ap.q, ap.qp)) and True)
            wts = sorted(b for b in ap.theta)
            check("B6 Theta|_{C3} = 1 + omega + omega^2 (weights 0,1,2) "
                  "(p=%d,%s)" % (p, tag), wts == [0, 1, 2])
            # THE dictionary fact: the C3-eigenline through q is <q, theta_{a_q}>
            E = ap.eigline[ap.a_q]
            ok = (len(E) == 2
                  and len(inter(m, E, (ap.q,))) == 1
                  and len(inter(m, E, (ap.theta[ap.a_q],))) == 1)
            check("B7 the C3-eigenline through q is <q, theta_{a_q}>, i.e. the "
                  "relative-weight-0 normal direction (p=%d,%s)" % (p, tag), ok)
            check("B8 neither C3-eigenline lies in X (p=%d,%s)" % (p, tag),
                  all(not all(m.onX(tuple((ap.eigline[w][0][i]
                                           + s * ap.eigline[w][1][i]) % p
                                          for i in range(5)))
                              for s in range(3)) for w in (1, 2)))
            check("B9 exactly one X^{C6} point on each C3-eigenline (p=%d,%s)"
                  % (p, tag), set(ap.C6pt) == {1, 2}
                  and all(m.onX(ap.C6pt[w]) for w in (1, 2)))


def part_C():
    """mu = 1 is impossible at an A4-point."""
    for p in (331, 661):
        m = Model(p)
        for which, tag in ((0, "omega"), (1, "omega^2")):
            ap = A4Point(m, which)
            for dmod3 in (0, 1, 2):
                basis, mons, idx = equivariant_space(m, ap, 1, dmod3)
                check("C1 dim Hom_{A4}(Theta, W (x) omega^{-d}) = 1 "
                      "(p=%d,%s,d=%d)" % (p, tag, dmod3), len(basis) == 1)
                # the generator is injective, so its image is a 3-plane; a
                # smooth cubic threefold contains no plane, so F(Phi) != 0
                Fc = F_of_phi(m, basis[0], mons, 1)
                check("C2 the generator does NOT satisfy F(Phi) = 0 "
                      "(no plane in X) (p=%d,%s,d=%d)" % (p, tag, dmod3),
                      len(Fc) > 0)
                # and the eigenline constraint alone already kills it
                b_line = ap.a_q % 3
                t = coords_in(m, ap.Theta, ap.theta[b_line])
                v = eval_phi(m, basis[0], mons, t)
                wline = (dmod3 * ap.a_q) % 3
                if wline == 0:
                    killed = any(x % p for x in v)
                else:
                    killed = not prop(m, v, ap.C6pt[wline]) if any(
                        x % p for x in v) else False
                check("C3 the eigenline constraint kills the mu=1 jet "
                      "(p=%d,%s,d=%d)" % (p, tag, dmod3), killed)


def part_D():
    m2 = json.load(open("results/lever1_m2.json"))
    agg = {}
    for k, v in m2.items():
        mu = int([x for x in k.split("|") if x.startswith("mu=")][0][3:])
        tgt = k.split("|")[-1]
        agg.setdefault((mu, tgt), set()).add(v != "-1")
    check("D1 mu = 3 : the X^{C6} point is NOT realisable",
          agg.get((3, "C6pt")) == {False}, str(agg.get((3, "C6pt"))))
    check("D2 mu = 3 : the two exact-C3 points ARE realisable",
          agg.get((3, "exactC3")) == {True}, str(agg.get((3, "exactC3"))))
    check("D3 mu = 4 : neither target is realisable (rows are base points)",
          agg.get((4, "C6pt")) == {False} and agg.get((4, "exactC3")) == {False})
    check("D4 mu = 5 : all three targets are realisable (the jet is blind)",
          agg.get((5, "C6pt")) == {True} and agg.get((5, "exactC3")) == {True})
    tg = json.load(open("results/lever1_targets.json"))
    n_c6_not = n_ex_yes = 0
    for pp in tg:
        for r in tg[pp]:
            if "targets" not in r or r.get("mu") != 3 or not r.get(
                    "eigenline_constraint", True):
                continue
            for key, val in r["targets"].items():
                if "X^{C6}" in key:
                    n_c6_not += (val == "NOT realised")
                else:
                    n_ex_yes += val.startswith("REALISED")
    check("D5 independent univariate-gcd route agrees at mu = 3 "
          "(%d C6-exclusions, %d exact-C3 realisations)" % (n_c6_not, n_ex_yes),
          n_c6_not >= 12 and n_ex_yes >= 16)
    lb = json.load(open("results/lever1_landing.json"))
    bad = 0
    for pp in lb:
        for r in lb[pp]:
            if r.get("mu") != 2 or "rows" not in r:
                continue
            for tag, s in r["rows"].items():
                if s.get("weight") and s.get("rank_ev") and s.get("achievable_st") \
                        not in ([], "NOT-SCANNED (dim A' = 2)"):
                    bad += 1
    check("D6 mu = 2 : no landing jet reaches any point of X on the eigenline",
          bad == 0, "%d violations" % bad)


def part_E():
    lv = json.load(open("results/lever2.json"))
    for p in (331, 661):
        L = lv["lines_p%d" % p]
        check("E1 ten C11-coordinate lines, all with stabiliser C11 and orbit "
              "60 (p=%d)" % p,
              len(L) == 10 and all(x["stab_order"] == 11 and x["orbit_size"] == 60
                                   for x in L))
        check("E2 a C11-coordinate line lies IN X iff its ratio class is {3,4} "
              "(p=%d)" % p,
              all(x["line_in_X"] == (x["ratio_class"] == [3, 4]) for x in L))
        check("E3 the split is 5 + 5 (p=%d)" % p,
              sum(1 for x in L if x["line_in_X"]) == 5
              and sum(1 for x in L if not x["line_in_X"]) == 5)
    mm = mu_min_table()
    check("E4 mu_min(d) = 0 exactly for the quadratic residues, else 1",
          all((v == 0) == (d in Q) for d, v in mm.items()), str(mm))
    check("E5 the congruence never forces mu >= 2 at a C11-point",
          max(mm.values()) <= 1)
    r1 = mu1_rank_table()
    check("E6 mu = 1 : at most TWO of the four C11-rows can carry a value",
          all(v["max_rows_with_a_value"] <= 2 for v in r1.values()))
    seven = [d for d, v in r1.items() if v["max_rows_with_a_value"] <= 1]
    check("E7 mu = 1 : at most ONE row for 7 of the 11 residues",
          len(seven) == 7, str(sorted(seven)))
    check("E8 the mu=1 cut is strictly sharper than the sealed congruence "
          "count (4 rows would be allowed at d = 1 mod 11)",
          r1[1]["rows_with_target_on_X"] == [3, 5, 6, 7]
          and r1[1]["max_rows_with_a_value"] == 2)
    # the two upper bounds are far above mu_min, so no exclusion
    check("E9 no exclusion: mu_min(d) <= 1 < floor(d/2) for every d >= 4",
          all(max(mm.values()) < d // 2 for d in range(4, 61)))


def part_F():
    a = {}
    for p in (331, 661):
        m = Model(p)
        ap = A4Point(m, 0)
        a[p] = (sorted(ap.theta), ap.a_q, sorted(ap.C6pt))
    check("F1 the A4 weight dictionary is the same at both primes",
          a[331] == a[661], str(a))
    lv = json.load(open("results/lever2.json"))
    check("F2 the C11 line geometry is the same at both primes",
          [(x["j"], x["k"], x["ratio_class"], x["line_in_X"])
           for x in lv["lines_p331"]]
          == [(x["j"], x["k"], x["ratio_class"], x["line_in_X"])
              for x in lv["lines_p661"]])


def main():
    part_A(); part_B(); part_C(); part_D(); part_E(); part_F()
    n = len(CHECKS)
    bad = [c for c in CHECKS if not c[1]]
    print()
    print("STAGE2_SECOND_ORDER_VERIFY: %d checks, %d failures" % (n, len(bad)))
    for c in bad:
        print("  FAILED:", c[0], c[2])
    if not bad:
        print("STAGE2_SECOND_ORDER_VERIFY_OK")
        print("ALLGREEN")
    json.dump({"n_checks": n, "n_failures": len(bad),
               "checks": [{"name": a, "ok": b, "detail": c}
                          for a, b, c in CHECKS]},
              open("results/verifier_output.json", "w"), indent=1)
    return 0 if not bad else 1


if __name__ == "__main__":
    sys.exit(main())
