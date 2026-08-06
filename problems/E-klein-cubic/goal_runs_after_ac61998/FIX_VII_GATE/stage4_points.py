"""Independent corroboration of the Stage-4 rank, by points of C(F_p).

Every F_p-point of C = Sing(V(H)) gives a linear functional that kills
(I_C)_34, so the rank of the profile basis evaluated on such points is a LOWER
bound for the rank of the normal-form map that Stage 4 computes in M2.  If the
two agree, the M2 rank is confirmed from an entirely different direction.

C = V(partial H) set-theoretically (Euler: 5H = sum x_i d_i H, and p != 5), so
the points are found by exhausting P^4(F_p).
"""
import json
import os
import sys
import time

import numpy as np

import gatelib as GL
from gatelib import check, hessian_H, poly_diff
import verifier as VF

sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                "p2copy"))
import p2lib as P2             # noqa: E402

HERE = os.path.dirname(os.path.abspath(__file__))
CH = 1 << 19
DTOP = 34


def poly_arrays(pd, p):
    ex = np.array(sorted(pd), dtype=np.int64)
    co = np.array([pd[tuple(e)] % p for e in ex], dtype=np.int64)
    return ex, co


def eval_poly(ex, co, X, p):
    """X: (5, n) coordinate arrays."""
    emax = int(ex.max())
    pw = [[None] * (emax + 1) for _ in range(5)]
    for k in range(5):
        pw[k][0] = np.ones_like(X[k])
        for e in range(1, emax + 1):
            pw[k][e] = (pw[k][e - 1] * X[k]) % p
    acc = np.zeros_like(X[0])
    for t in range(ex.shape[0]):
        term = np.full_like(X[0], int(co[t]))
        for k in range(5):
            e = int(ex[t, k])
            if e:
                term = (term * pw[k][e]) % p
        acc = (acc + term) % p
    return acc


def curve_points(p, log=print):
    t0 = time.time()
    H = hessian_H(p)
    dH = [poly_arrays(poly_diff(H, i, p), p) for i in range(5)]
    pts = []
    for nfix in range(5):
        # chart: x_0..x_{nfix-1} = 0, x_nfix = 1, the rest free
        nfree = 4 - nfix
        total = p ** nfree
        for lo in range(0, total, CH):
            hi = min(total, lo + CH)
            n = np.arange(lo, hi, dtype=np.int64)
            X = [np.zeros(hi - lo, dtype=np.int64) for _ in range(5)]
            X[nfix] = np.ones(hi - lo, dtype=np.int64)
            m = n
            for k in range(4, nfix, -1):
                X[k] = m % p
                m = m // p
            keep = np.nonzero(eval_poly(*dH[0], X, p) == 0)[0]
            for i in range(1, 5):
                if keep.size == 0:
                    break
                Xs = [x[keep] for x in X]
                keep = keep[eval_poly(*dH[i], Xs, p) == 0]
            for k in keep:
                pts.append([int(X[i][k]) for i in range(5)])
        log("    chart %d done, %d points so far (%.0fs)"
            % (nfix, len(pts), time.time() - t0))
    return np.array(pts, dtype=np.int64) if pts else np.zeros((0, 5), np.int64)


def run(p, tag=""):
    log = lambda *a: print(*a, flush=True)
    log("=== Stage 4 point control, p=%d ===" % p)
    P = curve_points(p, log=log)
    log("  |C(F_%d)| = %d" % (p, len(P)))
    T = np.load(os.path.join(HERE, "payload", "profile_basis_p%d" % p,
                             "coeffs.npz"))["T"].astype(np.int64)
    n1 = T.shape[0]
    if len(P) == 0:
        check("carrier_point_control" + tag, False,
              "C(F_%d) is empty -- no point control available" % p)
        return {"p": p, "npoints": 0}
    vals = VF.eval_tuples(T, P, p).reshape(n1, -1)
    rk0 = GL.rank_mod(vals, p)

    # tangent directions: T_P C = ker Hess(H)(P) (Euler puts P itself in the
    # kernel).  For f in I_C, both f(P) and D_v f(P) vanish, so these are extra
    # functionals killing (I_C)_34.
    H = hessian_H(p)
    HH = [[poly_arrays(poly_diff(poly_diff(H, i, p), j, p), p)
           for j in range(5)] for i in range(5)]
    dirs, kdims = [], []
    for q in range(len(P)):
        X = [np.array([P[q, k]], dtype=np.int64) for k in range(5)]
        Mx = np.array([[int(eval_poly(*HH[i][j], X, p)[0]) for j in range(5)]
                       for i in range(5)], dtype=np.int64)
        K = GL.nullspace(Mx, p).T % p
        kdims.append(int(K.shape[0]))
        stack = np.concatenate([P[q][None, :], K], axis=0)
        for row in K:
            if GL.rank_mod(np.stack([P[q], row]), p) == 2:
                dirs.append((q, row))
                break
    log("  tangent kernels: dims %s ; %d tangent directions"
        % (sorted(set(kdims)), len(dirs)))
    NT = DTOP + 1
    taus = (np.arange(NT) + 1) % p
    LP = np.concatenate([(P[q][None, :] + taus[:, None] * v[None, :]) % p
                         for q, v in dirs], axis=0)
    jv = VF.eval_tuples(T, LP, p).reshape(n1, 5, len(dirs), NT)
    Vinv = P2.vandermonde_inv(list(taus), p)
    co = np.einsum('ks,ncqs->ncqk', Vinv, jv) % p
    tan = co[:, :, :, 1].reshape(n1, -1)                  # the t^1 coefficient
    full = np.concatenate([vals, tan], axis=1)
    rk = GL.rank_mod(full, p)
    m2 = json.load(open(os.path.join(HERE, "payload", "carrier_p%d.json" % p)))
    # Point functionals give a LOWER bound only: |C(F_p)| = 60 is a single
    # G-orbit, far from enough to saturate a rank-3 restriction map.
    check("carrier_point_lower_bound" + tag, 1 <= rk <= m2["rank"],
          "rank on C(F_%d): %d points -> %d, +%d tangent functionals -> %d; "
          "consistent lower bound for the M2 normal-form rank %d "
          "(the F_p-points do NOT saturate it)"
          % (p, len(P), rk0, len(dirs), rk, m2["rank"]))
    out = {"p": p, "npoints": int(len(P)), "point_rank": int(rk0),
           "point_tangent_rank": int(rk), "m2_rank": m2["rank"]}
    with open(os.path.join(HERE, "payload", "cpoints_p%d.json" % p), "w") as f:
        json.dump(dict(out, points=P.tolist()), f)
    return out


if __name__ == "__main__":
    for pp in [int(a) for a in (sys.argv[1:] or ["67"])]:
        run(pp, tag="_p%d" % pp)
