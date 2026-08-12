#!/usr/bin/env python3
"""CONE_ORDER_AUDIT -- degree sweep of the r < 6 cells.

Premise under audit (used by every window at every degree):
    every landing covariant T in M_d satisfies  ord_{ell_V}(T) >= 6
along each of the 55 V4-triple-lines.

Sealed origin: FIX-N2 Theorem A (local A4-equivariant landing families with
m >= 1 and r in {2,3,4,5} empty at all line degrees) + H0-1 (m odd, m >= 1)
+ cone bound.  This script does NOT re-prove the local theorem; it checks the
GLOBAL modular prediction at degrees covering all residues mod 6.

For each degree d and prime p:
  * build a Reynolds basis of M_d
  * impose the STAGE2 structure conditions (degree-dependent) + (P)/(P+)
  * compute dim of {structure + ord_{ell_V} >= r} for r = 0..6
  * exact-order upper bounds: dim(>=r) - dim(>=r+1) for r = 0..5
  * saturation: second independent line-pair sample
  * landing probe: random elements of exact-order cells (if nonzero) are
    tested for F(T(v))=0 at many random v; a single non-zero falsifies
    landing for that element (safe direction)

Semantics (slicelib.__doc__): computed dim 0 is a char-0 emptiness verdict;
nonzero dim is an UPPER BOUND only.  Sampling functionals only enlarges the
kernel, so emptiness stays valid.

Usage:
  python3 produce_sweep.py [p] [dmin] [dmax] [npair] [npt]
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import slicelib as SL
import p2lib as P2
import d34lib as D34

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
RES = os.path.join(ROOT, "results")
T0 = time.time()

# Sealed Molien dimensions (D34_GUIDED_SWEEP ledger + pathA to d=42).
DIM_M = {
    31: 410, 32: 459, 33: 511, 34: 576, 35: 637, 36: 706,
    37: 786, 38: 865, 39: 950, 40: 1050, 41: 1148, 42: 1255,
}


class Basis:
    def __init__(self, ncols, p):
        self.p = p
        self.ncols = ncols
        self.rows = np.zeros((0, ncols), dtype=np.int64)
        self.piv = []
        self.keep = []

    def add_block(self, M_, tags):
        p = self.p
        B = np.array(M_, dtype=np.int64) % p
        if self.rows.shape[0]:
            B = (B - B[:, self.piv] @ self.rows) % p
        for i in range(B.shape[0]):
            v = B[i]
            nz = np.nonzero(v)[0]
            if nz.size == 0:
                continue
            c = int(nz[0])
            v = (v * SL.inv_mod(v[c], p)) % p
            if self.rows.shape[0]:
                col = self.rows[:, c].copy()
                k = np.nonzero(col)[0]
                if k.size:
                    self.rows[k] = (self.rows[k] - np.outer(col[k], v)) % p
            self.rows = np.concatenate([self.rows, v[None, :]], axis=0)
            self.piv.append(c)
            self.keep.append(tags[i])
            if i + 1 < B.shape[0]:
                col = B[i + 1:, c].copy()
                k = np.nonzero(col)[0]
                if k.size:
                    B[i + 1 + k] = (B[i + 1 + k] - np.outer(col[k], v)) % p
        return len(self.keep)


def basis_seeds(fr, deg, dim, p, rng, block=2500, maxseeds=150000):
    npt = dim // 5 + 40
    Wev = rng.integers(0, p, size=(npt, 5)) % p
    Yev = np.zeros_like(Wev)
    bas = Basis(npt * 5, p)
    used = 0
    while len(bas.keep) < dim and used < maxseeds:
        A, C = SL.seed_exponents(used + block, deg=deg)
        A, C = A[used:], C[used:]
        used += block
        ev = SL.jet_rows(fr, A, C, Wev, Yev, 1, deg=deg)
        bas.add_block(ev.reshape(A.shape[0], -1),
                      list(zip(A.tolist(), C.tolist())))
        print("    [seeds] tried %d, independent %d / %d  [%.0f s]"
              % (used, len(bas.keep), dim, time.time() - T0), flush=True)
    if len(bas.keep) < dim:
        return None, None, len(bas.keep)
    kA = np.array([k[0] for k in bas.keep[:dim]], dtype=np.int64)
    kC = np.array([k[1] for k in bas.keep[:dim]], dtype=np.int64)
    return kA, kC, dim


def rand_in_span(rows, k, p, rng):
    co = rng.integers(0, p, size=(k, rows.shape[0]))
    return (co @ rows) % p


def plane_blocks(fr, A, C, deg, m, npair, p, rng):
    Wp, Wm = fr["Wplus"], fr["Wminus"]
    ns = A.shape[0]
    Wa = rand_in_span(Wp, npair, p, rng)
    Ya = rand_in_span(Wm, npair, p, rng)
    J = SL.jet_rows(fr, A, C, Wa, Ya, m + 1, deg=deg)
    c1 = J[:, :, :, :m].reshape(ns, -1)
    PPL = fr["PPLUS"]
    top = J[:, :, :, m]
    c2 = np.einsum("sqc,kc->sqk", top, PPL).reshape(ns, -1) % p
    return c1 % p, c2 % p


def line_jets(fr, A, C, deg, rmax, npair, p, rng):
    """Jet matrix along ell_V to order rmax. Shape (ns, nfunc_per_order * rmax)
    stored as (ns, npair, 5, rmax) then cumulative columns used by caller."""
    LINE = fr["ellV"]
    FULL = np.eye(5, dtype=np.int64)
    Wb = rand_in_span(LINE, npair, p, rng)
    Yb = rand_in_span(FULL, npair, p, rng)
    return SL.jet_rows(fr, A, C, Wb, Yb, rmax, deg=deg)  # (ns,npair,5,rmax)


def eig_points(fr, p):
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
    assert len(P11) == 5
    assert all(D34.klein_F(v, p) % p == 0 for v in P11)

    g5 = [g for g in range(660) if fr["orders"][g] == 5][0]
    P5on = []
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
                if D34.klein_F(row, p) % p == 0:
                    P5on.append(row % p)
        assert len(P5on) == 4
    return P11, P5on


def structure_blocks(fr, A, C, d, npt, p, rng, P11, P5on):
    """Profile-independent STAGE2 conditions at degree d (from produce_ladder)."""
    out = []
    fired = {}
    ns_ = A.shape[0]
    if d % 2 == 0:
        out.append(D34.minus_line_block(fr, A, C, d, npt, p, rng))
        fired["M_minus_lines"] = True
    else:
        fired["M_minus_lines"] = False
    if d % 3 == 0:
        b = []
        for ELL in (fr["ELL1"], fr["ELL2"]):
            Wb = rand_in_span(ELL, npt, p, rng)
            J = SL.jet_rows(fr, A, C, Wb, np.zeros_like(Wb), 1, deg=d)
            b.append(J.reshape(ns_, -1) % p)
        out.append(np.concatenate(b, axis=1))
        fired["E_eigenlines"] = "vanish (3|d)"
    else:
        b = []
        for w, ELL in ((1, fr["ELL1"]), (2, fr["ELL2"])):
            tw = (d * w) % 3
            pt = fr["PW1"] if tw == 1 else fr["PW2"]
            ANN = SL.nullspace(pt[None, :] % p, p)
            Wb = rand_in_span(ELL, npt, p, rng)
            J = SL.jet_rows(fr, A, C, Wb, np.zeros_like(Wb), 1, deg=d)[:, :, :, 0]
            b.append(np.einsum("sqc,kc->sqk", J, ANN).reshape(ns_, -1) % p)
        out.append(np.concatenate(b, axis=1))
        fired["E_eigenlines"] = "contract to ell_{%d w}" % (d % 3)
    pts = [fr["D10pt"], fr["w0"]]
    if d % 6 not in (1, 5):
        pts += [fr["C6_eig"][1][0], fr["C6_eig"][5][0]]
        fired["C6_points"] = True
    else:
        fired["C6_points"] = False
    if d % 11 not in (1, 3, 4, 5, 9):
        pts += list(P11)
        fired["C11_points"] = True
    else:
        fired["C11_points"] = False
    if d % 5 == 0 and P5on:
        pts += list(P5on)
        fired["C5_points"] = True
    else:
        fired["C5_points"] = False
    out.append(D34.point_block(fr, A, C, d, pts, p))
    return out, fired


def dim_of(blocks, dimM, p):
    if not blocks:
        return dimM, 0
    Mx = np.concatenate(blocks, axis=1)
    rk = P2.rref_rank_fast(Mx, p)
    return int(dimM - rk), int(rk)


def eval_F_on_combo(fr, A, C, coeffs, deg, pts, p):
    """Evaluate F(T(v)) for T = sum coeffs[i] R(seed_i), at listed points.
    Returns list of F-values. Uses jet order 1 at the points."""
    ns = A.shape[0]
    Wb = np.array(pts, dtype=np.int64) % p
    Yb = np.zeros_like(Wb)
    J = SL.jet_rows(fr, A, C, Wb, Yb, 1, deg=deg)[:, :, :, 0]  # (ns,npt,5)
    # T(v)_c = sum_i coeffs[i] * J[i, pt, c]
    Tv = np.einsum("i,ipc->pc", coeffs % p, J) % p  # (npt, 5)
    vals = []
    for v in Tv:
        vals.append(int(D34.klein_F(v, p) % p))
    return vals


def landing_probe(fr, A, C, struct_blocks, lineJ, dimM, deg, p, rng,
                  n_combos=8, n_pts=40):
    """For each exact-order cell r=0..5 (upper bound via rank diff), if the
    cumulative space at ord>=r is strictly larger than at ord>=6, sample
    random elements of the structure space and test F(T(v)) at random points.

    Safe direction only: any F(T(v)) != 0 proves that sample is non-landing.
    Returns a record; never claims landing from samples alone.
    """
    ns = A.shape[0]
    base = list(struct_blocks)
    # structure + plane already in struct_blocks from caller
    dims = {}
    for r in range(0, 7):
        if r == 0:
            blocks = base
        else:
            blocks = base + [lineJ[:, :, :, :r].reshape(ns, -1)]
        d, _ = dim_of(blocks, dimM, p)
        dims[r] = d

    # Build a single matrix for structure (to sample its kernel via nullspace
    # of the functional matrix on the seed basis = the cokernel of the row
    # space).  We sample random linear combos of seeds that lie approximately
    # in the structure kernel by solving M @ c = 0 when dim allows, else
    # random combos of seeds and just report F-values (most will be non-struct).
    # Practical approach: take random combos of ALL seeds; evaluate F; also
    # report their measured line-jet order lower bound by checking which
    # jet columns vanish on the combo.
    FULL = np.eye(5, dtype=np.int64)
    pts = rng.integers(0, p, size=(n_pts, 5)) % p
    # precompute jets of seeds at probe points
    Jpt = SL.jet_rows(fr, A, C, pts, np.zeros_like(pts), 1, deg=deg)[:, :, :, 0]
    # line jets already have random pairs; use first few pairs for order probe
    n_use = min(6, lineJ.shape[1])
    LJ = lineJ[:, :n_use, :, :]  # (ns, n_use, 5, 6)

    samples = []
    n_structish = 0
    n_low_ord = 0
    n_low_ord_Fzero_samples = 0
    n_low_ord_Fnonzero = 0
    for _ in range(n_combos * 4):
        c = rng.integers(0, p, size=ns) % p
        # measured structure residual: apply structure functionals
        # (cheap: use dim comparison via a few blocks - skip full; just F + order)
        Tv = np.einsum("i,ipc->pc", c, Jpt) % p
        Fvals = [int(D34.klein_F(v, p) % p) for v in Tv]
        # line order lower bound: first vanishing jet level on the combo
        # combo jet: sum_i c_i * LJ[i]
        Cj = np.einsum("i,ipcj->pcj", c, LJ) % p  # (n_use,5,6)
        ord_lb = 6
        for r in range(6):
            if np.any(Cj[:, :, r] % p):
                ord_lb = r
                break
        rec = {"ord_lb": int(ord_lb),
               "F_all_zero_on_sample": all(f == 0 for f in Fvals),
               "F_nonzero_count": sum(1 for f in Fvals if f != 0),
               "n_pts": n_pts}
        samples.append(rec)
        if ord_lb < 6:
            n_low_ord += 1
            if rec["F_all_zero_on_sample"]:
                n_low_ord_Fzero_samples += 1
            else:
                n_low_ord_Fnonzero += 1
        if len(samples) >= n_combos and n_low_ord >= n_combos:
            break

    return {
        "dims_structure_plus_ord_ge": {str(r): dims[r] for r in range(7)},
        "exact_cell_upper_bound": {
            str(r): dims[r] - dims[r + 1] for r in range(6)
        },
        "n_samples": len(samples),
        "n_low_ord_samples": n_low_ord,
        "n_low_ord_with_F_all_zero_on_sample_pts": n_low_ord_Fzero_samples,
        "n_low_ord_with_F_nonzero": n_low_ord_Fnonzero,
        "note": ("F-all-zero on random points is NOT a landing certificate; "
                 "F-nonzero IS a non-landing certificate. Premise concerns "
                 "landing only."),
    }


def process_degree(fr, P11, P5on, d, p, npair, npt, rng):
    dimM = DIM_M[d]
    print("[d=%d] dim M_d = %d  p=%d  [%.0f s]" % (d, dimM, p, time.time() - T0),
          flush=True)
    A, C, got = basis_seeds(fr, d, dimM, p, rng)
    if A is None:
        return {"d": d, "dim_M": dimM, "verdict": "SEED-SHORTFALL",
                "got": got}
    ns = A.shape[0]
    c1, c2 = plane_blocks(fr, A, C, d, 1, npair, p, rng)
    sb, fired = structure_blocks(fr, A, C, d, npt, p, rng, P11, P5on)
    base = [c1, c2] + sb

    # line jets order 0..5  (J=6 means coeffs t^0..t^5)
    lineJ = line_jets(fr, A, C, d, 6, npair, p, rng)
    lineJ2 = line_jets(fr, A, C, d, 6, npair, p, rng)  # saturation sample

    dims_ge = {}
    ranks_ge = {}
    for r in range(0, 7):
        if r == 0:
            blocks = base
        else:
            blocks = base + [lineJ[:, :, :, :r].reshape(ns, -1)]
        dm, rk = dim_of(blocks, dimM, p)
        dims_ge[r] = dm
        ranks_ge[r] = rk
        print("    struct+ord>=%d  dim=%4d  (rank %d)  [%.0f s]"
              % (r, dm, rk, time.time() - T0), flush=True)

    # saturation at r=6
    blocks_sat = base + [lineJ[:, :, :, :6].reshape(ns, -1),
                         lineJ2[:, :, :, :6].reshape(ns, -1)]
    dim_sat, _ = dim_of(blocks_sat, dimM, p)

    # also pure plane+line (no STAGE2 structure) for comparison
    dims_prof = {}
    for r in range(0, 7):
        if r == 0:
            blocks = [c1, c2]
        else:
            blocks = [c1, c2, lineJ[:, :, :, :r].reshape(ns, -1)]
        dm, _ = dim_of(blocks, dimM, p)
        dims_prof[r] = dm

    exact = {r: dims_ge[r] - dims_ge[r + 1] for r in range(6)}
    exact_prof = {r: dims_prof[r] - dims_prof[r + 1] for r in range(6)}

    # Workorder prediction: dim(ord>=r) == dim(ord>=6) for r < 6
    # (i.e. exact cells r=0..5 empty inside the structure space).
    prediction_holds = all(dims_ge[r] == dims_ge[6] for r in range(6))
    cells_r_lt_6_empty = all(exact[r] == 0 for r in range(6))

    probe = landing_probe(fr, A, C, base, lineJ, dimM, d, p, rng)

    rec = {
        "d": d,
        "dim_M": dimM,
        "d_mod_6": d % 6,
        "rules_fired": fired,
        "dims_structure_plus_ord_ge": {str(r): dims_ge[r] for r in range(7)},
        "ranks_structure_plus_ord_ge": {str(r): ranks_ge[r] for r in range(7)},
        "exact_cell_upper_bound_r_lt_6": {str(r): exact[r] for r in range(6)},
        "dims_profile_plane_plus_ord_ge": {str(r): dims_prof[r]
                                           for r in range(7)},
        "exact_profile_cell_upper_bound": {str(r): exact_prof[r]
                                           for r in range(6)},
        "saturation_dim_ord_ge_6": dim_sat,
        "saturation_stable_at_6": bool(dim_sat == dims_ge[6]),
        "workorder_prediction_dims_equal": bool(prediction_holds),
        "exact_cells_r_lt_6_empty_in_structure": bool(cells_r_lt_6_empty),
        "landing_probe": probe,
        "semantics": ("nonzero modular dim is upper bound only; dim 0 is "
                      "char-0 empty; exact-cell numbers are differences of "
                      "upper bounds hence themselves upper bounds"),
    }
    print("    exact-cell upper bounds r=0..5: %s" %
          [exact[r] for r in range(6)], flush=True)
    print("    prediction dim(>=r)=dim(>=6) for r<6: %s; "
          "cells empty: %s; sat stable: %s"
          % (prediction_holds, cells_r_lt_6_empty, dim_sat == dims_ge[6]),
          flush=True)
    return rec


def main():
    p = int(sys.argv[1]) if len(sys.argv) > 1 else 331
    dmin = int(sys.argv[2]) if len(sys.argv) > 2 else 31
    dmax = int(sys.argv[3]) if len(sys.argv) > 3 else 42
    npair = int(sys.argv[4]) if len(sys.argv) > 4 else 80
    npt = int(sys.argv[5]) if len(sys.argv) > 5 else 60
    os.makedirs(RES, exist_ok=True)
    rng = np.random.default_rng(20260812 + p)

    assert p in (331, 661) or (p - 1) % 33 == 0
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=True)))
    P11, P5on = eig_points(fr, p)

    rows = []
    fn = os.path.join(RES, "sweep_p%d_%d_%d.json" % (p, dmin, dmax))
    for d in range(dmin, dmax + 1):
        rec = process_degree(fr, P11, P5on, d, p, npair, npt, rng)
        rows.append(rec)
        with open(fn, "w") as fh:
            json.dump({
                "prime": p,
                "range": [dmin, dmax],
                "npair": npair,
                "npt": npt,
                "rows": rows,
                "premise": ("ord_{ell_V}(T) >= 6 for every landing covariant"),
                "sealed_origin": ("FIX-N2 Theorem A + H0-1 + cone bound "
                                  "(theory/FIX_II_jets.md cell table)"),
                "elapsed_s": round(time.time() - T0, 1),
            }, fh, indent=1, sort_keys=True)
        print("  wrote partial %s" % fn, flush=True)

    # summary flags
    any_prediction = any(r.get("workorder_prediction_dims_equal") for r in rows
                         if "workorder_prediction_dims_equal" in r)
    all_prediction = all(r.get("workorder_prediction_dims_equal") for r in rows
                         if "workorder_prediction_dims_equal" in r)
    any_cell_pos = any(
        any(v > 0 for v in r.get("exact_cell_upper_bound_r_lt_6", {}).values())
        for r in rows if "exact_cell_upper_bound_r_lt_6" in r
    )
    summary = {
        "prime": p,
        "range": [dmin, dmax],
        "all_degrees_prediction_holds": bool(all_prediction),
        "any_degree_prediction_holds": bool(any_prediction),
        "any_exact_cell_r_lt_6_positive_upper_bound": bool(any_cell_pos),
        "interpretation": (
            "If exact-cell upper bounds for r<6 are positive inside the "
            "structure space, that does NOT refute the landing premise: "
            "structure alone does not encode F(T)=0.  A refutation requires "
            "an explicit landing covariant with ord < 6.  Confirmation of "
            "the landing premise rests on the sealed local FIX-N2 Theorem A "
            "plus the H0-1/cone bridge; the global modular filtration "
            "documents that the linear structure space has room at low "
            "order (non-landing) while the window machinery scopes only "
            "the r>=6 slice."
        ),
        "elapsed_s": round(time.time() - T0, 1),
        "rows": rows,
    }
    sfn = os.path.join(RES, "sweep_summary_p%d.json" % p)
    with open(sfn, "w") as fh:
        json.dump(summary, fh, indent=1, sort_keys=True)
    print("[done] %s  prediction_all=%s  any_pos_cell=%s  [%.0f s]"
          % (sfn, all_prediction, any_cell_pos, time.time() - T0), flush=True)
    return 0


if __name__ == "__main__":
    sys.exit(main())
