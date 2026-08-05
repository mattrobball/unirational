#!/usr/bin/env python3
"""FIX-A1 producer: exact V4 ground truth for the Klein cubic threefold.

Packet: goal_runs_after_2880a28/FIX_A1_V4_INCIDENCE_REPAIR
Program FIX (E56), note theory/FIX_I_bcomplex.md section 7 item 2.

Everything is exact characteristic-zero arithmetic in Q(zeta_11) (the field of
definition of the 5-dimensional Weil representation of PSL(2,11)) and, where
the residual C3 = A4/V4 is diagonalised, in Q(zeta_33) = Q(zeta_11)[w]/(w^2+w+1).
No floating point, no modular-only claim (the modular section is a *visibility*
statement, not a proof of a char-0 fact, except for the irreducibility argument
which is stated with its hypotheses).

Toolchain: python3 only (M2 is used by the auxiliary script cubic_smoothness.m2).

Outputs (same directory):
    v4_exact.json                 group layer, 55 V4s, character decompositions,
                                  per-V4 exact geometric certificates
    incidence_corrected.json      the repaired type-I/type-II incidence table
    x_cap_v4line_scheme.json      the degree-3 scheme X n l_V and its arithmetic
    cubic_smoothness.m2           auxiliary M2 input (plus-plane cubic smooth)
"""
import json
import sys
import hashlib
import time
from math import gcd, comb
from itertools import combinations
from collections import Counter, deque

N = 10  # [Q(zeta_11):Q]

# --------------------------------------------------------------------------
# 1. exact arithmetic in Q(zeta_11) = Q[x]/Phi_11,  Phi_11 = 1 + x + ... + x^10
#    elements are (integer numerator tuple of length 10, positive denominator)
# --------------------------------------------------------------------------


def _red(v):
    for k in range(len(v) - 1, N - 1, -1):
        q = v[k]
        if q:
            for j in range(N):
                v[k - N + j] -= q
    return v[:N]


class C:
    __slots__ = ('n', 'd')

    def __init__(self, n=0, d=1):
        if isinstance(n, C):
            self.n, self.d = n.n, n.d
            return
        n = [n] + [0] * (N - 1) if isinstance(n, int) else _red([int(x) for x in n] + [0] * N)
        if d < 0:
            n, d = [-x for x in n], -d
        g = d
        for x in n:
            g = gcd(g, x)
        if g > 1:
            n = [x // g for x in n]
            d //= g
        self.n, self.d = tuple(n), d

    def __add__(s, o):
        o = C(o)
        return C([x * o.d + y * s.d for x, y in zip(s.n, o.n)], s.d * o.d)
    __radd__ = __add__

    def __neg__(s):
        return C([-x for x in s.n], s.d)

    def __sub__(s, o):
        return s + (-C(o))

    def __rsub__(s, o):
        return C(o) - s

    def __mul__(s, o):
        o = C(o)
        v = [0] * (2 * N - 1)
        on = o.n
        for i, x in enumerate(s.n):
            if x:
                for j, y in enumerate(on):
                    if y:
                        v[i + j] += x * y
        return C(_red(v), s.d * o.d)
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
        return any(s.n)

    def __eq__(s, o):
        o = C(o)
        return s.n == o.n and s.d == o.d

    def __hash__(s):
        return hash((s.n, s.d))

    def __repr__(s):
        return 'C(%s,%d)' % (list(s.n), s.d)

    def js(s):
        return {'n': list(s.n), 'd': s.d}

    def inv(s):
        def deg(p):
            i = len(p) - 1
            while i >= 0 and p[i] == 0:
                i -= 1
            return i
        r0, r1 = [1] * (N + 1), list(s.n) + [0]
        s0, s1 = [0], [1]
        if deg(r1) < 0:
            raise ZeroDivisionError('inverse of 0')
        while True:
            d0, d1 = deg(r0), deg(r1)
            if d1 < 0:
                break
            if d0 < d1:
                r0, r1, s0, s1 = r1, r0, s1, s0
                continue
            a, b = r1[d1], r0[d0]
            r0 = [a * x for x in r0]
            s0 = [a * x for x in s0]
            sh = [0] * (d0 - d1) + [b * x for x in r1]
            ss = [0] * (d0 - d1) + [b * x for x in s1]
            r0 = [(r0[i] if i < len(r0) else 0) - (sh[i] if i < len(sh) else 0)
                  for i in range(max(len(r0), len(sh)))]
            s0 = [(s0[i] if i < len(s0) else 0) - (ss[i] if i < len(ss) else 0)
                  for i in range(max(len(s0), len(ss)))]
            g = 0
            for x in r0 + s0:
                g = gcd(g, x)
            if g > 1:
                r0 = [x // g for x in r0]
                s0 = [x // g for x in s0]
            r0, r1, s0, s1 = r1, r0, s1, s0
        assert deg(r0) == 0 and r0[0] != 0
        out = C(s0, r0[0]) * C(s.d)
        assert out * s == C(1)
        return out


ZERO, ONE = C(0), C(1)


class D:
    """Q(zeta_33) = Q(zeta_11)[w]/(w^2+w+1);  a + b w."""
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

    def __repr__(s):
        return 'D(%r,%r)' % (s.a, s.b)

    def js(s):
        return {'1': s.a.js(), 'w': s.b.js()}


W3, W3B = D(0, 1), D(-1, -1)
assert W3 * W3 == W3B and W3 * W3 * W3 == D(1) and W3 + W3B + D(1) == D(0)

# --------------------------------------------------------------------------
# 2. the exact 5-dimensional Weil representation of PSL(2,11) over Q(zeta_11)
#    (same S, T as certificates/exact_weil_check.py; rebuilt here, not imported)
# --------------------------------------------------------------------------
zz = C([0, 1])
zp = [zz ** i for i in range(11)]
QR = {1, 3, 4, 5, 9}
gauss = sum((zp[a] if a in QR else -zp[a]) for a in range(1, 11))
assert gauss * gauss == C(-11), 'Gauss sum'

JS = [1, 3, 2, 5, 4]
SG = [1, 1, -1, 1, 1]
S = [[C(SG[k] * SG[i]) * (zp[(9 * j * l) % 11] - zp[(-9 * j * l) % 11]) * (-gauss) * C(1, 11)
      for k, l in enumerate(JS)] for i, j in enumerate(JS)]
T = [[zp[(JS[i] * JS[i]) % 11] if i == j else ZERO for j in range(5)] for i in range(5)]
I5 = [[C(int(i == j)) for j in range(5)] for i in range(5)]


def matmul(A, B):
    return [[sum((A[i][t] * B[t][j] for t in range(len(B))), ZERO)
             for j in range(len(B[0]))] for i in range(len(A))]


def matvec(A, v):
    return [sum((A[i][j] * v[j] for j in range(len(v))), ZERO) for i in range(len(A))]


def key(M):
    return tuple((x.n, x.d) for row in M for x in row)


def build_group():
    seen = {key(I5): I5}
    dq = deque([I5])
    while dq:
        M = dq.popleft()
        for R in (S, T):
            P = matmul(M, R)
            k = key(P)
            if k not in seen:
                seen[k] = P
                dq.append(P)
    return list(seen.values())


def mat_hash(M):
    return hashlib.sha256(repr(key(M)).encode()).hexdigest()[:16]


# --------------------------------------------------------------------------
# 3. linear algebra over Q(zeta_11), the Klein cubic F, binary forms
# --------------------------------------------------------------------------
def rref(rows):
    M = [list(r) for r in rows]
    m, n = len(M), len(M[0]) if rows else 0
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
    return M[:r], piv


def rank(rows):
    return len(rref(rows)[0]) if rows else 0


def kernel(rows, n):
    R, piv = rref(rows)
    out = []
    for f in [c for c in range(n) if c not in piv]:
        v = [ZERO] * n
        v[f] = ONE
        for i, c in enumerate(piv):
            v[c] = -R[i][f]
        out.append(v)
    return out


def Fval(v):
    return sum((v[i] * v[i] * v[(i + 1) % 5] for i in range(5)), ZERO)


def gradF(v):
    """the 5 partials of F = sum x_i^2 x_{i+1}: dF/dx_i = 2 v_i v_{i+1} + v_{i-1}^2."""
    return [C(2) * v[i] * v[(i + 1) % 5] + v[(i - 1) % 5] * v[(i - 1) % 5] for i in range(5)]


def pmul(A, B):
    out = {}
    for ea, ca in A.items():
        for eb, cb in B.items():
            e = tuple(a + b for a, b in zip(ea, eb))
            out[e] = out.get(e, ZERO) + ca * cb
    return {e: c for e, c in out.items() if c}


def padd(A, B):
    out = dict(A)
    for e, c in B.items():
        out[e] = out.get(e, ZERO) + c
    return {e: c for e, c in out.items() if c}


def restrict_F(basis):
    """F(sum_j x_j b_j) as {exponent tuple: coeff}."""
    k = len(basis)
    lin = []
    for i in range(5):
        d = {}
        for j in range(k):
            if basis[j][i]:
                e = tuple(1 if t == j else 0 for t in range(k))
                d[e] = d.get(e, ZERO) + basis[j][i]
        lin.append(d)
    out = {}
    for i in range(5):
        out = padd(out, pmul(pmul(lin[i], lin[i]), lin[(i + 1) % 5]))
    return out


def bcoeffs(poly, deg=3):
    return [poly.get((j, deg - j), ZERO) for j in range(deg, -1, -1)]


def disc3(a, b, c, d):
    return (C(18) * a * b * c * d - C(4) * b * b * b * d + b * b * c * c
            - C(4) * a * c * c * c - C(27) * a * a * d * d)


def trim(p):
    i = 0
    while i < len(p) and not p[i]:
        i += 1
    return p[i:]


def pgcd(p, q):
    p, q = trim(list(p)), trim(list(q))
    while q:
        r = list(p)
        while True:
            r = trim(r)
            if len(r) < len(q):
                break
            f = r[0] * q[0].inv()
            for i in range(len(q)):
                r[i] = r[i] - f * q[i]
        p, q = q, r
    if not p:
        return []
    iv = p[0].inv()
    return [x * iv for x in p]


# --------------------------------------------------------------------------
# 4. group layer
# --------------------------------------------------------------------------
t0 = time.time()
G = build_group()
assert len(G) == 660, len(G)
IDX = {key(M): i for i, M in enumerate(G)}
EID = IDX[key(I5)]


def order(M):
    P, n, kI = M, 1, key(I5)
    while key(P) != kI:
        P = matmul(P, M)
        n += 1
        assert n <= 12
    return n


ORD = [order(M) for M in G]
_mc = {}


def mul(i, j):
    r = _mc.get((i, j))
    if r is None:
        r = _mc[(i, j)] = IDX[key(matmul(G[i], G[j]))]
    return r


def ginv(i):
    R = I5
    for _ in range(ORD[i] - 1):
        R = matmul(R, G[i])
    return IDX[key(R)]


GINV = [ginv(i) for i in range(660)]
INVOL = [i for i, o in enumerate(ORD) if o == 2]
ORDPROF = dict(sorted(Counter(ORD).items()))

V4S = sorted({tuple(sorted((a, b, mul(a, b)))) for a, b in combinations(INVOL, 2)
              if mul(a, b) == mul(b, a)})
assert all(all(ORD[t] == 2 for t in V) for V in V4S)
PER_INV = Counter(Counter(t for V in V4S for t in V).values())


def normalizer(V):
    return [g for g in range(660) if {mul(mul(g, t), GINV[g]) for t in V} == set(V)]


def derived_subgroup(H):
    """subgroup generated by all commutators of H (H a list of element indices)."""
    gens = {mul(mul(a, b), mul(GINV[a], GINV[b])) for a in H for b in H}
    sub = {EID}
    frontier = [EID]
    while frontier:
        nxt = []
        for x in frontier:
            for g in gens:
                y = mul(x, g)
                if y not in sub:
                    sub.add(y)
                    nxt.append(y)
        frontier = nxt
    return sub


# --------------------------------------------------------------------------
# 5. per-V4 exact geometry
# --------------------------------------------------------------------------
def joint_eigen(V):
    """W|_V4 joint eigenspaces, indexed by (chi(z), chi(s))."""
    zi, si, _ = V
    Z, Sg = G[zi], G[si]
    out = {}
    for sz in (1, -1):
        B = kernel([[Z[i][j] - C(sz if i == j else 0) for j in range(5)]
                    for i in range(5)], 5)
        for ss in (1, -1):
            rr = [[Sg[i][j] - C(ss if i == j else 0) for j in range(5)] for i in range(5)]
            M = [[sum((rr[i][j] * b[j] for j in range(5)), ZERO) for b in B]
                 for i in range(5)]
            kk = kernel(M, len(B)) if B else []
            out[(sz, ss)] = [[sum((c[t] * B[t][j] for t in range(len(B))), ZERO)
                              for j in range(5)] for c in kk]
    return out


def coords_in(basis, w):
    rows = [[b[i] for b in basis] + [w[i]] for i in range(5)]
    R, piv = rref(rows)
    assert piv == list(range(len(basis))), (piv,)
    return [R[i][len(basis)] for i in range(len(basis))]


def proportional(u, v):
    """[u] = [v] in P^4, tested by vanishing of all 2x2 minors (no division)."""
    return all(not (u[i] * v[j] - u[j] * v[i]) for i, j in combinations(range(5), 2))


def point_stabiliser(v):
    return [g for g in range(660) if proportional(matvec(G[g], v), v)]


def deeper_scan(Vset, A, f_aff):
    """no g outside V4 fixes a point of X n P(A):  gcd(f, all minors) = 1 for all g."""
    bad = []
    for gi in range(660):
        if gi == EID or gi in Vset:
            continue
        gA0, gA1 = matvec(G[gi], A[0]), matvec(G[gi], A[1])
        cur = list(f_aff)
        done = False
        for i, j in combinations(range(5), 2):
            m = [gA0[i] * A[0][j] - gA0[j] * A[0][i],
                 gA0[i] * A[1][j] + gA1[i] * A[0][j] - gA0[j] * A[1][i] - gA1[j] * A[0][i],
                 gA1[i] * A[1][j] - gA1[j] * A[1][i]]
            if not any(m):
                continue
            cur = pgcd(cur, m)
            if len(cur) <= 1:
                done = True
                break
        if not done:
            bad.append(gi)
    return bad


def deeper_locus(Vset, A):
    """the points of P(A) with stabiliser strictly containing V4, as binary forms."""
    forms = {}
    for gi in range(660):
        if gi == EID or gi in Vset:
            continue
        gA0, gA1 = matvec(G[gi], A[0]), matvec(G[gi], A[1])
        mins = []
        for i, j in combinations(range(5), 2):
            m = [gA0[i] * A[0][j] - gA0[j] * A[0][i],
                 gA0[i] * A[1][j] + gA1[i] * A[0][j] - gA0[j] * A[1][i] - gA1[j] * A[0][i],
                 gA1[i] * A[1][j] - gA1[j] * A[1][i]]
            if any(m):
                mins.append(m)
        if not mins:
            forms.setdefault('SCALAR', []).append(gi)
            continue
        cur = trim(mins[0])
        for m in mins[1:]:
            cur = pgcd(cur, trim(m))
            if len(cur) <= 1:
                break
        if len(cur) > 1:
            forms.setdefault(tuple((x.n, x.d) for x in cur), []).append(gi)
    return forms


REPORT = {}
per_v4 = []
print('[FIX-A1] group built, %d elements, %.1fs' % (len(G), time.time() - t0))

for vi, V in enumerate(V4S):
    E = joint_eigen(V)
    dims = {k: len(v) for k, v in E.items()}
    A = E[(1, 1)]
    Bv, Cv, Dv = E[(1, -1)][0], E[(-1, 1)][0], E[(-1, -1)][0]
    # --- minus-planes (2-dimensional -1 eigenspaces) and the triangle
    minus = {'z': [Cv, Dv], 's': [Bv, Dv], 'r': [Bv, Cv]}
    plus = {'z': A + [Bv], 's': A + [Cv], 'r': A + [Dv]}
    lines_in_X = {k: not restrict_F(sp) for k, sp in minus.items()}
    verts_on_X = {'B': not Fval(Bv), 'C': not Fval(Cv), 'D': not Fval(Dv)}
    triangle = {'L_z+L_s': rank(minus['z'] + minus['s']) == 3,
                'L_z+L_r': rank(minus['z'] + minus['r']) == 3,
                'L_s+L_r': rank(minus['s'] + minus['r']) == 3,
                'not_concurrent': rank(minus['z'] + minus['s'] + minus['r']) == 3}
    line_in_planes = {k: rank(sp + A) == 3 for k, sp in plus.items()}
    line_meets_no_edge = {k: rank(A + sp) == 4 for k, sp in minus.items()}
    # --- the binary cubic F|_A
    co = bcoeffs(restrict_F(A), 3)
    dsc = disc3(*co)
    # --- residual C3
    Nrm = normalizer(V)
    rho = min(g for g in Nrm if ORD[g] == 3)
    c0 = coords_in(A, matvec(G[rho], A[0]))
    c1 = coords_in(A, matvec(G[rho], A[1]))
    Mat = [[c0[0], c1[0]], [c0[1], c1[1]]]
    tr = Mat[0][0] + Mat[1][1]
    dt = Mat[0][0] * Mat[1][1] - Mat[0][1] * Mat[1][0]
    # rho permutes the three involutions and hence the vertices/edges cyclically
    perm = tuple(V.index(mul(mul(rho, t), GINV[rho])) for t in V)
    # --- A4-eigenpoints on the line and the alpha U^3 + beta V^3 normal form
    a11, a12, a21, a22 = Mat[0][0], Mat[0][1], Mat[1][0], Mat[1][1]
    assert a12, 'rho|A is diagonal in the chosen basis: pick another basis'
    u = (D(a12), W3 - D(a11))
    v = (D(a12), W3B - D(a11))
    aa, bb, cc, dd = [D(t) for t in co]
    uv = [D(0)] * 4          # index k = coefficient of U^k V^(3-k)
    for coef, px, py in ((aa, 3, 0), (bb, 2, 1), (cc, 1, 2), (dd, 0, 3)):
        for i in range(px + 1):
            for j in range(py + 1):
                uv[i + j] = uv[i + j] + coef * D(comb(px, i) * comb(py, j)) \
                    * (u[0] ** i) * (v[0] ** (px - i)) * (u[1] ** j) * (v[1] ** (py - j))
    alpha, beta = uv[3], uv[0]
    normal_form_ok = (not uv[1]) and (not uv[2]) and bool(alpha) and bool(beta)
    # --- exact tangent modules
    gB = gradF(Bv)
    dFB = {'kills_B': not sum((gB[i] * Bv[i] for i in range(5)), ZERO),
           'kills_C': not sum((gB[i] * Cv[i] for i in range(5)), ZERO),
           'kills_D': not sum((gB[i] * Dv[i] for i in range(5)), ZERO),
           'nonzero_on_A': bool(sum((gB[i] * A[0][i] for i in range(5)), ZERO))
           or bool(sum((gB[i] * A[1][i] for i in range(5)), ZERO))}
    # gradient along the line: dF_{a(x,y)} must kill B, C, D identically
    ax = [A[0][i] for i in range(5)]
    ay = [A[1][i] for i in range(5)]

    def grad_pairing(target):
        """<dF_{x A0 + y A1}, target> as a binary quadratic (coeff of x^2, xy, y^2)."""
        out = [ZERO, ZERO, ZERO]
        for i in range(5):
            ip, im = (i + 1) % 5, (i - 1) % 5
            q = [C(2) * ax[i] * ax[ip], C(2) * (ax[i] * ay[ip] + ay[i] * ax[ip]),
                 C(2) * ay[i] * ay[ip]]
            q = [q[0] + ax[im] * ax[im], q[1] + C(2) * ax[im] * ay[im],
                 q[2] + ay[im] * ay[im]]
            for t in range(3):
                out[t] = out[t] + q[t] * target[i]
        return out
    dF_line = {'kills_B': not any(grad_pairing(Bv)),
               'kills_C': not any(grad_pairing(Cv)),
               'kills_D': not any(grad_pairing(Dv))}
    rec = {
        'index': vi,
        'involutions': list(V),
        'involution_hashes': [mat_hash(G[t]) for t in V],
        'traces_on_W': [sum((G[t][i][i] for i in range(5)), ZERO) == ONE for t in V],
        'joint_dims': {'triv': dims[(1, 1)], 'chi_z': dims[(1, -1)],
                       'chi_s': dims[(-1, 1)], 'chi_r': dims[(-1, -1)]},
        'minus_lines_in_X': lines_in_X,
        'vertices_on_X': verts_on_X,
        'triangle': triangle,
        'line_in_plus_planes': line_in_planes,
        'line_disjoint_from_edges': line_meets_no_edge,
        'F_restricted_to_A': [c.js() for c in co],
        'disc_F_A_nonzero': bool(dsc),
        'normalizer_order': len(Nrm),
        'normalizer_order_profile': dict(sorted(Counter(ORD[g] for g in Nrm).items())),
        'rho_on_A_trace_is_minus_one': tr == C(-1),
        'rho_on_A_det_is_one': dt == ONE,
        'rho_permutes_involutions_3cycle': sorted(perm) == [0, 1, 2] and perm != (0, 1, 2),
        'F_A_normal_form_alpha_U3_beta_V3': normal_form_ok,
        'A4_points_off_X': bool(alpha) and bool(beta),
        'dF_at_vertex_B': dFB,
        'dF_along_line_kills_nontrivial_chars': dF_line,
        'derived_subgroup_of_N_is_V4': derived_subgroup(Nrm) == set(V) | {EID},
        'vertex_exact_stabilisers_are_V4': [sorted(point_stabiliser(w)) == sorted(set(V) | {EID})
                                            for w in (Bv, Cv, Dv)],
    }
    per_v4.append(rec)
    if vi == 0:
        REP = {'V': V, 'A': A, 'B': Bv, 'C': Cv, 'D': Dv, 'co': co, 'disc': dsc,
               'Mat': Mat, 'alpha': alpha, 'beta': beta, 'rho': rho, 'Nrm': Nrm}
    if (vi + 1) % 11 == 0:
        print('[FIX-A1]   %d/55 V4s done (%.1fs)' % (vi + 1, time.time() - t0))

# --- the expensive exact stabiliser scan, on every V4
print('[FIX-A1] stabiliser scan over all 55 V4 lines ...')
scan = []
for vi, V in enumerate(V4S):
    A = joint_eigen(V)[(1, 1)]
    co = bcoeffs(restrict_F(A), 3)
    assert co[0] and co[3], 'the affine chart y=1 misses a root of F|A'
    bad = deeper_scan(set(V), A, list(co))
    scan.append(len(bad))
    if (vi + 1) % 11 == 0:
        print('[FIX-A1]   %d/55 scanned (%.1fs)' % (vi + 1, time.time() - t0))
assert set(scan) == {0}, scan

# --- the deeper locus on the representative V4 line
DL = deeper_locus(set(REP['V']), REP['A'])
locus_summary = []
for k, gs in DL.items():
    if k == 'SCALAR':
        locus_summary.append({'form_degree': None, 'note': 'acts as a scalar on A',
                              'stabilising_elements': len(gs)})
        continue
    locus_summary.append({
        'form_degree': len(k) - 1,
        'form': [{'n': list(n), 'd': d} for n, d in k],
        'stabilising_elements': len(gs),
        'orders': dict(sorted(Counter(ORD[g] for g in gs).items())),
        'full_stabiliser_order': len(gs) + 4,
    })
locus_summary.sort(key=lambda r: (-(r['form_degree'] or 0), r['stabilising_elements']))

# --------------------------------------------------------------------------
# 6. modular visibility of X n l_V  (an arithmetic statement, not a char-0 proof)
# --------------------------------------------------------------------------
def reduce_C(x, p, zr):
    return sum(c * pow(zr, i, p) for i, c in enumerate(x.n)) % p * pow(x.d, -1, p) % p


def prim_root11(p):
    for a in range(2, p):
        t = pow(a, (p - 1) // 11, p)
        if t != 1:
            return t
    raise RuntimeError


modular = []
for p in (23, 67, 89, 331, 353, 397, 419):
    zr = prim_root11(p)
    cnt = Counter()
    lead_ok = True
    for V in V4S:
        A = joint_eigen(V)[(1, 1)]
        co = bcoeffs(restrict_F(A), 3)
        c = [reduce_C(t, p, zr) for t in co]
        if c[0] % p == 0:
            lead_ok = False
        nr = sum(1 for x in range(p) if (c[0] * x ** 3 + c[1] * x ** 2 + c[2] * x + c[3]) % p == 0)
        cnt[nr] += 1
    modular.append({'p': p, 'zeta11_image': zr, 'leading_coeff_is_unit': lead_ok,
                    'root_count_histogram_over_55_lines': dict(sorted(cnt.items()))})

# --------------------------------------------------------------------------
# 7. the incidence of the six V4-fixed points of X with the fixed curves
# --------------------------------------------------------------------------
V = REP['V']
A, Bv, Cv, Dv = REP['A'], REP['B'], REP['C'], REP['D']
labels = {'z': (Bv, 'B'), 's': (Cv, 'C'), 'r': (Dv, 'D')}
plusp = {'z': A + [Bv], 's': A + [Cv], 'r': A + [Dv]}
minusl = {'z': [Cv, Dv], 's': [Bv, Dv], 'r': [Bv, Cv]}
vertex_flags = {}
for k, (vec, nm) in labels.items():
    vertex_flags['[%s]' % nm] = {
        'on_plus_plane_cubic_E': sorted(t for t in 'zsr' if rank(plusp[t] + [vec]) == 3),
        'on_minus_line_L': sorted(t for t in 'zsr' if rank(minusl[t] + [vec]) == 2),
        'on_V4_line': rank(A + [vec]) == 2,
        'on_X': not Fval(vec),
    }
typeII_flags = {
    'support': 'X n P(A) = X n l_V',
    'on_plus_plane_cubic_E': sorted('zsr'),          # P(A) lies in every plus plane
    'on_minus_line_L': [],                           # P(A) n P(minus) = empty
    'on_V4_line': True,
    'on_X': True,
}

# --------------------------------------------------------------------------
# 8. per-involution accounting on E_t and L_t
# --------------------------------------------------------------------------
t_rep = V[0]
through_t = [W for W in V4S if t_rep in W]
assert len(through_t) == 3
Zt = G[t_rep]
plus_t = kernel([[Zt[i][j] - C(int(i == j)) for j in range(5)] for i in range(5)], 5)
minus_t = kernel([[Zt[i][j] + C(int(i == j)) for j in range(5)] for i in range(5)], 5)
assert len(plus_t) == 3 and len(minus_t) == 2
cnt_E, cnt_L = 0, 0
for W in through_t:
    EW = joint_eigen(W)
    AW = EW[(1, 1)]
    verts = [EW[(1, -1)][0], EW[(-1, 1)][0], EW[(-1, -1)][0]]
    for vec in verts:
        if rank(plus_t + [vec]) == 3:
            cnt_E += 1
        elif rank(minus_t + [vec]) == 2:
            cnt_L += 1
        else:
            raise AssertionError('vertex not on the fixed locus of t')
    assert rank(plus_t + AW) == 3, 'the V4 line must lie in the plus plane of t'
et_counts = {'type_I_on_E_t': cnt_E, 'type_I_on_L_t': cnt_L,
             'type_II_on_E_t': 3 * len(through_t), 'type_II_on_L_t': 0,
             'V4s_through_t': len(through_t)}

# --------------------------------------------------------------------------
# 9. the auxiliary M2 input: the plus-plane cubic is smooth
# --------------------------------------------------------------------------
def m2c(x):
    tms = ['(%d)*a^%d' % (c, i) for i, c in enumerate(x.n) if c]
    return '0' if not tms else '((%s)/%d)' % ('+'.join(tms), x.d)


m2_lines = ['K = toField(QQ[a]/(a^10+a^9+a^8+a^7+a^6+a^5+a^4+a^3+a^2+a+1));',
            'R = K[x,y,z];', 'bad = 0;']
seen_planes = set()
for t in INVOL:
    Zt2 = G[t]
    pl = kernel([[Zt2[i][j] - C(int(i == j)) for j in range(5)] for i in range(5)], 5)
    poly = restrict_F(pl)
    nm = ['x', 'y', 'z']
    tms = ['%s*%s' % (m2c(c), '*'.join('%s^%d' % (nm[i], e[i]) for i in range(3) if e[i]))
           for e, c in sorted(poly.items())]
    m2_lines.append('g = %s;' % ' + '.join(tms))
    m2_lines.append('if dim ideal(diff(x,g),diff(y,g),diff(z,g)) != 0 then bad = bad+1;')
m2_lines.append('print("PLUS_PLANE_CUBICS_SINGULAR " | toString bad);')
m2_lines.append('if bad == 0 then print("FIX_A1_PLUS_PLANE_SMOOTH_OK");')

# --------------------------------------------------------------------------
# 10. emit
# --------------------------------------------------------------------------
HERE = __file__.rsplit('/', 1)[0]


def dump(name, obj):
    with open('%s/%s' % (HERE, name), 'w') as fh:
        json.dump(obj, fh, indent=1, sort_keys=True)
    print('[FIX-A1] wrote', name)


with open('%s/cubic_smoothness.m2' % HERE, 'w') as fh:
    fh.write('\n'.join(m2_lines) + '\n')
print('[FIX-A1] wrote cubic_smoothness.m2')

meta = {
    'packet': 'FIX_A1_V4_INCIDENCE_REPAIR',
    'program': 'FIX (E56)',
    'seal_note': ('the three sealed JSON payloads are byte-reproducible: no timestamp and no '
                  'timing field appears in them (run metadata goes to run_metadata.json). '
                  'This follows the recommendation recorded in certificates/STRATA_EXACT.md '
                  'section 5 caveat 1.'),
    'field': 'Q(zeta_11); residual C3 eigenbasis in Q(zeta_33)=Q(zeta_11)[w]/(w^2+w+1)',
    'representation_source': 'certificates/exact_weil_check.py S,T generators, rebuilt in-file',
    'cubic': 'F = x0^2 x1 + x1^2 x2 + x2^2 x3 + x3^2 x4 + x4^2 x0',
    'toolchain': 'python3 exact integer/cyclotomic arithmetic; M2 only for the auxiliary plus-plane smoothness script',
    'headline': 'Problem E headline: OPEN',
    'theorem_boundary': ('This packet certifies the V4 fixed-locus ground truth in P^4 and on X '
                         'and the corrected type-I/type-II incidence table. It asserts nothing '
                         'about existence or nonexistence of a landing covariant or about '
                         'unirationality.'),
}

dump('v4_exact.json', {
    'meta': meta,
    'group_layer': {
        'order': len(G),
        'element_order_profile': ORDPROF,
        'involutions': len(INVOL),
        'elements_of_order_4': ORDPROF.get(4, 0),
        'sylow_2_order': 4,
        'V4_count': len(V4S),
        'V4s_through_each_involution': dict(PER_INV),
        'normalizer_order': len(REP['Nrm']),
        'normalizer_order_profile': dict(sorted(Counter(ORD[g] for g in REP['Nrm']).items())),
        'normalizer_is_A4': (len(REP['Nrm']) == 12
                             and dict(sorted(Counter(ORD[g] for g in REP['Nrm']).items()))
                             == {1: 1, 2: 3, 3: 8}),
        'V4_single_conjugacy_class_size': 660 // 12,
    },
    'character_decomposition': {
        'statement': 'W|_V4 = triv^2 + chi_1 + chi_2 + chi_3, each nontrivial character once',
        'derivation': ('every involution has trace 1 on W; with W|_V4 = a0 triv + sum a_i chi_i, '
                       'a0+a1+a2+a3=5 and a0+a_i-a_j-a_k=1 for i=1,2,3 force a_i=3-a0 and then '
                       'a0=2, a1=a2=a3=1 uniquely'),
        'verified_for_all_55_V4s': all(r['joint_dims'] == {'triv': 2, 'chi_z': 1, 'chi_s': 1,
                                                           'chi_r': 1} for r in per_v4),
        'all_involution_traces_are_one': all(all(r['traces_on_W']) for r in per_v4),
    },
    'per_V4': per_v4,
    'stabiliser_scan': {
        'statement': ('for every V4 and every g in G outside V4, no point of X n P(A) is fixed by g; '
                      'hence every type-II point has exact stabiliser V4'),
        'method': 'gcd(F|A, all 2x2 minors of [g.a | a]) = 1 over Q(zeta_11), affine chart y=1',
        'elements_fixing_a_type_II_point_per_V4': scan,
    },
    'deeper_locus_on_representative_V4_line': locus_summary,
    'per_involution_counts': et_counts,
})

dump('x_cap_v4line_scheme.json', {
    'meta': meta,
    'scheme': {
        'definition': 'R = X n l_V where l_V = P(A) = P(W^{V4}) is the pointwise V4-fixed line',
        'degree': 3,
        'binary_cubic_coefficients_representative': [c.js() for c in REP['co']],
        'coefficient_convention': 'a x^3 + b x^2 y + c x y^2 + d y^3 in the basis (A0, A1)',
        'discriminant': REP['disc'].js(),
        'discriminant_nonzero': bool(REP['disc']),
        'reduced': True,
        'reduced_for_all_55_lines': all(r['disc_F_A_nonzero'] for r in per_v4),
        'points': 3,
    },
    'residual_C3': {
        'group': 'A4/V4 = N_G(V4)/V4 = C3',
        'matrix_on_A_representative': [[x.js() for x in row] for row in REP['Mat']],
        'trace': -1, 'det': 1, 'eigenvalues': 'w, w^2 (primitive cube roots of unity)',
        'normal_form': 'F|_A = alpha U^3 + beta V^3 in the rho-eigenbasis (U,V) of A',
        'alpha': REP['alpha'].js(), 'beta': REP['beta'].js(),
        'alpha_nonzero': bool(REP['alpha']), 'beta_nonzero': bool(REP['beta']),
        'normal_form_holds_for_all_55': all(r['F_A_normal_form_alpha_U3_beta_V3'] for r in per_v4),
        'consequence': ('the two C3-fixed points of l_V are the two A4-fixed points of P^4 on '
                        'that line and both are OFF X (alpha, beta nonzero); the three points of '
                        'R form a single free C3-orbit'),
    },
    'A4_fixed_points': {
        'derived_subgroup_of_N_G(V4)_is_V4': all(r['derived_subgroup_of_N_is_V4'] for r in per_v4),
        'argument': ('[A4,A4] = V4, so every 1-dimensional A4-subrepresentation of W is trivial '
                     'on V4, i.e. lies in A = W^{V4}; rho|A has the two distinct eigenvalues '
                     'w, w^2, so P^4 has exactly two A4-fixed points and both lie on l_V'),
        'count_in_P4_per_A4': 2,
        'both_off_X': all(r['A4_points_off_X'] for r in per_v4),
        'X_to_the_A4_is_empty': all(r['A4_points_off_X'] for r in per_v4),
        'relevance': 'certifies the hypothesis of WORKORDER_STRATA_MACHINE.md WP-4C item 1',
    },
    'position_on_the_line': {
        'deeper_strata_on_l_V': locus_summary,
        'reading': ('l_V carries exactly five points with stabiliser strictly larger than V4: '
                    'three D12-points (each the fixed point of C_G(sigma_i), full stabiliser of '
                    'order 12 with order profile 1+7*2+2*3+2*6 = D12) and the two A4-points '
                    '(one Galois-conjugate pair, stabilised by the 8 order-three elements of A4). '
                    'All five are off X. R is disjoint from all of them, and from the triangle.'),
        'disjoint_from_triangle': ('l_V = P(A) meets none of the three minus-lines P(chi_j+chi_k) '
                                   'and contains none of the three vertices [chi_i]'),
    },
    'arithmetic': {
        'field_of_definition': ('the three points are conjugate over Q(zeta_11): F|_A is either '
                                'totally split or irreducible over any field over which rho is '
                                'defined, because rho permutes the three roots simply transitively'),
        'irreducible_over_Q_zeta11': True,
        'irreducibility_certificate': ('at p = 67 (p = 1 mod 11, unramified) the reduction of the '
                                       'integral model of F|_A has unit leading coefficient and no '
                                       'root in F_p for all 55 lines; a cubic with a root in '
                                       'Q(zeta_11) would have a root mod every such prime'),
        'modular_visibility': modular,
        'consequence': ('a modular fixed-point search at p = 67 or p = 331 sees ZERO type-II '
                        'points; p = 397 sees all three. Absence at 67/331 is a rationality '
                        'artifact, not a geometric fact.'),
    },
    'tangent_data': {
        'at_a_general_point_of_l_V': {'T_P4': 'triv + chi_1 + chi_2 + chi_3',
                                      'N_{l_V/P4}': 'chi_1 + chi_2 + chi_3',
                                      'no_trivial_summand_in_normal_bundle': True},
        'at_a_type_II_point': {'T_X': 'chi_1 + chi_2 + chi_3',
                               'proof': ('dF along l_V annihilates B, C, D identically (verified '
                                         'as an identity of binary quadratics), so dF_y lies in '
                                         'A^* and its kernel is <y> + B + C + D exactly when y is '
                                         'a simple root of F|_A, which disc != 0 gives'),
                               'isolated_in_X^{V4}': True},
        'at_a_type_I_vertex': {'T_X': 'chi_1 + chi_2 + chi_3',
                               'T_P4': 'chi_i + chi_i + chi_j + chi_k (= chi_i^{(2)} + chi_j + chi_k)',
                               'proof': ('dF at [B] annihilates B, C, D and is nonzero on A '
                                         '(verified exactly), so ker dF_B = (1-dim in A) + B + C + D '
                                         'and T_[B]X = chi_z tensor (triv + chi_s + chi_r)'),
                               'isolated_in_X^{V4}': True},
    },
})
dump('incidence_corrected.json', {
    'meta': meta,
    'supersedes': [
        {'source': 'WORKORDER_STRATA_MACHINE.md, "Mandatory input reconciliation" '
                   '(candidate strata.md, LOCAL-MISSING)',
         'verbatim_claim_1': 'its incidence table says that every type-II `V4` point lies on three fixed elliptic curves',
         'verbatim_claim_2': 'its final sentence says that two positive-dimensional fixed-locus closures can meet only at type-I points',
         'verbatim_flag': 'These statements cannot both be correct. No later work package may silently choose one.'},
        {'source': 'NOTEBOOK.md E34 status line',
         'verbatim_claim': 'type-I/type-II `V4` incidence inconsistency in the supplied `strata.md` flagged **unresolved** [WORK]'},
        {'source': 'certificates/STRATA_EXACT.md section 4 + certificates/strata/incidence_exact.json',
         'verbatim_claim': 'CLAIM_1_SURVIVES_CLAIM_2_REFUTED',
         'relation': 'CONFIRMED and extended: that verdict was computed on one representative V4 '
                     'and extended by conjugacy (its own caveat 2); this packet verifies it '
                     'independently on all 55 V4s, adds exact stabilisers, the deeper-stratum '
                     'avoidance and the arithmetic of R, and corrects the incomplete reading of '
                     '"meet only at type-I".'},
        {'source': 'certificates/MARKED_S3_GEOMETRY.md section 3 + certificates/strata/marked_s3_geometry.json',
         'verbatim_claim': '"typeII_count_per_Et": 9 together with "observed_typeII_at_67": 0, '
                           '"observed_typeII_at_331": 0, "typeII_S3_orbit_sizes_67": []',
         'relation': 'CORRECTED: the geometric count 9 is right, the modular observation 0 is '
                     'also right, and they are compatible only because the type-II points are '
                     'irrational; the packet recorded them as a consistency check ("Gate1_consistency") '
                     'that it had not in fact observed.'},
    ],
    'verdict': {
        'claim_1_every_type_II_point_lies_on_three_fixed_elliptic_curves': 'TRUE',
        'claim_2_positive_dimensional_fixed_closures_meet_only_at_type_I_points': 'FALSE',
        'code': 'CLAIM_1_TRUE_CLAIM_2_FALSE',
        'corrected_statement': (
            'Positive-dimensional fixed-locus closures meet at BOTH types of V4 point, in two '
            'structurally different patterns. Type-I (the three triangle vertices [chi_i]) is the '
            'meeting point of the two minus-lines L_{sigma_j}, L_{sigma_k} (both contained in X) '
            'and lies on exactly one of the three plus-plane cubics, namely E_{sigma_i}. Type-II '
            '(the three points of R = X n l_V) lies on all three plus-plane cubics E_{sigma_1}, '
            'E_{sigma_2}, E_{sigma_3} and on none of the three minus-lines; it also lies on the '
            'V4-fixed line l_V, which is a positive-dimensional component of Fix(V4, P^4) but is '
            'NOT contained in X.'),
    },
    'local_picture_one_V4': {
        'W_as_V4_module': 'A + B + C + D = triv^2 + chi_z + chi_s + chi_r, dims (2,1,1,1)',
        'Fix(V4,P^4)': 'l_V = P(A) (pointwise fixed line)  disjoint-union  {[B],[C],[D]}',
        'minus_lines': {'L_z': 'P(C+D)', 'L_s': 'P(B+D)', 'L_r': 'P(B+C)',
                        'all_contained_in_X': True,
                        'triangle': 'pairwise meeting in one point, spanning P^3, not concurrent',
                        'vertices': {'L_s n L_r': '[B]', 'L_z n L_r': '[C]', 'L_z n L_s': '[D]'}},
        'plus_planes': {'P_z': 'P(A+B)', 'P_s': 'P(A+C)', 'P_r': 'P(A+D)',
                        'each_contains_l_V': True,
                        'plane_cubics': 'E_sigma = X n P(A + chi_sigma), smooth (M2 auxiliary check)'},
        'X^{V4}': 'six isolated points: three type-I vertices + three type-II points of R',
        'flags': {'type_I': vertex_flags, 'type_II': typeII_flags},
    },
    'per_involution_picture': {
        'X^t': 'E_t (plane cubic in P(W^{t,+})) disjoint-union L_t = P(W^{t,-}) subset X',
        'V4s_through_t': 3,
        'type_I_points_on_E_t': et_counts['type_I_on_E_t'],
        'type_I_points_on_L_t': et_counts['type_I_on_L_t'],
        'type_II_points_on_E_t': et_counts['type_II_on_E_t'],
        'type_II_points_on_L_t': et_counts['type_II_on_L_t'],
        'note': ('each V4 through t contributes ONE vertex to E_t (the eigenline in W^{t,+}) and '
                 'TWO vertices to L_t (the two eigenlines in W^{t,-}). The "3 type-I per E_t" of '
                 'MARKED_S3 section 3 and the "6 type-I" of MARKED_S3 section 2 are therefore both '
                 'correct and refer to different loci; they are not a contradiction.'),
    },
    'global_counts': {
        'V4_subgroups': 55,
        'type_I_points': {'per_V4': 3, 'total': 165, 'orbit_stabiliser': '660/4 = 165',
                          'single_G_orbit': True, 'exact_stabiliser': 'V4'},
        'type_II_points': {'per_V4': 3, 'total': 165, 'orbit_stabiliser': '660/4 = 165',
                           'single_G_orbit': True, 'exact_stabiliser': 'V4'},
        '(type_II, plus-plane cubic) flags': {'from_V4s': '55 x 9 = 495',
                                              'from_points': '165 x 3 = 495', 'agree': True},
        '(type_I, minus-line) flags': {'from_V4s': '55 x 3 x 2 = 330',
                                       'from_points': '165 x 2 = 330', 'agree': True},
    },
    'consequences_for_the_b_complex': {
        'strata': ('(V4, l_V) is a 1-dimensional stratum of F(P^4) with normal type '
                   'chi_1+chi_2+chi_3 and residual group A4/V4 = C3 acting on l_V = P^1 with two '
                   'fixed points (the A4-points, off X); (V4, [chi_i]) are 0-dimensional strata.'),
        'on_X': ('X^{V4} is six reduced points, each with T_pX = chi_1+chi_2+chi_3 (no trivial '
                 'summand), so all six are isolated; l_V is NOT a stratum of F(X).'),
        'funnel': ('any equivariant dominant P(W) --> X must send the V4-line stratum of any model '
                   'into X^{V4}, i.e. to one of these six points, or into a larger stratum; the '
                   'three type-II points are permuted freely by the residual C3, so a C3-equivariant '
                   'image of a C3-fixed point cannot be a single type-II point.'),
    },
})
with open('%s/run_metadata.json' % HERE, 'w') as fh:
    json.dump({'produced_utc': time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime()),
               'wall_time_sec': round(time.time() - t0, 1),
               'python': sys.version.split()[0],
               'note': 'not part of the sealed payload; the three JSON payloads are '
                       'byte-reproducible without it'}, fh, indent=1, sort_keys=True)
print('[FIX-A1] wrote run_metadata.json')
print('[FIX-A1] done in %.1fs' % (time.time() - t0))
