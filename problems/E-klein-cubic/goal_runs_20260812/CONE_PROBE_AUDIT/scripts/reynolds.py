"""Own Reynolds evaluation and chain-rule Jacobian. No slicelib, no jets library.

    R(s)(v) = sum_g  rho(g)^{-1}  s(rho(g) v)

for s = X^alpha e_{c0}. The factor 1/|G| is dropped (unit for p not dividing 660).

The Jacobian is the ordinary chain rule on each monomial, not a truncated
t-series engine.
"""
import numpy as np


def eval_at_points(frame, A, C, W, deg=35, batch=64):
    """R(s)(w) for every seed and every point. Shape (nseeds, npts, 5)."""
    p = frame["p"]
    RHO = frame["RHO"]
    RHOI = frame["RHOI"]
    ns = A.shape[0]
    npts = W.shape[0]
    out = np.zeros((ns, npts, 5), dtype=np.int64)
    for start in range(0, npts, batch):
        Wb = np.array(W[start:start + batch], dtype=np.int64) % p
        b = Wb.shape[0]
        # RHO[g] @ Wb[q] = sum_j RHO[g, i, j] * Wb[q, j]
        U = np.einsum("gij,qj->gqi", RHO, Wb) % p  # (660, b, 5)
        P = np.ones((ns, 660, b), dtype=np.int64)
        for j in range(5):
            u = U[:, :, j]
            cur = np.ones((660, b), dtype=np.int64)
            pows = [cur]
            for _e in range(1, deg + 1):
                cur = (cur * u) % p
                pows.append(cur)
            pows = np.stack(pows, axis=0)
            P = (P * pows[A[:, j]]) % p
        for c0 in range(5):
            idx = np.nonzero(C == c0)[0]
            if idx.size == 0:
                continue
            Mg = RHOI[:, :, c0] % p
            out[idx, start:start + b] = np.einsum("sgq,gc->sqc", P[idx], Mg) % p
    return out % p


def seed_jacobian_at(frame, A, C, w, deg=35):
    """Chain-rule Jacobian of every seed at one point.

    Returns J[s, c, j] = d R(s)_c / dx_j  evaluated at w.
    Shape (nseeds, 5, 5).
    """
    p = frame["p"]
    RHO = frame["RHO"]
    RHOI = frame["RHOI"]
    ns = A.shape[0]
    w = np.array(w, dtype=np.int64) % p
    u = (RHO @ w) % p  # (660, 5)

    pows = np.ones((5, deg + 1, 660), dtype=np.int64)
    for j in range(5):
        cur = np.ones(660, dtype=np.int64)
        pows[j, 0] = cur
        for _e in range(1, deg + 1):
            cur = (cur * u[:, j]) % p
            pows[j, _e] = cur

    J = np.zeros((ns, 5, 5), dtype=np.int64)
    for jdir in range(5):
        up = RHO[:, :, jdir] % p  # (660, 5)
        dP = np.zeros((ns, 660), dtype=np.int64)
        for k in range(5):
            ek = A[:, k]
            Q = np.ones((ns, 660), dtype=np.int64)
            for i in range(5):
                if i == k:
                    continue
                Q = (Q * pows[i, A[:, i]]) % p
            em = np.where(ek > 0, ek - 1, 0)
            dmon = (ek.astype(np.int64)[:, None] * pows[k, em]) % p
            dP = (dP + dmon * Q * up[None, :, k]) % p
        for c0 in range(5):
            idx = np.nonzero(C == c0)[0]
            if idx.size == 0:
                continue
            Mg = RHOI[:, :, c0] % p
            J[idx, :, jdir] = np.einsum("sg,gc->sc", dP[idx], Mg) % p
    return J % p


def covariant_value(frame, A, C, vec, w, deg=35):
    W = np.array([w], dtype=np.int64)
    V = eval_at_points(frame, A, C, W, deg=deg, batch=1)
    return (vec @ V[:, 0, :]) % frame["p"]


def covariant_jacobian(frame, A, C, vec, w, deg=35):
    Js = seed_jacobian_at(frame, A, C, w, deg=deg)
    return (np.tensordot(vec % frame["p"], Js, axes=(0, 0))) % frame["p"]
