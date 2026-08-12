#!/usr/bin/env python3
"""Degree-general endgame instruments: finisher (line-order), six-flip, P3, sections.

Reuses D34_GUIDED_SWEEP (slicelib / p2lib / d34lib / produce_d34 / produce_ladder)
for the Layer-0 (1,6) cell. Instruments generalize PAIR_ATTACK_D35 and D35_LANDING.
"""
from __future__ import annotations

import itertools
import json
import os
import re
import subprocess
import time
from typing import Any

import numpy as np

import paths
import slicelib as SL
import p2lib as P2
import d34lib as D34
import produce_d34 as PD
import produce_ladder as PL
import produce_dims34 as DIMS

RES = paths.RES


# --------------------------------------------------------------------------- helpers
def inv_mod(M, p):
    n = M.shape[0]
    A = np.concatenate([M % p, np.eye(n, dtype=np.int64)], axis=1) % p
    r = 0
    for c in range(n):
        piv = None
        for i in range(r, n):
            if A[i, c] % p:
                piv = i
                break
        if piv is None:
            raise ValueError("singular")
        A[[r, piv]] = A[[piv, r]]
        A[r] = (A[r] * pow(int(A[r, c]), p - 2, p)) % p
        for i in range(n):
            if i != r and A[i, c] % p:
                A[i] = (A[i] - A[i, c] * A[r]) % p
        r += 1
    return A[:, n:] % p


def nullspace_rows(M, p):
    return SL.nullspace(np.array(M, dtype=np.int64) % p, p)


def eig_split(Ms, p, signs):
    I5 = np.eye(5, dtype=np.int64)
    B = I5.copy()
    for M, s in zip(Ms, signs):
        rows = nullspace_rows((M - (s % p) * I5) % p, p)
        big = np.concatenate([B, (-rows) % p], axis=0)
        ker = nullspace_rows(big.T % p, p)
        if ker.shape[0] == 0:
            return np.zeros((0, 5), dtype=np.int64)
        B = (ker[:, : B.shape[0]] @ B) % p
        keep = []
        for v in B:
            test = np.array(keep + [v], dtype=np.int64)
            if SL.rref_rank(test % p, p) == len(keep) + 1:
                keep.append(v % p)
        B = np.array(keep, dtype=np.int64) if keep else np.zeros((0, 5), dtype=np.int64)
    return B % p


def build_v4_children(fr, p):
    """Six attaching pairs over type-I points of three V4s through one involution."""
    RHO, orders = fr["RHO"], fr["orders"]
    I5 = np.eye(5, dtype=np.int64)
    invs = [g for g in range(660) if orders[g] == 2]
    z, plist = None, None
    for cand in invs:
        Z = RHO[cand] % p
        partners = [
            h
            for h in invs
            if h != cand and np.array_equal((RHO[h] @ Z) % p, (Z @ RHO[h]) % p)
        ]
        if len(partners) >= 4:
            z, plist = cand, partners
            break
    assert z is not None
    Z = RHO[z] % p
    Ks, used = [], set()
    for s in plist:
        if s in used:
            continue
        ZS = (Z @ RHO[s]) % p
        mate = [h for h in plist if np.array_equal(RHO[h] % p, ZS)]
        if len(mate) != 1:
            continue
        used.update({s, mate[0]})
        Ks.append((s, mate[0]))
    assert len(Ks) >= 3, len(Ks)
    Ks = Ks[:3]
    Wplus = nullspace_rows((Z - I5) % p, p)
    Wminus = nullspace_rows((Z + I5) % p, p)
    children = []
    for s, zs in Ks:
        Sm = RHO[s] % p
        Bln = eig_split([Z, Sm], p, [1, -1])
        Cln = eig_split([Z, Sm], p, [-1, 1])
        Dln = eig_split([Z, Sm], p, [-1, -1])
        assert Bln.shape[0] == 1 and Cln.shape[0] == 1 and Dln.shape[0] == 1
        for y, yperp, tag in ((Cln[0], Dln[0], "C"), (Dln[0], Cln[0], "D")):
            children.append(
                {
                    "K": (z, s, zs),
                    "w": Bln[0] % p,
                    "y": y % p,
                    "yperp": yperp % p,
                    "tag": tag,
                }
            )
    assert len(children) == 6
    return z, Z, Wplus, Wminus, children


def nmon3(K):
    return (K * (K + 1) * (K + 2)) // 6


def klein_F(v, p):
    s = 0
    for i in range(5):
        s = (s + int(v[i]) * int(v[i]) % p * int(v[(i + 1) % 5])) % p
    return s


def cubic_coeff_row(M5xK, p):
    """Coefficient vector of F(M c) in combinations_with_replacement monomials."""
    K = M5xK.shape[1]
    C3 = np.zeros((K, K, K), dtype=np.int64)
    for i in range(5):
        a = M5xK[i]
        b = M5xK[(i + 1) % 5]
        C3 = (C3 + np.einsum("u,v,w->uvw", a, a, b)) % p
    mons = list(itertools.combinations_with_replacement(range(K), 3))
    row = []
    for u, v, w in mons:
        perms = set(itertools.permutations((u, v, w)))
        row.append(sum(int(C3[q]) for q in perms) % p)
    return np.array(row, dtype=np.int64)


# --------------------------------------------------------------------------- cell builder
def build_layer0_cell(fr, d, dimM, p, rng, npair=100, npt=80):
    """Structure + (P)+(P+)+ord_ellV>=r0 cell. Returns dict with NUL (cell x ns)."""
    t0 = time.time()
    A, C, got = PD.basis_seeds(fr, d, dimM, p, rng)
    if A is None:
        return {"d": d, "p": p, "error": "seed shortfall %d/%d" % (got, dimM)}
    ns = A.shape[0]
    P11, P5on, P5off = PL.eig_points(fr, p)
    c1, c2 = PD.plane_blocks(fr, A, C, d, 1, npair, p, rng)
    sb, fired = PL.structure_blocks(fr, A, C, d, npt, p, rng, P11, P5on, P5off)
    blocks = [c1, c2] + [b for _, b in sb]
    # r0 always 6 in the window 31..42
    r0 = 6
    lb = PD.line_block(fr, A, C, d, r0, npair, p, rng)
    full = np.concatenate(blocks + [lb], axis=1) % p
    # full is (ns, nfunc); nullspace of full^T gives left-kernel rows x with x@full=0
    # slicelib.nullspace does right-null of matrix: rows of nullspace(M) are basis of {x: M x = 0}
    # We want {x in F^{ns} : x^T full = 0} i.e. full^T x = 0, so nullspace(full.T)
    NUL = SL.nullspace(full.T % p, p) % p  # (cell_dim, ns)
    cell_dim = int(NUL.shape[0])
    # also profile-only dim for anchor checks
    d_prof = int(dimM - P2.rref_rank_fast(np.concatenate([c1, c2, lb], axis=1), p))
    d_struct = int(dimM - P2.rref_rank_fast(np.concatenate(blocks, axis=1), p))
    d_full = int(dimM - P2.rref_rank_fast(full, p))
    assert d_full == cell_dim, (d_full, cell_dim)
    return {
        "d": d,
        "p": p,
        "dim_M": dimM,
        "cell_dim": cell_dim,
        "dim_profile_only": d_prof,
        "dim_structure_only": d_struct,
        "r0": r0,
        "rules_fired": fired,
        "A": A,
        "C": C,
        "NUL": NUL,
        "seconds": time.time() - t0,
    }


# --------------------------------------------------------------------------- finisher
def finisher_line_order(fr, A, C, NUL, d, p, npts=40):
    """Parity-forced minimal POSITIVE line-order instrument on the cell.

    ord ≡ d+1 (mod 2). At odd d the minimal positive option is ord>=2;
    at even d, ord>=1 is forced by STAGE2 (M) already, so test ord>=3.
    """
    if NUL.shape[0] == 0:
        return {
            "d": d,
            "p": p,
            "cell_dim": 0,
            "demanded_ord": None,
            "rank": 0,
            "dim_after": 0,
            "impossible": True,
            "note": "empty cell (control)",
        }
    ns, nsl = A.shape[0], NUL.shape[0]
    I5 = np.eye(5, dtype=np.int64)
    RHO, orders = fr["RHO"], fr["orders"]
    z = next(g for g in range(660) if orders[g] == 2)
    Z = RHO[z] % p
    Wm = nullspace_rows((Z + I5) % p, p)
    Wp = nullspace_rows((Z - I5) % p, p)
    assert Wm.shape[0] == 2 and Wp.shape[0] == 3

    # demanded order: odd d -> 2; even d -> 3
    if d % 2 == 1:
        demand = 2
    else:
        demand = 3

    rng = np.random.default_rng(20260812 + d + p)
    ab = rng.integers(1, p, size=(npts, 2))
    pts = (ab @ Wm) % p

    blocks = []
    # order >= 1: T(x)=0
    J1 = SL.jet_rows(fr, A, C, pts, np.zeros_like(pts), 1, deg=d)
    S1 = (NUL @ (J1.reshape(ns, -1) % p)) % p
    blocks.append(S1)
    ranks = {"ord1": int(SL.rref_rank(S1.T % p, p))}

    # higher jets: for ord >= k we need derivatives up to order k-1 along transverse dirs
    # jet_rows with J=demand, directional Y along each plus-direction
    if demand >= 2:
        for k in range(3):
            Y = np.tile(Wp[k][None, :], (npts, 1)) % p
            J2 = SL.jet_rows(fr, A, C, pts, Y, 2, deg=d)[:, :, :, 1]
            blocks.append((NUL @ (J2.reshape(ns, -1) % p)) % p)
        S2 = np.concatenate(blocks, axis=1) % p
        ranks["ord2"] = int(SL.rref_rank(S2.T % p, p))
    else:
        S2 = S1

    if demand >= 3:
        # second transverse derivatives: jet order 3, t^2 block along each plus dir
        for k in range(3):
            Y = np.tile(Wp[k][None, :], (npts, 1)) % p
            J3 = SL.jet_rows(fr, A, C, pts, Y, 3, deg=d)[:, :, :, 2]
            blocks.append((NUL @ (J3.reshape(ns, -1) % p)) % p)
        S3 = np.concatenate(blocks, axis=1) % p
        ranks["ord3"] = int(SL.rref_rank(S3.T % p, p))
        SALL = S3
    else:
        SALL = S2

    r_final = int(SL.rref_rank(SALL.T % p, p))
    dim_after = nsl - r_final
    impossible = r_final >= nsl  # rank full cell dim

    # saturation: extra points must not raise rank
    ab2 = rng.integers(1, p, size=(15, 2))
    pts2 = (ab2 @ Wm) % p
    J1b = SL.jet_rows(fr, A, C, pts2, np.zeros_like(pts2), 1, deg=d)
    S1b = (NUL @ (J1b.reshape(ns, -1) % p)) % p
    r_sat = int(SL.rref_rank(np.concatenate([SALL, S1b], axis=1).T % p, p))
    sat_ok = r_sat == r_final

    return {
        "d": d,
        "p": p,
        "cell_dim": nsl,
        "demanded_ord": demand,
        "parity_note": "ord ≡ d+1 (mod 2); test minimal POSITIVE option beyond forced base",
        "ranks": ranks,
        "rank": r_final,
        "dim_after": dim_after,
        "impossible": bool(impossible),
        "saturation_ok": bool(sat_ok),
        "npts": npts,
    }


# --------------------------------------------------------------------------- six-flip
def six_flip_rank(fr, A, C, NUL, d, p):
    """Universal six V4-child flip functionals on the cell. Odd d only.

    At odd d the level-0 value is the forbidden vertex (ODDZERO), so every
    coherent m=1 pattern must flip the six children: lambda_j(T)=0.
    """
    if d % 2 == 0:
        return {
            "d": d,
            "p": p,
            "skipped": True,
            "note": "even d: level-0 value is the demanded vertex; skip flip cut",
        }
    if NUL.shape[0] == 0:
        return {
            "d": d,
            "p": p,
            "skipped": False,
            "cell_dim": 0,
            "rank": 0,
            "dim_after": 0,
            "r1_bad": 0,
            "note": "empty cell",
        }

    ns, nsl = A.shape[0], NUL.shape[0]
    z, Z, Wplus, Wminus, kids6 = build_v4_children(fr, p)
    Wmat = np.array([k["w"] for k in kids6], dtype=np.int64) % p
    Ymat = np.array([k["y"] for k in kids6], dtype=np.int64) % p
    # bidegree-(d-1,1) leading datum: t^1 jet along w + t y
    JR = SL.jet_rows(fr, A, C, Wmat, Ymat, 2, deg=d)
    VAL = JR[:, :, :, 1] % p

    lam_amb = np.zeros((ns, 6), dtype=np.int64)
    r1_bad = 0
    for j, kid in enumerate(kids6):
        Bmat = np.concatenate(
            [kid["y"][None, :], kid["yperp"][None, :], Wplus], axis=0
        ) % p
        CINV = inv_mod(Bmat.T % p, p).T % p
        comp = (VAL[:, j, :] @ CINV) % p
        lam_amb[:, j] = comp[:, 0]
        r1_bad += int(np.count_nonzero(comp[:, 1] % p))

    LAM = (NUL @ lam_amb) % p  # (nsl, 6)
    r6 = int(SL.rref_rank(LAM.T % p, p))
    r_amb = int(SL.rref_rank(lam_amb.T % p, p))
    return {
        "d": d,
        "p": p,
        "skipped": False,
        "cell_dim": nsl,
        "z": int(z),
        "r1_bad": r1_bad,
        "ambient_rank": r_amb,
        "rank": r6,
        "dim_after": nsl - r6,
        "universal_matrix": LAM.tolist(),  # (nsl, 6) for optional combine
    }


def post_flip_null(NUL, flip_rec, p):
    """Nullspace of flip conditions inside the cell. Returns B (K x ns)."""
    if flip_rec.get("skipped") or NUL.shape[0] == 0:
        return NUL
    U = np.array(flip_rec["universal_matrix"], dtype=np.int64) % p  # (nsl, 6)
    # x @ U = 0  <=>  U.T @ x.T = 0; rows of nullspace(U.T) span such x.
    Kloc = SL.nullspace(U.T % p, p) % p  # (dim_after, nsl)
    if Kloc.shape[0] == 0:
        return np.zeros((0, NUL.shape[1]), dtype=np.int64)
    return (Kloc @ NUL) % p


# --------------------------------------------------------------------------- P3 plateau
class Echelon:
    def __init__(self, ncols, p):
        self.p = int(p)
        self.ncols = ncols
        self.basis = np.zeros((0, ncols), dtype=np.int64)
        self.pivots = []

    @property
    def rank(self):
        return len(self.pivots)

    def reduce(self, v):
        p = self.p
        v = np.array(v, dtype=np.int64, copy=True) % p
        for i, piv in enumerate(self.pivots):
            if v[piv]:
                v = (v - int(v[piv]) * self.basis[i]) % p
        return v

    def try_add(self, v):
        p = self.p
        v = self.reduce(v)
        nz = np.nonzero(v)[0]
        if not nz.size:
            return False
        piv = int(nz[0])
        v = (v * pow(int(v[piv]), p - 2, p)) % p
        if self.basis.shape[0]:
            col = self.basis[:, piv].copy()
            nz2 = np.nonzero(col)[0]
            if nz2.size:
                self.basis[nz2] = (self.basis[nz2] - np.outer(col[nz2], v)) % p
        self.basis = (
            np.vstack([self.basis, v]) if self.basis.shape[0] else v.reshape(1, -1)
        )
        self.pivots.append(piv)
        return True


def eval_cell_at_points(fr, A, C, Bcell, pts, d):
    """Bcell: (K, ns); returns (npts, 5, K)."""
    p = fr["p"]
    seeds = SL.jet_rows(fr, A, C, pts % p, np.zeros_like(pts), 1, deg=d)[:, :, :, 0] % p
    # seeds (ns, npts, 5); T = Bcell @ seeds
    T = np.einsum("js,sqc->jqc", Bcell, seeds) % p
    return np.transpose(T, (1, 2, 0)) % p


def p3_plateau(fr, A, C, Bcell, d, p, max_pts=4000, stable_window=250, sketch_cap=50000):
    """Saturate span of landing cubics on the cell. For huge cells use sketch LB."""
    K = Bcell.shape[0]
    if K == 0:
        return {
            "d": d,
            "p": p,
            "K": 0,
            "P3": 0,
            "N3": 0,
            "HF3": 0,
            "saturated": True,
            "mode": "empty",
        }
    N3 = nmon3(K)
    t0 = time.time()
    rng = np.random.default_rng(20260812 + 17 * d + p)

    # dense mode only when ambient fits memory budget
    if N3 > sketch_cap or K > 80:
        # For large cells: CountSketch lower bound on P3 (never claim saturation
        # as exact P3). Cap K for building the K^3 tensor of one cubic row.
        if K > 100:
            return {
                "d": d,
                "p": p,
                "K": K,
                "N3": N3,
                "P3": None,
                "P3_lower": None,
                "HF3": None,
                "saturated": False,
                "mode": "too_large",
                "note": "cell dim %d => N3=%d exceeds dense budget; P3 deferred"
                % (K, N3),
                "seconds": time.time() - t0,
            }

        s = min(12000, max(3000, 50 * K))
        ech = Echelon(s, p)
        n_tested = 0
        stable = 0
        sw = max(stable_window, 300)
        mp = max(max_pts, 3000)
        proj = rng.integers(0, p, size=(N3, s), dtype=np.int64)
        while n_tested < mp and stable < sw:
            b = 6
            pts = rng.integers(0, p, size=(b, 5), dtype=np.int64)
            for i in range(b):
                if not pts[i].any():
                    pts[i, 0] = 1
            Mall = eval_cell_at_points(fr, A, C, Bcell, pts, d)
            for q in range(b):
                if n_tested >= mp or stable >= sw:
                    break
                row = cubic_coeff_row(Mall[q], p)
                sk = (row @ proj) % p
                n_tested += 1
                if ech.try_add(sk):
                    stable = 0
                else:
                    stable += 1
                if n_tested % 100 == 0:
                    print(
                        "    P3-sketch d=%d p=%d n=%d rank=%d stable=%d"
                        % (d, p, n_tested, ech.rank, stable),
                        flush=True,
                    )
        return {
            "d": d,
            "p": p,
            "K": K,
            "N3": N3,
            "P3": None,
            "P3_lower": int(ech.rank),
            "HF3": None,
            "HF3_upper": N3 - int(ech.rank),
            "saturated": stable >= sw,
            "mode": "sketch",
            "sketch_dim": s,
            "npts_tested": n_tested,
            "seconds": time.time() - t0,
        }

    # dense exact mode (K small enough that N3 is manageable)
    ech = Echelon(N3, p)
    n_tested = 0
    stable = 0
    sw = max(stable_window, min(500, 80 + 2 * K))
    mp = max_pts if K <= 50 else max(max_pts, 3500)
    while n_tested < mp and stable < sw:
        b = 12
        pts = rng.integers(0, p, size=(b, 5), dtype=np.int64)
        for i in range(b):
            if not pts[i].any():
                pts[i, 0] = 1
        Mall = eval_cell_at_points(fr, A, C, Bcell, pts, d)
        for q in range(b):
            if n_tested >= mp or stable >= sw:
                break
            row = cubic_coeff_row(Mall[q], p)
            n_tested += 1
            if ech.try_add(row):
                stable = 0
            else:
                stable += 1
            if n_tested % 100 == 0:
                print(
                    "    P3 d=%d p=%d n=%d rank=%d stable=%d"
                    % (d, p, n_tested, ech.rank, stable),
                    flush=True,
                )
    P3 = int(ech.rank)
    return {
        "d": d,
        "p": p,
        "K": K,
        "N3": N3,
        "P3": P3,
        "HF3": N3 - P3,
        "saturated": stable >= sw,
        "mode": "dense",
        "npts_tested": n_tested,
        "stable_window": sw,
        "seconds": time.time() - t0,
    }


# --------------------------------------------------------------------------- sections
def section_battery(fr, A, C, Bcell, d, p, n_line=10, n_plane=10, timeout=45):
    """10 P1 + 10 P2 random sections; msolve origin-only verdict."""
    K = Bcell.shape[0]
    if K == 0:
        return {
            "d": d,
            "p": p,
            "K": 0,
            "P1": {"n": 0, "origin_only": 0, "nontriv": 0, "fail": 0},
            "P2": {"n": 0, "origin_only": 0, "nontriv": 0, "fail": 0},
            "note": "empty cell",
        }
    rng = np.random.default_rng(20260812 + 31 * d + p)
    out = {}
    for sec_dim, nsec, tag in ((1, n_line, "P1"), (2, n_plane, "P2")):
        nvars = sec_dim + 1
        mons3 = list(itertools.combinations_with_replacement(range(nvars), 3))
        n_oo = n_nt = n_fail = 0
        for sidx in range(nsec):
            B = rng.integers(0, p, size=(nvars, K), dtype=np.int64)
            if SL.rref_rank(B, p) < nvars:
                n_fail += 1
                continue
            npts = max(30, 4 * nvars * nvars)
            pts = rng.integers(0, p, size=(npts, 5), dtype=np.int64)
            for i in range(npts):
                if not pts[i].any():
                    pts[i, 0] = 1
            Mall = eval_cell_at_points(fr, A, C, Bcell, pts, d)
            polys = []
            for q in range(npts):
                Mr = (Mall[q] @ B.T) % p
                C3 = np.zeros((nvars,) * 3, dtype=np.int64)
                for i in range(5):
                    a, b = Mr[i], Mr[(i + 1) % 5]
                    C3 = (C3 + np.einsum("u,v,w->uvw", a, a, b)) % p
                terms = []
                for u, v, w in mons3:
                    perms = set(itertools.permutations((u, v, w)))
                    coef = sum(int(C3[t]) for t in perms) % p
                    if coef:
                        terms.append("%d*a%d*a%d*a%d" % (coef, u, v, w))
                if terms:
                    polys.append("+".join(terms))
            if len(polys) < nvars:
                n_fail += 1
                continue
            ms = os.path.join(RES, "_sec_d%d_p%d_s%d_%d.ms" % (d, p, sec_dim, sidx))
            mo = os.path.join(RES, "_sec_d%d_p%d_s%d_%d.out" % (d, p, sec_dim, sidx))
            header = ",".join("a%d" % i for i in range(nvars))
            open(ms, "w").write(header + "\n%d\n" % p + ",\n".join(polys) + "\n")
            origin_only = False
            try:
                subprocess.run(
                    ["msolve", "-t", "2", "-g", "2", "-f", ms, "-o", mo],
                    capture_output=True,
                    text=True,
                    timeout=timeout,
                )
                body = "".join(l for l in open(mo) if not l.startswith("#"))
                gens = sorted(set(map(int, re.findall(r"1\*a(\d+)\^1", body))))
                origin_only = gens == list(range(nvars))
            except Exception:
                n_fail += 1
                for f in (ms, mo):
                    if os.path.exists(f):
                        try:
                            os.remove(f)
                        except OSError:
                            pass
                continue
            if origin_only:
                n_oo += 1
            else:
                n_nt += 1
            for f in (ms, mo):
                if os.path.exists(f) and sidx > 1:
                    try:
                        os.remove(f)
                    except OSError:
                        pass
        out[tag] = {
            "n": nsec,
            "origin_only": n_oo,
            "nontriv": n_nt,
            "fail": n_fail,
            "verdict": (
                "origin_only"
                if n_oo == nsec and n_fail == 0
                else ("mixed" if n_nt else "partial")
            ),
        }
    out.update({"d": d, "p": p, "K": K})
    return out


def jsonable(obj: Any):
    if isinstance(obj, dict):
        return {k: jsonable(v) for k, v in obj.items() if k not in ("A", "C", "NUL")}
    if isinstance(obj, (list, tuple)):
        return [jsonable(x) for x in obj]
    if isinstance(obj, (np.integer,)):
        return int(obj)
    if isinstance(obj, (np.floating,)):
        return float(obj)
    if isinstance(obj, np.ndarray):
        return obj.tolist()
    if isinstance(obj, (bool, int, float, str)) or obj is None:
        return obj
    return str(obj)
