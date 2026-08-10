#!/usr/bin/env python3
"""
Exact computation of X^sigma and X^{D8} for the Klein V22
X = { U in Gr(3,A) : U isotropic for the net N },  G = PSL(2,F_7).

sigma = an involution of G, N_G(<sigma>) = C_G(sigma) = D8 (Sylow 2-subgroup).

Structure used (all verified numerically below):
  A  = A_+ (dim 3) + A_- (dim 4)          sigma-eigenspaces
  N  = N_+ (dim 1) + N_- (dim 2)          sigma-eigenspaces
  a sigma-invariant form is block diagonal, a sigma-anti-invariant form is
  block off-diagonal.  Hence for U = U_+ + U_- (dim k, 3-k):
     k=3:  need  omega_0|A_+ = 0
     k=2:  need  omega_0|U_+ = 0  and  eta(U_+, v) = 0 for eta in N_-
     k=1:  need  omega_0|U_- = 0  and  eta(u, U_-) = 0 for eta in N_-
     k=0:  need  omega_0|U_- = 0
"""

from fractions import Fraction as Fr

from v22_klein_model import (
    K, ZERO, ONE, S, zeros, mat_mul, transpose, rref, rank, kernel, row_space,
    in_span, coords_in, canon, gmul, ginv, group, order, perm, rho,
    form_from_vec, vec_from_form, act_form, PAIRS, main as build_model,
)


def restrict(M, basis):
    """Matrix of the bilinear form M restricted to span(basis)."""
    B = transpose(basis)  # columns = basis vectors
    return mat_mul(transpose(B), mat_mul(M, B))


def apply_vec(M, v):
    return [sum((M[i][j] * v[j] for j in range(len(v))), K(0)) for i in range(len(M))]


def pair(M, u, v):
    return sum((u[i] * M[i][j] * v[j] for i in range(len(u)) for j in range(len(v))), K(0))


def pfaffian4(c):
    return c[0][1] * c[2][3] - c[0][2] * c[1][3] + c[0][3] * c[1][2]


def fmt(x):
    return repr(x)


def run():
    G, R, ords, Nb, Nvecs, perms = build_model()
    print()

    # ---------------------------------------------------------------- sigma and D8
    sigma = canon((0, -1, 1, 0))
    assert ords[sigma] == 2
    D8 = [g for g in G if gmul(g, sigma) == gmul(sigma, g)]
    assert len(D8) == 8
    from collections import Counter
    print("sigma =", sigma, "  |C_G(sigma)| =", len(D8),
          " element orders:", dict(sorted(Counter(ords[g] for g in D8).items())))
    assert dict(Counter(ords[g] for g in D8)) == {1: 1, 2: 5, 4: 2}, "C_G(sigma) is D8"

    r = next(g for g in D8 if ords[g] == 4)
    refl = [g for g in D8 if ords[g] == 2 and g != sigma]
    assert gmul(r, r) == sigma, "sigma is the centre of D8"
    s = refl[0]
    print("D8 = <r,s>, r of order 4 with r^2 = sigma, s =", s)

    # ---------------------------------------------------------------- A_+ , A_-
    I7 = [[ONE if i == j else ZERO for j in range(7)] for i in range(7)]
    Rs = R[sigma]
    Aplus = kernel([[Rs[i][j] - I7[i][j] for j in range(7)] for i in range(7)])
    Aminus = kernel([[Rs[i][j] + I7[i][j] for j in range(7)] for i in range(7)])
    print("dim A_+ =", len(Aplus), "  dim A_- =", len(Aminus))
    assert len(Aplus) == 3 and len(Aminus) == 4

    # simultaneous eigenbasis of A_+ for r and s (both act as involutions there)
    def act_on(sub, g):
        """matrix of g acting on the subspace spanned by `sub`."""
        cols = [coords_in(sub, apply_vec(R[g], b)) for b in sub]
        assert all(c is not None for c in cols)
        return transpose(cols)

    Mr = act_on(Aplus, r)
    Ms = act_on(Aplus, s)
    lines = []
    for er in (1, -1):
        for es in (1, -1):
            Mat = [[Mr[i][j] - (K(er) if i == j else ZERO) for j in range(3)] for i in range(3)]
            Mat += [[Ms[i][j] - (K(es) if i == j else ZERO) for j in range(3)] for i in range(3)]
            kb = kernel(Mat)
            if kb:
                assert len(kb) == 1
                vec = [sum((kb[0][i] * Aplus[i][t] for i in range(3)), K(0)) for t in range(7)]
                lines.append(((er, es), vec))
    print("D8-characters on A_+ (eps(r), eps(s)):", [c for c, _ in lines])
    assert len(lines) == 3 and (1, 1) not in [c for c, _ in lines]
    ell = [v for _, v in lines]
    chars = [c for c, _ in lines]

    # ---------------------------------------------------------------- N_+ , N_-
    def act_form_g(g, M):
        """genuine action (g.omega)(u,v) = omega(g^{-1}u, g^{-1}v)."""
        return act_form(R[ginv(g)], M)

    Amat = [vec_from_form(act_form_g(sigma, M)) for M in Nb]  # rows: images
    # solve in coordinates of Nb
    coordmat = transpose([coords_in(Nvecs, row) for row in Amat])  # matrix of sigma on N
    Nplus, Nminus = [], []
    for sign, store in ((1, Nplus), (-1, Nminus)):
        Mat = [[coordmat[i][j] - (K(sign) if i == j else ZERO) for j in range(3)] for i in range(3)]
        for kb in kernel(Mat):
            acc = zeros(7, 7)
            for i, c in enumerate(kb):
                for a in range(7):
                    for b in range(7):
                        acc[a][b] = acc[a][b] + c * Nb[i][a][b]
            store.append(acc)
    print("dim N_+ =", len(Nplus), "  dim N_- =", len(Nminus))
    assert len(Nplus) == 1 and len(Nminus) == 2
    om0 = Nplus[0]
    eta = Nminus

    # block structure check
    for u in Aplus:
        for v in Aminus:
            assert pair(om0, u, v).is_zero()
    for e in eta:
        for u in Aplus:
            for v in Aplus:
                assert pair(e, u, v).is_zero()
        for u in Aminus:
            for v in Aminus:
                assert pair(e, u, v).is_zero()
    print("block structure of N_+ / N_- w.r.t. A_+ + A_- verified")

    # D8-character of omega_0
    def char_of_form(M):
        out = {}
        for g in (r, s):
            Mg = act_form_g(g, M)
            c = None
            for i in range(7):
                for j in range(7):
                    if not M[i][j].is_zero():
                        c = Mg[i][j] / M[i][j]
                        break
                if c is not None:
                    break
            for i in range(7):
                for j in range(7):
                    assert (Mg[i][j] - c * M[i][j]).is_zero()
            out[g] = c
        return out
    co = char_of_form(om0)
    print("omega_0 transforms by eps(r) =", fmt(co[r]), ", eps(s) =", fmt(co[s]))

    # ---------------------------------------------------------------- stratum k=3
    om0_plus = restrict(om0, ell)
    print("\n[k=3]  omega_0 restricted to A_+ in the eigenbasis (l1,l2,l3):")
    for row in om0_plus:
        print("   ", [fmt(x) for x in row])
    rk_plus = rank(om0_plus)
    print("   rank =", rk_plus,
          "=> U = A_+ is", "ON X (D8-FIXED POINT!)" if rk_plus == 0 else "NOT on X")

    # radical of omega_0 on A_+
    rad = kernel(om0_plus)
    print("   radical of omega_0|A_+ = span of coordinate vector(s)",
          [[fmt(x) for x in v] for v in rad])

    # ---------------------------------------------------------------- stratum k=0
    om0_minus = restrict(om0, Aminus)
    rk_minus = rank(om0_minus)
    print("\n[k=0]  rank of omega_0 restricted to A_- =", rk_minus,
          "  Pfaffian =", fmt(pfaffian4(om0_minus)))
    if rk_minus == 4:
        print("   => no 3-dim subspace of A_- is isotropic: stratum EMPTY")
    else:
        print("   => stratum is POSITIVE-DIMENSIONAL (a P^1 of isotropic 3-spaces)")

    # ---------------------------------------------------------------- stratum k=1
    # u in P(A_+); phi_u : A_- -> K^2, v |-> (eta_1(u,v), eta_2(u,v)).
    def rows_of(u):
        return [[pair(e, u, b) for b in Aminus] for e in eta]

    def Qval(u):
        r1, r2 = rows_of(u)
        m = {}
        for i in range(4):
            for j in range(i + 1, 4):
                m[(i, j)] = r1[i] * r2[j] - r1[j] * r2[i]
        c = om0_minus
        return (c[0][1] * m[(2, 3)] - c[0][2] * m[(1, 3)] + c[0][3] * m[(1, 2)]
                + c[1][2] * m[(0, 3)] - c[1][3] * m[(0, 2)] + c[2][3] * m[(0, 1)])

    def lin(coeffs):
        return [sum((K(coeffs[i]) * ell[i][t] for i in range(3)), K(0)) for t in range(7)]

    q = {}
    for i in range(3):
        e = [0, 0, 0]
        e[i] = 1
        q[(i, i)] = Qval(lin(e))
    for i in range(3):
        for j in range(i + 1, 3):
            e = [0, 0, 0]
            e[i] = 1
            e[j] = 1
            q[(i, j)] = Qval(lin(e)) - q[(i, i)] - q[(j, j)]
    print("\n[k=1]  the conic Q(u) = omega_0 ^ eta_1(u,.) ^ eta_2(u,.) on P(A_+):")
    terms = []
    for (i, j), v in sorted(q.items()):
        if not v.is_zero():
            terms.append(f"({fmt(v)})*u{i+1}{'^2' if i == j else f'*u{j+1}'}")
    print("   Q =", " + ".join(terms) if terms else "0")
    diag_only = all(v.is_zero() for (i, j), v in q.items() if i != j)
    print("   diagonal (D8-invariant) form:", diag_only)
    nz = [ (i,i) for i in range(3) if not q[(i,i)].is_zero() ]
    conic_rank = rank([[q[(min(i,j),max(i,j))] * (ONE if i == j else K(Fr(1,2)))
                        for j in range(3)] for i in range(3)])
    print("   rank of the conic's symmetric matrix =", conic_rank,
          "=> ", {3: "SMOOTH conic (rational curve, D8-stable)",
                  2: "two distinct lines meeting in a D8-fixed point",
                  1: "double line", 0: "the whole plane"}[conic_rank])

    # rank of phi_u : is it 2 everywhere on P(A_+)?
    print("   rank of phi_u at the three D8-eigenpoints:",
          [rank(rows_of(lin([1 if t == i else 0 for t in range(3)]))) for i in range(3)])
    # 2x2 minors of the 2x4 matrix, as quadrics in u -- exported for M2
    minors = []
    for i in range(4):
        for j in range(i + 1, 4):
            coeffs = {}
            def mij(u):
                r1, r2 = rows_of(u)
                return r1[i] * r2[j] - r1[j] * r2[i]
            for a in range(3):
                e = [0, 0, 0]
                e[a] = 1
                coeffs[(a, a)] = mij(lin(e))
            for a in range(3):
                for b in range(a + 1, 3):
                    e = [0, 0, 0]
                    e[a] = 1
                    e[b] = 1
                    coeffs[(a, b)] = mij(lin(e)) - coeffs[(a, a)] - coeffs[(b, b)]
            minors.append(coeffs)

    # ---------------------------------------------------------------- stratum k=2
    # U_+ must be isotropic for omega_0|A_+ : since that form has rank 2 with
    # radical the line rad, the isotropic 2-planes are exactly rad + <m>.
    print("\n[k=2]")
    assert rk_plus == 2, "k=2 analysis assumes rank(omega_0|A_+) = 2"
    radv = [sum((rad[0][i] * ell[i][t] for i in range(3)), K(0)) for t in range(7)]
    radchar = chars[[i for i in range(3) if not rad[0][i].is_zero()][0]]
    print("   radical line of omega_0|A_+ has D8-character", radchar)
    others = [i for i in range(3) if rad[0][i].is_zero()]
    print("   pencil parameter m = m1*l_%d + m2*l_%d" % (others[0] + 1, others[1] + 1))

    def detk2(mcoef):
        m = [sum((K(mcoef[t]) * ell[others[t]][x] for t in range(2)), K(0)) for x in range(7)]
        M = rows_of(radv) + rows_of(m)
        return M

    def det4(M):
        # exact 4x4 determinant by expansion
        from itertools import permutations
        tot = K(0)
        for p in permutations(range(4)):
            sgn = 1
            pl = list(p)
            for a in range(4):
                for b in range(a + 1, 4):
                    if pl[a] > pl[b]:
                        sgn = -sgn
            term = K(sgn)
            for a in range(4):
                term = term * M[a][p[a]]
            tot = tot + term
        return tot

    d = {}
    d[(0, 0)] = det4(detk2([1, 0]))
    d[(1, 1)] = det4(detk2([0, 1]))
    d[(0, 1)] = det4(detk2([1, 1])) - d[(0, 0)] - d[(1, 1)]
    terms = []
    for (i, j), v in sorted(d.items()):
        if not v.is_zero():
            terms.append(f"({fmt(v)})*m{i+1}{'^2' if i == j else f'*m{j+1}'}")
    print("   4x4 determinant as a binary quadratic in m:", " + ".join(terms) if terms else "0")
    disc = d[(0, 1)] * d[(0, 1)] - K(4) * d[(0, 0)] * d[(1, 1)]
    print("   discriminant =", fmt(disc))
    if d[(0, 0)].is_zero() or d[(1, 1)].is_zero():
        print("   => a root is a D8-eigenpoint: the corresponding point of X^sigma is D8-FIXED")
    else:
        print("   => the two roots are NOT D8-eigenpoints (m1^2, m2^2 both present)")
        print("      the two points of the k=2 stratum are SWAPPED by D8 (no D8-fixed point here)")

    # solve for the actual points
    print("   points of the k=2 stratum (as m-ratios, over K or a quadratic ext.):")
    if not d[(0, 0)].is_zero() and d[(0, 1)].is_zero():
        print("      m2^2/m1^2 = ", fmt(K(-1) * d[(0, 0)] / d[(1, 1)]),
              " (two conjugate points, swapped by any g in D8 with eps_%d(g) != eps_%d(g))"
              % (others[0] + 1, others[1] + 1))

    return dict(q=q, d=d, conic_rank=conic_rank, chars=chars, radchar=radchar,
                rk_plus=rk_plus, rk_minus=rk_minus, minors=minors,
                lines=lines, others=others)


if __name__ == "__main__":
    out = run()
