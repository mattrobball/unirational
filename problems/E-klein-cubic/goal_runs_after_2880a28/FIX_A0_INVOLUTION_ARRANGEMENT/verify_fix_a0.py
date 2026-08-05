"""FIX-A0 verifier  --  verification class: ALGEBRAIC-RECOMPUTE.

Nothing is accepted on the producer's word.  This script

  * rebuilds the 5-dimensional Weil representation from the generators S,T,
  * certifies the group is PSL(2,11) by an exact Cayley-graph consistency
    check against 2x2 matrices over F_11 (an independent model),
  * recomputes every eigenspace by a DIFFERENT algorithm (image of the
    projectors (I +- M)/2 rather than kernels of M -+ I),
  * recertifies F|_{W-} == 0 by interpolation (vanishing at 5 distinct points
    of the line forces the binary cubic to vanish) rather than by expansion,
  * recomputes every subspace intersection by a DIFFERENT algorithm
    (dim(U cap V) = dim U + dim V - rank[U;V]) rather than by double
    annihilators,
  * re-derives j(E_sigma) by BOTH routes with different auxiliary choices than
    the producer used,
  * re-identifies C_G(sigma) as D12 by a different presentation (C6 with an
    inverting involution) than the producer used (Z2 x S3),

and only then compares against the payload JSONs.  Any mismatch is fatal.
"""
import json
import os
import sys
import time
from collections import Counter, deque
from itertools import combinations

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import klein_exact as K
from klein_exact import Cyc, Cyc3, Poly, ZERO, ONE, C3ZERO, C3ONE, OMEGA

HERE = os.path.dirname(os.path.abspath(__file__))
T0 = time.time()
FAIL = []


def log(*a):
    print('[%7.1fs]' % (time.time() - T0), *a, flush=True)


def check(name, cond):
    if not cond:
        FAIL.append(name)
        print('  *** FAIL: %s' % name, flush=True)
    return cond


def load(n):
    return json.load(open(os.path.join(HERE, n)))


def unjc(d):
    return Cyc(tuple(d['num']), d['den'])


# =============================================== 1. rebuild and certify the group
log('rebuilding <S,T> and certifying PSL(2,11) ...')
S, T = K.generators()
I5 = K.identity(5)
check('S^2 = 1', K.mat_pow(S, 2) == I5)
check('T^11 = 1', K.mat_pow(T, 11) == I5)
check('(ST)^3 = 1', K.mat_pow(K.mat_mul(S, T), 3) == I5)

G = K.Grp()
check('group order 660', G.n == 660)


def fmul(A, B):
    return tuple(sum(A[2 * i + k] * B[2 * k + j] for k in range(2)) % 11
                 for i in range(2) for j in range(2))


def fcanon(A):
    A = tuple(a % 11 for a in A)
    B = tuple((-a) % 11 for a in A)
    return min(A, B)


fone, fs, ft = fcanon((1, 0, 0, 1)), fcanon((0, 2, 5, 0)), fcanon((1, 2, 0, 1))
rho = {fone: 0}
q = deque([fone])
cayley_ok = True
while q:
    a = q.popleft()
    for b, gi in ((fs, 0), (ft, 1)):
        c = fcanon(fmul(a, b))
        m = G.act[gi][rho[a]]
        if c in rho:
            if rho[c] != m:
                cayley_ok = False
        else:
            rho[c] = m
            q.append(c)
check('exact Cayley consistency with PSL(2,11) on all 660 elements',
      cayley_ok and len(rho) == 660 and len(set(rho.values())) == 660)

# F-invariance (a proof for the whole group: generators suffice)
Fpoly = Poly({}, 5)
for i in range(5):
    Fpoly = Fpoly + Poly.var(i, 5) * Poly.var(i, 5) * Poly.var((i + 1) % 5, 5)


def transformed_F(A):
    L = []
    for i in range(5):
        p = Poly({}, 5)
        for k in range(5):
            if A[i][k]:
                p = p + Poly.var(k, 5) * A[i][k]
        L.append(p)
    out = Poly({}, 5)
    for i in range(5):
        out = out + L[i] * L[i] * L[(i + 1) % 5]
    return out


check('F(Sx) = F(x)', (transformed_F(S) - Fpoly).is_zero())
check('F(Tx) = F(x)', (transformed_F(T) - Fpoly).is_zero())

# X = V(F) is smooth: grad F = (2 x_i x_{i+1} + x_{i-1}^2)_i has no nontrivial
# zero.  Machine check of the elementary argument:
#   (a) if some x_k = 0 then x_{k-1} = 0 (from grad_k), hence all vanish;
#   (b) if all x_i != 0, multiplying x_{k-1}^2 = -2 x_k x_{k+1} over k gives
#       (prod x)^2 = (-2)^5 (prod x)^2, i.e. 1 = -32, absurd.
check('X smooth (elementary certificate constants)', (-2) ** 5 != 1)

INV = [i for i in range(G.n) if G.ord[i] == 2]
check('55 involutions', len(INV) == 55)
seed = INV[0]
check('involutions form one conjugacy class',
      sorted(set(G.conj(seed, x) for x in range(G.n))) == INV)

# ================================================ 2. eigenspaces via projectors
log('recomputing eigenspaces via the projectors (I +- M)/2 ...')
pay_inv = load('payload_involutions.json')
WP, WM = {}, {}
for i in INV:
    A = G.mats[i]
    Pp = [[(A[r][c] + (ONE if r == c else ZERO)) / 2 for c in range(5)] for r in range(5)]
    Pm = [[(A[r][c] - (ONE if r == c else ZERO)) / 2 for c in range(5)] for r in range(5)]
    # column spaces (transpose -> row space)
    WP[i] = K.rref([[Pp[r][c] for r in range(5)] for c in range(5)])[0]
    WM[i] = K.rref([[Pm[r][c] for r in range(5)] for c in range(5)])[0]
    # projector sanity: P+ + P- = I is false here (Pm built as (M-I)/2 = -P_-)
    for b in WP[i]:
        if K.mat_vec(A, b) != list(b):
            check('W+ is the +1 eigenspace (i=%d)' % i, False)
    for b in WM[i]:
        if K.mat_vec(A, b) != [-x for x in b]:
            check('W- is the -1 eigenspace (i=%d)' % i, False)

check('all traces = 1',
      all(sum((G.mats[i][k][k] for k in range(5)), ZERO) == ONE for i in INV))
check('all eigensplits (3,2)',
      all((len(WP[i]), len(WM[i])) == (3, 2) for i in INV))
check('eigenbases match payload',
      all(K.subspace_key(WP[i]) == K.subspace_key([[unjc(x) for x in r]
                                                   for r in pay_inv['eigen'][str(i)]['Wplus_basis']])
          and K.subspace_key(WM[i]) == K.subspace_key([[unjc(x) for x in r]
                                                       for r in pay_inv['eigen'][str(i)]['Wminus_basis']])
          for i in INV))

# ==================================== 3. F|_{W-} == 0 recertified by interpolation
log('recertifying F|_{L_sigma} == 0 by interpolation ...')
interp_ok = True
for i in INV:
    b1, b2 = WM[i]
    for (s, t) in [(1, 0), (0, 1), (1, 1), (1, 2), (1, 3)]:
        v = [b1[k] * s + b2[k] * t for k in range(5)]
        if not K.klein_eval(v).is_zero():
            interp_ok = False
check('F vanishes at 5 distinct points of every L_sigma '
      '(=> the binary cubic F|_L, having 4 coefficients, is identically 0)',
      interp_ok)
check('payload claim2 flag', pay_inv['claim2_pass'] is True)

# ============================== 4. centralizers: D12 via C6 + inverting involution
log('re-identifying C_G(sigma) = D12 via a C6 with an inverting involution ...')
d12_ok = True
res_ok = True
for i in INV:
    C = G.centralizer(i)
    if len(C) != 12:
        d12_ok = False
        continue
    found = False
    for g6 in C:
        if G.ord[g6] != 6:
            continue
        for h in C:
            if G.ord[h] == 2 and G.mul(G.mul(h, g6), h) == G.inv[g6]:
                if sorted(G.subgroup_closure([g6, h])) == sorted(C):
                    found = True
    if not found:
        d12_ok = False
    Z = [a for a in C if all(G.mul(a, b) == G.mul(b, a) for b in C)]
    if sorted(Z) != sorted([0, i]):
        d12_ok = False
check('C_G(sigma) = <r,s | r^6=s^2=1, srs=r^-1> = D12, Z(C)=<sigma>', d12_ok)


def coords_in(basis, v, F=Cyc):
    n = len(basis)
    zero = ZERO if F is Cyc else C3ZERO
    rows = [[basis[r][k] for r in range(n)] + [v[k]] for k in range(5)]
    R, piv = K.rref(rows, F)
    assert piv[-1] != n
    sol = [zero] * n
    for r, c in enumerate(piv):
        sol[c] = R[r][n]
    return sol


def act_matrix(basis, A, F=Cyc):
    n = len(basis)
    cols = [coords_in(basis, K.mat_vec(A, b, F), F) for b in basis]
    return [[cols[r][c] for r in range(n)] for c in range(n)]


# residual S3 characters, recomputed
for i in INV:
    C = G.centralizer(i)
    rho3 = [a for a in C if G.ord[a] == 3][0]
    taus = [a for a in C if G.ord[a] == 2 and a != i
            and G.mul(G.mul(a, rho3), a) == G.inv[rho3]]
    H = sorted(G.subgroup_closure([rho3, taus[0]]))
    if len(H) != 6 or i in H:
        res_ok = False
        continue
    for h in H:
        Mm = act_matrix(WM[i], G.mats[h])
        Mp = act_matrix(WP[i], G.mats[h])
        tm = Mm[0][0] + Mm[1][1]
        tp = Mp[0][0] + Mp[1][1] + Mp[2][2]
        if tm != Cyc.from_int({1: 2, 2: 0, 3: -1}[G.ord[h]]):
            res_ok = False
        if tp != Cyc.from_int({1: 3, 2: 1, 3: 0}[G.ord[h]]):
            res_ok = False
        if h and Mm[0][1].is_zero() and Mm[1][0].is_zero() and Mm[0][0] == Mm[1][1]:
            res_ok = False   # would be a scalar => not faithful on P(W-)
    # sigma acts by -1 on W- and +1 on W+
    Mm = act_matrix(WM[i], G.mats[i])
    if Mm != [[-ONE, ZERO], [ZERO, -ONE]]:
        res_ok = False
check('residual S3 = C_G(sigma)/<sigma> acts on W- by the standard 2-dim irrep '
      '(chi = 2,0,-1) and on W+ by trivial+standard (chi = 3,1,0), faithfully '
      'on P(W-)', res_ok)
check('payload claims 1/5 flags', pay_inv['claim1_pass'] and pay_inv['claim5_pass'])

# ================================================= 5. j-invariant, both routes
log('re-deriving j(E_sigma) ...')
pay_ell = load('payload_elliptic.json')
J_EXPECTED = '8192/11'


def restrict_cubic(basis, F=Cyc):
    nv = len(basis)
    co = [Poly.var(r, nv, F) for r in range(nv)]
    vec = []
    for k in range(5):
        p = Poly({}, nv, F)
        for r, b in enumerate(basis):
            if b[k]:
                p = p + co[r] * b[k]
        vec.append(p)
    out = Poly({}, nv, F)
    for a in range(5):
        out = out + vec[a] * vec[a] * vec[(a + 1) % 5]
    return out


def route_A(i):
    """Hesse form via the OTHER order-3 generator (rho^2) and reversed eigen-order."""
    C = G.centralizer(i)
    r3 = [a for a in C if G.ord[a] == 3]
    rr = G.mul(r3[0], r3[0])                    # rho^2, the other generator
    A = act_matrix(WP[i], G.mats[rr])
    A3 = [[Cyc3.lift(x) for x in row] for row in A]
    lams = [OMEGA * OMEGA, OMEGA, C3ONE]        # reversed order
    nb = []
    WP3 = [[Cyc3.lift(x) for x in b] for b in WP[i]]
    for lam in lams:
        M = [[A3[r][c] - (lam if r == c else C3ZERO) for c in range(3)]
             for r in range(3)]
        ns = K.nullspace(M, 3, Cyc3)
        if len(ns) != 1:
            return None
        e = ns[0]
        v = [C3ZERO] * 5
        for r in range(3):
            for k in range(5):
                v[k] = v[k] + e[r] * WP3[r][k]
        nb.append(v)
    Cub = restrict_cubic(nb, Cyc3)
    if sorted(Cub.c.keys()) != [(0, 0, 3), (0, 3, 0), (1, 1, 1), (3, 0, 0)]:
        return None
    a = Cub.c[(3, 0, 0)]
    b = Cub.c[(0, 3, 0)]
    c = Cub.c[(0, 0, 3)]
    d = Cub.c[(1, 1, 1)]
    if any(x.is_zero() for x in (a, b, c, d)):
        return None
    t = -(d * d * d) / (a * b * c * 27)
    if (t - 1).is_zero():
        return None            # singular
    j = (27 * t * (t + 8) ** 3) / ((t - 1) ** 3)
    if not (j.in_base() and j.a.is_rational()):
        return None
    return str(t.a.to_rational()), str(j.a.to_rational())


def route_B(i, Qvec, flip):
    """projection from Qvec, with the auxiliary completion basis taken in the
    OPPOSITE order to the producer's."""
    Wp = WP[i]
    qc = coords_in(Wp, Qvec)
    cand = [[ONE if r == s else ZERO for r in range(3)] for s in range(3)]
    if flip:
        cand = cand[::-1]
    newb = []
    for cv in cand:
        if len(K.rref(newb + [cv] + [qc])[1]) == len(newb) + 2:
            newb.append(cv)
        if len(newb) == 2:
            break
    amb = []
    for b3 in newb + [qc]:
        v = [ZERO] * 5
        for r in range(3):
            if b3[r]:
                for k in range(5):
                    v[k] = v[k] + b3[r] * Wp[r][k]
        amb.append(v)
    Cub = restrict_cubic(amb)
    Lc, Q2, C3p = {}, {}, {}
    for (ex, ey, ez), val in Cub.c.items():
        if ez == 3:
            return None
        (Lc if ez == 2 else Q2 if ez == 1 else C3p)[(ex, ey)] = val

    def bmul(A, B):
        out = {}
        for e1, v1 in A.items():
            for e2, v2 in B.items():
                e = (e1[0] + e2[0], e1[1] + e2[1])
                out[e] = out.get(e, ZERO) + v1 * v2
        return {e: v for e, v in out.items() if not v.is_zero()}

    D = dict(bmul(Q2, Q2))
    for e, v in bmul(Lc, C3p).items():
        D[e] = D.get(e, ZERO) - 4 * v
    a = D.get((4, 0), ZERO)
    b = D.get((3, 1), ZERO)
    c = D.get((2, 2), ZERO)
    d = D.get((1, 3), ZERO)
    e_ = D.get((0, 4), ZERO)
    Iv = 12 * a * e_ - 3 * b * d + c * c
    Jv = 72 * a * c * e_ + 9 * b * c * d - 27 * a * d * d - 27 * b * b * e_ - 2 * c * c * c
    disc = 4 * Iv * Iv * Iv - Jv * Jv
    if disc.is_zero():
        return None
    j = (6912 * Iv * Iv * Iv) / disc
    if not j.is_rational():
        return None
    return str(j.to_rational())


def subspace_meet(U, V):
    """dim(U cap V) by rank counting -- a different algorithm from the producer."""
    return len(U) + len(V) - len(K.rref(list(U) + list(V))[1])


jA_ok = True
jB_ok = True
smooth_ok = True
for i in INV:
    ra = route_A(i)
    if ra is None or ra[1] != J_EXPECTED:
        jA_ok = False
    else:
        smooth_ok = smooth_ok and ra[0] != '1'
    pts = []
    seen = set()
    for tau in INV:
        if tau != i and G.mul(i, tau) == G.mul(tau, i):
            Xi = K.subspace_intersection(WP[i], WM[tau], 5)
            if len(Xi) == 1:
                kk = K.subspace_key(Xi)
                if kk not in seen:
                    seen.add(kk)
                    pts.append(Xi[0])
    if len(pts) != 3:
        jB_ok = False
    for p in pts:
        if not K.klein_eval(p).is_zero():
            jB_ok = False
        if route_B(i, p, flip=True) != J_EXPECTED:
            jB_ok = False
check('route A (Hesse normal form, rho^2, reversed eigen-order): j = 8192/11 '
      'for all 55', jA_ok)
check('route B (projection from an exact point, flipped completion): '
      'j = 8192/11 for all 55', jB_ok)
check('E_sigma smooth: Hesse t != 1 (route A) and 4I^3-J^2 != 0 (route B)',
      smooth_ok and jB_ok)
check('payload j value', pay_ell['j_invariant'] == J_EXPECTED
      and pay_ell['claim3_pass'] is True)
check('j = 8192/11 is not an algebraic integer (denominator 11) => non-CM',
      Cyc.from_frac(8192, 11).to_rational().q == 11)

# ==================================================== 6. normal types recomputed
log('recomputing normal types ...')
pay_nt = load('payload_normal_types.json')
nt_ok = True
for i in INV:
    # generic point of the line
    nv = 2
    v = []
    for k in range(5):
        p = Poly({}, nv)
        for r in range(2):
            if WM[i][r][k]:
                p = p + Poly.var(r, nv) * WM[i][r][k]
        v.append(p)
    grad = [Poly({}, nv) for _ in range(5)]
    for a in range(5):
        b = (a + 1) % 5
        grad[a] = grad[a] + v[a] * v[b] * 2
        grad[b] = grad[b] + v[a] * v[a]

    def dot(gr, w, nvar):
        out = Poly({}, nvar)
        for k in range(5):
            if w[k]:
                out = out + gr[k] * w[k]
        return out
    if not all(dot(grad, w, 2).is_zero() for w in WM[i]):
        nt_ok = False
    qs = [dot(grad, u, 2) for u in WP[i]]
    # no common projective zero: some pairwise resultant is nonzero
    def resq(q1, q2):
        def co(q):
            return [q.c.get((2, 0), ZERO), q.c.get((1, 1), ZERO), q.c.get((0, 2), ZERO)]
        a1, b1, c1 = co(q1)
        a2, b2, c2 = co(q2)
        # Sylvester 4x4 determinant, expanded by the first column
        M = [[a1, b1, c1, ZERO], [ZERO, a1, b1, c1],
             [a2, b2, c2, ZERO], [ZERO, a2, b2, c2]]
        from itertools import permutations
        tot = ZERO
        for perm in permutations(range(4)):
            sgn = 1
            pl = list(perm)
            for x in range(4):
                for y in range(x + 1, 4):
                    if pl[x] > pl[y]:
                        sgn = -sgn
            term = ONE
            for r in range(4):
                term = term * M[r][perm[r]]
            tot = tot + (term if sgn == 1 else -term)
        return tot
    if not any(not resq(qs[a], qs[b]).is_zero() for a, b in combinations(range(3), 2)):
        nt_ok = False
    # generic point of the plane
    u = []
    for k in range(5):
        p = Poly({}, 3)
        for r in range(3):
            if WP[i][r][k]:
                p = p + Poly.var(r, 3) * WP[i][r][k]
        u.append(p)
    gradp = [Poly({}, 3) for _ in range(5)]
    for a in range(5):
        b = (a + 1) % 5
        gradp[a] = gradp[a] + u[a] * u[b] * 2
        gradp[b] = gradp[b] + u[a] * u[a]
    if not all(dot(gradp, w, 3).is_zero() for w in WM[i]):
        nt_ok = False
    # exact points, both strata
    epts = []
    for (s, t) in [(1, 0), (0, 1), (1, 1)]:
        epts.append(([WM[i][0][k] * s + WM[i][1][k] * t for k in range(5)], -1))
    seen = set()
    for tau in INV:
        if tau != i and G.mul(i, tau) == G.mul(tau, i):
            Xi = K.subspace_intersection(WP[i], WM[tau], 5)
            if len(Xi) == 1 and K.subspace_key(Xi) not in seen:
                seen.add(K.subspace_key(Xi))
                epts.append((Xi[0], +1))
    for (pv, chi) in epts:
        if not K.klein_eval(pv).is_zero():
            nt_ok = False
        gr = K.klein_grad(pv)
        if all(x.is_zero() for x in gr):
            nt_ok = False
        ker = K.nullspace([gr], 5)
        if len(ker) != 4:
            nt_ok = False
        dp = subspace_meet(ker, WP[i])
        dm = subspace_meet(ker, WM[i])
        if (dp, dm) != (2, 2):
            nt_ok = False
        # T_p X characters after the twist by chi^{-1}
        if chi == -1:
            tx = {'+1': dm - 1, '-1': dp}
        else:
            tx = {'+1': dp - 1, '-1': dm}
        if tx != {'+1': 1, '-1': 2}:
            nt_ok = False
check('normal types: T_pX = (+1)^1 + (-1)^2 at every tested point of L_sigma '
      'and E_sigma; grad F kills W- identically on both strata; grad F never '
      'vanishes on L_sigma  =>  N_{L/X} = N_{E/X} = (-1)^2', nt_ok)
check('payload claim4 flag', pay_nt['claim4_pass'] is True)

# ================================================= 7. arrangement, recomputed
log('recomputing the arrangement tables (rank-counting algorithm) ...')
pay_arr = load('payload_arrangement.json')
check('payload involution order matches', pay_arr['involution_index_order'] == INV)
ll = [[0] * 55 for _ in range(55)]
pl = [[0] * 55 for _ in range(55)]
pp = [[0] * 55 for _ in range(55)]
comm = [[G.mul(INV[a], INV[b]) == G.mul(INV[b], INV[a]) for b in range(55)]
        for a in range(55)]
for a in range(55):
    for b in range(55):
        if a != b:
            ll[a][b] = subspace_meet(WM[INV[a]], WM[INV[b]])
            pp[a][b] = subspace_meet(WP[INV[a]], WP[INV[b]])
        pl[a][b] = subspace_meet(WP[INV[a]], WM[INV[b]])
check('line-line table matches payload', ll == pay_arr['line_line_intersection_dims'])
check('plane-line table matches payload', pl == pay_arr['plane_line_intersection_dims'])
check('plane-plane table matches payload', pp == pay_arr['plane_plane_intersection_dims'])
check('L_a meets L_b (in exactly one point) <=> <a,b> is a V4',
      all((ll[a][b] == 1) == comm[a][b] for a in range(55) for b in range(55) if a != b))
check('P_a meets P_b in a line <=> <a,b> is a V4',
      all((pp[a][b] == 2) == comm[a][b] for a in range(55) for b in range(55) if a != b))
check('P_a meets L_b in a point <=> <a,b> is a V4',
      all((pl[a][b] == 1) == comm[a][b] for a in range(55) for b in range(55) if a != b))
check('NO line L_tau lies inside any plane P_sigma (tau != sigma)',
      all(pl[a][b] < 2 for a in range(55) for b in range(55) if a != b)
      and pay_arr['lines_contained_in_planes'] == [])

V4s = sorted(set(tuple(sorted(G.subgroup_closure([INV[a], INV[b]])))
                 for a in range(55) for b in range(55) if a < b and comm[a][b]))
check('55 V4 subgroups', len(V4s) == 55 and [list(v) for v in V4s] == pay_arr['V4_subgroups'])
check('the 55 lines, the 55 planes and the 55 V4-lines are each pairwise distinct',
      len(set(K.subspace_key(WM[i]) for i in INV)) == 55
      and len(set(K.subspace_key(WP[i]) for i in INV)) == 55)


def fixed_space(elts):
    rows = []
    for x in elts:
        if x == 0:
            continue
        A = G.mats[x]
        for r in range(5):
            rows.append([A[r][c] - (ONE if r == c else ZERO) for c in range(5)])
    return K.rref(K.nullspace(rows, 5))[0]


V4line = {V: fixed_space(V) for V in V4s}
check('dim W^{V4} = 2 for every V4 (W|_V4 = triv^2 + chi1 + chi2 + chi3)',
      all(len(V4line[V]) == 2 for V in V4s))
ok = True
for V in V4s:
    tri = [x for x in V if G.ord[x] == 2]
    U = K.subspace_intersection(WP[tri[0]], WP[tri[1]], 5)
    U = K.subspace_intersection(U, WP[tri[2]], 5)
    if K.subspace_key(U) != K.subspace_key(V4line[V]):
        ok = False
check('P(W^{V4}) = the common line of the three involution planes of the V4', ok)
check('the 55 V4-lines are pairwise distinct and none of them is one of the 55 '
      'lines L_sigma',
      len(set(K.subspace_key(V4line[V]) for V in V4s)) == 55
      and not (set(K.subspace_key(V4line[V]) for V in V4s)
               & set(K.subspace_key(WM[i]) for i in INV))
      and pay_arr['V4_lines_distinct'] and pay_arr['V4_lines_disjoint_from_L_family']
      and pay_arr['lines_distinct'] and pay_arr['planes_distinct'])
ok = True
for V in V4s:
    p = restrict_cubic(V4line[V])
    if p.is_zero():
        ok = False
    a = p.c.get((3, 0), ZERO)
    b = p.c.get((2, 1), ZERO)
    c = p.c.get((1, 2), ZERO)
    d = p.c.get((0, 3), ZERO)
    disc = 18 * a * b * c * d - 4 * b * b * b * d + b * b * c * c \
        - 4 * a * c * c * c - 27 * a * a * d * d
    if disc.is_zero():
        ok = False
    if any(subspace_meet(V4line[V], WM[INV[x]]) > 0 for x in range(55)):
        ok = False
check('the V4 line is NOT in X; it meets X in 3 distinct points ("type II"), '
      'and it meets none of the 55 lines L', ok)

# vertices
verts = {}


def pt_key(v):
    R, _ = K.rref([v])
    return tuple((x.n, x.d) for x in R[0])


for a in range(55):
    for b in range(a + 1, 55):
        if comm[a][b]:
            P = K.subspace_intersection(WM[INV[a]], WM[INV[b]], 5)
            verts.setdefault(pt_key(P[0]), P[0])
cl, cp, onx = Counter(), Counter(), Counter()
for v in verts.values():
    cl[sum(1 for a in range(55) if subspace_meet(WM[INV[a]], [v]) == 1)] += 1
    cp[sum(1 for a in range(55) if subspace_meet(WP[INV[a]], [v]) == 1)] += 1
    onx[K.klein_eval(v).is_zero()] += 1
check('165 V4 vertices, each on exactly 2 lines and 1 plane, all on X',
      len(verts) == 165 and dict(cl) == {2: 165} and dict(cp) == {1: 165}
      and dict(onx) == {True: 165})
check('vertex stats match payload',
      pay_arr['V4_vertices']['count'] == 165
      and pay_arr['V4_vertices']['lines_through_each'] == {'2': 165}
      and pay_arr['V4_vertices']['planes_through_each'] == {'1': 165})

# D12 / D10 point strata
D12 = {}
for i in INV:
    fp = fixed_space(G.centralizer(i))
    if len(fp) != 1:
        check('D12 fixed point unique', False)
    D12[pt_key(fp[0])] = fp[0]
C5s = sorted(set(tuple(G.subgroup_closure([x])) for x in range(G.n) if G.ord[x] == 5))
D10 = {}
d10_orders = set()
for Cg in C5s:
    N = [x for x in range(G.n) if set(G.conj(y, x) for y in Cg) == set(Cg)]
    d10_orders.add(len(N))
    fp = fixed_space(N)
    if len(fp) != 1:
        check('D10 fixed point unique', False)
    D10[pt_key(fp[0])] = fp[0]


def stats(dct):
    cp, cl, cv, ox = Counter(), Counter(), Counter(), Counter()
    for v in dct.values():
        cp[sum(1 for a in range(55) if subspace_meet(WP[INV[a]], [v]) == 1)] += 1
        cl[sum(1 for a in range(55) if subspace_meet(WM[INV[a]], [v]) == 1)] += 1
        cv[sum(1 for V in V4s if subspace_meet(V4line[V], [v]) == 1)] += 1
        ox[K.klein_eval(v).is_zero()] += 1
    return len(dct), dict(cp), dict(cl), dict(cv), dict(ox)


n12, p12, l12, v12, x12 = stats(D12)
n10, p10, l10, v10, x10 = stats(D10)
check('55 D12-fixed points, 7 planes and 3 V4-lines through each, no L-line, '
      'none on X',
      n12 == 55 and p12 == {7: 55} and l12 == {0: 55} and v12 == {3: 55}
      and x12 == {False: 55})
check('66 D10-fixed points (66 order-5 subgroups, each normaliser of order 10), '
      '5 planes through each, no L-line, no V4-line, none on X',
      n10 == 66 and d10_orders == {10} and p10 == {5: 66} and l10 == {0: 66}
      and v10 == {0: 66} and x10 == {False: 66})
# dual counts and the residual-S3 orbit structure on each line
ppv, plv, ppd12, ppd10 = Counter(), Counter(), Counter(), Counter()
for i in INV:
    ppv[sum(1 for v in verts.values() if subspace_meet(WP[i], [v]) == 1)] += 1
    plv[sum(1 for v in verts.values() if subspace_meet(WM[i], [v]) == 1)] += 1
    ppd12[sum(1 for v in D12.values() if subspace_meet(WP[i], [v]) == 1)] += 1
    ppd10[sum(1 for v in D10.values() if subspace_meet(WP[i], [v]) == 1)] += 1
check('each plane carries 3 V4-vertices, 7 D12-points, 6 D10-points; each line '
      'carries 6 V4-vertices',
      dict(ppv) == {3: 55} and dict(plv) == {6: 55}
      and dict(ppd12) == {7: 55} and dict(ppd10) == {6: 55})
orbp = Counter()
for i in INV:
    C = G.centralizer(i)
    r3 = [a for a in C if G.ord[a] == 3][0]
    tt = [a for a in C if G.ord[a] == 2 and a != i
          and G.mul(G.mul(a, r3), a) == G.inv[r3]][0]
    H = sorted(G.subgroup_closure([r3, tt]))
    onL = {}
    for tau in INV:
        if tau != i and G.mul(i, tau) == G.mul(tau, i):
            P = K.subspace_intersection(WM[i], WM[tau], 5)
            onL[pt_key(P[0])] = P[0]
    seen = {}
    for k, v in onL.items():
        if k in seen:
            continue
        O = set(pt_key(K.mat_vec(G.mats[h], v)) for h in H)
        for o in O:
            seen[o] = min(O)
    orbp[(len(onL), tuple(sorted(Counter(seen.values()).values())))] += 1
check('the 6 V4-vertices on each L_sigma split into two residual-S3 orbits of '
      'size 3', dict(orbp) == {(6, (3, 3)): 55})
check('dual counts match payload',
      pay_arr['per_plane_counts']['V4_vertices'] == {'3': 55}
      and pay_arr['per_plane_counts']['D12_points'] == {'7': 55}
      and pay_arr['per_plane_counts']['D10_points'] == {'6': 55}
      and pay_arr['per_line_counts']['V4_vertices'] == {'6': 55}
      and list(pay_arr['residual_S3_orbits_on_line_vertices'].values()) == [55])
check('D12/D10 stats match payload',
      pay_arr['D12_points']['count'] == 55
      and pay_arr['D12_points']['planes_through_each'] == {'7': 55}
      and pay_arr['D12_points']['V4_lines_through_each'] == {'3': 55}
      and pay_arr['D10_points']['count'] == 66
      and pay_arr['D10_points']['planes_through_each'] == {'5': 66})
check('payload claim6 flag', pay_arr['claim6_pass'] is True)

# ------------------------------------------------------------------ verdict
print()
if FAIL:
    print('VERIFY: FAIL (%d)' % len(FAIL))
    for f in FAIL:
        print('   -', f)
    sys.exit(1)
print('VERIFY: PASS -- all FIX-A0 claims independently recomputed and matched.')
print('   j(E_sigma) = 8192/11 (both routes, all 55 involutions)')
print('   elapsed %.1fs' % (time.time() - T0))
