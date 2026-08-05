#!/usr/bin/env python3
"""FIX-N2: residual-C3-equivariant POINTWISE landing tuples.

A C3-equivariant pointwise tuple is a K-equivariant tuple which in addition
satisfies, for a constant projective scalar lam with lam^3 = 1,

    psi(a')  = lam*om  * a'
    psi(b')  = lam*om^2* b'
    psi(u0') = lam * u1',  psi(u1') = lam * u2',  psi(u2') = lam * u0'

where psi is the substitution (x,y,z) -> (y,z,x) on the source, and
(a,b,u0,u1,u2) -> (om a, om^2 b, u1, u2, u0) is the residual C3 on the target
(this substitution preserves the Klein normal form (1.1); checked below).

The linear algebra is carried out over the exact field QQ(om) by substituting
the algebraic number om = (-1+sqrt(-3))/2, computing an exact nullspace, and
converting back with sqrt(-3) = 2*om+1.  (sympy's `solve` is NOT reliable here:
with `om` left as a free symbol it silently returns over-specialised solutions.)
"""

import sympy as sp

import cell_lib as CL
from cell_lib import om, x, y, z

OMV = sp.Rational(-1, 2) + sp.sqrt(3) * sp.I / 2      # primitive cube root
assert sp.simplify(OMV**2 + OMV + 1) == 0


def psi(f):
    return sp.expand(sp.sympify(f).subs({x: y, y: z, z: x}, simultaneous=True))


def to_om(e):
    """Convert an element of QQ(sqrt(-3)) to p + q*om with p,q in QQ.

    om = (-1+i sqrt3)/2, so e = A + B i sqrt3 with A,B rational corresponds to
    p = A + B, q = 2B.
    """
    e = sp.simplify(sp.sympify(e))
    A = sp.nsimplify(sp.simplify(sp.re(e)), rational=True)
    B = sp.nsimplify(sp.simplify(sp.im(e) / sp.sqrt(3)), rational=True)
    assert A.is_rational and B.is_rational, (e, A, B)
    return sp.expand((A + B) + 2 * B * om)


def check_normal_form_invariance():
    a, b, u0, u1, u2 = sp.symbols('a b u0 u1 u2')
    F = CL.klein(a, b, u0, u1, u2)
    Fs = CL.klein(om * a, om**2 * b, u1, u2, u0)
    assert CL.reduce_om(sp.expand(F - Fs)) == 0
    return True


def equivariant_tuple(r, m, lam):
    """Impose C3-equivariance.  Returns (forms, free params) or None."""
    forms, coeffs, bases = CL.make_tuple(r, m)
    if not coeffs:
        return None
    a, b, u0, u1, u2 = [sp.sympify(f) for f in forms]
    lamv = sp.simplify(sp.sympify(lam).subs(om, OMV))
    conds = []
    for lhs, rhs in ((psi(a), lamv * OMV * a), (psi(b), lamv * OMV**2 * b),
                     (psi(u0), lamv * u1), (psi(u1), lamv * u2),
                     (psi(u2), lamv * u0)):
        diff = sp.expand(lhs - rhs)
        if diff == 0:
            continue
        P = sp.Poly(diff, x, y, z)
        conds.extend(P.coeffs())
    if not conds:
        ns = sp.eye(len(coeffs)).columnspace()
    else:
        M, _ = sp.linear_eq_to_matrix(conds, coeffs)
        M = M.applyfunc(lambda e: sp.expand(sp.simplify(e)))
        ns = M.nullspace()
    if not ns:
        return None
    params = sp.symbols('v0:%d' % len(ns))
    subs = {}
    for i, c in enumerate(coeffs):
        val = sum(params[k] * to_om(ns[k][i]) for k in range(len(ns)))
        subs[c] = sp.expand(val)
    newforms = [CL.reduce_om(sp.expand(sp.sympify(f).subs(subs))) for f in forms]
    return newforms, list(params)


def landing_eqs(forms, orbit_reduce=True):
    """Coefficient equations of F(T)=0.

    For a C3-equivariant T the form F(T) is itself C3-semi-invariant, so the
    coefficient equations come in psi-orbits of monomials and one representative
    per orbit implies the whole orbit.  With orbit_reduce=True we return one
    equation per orbit (a genuine reduction by a factor ~3, which is what makes
    the r=7,8 Groebner computations feasible).
    """
    Fv = CL.reduce_om(sp.expand(CL.klein(*forms)))
    if Fv == 0:
        return []
    P = sp.Poly(Fv, x, y, z)
    terms = {mo: CL.reduce_om(c) for mo, c in P.terms()}
    if not orbit_reduce:
        return [e for e in terms.values() if e != 0]
    seen, out = set(), []
    for mo in sorted(terms, reverse=True):
        if mo in seen:
            continue
        orb = {mo, (mo[2], mo[0], mo[1]), (mo[1], mo[2], mo[0])}
        seen |= orb
        if terms[mo] != 0:
            out.append(terms[mo])
        else:
            for m2 in orb:
                if terms.get(m2, 0) != 0:
                    out.append(terms[m2])
                    break
    return out


def report(r, m):
    out = []
    for lam in (1, om, om**2):
        res = equivariant_tuple(r, m, lam)
        if res is None:
            out.append((lam, 0, [], []))
            continue
        forms, free = res
        out.append((lam, len(free), forms, landing_eqs(forms)))
    return out


if __name__ == '__main__':
    import sys
    assert check_normal_form_invariance()
    print('normal form (1.1) invariant under the residual C3 substitution: OK')
    for spec in sys.argv[1:]:
        m, r = (int(v) for v in spec.split(','))
        print('=' * 60)
        for lam, nfree, forms, eqs in report(r, m):
            print('cell (m,r)=(%d,%d)  lam=%s : free params = %s, eqs = %d'
                  % (m, r, lam, nfree, len(eqs)))
            if nfree and nfree <= 6:
                for nm, f in zip(['a', 'b', 'u0', 'u1', 'u2'], forms):
                    print('    %s = %s' % (nm, sp.factor(f)))
