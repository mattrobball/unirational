#!/usr/bin/env python3
"""D34_GUIDED_SWEEP, engine 3 -- the guided ladder sweep, degree by degree.

For each degree d this imposes, on M_d = (Sym^d W* (x) W)^G,

  PROFILE-INDEPENDENT (STAGE2_ODD_ORDER_PINNING, all Tier-1):
    (P)   ord_{P_sigma}(T) >= 1 and ord_{P_sigma}(T^+) >= 2       [Prop 1.3]
    (M)   d even            =>  T|_{L_sigma} = 0                  [Prop 1.4(i)]
    (E)   3 | d             =>  T|_{ell_w} = 0 (both eigenlines)  [Prop 1.6]
          3 !| d            =>  ann(p_{dw}) . T|_{ell_w} = 0      [Prop 1.6]
    (C6)  d != +-1 (mod 6)  =>  T = 0 at both X^{C6} points       [Cor 1.5]
    (C11) d not a QR mod 11 =>  T = 0 at the C11-eigenpoints      [B(C11)]
    (C5)  5 | d             =>  T = 0 at the exact-C5 points      [B(C5)]
    (D10) always            =>  T = 0 at the D10-point            [B(D10)]
    (D12) always            =>  T = 0 at c_sigma                  [B(D12)]

  PROFILE (the FIX-P1/FIX-P2 sieve, corrected bound n >= 2e):
    (L)   ord_{ell_V}(T) >= r

MONOTONICITY.  Every admissible profile at a given d has m >= 1 and
r >= r0(d) := min r over the admissible profiles, so its slice is CONTAINED in
the r0-slice.  Hence ONE rank computation per degree decides the whole degree:

    dim{ structure + (P) + ord_{ell_V} >= r0(d) } = 0   =>   degree d EMPTY.

Semantics (slicelib.__doc__): a computed dimension 0 is a characteristic-zero
emptiness verdict; a nonzero value is an upper bound only.  Sampling a subset
of the functionals of a vanishing condition only ENLARGES the computed space.

Usage:  python3 produce_ladder.py [p] [dmin] [dmax] [npair] [npt]
"""
import json
import os
import sys
import time

import numpy as np

import slicelib as SL
import p2lib as P2
import d34lib as D34
import produce_dims34 as DIMS
import produce_d34 as PD

HERE = os.path.dirname(os.path.abspath(__file__))
RES = os.path.join(HERE, "results")
T0 = time.time()


def cone_min_r(m):
    return (3 * m + 1) // 2 if m % 2 else (3 * m) // 2


def cell_empty_all_line_degrees(m, r):
    if (m, r) in {(1, 2), (1, 3), (1, 4), (1, 5), (3, 5)}:
        return True
    if m % 2 == 1 and r == cone_min_r(m):
        return True
    return False


def profiles(d):
    """FIX-P2's corrected-bound sieve, verbatim (n >= 2e, i.e. d >= 3r-2m)."""
    out = []
    m = 1
    while m <= 2 * d:
        for r in range(cone_min_r(m), d + 1):
            e = r - m
            if e < 1:
                continue
            n = d - r
            if n < 2 * e:
                continue
            if cell_empty_all_line_degrees(m, r):
                continue
            out.append({"m": m, "r": r, "e": e, "n": n})
        m += 2
    return out


def eig_points(fr, p):
    """C11-eigenpoints (5, all on X) and the exact-C5 points (4, on X)."""
    RHO = fr["RHO"]
    I5 = np.eye(5, dtype=np.int64)
    g11 = [g for g in range(660) if fr["orders"][g] == 11][0]
    z11 = None
    for a in range(2, p):
        c = pow(a, (p - 1) // 11, p)
        if c != 1:
            z11 = c
            break
    P11 = []
    for k in range(11):
        ns = SL.nullspace((RHO[g11] - pow(z11, k, p) * I5) % p, p)
        for row in ns:
            P11.append(row % p)
    assert len(P11) == 5, len(P11)
    assert all(D34.klein_F(v, p) % p == 0 for v in P11), "C11 pts not on X"

    g5 = [g for g in range(660) if fr["orders"][g] == 5][0]
    P5on, P5off = [], []
    if (p - 1) % 5 == 0:
        z5 = None
        for a in range(2, p):
            c = pow(a, (p - 1) // 5, p)
            if c != 1:
                z5 = c
                break
        for k in range(5):
            ns = SL.nullspace((RHO[g5] - pow(z5, k, p) * I5) % p, p)
            for row in ns:
                (P5on if D34.klein_F(row, p) % p == 0
                 else P5off).append(row % p)
        assert len(P5on) == 4 and len(P5off) == 1, (len(P5on), len(P5off))
    else:
        # 5 does not divide p-1: the exact-C5 eigenpoints are not F_p-rational.
        # The B(C5) block is then simply OMITTED -- dropping functionals only
        # ENLARGES the computed space, so every EMPTY verdict stays valid.
        ns = SL.nullspace((RHO[g5] - I5) % p, p)
        P5off = [ns[0] % p]
        print("[warn] 5 does not divide p-1 = %d: the B(C5) block is omitted "
              "at this prime (safe: fewer functionals)" % (p - 1))
    return P11, P5on, P5off


def structure_blocks(fr, A, C, d, npt, p, rng, P11, P5on, P5off):
    """The profile-independent STAGE2 conditions at degree d.  Returns
    (list of (tag, block), dict of which rules fired)."""
    out = []
    fired = {}
    # (M) minus-lines
    if d % 2 == 0:
        out.append(("M: T|_{L_sigma}=0 (55 minus-lines)",
                    D34.minus_line_block(fr, A, C, d, npt, p, rng)))
        fired["M_minus_lines"] = True
    else:
        fired["M_minus_lines"] = False
    # (E) C3-eigenlines
    ns_ = A.shape[0]
    if d % 3 == 0:
        b = []
        for ELL in (fr["ELL1"], fr["ELL2"]):
            Wb = D34.rand_in_span(ELL, npt, p, rng)
            J = SL.jet_rows(fr, A, C, Wb, np.zeros_like(Wb), 1, deg=d)
            b.append(J.reshape(ns_, -1) % p)
        out.append(("E: T|_{ell_w}=0 (110 C3-eigenlines)",
                    np.concatenate(b, axis=1)))
        fired["E_eigenlines"] = "vanish (3|d)"
    else:
        # target point: the X^{C6} point on ell_{dw}
        b = []
        for w, ELL in ((1, fr["ELL1"]), (2, fr["ELL2"])):
            tw = (d * w) % 3
            pt = fr["PW1"] if tw == 1 else fr["PW2"]
            ANN = SL.nullspace(pt[None, :] % p, p)
            Wb = D34.rand_in_span(ELL, npt, p, rng)
            J = SL.jet_rows(fr, A, C, Wb, np.zeros_like(Wb), 1, deg=d)[:, :, :, 0]
            b.append(np.einsum('sqc,kc->sqk', J, ANN).reshape(ns_, -1) % p)
        out.append(("E: contraction to X^{C6} on ell_{dw}",
                    np.concatenate(b, axis=1)))
        fired["E_eigenlines"] = "contract to ell_{%d w}" % (d % 3)
    # (C6) points
    pts = [fr["D10pt"], fr["w0"]]
    tags = ["D10-point", "D12-point c_sigma"]
    if d % 6 not in (1, 5):
        pts += [fr["C6_eig"][1][0], fr["C6_eig"][5][0]]
        tags += ["X^{C6} pair"]
        fired["C6_points"] = True
    else:
        fired["C6_points"] = False
    if d % 11 not in (1, 3, 4, 5, 9):
        pts += list(P11)
        tags += ["X^{C11} (60 pts)"]
        fired["C11_points"] = True
    else:
        fired["C11_points"] = False
    if d % 5 == 0 and P5on:
        pts += list(P5on)
        tags += ["X^{C5} (264 pts)"]
        fired["C5_points"] = True
    else:
        fired["C5_points"] = ("omitted (5 !| p-1)" if d % 5 == 0 and not P5on
                              else False)
    out.append((" + ".join(tags), D34.point_block(fr, A, C, d, pts, p)))
    return out, fired


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 67
    dmin = int(sys.argv[2]) if len(sys.argv) > 2 else 34
    dmax = int(sys.argv[3]) if len(sys.argv) > 3 else 40
    npair = int(sys.argv[4]) if len(sys.argv) > 4 else 100
    npt = int(sys.argv[5]) if len(sys.argv) > 5 else 80
    os.makedirs(RES, exist_ok=True)
    rng = np.random.default_rng(20260811)

    P = DIMS.big_prime()
    dims, _ = DIMS.pathA_dimM(P, dmax=max(dmax, 40))
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p)))
    P11, P5on, P5off = eig_points(fr, p)
    print("[eig] 5 C11-points on X, 4 exact-C5 points on X, 1 D10-point off X",
          flush=True)

    rows = []
    fn = os.path.join(RES, "ladder_p%d_%d_%d.json" % (p, dmin, dmax))
    for d in range(dmin, dmax + 1):
        profs = profiles(d)
        dimM = dims[d]
        if not profs:
            print("d=%2d dimM=%4d  NO ADMISSIBLE PROFILE -> EMPTY" % (d, dimM),
                  flush=True)
            rows.append({"d": d, "dim_M": dimM, "n_profiles": 0,
                         "verdict": "EMPTY-NO-PROFILE"})
            continue
        r0 = min(x["r"] for x in profs)
        m0 = min(x["m"] for x in profs)
        A, C, got = PD.basis_seeds(fr, d, dimM, p, rng)
        if A is None:
            print("d=%2d SEED SHORTFALL %d/%d -- NOT DECIDED"
                  % (d, got, dimM), flush=True)
            rows.append({"d": d, "dim_M": dimM, "verdict": "NOT-DECIDED",
                         "reason": "seed shortfall %d/%d" % (got, dimM)})
            with open(fn, "w") as fh:
                json.dump({"prime": p, "rows": rows}, fh, indent=1,
                          sort_keys=True)
            continue
        c1, c2 = PD.plane_blocks(fr, A, C, d, 1, npair, p, rng)
        sb, fired = structure_blocks(fr, A, C, d, npt, p, rng,
                                     P11, P5on, P5off)
        blocks = [c1, c2] + [b for _, b in sb]
        d_struct = int(dimM - P2.rref_rank_fast(
            np.concatenate(blocks, axis=1), p))
        lb = PD.line_block(fr, A, C, d, r0, npair, p, rng)
        d_full = int(dimM - P2.rref_rank_fast(
            np.concatenate(blocks + [lb], axis=1), p))
        # FIX-P2 baseline for comparison: profile conditions only
        d_prof = int(dimM - P2.rref_rank_fast(
            np.concatenate([c1, c2, lb], axis=1), p))
        rec = {"d": d, "dim_M": dimM, "n_profiles": len(profs),
               "r0": r0, "m0": m0, "rules_fired": fired,
               "dim_profile_only_(1,r0)": d_prof,
               "dim_structure_only": d_struct,
               "dim_structure_plus_(1,r0)": d_full,
               "verdict": ("EMPTY" if d_full == 0 else "ALIVE:%d" % d_full)}
        rows.append(rec)
        print("d=%2d dimM=%4d  #prof=%2d r0=%2d | FIX-P2 profile-only (1,%d) = "
              "%4d | structure-only = %4d | BOTH = %4d  -> %s   [%.0f s]"
              % (d, dimM, len(profs), r0, r0, d_prof, d_struct, d_full,
                 rec["verdict"], time.time() - T0), flush=True)
        with open(fn, "w") as fh:
            json.dump({"prime": p, "range": [dmin, dmax], "rows": rows,
                       "monotonicity": ("every admissible profile at d has "
                                        "m >= 1 and r >= r0, so its slice is "
                                        "contained in the (1,r0) slice"),
                       "semantics": ("dimension 0 is a characteristic-zero "
                                     "emptiness verdict; nonzero is an upper "
                                     "bound only")}, fh, indent=1,
                      sort_keys=True)
    print("wrote", fn, " [%.0f s]" % (time.time() - T0))
    return 0


if __name__ == "__main__":
    sys.exit(main())
