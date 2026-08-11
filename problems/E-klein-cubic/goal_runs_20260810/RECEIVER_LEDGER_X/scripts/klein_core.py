"""Exact arithmetic core for the target-side fixed-locus ledger (RECEIVER_LEDGER_X).

Self-contained.  Provides

  * K   -- the cyclotomic field Q(zeta_165) = Q(zeta_3) (x) Q(zeta_5) (x) Q(zeta_11),
           exact rational arithmetic, tensor basis {z3^i z5^j z11^k}, i<2, j<4, k<10.
  * the 5-dimensional Klein representation of G = PSL(2,11) over Q(zeta_11) < K,
    rebuilt from the same S, T generators as certificates/exact_weil_check.py,
  * the Klein cubic F = sum_{i in Z/5} x_i^2 x_{i+1},
  * abstract PSL(2,11) as 2x2 matrices over F_11 modulo +-1 (660 elements),
  * subgroup enumeration and conjugacy classification.

No third-party imports.  python3 only.
"""
from fractions import Fraction as Q
from collections import deque

# ---------------------------------------------------------------- field K
# basis index: i*40 + j*10 + k   with  i<2 (zeta_3), j<4 (zeta_5), k<10 (zeta_11)
DEG = 80
_Z = tuple([Q(0)] * DEG)


def _idx(i, j, k):
    return i * 40 + j * 10 + k


def k_zero():
    return _Z


def k_from_int(n):
    a = [Q(0)] * DEG
    a[0] = Q(n)
    return tuple(a)


def k_from_q(n):
    a = [Q(0)] * DEG
    a[0] = Q(n)
    return tuple(a)


def k_add(a, b):
    return tuple(x + y for x, y in zip(a, b))


def k_sub(a, b):
    return tuple(x - y for x, y in zip(a, b))


def k_neg(a):
    return tuple(-x for x in a)


def k_scal(a, c):
    c = Q(c)
    return tuple(x * c for x in a)


def _reduce165(raw):
    """raw: dict/list indexed by (i mod 3, j mod 5, k mod 11) -> Q ; reduce to basis."""
    # raw is a flat list of length 3*5*11 = 165, index i*55 + j*11 + k
    # reduce zeta_11:  c^10 = -(1 + c + ... + c^9)
    for i in range(3):
        for j in range(5):
            v = raw[i * 55 + j * 11 + 10]
            if v:
                raw[i * 55 + j * 11 + 10] = Q(0)
                for k in range(10):
                    raw[i * 55 + j * 11 + k] -= v
    # reduce zeta_5:  b^4 = -(1 + b + b^2 + b^3)
    for i in range(3):
        for k in range(10):
            v = raw[i * 55 + 4 * 11 + k]
            if v:
                raw[i * 55 + 4 * 11 + k] = Q(0)
                for j in range(4):
                    raw[i * 55 + j * 11 + k] -= v
    # reduce zeta_3:  a^2 = -(1 + a)
    for j in range(4):
        for k in range(10):
            v = raw[2 * 55 + j * 11 + k]
            if v:
                raw[2 * 55 + j * 11 + k] = Q(0)
                for i in range(2):
                    raw[i * 55 + j * 11 + k] -= v
    out = [Q(0)] * DEG
    for i in range(2):
        for j in range(4):
            for k in range(10):
                out[_idx(i, j, k)] = raw[i * 55 + j * 11 + k]
    return tuple(out)


def k_mul(a, b):
    raw = [Q(0)] * 165
    nza = [(t, a[t]) for t in range(DEG) if a[t]]
    nzb = [(t, b[t]) for t in range(DEG) if b[t]]
    for ta, ca in nza:
        ia, r = divmod(ta, 40)
        ja, ka = divmod(r, 10)
        for tb, cb in nzb:
            ib, r2 = divmod(tb, 40)
            jb, kb = divmod(r2, 10)
            raw[((ia + ib) % 3) * 55 + ((ja + jb) % 5) * 11 + ((ka + kb) % 11)] += ca * cb
    return _reduce165(raw)


def k_pow(a, n):
    r = k_from_int(1)
    while n:
        if n & 1:
            r = k_mul(r, a)
        a = k_mul(a, a)
        n //= 2
    return r


def k_is_zero(a):
    return all(x == 0 for x in a)


def k_eq(a, b):
    return all(x == y for x, y in zip(a, b))


def k_galois(a, e3, e5, e11):
    """apply zeta_3 -> zeta_3^e3, zeta_5 -> zeta_5^e5, zeta_11 -> zeta_11^e11."""
    raw = [Q(0)] * 165
    for t in range(DEG):
        c = a[t]
        if not c:
            continue
        i, r = divmod(t, 40)
        j, k = divmod(r, 10)
        raw[((i * e3) % 3) * 55 + ((j * e5) % 5) * 11 + ((k * e11) % 11)] += c
    return _reduce165(raw)


def _inv_zeta11(a):
    """inverse of an element that lies in Q(zeta_11) (basis indices 0..9)."""
    # solve  a * x = 1  in Q[c]/Phi_11 by 10x10 linear system
    M = [[Q(0)] * 11 for _ in range(10)]
    for k in range(10):
        e = [Q(0)] * 165
        for t in range(10):
            if a[t]:
                e[((t + k) % 11)] += a[t]
        red = _reduce165(e)
        for r in range(10):
            M[r][k] = red[r]
    M[0][10] = Q(1)
    # gaussian elimination
    row = 0
    piv = []
    for col in range(10):
        p = None
        for r in range(row, 10):
            if M[r][col]:
                p = r
                break
        if p is None:
            raise ZeroDivisionError('singular')
        M[row], M[p] = M[p], M[row]
        pv = M[row][col]
        M[row] = [x / pv for x in M[row]]
        for r in range(10):
            if r != row and M[r][col]:
                f = M[r][col]
                M[r] = [x - f * y for x, y in zip(M[r], M[row])]
        piv.append(col)
        row += 1
    out = [Q(0)] * DEG
    for r, col in enumerate(piv):
        out[col] = M[r][10]
    return tuple(out)


def k_inv(a):
    if k_is_zero(a):
        raise ZeroDivisionError('k_inv(0)')
    # step 1: norm down to Q(zeta_55)  (kill zeta_3)
    s = k_galois(a, 2, 1, 1)
    n55 = k_mul(a, s)
    num = s
    # step 2: norm down to Q(zeta_11)  (kill zeta_5); Gal generated by zeta_5 -> zeta_5^2
    acc = k_from_int(1)
    for e in (2, 4, 3):
        acc = k_mul(acc, k_galois(n55, 1, e, 1))
    n11 = k_mul(n55, acc)
    num = k_mul(num, acc)
    assert all(n11[t] == 0 for t in range(10, DEG)), 'norm did not land in Q(zeta_11)'
    return k_mul(num, _inv_zeta11(n11))


def k_div(a, b):
    return k_mul(a, k_inv(b))


Z3 = tuple(Q(1) if t == _idx(1, 0, 0) else Q(0) for t in range(DEG))
Z5 = tuple(Q(1) if t == _idx(0, 1, 0) else Q(0) for t in range(DEG))
Z11 = tuple(Q(1) if t == _idx(0, 0, 1) else Q(0) for t in range(DEG))
ONE = k_from_int(1)
ZERO = _Z


def root_of_unity(n, e=1):
    """primitive n-th root of unity to the power e, for n | 330."""
    assert 330 % n == 0, n
    e %= n
    r = ONE
    # zeta_n = zeta_2^{a} zeta_3^{b} zeta_5^{c} zeta_11^{d}
    for p, zp in ((2, None), (3, Z3), (5, Z5), (11, Z11)):
        m = 1
        nn = n
        while nn % p == 0:
            m *= p
            nn //= p
        if m == 1:
            continue
        # component of order m at p; need m == p (330 squarefree)
        assert m == p
        # exponent of zeta_p in zeta_n^e : solve  n/p * t = e mod ... use CRT directly
    # simpler: CRT
    fac = []
    nn = n
    for p in (2, 3, 5, 11):
        if nn % p == 0:
            fac.append(p)
    # zeta_n = prod_p zeta_p^{u_p} with sum_p u_p * (n/p) ... use explicit CRT
    r = ONE
    for p in fac:
        m = n // p
        # find inverse of m mod p
        minv = pow(m % p, -1, p)
        ep = (e * minv) % p
        if p == 2:
            if ep:
                r = k_neg(r)
        elif p == 3:
            r = k_mul(r, k_pow(Z3, ep))
        elif p == 5:
            r = k_mul(r, k_pow(Z5, ep))
        else:
            r = k_mul(r, k_pow(Z11, ep))
    return r


# ------------------------------------------------- the Klein representation
def _build_rep():
    zp = [k_pow(Z11, i) for i in range(11)]
    qr = {1, 3, 4, 5, 9}
    g = ZERO
    for a in range(1, 11):
        g = k_add(g, k_scal(zp[a], 1 if a in qr else -1))
    assert k_eq(k_mul(g, g), k_from_int(-11)), 'gauss sum'
    js = [1, 3, 2, 5, 4]
    signs = [1, 1, -1, 1, 1]
    mg = k_neg(g)
    S = [[k_scal(k_mul(k_sub(zp[(9 * j * l) % 11], zp[(-9 * j * l) % 11]), mg),
                 Q(signs[k], signs[i]) / 11)
          for k, l in enumerate(js)] for i, j in enumerate(js)]
    T = [[zp[(js[i] * js[i]) % 11] if i == j else ZERO for j in range(5)] for i in range(5)]
    return S, T


def matmul(A, B):
    out = []
    for i in range(5):
        row = []
        for j in range(5):
            s = ZERO
            for t in range(5):
                if not k_is_zero(A[i][t]) and not k_is_zero(B[t][j]):
                    s = k_add(s, k_mul(A[i][t], B[t][j]))
            row.append(s)
        out.append(row)
    return out


IDENT = [[ONE if i == j else ZERO for j in range(5)] for i in range(5)]


def mpow(A, n):
    R = IDENT
    while n:
        if n & 1:
            R = matmul(R, A)
        A = matmul(A, A)
        n //= 2
    return R


def mat_eq(A, B):
    return all(k_eq(A[i][j], B[i][j]) for i in range(5) for j in range(5))


# ------------------------------------------------- abstract PSL(2,11)
def fmul(A, B):
    return tuple(sum(A[2 * i + t] * B[2 * t + j] for t in range(2)) % 11
                 for i in range(2) for j in range(2))


def fcanon(A):
    A = tuple(a % 11 for a in A)
    B = tuple((-a) % 11 for a in A)
    return min(A, B)


FONE = fcanon((1, 0, 0, 1))
FS = fcanon((0, 2, 5, 0))
FT = fcanon((1, 2, 0, 1))


def build_group(check_all=True):
    """returns (elements list, index map, rho list of 5x5 matrices over K)."""
    S, T = _build_rep()
    rho = {FONE: IDENT}
    order = [FONE]
    dq = deque([FONE])
    while dq:
        a = dq.popleft()
        for b, R in ((FS, S), (FT, T)):
            c = fcanon(fmul(a, b))
            if c in rho:
                if check_all:
                    assert mat_eq(rho[c], matmul(rho[a], R)), 'Cayley inconsistency'
            else:
                rho[c] = matmul(rho[a], R)
                order.append(c)
                dq.append(c)
    assert len(rho) == 660, len(rho)
    idx = {e: n for n, e in enumerate(order)}
    return order, idx, [rho[e] for e in order]


def elt_order(e):
    n = 1
    x = e
    while x != FONE:
        x = fcanon(fmul(x, e))
        n += 1
    return n


def finv(e):
    a, b, c, d = e
    det = (a * d - b * c) % 11
    di = pow(det, -1, 11)
    return fcanon(((d * di) % 11, (-b * di) % 11, (-c * di) % 11, (a * di) % 11))


# ------------------------------------------------- subgroup enumeration
class GroupTable:
    """PSL(2,11) with elements indexed 0..659 and a precomputed Cayley table."""

    def __init__(self):
        dq = deque([FONE])
        seen = {FONE: 0}
        elts = [FONE]
        while dq:
            a = dq.popleft()
            for b in (FS, FT):
                c = fcanon(fmul(a, b))
                if c not in seen:
                    seen[c] = len(elts)
                    elts.append(c)
                    dq.append(c)
        assert len(elts) == 660
        self.elts = elts
        self.index = seen
        n = 660
        self.mul = [[0] * n for _ in range(n)]
        for i, a in enumerate(elts):
            row = self.mul[i]
            for j, b in enumerate(elts):
                row[j] = seen[fcanon(fmul(a, b))]
        self.inv = [0] * n
        for i in range(n):
            self.inv[i] = seen[finv(elts[i])]
        self.one = seen[FONE]
        self.ordr = [elt_order(e) for e in elts]

    def gen(self, gens):
        S = {self.one}
        fr = [self.one]
        while fr:
            nf = []
            for x in fr:
                mx = self.mul[x]
                for g in gens:
                    y = mx[g]
                    if y not in S:
                        S.add(y)
                        nf.append(y)
            fr = nf
        return frozenset(S)

    def conj(self, H, g):
        gi = self.inv[g]
        mg = self.mul[g]
        return frozenset(self.mul[mg[h]][gi] for h in H)

    def orbit(self, H):
        return frozenset(self.conj(H, g) for g in range(660))

    def normalizer(self, H):
        return frozenset(g for g in range(660) if self.conj(H, g) == H)

    def centralizer(self, H):
        out = []
        for g in range(660):
            mg = self.mul[g]
            if all(mg[h] == self.mul[h][g] for h in H):
                out.append(g)
        return frozenset(out)

    def subgroup_classes(self):
        """All conjugacy classes of subgroups.

        Every subgroup K arises as 1 = K_0 < K_1 < ... < K_r = K with
        K_{i+1} = <K_i, g_i>, so the one-generator-at-a-time closure below is
        complete; conjugation carries such a chain to a chain, so running the
        closure modulo conjugacy is sound."""
        triv = frozenset({self.one})
        reps = [triv]
        gens = [[]]
        orbs = [self.orbit(triv)]
        seen = set(orbs[0])
        frontier = [0]
        while frontier:
            nf = []
            for hi in frontier:
                H, gH = reps[hi], gens[hi]
                for g in range(660):
                    if g in H:
                        continue
                    K = self.gen(gH + [g])
                    if K in seen:
                        continue
                    ob = self.orbit(K)
                    reps.append(K)
                    gens.append(gH + [g])
                    orbs.append(ob)
                    seen |= ob
                    nf.append(len(reps) - 1)
            frontier = nf
        return list(zip(reps, [len(o) for o in orbs], orbs, gens))

    def name(self, H):
        n = len(H)
        orders = sorted(self.ordr[h] for h in H)
        if n == 1:
            return '1'
        if n == 2:
            return 'C2'
        if n == 3:
            return 'C3'
        if n == 4:
            return 'V4'
        if n == 5:
            return 'C5'
        if n == 6:
            return 'C6' if 6 in orders else 'S3'
        if n == 10:
            return 'D10'
        if n == 11:
            return 'C11'
        if n == 12:
            return 'D12' if 6 in orders else 'A4'
        if n == 55:
            return 'C11:C5'
        if n == 60:
            return 'A5'
        if n == 660:
            return 'PSL(2,11)'
        return 'order%d' % n


def group_name(H):
    """isomorphism type name for the subgroups of PSL(2,11) that occur."""
    n = len(H)
    orders = sorted(elt_order(h) for h in H)
    if n == 1:
        return '1'
    if n == 2:
        return 'C2'
    if n == 3:
        return 'C3'
    if n == 4:
        return 'V4'
    if n == 5:
        return 'C5'
    if n == 6:
        return 'C6' if 6 in orders else 'S3'
    if n == 10:
        return 'D10'
    if n == 11:
        return 'C11'
    if n == 12:
        return 'A4' if 6 not in orders else 'D12'
    if n == 55:
        return 'C11:C5'
    if n == 60:
        return 'A5'
    if n == 660:
        return 'PSL(2,11)'
    return 'order%d' % n


# ------------------------------------------------- the Klein cubic
# F = sum_{i in Z/5} x_i^2 x_{i+1}
FMON = [tuple(2 if j == i else 1 if j == (i + 1) % 5 else 0 for j in range(5))
        for i in range(5)]


def F_eval(v):
    """F at a vector v of five K-elements."""
    s = ZERO
    for i in range(5):
        a = v[i]
        b = v[(i + 1) % 5]
        if k_is_zero(a) or k_is_zero(b):
            continue
        s = k_add(s, k_mul(k_mul(a, a), b))
    return s


def F_restrict(basis):
    """coefficients of F on the span of `basis` (list of d vectors),
    as a dict: exponent tuple (length d) -> K-coefficient."""
    d = len(basis)
    out = {}
    for i in range(5):
        # (sum_t s_t b_t[i])^2 * (sum_t s_t b_t[i+1])
        li = [basis[t][i] for t in range(d)]
        lj = [basis[t][(i + 1) % 5] for t in range(d)]
        # square of li
        sq = {}
        for a in range(d):
            if k_is_zero(li[a]):
                continue
            for b in range(d):
                if k_is_zero(li[b]):
                    continue
                e = [0] * d
                e[a] += 1
                e[b] += 1
                e = tuple(e)
                sq[e] = k_add(sq.get(e, ZERO), k_mul(li[a], li[b]))
        for e, c in sq.items():
            for a in range(d):
                if k_is_zero(lj[a]):
                    continue
                ee = list(e)
                ee[a] += 1
                ee = tuple(ee)
                out[ee] = k_add(out.get(ee, ZERO), k_mul(c, lj[a]))
    return {e: c for e, c in out.items() if not k_is_zero(c)}


# ------------------------------------------------- linear algebra over K
def kernel(M, ncols):
    """kernel basis of the list-of-rows matrix M over K (entries K-elements)."""
    rows = [list(r) for r in M]
    piv = []
    r = 0
    for c in range(ncols):
        p = None
        for i in range(r, len(rows)):
            if not k_is_zero(rows[i][c]):
                p = i
                break
        if p is None:
            continue
        rows[r], rows[p] = rows[p], rows[r]
        iv = k_inv(rows[r][c])
        rows[r] = [k_mul(x, iv) for x in rows[r]]
        for i in range(len(rows)):
            if i != r and not k_is_zero(rows[i][c]):
                f = rows[i][c]
                rows[i] = [k_sub(x, k_mul(f, y)) for x, y in zip(rows[i], rows[r])]
        piv.append(c)
        r += 1
        if r == len(rows):
            break
    free = [c for c in range(ncols) if c not in piv]
    basis = []
    for fc in free:
        v = [ZERO] * ncols
        v[fc] = ONE
        for i, c in enumerate(piv):
            v[c] = k_neg(rows[i][fc])
        basis.append(v)
    return basis
