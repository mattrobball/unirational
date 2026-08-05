#!/usr/bin/env python3
"""FIX-H0 producer, Part E -- the quotient-complex bookkeeping used by the
B-reduction statement.

  E1  Stab_G(L_sigma) = Stab_G(P_sigma) = C_G(sigma) = D12  (all 55)
  E2  each involution lies in exactly 3 V4's; C_G(sigma) cap N_G(V4) = V4 for
      each of them; the three images in the residual S3 = C_G(sigma)/<sigma>
      are three DISTINCT order-2 subgroups and together GENERATE S3
      -- so residual-S3-equivariance of the line germ couples the three
      V4-stars through sigma (the "second line at each vertex" closure)
  E3  ell_V cap L_sigma = empty for every V4 and every line
      (the [II] cell datum is a germ at a stratum DISJOINT from L_sigma)
  E4  X^{V4} = 6 isolated points = 3 type-I vertices + 3 type-II points, two
      FREE C3-orbits; X^{A4} = empty
"""
import json
import os
import sys
import time

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
from klein_exact import (Cyc, ZERO, ONE, Grp, klein_eval, mat_vec, nullspace,
                         rref, subspace_key, rank)

T0 = time.time()
LINES = []


def log(s):
    print(s, flush=True)
    LINES.append(s)


def eig(M, sign):
    rows = [[M[i][j] - (Cyc.from_int(sign) if i == j else ZERO)
             for j in range(5)] for i in range(5)]
    return nullspace(rows, 5)


def joint_fix(G, gens):
    rows = []
    for g in gens:
        M = G.mats[g]
        for i in range(5):
            rows.append([M[i][j] - (ONE if i == j else ZERO) for j in range(5)])
    return nullspace(rows, 5)


def main():
    log('FIX-H0 producer, Part E: quotient-complex bookkeeping')
    G = Grp()
    invs = [i for i in range(G.n) if G.ord[i] == 2]
    assert len(invs) == 55

    # subspaces
    Wp = {s: eig(G.mats[s], 1) for s in invs}
    Wm = {s: eig(G.mats[s], -1) for s in invs}
    kmin = {s: subspace_key(Wm[s]) for s in invs}
    kplu = {s: subspace_key(Wp[s]) for s in invs}
    assert len(set(kmin.values())) == 55 and len(set(kplu.values())) == 55

    # E1  stabilisers
    n_ok = 0
    for s in invs:
        stab = []
        for g in range(G.n):
            img = [mat_vec(G.mats[g], v) for v in Wm[s]]
            if subspace_key(img) == kmin[s]:
                stab.append(g)
        C = set(G.centralizer(s))
        if set(stab) == C and len(C) == 12:
            n_ok += 1
    log('    E1  Stab_G(L_sigma) = C_G(sigma), |.| = 12 : %d/55' % n_ok)
    assert n_ok == 55

    # E2  the three V4's through sigma, and the residual S3
    V4s = []
    seen = set()
    for a in invs:
        for b in invs:
            if a < b and G.mul(a, b) == G.mul(b, a):
                c = G.mul(a, b)
                key = tuple(sorted((a, b, c)))
                if key not in seen:
                    seen.add(key)
                    V4s.append(key)
    log('    E2  number of V4 subgroups : %d' % len(V4s))
    assert len(V4s) == 55

    e2_ok = 0
    for s in invs:
        thru = [V for V in V4s if s in V]
        assert len(thru) == 3, (s, len(thru))
        C = G.centralizer(s)
        # residual S3 = C/<sigma>; represent cosets by the pair {g, g*sigma}
        def cos(g):
            return frozenset((g, G.mul(g, s)))
        S3 = {cos(g) for g in C}
        assert len(S3) == 6
        images = []
        for V in thru:
            NV = [g for g in range(G.n)
                  if {G.conj(t, g) for t in V} == set(V)]
            assert len(NV) == 12, len(NV)          # N_G(V4) = A4
            inter = set(NV) & set(C)
            assert inter == set(V) | {0}, (sorted(inter), V)
            images.append(frozenset(cos(g) for g in V))
        assert all(len(im) == 2 for im in images)
        assert len(set(images)) == 3
        # do the three order-2 subgroups generate S3?
        gen = set()
        for im in images:
            gen |= im
        clos = set(gen)
        changed = True
        while changed:
            changed = False
            for u in list(clos):
                for v in list(clos):
                    w = cos(G.mul(next(iter(u)), next(iter(v))))
                    if w not in clos:
                        clos.add(w)
                        changed = True
        if clos == S3:
            e2_ok += 1
    log('    E2  C_G(sigma) cap N_G(V4) = V4 for each of the 3 V4s through')
    log('        sigma; their 3 images are distinct order-2 subgroups of the')
    log('        residual S3 and GENERATE it : %d/55' % e2_ok)
    assert e2_ok == 55

    # E3  ell_V cap L_sigma = empty
    bad = 0
    for V in V4s:
        gens = list(V)
        A = joint_fix(G, gens)                      # W^{V4}, dim 2 = ell_V
        assert len(A) == 2
        for s in invs:
            inter = rank([list(u) for u in A] + [list(u) for u in Wm[s]])
            if inter < 4:                           # dim(A + Wm) < 4 <=> meet
                bad += 1
    log('    E3  ell_V cap L_sigma = empty for all 55x55 pairs : %s'
        % (bad == 0))
    assert bad == 0

    # E4  X^{V4} and X^{A4}
    e4 = []
    for V in V4s[:55]:
        gens = list(V)
        A = joint_fix(G, gens)
        # the three isolated V4 points: the nontrivial character lines
        chars = []
        for s in gens:
            # W^{V4, chi} with chi(s) = 1 is A; the chi_i lines are the
            # joint eigenlines; get them as ker of the other two gens' (M-I)
            others = [t for t in gens if t != s]
            rows = []
            for t in others:
                M = G.mats[t]
                for i in range(5):
                    rows.append([M[i][j] + (ONE if i == j else ZERO)
                                 for j in range(5)])
            M = G.mats[s]
            for i in range(5):
                rows.append([M[i][j] - (ONE if i == j else ZERO)
                             for j in range(5)])
            L = nullspace(rows, 5)
            assert len(L) == 1
            chars.append(L[0])
        onX = [klein_eval(v).is_zero() for v in chars]
        # the two C3-eigenpoints of ell_V: fixed points of an order-3 element
        NV = [g for g in range(G.n) if {G.conj(t, g) for t in V} == set(V)]
        rho = next(g for g in NV if G.ord[g] == 3)
        # F on ell_V restricted; its roots are the type-II points
        # A4-fixed points of P^4 = the two rho-eigenlines inside A
        # (computed as eigenvectors of rho restricted to A)
        # -- we only need: they are OFF X.
        # restrict rho to A
        Ar = []
        for v in A:
            w = mat_vec(G.mats[rho], v)
            aug = [[A[0][i], A[1][i], w[i]] for i in range(5)]
            R, _ = rref(aug)
            sol = [ZERO, ZERO]
            for row in R:
                p = next((j for j in range(2) if not row[j].is_zero()), None)
                if p is not None:
                    sol[p] = row[2]
            Ar.append(sol)
        Ar = [[Ar[j][i] for j in range(2)] for i in range(2)]
        # eigenvalues are om, om^2 (not in Q(zeta11)); so instead check that
        # F restricted to ell_V is  alpha U^3 + beta V^3  in the eigenbasis
        # by the equivalent statement: F|_{ell_V} has NO root fixed by rho,
        # i.e. F|_{ell_V} and its rho-twist share no root.  We test the
        # equivalent, field-free statement: F|_{ell_V} is not divisible by any
        # rho-eigenvector, which holds iff  F|_{ell_V}  has 3 distinct roots
        # forming one free rho-orbit.  Certify by: disc != 0 and the two
        # rho-fixed points (which satisfy  v ^ rho v = 0) are not roots.
        # rho-fixed points on P(A): solve rank[v, rho v] = 1 -- a quadratic.
        # Its two roots are the A4-fixed points; check F != 0 there via the
        # resultant of that quadratic with F|_{ell_V}.
        import sympy as sp
        U, Vv = sp.symbols('U Vv')
        def cyc2sym(c):
            zz = sp.symbols('zz')
            return sum(sp.Integer(c.n[i]) * zz**i for i in range(len(c.n))) / c.d
        # F on ell_V as a binary cubic
        Fc = {}
        for i in range(4):
            pass
        # build symbolically
        zz = sp.symbols('zz')
        vec = [cyc2sym(A[0][i]) * U + cyc2sym(A[1][i]) * Vv for i in range(5)]
        Fb = sp.expand(sum(vec[k]**2 * vec[(k + 1) % 5] for k in range(5)))
        # rho on A in the (U,V) coordinates: matrix Ar
        M11, M12 = cyc2sym(Ar[0][0]), cyc2sym(Ar[0][1])
        M21, M22 = cyc2sym(Ar[1][0]), cyc2sym(Ar[1][1])
        # fixed points: (M11 U + M12 V) V - (M21 U + M22 V) U = 0
        Q = sp.expand((M11 * U + M12 * Vv) * Vv - (M21 * U + M22 * Vv) * U)
        phi = zz**10 + zz**9 + zz**8 + zz**7 + zz**6 + zz**5 + zz**4 + \
            zz**3 + zz**2 + zz + 1
        res = sp.resultant(sp.Poly(Fb, U, Vv).as_expr(),
                           sp.Poly(Q, U, Vv).as_expr(), U)
        res = sp.Poly(sp.expand(res), Vv).all_coeffs()
        nz = any(sp.rem(sp.Poly(sp.together(cc) * 1, zz), sp.Poly(phi, zz))
                 != 0 for cc in res if cc != 0)
        e4.append({'V4': list(V), 'three_vertices_on_X': onX,
                   'A4_fixed_points_off_X': bool(nz)})
        assert all(onX), onX
        assert nz
    log('    E4  the 3 isolated V4-points lie ON X (type-I vertices) and the')
    log('        2 A4-fixed points of ell_V lie OFF X (so X^{A4} = empty and')
    log('        the 3 type-II points form a FREE C3-orbit) : %d/55'
        % len(e4))

    os.makedirs(os.path.join(HERE, 'payloads'), exist_ok=True)
    with open(os.path.join(HERE, 'payloads', 'PAYLOAD_quotient_complex.txt'),
              'w') as f:
        f.write('\n'.join(LINES) + '\n')
    log('elapsed %.1f s' % (time.time() - T0))
    log('FIX_H0_PRODUCE_E_OK')


if __name__ == '__main__':
    main()
