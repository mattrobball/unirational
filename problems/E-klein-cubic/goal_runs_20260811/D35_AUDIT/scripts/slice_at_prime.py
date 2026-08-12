"""Load sealed Layer-0 seeds and nullspace; build null at p=991 if needed.

At 331/661: use PAIR_ATTACK_D35 sealed artefacts.
At 991: recompute structure+(1,6)+A4 cuts on the sealed monomial seeds via
the D34 ladder builders (evaluation path for those cuts may use slicelib —
that only constructs the ambient slice; T1–T3 then re-evaluate with OUR
reynolds engine).
"""
import json
import os
import sys

import numpy as np

import paths
from frame import build_frame
from linalg import nullspace, rref_rank


PAIR_RES = paths.PAIR_RES
AUDIT_RES = paths.AUDIT_RES
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
    # p = 991 or other: try audit cache, else rebuild
    cache = os.path.join(AUDIT_RES, "layer0_null_p%d.npy" % p)
    if os.path.exists(cache):
        NUL = np.load(cache) % p
        assert NUL.shape[1] == DIM_M
        return A, C, NUL
    NUL = rebuild_null(p, A, C)
    os.makedirs(AUDIT_RES, exist_ok=True)
    np.save(cache, NUL)
    return A, C, NUL


def rebuild_null(p, A, C, npair=80, npt=60, rng_seed=20260811):
    """Replay sealed Layer-0 cuts at a new prime; return ker basis rows."""
    import slicelib as SL
    import p2lib as P2
    import d34lib as D34
    import produce_d34 as PD
    import produce_ladder as PL
    # import layer0 helpers from sealed packet
    sys.path.insert(0, paths.PAIR_SCR)
    from layer0_base import a4_mu2_block  # noqa: E402

    rng = np.random.default_rng(rng_seed)
    fr = D34.stage2_frame(P2.adapted_frame(SL.build_frame(p)), verbose=False)
    P11, P5on, P5off = PL.eig_points(fr, p)
    c1, c2 = PD.plane_blocks(fr, A, C, DEG, 1, npair, p, rng)
    sb, fired = PL.structure_blocks(fr, A, C, DEG, npt, p, rng, P11, P5on, P5off)
    lb = PD.line_block(fr, A, C, DEG, 6, npair, p, rng)
    a4b = a4_mu2_block(fr, A, C, DEG, p, njet=2, npair=max(30, npair // 2),
                       rng=rng)
    blocks = [c1, c2] + [b for _, b in sb] + [lb, a4b]
    Mfull = np.concatenate(blocks, axis=1) % p
    Phi = Mfull.T % p
    K = nullspace(Phi, p)
    d = int(K.shape[0])
    rec = {
        "prime": p, "nullspace_dim": d, "fired": fired,
        "rank_layer0": int(DIM_M - d),
        "note": "rebuilt in D35_AUDIT for third-prime audit",
    }
    with open(os.path.join(AUDIT_RES, "layer0_p%d.json" % p), "w") as f:
        json.dump(rec, f, indent=1)
    print("[slice] rebuilt null at p=%d dim=%d rules=%s" % (p, d, fired))
    if d != 39:
        print("[slice] WARNING: expected 39, got %d" % d)
    return K % p


def our_frame(p):
    return build_frame(p, verbose=False)
