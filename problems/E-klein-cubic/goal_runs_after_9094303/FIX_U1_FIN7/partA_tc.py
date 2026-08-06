#!/usr/bin/env python3
"""FIX-U1-FIN7 -- part A: the quadratic Kuranishi obstruction cuts ker J_p
(8-dimensional) down to a LINEAR subspace; find it intrinsically and lift arcs
inside it.

Ob_2 vanishes on a linear space L iff every symmetric matrix of Ob_2 kills L;
so L = the common kernel of the 17 Gram matrices (verified to be 5-dimensional,
matching M2's `dim = 5, degree = 1`).
"""
import random
import sys

import sympy as sp

import fin7_equiv as E
import fin7_jac as JJ
import fin7_lib as L
import fin7_modular as M

NORD = int(sys.argv[1]) if len(sys.argv) > 1 else 10
NDIR = int(sys.argv[2]) if len(sys.argv) > 2 else 8
random.seed(20260806)
p, omp, kpp = M.good_primes(100000, 1)[0]
names, eqs = L.landing_terms(); R = JJ.Fp(p)
eq_p = M.eqs_mod(eqs, p, omp, kpp); n = len(names); NE = len(eq_p)
tofp = lambda e: M.to_fp(e, {L.om: omp, L.kp: kpp}, p)
E3 = JJ.torus_rows()
inv2 = pow(2, p - 2, p)

for j in range(3):
    coords = E.classified_point(j)
    r1, r2 = M.block_points_mod(j, p, omp, kpp)
    B20 = tofp(sp.expand((2*L.om+1)*L.om**(2*j)
                         * (sp.Rational(4, 3)*L.kp - sp.Rational(1, 3))))
    P10 = tofp(sp.expand(sp.Rational(4, 3)*L.om**(j+1)
                         * (sp.Rational(4, 3)*L.kp - sp.Rational(1, 3))))
    P = M.point_mod(j, B20, P10, p, omp, kpp, names, coords)
    J = JJ.jacobian(R, P, eq_p, names)
    rk, pc, A2 = JJ.rank(R, J)
    ker = JJ.nullspace(R, J, (rk, pc, A2))
    K = len(ker)
    JT = [[J[i][t] for i in range(NE)] for t in range(n)]
    coker = JJ.nullspace(R, JT)
    # Gram matrices of Ob_2 in the kernel basis
    G = [[[0]*K for _ in range(K)] for _ in coker]
    for a in range(K):
        for b in range(a, K):
            va, vb = ker[a], ker[b]
            rhs = []
            for _m, tl in eq_p:
                s = 0
                for c0, (i1, i2, i3) in tl:
                    s = (s + c0*(va[i1]*vb[i2] % p*P[i3]
                                 + va[i1]*P[i2] % p*vb[i3]
                                 + P[i1]*va[i2] % p*vb[i3]
                                 + vb[i1]*va[i2] % p*P[i3]
                                 + vb[i1]*P[i2] % p*va[i3]
                                 + P[i1]*vb[i2] % p*va[i3])) % p
                rhs.append(s*inv2 % p)      # polarisation / 2
            for ci, yv in enumerate(coker):
                s = sum(yv[i]*rhs[i] for i in range(NE)) % p
                G[ci][a][b] = s
                G[ci][b][a] = s
    rows = [G[ci][a] for ci in range(len(coker)) for a in range(K)]
    rr, pcs, AA = JJ.rank(R, rows)
    Lsp = JJ.nullspace(R, rows, (rr, pcs, AA))
    print('j=%d part A : dim ker=%d ; common kernel of the Ob_2 Gram matrices '
          '= %d-dimensional (this is the tangent cone bound)'
          % (j, K, len(Lsp)))
    good = 0
    for _ in range(NDIR):
        cs = [random.randrange(p) for _ in Lsp]
        c = [sum(cs[a]*Lsp[a][b] for a in range(len(Lsp))) % p
             for b in range(K)]
        v = [sum(c[a]*ker[a][t] for a in range(K)) % p for t in range(n)]
        terms = [P[:], v[:]]
        ok = True
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
            r_, pcs2, A = JJ.rank(R, aug)
            if n in pcs2:
                ok = False
                break
            w = [0]*n
            for i, c1 in enumerate(pcs2):
                w[c1] = A[i][n] % p
            terms.append(w)
        good += ok
    print('        %d/%d random directions of that %d-space lift to order %d'
          % (good, NDIR, len(Lsp), NORD))
