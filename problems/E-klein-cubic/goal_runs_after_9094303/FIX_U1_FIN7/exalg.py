#!/usr/bin/env python3
"""FIX-U1-FIN7 -- exact arithmetic in the finite QQ-algebras of the branch.

R = QQ[om, kp, B2, P1] / (om^2+om+1, 8kp^2-13kp-4, g(B2), h(P1))

with g, h monic of degree 1 or 2 (the K-rational root and the quadratic
cofactor of each of FIX-N2C's two block cubics).  The four relations have
pairwise coprime leading monomials om^2, kp^2, B2^deg g, P1^deg h in the lex
order (P1 > B2 > om > kp), so they are a Groebner basis by Buchberger's first
criterion and sympy's `reduced` returns the unique normal form.

Elements are tuples of `fractions.Fraction` in the monomial basis; products use
precomputed structure constants; inversion solves a dim x dim rational system.
When deg g = deg h = 1 the algebra is K itself (dim 4).
"""
from fractions import Fraction as Fr

import sympy as sp

from fin7_lib import om, kp
from fin7_equiv import B2s, P1s


class Alg(object):
    def __init__(self, gB2, gP1, name=''):
        self.name = name
        self.gB2 = sp.Poly(gB2, B2s)
        self.gP1 = sp.Poly(gP1, P1s)
        assert self.gB2.LC() == 1 and self.gP1.LC() == 1, 'monic required'
        self.dB2 = self.gB2.degree()
        self.dP1 = self.gP1.degree()
        self.rel = [sp.expand(gP1), sp.expand(gB2), om**2 + om + 1,
                    8*kp**2 - 13*kp - 4]
        self.gens = (P1s, B2s, om, kp)
        self.basis = [(i, j, k, l)
                      for l in range(self.dP1)
                      for k in range(self.dB2)
                      for j in range(2)
                      for i in range(2)]
        self.dim = len(self.basis)
        self.index = {b: n for n, b in enumerate(self.basis)}
        self._mtab = None

    # -- conversion --------------------------------------------------------
    def _mono(self, b):
        i, j, k, l = b
        return om**i * kp**j * B2s**k * P1s**l

    def nf(self, e):
        e = sp.expand(e)
        if e == 0:
            return sp.Integer(0)
        _, r = sp.reduced(e, self.rel, *self.gens, order='lex')
        return sp.expand(r)

    def of(self, e):
        """sympy expression in om,kp,B2,P1 -> element vector."""
        r = self.nf(e)
        v = [Fr(0)]*self.dim
        if r == 0:
            return tuple(v)
        p = sp.Poly(r, *reversed(self.gens))     # om, kp order irrelevant
        for mon, cf in zip(p.monoms(), p.coeffs()):
            # monoms are in the order (kp, om, B2, P1) after reversed(gens)
            e_kp, e_om, e_B2, e_P1 = mon
            b = (e_om, e_kp, e_B2, e_P1)
            assert b in self.index, (b, r)
            v[self.index[b]] += Fr(sp.Rational(cf).p, sp.Rational(cf).q)
        return tuple(v)

    def to_expr(self, v):
        return sp.expand(sum(sp.Rational(c.numerator, c.denominator)
                             * self._mono(b)
                             for b, c in zip(self.basis, v) if c))

    # -- ring ops ----------------------------------------------------------
    def zero(self):
        return tuple([Fr(0)]*self.dim)

    def one(self):
        return self.of(sp.Integer(1))

    def mtab(self):
        if self._mtab is None:
            n = self.dim
            tab = [[None]*n for _ in range(n)]
            for a in range(n):
                for b in range(a, n):
                    v = self.of(self._mono(self.basis[a])
                                * self._mono(self.basis[b]))
                    tab[a][b] = v
                    tab[b][a] = v
            self._mtab = tab
        return self._mtab

    def mul(self, u, v):
        tab = self.mtab()
        n = self.dim
        out = [Fr(0)]*n
        for a in range(n):
            ua = u[a]
            if not ua:
                continue
            for b in range(n):
                vb = v[b]
                if not vb:
                    continue
                c = ua*vb
                row = tab[a][b]
                for t in range(n):
                    if row[t]:
                        out[t] += c*row[t]
        return tuple(out)

    def add(self, u, v):
        return tuple(a + b for a, b in zip(u, v))

    def sub(self, u, v):
        return tuple(a - b for a, b in zip(u, v))

    def smul(self, c, u):
        return tuple(c*a for a in u)

    def is_zero(self, u):
        return not any(u)

    def matmul(self, u):
        """matrix of multiplication by u in the monomial basis."""
        n = self.dim
        cols = [self.mul(u, self.of(self._mono(self.basis[b])))
                for b in range(n)]
        return [[cols[b][a] for b in range(n)] for a in range(n)]

    def inv(self, u):
        """exact inverse, or None if u is a zero divisor / zero."""
        n = self.dim
        M = self.matmul(u)
        rhs = [Fr(1) if a == 0 else Fr(0) for a in range(n)]
        A = [row[:] + [rhs[i]] for i, row in enumerate(M)]
        piv = 0
        where = []
        for col in range(n):
            r = None
            for i in range(piv, n):
                if A[i][col]:
                    r = i
                    break
            if r is None:
                continue
            A[piv], A[r] = A[r], A[piv]
            f = A[piv][col]
            A[piv] = [e/f for e in A[piv]]
            for i in range(n):
                if i != piv and A[i][col]:
                    g = A[i][col]
                    A[i] = [e - g*e2 for e, e2 in zip(A[i], A[piv])]
            where.append(col)
            piv += 1
        if piv < n:
            # singular: check consistency -> zero divisor
            return None
        sol = [Fr(0)]*n
        for i, col in enumerate(where):
            sol[col] = A[i][n]
        return tuple(sol)
