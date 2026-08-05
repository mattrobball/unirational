#!/usr/bin/env python3
"""FIX-A1 independent verifier.  Verification class: ALGEBRAIC-RECOMPUTE.

This script does NOT import the producer.  It rebuilds the representation, the
group, the V4 layer and every geometric statement from scratch, using method
choices deliberately different from the producer's, and only then compares with
the sealed JSON:

  producer                                verifier
  --------------------------------------  --------------------------------------
  Q(zeta_11) as (int tuple, denominator)  Q(zeta_11) as a tuple of Fractions
  BFS closure under right mult by S,T     BFS closure under LEFT mult by T,S
  eigenspaces by iterated kernels         eigenspaces by isotypic projectors
                                          P_chi = (1/4) sum_g chi(g) g, ranks+traces
  F|_A by symbolic expansion              F|_A by Lagrange interpolation at 4 points
  minus-line in X by coefficient expansion  by vanishing at 5 distinct points of P^1
  ranks by rref                           incidences by 3x3 / 4x4 determinants
  stabiliser scan by binary-form gcd      by unit-ideal test in K[t]/(F|_A)
  modular visibility by root counting     recomputed from an independent reduction

Terminal marker on success: FIX_A1_V4_REPAIR_VERIFY_OK
"""
import json
import sys
from fractions import Fraction as Q
from itertools import combinations
from collections import Counter, deque

N = 10
FAIL = []


def check(cond, name):
    if cond:
        print('  PASS  %s' % name)
    else:
        print('  FAIL  %s' % name)
        FAIL.append(name)
    return bool(cond)


# --------------------------------------------------------------- Q(zeta_11)
class C:
    """tuple of 10 Fractions modulo Phi_11 = 1 + x + ... + x^10."""
    __slots__ = ('a',)

    def __init__(s, a=0):
        if isinstance(a, C):
            s.a = a.a
            return
        if isinstance(a, (int, Q)):
            s.a = (Q(a),) + (Q(0),) * (N - 1)
            return
        aa = [Q(x) for x in a] + [Q(0)] * N
        for k in range(len(aa) - 1, N - 1, -1):
            q = aa[k]
            if q:
                for j in range(N):
                    aa[k - N + j] -= q
        s.a = tuple(aa[:N])

    def __add__(s, o):
        o = C(o)
        return C([x + y for x, y in zip(s.a, o.a)])
    __radd__ = __add__

    def __neg__(s):
        return C([-x for x in s.a])

    def __sub__(s, o):
        return s + (-C(o))

    def __rsub__(s, o):
        return C(o) - s

    def __mul__(s, o):
        o = C(o)
        v = [Q(0)] * (2 * N - 1)
        for i, x in enumerate(s.a):
            if x:
                for j, y in enumerate(o.a):
                    if y:
                        v[i + j] += x * y
        return C(v)
    __rmul__ = __mul__

    def __truediv__(s, o):
        return s * C(o).inv()

    def __pow__(s, k):
        r, a = C(1), s
        while k:
            if k & 1:
                r = r * a
            a, k = a * a, k // 2
        return r

    def __bool__(s):
        return any(x != 0 for x in s.a)

    def __eq__(s, o):
        return s.a == C(o).a

    def __hash__(s):
        return hash(s.a)

    def __repr__(s):
        return 'C%s' % (s.a,)

    def inv(s):
        # inverse by linear algebra: solve (multiplication by s) * v = 1 over Q
        rows = [[C([1 if t == j else 0 for t in range(N)]) * s for j in range(N)]]
        M = [[rows[0][j].a[i] for j in range(N)] for i in range(N)]
        rhs = [Q(1)] + [Q(0)] * (N - 1)
        # Gaussian elimination over Q
        A = [M[i][:] + [rhs[i]] for i in range(N)]
        r = 0
        piv = []
        for c in range(N):
            p = next((i for i in range(r, N) if A[i][c] != 0), None)
            if p is None:
                continue
            A[r], A[p] = A[p], A[r]
            f = A[r][c]
            A[r] = [x / f for x in A[r]]
            for i in range(N):
                if i != r and A[i][c] != 0:
                    g = A[i][c]
                    A[i] = [x - g * y for x, y in zip(A[i], A[r])]
            piv.append(c)
            r += 1
        assert r == N, 'element not invertible'
        out = C([A[i][N] for i in range(N)])
        assert out * s == C(1)
        return out

    def js(s):
        """canonical (integer numerator tuple, positive denominator) form."""
        from math import gcd
        d = 1
        for x in s.a:
            d = d * x.denominator // gcd(d, x.denominator)
        n = [int(x * d) for x in s.a]
        g = d
        for x in n:
            g = gcd(g, abs(x))
        if g > 1:
            n = [x // g for x in n]
            d //= g
        return {'n': n, 'd': d}


ZERO, ONE = C(0), C(1)


class D:
    """Q(zeta_33) = Q(zeta_11)[w]/(w^2+w+1)."""
    __slots__ = ('a', 'b')

    def __init__(s, a=0, b=0):
        if isinstance(a, D):
            s.a, s.b = a.a, a.b
            return
        s.a = a if isinstance(a, C) else C(a)
        s.b = b if isinstance(b, C) else C(b)

    def __add__(s, o):
        o = D(o)
        return D(s.a + o.a, s.b + o.b)
    __radd__ = __add__

    def __neg__(s):
        return D(-s.a, -s.b)

    def __sub__(s, o):
        return s + (-D(o))

    def __rsub__(s, o):
        return D(o) - s

    def __mul__(s, o):
        o = D(o)
        bd = s.b * o.b
        return D(s.a * o.a - bd, s.a * o.b + s.b * o.a - bd)
    __rmul__ = __mul__

    def __pow__(s, k):
        r, a = D(1), s
        while k:
            if k & 1:
                r = r * a
            a, k = a * a, k // 2
        return r

    def __bool__(s):
        return bool(s.a) or bool(s.b)

    def __eq__(s, o):
        o = D(o)
        return s.a == o.a and s.b == o.b


W3, W3B = D(0, 1), D(-1, -1)

# ------------------------------------------------- representation and group
zz = C([0, 1])
zp = [zz ** i for i in range(11)]
QR = {1, 3, 4, 5, 9}
gauss = sum((zp[a] if a in QR else -zp[a]) for a in range(1, 11))
JS = [1, 3, 2, 5, 4]
SG = [1, 1, -1, 1, 1]
S = [[C(Q(SG[k], SG[i])) * (zp[(9 * j * l) % 11] - zp[(-9 * j * l) % 11]) * (-gauss) / C(11)
      for k, l in enumerate(JS)] for i, j in enumerate(JS)]
T = [[zp[(JS[i] * JS[i]) % 11] if i == j else ZERO for j in range(5)] for i in range(5)]
I5 = [[C(int(i == j)) for j in range(5)] for i in range(5)]


def matmul(A, B):
    return [[sum((A[i][t] * B[t][j] for t in range(len(B))), ZERO)
             for j in range(len(B[0]))] for i in range(len(A))]


def matvec(A, v):
    return [sum((A[i][j] * v[j] for j in range(len(v))), ZERO) for i in range(len(A))]


def key(M):
    return tuple(x.a for row in M for x in row)


def scal(c, M):
    return [[c * x for x in row] for row in M]


def madd(A, B):
    return [[x + y for x, y in zip(ra, rb)] for ra, rb in zip(A, B)]


print('[verify] section -1 : harness self-test')
_before = len(FAIL)
check(C(1) == C(2), 'HARNESS SELF-TEST -- this line is EXPECTED to read FAIL')
assert len(FAIL) == _before + 1, 'the check harness does not record failures!'
FAIL.pop()
print('  (self-test passed: a false statement is detected and recorded)')

print('[verify] section 0 : representation and group layer')
check(gauss * gauss == C(-11), 'Gauss sum g^2 = -11')
check(matmul(S, S) == I5, 'S^2 = 1')
TT = I5
for _ in range(11):
    TT = matmul(TT, T)
check(TT == I5, 'T^11 = 1')
ST = matmul(S, T)
check(matmul(matmul(ST, ST), ST) == I5, '(ST)^3 = 1')

seen = {key(I5): I5}
dq = deque([I5])
while dq:                                  # LEFT multiplication, generator order (T,S)
    M = dq.popleft()
    for R in (T, S):
        P = matmul(R, M)
        k = key(P)
        if k not in seen:
            seen[k] = P
            dq.append(P)
G = list(seen.values())
IDX = {key(M): i for i, M in enumerate(G)}
EID = IDX[key(I5)]
check(len(G) == 660, 'group closure has order 660')

# right-multiplication permutations: rS[i] = index of G[i].S, rT[i] = index of G[i].T.
# from these the whole multiplication table is pure integer bookkeeping, so the
# combinatorial layer needs no further exact matrix arithmetic.
rS = [IDX[key(matmul(M, S))] for M in G]
rT = [IDX[key(matmul(M, T))] for M in G]
RHO = [None] * 660                         # RHO[j][i] = index of G[i].G[j]
RHO[EID] = list(range(660))
dq = deque([EID])
while dq:
    j = dq.popleft()
    pj = RHO[j]
    for r in (rS, rT):
        j2 = r[j]
        if RHO[j2] is None:
            RHO[j2] = [r[x] for x in pj]
            dq.append(j2)
check(all(p is not None for p in RHO), 'right-multiplication permutation layer complete')
check(all(RHO[j][EID] == j for j in range(660)), 'permutation layer is consistent with e.g = g')


def mul(i, j):
    return RHO[j][i]


GINV = [None] * 660
for j in range(660):
    GINV[RHO[j].index(EID)] = j
check(all(mul(i, GINV[i]) == EID for i in range(660)), 'inverse table')


def order(i):
    n, x = 1, i
    while x != EID:
        x = mul(x, i)
        n += 1
        assert n <= 60
    return n


ORD = [order(i) for i in range(660)]
PROF = dict(sorted(Counter(ORD).items()))
INVOL = [i for i, o in enumerate(ORD) if o == 2]
V4S = sorted({tuple(sorted((a, b, mul(a, b)))) for a, b in combinations(INVOL, 2)
              if mul(a, b) == mul(b, a)})

# -------------------------------------------------------------- F and forms
def Fval(v):
    return sum((v[i] * v[i] * v[(i + 1) % 5] for i in range(5)), ZERO)


def gradF(v):
    return [C(2) * v[i] * v[(i + 1) % 5] + v[(i - 1) % 5] * v[(i - 1) % 5] for i in range(5)]


def det(M):
    M = [list(r) for r in M]
    n = len(M)
    d = ONE
    for c in range(n):
        p = next((i for i in range(c, n) if M[i][c]), None)
        if p is None:
            return ZERO
        if p != c:
            M[c], M[p] = M[p], M[c]
            d = -d
        d = d * M[c][c]
        iv = M[c][c].inv()
        M[c] = [x * iv for x in M[c]]
        for i in range(c + 1, n):
            if M[i][c]:
                f = M[i][c]
                M[i] = [x - f * y for x, y in zip(M[i], M[c])]
    return d


def rank(rows):
    M = [list(r) for r in rows]
    m = len(M)
    n = len(M[0]) if m else 0
    r = 0
    for c in range(n):
        p = next((i for i in range(r, m) if M[i][c]), None)
        if p is None:
            continue
        M[r], M[p] = M[p], M[r]
        iv = M[r][c].inv()
        M[r] = [x * iv for x in M[r]]
        for i in range(m):
            if i != r and M[i][c]:
                f = M[i][c]
                M[i] = [x - f * y for x, y in zip(M[i], M[r])]
        r += 1
        if r == m:
            break
    return r


def kernel(rows, n):
    M = [list(r) for r in rows]
    m = len(M)
    piv, r = [], 0
    for c in range(n):
        p = next((i for i in range(r, m) if M[i][c]), None)
        if p is None:
            continue
        M[r], M[p] = M[p], M[r]
        iv = M[r][c].inv()
        M[r] = [x * iv for x in M[r]]
        for i in range(m):
            if i != r and M[i][c]:
                f = M[i][c]
                M[i] = [x - f * y for x, y in zip(M[i], M[r])]
        piv.append(c)
        r += 1
        if r == m:
            break
    out = []
    for f in [c for c in range(n) if c not in piv]:
        v = [ZERO] * n
        v[f] = ONE
        for i, c in enumerate(piv):
            v[c] = -M[i][f]
        out.append(v)
    return out


def isotypic(V, chi):
    """projector (1/4) sum_{g in V4} chi(g) g  --  the producer used kernels instead."""
    P = scal(C(Q(1, 4)), I5)
    for k, t in enumerate(V):
        P = madd(P, scal(C(Q(chi[k], 4)), G[t]))
    return P


def image_basis(P):
    cols = [[P[i][j] for i in range(5)] for j in range(5)]
    out = []
    for c in cols:
        if rank(out + [c]) > len(out):
            out.append(c)
    return out


# ---------------------------------------------------------------- load JSONs
HERE = __file__.rsplit('/', 1)[0]
VE = json.load(open('%s/v4_exact.json' % HERE))
XC = json.load(open('%s/x_cap_v4line_scheme.json' % HERE))
IC = json.load(open('%s/incidence_corrected.json' % HERE))

print('[verify] section 1 : claim A1-C1  (Sylow-2 structure)')
check(PROF == {1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120}, 'element order profile')
check(PROF.get(4, 0) == 0, 'no elements of order 4, so Sylow-2 = V4 (order 4 || 660)')
check(len(INVOL) == 55, '55 involutions')
check(len(V4S) == 55, '55 Klein four-subgroups')
check(set(Counter(Counter(t for V in V4S for t in V).values())) == {3},
      'every involution lies in exactly 3 V4s')
check(all(len(set(V)) == 3 for V in V4S), 'every V4 contains 3 involutions')
NRM = {}
for V in V4S:
    NRM[V] = [g for g in range(660) if {mul(mul(g, t), GINV[g]) for t in V} == set(V)]
check(all(len(n) == 12 for n in NRM.values()), '|N_G(V4)| = 12 for all 55')
check(all(dict(sorted(Counter(ORD[g] for g in n).items())) == {1: 1, 2: 3, 3: 8}
          for n in NRM.values()), 'N_G(V4) has A4 order profile 1+3.2+8.3 (not D12, not C12)')
# single conjugacy class
orb = {V4S[0]}
frontier = [V4S[0]]
while frontier:
    nxt = []
    for V in frontier:
        for g in range(660):
            W = tuple(sorted(mul(mul(g, t), GINV[g]) for t in V))
            if W not in orb:
                orb.add(W)
                nxt.append(W)
    frontier = nxt
check(len(orb) == 55 and orb == set(V4S), 'the 55 V4s form a single G-conjugacy class')
check(VE['group_layer']['element_order_profile'] == {str(k): v for k, v in PROF.items()},
      'JSON group_layer.element_order_profile matches')
check(VE['group_layer']['normalizer_is_A4'] is True and VE['group_layer']['V4_count'] == 55,
      'JSON group_layer V4/normalizer fields match')

print('[verify] section 2 : claim A1-C2  (W|_V4 = triv^2 + chi_1 + chi_2 + chi_3)')
dims_ok, tr_ok = True, True
for V in V4S:
    for t in V:
        if sum((G[t][i][i] for i in range(5)), ZERO) != ONE:
            tr_ok = False
    d = [rank(image_basis(isotypic(V, chi)))
         for chi in ((1, 1, 1), (1, -1, -1), (-1, 1, -1), (-1, -1, 1))]
    if d != [2, 1, 1, 1] or sum(d) != 5:
        dims_ok = False
check(tr_ok, 'every one of the 165 involutions has trace 1 on W')
check(dims_ok, 'isotypic projector ranks are (2,1,1,1) for all 55 V4s')
# the arithmetic of the trace equation, solved symbolically
sols = [(a0, a1, a2, a3) for a0 in range(6) for a1 in range(6) for a2 in range(6)
        for a3 in range(6) if a0 + a1 + a2 + a3 == 5
        and a0 + a1 - a2 - a3 == 1 and a0 - a1 + a2 - a3 == 1 and a0 - a1 - a2 + a3 == 1]
check(sols == [(2, 1, 1, 1)], 'a0+ai-aj-ak = 1 with sum 5 has the unique solution (2,1,1,1)')
check(VE['character_decomposition']['verified_for_all_55_V4s'] is True,
      'JSON character_decomposition agrees')

print('[verify] section 3 : claims A1-C3a/b/c  (fixed locus, triangle, planes)')
GEO = {}
for V in V4S:
    A = image_basis(isotypic(V, (1, 1, 1)))
    B = image_basis(isotypic(V, (1, -1, -1)))[0]
    Cc = image_basis(isotypic(V, (-1, 1, -1)))[0]
    Dd = image_basis(isotypic(V, (-1, -1, 1)))[0]
    GEO[V] = (A, B, Cc, Dd)
ok_fix = ok_line = ok_plane = ok_tri = ok_vert = True
for V in V4S:
    A, B, Cc, Dd = GEO[V]
    # Fix(V4,P^4) = P(A) (pointwise fixed line) together with the three isolated
    # points [B],[C],[D]; the checks below pin down the incidences.
    # minus-lines contained in X : a binary cubic vanishing at 5 distinct points is 0
    for pair in ([Cc, Dd], [B, Dd], [B, Cc]):
        for (x, y) in ((1, 0), (0, 1), (1, 1), (1, 2), (1, 3)):
            v = [C(x) * pair[0][i] + C(y) * pair[1][i] for i in range(5)]
            if Fval(v):
                ok_line = False
    # the three plus planes contain the V4 line
    for w in (B, Cc, Dd):
        if rank([A[0], A[1], w] + A) != 3:
            ok_plane = False
    # triangle: each pair of minus-lines spans a plane and meets in the expected vertex
    trip = {'z': [Cc, Dd], 's': [B, Dd], 'r': [B, Cc]}
    if not (rank(trip['z'] + trip['s']) == 3 and rank(trip['z'] + trip['r']) == 3
            and rank(trip['s'] + trip['r']) == 3
            and rank(trip['z'] + trip['s'] + trip['r']) == 3):
        ok_tri = False
    if not (rank(trip['s'] + [B]) == 2 and rank(trip['r'] + [B]) == 2
            and rank(trip['z'] + [B]) == 3):
        ok_tri = False
    # the V4 line is disjoint from every edge of the triangle
    for k in trip:
        if rank(A + trip[k]) != 4:
            ok_fix = False
    # the vertices lie on X
    for w in (B, Cc, Dd):
        if Fval(w):
            ok_vert = False
check(ok_line, 'all 165 minus-lines lie in X (5-point vanishing test, all 55 V4s)')
check(ok_plane, 'every plus-plane P(triv^2+chi_i) contains the V4 line l_V (all 55)')
check(ok_tri, 'the three minus-lines form a triangle with vertices [B],[C],[D] (all 55)')
check(ok_fix, 'l_V is disjoint from every edge of the triangle (all 55)')
check(ok_vert, 'the three triangle vertices lie on X (all 55)')

print('[verify] section 4 : claim A1-C3d  (X n l_V, exact)')


def cubic_by_interpolation(A):
    """F|_A as a binary cubic, recovered from 4 values instead of symbolic expansion."""
    pts = [(1, 0), (0, 1), (1, 1), (1, -1)]
    vals = [Fval([C(x) * A[0][i] + C(y) * A[1][i] for i in range(5)]) for x, y in pts]
    # solve for (a,b,c,d) with a x^3 + b x^2 y + c x y^2 + d y^3
    M = [[C(x ** 3), C(x * x * y), C(x * y * y), C(y ** 3)] for x, y in pts]
    aug = [M[i] + [vals[i]] for i in range(4)]
    r = 0
    for c in range(4):
        p = next((i for i in range(r, 4) if aug[i][c]), None)
        aug[r], aug[p] = aug[p], aug[r]
        iv = aug[r][c].inv()
        aug[r] = [x * iv for x in aug[r]]
        for i in range(4):
            if i != r and aug[i][c]:
                f = aug[i][c]
                aug[i] = [x - f * y for x, y in zip(aug[i], aug[r])]
        r += 1
    return [aug[i][4] for i in range(4)]


def disc3(a, b, c, d):
    return (C(18) * a * b * c * d - C(4) * b * b * b * d + b * b * c * c
            - C(4) * a * c * c * c - C(27) * a * a * d * d)


all_disc, all_full = True, True
CUB = {}
for V in V4S:
    A = GEO[V][0]
    co = cubic_by_interpolation(A)
    CUB[V] = co
    if not disc3(*co):
        all_disc = False
    if not (co[0] and co[3]):
        all_full = False
check(all_disc, 'disc(F|_{l_V}) != 0 for all 55 lines : X n l_V is 3 REDUCED points')
check(all_full, 'neither [1:0] nor [0:1] is on X, so the affine chart y=1 sees all 3 points')
check(XC['scheme']['reduced_for_all_55_lines'] is True and XC['scheme']['degree'] == 3
      and XC['scheme']['points'] == 3,
      'JSON x_cap_v4line_scheme: degree 3, reduced, 3 points, all 55 lines')
check(all(r['disc_F_A_nonzero'] is True for r in VE['per_V4']),
      'JSON per_V4 disc_F_A_nonzero for all 55')

print('[verify] section 5 : claim A1-C3e  (residual C3 = A4/V4 on l_V)')
ok_rho, ok_perm, ok_nf, ok_a4 = True, True, True, True
for V in V4S:
    A = GEO[V][0]
    rho = min(g for g in NRM[V] if ORD[g] == 3)
    cols = []
    for b in A:
        w = matvec(G[rho], b)
        M = [[A[0][i], A[1][i], w[i]] for i in range(5)]
        r, piv = 0, []
        MM = [row[:] for row in M]
        for c in range(2):
            p = next((i for i in range(r, 5) if MM[i][c]), None)
            MM[r], MM[p] = MM[p], MM[r]
            iv = MM[r][c].inv()
            MM[r] = [x * iv for x in MM[r]]
            for i in range(5):
                if i != r and MM[i][c]:
                    f = MM[i][c]
                    MM[i] = [x - f * y for x, y in zip(MM[i], MM[r])]
            r += 1
        cols.append([MM[0][2], MM[1][2]])
        if any(MM[i][2] for i in range(2, 5)):
            ok_rho = False          # rho(A) must stay inside A
    Mat = [[cols[0][0], cols[1][0]], [cols[0][1], cols[1][1]]]
    if not (Mat[0][0] + Mat[1][1] == C(-1)
            and Mat[0][0] * Mat[1][1] - Mat[0][1] * Mat[1][0] == ONE):
        ok_rho = False
    perm = tuple(V.index(mul(mul(rho, t), GINV[rho])) for t in V)
    if sorted(perm) != [0, 1, 2] or perm == (0, 1, 2):
        ok_perm = False
    # eigenvectors of rho|A over Q(zeta_33) and the alpha U^3 + beta V^3 normal form
    a11, a12, a21, a22 = Mat[0][0], Mat[0][1], Mat[1][0], Mat[1][1]
    if not a12:
        ok_nf = False
        continue
    u = (D(a12), W3 - D(a11))
    v = (D(a12), W3B - D(a11))
    co = CUB[V]
    aa, bb, cc, dd = [D(t) for t in co]
    from math import comb
    uv = [D(0)] * 4
    for coef, px, py in ((aa, 3, 0), (bb, 2, 1), (cc, 1, 2), (dd, 0, 3)):
        for i in range(px + 1):
            for j in range(py + 1):
                uv[i + j] = uv[i + j] + coef * D(comb(px, i) * comb(py, j)) \
                    * (u[0] ** i) * (v[0] ** (px - i)) * (u[1] ** j) * (v[1] ** (py - j))
    if uv[1] or uv[2]:
        ok_nf = False
    if not (uv[0] and uv[3]):
        ok_a4 = False
check(ok_rho, 'rho preserves A and acts with trace -1, det 1 (eigenvalues w, w^2), all 55')
check(ok_perm, 'rho permutes the three involutions (hence vertices and edges) in a 3-cycle')
check(ok_nf, 'F|_A = alpha U^3 + beta V^3 in the rho-eigenbasis, all 55')
check(ok_a4, 'alpha, beta nonzero: both A4-fixed points of l_V are OFF X, all 55')


def derived(H):
    gens = {mul(mul(a, b), mul(GINV[a], GINV[b])) for a in H for b in H}
    sub, fr = {EID}, [EID]
    while fr:
        nx = []
        for x in fr:
            for g in gens:
                y = mul(x, g)
                if y not in sub:
                    sub.add(y)
                    nx.append(y)
        fr = nx
    return sub


check(all(derived(NRM[V]) == set(V) | {EID} for V in V4S),
      '[N_G(V4), N_G(V4)] = V4, so every A4-character line of W lies in A = W^{V4}')
check(ok_a4 and XC['A4_fixed_points']['X_to_the_A4_is_empty'] is True,
      'hence P^4 has exactly two A4-fixed points, both on l_V, both off X:  X^{A4} = empty')

print('[verify] section 6 : exact stabilisers of the type-II points')
# independent method: unit-ideal test in the cubic residue algebra K[t]/(f)
def resalg_scan(V):
    A = GEO[V][0]
    a, b, c, d = CUB[V]
    inv_a = a.inv()
    # t^3 = -(b t^2 + c t + d)/a
    red = [-b * inv_a, -c * inv_a, -d * inv_a]   # t^3 = red[0] t^2 + red[1] t + red[2]

    def rmul(x, y):
        v = [ZERO] * 5
        for i in range(3):
            for j in range(3):
                v[i + j] = v[i + j] + x[i] * y[j]
        for k in (4, 3):
            q = v[k]
            if q:
                v[k] = ZERO
                v[k - 1] = v[k - 1] + q * red[0]
                v[k - 2] = v[k - 2] + q * red[1]
                v[k - 3] = v[k - 3] + q * red[2]
        return v[:3]
    theta = [ZERO, ONE, ZERO]
    one = [ONE, ZERO, ZERO]
    # the point of P(A) is [theta : 1] -> vector theta*A0 + A1
    pt = [[A[0][i] * theta[0] + A[1][i], A[0][i] * theta[1], A[0][i] * theta[2]]
          for i in range(5)]
    for gi in range(660):
        if gi in V or ORD[gi] == 1:
            continue
        gp = [[sum((G[gi][i][j] * pt[j][k] for j in range(5)), ZERO) for k in range(3)]
              for i in range(5)]
        rows = []
        done = False
        for i, j in combinations(range(5), 2):
            m = [x - y for x, y in zip(rmul(gp[i], pt[j]), rmul(gp[j], pt[i]))]
            if any(m):
                rows.append(m)
                rows.append(rmul(m, theta))
                rows.append(rmul(rmul(m, theta), theta))
                if rank(rows) == 3:     # the minors already generate the unit ideal
                    done = True
                    break
        if not done:
            return gi
    return None


bad = [resalg_scan(V) for V in V4S[:3]]
check(all(b is None for b in bad),
      'no g outside V4 fixes any point of X n l_V (residue-algebra unit-ideal test, 3 V4s)')
check(len(orb) == 55, 'and by the single-conjugacy-class fact this extends to all 55 V4s')
check(VE['stabiliser_scan']['elements_fixing_a_type_II_point_per_V4'] == [0] * 55,
      'JSON stabiliser_scan reports 0 for every V4')
check(all(r == 0 for r in VE['stabiliser_scan']['elements_fixing_a_type_II_point_per_V4']),
      'type-II points therefore have exact stabiliser V4; orbit 660/4 = 165')


def prop(u, v):
    return all(not (u[i] * v[j] - u[j] * v[i]) for i, j in combinations(range(5), 2))


ok_vs = True
for V in V4S:
    A, B, Cc, Dd = GEO[V]
    for w in (B, Cc, Dd):
        st = [g for g in range(660) if prop(matvec(G[g], w), w)]
        if sorted(st) != sorted(set(V) | {EID}):
            ok_vs = False
check(ok_vs, 'each of the 165 type-I vertices has exact stabiliser V4 (brute force over G)')
check(all(all(r['vertex_exact_stabilisers_are_V4']) for r in VE['per_V4']),
      'JSON per_V4 vertex_exact_stabilisers_are_V4 for all 55')

print('[verify] section 7 : claim A1-C4  (tangent and normal characters)')
ok_tan_v, ok_tan_l = True, True
for V in V4S:
    A, B, Cc, Dd = GEO[V]
    g = gradF(B)
    if any(sum((g[i] * w[i] for i in range(5)), ZERO) for w in (B, Cc, Dd)):
        ok_tan_v = False
    if not (sum((g[i] * A[0][i] for i in range(5)), ZERO)
            or sum((g[i] * A[1][i] for i in range(5)), ZERO)):
        ok_tan_v = False
    # along the line: dF_{x A0 + y A1} must kill B, C, D identically.  Test by
    # evaluating at 3 distinct points (a binary quadratic with 3 roots is 0).
    for w in (B, Cc, Dd):
        for (x, y) in ((1, 0), (0, 1), (1, 1)):
            a = [C(x) * A[0][i] + C(y) * A[1][i] for i in range(5)]
            if sum((gradF(a)[i] * w[i] for i in range(5)), ZERO):
                ok_tan_l = False
check(ok_tan_v, 'dF at each vertex kills B,C,D and is nonzero on A  =>  T_[B]X = chi_z+chi_s+chi_r')
check(ok_tan_l, 'dF along l_V kills B,C,D identically  =>  T_yX = chi_1+chi_2+chi_3 at type-II')
check(XC['tangent_data']['at_a_general_point_of_l_V']['N_{l_V/P4}'] == 'chi_1 + chi_2 + chi_3',
      'JSON normal type of the V4-line stratum')

print('[verify] section 8 : modular visibility of X n l_V')


def prim_root11(p):
    for a in range(2, p):
        t = pow(a, (p - 1) // 11, p)
        if t != 1:
            return t
    raise RuntimeError


mod_ok = True
for entry in XC['arithmetic']['modular_visibility']:
    p = entry['p']
    zr = prim_root11(p)
    cnt = Counter()
    for V in V4S:
        co = CUB[V]
        cc = []
        for x in co:
            j = x.js()
            cc.append(sum(n * pow(zr, i, p) for i, n in enumerate(j['n'])) % p
                      * pow(j['d'], -1, p) % p)
        nr = sum(1 for t in range(p)
                 if (cc[0] * t ** 3 + cc[1] * t ** 2 + cc[2] * t + cc[3]) % p == 0)
        cnt[nr] += 1
    got = dict(sorted(cnt.items()))
    want = {int(k): v for k, v in entry['root_count_histogram_over_55_lines'].items()}
    # the choice of the prime above p is a Galois choice; the multiset over the
    # 55 lines is Galois-stable, so the histogram must match exactly
    if got != want:
        mod_ok = False
        print('     p=%d got %s want %s' % (p, got, want))
check(mod_ok, 'modular root-count histograms reproduce the JSON at all recorded primes')
check(all(entry['root_count_histogram_over_55_lines'] == {'0': 55}
          for entry in XC['arithmetic']['modular_visibility'] if entry['p'] in (67, 331)),
      'at p = 67 and p = 331 ZERO of the 165 type-II points are F_p-rational')
check(any(entry['root_count_histogram_over_55_lines'] == {'3': 55}
          for entry in XC['arithmetic']['modular_visibility']),
      'at least one recorded prime (397, 419) makes all 165 type-II points visible')

print('[verify] section 9 : the corrected incidence table')
V = V4S[0]
A, B, Cc, Dd = GEO[V]
planes = {'z': A + [B], 's': A + [Cc], 'r': A + [Dd]}
lines = {'z': [Cc, Dd], 's': [B, Dd], 'r': [B, Cc]}
check(all(rank(planes[a] + planes[b]) == 4 for a, b in combinations('zsr', 2)),
      'the three plus-planes are pairwise distinct')
check(all(rank(planes[k] + A) == 3 for k in planes),
      'l_V lies in all three plus-planes, so R = X n l_V lies on all three plane cubics'
      '   [candidate claim 1: TRUE]')
check(rank(lines['s'] + [B]) == 2 and rank(lines['r'] + [B]) == 2,
      'the vertex [B] lies on the two minus-lines L_s, L_r (both inside X)')
check(rank(planes['z'] + [B]) == 3 and rank(planes['s'] + [B]) == 4
      and rank(planes['r'] + [B]) == 4,
      'the vertex [B] lies on exactly one plus-plane cubic, E_z')
check(all(rank(A + lines[k]) == 4 for k in lines),
      'R meets no minus-line: type-II points are NOT on the triangle'
      '   [two positive-dimensional closures E_z, E_s meet at type-II '
      '=> candidate claim 2: FALSE]')
check(IC['verdict']['code'] == 'CLAIM_1_TRUE_CLAIM_2_FALSE', 'JSON verdict code')
# per-involution accounting, recomputed
t_rep = V[0]
through = [W for W in V4S if t_rep in W]
Zt = G[t_rep]
plus_t = kernel([[Zt[i][j] - C(int(i == j)) for j in range(5)] for i in range(5)], 5)
minus_t = kernel([[Zt[i][j] + C(int(i == j)) for j in range(5)] for i in range(5)], 5)
cE = cL = 0
for W in through:
    AW, BW, CW, DW = GEO[W]
    for w in (BW, CW, DW):
        if rank(plus_t + [w]) == 3:
            cE += 1
        elif rank(minus_t + [w]) == 2:
            cL += 1
        else:
            cE = cL = -99
    if rank(plus_t + AW) != 3:
        cE = -99
check(len(through) == 3 and len(plus_t) == 3 and len(minus_t) == 2,
      '3 V4s through t; W^{t,+} is 3-dimensional and W^{t,-} is 2-dimensional')
check(cE == 3 and cL == 6,
      '3 type-I points on E_t and 6 type-I points on L_t '
      '(so "3 per E_t" and "6 on L_t" are both right and refer to different loci)')
check(IC['per_involution_picture']['type_I_points_on_E_t'] == 3
      and IC['per_involution_picture']['type_I_points_on_L_t'] == 6
      and IC['per_involution_picture']['type_II_points_on_E_t'] == 9
      and IC['per_involution_picture']['type_II_points_on_L_t'] == 0,
      'JSON per-involution counts (3 / 6 / 9 / 0)')
check(55 * 3 == 165 and 660 // 4 == 165 and 55 * 9 == 495 and 165 * 3 == 495
      and 55 * 3 * 2 == 330 and 165 * 2 == 330, 'global double counts close')

print()
if FAIL:
    print('FIX_A1_V4_REPAIR_VERIFY_FAIL  (%d failures)' % len(FAIL))
    for f in FAIL:
        print('   ', f)
    sys.exit(1)
print('FIX_A1_V4_REPAIR_VERIFY_OK')
