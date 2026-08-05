#!/usr/bin/env python3
"""FIX-C1 -- exact arithmetic and linear algebra over the parameter ring.

The parameter ring of a branch is a finite-dimensional QQ-algebra

    R = QQ[g_1,...,g_s] / (GB)

presented by a Groebner basis whose leading monomials are pure powers
g_i^{d_i}, pairwise coprime (Buchberger's first criterion), so that R is free
with the monomial basis  { g_1^{e_1} ... g_s^{e_s} : 0 <= e_i < d_i }.

For the (1,7) Chebyshev branch, R = QQ[P1,c,om,kp]/(...) has dim_QQ R = 36 and
is a product of fields (one factor per Galois orbit of the nine points).  All
linear algebra below is exact over QQ and is carried out with UNIT PIVOTS: a
pivot is accepted only when its multiplication operator on R is invertible,
i.e. when it is nonzero at EVERY point of Spec R.  A row-echelon form obtained
with unit pivots is therefore valid simultaneously at all nine points, and the
resulting rank / solvability verdicts are uniform in the branch parameters.
If no unit pivot exists the routine says so loudly (`ZeroDivisorPivot`) --
that would itself be a parameter-dependence finding.
"""
import itertools
from fractions import Fraction

import sympy as sp


class ZeroDivisorPivot(Exception):
    pass


class Quo(object):
    """R = QQ[gens]/(rel) with pure-power, pairwise coprime leading monomials."""

    def __init__(self, rel, gens, degs, red):
        self.gens = tuple(gens)
        self.degs = tuple(degs)
        self.red = red
        self.basis = [tuple(e) for e in
                      itertools.product(*[range(d) for d in degs])]
        self.index = {b: i for i, b in enumerate(self.basis)}
        self.n = len(self.basis)
        self._nf = {}
        self.one = self.from_expr(sp.Integer(1))
        self.zero = [Fraction(0)]*self.n

    # -- conversion ---------------------------------------------------------
    def _vec_of_normal(self, expr):
        v = [Fraction(0)]*self.n
        expr = sp.expand(expr)
        if expr == 0:
            return v
        P = sp.Poly(expr, *self.gens)
        for mono, cf in zip(P.monoms(), P.coeffs()):
            q = sp.Rational(cf)
            v[self.index[tuple(mono)]] += Fraction(int(q.p), int(q.q))
        return v

    def from_expr(self, expr):
        """normal form of an arbitrary polynomial in the gens (fast: reduces
        monomial by monomial through the cached monomial normal forms)."""
        expr = sp.expand(expr)
        if expr == 0:
            return [Fraction(0)]*self.n
        P = sp.Poly(expr, *self.gens)
        out = [Fraction(0)]*self.n
        for mono, cf in zip(P.monoms(), P.coeffs()):
            q = sp.Rational(cf)
            f = Fraction(int(q.p), int(q.q))
            for k, cc in self.nf_mono(tuple(mono)):
                out[k] += f*cc
        return out

    def to_expr(self, v):
        out = sp.Integer(0)
        for i, a in enumerate(v):
            if a:
                t = sp.Rational(a.numerator, a.denominator)
                for g, e in zip(self.gens, self.basis[i]):
                    t *= g**e
                out += t
        return sp.expand(out)

    def nf_mono(self, e):
        """sparse normal form of the monomial with exponent tuple e:
        list of (basis index, coefficient)."""
        got = self._nf.get(e)
        if got is None:
            expr = sp.Integer(1)
            for g, k in zip(self.gens, e):
                expr *= g**k
            v = self._vec_of_normal(self.red(expr))
            got = [(k, cc) for k, cc in enumerate(v) if cc]
            self._nf[e] = got
        return got

    # -- ring ops -----------------------------------------------------------
    def add(self, u, v):
        return [a + b for a, b in zip(u, v)]

    def sub(self, u, v):
        return [a - b for a, b in zip(u, v)]

    def neg(self, u):
        return [-a for a in u]

    def scal(self, s, u):
        return [s*a for a in u]

    def is_zero(self, u):
        return not any(u)

    def mul(self, u, v):
        """convolve as polynomials, then reduce the (few) product monomials."""
        bs = self.basis
        su = [(i, a) for i, a in enumerate(u) if a]
        sv = [(j, b) for j, b in enumerate(v) if b]
        if not su or not sv:
            return [Fraction(0)]*self.n
        prod = {}
        for i, a in su:
            bi = bs[i]
            for j, b in sv:
                bj = bs[j]
                key = (bi[0] + bj[0], bi[1] + bj[1], bi[2] + bj[2],
                       bi[3] + bj[3]) if len(bi) == 4 else \
                      tuple(p + q for p, q in zip(bi, bj))
                ab = a*b
                if key in prod:
                    prod[key] += ab
                else:
                    prod[key] = ab
        out = [Fraction(0)]*self.n
        nf = self.nf_mono
        for key, cf in prod.items():
            if not cf:
                continue
            for k, cc in nf(key):
                out[k] += cf*cc
        return out

    def mulmat(self, u):
        """matrix of multiplication-by-u in the monomial basis."""
        cols = []
        for j in range(self.n):
            ej = [Fraction(0)]*self.n
            ej[j] = Fraction(1)
            cols.append(self.mul(u, ej))
        return [[cols[j][i] for j in range(self.n)] for i in range(self.n)]

    def inv(self, u):
        """inverse of u; raises ZeroDivisorPivot if u is not a unit."""
        M = self.mulmat(u)
        rhs = [Fraction(0)]*self.n
        rhs[self.index[tuple([0]*len(self.gens))]] = Fraction(1)
        sol = solve_qq(M, rhs)
        if sol is None:
            raise ZeroDivisorPivot('not a unit')
        return sol

    def is_unit(self, u):
        if self.is_zero(u):
            return False
        key = tuple(u)
        got = getattr(self, '_unitcache', None)
        if got is None:
            got = self._unitcache = {}
        if key in got:
            return got[key]
        try:
            self.inv(u)
            got[key] = True
        except ZeroDivisorPivot:
            got[key] = False
        return got[key]


# ---------------------------------------------------------------------------
# exact QQ linear algebra (Fractions)
# ---------------------------------------------------------------------------
def solve_qq(M, rhs):
    """one solution of M X = rhs over QQ, or None if inconsistent."""
    n = len(M)
    m = len(M[0]) if n else 0
    A = [list(M[i]) + [rhs[i]] for i in range(n)]
    piv = []
    r = 0
    for cidx in range(m):
        p = None
        for i in range(r, n):
            if A[i][cidx]:
                p = i
                break
        if p is None:
            continue
        A[r], A[p] = A[p], A[r]
        inv = Fraction(1)/A[r][cidx]
        A[r] = [a*inv for a in A[r]]
        for i in range(n):
            if i != r and A[i][cidx]:
                f = A[i][cidx]
                A[i] = [a - f*b for a, b in zip(A[i], A[r])]
        piv.append(cidx)
        r += 1
        if r == n:
            break
    for i in range(r, n):
        if A[i][m] and not any(A[i][:m]):
            return None
    sol = [Fraction(0)]*m
    for i, cidx in enumerate(piv):
        sol[cidx] = A[i][m]
    return sol


# ---------------------------------------------------------------------------
# linear algebra over R with unit pivots
# ---------------------------------------------------------------------------
def rref_R(Q, M, rhs=None, track=False):
    """unit-pivot row reduction of the R-matrix M (list of rows of R-vectors).

    Returns dict with 'rank', 'pivots', 'A' (reduced rows), 'rhs' (reduced),
    and, if track, 'U' with U*M = A (records the row operations, so the
    left kernel can be read off).
    """
    nr = len(M)
    nc = len(M[0]) if nr else 0
    A = [[list(e) for e in row] for row in M]
    b = [list(e) for e in rhs] if rhs is not None else None
    U = None
    if track:
        U = [[(Q.one if i == j else list(Q.zero)) for j in range(nr)]
             for i in range(nr)]
        U = [[list(u) for u in row] for row in U]
    piv = []
    r = 0
    for cidx in range(nc):
        # find a UNIT pivot in column cidx at or below row r
        p = None
        for i in range(r, nr):
            if not Q.is_zero(A[i][cidx]) and Q.is_unit(A[i][cidx]):
                p = i
                break
        if p is None:
            # any nonzero, non-unit entry left in this column?
            for i in range(r, nr):
                if not Q.is_zero(A[i][cidx]):
                    raise ZeroDivisorPivot(
                        'column %d has only zero-divisor entries' % cidx)
            continue
        A[r], A[p] = A[p], A[r]
        if b is not None:
            b[r], b[p] = b[p], b[r]
        if track:
            U[r], U[p] = U[p], U[r]
        iv = Q.inv(A[r][cidx])
        A[r] = [Q.mul(iv, e) for e in A[r]]
        if b is not None:
            b[r] = Q.mul(iv, b[r])
        if track:
            U[r] = [Q.mul(iv, e) for e in U[r]]
        for i in range(nr):
            if i != r and not Q.is_zero(A[i][cidx]):
                f = list(A[i][cidx])
                A[i] = [Q.sub(A[i][k], Q.mul(f, A[r][k])) for k in range(nc)]
                if b is not None:
                    b[i] = Q.sub(b[i], Q.mul(f, b[r]))
                if track:
                    U[i] = [Q.sub(U[i][k], Q.mul(f, U[r][k]))
                            for k in range(nr)]
        piv.append(cidx)
        r += 1
        if r == nr:
            break
    return {'rank': r, 'pivots': piv, 'A': A, 'rhs': b, 'U': U, 'nrows': nr,
            'ncols': nc}


def kernel_R(Q, M):
    """basis of the right kernel of M over R (M has a unit-pivot echelon form)."""
    res = rref_R(Q, M)
    A, piv, nc = res['A'], res['pivots'], res['ncols']
    free = [j for j in range(nc) if j not in piv]
    ker = []
    for f in free:
        v = [list(Q.zero) for _ in range(nc)]
        v[f] = list(Q.one)
        for i, pcol in enumerate(piv):
            v[pcol] = Q.neg(A[i][f])
        ker.append(v)
    return ker, res


def cokernel_functionals_R(Q, M):
    """basis of the left kernel of M (functionals phi with phi.M = 0)."""
    res = rref_R(Q, M, track=True)
    A, U, r, nr = res['A'], res['U'], res['rank'], res['nrows']
    phis = []
    for i in range(nr):
        if all(Q.is_zero(e) for e in A[i]):
            phis.append(U[i])
    return phis, res


def solve_R(Q, M, rhs):
    """particular solution of M v = rhs over R, or None if inconsistent."""
    res = rref_R(Q, M, rhs=rhs)
    A, b, piv, nc, nr = res['A'], res['rhs'], res['pivots'], res['ncols'], res['nrows']
    for i in range(nr):
        if all(Q.is_zero(e) for e in A[i]) and not Q.is_zero(b[i]):
            return None, res
    v = [list(Q.zero) for _ in range(nc)]
    for i, pcol in enumerate(piv):
        v[pcol] = b[i]
    return v, res


# ---------------------------------------------------------------------------
# modular specialisation (used ONLY to guess pivot rows / to cross-check;
# every verdict is certified by exact arithmetic afterwards)
# ---------------------------------------------------------------------------
def spec_vec(Q, u, vals, p):
    """evaluate an R-element at a point of Spec R over F_p."""
    s = 0
    for i, a in enumerate(u):
        if not a:
            continue
        t = a.numerator % p * pow(a.denominator % p, p - 2, p) % p
        for g, e in zip(vals, Q.basis[i]):
            if e:
                t = t*pow(g, e, p) % p
        s = (s + t) % p
    return s


def modular_rref(rows, p):
    """rref of a matrix over F_p; returns (rank, pivot cols, pivot rows, A)."""
    A = [list(r) for r in rows]
    nr, nc = len(A), (len(A[0]) if A else 0)
    piv, prow, r = [], [], 0
    for cidx in range(nc):
        q = None
        for i in range(r, nr):
            if A[i][cidx] % p:
                q = i
                break
        if q is None:
            continue
        A[r], A[q] = A[q], A[r]
        inv = pow(A[r][cidx], p - 2, p)
        A[r] = [a*inv % p for a in A[r]]
        for i in range(nr):
            if i != r and A[i][cidx] % p:
                f = A[i][cidx]
                A[i] = [(a - f*b) % p for a, b in zip(A[i], A[r])]
        piv.append(cidx)
        prow.append(q if q != r else r)
        r += 1
    return r, piv, A


def modular_pivot_rows(Q, M, vals, p):
    """row indices that already realise the rank, guessed modulo p."""
    nr, nc = len(M), len(M[0])
    S = [[spec_vec(Q, M[i][j], vals, p) for j in range(nc)] for i in range(nr)]
    chosen, cur = [], []
    rk = 0
    for i in range(nr):
        trial = cur + [S[i]]
        r, _, _ = modular_rref(trial, p)
        if r > rk:
            rk = r
            cur = trial
            chosen.append(i)
    return chosen, rk, S


def analyze_R(Q, M, rhss=None, hint=None, verbose=False):
    """exact rank / kernel / solvability of the R-linear system M v = rhs.

    Strategy: run unit-pivot elimination on a small set of rows (guessed
    modulo a prime), then reduce EVERY remaining row of M against the reduced
    rows.  When every remaining row reduces to zero:
      * rank >= r is certified by the unit pivots (valid at every point of
        Spec R simultaneously),
      * rank <= r is certified because every row of M is an R-combination of
        the r reduced rows,
    so rank = r exactly.  The reduced right-hand sides on the zero rows are
    the exact obstruction (cokernel) coordinates.
    """
    nr = len(M)
    nc = len(M[0]) if nr else 0
    rhss = [] if rhss is None else [list(v) for v in rhss]
    rows = list(range(nr)) if hint is None else list(hint)
    while True:
        sub = [M[i] for i in rows]
        subr = [[v[i] for i in rows] for v in rhss]
        res2 = rref_R(Q, sub, track=True)
        U = res2['U']
        A = res2['A']
        piv = res2['pivots']
        r = res2['rank']
        subrT = []
        for v in subr:
            subrT.append([_dot(Q, U[i], v) for i in range(len(rows))])
        # reduce the remaining rows
        bad = None
        resid = [[] for _ in rhss]
        # first: zero rows inside the sub-block
        for i in range(len(rows)):
            if all(Q.is_zero(e) for e in A[i]):
                for t, v in enumerate(subrT):
                    resid[t].append((('sub', rows[i]), v[i]))
        for i in range(nr):
            if i in rows:
                continue
            row = [list(e) for e in M[i]]
            rv = [list(v[i]) for v in rhss]
            for k, pc in enumerate(piv):
                f = list(row[pc])
                if Q.is_zero(f):
                    continue
                row = [Q.sub(row[j], Q.mul(f, A[k][j])) for j in range(nc)]
                for t in range(len(rhss)):
                    rv[t] = Q.sub(rv[t], Q.mul(f, subrT[t][k]))
            if any(not Q.is_zero(e) for e in row):
                bad = i
                break
            for t in range(len(rhss)):
                resid[t].append((('ext', i), rv[t]))
        if bad is not None:
            rows.append(bad)
            if verbose:
                print('    (adding row %d to the pivot set)' % bad, flush=True)
            continue
        break
    # kernel
    free = [j for j in range(nc) if j not in piv]
    ker = []
    for f in free:
        v = [list(Q.zero) for _ in range(nc)]
        v[f] = list(Q.one)
        for i, pcol in enumerate(piv):
            v[pcol] = Q.neg(A[i][f])
        ker.append(v)
    # particular solutions
    sols = []
    for t in range(len(rhss)):
        if any(not Q.is_zero(val) for _, val in resid[t]):
            sols.append(None)
        else:
            v = [list(Q.zero) for _ in range(nc)]
            for i, pcol in enumerate(piv):
                v[pcol] = subrT[t][i]
            sols.append(v)
    return {'rank': r, 'pivots': piv, 'free': free, 'kernel': ker,
            'A': A, 'rows': rows, 'residuals': resid, 'solutions': sols,
            'nrows': nr, 'ncols': nc}


def _dot(Q, coeffs, vec):
    out = list(Q.zero)
    for cvec, v in zip(coeffs, vec):
        if Q.is_zero(cvec) or Q.is_zero(v):
            continue
        out = Q.add(out, Q.mul(cvec, v))
    return out


def matvec_R(Q, M, v):
    return [_dot(Q, row, v) for row in M]
