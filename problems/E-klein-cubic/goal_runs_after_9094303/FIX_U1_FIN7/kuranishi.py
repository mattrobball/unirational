#!/usr/bin/env python3
"""FIX-U1-FIN7 -- the level-0 Kuranishi map at a classified point, to order 3.

The germ of the cone at p is isomorphic to the germ at 0 of

    Kur(p) = { v in ker J_p : Ob(v) = 0 }   subset  ker J_p ,

Ob = Ob_2 + Ob_3 + ... : ker -> coker J_p, the standard Kuranishi power series
(w chosen in the complement of ker spanned by the pivot coordinates).  Hence

    dim_p (cone)  =  dim_0 Kur(p) ,

and dim_0 V(Ob_2, Ob_3) is an UPPER bound for it.  The 3-dimensional torus
subspace T = <E_x.p, E_y.p, E_z.p> is always contained in Kur(p).

If dim_0 V(Ob_2, Ob_3) = 3, then dim_p(cone) = 3 (affine), i.e. the germ of
PO_1(7) at p is exactly the 2-dimensional torus orbit: FINITE MOD TORUS there.
"""
import sys
import itertools
import sympy as sp

import fin7_lib as L, fin7_modular as M, fin7_jac as JJ, fin7_equiv as E

p, omp, kpp = M.good_primes(100000, 1)[0]
names, eqs = L.landing_terms(); R = JJ.Fp(p)
eq_p = M.eqs_mod(eqs, p, omp, kpp); n = len(names); NE = len(eq_p)


def tofp(e):
    return M.to_fp(e, {L.om: omp, L.kp: kpp}, p)


def poly_mul(a, b):
    out = {}
    for ka, va in a.items():
        for kb, vb in b.items():
            k = tuple(i + j for i, j in zip(ka, kb))
            out[k] = (out.get(k, 0) + va*vb) % p
    return {k: v for k, v in out.items() if v}


def poly_add(a, b, s=1):
    out = dict(a)
    for k, v in b.items():
        out[k] = (out.get(k, 0) + s*v) % p
    return {k: v for k, v in out.items() if v}


def run(j, part_wanted):
    coords = E.classified_point(j)
    r1, r2 = M.block_points_mod(j, p, omp, kpp)
    B20 = tofp(sp.expand((2*L.om+1)*L.om**(2*j)
                         * (sp.Rational(4, 3)*L.kp - sp.Rational(1, 3))))
    P10 = tofp(sp.expand(sp.Rational(4, 3)*L.om**(j+1)
                         * (sp.Rational(4, 3)*L.kp - sp.Rational(1, 3))))
    for B2v in r1:
        for P1v in r2:
            part = (('A' if P1v == P10 else 'B') if B2v == B20
                    else ('C' if P1v == P10 else 'D'))
            if part != part_wanted:
                continue
            P = M.point_mod(j, B2v, P1v, p, omp, kpp, names, coords)
            J = JJ.jacobian(R, P, eq_p, names)
            rk, pc, A2 = JJ.rank(R, J)
            ker = JJ.nullspace(R, J, (rk, pc, A2))
            K = len(ker)
            JT = [[J[i][t] for i in range(NE)] for t in range(n)]
            coker = JJ.nullspace(R, JT)
            # v = sum c_a ker[a] ; monomials in c
            ZERO = tuple([0]*K)

            def emono(a):
                e = [0]*K; e[a] = 1; return tuple(e)

            def const(val):
                return {ZERO: val % p} if val % p else {}
            V = [{emono(a): ker[a][t] % p for a in range(K) if ker[a][t] % p}
                 for t in range(n)]
            # 3*Phi(p,v,v) : quadratic in c, per equation
            Q = [dict() for _ in range(NE)]
            for ei, (_m, tl) in enumerate(eq_p):
                acc = {}
                for c0, (i1, i2, i3) in tl:
                    for (x1, x2, x3) in ((V[i1], V[i2], const(P[i3])),
                                         (V[i1], const(P[i2]), V[i3]),
                                         (const(P[i1]), V[i2], V[i3])):
                        t3 = poly_mul(poly_mul(x1, x2), x3)
                        for k, v in t3.items():
                            acc[k] = (acc.get(k, 0) + c0*v) % p
                Q[ei] = {k: v for k, v in acc.items() if v}
            quad = sorted(set().union(*[set(q) for q in Q]) if any(Q)
                          else [])
            assert all(sum(k) == 2 for k in quad), 'quadratic monomials only'
            ob2 = []
            for yv in coker:
                f = {}
                for ei in range(NE):
                    if yv[ei] % p == 0:
                        continue
                    for k, v in Q[ei].items():
                        f[k] = (f.get(k, 0) + yv[ei]*v) % p
                f = {k: v for k, v in f.items() if v}
                if f:
                    ob2.append(f)
            print('  j=%d part %s: dim ker=%d dim coker=%d ; nonzero Ob_2 '
                  'components: %d' % (j, part, K, len(coker), len(ob2)))
            if ob2:
                return ('OB2', K, ob2, quad)
            # Ob_2 == 0 : solve J w = -Q  for each quadratic monomial
            W = [dict() for _ in range(n)]
            for mono in quad:
                rhs = [(-Q[ei].get(mono, 0)) % p for ei in range(NE)]
                aug = [J[i][:] + [rhs[i]] for i in range(NE)]
                r2_, pcs, A3 = JJ.rank(R, aug)
                assert n not in pcs, 'inconsistent -- Ob_2 not zero'
                for i, c1 in enumerate(pcs):
                    if A3[i][n] % p:
                        W[c1][mono] = A3[i][n] % p
            # Ob_3 = 6 Phi(p,v,w) + Phi(v,v,v)  (cubic in c)
            C3 = [dict() for _ in range(NE)]
            for ei, (_m, tl) in enumerate(eq_p):
                acc = {}
                for c0, (i1, i2, i3) in tl:
                    parts = []
                    # 6 Phi(p,v,w): all 6 orderings of (P, v, w)
                    for perm in itertools.permutations([0, 1, 2]):
                        xs = [None, None, None]
                        xs[perm[0]] = const(P[[i1, i2, i3][perm[0]]])
                        xs[perm[1]] = V[[i1, i2, i3][perm[1]]]
                        xs[perm[2]] = W[[i1, i2, i3][perm[2]]]
                        parts.append(poly_mul(poly_mul(xs[0], xs[1]), xs[2]))
                    parts.append(poly_mul(poly_mul(V[i1], V[i2]), V[i3]))
                    for t3 in parts:
                        for k, v in t3.items():
                            acc[k] = (acc.get(k, 0) + c0*v) % p
                C3[ei] = {k: v for k, v in acc.items() if v and sum(k) == 3}
            ob3 = []
            for yv in coker:
                f = {}
                for ei in range(NE):
                    if yv[ei] % p == 0:
                        continue
                    for k, v in C3[ei].items():
                        f[k] = (f.get(k, 0) + yv[ei]*v) % p
                f = {k: v for k, v in f.items() if v}
                if f:
                    ob3.append(f)
            print('    Ob_2 == 0 identically; nonzero Ob_3 components: %d'
                  % len(ob3))
            return ('OB3', K, ob3, None)


def emit(tag, K, forms, deg):
    vs = ['c%d' % a for a in range(K)]
    lines = []
    for f in forms:
        lines.append('+'.join(
            '%d*%s' % (v, '*'.join(vs[a] for a in range(K)
                                   for _ in range(k[a])))
            for k, v in sorted(f.items())))
    m2 = ('R = ZZ/%d[%s];\nI = ideal(\n%s);\n'
          'print("dim (affine cone) = "|toString dim I);\n'
          'print("proj dim = "|toString(dim I - 1));\n'
          'print("degree = "|toString degree I);\n'
          'print("minimal primes:");\n'
          'scan(minimalPrimes I, P -> print(toString(dim P)|"  "|toString P));'
          '\nexit 0\n' % (p, ','.join(vs), ',\n'.join(lines)))
    open('m2/%s.m2' % tag, 'w').write(m2)
    print('    wrote m2/%s.m2  (%d forms of degree %s in %d variables)'
          % (tag, len(forms), deg, K))


if __name__ == '__main__':
    for j, part in [(0, 'A'), (0, 'B'), (0, 'D')]:
        out = run(j, part)
        if out:
            kind, K, forms, _q = out
            emit('kur_j%d%s_%s' % (j, part, kind), K, forms,
                 2 if kind == 'OB2' else 3)
