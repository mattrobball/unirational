#!/usr/bin/env python3
"""FIX-U1-FIN7 -- Kuranishi obstruction scan: lift arcs along many random
kernel directions to high order.

Ob_k is a polynomial map of degree k on ker J_p (5- or 8-dimensional).  If it
were not identically zero, a uniformly random direction would fail to lift with
probability >= 1 - k/p.  Lifting along R random directions therefore certifies
"Ob_k == 0 identically for all k <= N" with failure probability <= (N/p)^R.
This is a MODULAR cross-check (Schwartz-Zippel), never a verdict.
"""
import random
import sys

import sympy as sp

import fin7_equiv as E
import fin7_jac as JJ
import fin7_lib as L
import fin7_modular as M

NORD = int(sys.argv[1]) if len(sys.argv) > 1 else 12
NDIR = int(sys.argv[2]) if len(sys.argv) > 2 else 12
random.seed(20260806)
p, omp, kpp = M.good_primes(100000, 1)[0]
names, eqs = L.landing_terms(); R = JJ.Fp(p)
eq_p = M.eqs_mod(eqs, p, omp, kpp); n = len(names); NE = len(eq_p)
tofp = lambda e: M.to_fp(e, {L.om: omp, L.kp: kpp}, p)
E3 = JJ.torus_rows()

for j in range(3):
    coords = E.classified_point(j)
    r1, r2 = M.block_points_mod(j, p, omp, kpp)
    B20 = tofp(sp.expand((2*L.om+1)*L.om**(2*j)
                         * (sp.Rational(4, 3)*L.kp - sp.Rational(1, 3))))
    P10 = tofp(sp.expand(sp.Rational(4, 3)*L.om**(j+1)
                         * (sp.Rational(4, 3)*L.kp - sp.Rational(1, 3))))
    done = set()
    for B2v in r1:
        for P1v in r2:
            part = (('A' if P1v == P10 else 'B') if B2v == B20
                    else ('C' if P1v == P10 else 'D'))
            if part in done:
                continue
            done.add(part)
            P = M.point_mod(j, B2v, P1v, p, omp, kpp, names, coords)
            J = JJ.jacobian(R, P, eq_p, names)
            rk, pc, A2 = JJ.rank(R, J)
            ker = JJ.nullspace(R, J, (rk, pc, A2))
            worst, obstructed = NORD, 0
            for _ in range(NDIR):
                cs = [random.randrange(p) for _ in ker]
                v = [sum(cs[a]*ker[a][t] for a in range(len(ker))) % p
                     for t in range(n)]
                terms = [P[:], v[:]]
                for N in range(2, NORD + 1):
                    rhs = [0]*NE
                    for ei, (_m, tl) in enumerate(eq_p):
                        s = 0
                        for c0, (i1, i2, i3) in tl:
                            for a in range(len(terms)):
                                for b in range(len(terms)):
                                    c2 = N - a - b
                                    if c2 < 0 or c2 >= len(terms):
                                        continue
                                    s = (s + c0*terms[a][i1]*terms[b][i2] % p
                                         * terms[c2][i3]) % p
                        rhs[ei] = (-s) % p
                    aug = [J[i][:] + [rhs[i]] for i in range(NE)]
                    r_, pcs, A = JJ.rank(R, aug)
                    if n in pcs:
                        obstructed += 1
                        worst = min(worst, N)
                        break
                    w = [0]*n
                    for i, c1 in enumerate(pcs):
                        w[c1] = A[i][n] % p
                    terms.append(w)
            print('j=%d part %s : dim ker=%d ; %d/%d random directions lift to '
                  'order %d ; first obstruction order = %s'
                  % (j, part, len(ker), NDIR - obstructed, NDIR, NORD,
                     worst if obstructed else 'none <= %d' % NORD))
