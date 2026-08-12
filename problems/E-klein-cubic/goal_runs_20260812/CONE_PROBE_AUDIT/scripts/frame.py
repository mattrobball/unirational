"""Weil representation of PSL(2,11) from the defining formulas. No slicelib."""
import numpy as np
from linalg import inv_mod, mat_inv


def klein_F(v, p):
    s = 0
    for i in range(5):
        s += int(v[i]) * int(v[i]) * int(v[(i + 1) % 5])
    return s % p


def build_frame(p, verbose=False):
    assert (p - 1) % 33 == 0, "need p = 1 mod 33"
    assert 660 % p != 0

    z11 = None
    for a in range(2, p):
        c = pow(a, (p - 1) // 11, p)
        if c != 1:
            z11 = c
            break
    assert z11 is not None and pow(z11, 11, p) == 1
    zp = [pow(z11, i % 11, p) for i in range(11)]
    qr = {1, 3, 4, 5, 9}
    gs = sum((1 if a in qr else -1) * zp[a] for a in range(1, 11)) % p
    assert (gs * gs) % p == (-11) % p

    js = [1, 3, 2, 5, 4]
    signs = [1, 1, -1, 1, 1]
    inv11 = inv_mod(11, p)
    S = np.zeros((5, 5), dtype=np.int64)
    for i, j in enumerate(js):
        for k, l in enumerate(js):
            sg = (signs[k] * signs[i]) % p
            val = (sg * (zp[(9 * j * l) % 11] - zp[(-9 * j * l) % 11]) % p)
            val = val * ((-gs) % p) % p * inv11 % p
            S[i, k] = val % p
    T = np.zeros((5, 5), dtype=np.int64)
    for i in range(5):
        T[i, i] = zp[(js[i] * js[i]) % 11]

    I5 = np.eye(5, dtype=np.int64)

    def mm(A, B):
        return (A @ B) % p

    def mpow(A, n):
        R = I5.copy()
        while n:
            if n & 1:
                R = mm(R, A)
            A = mm(A, A)
            n //= 2
        return R

    assert np.array_equal(mpow(S, 2), I5)
    assert np.array_equal(mpow(T, 11), I5)
    assert np.array_equal(mpow(mm(S, T), 3), I5)

    key = lambda A: A.tobytes()
    seen = {key(I5): 0}
    mats = [I5]
    frontier = [I5]
    while frontier:
        nxt = []
        for A in frontier:
            for gmat in (S, T):
                B = mm(A, gmat)
                k = key(B)
                if k not in seen:
                    seen[k] = len(mats)
                    mats.append(B)
                    nxt.append(B)
        frontier = nxt
    assert len(mats) == 660
    RHO = np.array(mats, dtype=np.int64)
    RHOI = np.array([mat_inv(A, p) for A in mats], dtype=np.int64)

    rng = np.random.default_rng(11)
    for _ in range(6):
        v = rng.integers(0, p, size=5)
        f0 = klein_F(v, p)
        for gi in range(0, 660, 37):
            w = (RHO[gi] @ v) % p
            assert klein_F(w, p) == f0

    if verbose:
        print("[frame] p=%d |G|=660 F-invariant" % p)
    return {"p": p, "RHO": RHO, "RHOI": RHOI, "S": S, "T": T}
