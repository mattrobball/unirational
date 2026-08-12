"""Independent modular Weil frame for PSL(2,11) (from defining formulas).

Byte-level independent of slicelib.build_frame: same formulas, our linear algebra.
"""
import numpy as np
from linalg import inv_mod, nullspace, mat_inv, rref_rank


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
            val = (sg * (zp[(9 * j * l) % 11] - zp[(-9 * j * l) % 11]) %
                   p) * ((-gs) % p) % p * inv11 % p
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

    orders = []
    for A in RHO:
        o = 1
        B = A.copy()
        while not np.array_equal(B, I5):
            B = mm(B, A)
            o += 1
        orders.append(o)
    orders = np.array(orders)
    invol = [i for i in range(660) if orders[i] == 2]
    assert len(invol) == 55

    si = invol[0]
    sig = RHO[si]
    Wp = nullspace((sig - I5) % p, p)
    Wm = nullspace((sig + I5) % p, p)
    assert Wp.shape[0] == 3 and Wm.shape[0] == 2

    out = {
        "p": p, "RHO": RHO, "RHOI": RHOI, "S": S, "T": T,
        "sigma_index": si, "orders": orders,
        "Wplus": Wp, "Wminus": Wm,
    }
    if verbose:
        print("[audit-frame] p=%d |G|=660 invol=%d" % (p, len(invol)))
    return out
