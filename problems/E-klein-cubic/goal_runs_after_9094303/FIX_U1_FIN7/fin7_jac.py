#!/usr/bin/env python3
"""FIX-U1-FIN7 -- the Jacobian of the 52 non-equivariant landing equations,
evaluated at a point of the 39-dimensional parameter space, over any ring.

The ring interface is a tiny duck-typed object with add/sub/mul/smul/zero/
is_zero/inv (see `exalg.Alg` for the exact number-field case and `Fp` below for
the modular case).

Also provides the exact rank routine (unit-pivot Gaussian elimination over a
field) and the torus tangent vectors E_x, E_y, E_z.
"""
import fin7_lib as L


class Fp(object):
    """the prime field F_p, in the same interface as exalg.Alg."""

    def __init__(self, p):
        self.p = p
        self.dim = 1
        self.name = 'F%d' % p

    def of_int(self, n):
        return n % self.p

    def zero(self):
        return 0

    def one(self):
        return 1 % self.p

    def add(self, a, b):
        return (a + b) % self.p

    def sub(self, a, b):
        return (a - b) % self.p

    def mul(self, a, b):
        return a*b % self.p

    def smul(self, c, a):
        return c*a % self.p

    def is_zero(self, a):
        return a % self.p == 0

    def inv(self, a):
        return pow(a, self.p - 2, self.p) if a % self.p else None


def jacobian(ring, vals, eqs=None, names=None):
    """52 x 39 Jacobian of the landing equations at the point `vals`.

    `vals[t]` are ring elements; the K-coefficients of the equations must
    already have been mapped into the ring by the caller (see `map_eqs`).
    """
    if eqs is None:
        names, eqs = L.landing_terms()
    n = len(vals)
    J = []
    for _mon, terms in eqs:
        row = [ring.zero()]*n
        for coef, (i, j, k) in terms:
            trip = (i, j, k)
            for pos in range(3):
                t = trip[pos]
                o1, o2 = trip[(pos + 1) % 3], trip[(pos + 2) % 3]
                c = ring.mul(coef, ring.mul(vals[o1], vals[o2]))
                row[t] = ring.add(row[t], c)
        J.append(row)
    return J


def evaluate(ring, vals, eqs):
    """the 52 equation values at the point (should all be zero)."""
    out = []
    for _mon, terms in eqs:
        s = ring.zero()
        for coef, (i, j, k) in terms:
            s = ring.add(s, ring.mul(coef,
                                     ring.mul(vals[i], ring.mul(vals[j],
                                                                vals[k]))))
        out.append(s)
    return out


def rank(ring, M):
    """exact rank by Gaussian elimination over a field (ring.inv must succeed
    on every nonzero pivot; a None inverse means the ring is not a field at
    that element and is reported by raising)."""
    A = [row[:] for row in M]
    nr, nc = len(A), len(A[0]) if A else 0
    piv = 0
    pivcols = []
    for col in range(nc):
        r = None
        for i in range(piv, nr):
            if not ring.is_zero(A[i][col]):
                r = i
                break
        if r is None:
            continue
        A[piv], A[r] = A[r], A[piv]
        iv = ring.inv(A[piv][col])
        if iv is None:
            raise ArithmeticError('zero divisor pivot in %s' % ring.name)
        A[piv] = [ring.mul(iv, e) for e in A[piv]]
        for i in range(nr):
            if i != piv and not ring.is_zero(A[i][col]):
                g = A[i][col]
                A[i] = [ring.sub(e, ring.mul(g, e2))
                        for e, e2 in zip(A[i], A[piv])]
        pivcols.append(col)
        piv += 1
        if piv == nr:
            break
    return piv, pivcols, A


def nullspace(ring, M, rk_info=None):
    """basis of the kernel of M over a field (columns = parameters)."""
    piv, pivcols, A = rk_info if rk_info else rank(ring, M)
    nc = len(M[0])
    free = [c for c in range(nc) if c not in pivcols]
    basis = []
    for f in free:
        v = [ring.zero()]*nc
        v[f] = ring.one()
        for i, c in enumerate(pivcols):
            v[c] = ring.sub(ring.zero(), A[i][f])
        basis.append(v)
    return basis


def torus_rows():
    """the three weight vectors (A, B, C) of the (C*)^3 reparametrisation."""
    _names, E = L.torus_vectors()
    return E
