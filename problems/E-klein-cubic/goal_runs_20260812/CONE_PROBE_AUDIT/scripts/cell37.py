"""Rebuild the sealed 37-cell from PAIR_ATTACK artefacts. Own nullspace."""
import json
import os

import numpy as np

import paths
from linalg import nullspace, rref_rank


def load_AC():
    a = np.load(os.path.join(paths.PAIR_RES, "layer0_A_p331.npy"))
    c = np.load(os.path.join(paths.PAIR_RES, "layer0_C_p331.npy"))
    assert a.shape == (paths.NSEED, 5)
    assert c.shape == (paths.NSEED,)
    assert set(a.sum(axis=1).tolist()) == {paths.DEG}
    return a, c


def cell37(p):
    nul = np.load(os.path.join(paths.PAIR_RES, "layer0_null_p%d.npy" % p)) % p
    we = json.load(open(os.path.join(paths.PAIR_RES, "worked_example_p%d.json" % p)))
    u6 = np.array(we["universal_matrix_6x39"], dtype=np.int64) % p
    assert nul.shape == (39, paths.NSEED)
    assert u6.shape == (6, 39)
    k37 = nullspace(u6, p) % p
    assert k37.shape[0] == paths.DIM37, ("cell not 37", k37.shape)
    b = (k37 @ nul) % p
    assert rref_rank(b, p) == paths.DIM37
    return {
        "p": p,
        "B37": b,
        "K37": k37,
        "U6": u6,
        "rank_U": int(rref_rank(u6, p)),
        "null_shape": list(nul.shape),
    }
