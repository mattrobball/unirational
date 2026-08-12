"""Frames, rigidity, and cell helpers for CONE_VS_PATTERN.

Same constructions as PAIR_ATTACK director_worked_example and
DEPTH_TABLE_GENERAL keep_pass_22: attaching pairs, Reynolds jets,
transverse W^- rigidity, universal six-flip 37-cell.
"""
from __future__ import annotations

import itertools
import json
import os

import numpy as np

import paths
import slicelib as SL

PAIR_RES = paths.PAIR_RES
DEG = paths.DEG


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
        assert piv is not None, "singular"
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
        B = (ker[:, :B.shape[0]] @ B) % p
        keep = []
        for v in B:
            test = np.array(keep + [v], dtype=np.int64)
            if SL.rref_rank(test % p, p) == len(keep) + 1:
                keep.append(v % p)
        B = (np.array(keep, dtype=np.int64) if keep
             else np.zeros((0, 5), dtype=np.int64))
    return B % p


def build_v4_children(fr, p):
    """Six universal flip attaching pairs (director_worked_example)."""
    RHO, orders = fr["RHO"], fr["orders"]
    I5 = np.eye(5, dtype=np.int64)
    invs = [g for g in range(660) if orders[g] == 2]
    z = None
    for cand in invs:
        Z = RHO[cand] % p
        partners = [h for h in invs if h != cand and
                    np.array_equal((RHO[h] @ Z) % p, (Z @ RHO[h]) % p)]
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
        assert len(mate) == 1
        used.update({s, mate[0]})
        Ks.append((s, mate[0]))
    assert len(Ks) == 3
    Wplus = nullspace_rows((Z - I5) % p, p)
    children = []
    for (s, zs) in Ks:
        Sm = RHO[s] % p
        Bln = eig_split([Z, Sm], p, [1, -1])
        Cln = eig_split([Z, Sm], p, [-1, 1])
        Dln = eig_split([Z, Sm], p, [-1, -1])
        for (y, yperp, tag) in ((Cln[0], Dln[0], "C"), (Dln[0], Cln[0], "D")):
            children.append({
                "K": (z, s, zs), "w": Bln[0] % p, "y": y % p,
                "yperp": yperp % p, "tag": tag,
            })
    assert len(children) == 6
    return z, Z, Wplus, children


def vec5p(U, p):
    return np.array(U, dtype=np.int64).reshape(-1) % p


def lab_eq(a, b):
    if a is None or b is None:
        return False
    return json.dumps(a, sort_keys=True) == json.dumps(b, sort_keys=True)


def assign_from_embed(entry):
    out = {}
    for r, lab in entry["assign"]:
        out[int(r)] = lab
    return out


def load_seeds_and_cell(p):
    """Sealed 39-slice, universal six, 37-cell. Fatal if not rank 2 / dim 37."""
    A6 = np.load(os.path.join(PAIR_RES, "layer0_A_p331.npy"))
    C6 = np.load(os.path.join(PAIR_RES, "layer0_C_p331.npy"))
    NUL = np.load(os.path.join(PAIR_RES, "layer0_null_p%d.npy" % p)) % p
    assert A6.shape[0] == paths.NSEED and NUL.shape[0] == paths.DIM39
    fr = SL.build_frame(p, verbose=False)
    z, Z, Wplus, kids6 = build_v4_children(fr, p)
    Wmat = np.array([k["w"] for k in kids6], dtype=np.int64) % p
    Ymat = np.array([k["y"] for k in kids6], dtype=np.int64) % p
    JR = SL.jet_rows(fr, A6, C6, Wmat, Ymat, 2, deg=DEG)
    VAL = JR[:, :, :, 1] % p
    lam_amb = np.zeros((paths.NSEED, 6), dtype=np.int64)
    r1_bad = 0
    for j, kid in enumerate(kids6):
        Bmat = np.concatenate([kid["y"][None, :], kid["yperp"][None, :],
                               Wplus], axis=0) % p
        CINV = inv_mod(Bmat.T % p, p).T % p
        comp = (VAL[:, j, :] @ CINV) % p
        lam_amb[:, j] = comp[:, 0]
        r1_bad += int(np.count_nonzero(comp[:, 1] % p))
    assert r1_bad == 0, "universal rigidity failed: %d" % r1_bad
    LAM_SLICE = (NUL % p) @ (lam_amb % p) % p
    r6 = SL.rref_rank(LAM_SLICE.T % p, p)
    assert r6 == 2, "universal rank expected 2, got %d" % r6
    CELL37 = SL.nullspace(LAM_SLICE.T % p, p) % p
    assert CELL37.shape == (37, paths.DIM39)
    B37 = (CELL37 @ NUL) % p
    assert SL.rref_rank(B37, p) == 37
    return {
        "p": p, "fr": fr, "A6": A6, "C6": C6, "NUL": NUL,
        "CELL37": CELL37, "B37": B37, "LAM_SLICE": LAM_SLICE,
        "r6": int(r6), "r1_bad": int(r1_bad),
    }


def on37(cell, lam_amb):
    """Push a 637-vector functional to the 37-cell."""
    p = cell["p"]
    on39 = ((cell["NUL"] % p) @ (lam_amb % p)) % p
    return (cell["CELL37"] @ on39) % p


def lam3_row(lam37, p):
    """Coefficient row of (λ·c)^3 in combinations_with_replacement basis."""
    K = paths.DIM37
    mons = list(itertools.combinations_with_replacement(range(K), 3))
    row = np.zeros(len(mons), dtype=np.int64)
    lam = np.array(lam37, dtype=np.int64) % p
    for i, (u, v, w) in enumerate(mons):
        s = 0
        for a, b, c in set(itertools.permutations((u, v, w))):
            s += (int(lam[a]) * int(lam[b]) % p) * int(lam[c]) % p
        row[i] = s % p
    return row


def i3_reduce(vec, basis, pivots, p):
    v = np.array(vec, dtype=np.int64) % p
    for i, piv in enumerate(pivots):
        if v[piv]:
            v = (v - int(v[piv]) * basis[i]) % p
    return v


def i3_contains(vec, basis, pivots, p):
    return not bool(np.any(i3_reduce(vec, basis, pivots, p)))
