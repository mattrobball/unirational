#!/usr/bin/env python3
"""FIX-C1 -- assembling and solving the ladder levels."""
import sympy as sp

import c1_lib as L
import c1_ring as CR
from c1_lib import x, y, z


def linear_system(expr, syms, Q, rows=None):
    """split a polynomial that is AFFINE in `syms` into (rows, M, const).

    rows  : ordered list of (x,y,z)-monomials
    M     : matrix over R, M[i][j] = coefficient of syms[j] in monomial rows[i]
    const : the syms-free part, as an R-vector indexed by rows
    """
    expr = sp.expand(expr)
    syms = list(syms)
    sidx = {s: j for j, s in enumerate(syms)}
    data = {}
    const = {}
    if expr != 0:
        P = sp.Poly(expr, x, y, z, *syms)
        for mono, cf in zip(P.monoms(), P.coeffs()):
            xyz = tuple(mono[:3])
            sm = mono[3:]
            deg = sum(sm)
            assert deg <= 1, 'system is not affine in the unknowns'
            if deg == 0:
                const[xyz] = const.get(xyz, sp.Integer(0)) + cf
            else:
                j = [k for k, e in enumerate(sm) if e][0]
                data.setdefault(xyz, {})
                data[xyz][j] = data[xyz].get(j, sp.Integer(0)) + cf
    if rows is None:
        rows = sorted(set(data) | set(const), reverse=True)
    M = []
    cv = []
    for mn in rows:
        row = [list(Q.zero) for _ in syms]
        for j, e in data.get(mn, {}).items():
            row[j] = Q.from_expr(e)
        M.append(row)
        cv.append(Q.from_expr(const.get(mn, sp.Integer(0))))
    return rows, M, cv


def level_operator(seed_df, n, m, lam, Q, rd, tag):
    """the R-matrix of D_{p0} on V_n(m,lam), plus the basis names."""
    names, E = L.graded_piece(n, m, lam, tag, rd)
    syms = [sp.Symbol(s) for s in names]
    expr = L.D_apply(seed_df, E)
    rows, M, cv = linear_system(expr, syms, Q)
    assert all(Q.is_zero(v) for v in cv)
    return names, E, syms, rows, M


def rhs_vector(expr, rows, Q, rd):
    """R-vector of a known polynomial on the given monomial row set."""
    expr = L.red_poly(expr, rd)
    vec = {}
    if expr != 0:
        P = sp.Poly(expr, x, y, z)
        for mono, cf in zip(P.monoms(), P.coeffs()):
            vec[tuple(mono)] = cf
    extra = sorted(set(vec) - set(rows), reverse=True)
    allrows = list(rows) + extra
    out = [Q.from_expr(vec.get(mn, sp.Integer(0))) for mn in allrows]
    return allrows, out, extra


def pad_matrix(M, rows, allrows, Q, ncols):
    """extend an R-matrix defined on `rows` by zero rows to `allrows`."""
    idx = {mn: i for i, mn in enumerate(rows)}
    out = []
    for mn in allrows:
        i = idx.get(mn)
        if i is None:
            out.append([list(Q.zero) for _ in range(ncols)])
        else:
            out.append(M[i])
    return out


def orbit_key(mn):
    """the psi-orbit representative of a monomial exponent triple."""
    return max(mn, (mn[2], mn[0], mn[1]), (mn[1], mn[2], mn[0]))


def psi_orbit_reduce(rows, M, Q, check=True):
    """drop rows duplicated by the residual C3.

    Every level equation is psi-invariant (psi(Phi(A,B,C)) = lam^3 Phi = Phi
    for tuples of a common eigenblock), so the coefficient of x^A y^B z^C and
    of psi(x^A y^B z^C) = x^C y^A z^B coincide.  Keeping one monomial per
    orbit loses nothing; `check` verifies the coincidence exactly.
    """
    idx = {mn: i for i, mn in enumerate(rows)}
    keep, seen = [], set()
    for mn in rows:
        if mn in seen:
            continue
        orb = {mn, (mn[2], mn[0], mn[1]), (mn[1], mn[2], mn[0])}
        seen |= orb
        keep.append(mn)
        if check:
            for o in orb:
                j = idx.get(o)
                if j is not None and M[j] != M[idx[mn]]:
                    raise AssertionError('psi-invariance violated at %s' % (mn,))
                if j is None and any(not Q.is_zero(e) for e in M[idx[mn]]):
                    raise AssertionError('orbit member missing at %s' % (mn,))
    sel = [idx[mn] for mn in keep]
    return keep, [M[i] for i in sel], sel


def tuple_from_vector(E, syms, vec, Q, rd):
    """substitute an R-vector of coefficients into the general graded tuple."""
    sub = {s: Q.to_expr(v) for s, v in zip(syms, vec)}
    return [L.red_poly(sp.expand(comp.subs(sub, simultaneous=True)), rd)
            for comp in E]


def equivariant_vector_field_directions(p0, m, rd):
    """the reparametrisation directions in ker D_{p0}: (V.grad) p0 for the
    A4-equivariant vector fields V of low degree.

    Degree 2: V = (yz, zx, xy) is the unique one up to scalar.
    Degree 3: V = (x^3, y^3, z^3) and V = (x q, y q, z q), q = x^2+y^2+z^2
              (the second is the Euler/radial one, giving q * p0 * 7/... ).
    """
    out = {}
    D2 = [y*z, z*x, x*y]
    out[2] = [L.red_poly(sum(D2[i]*sp.diff(comp, v)
                             for i, v in enumerate((x, y, z))), rd)
              for comp in p0]
    D3a = [x**3, y**3, z**3]
    out['3a'] = [L.red_poly(sum(D3a[i]*sp.diff(comp, v)
                                for i, v in enumerate((x, y, z))), rd)
                 for comp in p0]
    q = x**2 + y**2 + z**2
    out['3b'] = [L.red_poly(q*comp, rd) for comp in p0]
    return out


def piece_coords(T, names, E, syms, Q, rd):
    """coordinates of a concrete tuple T in the basis of a graded piece.

    Each basis vector of the a'-, b'- and u0'-blocks is supported on a distinct
    monomial (resp. psi-orbit), so the coordinates can be read off; the result
    is then verified by exact reconstruction.
    """
    lead = []
    for j, s in enumerate(syms):
        comp = None
        mn = None
        for i in (0, 1, 2):
            e = sp.expand(sp.diff(E[i], s))
            if e != 0:
                P = sp.Poly(e, x, y, z)
                mn = max(P.monoms())
                cf = P.coeff_monomial(L.mono(mn))
                comp = i
                break
        assert comp is not None
        lead.append((comp, mn, cf))
    vec = []
    for comp, mn, cf in lead:
        Tc = sp.expand(T[comp])
        got = sp.Integer(0)
        if Tc != 0:
            P = sp.Poly(Tc, x, y, z)
            got = P.coeff_monomial(L.mono(mn)) or sp.Integer(0)
        vec.append(Q.from_expr(rd(sp.expand(got/cf))))
    rebuilt = tuple_from_vector(E, syms, vec, Q, rd)
    for a, b in zip(rebuilt, T):
        assert L.red_poly(sp.expand(a - b), rd) == 0, \
            'tuple is not in the graded piece'
    return vec


def in_span(Q, basis, v):
    """is the R-vector v in the R-span of `basis`? (exact)"""
    M = [[basis[k][i] for k in range(len(basis))] for i in range(len(v))]
    res = CR.analyze_R(Q, M, rhss=[v])
    return res['solutions'][0] is not None, res
