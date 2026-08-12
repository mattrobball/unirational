"""Load sealed Layer-0 seeds / nullspaces; six-flip 37-cell via own Reynolds."""
import os

import numpy as np

import paths
from frame import build_frame
from linalg import nullspace, rref_rank, mat_inv
from reynolds import eval_jet

PAIR_RES = paths.PAIR_RES
AUDIT_RES = paths.AUDIT_RES
RES = paths.RES
DEG = 35
DIM_M = 637


def load_seeds():
    A = np.load(os.path.join(PAIR_RES, "layer0_A_p331.npy"))
    C = np.load(os.path.join(PAIR_RES, "layer0_C_p331.npy"))
    assert A.shape == (DIM_M, 5) and C.shape == (DIM_M,)
    return A, C


def load_null(p):
    """Return (A, C, NUL) with NUL shape (39, 637) over F_p."""
    A, C = load_seeds()
    if p in (331, 661):
        NUL = np.load(os.path.join(PAIR_RES, "layer0_null_p%d.npy" % p)) % p
        assert NUL.shape == (39, DIM_M), NUL.shape
        return A, C, NUL
    cache = os.path.join(AUDIT_RES, "layer0_null_p%d.npy" % p)
    if os.path.exists(cache):
        NUL = np.load(cache) % p
        assert NUL.shape[1] == DIM_M
        return A, C, NUL
    raise FileNotFoundError(
        "no sealed null at p=%d (expected D35_AUDIT cache)" % p)


def eig_split(Ms, p, signs):
    I5 = np.eye(5, dtype=np.int64)
    B = I5.copy()
    for M, s in zip(Ms, signs):
        rows = nullspace((M - (s % p) * I5) % p, p)
        big = np.concatenate([B, (-rows) % p], axis=0)
        ker = nullspace(big.T % p, p)
        if ker.shape[0] == 0:
            return np.zeros((0, 5), dtype=np.int64)
        B = (ker[:, :B.shape[0]] @ B) % p
        keep = []
        for v in B:
            test = np.array(keep + [v], dtype=np.int64)
            if rref_rank(test % p, p) == len(keep) + 1:
                keep.append(v % p)
        B = np.array(keep, dtype=np.int64) if keep else np.zeros((0, 5),
                                                                 dtype=np.int64)
    return B % p


def build_v4_children(fr, p, pick=0):
    """Six attaching pairs of the three type-I-plus V4s through an involution."""
    RHO, orders = fr["RHO"], fr["orders"]
    I5 = np.eye(5, dtype=np.int64)
    invs = [g for g in range(660) if orders[g] == 2]
    candidates = []
    for cand in invs:
        Z = RHO[cand] % p
        partners = [h for h in invs if h != cand and
                    np.array_equal((RHO[h] @ Z) % p, (Z @ RHO[h]) % p)]
        if len(partners) >= 4:
            candidates.append((cand, partners))
    assert candidates, "no V4-rich involution"
    z, plist = candidates[pick % len(candidates)]
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
    Wplus = nullspace((Z - I5) % p, p)
    Wminus = nullspace((Z + I5) % p, p)
    children = []
    for (s, zs) in Ks:
        Sm = RHO[s] % p
        Bln = eig_split([Z, Sm], p, [1, -1])
        Cln = eig_split([Z, Sm], p, [-1, 1])
        Dln = eig_split([Z, Sm], p, [-1, -1])
        assert Bln.shape[0] == 1 and Cln.shape[0] == 1 and Dln.shape[0] == 1
        for (y, yperp, tag) in ((Cln[0], Dln[0], "C"), (Dln[0], Cln[0], "D")):
            children.append({
                "K": (z, s, zs), "w": Bln[0] % p, "y": y % p,
                "yperp": yperp % p, "tag": tag,
            })
    assert len(children) == 6
    return z, Z, Wplus, Wminus, children


def six_flip_cell37(fr, A, C, NUL, p, pick=0, deg=DEG):
    """Own-Reynolds six-flip cut → (LAM_SLICE, CELL37, meta)."""
    z, Z, Wplus, Wminus, kids6 = build_v4_children(fr, p, pick=pick)
    ns, nsl = A.shape[0], NUL.shape[0]
    Wmat = np.array([k["w"] for k in kids6], dtype=np.int64) % p
    Ymat = np.array([k["y"] for k in kids6], dtype=np.int64) % p
    JR = eval_jet(fr, A, C, Wmat, Ymat, 2, deg=deg)
    VAL = JR[:, :, :, 1] % p
    lam_amb = np.zeros((ns, 6), dtype=np.int64)
    r1_bad = 0
    for j, kid in enumerate(kids6):
        Bmat = np.concatenate([kid["y"][None, :], kid["yperp"][None, :],
                               Wplus], axis=0) % p
        CINV = mat_inv(Bmat.T % p, p).T % p
        comp = (VAL[:, j, :] @ CINV) % p
        lam_amb[:, j] = comp[:, 0]
        r1_bad += int(np.count_nonzero(comp[:, 1] % p))
    LAM_SLICE = (NUL % p) @ (lam_amb % p) % p
    r6 = rref_rank(LAM_SLICE.T % p, p)
    CELL37 = nullspace(LAM_SLICE.T % p, p) % p
    meta = {
        "p": p, "pick": pick, "z": int(z),
        "r1_rigidity": int(r1_bad),
        "slice_rank": int(r6),
        "cell37_shape": list(CELL37.shape),
        "dim_after": int(nsl - r6),
    }
    return LAM_SLICE, CELL37, meta


def our_frame(p):
    return build_frame(p, verbose=False)
