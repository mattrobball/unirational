#!/usr/bin/env python3
"""Stage 2: two-sided jet-window certification of dim im(mu).

Bound: for any set Phi of linear functionals on Inv_{3d} and any set C of
functionals vanishing on im(mu) (the plain-order conditions),

    im(mu) <= { f : C(f)=0, Phi(f) in Phi(im mu) }
    dim im(mu) <= I(3d) - rank([C | Phi] on Inv) + rank(Phi on im(mu)).

R_total = rank([C|Phi]) is lower-bounded on the product model V (mod p);
r_im = rank(Phi on im(mu)) is computed from sampled landing elements
(im(mu) spanned whp by ~2000 random landing cubics; sealed P3 gives the
exact dimension for the saturation check).

Certification: bound == P3(d) iff R_total - r_im == I(3d) - P3(d).

Extra families beyond stage 1: jet windows [base_order, hi) along each
locus, capturing anisotropic/shape structure as *relative* conditions.

Usage: python3 cond_rank2.py d p
"""
from __future__ import annotations

import json
import os
import sys
import time

import numpy as np

import common as CM
import slicelib as SL
import p2lib as P2
import d34lib as D34
import produce_ladder as PL
import instruments as INS
import cond_rank as C1


def landing_jets_at(fr, A, C, Bcell, cs, z0, vdir, J, d):
    """t-series (nc, J) of F(T_c(z0 + t v)) via the seed jet engine."""
    p = fr["p"]
    JR = SL.jet_rows(fr, A, C, np.asarray(z0, dtype=np.int64)[None, :],
                     np.asarray(vdir, dtype=np.int64)[None, :], J, deg=d)
    # (ns, 1, 5, J) -> cell contraction
    S = JR[:, 0, :, :] % p                      # (ns, 5, J)
    Tj = np.einsum("ks,scj->kcj", Bcell % p, S) % p   # (K, 5, J)
    U = np.einsum("nk,kcj->ncj", cs % p, Tj) % p      # (nc, 5, J)
    # F(u) = sum_i u_i^2 u_{i+1}, truncated convolutions
    nc = U.shape[0]
    out = np.zeros((nc, J), dtype=np.int64)
    for i in range(5):
        a = U[:, i, :]
        b = U[:, (i + 1) % 5, :]
        sq = np.zeros_like(a)
        for k in range(J):
            acc = (a[:, : k + 1] * a[:, k::-1]).sum(axis=1) % p
            sq[:, k] = acc
        cu = np.zeros_like(a)
        for k in range(J):
            acc = (sq[:, : k + 1] * b[:, k::-1]).sum(axis=1) % p
            cu[:, k] = acc
        out = (out + cu) % p
    return out % p


def main():
    d = int(sys.argv[1]) if len(sys.argv) > 1 else 35
    p = int(sys.argv[2]) if len(sys.argv) > 2 else 331
    D = 3 * d
    t00 = time.time()
    I_table = json.load(open(os.path.join(CM.RES, "molien_ext.json")))["I"]
    P3 = {35: 1380, 36: 1850, 37: 2642, 38: 3285}[d]
    target = I_table[D] - P3
    print("[stage2] d=%d p=%d I=%d P3=%d target R_total - r_im = %d"
          % (d, p, I_table[D], P3, target), flush=True)

    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=False), verbose=False), verbose=False)
    P11, P5on, P5off = PL.eig_points(fr, p)
    z, Z, Wplus, Wminus, kids6 = INS.build_v4_children(fr, p)
    gens = json.load(open(os.path.join(CM.RES, "generators_p331.json")))["generators"]
    rng = np.random.default_rng(20260812 + 20101 * d + p)

    A, Cc, Bcell = CM.load_cell(d, p)
    K = Bcell.shape[0]
    n_land = P3 + 650
    cs_land = rng.integers(0, p, size=(n_land, K), dtype=np.int64)

    # ---------- families: (name, kind, locus, jlo, jhi, npair)
    fams1 = C1.load_profile(d, fr, P11, P5on, kids6)
    base = {name: o for (name, kind, loc, o) in fams1}
    plan = []
    for (name, kind, loc, o) in fams1:
        if kind == "line" and name == "ellV":
            npair = 340
        elif kind == "line":
            npair = 40 + 18 * o
        elif kind == "plane":
            npair = 560
        else:
            npair = {1: 40, 2: 60, 3: 80, 4: 90, 6: 110, 12: 150, 21: 130}.get(o, 40 + 12 * o)
        plan.append((name, kind, loc, 0, o, npair, "C"))     # plain window [0, o)
    # extended windows (Phi): relative conditions
    ext = {
        "ellV": 3, "plusplane": 3, "minusline": 3,
        "eigenline1": 2, "eigenline2": 2,
        "D12pt": 3, "D10pt": 8, "V4w": 4, "C6a": 4, "C6b": 4,
        "C11": 10, "C5a": 5, "C5b": 5,
    }
    for (name, kind, loc, o) in fams1:
        w = ext.get(name, 2)
        if kind == "line" and name == "ellV":
            npair = 300
        elif kind == "plane":
            npair = 420
        elif kind == "line":
            npair = 120
        else:
            npair = 90
        plan.append((name + "+", kind, loc, o, o + w, npair, "Phi"))

    chains, pools, splits = C1.build_half_pools(gens, D, rng)
    per_split = 14400 // len(splits)
    row_plan = []
    for (a, b) in splits:
        na, nb = len(pools[a]), len(pools[b])
        ia = rng.integers(0, na, size=per_split)
        ib = rng.integers(0, nb, size=per_split)
        seen = set()
        ka, kb = [], []
        for x, y in zip(ia, ib):
            if (int(x), int(y)) in seen:
                continue
            seen.add((int(x), int(y)))
            ka.append(int(x))
            kb.append(int(y))
        row_plan.append(((a, b), np.array(ka), np.array(kb)))
    nrowsV = sum(len(x[1]) for x in row_plan)
    print("[rows] V-model rows = %d ; halves nodes = %d" % (nrowsV, len(chains)), flush=True)

    Vblocks, Lblocks, meta = [], [], []
    for (name, kind, loc, jlo, jhi, npair, role) in plan:
        t0 = time.time()
        w = jhi - jlo
        Vcols = np.zeros((nrowsV, npair * w), dtype=np.int16)
        Lcols = np.zeros((n_land, npair * w), dtype=np.int16)
        for q in range(npair):
            if kind == "point":
                z0 = loc
            else:
                co = rng.integers(1, p, size=loc.shape[0])
                z0 = (co @ loc) % p
            vdir = rng.integers(0, p, size=5, dtype=np.int64)
            gser = C1.gen_series_at(fr, gens, z0, vdir, jhi)
            H = C1.half_series(chains, gser, p)
            r0 = 0
            colblk = np.zeros((nrowsV, jhi), dtype=np.int64)
            for (ab, ia, ib) in row_plan:
                a, b = ab
                HA = H[np.array(pools[a])]
                HB = H[np.array(pools[b])]
                rows = C1.pair_rows_series(HA, HB, ia, ib, p)
                colblk[r0:r0 + ia.size] = rows
                r0 += ia.size
            Vcols[:, q * w:(q + 1) * w] = colblk[:, jlo:jhi].astype(np.int16)
            lj = landing_jets_at(fr, A, Cc, Bcell, cs_land, z0, vdir, jhi, d)
            Lcols[:, q * w:(q + 1) * w] = lj[:, jlo:jhi].astype(np.int16)
        Vblocks.append(Vcols)
        Lblocks.append(Lcols)
        nz = int(np.count_nonzero(Lcols))
        meta.append({"family": name, "kind": kind, "window": [jlo, jhi],
                     "npair": npair, "ncols": npair * w, "role": role,
                     "landing_nonzero_entries": nz,
                     "seconds": round(time.time() - t0, 1)})
        print("  [%s] %-12s win=[%d,%d) npair=%d ncols=%d landing_nz=%d (%.0fs)"
              % (role, name, jlo, jhi, npair, npair * w, nz, time.time() - t0), flush=True)

    # sanity: plain-condition columns must vanish on the landing span
    bad = [m["family"] for m, Lb in zip(meta, Lblocks)
           if m["role"] == "C" and np.count_nonzero(Lb)]
    print("[sanity] plain-condition families nonzero on landing:", bad or "none", flush=True)

    MV = np.concatenate(Vblocks, axis=1)
    ML = np.concatenate([Lb for m, Lb in zip(meta, Lblocks) if m["role"] == "Phi"], axis=1)
    print("[matrices] V: %s  landing-Phi: %s (%.0fs)" % (MV.shape, ML.shape, time.time() - t00), flush=True)

    hist = []
    R_total = C1.blocked_rank(MV, p, panel=128, verbose_tag="Rtot", history=hist)
    r_im = C1.blocked_rank(ML, p, panel=128, verbose_tag="rim")
    bound = I_table[D] - R_total + r_im
    verdict = ("CERTIFIED-MODP: dim im = P3 = %d (bound met)" % P3
               if bound <= P3 else
               "SHORT: bound %d > P3 %d (gap %d)" % (bound, P3, bound - P3))
    print("[result] R_total=%d r_im=%d bound=%d P3=%d" % (R_total, r_im, bound, P3), flush=True)
    print("[verdict]", verdict, flush=True)
    out = {"d": d, "p": p, "I_3d": I_table[D], "P3_sealed": P3,
           "R_total": int(R_total), "r_im": int(r_im), "bound_dim_im": int(bound),
           "families": meta, "n_rowsV": int(nrowsV), "n_landing_rows": int(n_land),
           "verdict": verdict, "seconds": round(time.time() - t00, 1)}
    json.dump(out, open(os.path.join(CM.RES, "cond_rank2_d%d_p%d.json" % (d, p)), "w"), indent=1)
    print("[write] cond_rank2_d%d_p%d.json total %.0fs" % (d, p, time.time() - t00))


if __name__ == "__main__":
    main()
