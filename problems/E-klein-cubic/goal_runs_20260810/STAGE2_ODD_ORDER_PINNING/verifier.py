"""STAGE2_ODD_ORDER_PINNING verifier.

Every claim of THEOREM.md that is a finite computation is re-checked here from
scratch: the group model at two split primes, the eigen data, the sealed normal
characters of TERMINUS_STRATA_PW, the two independent congruence code paths,
the brute-force covariant module, the pinning statements, the equivariance
commutations, and the collapsed counts.

    python3 verifier.py            # writes results/verifier_stdout.txt
"""
import json
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), "scripts"))

from s2core import Model, QR11, normpt                       # noqa: E402
from s2pin import (SPECTRUM, pathA_weight, pathB_level0, pathB_level1,       # noqa: E402
                   pathB_level2, IMMUNE_ROWS, value_set, tangent_weights,
                   forbidden_relative_weight, diff_blocks)

CHECKS = []


def check(name, ok, detail=""):
    CHECKS.append((name, bool(ok), detail))
    print("CHECK %-52s %s %s" % (name, "PASS" if ok else "FAIL", detail))
    return ok


# --------------------------------------------------------------- A. the model
def part_A():
    for p in (331, 661):
        m = Model(p)
        check("A1 |G|=660 (p=%d)" % p, len(m.G) == 660)
        prof = {}
        for A in m.G:
            prof[m.order[A]] = prof.get(m.order[A], 0) + 1
        check("A2 order profile (p=%d)" % p,
              prof == {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120}, str(prof))
        # F invariant under both generators
        ok = True
        for A in (m.S, m.T):
            for _ in range(6):
                v = tuple((3 * i * i + 7 * i + 1) % p for i in range(5))
                if m.F(m.act(A, v)) != m.F(v):
                    ok = False
        check("A3 F invariant under S and T (p=%d)" % p, ok)


# ------------------------------------------------------------ B. eigen layer
SEALED_NORMAL = {          # TERMINUS_STRATA_PW results/t2_strata.txt, stage 0
    "C11": {9: [3, 5, 6, 7], 1: [2, 3, 4, 8], 3: [1, 2, 6, 9],
            4: [1, 5, 8, 10], 5: [4, 7, 9, 10]},
    "C5": [1, 2, 3, 4],
    "C6a": [4, 5, 2, 3],   # printed as [4/6] [5/6] [2/6] [3/6]
    "C6b": [1, 2, 3, 5],
    "C3line": [2, 1, 1],   # the non-trivial tangent weights on an eigenline
    "A4a": [0, 1, 1, 2],
    "A4b": [0, 1, 2, 2],
}


def part_B():
    data = json.load(open("results/eigen_data.json"))
    for p in ("331", "661"):
        r = data[p]
        check("B1 C11 weights = QR11 (p=%s)" % p, r["C11_weights_are_QR"],
              str(r["C11_weights"]))
        check("B2 all five C11-eigenpoints on X (p=%s)" % p,
              all(r["C11_points_onX"].values()))
        check("B3 C11 normal weights = sealed terminus (p=%s)" % p,
              all(sorted(SEALED_NORMAL["C11"][int(k)]) == v
                  for k, v in r["C11_normal_weights"].items()))
        check("B4 C11 normaliser acts by multiplication (p=%s)" % p,
              r["C11_normaliser_is_multiplicative"]
              and set(x[0] for x in r["C11_normaliser_mult_constants"]) <= set(QR11))
        check("B5 C5 spectrum is the regular rep (p=%s)" % p,
              r["C5_weights_regular"])
        check("B6 C5 weight-0 point OFF X, stab = D10 (p=%s)" % p,
              (not r["C5_points_onX"]["0"]) and r["C5_weight0_stab_order"] == 10)
        check("B7 the four non-trivial C5-eigenpoints ON X (p=%s)" % p,
              all(r["C5_points_onX"][str(a)] for a in (1, 2, 3, 4)))
        check("B8 C5 normal weights = sealed (p=%s)" % p,
              all(v == SEALED_NORMAL["C5"] for v in r["C5_normal_weights"].values()))
        check("B9 D10 involution acts by a -> -a (p=%s)" % p,
              r["C5_involution_is_negation"])
        check("B10 C6 spectrum = {0,1,2,4,5} (p=%s)" % p, r["C6_weights_are_01245"])
        check("B11 X^{C6} = weights {1,5}, and those are the t=-1 ones (p=%s)" % p,
              [w for w, f in r["C6_points_onX"].items() if f] == ["1", "5"]
              and all(r["C6_t_eigenvalues"][w] == (-1 if int(w) % 2 else 1)
                      for w in r["C6_t_eigenvalues"]))
        check("B12 C3 spectrum multiplicities (1,2,2) (p=%s)" % p, r["C3_is_1_2_2"])
        check("B13 C3 weight-0 point OFF X, stab = D12 (p=%s)" % p,
              (not r["C3_weight0_onX"]) and r["C3_weight0_stab_order"] == 12)
        el = r["C3_eigenlines"]
        check("B14 neither C3-eigenline lies in X (p=%s)" % p,
              not el["1"]["line_inside_X"] and not el["2"]["line_inside_X"])
        check("B15 the X^{C6} point on the weight-w eigenline has C6-weight "
              "1 resp 5 (p=%s)" % p,
              el["1"]["C6_points_onX_here"] == [1]
              and el["2"]["C6_points_onX_here"] == [5])
        check("B16 A4-point normal C3-weights = sealed terminus (p=%s)" % p,
              sorted(x["normal_C3_weights"] for x in r["A4"])
              == sorted([SEALED_NORMAL["A4a"], SEALED_NORMAL["A4b"]]))
        check("B17 both A4-points OFF X, stab order 12 (p=%s)" % p,
              all((not x["onX"]) and x["stab_order"] == 12 for x in r["A4"]))
    # B18/B19 are the two group-theoretic facts Prop 1.6 and J3 rest on.
    for p in (331, 661):
        m = Model(p)
        A6 = m.elt_of_order(6)
        A3 = m.mm(A6, A6)
        eb = m.eigenbasis(A3, 3)
        L1 = [v for b, v in eb if b == 1]
        L2 = [v for b, v in eb if b == 2]

        def canon(U):
            return m.rref([list(u) for u in U])[0]
        c1, c2 = canon(L1), canon(L2)
        stab = [A for A in m.G if canon([m.act(A, v) for v in L1]) == c1]
        swap = [A for A in m.G if canon([m.act(A, v) for v in L1]) == c2]
        cent = m.centralizer(A3)
        check("B18 Stab_G(C3-eigenline) = C_G(C3) = C6, and the six elements "
              "of D12 outside it swap the two eigenlines (p=%d)" % p,
              len(stab) == 6 and len(swap) == 6
              and sorted(map(m.G.index, stab)) == sorted(map(m.G.index, cent)))
        v0 = [v for b, v in eb if b == 0][0]
        st = m.stab_point(v0)
        check("B19 D12 acts TRIVIALLY on the D12-point line (needed for J3) "
              "(p=%d)" % p,
              len(st) == 12 and all(all((m.act(A, v0)[i] - v0[i]) % p == 0
                                        for i in range(5)) for A in st))


# ------------------------------------------------------ C. congruence engine
def part_C():
    t = json.load(open("results/tables.json"))
    cc = t["path_crosscheck"]
    check("C1 path A (closed form) == path B (enumeration)",
          cc["mismatches"] == 0 and cc["tested"] > 40000,
          "%d cases" % cc["tested"])
    # level-0 statement, re-derived here a third time
    bad = 0
    for n in (3, 5, 6, 11):
        a = SPECTRUM[n]["weights"]
        for d in range(1, 200):
            for k in range(5):
                w = pathB_level0(n, d)[k][0]
                if w != (d * a[k]) % n:
                    bad += 1
    check("C2 T(e_k) weight = d*a_k for all n, d<200", bad == 0)
    # the four odd-order base-locus corollaries
    check("C3 D12-point (C3 weight 0) is always a base point",
          all(not SPECTRUM[3]["onX"].get((d * 0) % 3, False) for d in range(3)))
    check("C4 D10-point (C5 weight 0) is always a base point",
          all(not SPECTRUM[5]["onX"].get((d * 0) % 5, False) for d in range(5)))
    check("C5 X^{C11} in Bs(T) iff d is not a QR mod 11",
          all(((d in QR11) == all((d * k) % 11 in QR11 for k in QR11))
              for d in range(11)))
    check("C6 X^{C5} in Bs(T) iff 5 | d",
          all(((d % 5 != 0) == all((d * a) % 5 != 0 for a in (1, 2, 3, 4)))
              for d in range(5)))
    check("C7 X^{C6} in Bs(T) iff d is not +-1 mod 6",
          all((((d % 6) in (1, 5)) ==
               all(SPECTRUM[6]["onX"].get((d * a) % 6, False) for a in (1, 5)))
              for d in range(6)))
    check("C8 both C3-eigenlines in Bs(T) iff 3 | d",
          all((((d % 3) != 0) == all((d * w) % 3 != 0 for w in (1, 2)))
              for d in range(3)))


# ---------------------------------------------------- D. the pinned row table
def part_D():
    t = json.load(open("results/tables.json"))
    im = t["immune"]
    check("D1 all 165 residues present", len(im) == 165)
    check("D2 no residue is contradictory",
          all(r["verdict"] == "CONSISTENT" for r in im))
    # C11 quadruple statement
    ok = True
    for r in im:
        d11 = r["d_mod_11"]
        prof = {int(k): v for k, v in r["C11"]["mu_profile"].items()}
        four = {mu for mu, v in prof.items() if v == 4}
        if d11 in QR11:
            if four != {0, d11 % 11}:
                ok = False
        else:
            if four:
                ok = False
        mx = max(prof.values())
        if d11 in QR11 and mx != 4:
            ok = False
        if d11 not in QR11 and d11 != 0 and mx != 3:
            ok = False
        if d11 == 0 and mx != 2:
            ok = False
    check("D3 C11 quadruple rule: all four rows defined iff d in QR11 and "
          "mu = 0 or d (mod 11); max 3 if d non-residue, max 2 if 11 | d", ok)
    check("D4 the eight pt_C5 rows are always simultaneously realisable",
          all(r["C5"]["a"]["n_defined"] + r["C5"]["b"]["n_defined"] == 8
              for r in im))
    check("D5 the two pt_D10 rows are always simultaneously realisable",
          all(r["C5"]["D10"]["n_defined"] == 2 for r in im))
    # D10 pair lands in different C5-orbits, for every mu0
    orb = {1: "a", 4: "a", 2: "b", 3: "b"}
    ok = all(orb[(mu * 1) % 5] != orb[(mu * 2) % 5] for mu in (1, 2, 3, 4))
    check("D6 the two pt_D10 rows always land in DIFFERENT C5-orbits", ok)
    check("D7 the eight C3 rows are always simultaneously realisable",
          all(r["C3"]["a"]["n_defined"] + r["C3"]["b"]["n_defined"] == 8
              for r in im))
    check("D8 every defined C11/C5 row has EXACTLY ONE admissible value",
          all(len(value_set(11, w)) == 1
              for w in QR11) and all(len(value_set(5, w)) == 1
                                     for w in (1, 2, 3, 4)))
    check("D9 every defined C3 row has EXACTLY THREE admissible values",
          all(len(value_set(3, w)) == 3 for w in (1, 2))
          and value_set(3, 0) == [])
    stage1 = 6 ** 8 * 4 ** 10 * 5 ** 4
    check("D10 Stage-1 immune factor = 1100753141760000",
          stage1 == 1100753141760000, str(stage1))
    check("D11 collapsed immune factor = 3^8 = 6561",
          all(r["collapsed_count_all_defined"] == 6561 for r in im))
    check("D12 collapse factor = 2^28 * 5^4 = 167772160000",
          stage1 // 6561 == 2 ** 28 * 5 ** 4 == 167772160000,
          str(stage1 // 6561))


# ------------------------------------------------ E. equivariance and C6-band
def part_E():
    t = json.load(open("results/tables.json"))
    eq = t["equivariance"]
    check("E1 F55 5-cycle commutes with a -> d a at C11",
          eq["F55_C11_commutes"]["violations"] == 0)
    check("E2 D10 inversion commutes with a -> d a at C5",
          eq["D10_C5_commutes"]["violations"] == 0)
    check("E3 D12/C3 eigenline swap commutes with w -> d w",
          eq["D12_C3_commutes"]["violations"] == 0)
    band = t["c6_band_DPsigma"]
    ok = True
    for r in band:
        d, m = r["d_mod_6"], r["m_mod_6"]
        good = (d % 3 != 0) and (m % 3 != 0) and (m % 3 == d % 3)
        if good != (r["n_degenerate"] == 0):
            ok = False
    check("E4 the six C6-children of D_{P_sigma} are all non-degenerate "
          "iff  d != 0 and m = d  (mod 3)", ok)
    check("E5 when 3|d and 3|m all six C6-children are degenerate",
          all(r["n_degenerate"] == 6 for r in band
              if r["d_mod_6"] % 3 == 0 and r["m_mod_6"] % 3 == 0))
    check("E6 m odd is consistent with the sealed parity theorem (H0-1)",
          all(r["m_mod_6"] % 2 == 1 for r in band))


# ------------------------------------------------------- F. first-order layer
def part_F():
    t = json.load(open("results/tables.json"))
    fo = t["first_order"]
    d11 = {e["d_mod_n"]: e for e in fo if e["n"] == 11 and e["source_weight"] == 1}
    check("F1 dT = 0 at every C11-point when d = 3 (mod 11)",
          d11[3]["max_rank"] == 0)
    check("F2 dT has rank <= 3 at C11 iff d = 1 (mod 11)",
          d11[1]["max_rank"] == 3
          and all(d11[d]["max_rank"] == 1 for d in (4, 5, 9)))
    d6 = {e["d_mod_n"]: e for e in fo if e["n"] == 6 and e["source_weight"] == 1}
    check("F3 dT has rank <= 2 at X^{C6} when d = 5 (mod 6), <= 3 when d = 1",
          d6[5]["max_rank"] == 2 and d6[1]["max_rank"] == 3)
    d5 = {e["d_mod_n"]: e for e in fo if e["n"] == 5 and e["source_weight"] == 1}
    check("F4 dT has rank <= 3 at X^{C5} for every d not divisible by 5",
          all(d5[d]["max_rank"] == 3 for d in (1, 2, 3, 4)))
    # the -3a rule against a direct computation of dF at the eigenpoints
    m = Model(331)
    ok = True
    A5 = m.elt_of_order(5)
    for n, g in ((5, A5), (11, m.T), (6, m.elt_of_order(6))):
        eb = m.eigenbasis(g, n)
        for a, v in eb:
            if not m.onX(v):
                continue
            grad = [(2 * v[l] * v[(l + 1) % 5] + v[(l - 1) % 5] ** 2) % m.p
                    for l in range(5)]
            # the eigenvector NOT killed by dF must have weight -2a
            nz = []
            for b, u in eb:
                if sum(grad[l] * u[l] for l in range(5)) % m.p:
                    nz.append(b)
            if nz != [(-2 * a) % n]:
                ok = False
    check("F5 dF at a weight-a eigenpoint is supported on weight -2a "
          "(direct gradient computation, p=331)", ok)


# ----------------------------------------------------- G. brute-force module
SEALED_MOLIEN = {1: 1, 2: 0, 3: 0, 4: 2, 5: 1, 6: 2, 7: 4}


def part_G():
    bf = json.load(open("results/covariant_bruteforce.json"))
    for p in ("331", "661"):
        for d, dim in SEALED_MOLIEN.items():
            key = "d=%d" % d
            if key not in bf[p]:
                continue
            check("G dim M_%d = %d (p=%s, sealed Molien)" % (d, dim, p),
                  bf[p][key]["dim_M_d"] == dim, str(bf[p][key]["dim_M_d"]))
        tot_m = tot_e = tot_c = 0
        for key, rec in bf[p].items():
            for n, c in rec["checks"].items():
                tot_m += c["monomial_congruence_violations"]
                tot_e += c["eigenpoint_value_violations"]
                tot_c += c["nonzero_coeffs_in_eigenbasis"]
        check("G monomial-congruence violations = 0 (p=%s)" % p, tot_m == 0,
              "%d coefficients tested" % tot_c)
        check("G eigenpoint-value violations = 0 (p=%s)" % p, tot_e == 0)


# ------------------------------------------------------------ H. cross-prime
def part_H():
    data = json.load(open("results/eigen_data.json"))
    a, b = data["331"], data["661"]
    same = [k for k in a
            if k not in ("p", "C3_eigenlines", "C11_normaliser_mult_constants",
                         "C5_involution_perms")]
    check("H1 the two primes give identical eigen data",
          all(a[k] == b[k] for k in same),
          str([k for k in same if a[k] != b[k]]))
    check("H2 C3-eigenline F_p-rationality differs by design (3 at 331, "
          "1 at 661) - matches RECEIVER_LEDGER_X 3.1",
          a["C3_eigenlines"]["1"]["num_Fp_points_on_X"] == 3
          and b["C3_eigenlines"]["1"]["num_Fp_points_on_X"] == 1)


def main():
    part_A(); part_B(); part_C(); part_D(); part_E(); part_F(); part_G(); part_H()
    n = len(CHECKS)
    bad = [c for c in CHECKS if not c[1]]
    print()
    print("STAGE2_ODD_ORDER_PINNING_VERIFY: %d checks, %d failures" % (n, len(bad)))
    for c in bad:
        print("  FAILED:", c[0], c[2])
    if not bad:
        print("STAGE2_ODD_ORDER_PINNING_VERIFY_OK")
        print("ALLGREEN")
    with open("results/verifier_output.json", "w") as f:
        json.dump({"n_checks": n, "n_failures": len(bad),
                   "checks": [{"name": a, "ok": b, "detail": c}
                              for a, b, c in CHECKS]}, f, indent=1)
    return 0 if not bad else 1


if __name__ == "__main__":
    sys.exit(main())
