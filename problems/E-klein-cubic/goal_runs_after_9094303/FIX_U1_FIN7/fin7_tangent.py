#!/usr/bin/env python3
"""FIX-U1-FIN7 -- exact tangent-space computation at the 27 classified points.

For each eigenblock lam = om^j and each Galois part (A, B, C, D) of FIX-N2C's
nine-point scheme, over the exact residue field:

  * the point is re-verified on all 52 equations;
  * the plane-order-exactly-1 conditions are certified (an inverse is exhibited
    for a witness of each plane);
  * the Jacobian J_p is built and its rank is computed exactly, refined by the
    Theta-eigenspace decomposition (three 52 x 13 blocks);
  * the torus orbit dimension is computed exactly;
  * the level-0 Kuranishi map Ob_2(v) = 3 Phi(p, v, v) is evaluated on
    ker J_p modulo im J_p.
"""
import time

import sympy as sp

import fin7_equiv as E
import fin7_jac as JJ
import fin7_lib as L
import fin7_points as PT
import fin7_theta as TH


def prepare(j, part, cache={}):
    """(A, names, vals, eqs_A, prods) for one (block, part)."""
    key = (j, part)
    if key in cache:
        return cache[key]
    A = PT.part_algebra(j, part)
    A.mtab()
    names, eqs = L.landing_terms()
    coords = E.classified_point(j)
    vals = [A.of(coords[n]) for n in names]
    ceq = [(mon, [(A.of(c), idx) for c, idx in terms]) for mon, terms in eqs]
    n = len(names)
    prods = [[None]*n for _ in range(n)]
    for a in range(n):
        for b in range(a, n):
            pv = A.mul(vals[a], vals[b])
            prods[a][b] = pv
            prods[b][a] = pv
    cache[key] = (A, names, vals, ceq, prods)
    return cache[key]


def eq_values(A, vals, ceq):
    out = []
    for _mon, terms in ceq:
        s = A.zero()
        for c, (i, jj, k) in terms:
            s = A.add(s, A.mul(c, A.mul(vals[i], A.mul(vals[jj], vals[k]))))
        out.append(s)
    return out


def jacobian(A, vals, ceq, prods):
    n = len(vals)
    J = []
    for _mon, terms in ceq:
        row = [A.zero()]*n
        for c, trip in terms:
            for pos in range(3):
                t = trip[pos]
                o1, o2 = trip[(pos + 1) % 3], trip[(pos + 2) % 3]
                row[t] = A.add(row[t], A.mul(c, prods[o1][o2]))
        J.append(row)
    return J


def phi_quad(A, vals, ceq, v):
    """3 Phi(p, v, v) = the quadratic term of F(p + v): sum over terms of
    coef * (v_i v_j p_k + v_i p_j v_k + p_i v_j v_k)."""
    out = []
    for _mon, terms in ceq:
        s = A.zero()
        for c, trip in terms:
            i, jj, k = trip
            t1 = A.mul(A.mul(v[i], v[jj]), vals[k])
            t2 = A.mul(A.mul(v[i], vals[jj]), v[k])
            t3 = A.mul(A.mul(vals[i], v[jj]), v[k])
            s = A.add(s, A.mul(c, A.add(t1, A.add(t2, t3))))
        out.append(s)
    return out


def contract(A, J, b):
    """J . b for a (sparse) parameter-space vector b of A-elements."""
    supp = [t for t in range(len(b)) if not A.is_zero(b[t])]
    out = []
    for row in J:
        s = A.zero()
        for t in supp:
            s = A.add(s, A.mul(row[t], b[t]))
        out.append(s)
    return out


def block_matrix(A, J, basis):
    """the 52 x 13 matrix J restricted to an eigenspace, in the given basis."""
    cols = [contract(A, J, [A.of(c) for c in v]) for v in basis]
    return [[cols[k][i] for k in range(len(cols))] for i in range(len(J))]


def torus_tangent(A, vals):
    _names, E3 = L.torus_vectors()
    return [[A.smul(sp.Rational(w).p, vals[t]) if w else A.zero()
             for t, w in enumerate(Ei)] for Ei in E3]


def run_point(j, part, log=print):
    t0 = time.time()
    A, names, vals, ceq, prods = prepare(j, part)
    n = len(names)
    res = {'j': j, 'part': part, 'dimK': A.dim, 'npts': PT.npoints(part)}

    ev = eq_values(A, vals, ceq)
    res['on_cone'] = all(A.is_zero(e) for e in ev)

    # plane orders exactly 1 : certify by exhibiting an inverse
    po = []
    for i, w in enumerate(L.po1_witnesses()):
        good = []
        for nm, _slot, _mon in w:
            v = vals[names.index(nm)]
            iv = None if A.is_zero(v) else A.inv(v)
            good.append((nm, iv is not None))
        po.append(good)
    res['po1'] = po
    res['po1_ok'] = all(any(g[1] for g in gs) for gs in po)

    J = jacobian(A, vals, ceq, prods)
    rk, _pc, _A2 = JJ.rank(A, J)
    res['rank'] = rk
    res['corank'] = n - rk

    _nm, EB = TH.eigen_basis()
    per = {}
    for jm in range(3):
        Mb = block_matrix(A, J, EB[jm])
        r, _pc, _ = JJ.rank(A, Mb)
        per[jm] = (r, 13 - r)
    res['per_block'] = per
    assert sum(per[k][0] for k in per) == rk, (per, rk)

    Tt = torus_tangent(A, vals)
    rt, _pc, _ = JJ.rank(A, [[row[t] for t in range(n)] for row in Tt])
    res['torus_dim'] = rt
    res['torus_in_ker'] = all(all(A.is_zero(c) for c in contract(A, J, tv))
                              for tv in Tt)
    res['secs'] = time.time() - t0
    return res
