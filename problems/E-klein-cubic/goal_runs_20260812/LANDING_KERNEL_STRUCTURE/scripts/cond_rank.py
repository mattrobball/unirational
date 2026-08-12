#!/usr/bin/env python3
"""Certify dim S(d) <= P3(d) by a jet-conditions rank computation over F_p.

S(d) := { f in Inv_{3d} : f vanishes to the MEASURED landing orders along
the sealed special-locus orbits (locus_orders_d{d}_p331.json) }.

Facts used:
  (i)  im(mu) subset S(d)      [locus_orders: every sampled landing cubic
                                has at least these orders; G-symmetry
                                extends single representatives to orbits]
  (ii) dim im(mu) = P3(d)      [sealed, two primes]
Therefore dim S(d) >= P3(d), and equality holds iff the jet conditions have
rank I(3d) - P3(d) on Inv_{3d}.

This script LOWER-bounds that rank: V = span of products u*v of random
invariant "halves" (monomials in the ten generators found by gen_hunt) with
deg u + deg v = 3d; the sampled jet functionals (t^j coefficients at
z0 + t v_dir, z0 on locus, j < order) are exact linear functionals that
vanish on S(d); rank of the (products x functionals) pairing matrix is a
lower bound for rank_{Inv}(conditions).  Achieving I(3d) - P3(d) certifies
dim S(d) = P3(d) mod p.

Also reports the point-evaluation rank of V (model-span diagnostic).

Usage: python3 cond_rank.py d p [nrows] [--skip-span]
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


# ---------------------------------------------------------------- profiles
def load_profile(d, fr, P11, P5on, kids6):
    ellV = fr["ellV"] if "ellV" in fr else fr["LINE"]
    prof = json.load(open(os.path.join(CM.RES, "locus_orders_d%d_p331.json" % d)))
    L = prof["loci"]

    def o(name):
        return int(L[name]["min_order"])

    fams = []
    fams.append(("ellV", "line", np.asarray(ellV), o("ellV (V4-line, ord>=6 cut)")))
    fams.append(("plusplane", "plane", np.asarray(fr["Wplus"]), o("plus-plane P_sigma")))
    om = o("minus-line L_sigma")
    if om > 0:
        fams.append(("minusline", "line", np.asarray(fr["Wminus"]), om))
    oe = o("C3-eigenline ELL1")
    if oe > 0:
        fams.append(("eigenline1", "line", np.asarray(fr["ELL1"]), oe))
    oe2 = o("C3-eigenline ELL2")
    if oe2 > 0:
        fams.append(("eigenline2", "line", np.asarray(fr["ELL2"]), oe2))
    pts = [
        ("D12pt", np.asarray(fr["w0"]), o("D12-point c_sigma")),
        ("D10pt", np.asarray(fr["D10pt"]), o("D10-point")),
        ("V4w", np.asarray(kids6[0]["w"]), o("V4-child w (flip point)")),
        ("C6a", np.asarray(fr["C6_eig"][1][0]), o("X^{C6} point w=1")),
        ("C6b", np.asarray(fr["C6_eig"][5][0]), o("X^{C6} point w=5")),
        ("C11", np.asarray(P11[0]), o("C11 eigenpoint")),
    ]
    if P5on:
        oc5 = o("exact-C5 point (on X)")
        pts.append(("C5a", np.asarray(P5on[0]), oc5))
        pts.append(("C5b", np.asarray(P5on[1]), oc5))
    for nm, pt, op in pts:
        if op > 0:
            fams.append((nm, "point", pt, op))
    return fams


# ---------------------------------------------------------------- fast rank
def blocked_rank(M, p, panel=128, verbose_tag="", history=None):
    """Exact rank mod p, float64 panels + dgemm trailing updates.
    history: optional list; appends (cols_processed, rank)."""
    A = np.ascontiguousarray(M.astype(np.float64) % p)
    rows, cols = A.shape
    assert panel * (p - 1) ** 2 < 2 ** 53
    r = 0
    t0 = time.time()
    for c0 in range(0, cols, panel):
        c1 = min(c0 + panel, cols)
        if r >= rows:
            if history is not None:
                history.append((c1, r))
            continue
        Pan = A[:, c0:c1] % p
        w = c1 - c0
        Mult = np.zeros((rows, w), dtype=np.float64)
        piv = []  # (row, inv)
        rr = r
        for j in range(w):
            col = Pan[rr:, j] % p
            nz = np.nonzero(col)[0]
            if nz.size == 0:
                Pan[rr:, j] = col
                continue
            i = rr + int(nz[0])
            if i != rr:
                Pan[[rr, i]] = Pan[[i, rr]]
                A[[rr, i]] = A[[i, rr]]
                Mult[[rr, i]] = Mult[[i, rr]]
            inv = pow(int(Pan[rr, j]) % p, p - 2, p)
            Pan[rr, :] = (Pan[rr, :] * inv) % p
            colv = Pan[rr + 1:, j] % p
            nzb = np.nonzero(colv)[0]
            Mult[rr + 1 + nzb, len(piv)] = colv[nzb]
            if nzb.size:
                Pan[rr + 1 + nzb, :] = (Pan[rr + 1 + nzb, :] - np.outer(colv[nzb], Pan[rr, :])) % p
            piv.append((rr, inv))
            rr += 1
            if rr == rows:
                break
        k = len(piv)
        if k and c1 < cols:
            U = np.zeros((k, cols - c1), dtype=np.float64)
            for t in range(k):
                rt, inv_ = piv[t]
                row = A[rt, c1:] % p
                if t:
                    row = (row - Mult[rt, :t] @ U[:t]) % p
                row = (row * inv_) % p
                U[t] = row
                A[rt, c1:] = row
            mask = np.ones(rows, dtype=bool)
            mask[: r] = False
            for (pr_, _) in piv:
                mask[pr_] = False
            idx = np.nonzero(mask)[0]
            if idx.size:
                step = max(1, int(6e7 // max(1, U.shape[1])))
                for s0 in range(0, idx.size, step):
                    sl = idx[s0:s0 + step]
                    A[sl, c1:] = (A[sl, c1:] - Mult[sl, :k] @ U) % p
        A[:, c0:c1] = Pan
        r = rr
        if history is not None:
            history.append((c1, r))
        if verbose_tag and (c0 // panel) % 8 == 0:
            print("  [%s] cols<=%d rank=%d (%.0fs)" % (verbose_tag, c1, r, time.time() - t0), flush=True)
    return r


# ------------------------------------------------------- series machinery
def gen_series_at(fr, gens, z0, vdir, J):
    """t-series (order J) of each generator at z0 + t*vdir -> (ngen, J) int64."""
    p = fr["p"]
    RHO = fr["RHO"]
    u = (RHO @ (np.asarray(z0, dtype=np.int64) % p)) % p
    up = (RHO @ (np.asarray(vdir, dtype=np.int64) % p)) % p
    maxdeg = max(g["deg"] for g in gens)
    POW = []
    for j in range(5):
        base = np.zeros((660, J), dtype=np.int64)
        base[:, 0] = u[:, j]
        if J > 1:
            base[:, 1] = up[:, j]
        cur = np.zeros((660, J), dtype=np.int64)
        cur[:, 0] = 1
        lst = [cur]
        for m in range(1, maxdeg + 1):
            nxt = np.zeros_like(cur)
            for i in range(J):
                if i:
                    nxt[:, i:] = (nxt[:, i:] + cur[:, i][:, None] * base[:, : J - i]) % p
                else:
                    nxt = (nxt + cur[:, 0][:, None] * base) % p
            cur = nxt % p
            lst.append(cur)
        POW.append(lst)
    out = np.zeros((len(gens), J), dtype=np.int64)
    for gi, g in enumerate(gens):
        e = g["expo"]
        P = POW[0][e[0]]
        for j in range(1, 5):
            if e[j]:
                b = POW[j][e[j]]
                nxt = np.zeros_like(P)
                for i in range(J):
                    if i:
                        nxt[:, i:] = (nxt[:, i:] + P[:, i][:, None] * b[:, : J - i]) % p
                    else:
                        nxt = (nxt + P[:, 0][:, None] * b) % p
                P = nxt % p
        out[gi] = P.sum(axis=0) % p
    return out


def half_series(halves, gser, p):
    """Series of each half monomial (list of parent chains).  halves is a
    list of (parent_index, gen_index); returns (nhalf, J)."""
    J = gser.shape[1]
    out = np.zeros((len(halves), J), dtype=np.int64)
    for i, (par, gi) in enumerate(halves):
        b = gser[gi]
        if par < 0:
            out[i] = b
            continue
        a = out[par]
        acc = np.zeros(J, dtype=np.int64)
        for k in range(J):
            if a[k]:
                acc[k:] = (acc[k:] + int(a[k]) * b[: J - k]) % p
        out[i] = acc
    return out


def pair_rows_series(HA, HB, ia, ib, p):
    """Series of products A[ia[r]]*B[ib[r]] -> (nrows, J)."""
    J = HA.shape[1]
    out = np.zeros((ia.size, J), dtype=np.int64)
    A = HA[ia]  # (n, J)
    B = HB[ib]
    for k in range(J):
        acc = np.zeros(ia.size, dtype=np.int64)
        for i in range(k + 1):
            acc = (acc + A[:, i] * B[:, k - i]) % p
        out[:, k] = acc
    return out


# ------------------------------------------------------- half-pool builder
def build_half_pools(gens, D, rng, nper=520, nsplits=6):
    """Random monomial 'halves' of degrees pairing to D.  Returns
    (chains, pools) where chains is the DP list [(parent, gen)], and pools
    maps degree -> list of node indices."""
    gdegs = [g["deg"] for g in gens]
    ngen = len(gens)
    hA = D // 2
    splits = []
    for s in range(nsplits):
        a = hA - s
        b = D - a
        splits.append((a, b))
    degrees_needed = sorted({x for ab in splits for x in ab})
    chains = []
    pools = {h: [] for h in degrees_needed}
    memo = {}

    def add_monomial(expo):
        """Add monomial and its parent chain; return node index."""
        key = tuple(expo)
        if key in memo:
            return memo[key]
        tot = sum(e * g for e, g in zip(expo, gdegs))
        i0 = next((j for j in range(ngen) if expo[j] > 0), None)
        assert i0 is not None
        par = list(expo)
        par[i0] -= 1
        ptot = tot - gdegs[i0]
        if ptot == 0:
            idx = len(chains)
            chains.append((-1, i0))
        else:
            pidx = add_monomial(par)
            idx = len(chains)
            chains.append((pidx, i0))
        memo[key] = idx
        return idx

    def random_expo(h):
        """Random exponent vector of weighted degree exactly h (rejection walk)."""
        for _ in range(4000):
            expo = [0] * ngen
            rem = h
            while rem > 0:
                cand = [j for j in range(ngen) if gdegs[j] <= rem]
                if not cand:
                    break
                j = int(rng.choice(cand))
                expo[j] += 1
                rem -= gdegs[j]
            if rem == 0:
                return expo
        raise RuntimeError("cannot hit degree %d" % h)

    for h in degrees_needed:
        seen = set()
        tries = 0
        while len(pools[h]) < nper and tries < 60 * nper:
            expo = tuple(random_expo(h))
            tries += 1
            if expo in seen:
                continue
            seen.add(expo)
            pools[h].append(add_monomial(list(expo)))
    return chains, pools, splits


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    d = int(args[0]) if args else 35
    p = int(args[1]) if len(args) > 1 else 331
    nrows = int(args[2]) if len(args) > 2 else 14400
    skip_span = "--skip-span" in sys.argv
    D = 3 * d
    t00 = time.time()
    I_table = json.load(open(os.path.join(CM.RES, "molien_ext.json")))["I"]
    P3 = {35: 1380, 36: 1850, 37: 2642, 38: 3285}[d]
    target = I_table[D] - P3
    print("[cond_rank] d=%d p=%d I(%d)=%d P3=%d target=%d" % (d, p, D, I_table[D], P3, target), flush=True)

    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p, verbose=False), verbose=False), verbose=False)
    P11, P5on, P5off = PL.eig_points(fr, p)
    z, Z, Wplus, Wminus, kids6 = INS.build_v4_children(fr, p)
    gens = json.load(open(os.path.join(CM.RES, "generators_p331.json")))["generators"]
    rng = np.random.default_rng(20260812 + 101 * d + p)

    fams = load_profile(d, fr, P11, P5on, kids6)
    print("[families]", [(n, k, o) for (n, k, _, o) in fams], flush=True)

    chains, pools, splits = build_half_pools(gens, D, rng)
    print("[halves] %d chain nodes; splits %s" % (len(chains), splits), flush=True)

    # fixed row plan: nrows rows split across the degree splits
    per_split = nrows // len(splits)
    row_plan = []
    for (a, b) in splits:
        na, nb = len(pools[a]), len(pools[b])
        ia = rng.integers(0, na, size=per_split)
        ib = rng.integers(0, nb, size=per_split)
        # dedupe pairs
        seen = set()
        keep_a, keep_b = [], []
        for x, y in zip(ia, ib):
            if (int(x), int(y)) in seen:
                continue
            seen.add((int(x), int(y)))
            keep_a.append(int(x))
            keep_b.append(int(y))
        row_plan.append(((a, b), np.array(keep_a), np.array(keep_b)))
    nrows_actual = sum(len(x[1]) for x in row_plan)
    print("[rows] %d product rows" % nrows_actual, flush=True)

    # condition sampling plan
    plan = []
    for (name, kind, locus, order) in fams:
        if kind == "line":
            npair = 60 if order <= 2 else (30 + 16 * order)
        elif kind == "plane":
            npair = 520
        else:
            raw = {1: 40, 2: 60, 3: 80, 4: 90, 6: 110, 12: 150, 21: 130}.get(order, 40 + 12 * order)
            npair = raw
        plan.append((name, kind, locus, order, npair))

    blocks = []
    meta = []
    for (name, kind, locus, order, npair) in plan:
        t0 = time.time()
        cols = np.zeros((nrows_actual, npair * order), dtype=np.int16)
        for q in range(npair):
            if kind == "point":
                z0 = locus
            else:
                co = rng.integers(1, p, size=locus.shape[0])
                z0 = (co @ locus) % p
            vdir = rng.integers(0, p, size=5, dtype=np.int64)
            gser = gen_series_at(fr, gens, z0, vdir, order)
            H = half_series(chains, gser, p)
            r0 = 0
            colblk = np.zeros((nrows_actual, order), dtype=np.int64)
            for (ab, ia, ib) in row_plan:
                a, b = ab
                HA = H[np.array(pools[a])]
                HB = H[np.array(pools[b])]
                rows = pair_rows_series(HA, HB, ia, ib, p)
                colblk[r0:r0 + ia.size] = rows
                r0 += ia.size
            cols[:, q * order:(q + 1) * order] = colblk.astype(np.int16)
        blocks.append(cols)
        meta.append({"family": name, "kind": kind, "order": order,
                     "npair": npair, "ncols": npair * order,
                     "seconds": round(time.time() - t0, 1)})
        print("  [cols] %-11s ord=%2d npair=%3d ncols=%5d (%.0fs)"
              % (name, order, npair, npair * order, time.time() - t0), flush=True)

    M = np.concatenate(blocks, axis=1)
    print("[matrix] %s built (%.0fs)" % (M.shape, time.time() - t00), flush=True)

    hist = []
    rank = blocked_rank(M, p, panel=128, verbose_tag="elim", history=hist)
    # map family boundaries to history
    bounds = np.cumsum([b["ncols"] for b in meta])
    fam_ranks = []
    for bi, b in enumerate(meta):
        cend = bounds[bi]
        rk = max(rk_ for (ce, rk_) in hist if ce <= cend) if any(ce <= cend for ce, _ in hist) else 0
        fam_ranks.append({"through": b["family"], "cum_cols": int(cend), "cum_rank_le": int(rk)})
    print("[rank] total = %d (target %d)" % (rank, target), flush=True)

    span_rank = None
    if not skip_span:
        # model-span diagnostic: point evaluations
        npts = min(I_table[D] + 500, 12000)
        pts = rng.integers(0, p, size=(npts, 5), dtype=np.int64)
        RHO = fr["RHO"]
        pts_g = np.einsum("gij,qj->qgi", RHO, pts) % p
        gvals = np.zeros((len(gens), npts), dtype=np.int64)
        for gi, g in enumerate(gens):
            val = np.ones((npts, 660), dtype=np.int64)
            for j in range(5):
                e = g["expo"][j]
                if e:
                    base = pts_g[:, :, j] % p
                    r_ = np.ones_like(base)
                    bb, ee = base, e
                    while ee:
                        if ee & 1:
                            r_ = (r_ * bb) % p
                        bb = (bb * bb) % p
                        ee >>= 1
                    val = (val * r_) % p
            gvals[gi] = val.sum(axis=1) % p
        hvals = np.zeros((len(chains), npts), dtype=np.int64)
        for i, (par, gi) in enumerate(chains):
            hvals[i] = gvals[gi] if par < 0 else (hvals[par] * gvals[gi]) % p
        PE = np.zeros((nrows_actual, npts), dtype=np.int16)
        r0 = 0
        for (ab, ia, ib) in row_plan:
            a, b = ab
            HA = hvals[np.array(pools[a])]
            HB = hvals[np.array(pools[b])]
            PE[r0:r0 + ia.size] = ((HA[ia] * HB[ib]) % p).astype(np.int16)
            r0 += ia.size
        span_rank = blocked_rank(PE, p, panel=128, verbose_tag="span")
        print("[span] model point-eval rank = %d (I(%d) = %d)" % (span_rank, D, I_table[D]), flush=True)

    verdict = ("CERTIFIED-MODP: rank == target; dim S(d) = P3(d) = %d" % P3
               if rank >= target else
               "SHORT: rank %d < target %d; dim S <= %d, gap %d"
               % (rank, target, I_table[D] - rank, target - rank))
    if rank > target:
        verdict = ("CONTRADICTION: rank %d > target %d — a condition fails on im(mu); recheck orders"
                   % (rank, target))
    print("[verdict]", verdict, flush=True)
    out = {"d": d, "p": p, "I_3d": I_table[D], "P3_sealed": P3, "target_rank": target,
           "families": meta, "family_rank_history": fam_ranks,
           "total_rank": int(rank), "model_span_rank": span_rank,
           "n_product_rows": int(nrows_actual), "verdict": verdict,
           "seconds": round(time.time() - t00, 1)}
    json.dump(out, open(os.path.join(CM.RES, "cond_rank_d%d_p%d.json" % (d, p)), "w"), indent=1)
    print("[write] cond_rank_d%d_p%d.json total %.0fs" % (d, p, time.time() - t00))


if __name__ == "__main__":
    main()
