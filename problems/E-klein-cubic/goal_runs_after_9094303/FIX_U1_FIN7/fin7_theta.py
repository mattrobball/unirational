#!/usr/bin/env python3
"""FIX-U1-FIN7 -- the Theta-eigenspace decomposition of the 39-parameter space.

Theta(T) := g^{-1}(psi(T)) satisfies Theta^3 = id, and F(Theta T) = F(T) o psi
(F is A4-invariant), so the cone and its ideal are Theta-stable and, at a point
p with Theta p = lam p,

    J_{Theta p} Theta v = psi( J_p v )   and   J_{Theta p} = lam^2 J_p ,

hence ker J_p is Theta-stable and splits as  ker_1 + ker_om + ker_om2.

Theta is a monomial matrix with 13 free 3-cycles (all five slots: a' and b'
each contribute 2 psi-orbits of monomials, the three u-slots are permuted
cyclically and contribute 9), so each eigenspace V_mu has dimension 13.  The
eigenblocks of FIX-N2C are exactly the V_mu.
"""
import sympy as sp

import fin7_lib as L
from fin7_lib import kred, om


def theta_mat():
    """39 x 39 matrix M over K with (Theta v)_a = sum_b M[a][b] v_b."""
    names = L.all_params()
    idx = {n: k for k, n in enumerate(names)}
    lin = L.theta_matrix()
    n = len(names)
    M = [[sp.Integer(0)]*n for _ in range(n)]
    for a, nm in enumerate(names):
        e = sp.expand(lin[names[a]])
        for b, nb in enumerate(names):
            c = e.coeff(sp.Symbol(nb))
            if c != 0:
                M[a][b] = kred(c)
    return names, M


def _matmulv(M, v):
    n = len(M)
    return [kred(sum(M[a][b]*v[b] for b in range(n) if M[a][b] != 0))
            for a in range(n)]


def eigen_basis():
    """{mu_index j: 13 basis vectors of V_{om^j}} as lists of K-elements."""
    names, M = theta_mat()
    n = len(names)
    # orbits of the monomial matrix
    supp = [[b for b in range(n) if M[a][b] != 0] for a in range(n)]
    assert all(len(s) == 1 for s in supp), 'Theta is not a monomial matrix'
    # Theta e_b -> which coordinate?  column b is nonzero in row a(b)
    col = {}
    for a in range(n):
        b = supp[a][0]
        assert b not in col
        col[b] = (a, M[a][b])
    out = {}
    for j in range(3):
        mu = kred(om**j)
        basis, seen = [], set()
        for b0 in range(n):
            if b0 in seen:
                continue
            orb, cs, b = [b0], [sp.Integer(1)], b0
            for _ in range(2):
                a, c = col[b]
                orb.append(a)
                cs.append(kred(cs[-1]*c))
                b = a
            a, c = col[b]
            assert a == b0 and kred(cs[-1]*c) == 1, 'Theta^3 != 1'
            seen |= set(orb[:3])
            # v = sum_k mu^{-k} Theta^k e_{b0}  is a mu-eigenvector
            v = [sp.Integer(0)]*n
            for k in range(3):
                v[orb[k]] = kred(cs[k]*kred(mu**(3 - k) if k else 1))
            basis.append(v)
        assert len(basis) == 13, len(basis)
        # sanity: Theta v = mu v
        for v in basis:
            w = _matmulv(M, v)
            assert all(kred(w[t] - mu*v[t]) == 0 for t in range(n))
        out[j] = basis
    # sanity: the 39 vectors are a basis
    A = sp.Matrix([out[j][k] for j in range(3) for k in range(13)])
    A = A.applyfunc(lambda e: e.subs({om: sp.Rational(-1, 2)
                                      + sp.sqrt(-3)/2}))
    assert sp.simplify(A.det()) != 0, 'eigenvectors are not a basis'
    return names, out
