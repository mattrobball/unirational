"""Stage 1: the explicit order-660 group G < SL5(F_p) preserving the Klein cubic.

Recipe fixed by the brief (= the FIX-VII-XRING corrected recipe):
    g11 = diag(z^1, z^9, z^4, z^3, z^5)
    s5  : x_i -> x_{i+1}   (cyclic shift preserving F)
    S   : M_{jk} = s_j s_k (z^{t b_j b_k} - z^{-t b_j b_k}),  b = (1,3,2,5,4),
          s = (1,1,-1,1,1), rescaled so that S^2 = I and det S = 1.
"""
import json
import os
import sys
from collections import Counter

import numpy as np

from gatelib import (F_eval, check, det_mod, mmul, nth_root_unity, nullspace,
                     matinv, sqrt_mod)

HERE = os.path.dirname(os.path.abspath(__file__))
EXP = (1, 9, 4, 3, 5)
BVEC = (1, 3, 2, 5, 4)
SIGNS = (1, 1, -1, 1, 1)
CLASS_PROFILE = {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120}


def preserves_F(M, p, V=None):
    if V is None:
        rng = np.random.default_rng(20260806)
        V = rng.integers(1, p, size=(12, 5)).astype(np.int64)
    lhs = F_eval((V @ np.asarray(M, dtype=np.int64).T) % p, p)
    rhs = F_eval(V, p)
    cs = set()
    for a, b in zip(lhs, rhs):
        if b == 0:
            continue
        cs.add(int(a) * pow(int(b), p - 2, p) % p)
    return len(cs) == 1, (cs.pop() if len(cs) == 1 else None)


def build_generators(p, log=print):
    zeta = nth_root_unity(11, p)
    Z = [pow(zeta, k % 11, p) for k in range(11)]
    g11 = np.diag([Z[e] for e in EXP]).astype(np.int64)
    s5 = np.zeros((5, 5), dtype=np.int64)
    for i in range(5):
        s5[i, (i + 1) % 5] = 1

    S, recipe = None, None
    for t in range(1, 6):
        K = np.array([[(Z[(t * bi * bj) % 11] - Z[(-t * bi * bj) % 11]) % p
                       for bj in BVEC] for bi in BVEC], dtype=np.int64)
        s = np.array(SIGNS, dtype=np.int64)
        M = (K * np.outer(s, s)) % p
        if det_mod(M, p) == 0:
            continue
        ok, c = preserves_F(M, p)
        if not ok:
            continue
        M2 = mmul(M, M, p)
        lam = int(M2[0, 0])
        if not np.array_equal(M2, (lam * np.eye(5, dtype=np.int64)) % p):
            continue
        r = sqrt_mod(lam, p)
        if r is None:
            continue
        Sn = (M * pow(r, p - 2, p)) % p
        neg = False
        if det_mod(Sn, p) != 1:
            Sn = (-Sn) % p
            neg = True
        if det_mod(Sn, p) != 1:
            continue
        S = Sn
        recipe = dict(b=list(BVEC), t=t, signs=list(SIGNS), scalar_c=int(c),
                      M2_scalar=lam, sqrt=int(r), negated=neg)
        break
    return dict(zeta=int(zeta), g11=g11, s5=s5, S=S, recipe=recipe)


def elt_order(M, p, cap=100):
    N = M.copy()
    I = np.eye(5, dtype=np.int64)
    for k in range(1, cap + 1):
        if np.array_equal(N, I):
            return k
        N = mmul(N, M, p)
    return None


def bfs_linear(gens, p, cap=5000):
    seen = {}
    start = np.eye(5, dtype=np.int64)
    seen[start.tobytes()] = start
    frontier = [start]
    while frontier:
        nxt = []
        for M in frontier:
            for g in gens:
                N = mmul(M, g, p)
                k = N.tobytes()
                if k not in seen:
                    seen[k] = N
                    nxt.append(N)
                    if len(seen) > cap:
                        return seen, False
        frontier = nxt
    return seen, True


def build_group(p, tag="", do_checks=True, log=print):
    B = build_generators(p, log=log)
    g11, s5, S = B["g11"], B["s5"], B["S"]
    assert S is not None, "no S found at p=%d with the fixed labeling" % p
    oks = [preserves_F(M, p)[0] for M in (g11, s5, S)]
    dets = [det_mod(M, p) for M in (g11, s5, S)]
    ords = [elt_order(M, p) for M in (g11, s5, S)]
    if do_checks:
        check("F_preserved" + tag, all(oks),
              "g11/s5/S=%s dets=%s orders=%s" % (oks, dets, ords))
    lin, done = bfs_linear([g11, s5, S], p)
    mats = list(lin.values())
    prof = dict(Counter(elt_order(M, p) for M in mats))
    if do_checks:
        check("closure_660" + tag, done and len(mats) == 660 and
              prof == CLASS_PROFILE,
              "|G|=%d profile=%s" % (len(mats), prof))
    RHO = np.array(mats, dtype=np.int64)
    return dict(p=p, zeta=B["zeta"], recipe=B["recipe"], g11=g11, s5=s5, S=S,
                RHO=RHO, order_profile=prof, closed=done)


def make_frame(p, tag="", do_checks=True, log=print):
    """A `slicelib`-shaped frame dict built from OUR generators, so that the
    FIX-P2 adapted-frame machinery can be applied verbatim."""
    G = build_group(p, tag=tag, do_checks=do_checks, log=log)
    RHO = G["RHO"]
    RHOI = np.array([matinv(A, p) for A in RHO], dtype=np.int64)
    I5 = np.eye(5, dtype=np.int64)
    orders = np.array([elt_order(A, p) for A in RHO])
    traces = np.array([int(np.trace(A)) % p for A in RHO])
    key = {A.tobytes(): i for i, A in enumerate(RHO)}

    invol = [i for i in range(660) if orders[i] == 2]
    assert len(invol) == 55
    si = invol[0]
    sig = RHO[si]
    Wp = nullspace((sig - I5) % p, p).T % p       # rows span the +1 eigenspace
    Wm = nullspace((sig + I5) % p, p).T % p
    assert Wp.shape[0] == 3 and Wm.shape[0] == 2, (Wp.shape, Wm.shape)

    LINE, tau_idx = None, None
    for tj in invol:
        if tj == si:
            continue
        tau = RHO[tj]
        if not np.array_equal(mmul(sig, tau, p), mmul(tau, sig, p)):
            continue
        M = np.concatenate([(sig - I5) % p, (tau - I5) % p], axis=0)
        fix = nullspace(M % p, p).T % p
        if fix.shape[0] == 2:
            LINE, tau_idx = fix, tj
            break
    assert LINE is not None
    tk = key[mmul(sig, RHO[tau_idx], p).tobytes()]
    v4 = [si, tau_idx, tk]
    fr = {"p": p, "RHO": RHO, "RHOI": RHOI, "sigma_index": si, "v4": v4,
          "Wplus": Wp, "Wminus": Wm, "LINE": LINE, "orders": orders,
          "traces": traces, "S": G["S"], "T": G["g11"]}
    fr["_G"] = G
    return fr


def run(p, tag=""):
    log = lambda *a: print(*a, flush=True)
    log("=== Stage 1, p=%d ===" % p)
    G = build_group(p, tag=tag, log=log)
    log("  recipe: %s" % json.dumps(G["recipe"]))
    log("  order profile: %s" % G["order_profile"])
    out = os.path.join(HERE, "payload", "G660_p%d.json" % p)
    with open(out, "w") as f:
        json.dump({"p": p, "zeta": G["zeta"], "recipe": G["recipe"],
                   "generators": {"g11": G["g11"].tolist(),
                                  "s5": G["s5"].tolist(),
                                  "S": G["S"].tolist()},
                   "order_profile": {str(k): v for k, v in
                                     G["order_profile"].items()},
                   "linear_order": int(G["RHO"].shape[0])}, f)
    log("  wrote %s" % out)
    return G


if __name__ == "__main__":
    for pp in [int(a) for a in (sys.argv[1:] or ["67", "199"])]:
        run(pp, tag="_p%d" % pp)
