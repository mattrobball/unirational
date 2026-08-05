"""FIX-A0 shared exact-arithmetic library (characteristic 0).

Self-contained: no imports from `certificates/`.  Everything (field, group,
Klein cubic) is rebuilt from generators/definitions inside this module, so
both `produce_*.py` and `verify_*.py` are ALGEBRAIC-RECOMPUTE.

Fields
------
`Cyc`  : Q(zeta_11)                 -- integer numerator vector / positive den
`Cyc3` : Q(zeta_11, omega), omega^2+omega+1=0, i.e. Q(zeta_33) -- pairs over Cyc

All arithmetic is exact rational; no floating point anywhere.
"""
from math import gcd
from functools import reduce

# ---------------------------------------------------------------- Q(zeta_11)

NDEG = 10  # phi(11)


def _norm(n, d):
    if d < 0:
        n = tuple(-x for x in n)
        d = -d
    g = d
    for x in n:
        if x:
            g = gcd(g, x if x > 0 else -x)
        if g == 1:
            break
    if g > 1:
        n = tuple(x // g for x in n)
        d //= g
    return n, d


def _shift_reduce(n, c):
    """integer coefficient vector of (sum n_i z^i) * z^c, reduced mod Phi_11."""
    v = [0] * (2 * NDEG - 1)
    for i, x in enumerate(n):
        if x:
            v[i + c] += x
    for k in range(2 * NDEG - 2, NDEG - 1, -1):
        q = v[k]
        if q:
            v[k] = 0
            base = k - NDEG
            for j in range(NDEG):
                v[base + j] -= q
    return v[:NDEG]


class Cyc:
    """Element of Q(zeta_11) = Q[z]/(1+z+...+z^10)."""
    __slots__ = ('n', 'd')

    def __init__(self, n=(0,) * NDEG, d=1):
        self.n = n
        self.d = d

    @staticmethod
    def from_int(k):
        return Cyc((k,) + (0,) * (NDEG - 1), 1)

    @staticmethod
    def from_frac(p, q):
        n, d = _norm((p,) + (0,) * (NDEG - 1), q)
        return Cyc(n, d)

    @staticmethod
    def zeta(k):
        """zeta_11^k, k any integer."""
        k %= 11
        if k < 10:
            return Cyc(tuple(1 if i == k else 0 for i in range(NDEG)), 1)
        return Cyc((-1,) * NDEG, 1)          # z^10 = -(1+z+...+z^9)

    def is_zero(self):
        return not any(self.n)

    def __bool__(self):
        return any(self.n)

    def __eq__(self, o):
        if isinstance(o, int):
            o = Cyc.from_int(o)
        return self.n == o.n and self.d == o.d

    def __hash__(self):
        return hash((self.n, self.d))

    def __neg__(self):
        return Cyc(tuple(-x for x in self.n), self.d)

    def __add__(self, o):
        if isinstance(o, int):
            o = Cyc.from_int(o)
        a, b = self.d, o.d
        g = gcd(a, b)
        m = a // g * b
        ka, kb = m // a, m // b
        n, d = _norm(tuple(x * ka + y * kb for x, y in zip(self.n, o.n)), m)
        return Cyc(n, d)

    __radd__ = __add__

    def __sub__(self, o):
        return self + (-o if not isinstance(o, int) else Cyc.from_int(-o))

    def __rsub__(self, o):
        return (-self) + o

    def __mul__(self, o):
        if isinstance(o, int):
            if o == 0:
                return Cyc()
            n, d = _norm(tuple(x * o for x in self.n), self.d)
            return Cyc(n, d)
        v = [0] * (2 * NDEG - 1)
        sn, on = self.n, o.n
        for i, x in enumerate(sn):
            if x:
                for j, y in enumerate(on):
                    if y:
                        v[i + j] += x * y
        for k in range(2 * NDEG - 2, NDEG - 1, -1):
            q = v[k]
            if q:
                v[k] = 0
                base = k - NDEG
                for j in range(NDEG):
                    v[base + j] -= q
        n, d = _norm(tuple(v[:NDEG]), self.d * o.d)
        return Cyc(n, d)

    __rmul__ = __mul__

    def __pow__(self, e):
        r = ONE
        b = self
        while e:
            if e & 1:
                r = r * b
            b = b * b
            e >>= 1
        return r

    def inv(self):
        """Exact inverse via linear algebra in the 10-dim Q-basis."""
        if self.is_zero():
            raise ZeroDivisionError('Cyc inverse of 0')
        # columns of the multiplication-by-(numerator) matrix on 1,z,...,z^9
        cols = [_shift_reduce(self.n, c) for c in range(NDEG)]
        # solve  sum_c y_c * cols[c] = d * e_0   over Q
        M = [[Fr(cols[c][r], 1) for c in range(NDEG)] +
             [Fr(self.d if r == 0 else 0, 1)] for r in range(NDEG)]
        sol = _solve_rational(M)
        L = reduce(lambda a, b: a * b // gcd(a, b), [s.q for s in sol], 1)
        n = tuple(s.p * (L // s.q) for s in sol)
        nn, dd = _norm(n, L)
        return Cyc(nn, dd)

    def __truediv__(self, o):
        if isinstance(o, int):
            n, d = _norm(self.n, self.d * o)
            return Cyc(n, d)
        return self * o.inv()

    def conj(self, k):
        """Galois conjugation zeta -> zeta^k (k coprime to 11)."""
        v = [0] * (2 * NDEG - 1)
        for i, c in enumerate(self.n):
            if c:
                e = (i * k) % 11
                if e < NDEG:
                    v[e] += c
                else:                      # z^10 = -(1+z+...+z^9)
                    for j in range(NDEG):
                        v[j] -= c
        n, d = _norm(tuple(v[:NDEG]), self.d)
        return Cyc(n, d)

    def is_rational(self):
        return all(x == 0 for x in self.n[1:])

    def to_rational(self):
        assert self.is_rational(), 'not rational: %r' % (self,)
        return Fr(self.n[0], self.d)

    def __repr__(self):
        if self.is_zero():
            return '0'
        terms = []
        for i, c in enumerate(self.n):
            if c:
                terms.append('%d*z^%d' % (c, i) if i else '%d' % c)
        s = '+'.join(terms).replace('+-', '-')
        return s if self.d == 1 else '(%s)/%d' % (s, self.d)

    def json(self):
        return {'num': list(self.n), 'den': self.d}


ZERO = Cyc()
ONE = Cyc.from_int(1)


class Fr:
    """minimal exact rational (avoids fractions.Fraction overhead in hot loops)"""
    __slots__ = ('p', 'q')

    def __init__(self, p, q=1):
        if q == 0:
            raise ZeroDivisionError
        if q < 0:
            p, q = -p, -q
        g = gcd(p if p > 0 else -p, q)
        if g > 1:
            p //= g
            q //= g
        self.p, self.q = p, q

    def __add__(s, o):
        return Fr(s.p * o.q + o.p * s.q, s.q * o.q)

    def __sub__(s, o):
        return Fr(s.p * o.q - o.p * s.q, s.q * o.q)

    def __mul__(s, o):
        return Fr(s.p * o.p, s.q * o.q)

    def __truediv__(s, o):
        return Fr(s.p * o.q, s.q * o.p)

    def __neg__(s):
        return Fr(-s.p, s.q)

    def __bool__(s):
        return s.p != 0

    def __eq__(s, o):
        return s.p == o.p and s.q == o.q

    def __repr__(s):
        return '%d' % s.p if s.q == 1 else '%d/%d' % (s.p, s.q)


def _solve_rational(aug):
    """Gauss-Jordan on an n x (n+1) augmented Fr matrix; returns solution list."""
    n = len(aug)
    M = [row[:] for row in aug]
    piv = []
    r = 0
    for c in range(n):
        pr = None
        for rr in range(r, n):
            if M[rr][c]:
                pr = rr
                break
        if pr is None:
            continue
        M[r], M[pr] = M[pr], M[r]
        inv = Fr(M[r][c].q, M[r][c].p)
        M[r] = [x * inv for x in M[r]]
        for rr in range(n):
            if rr != r and M[rr][c]:
                f = M[rr][c]
                M[rr] = [x - f * y for x, y in zip(M[rr], M[r])]
        piv.append(c)
        r += 1
    sol = [Fr(0, 1)] * n
    for i, c in enumerate(piv):
        sol[c] = M[i][n]
    return sol


# ------------------------------------------------------- Q(zeta_11, omega)

class Cyc3:
    """a + b*omega with a,b in Q(zeta_11), omega^2 = -1-omega  (= Q(zeta_33))."""
    __slots__ = ('a', 'b')

    def __init__(self, a=ZERO, b=ZERO):
        self.a, self.b = a, b

    @staticmethod
    def lift(c):
        return Cyc3(c, ZERO)

    def is_zero(self):
        return self.a.is_zero() and self.b.is_zero()

    def __bool__(self):
        return not self.is_zero()

    def __eq__(s, o):
        if isinstance(o, int):
            o = Cyc3.lift(Cyc.from_int(o))
        return s.a == o.a and s.b == o.b

    def __hash__(s):
        return hash((s.a, s.b))

    def __neg__(s):
        return Cyc3(-s.a, -s.b)

    def __add__(s, o):
        if isinstance(o, int):
            o = Cyc3.lift(Cyc.from_int(o))
        elif isinstance(o, Cyc):
            o = Cyc3.lift(o)
        return Cyc3(s.a + o.a, s.b + o.b)

    __radd__ = __add__

    def __sub__(s, o):
        if isinstance(o, int):
            o = Cyc3.lift(Cyc.from_int(o))
        elif isinstance(o, Cyc):
            o = Cyc3.lift(o)
        return Cyc3(s.a - o.a, s.b - o.b)

    def __rsub__(s, o):
        return (-s) + o

    def __mul__(s, o):
        if isinstance(o, int):
            return Cyc3(s.a * o, s.b * o)
        if isinstance(o, Cyc):
            return Cyc3(s.a * o, s.b * o)
        ac = s.a * o.a
        bd = s.b * o.b
        return Cyc3(ac - bd, s.a * o.b + s.b * o.a - bd)

    __rmul__ = __mul__

    def __pow__(s, e):
        r = Cyc3(ONE, ZERO)
        b = s
        while e:
            if e & 1:
                r = r * b
            b = b * b
            e >>= 1
        return r

    def inv(s):
        # norm to Q(zeta_11): (a+b w)(a+b w^2) = a^2 - ab + b^2
        conj = Cyc3(s.a - s.b, -s.b)      # a + b*w^2 = (a-b) - b*w
        nm = (s * conj).a                  # must be in Q(zeta_11)
        assert (s * conj).b.is_zero()
        i = nm.inv()
        return Cyc3(conj.a * i, conj.b * i)

    def __truediv__(s, o):
        if isinstance(o, int):
            return Cyc3(s.a / o, s.b / o)
        if isinstance(o, Cyc):
            i = o.inv()
            return Cyc3(s.a * i, s.b * i)
        return s * o.inv()

    def in_base(s):
        return s.b.is_zero()

    def base(s):
        assert s.b.is_zero()
        return s.a

    def __repr__(s):
        return '(%r) + (%r)*w' % (s.a, s.b)


C3ZERO = Cyc3()
C3ONE = Cyc3(ONE, ZERO)
OMEGA = Cyc3(ZERO, ONE)


# --------------------------------------------------- generic linear algebra

def mat_mul(A, B, F=Cyc):
    n, m, p = len(A), len(B), len(B[0])
    zero = ZERO if F is Cyc else C3ZERO
    out = []
    for i in range(n):
        Ai = A[i]
        row = []
        for j in range(p):
            s = zero
            for k in range(m):
                a = Ai[k]
                if a:
                    s = s + a * B[k][j]
            row.append(s)
        out.append(row)
    return out


def mat_vec(A, v, F=Cyc):
    zero = ZERO if F is Cyc else C3ZERO
    out = []
    for row in A:
        s = zero
        for a, x in zip(row, v):
            if a and x:
                s = s + a * x
        out.append(s)
    return out


def identity(n, F=Cyc):
    if F is Cyc:
        return [[ONE if i == j else ZERO for j in range(n)] for i in range(n)]
    return [[C3ONE if i == j else C3ZERO for j in range(n)] for i in range(n)]


def mat_pow(A, e, F=Cyc):
    R = identity(len(A), F)
    B = A
    while e:
        if e & 1:
            R = mat_mul(R, B, F)
        B = mat_mul(B, B, F)
        e >>= 1
    return R


def rref(rows, F=Cyc):
    """Reduced row echelon form; returns (M, pivot_columns)."""
    M = [list(r) for r in rows]
    if not M:
        return [], []
    ncol = len(M[0])
    piv = []
    r = 0
    for c in range(ncol):
        pr = None
        for rr in range(r, len(M)):
            if M[rr][c]:
                pr = rr
                break
        if pr is None:
            continue
        M[r], M[pr] = M[pr], M[r]
        inv = M[r][c].inv()
        M[r] = [x * inv for x in M[r]]
        for rr in range(len(M)):
            if rr != r and M[rr][c]:
                f = M[rr][c]
                M[rr] = [x - f * y for x, y in zip(M[rr], M[r])]
        piv.append(c)
        r += 1
        if r == len(M):
            break
    return M[:r], piv


def rank(rows, F=Cyc):
    return len(rref(rows, F)[1])


def nullspace(rows, ncol, F=Cyc):
    """Basis (list of vectors) of {x : rows . x = 0}."""
    one = ONE if F is Cyc else C3ONE
    zero = ZERO if F is Cyc else C3ZERO
    if not rows:
        return [[one if i == j else zero for i in range(ncol)] for j in range(ncol)]
    R, piv = rref(rows, F)
    free = [c for c in range(ncol) if c not in piv]
    basis = []
    for fc in free:
        v = [zero] * ncol
        v[fc] = one
        for i, pc in enumerate(piv):
            v[pc] = -R[i][fc]
        basis.append(v)
    return basis


def rowspace_basis(rows, F=Cyc):
    return rref(rows, F)[0]


def annihilator(rows, ncol, F=Cyc):
    """Functionals vanishing on rowspan(rows)  ==  nullspace(rows)."""
    return nullspace(rows, ncol, F)


def subspace_intersection(U, V, ncol, F=Cyc):
    """Intersection of rowspan(U) and rowspan(V) inside k^ncol."""
    AU = annihilator(U, ncol, F)
    AV = annihilator(V, ncol, F)
    return nullspace(AU + AV, ncol, F)


def subspace_key(U, F=Cyc):
    """Canonical hashable key for a subspace given by spanning rows."""
    R, piv = rref(U, F)
    if F is Cyc:
        return tuple(tuple((x.n, x.d) for x in row) for row in R)
    return tuple(tuple(((x.a.n, x.a.d), (x.b.n, x.b.d)) for x in row) for row in R)


# ----------------------------------------------------------- the group PSL(2,11)

QR11 = {1, 3, 4, 5, 9}


def gauss_sum():
    g = ZERO
    for a in range(1, 11):
        g = g + (Cyc.zeta(a) if a in QR11 else -Cyc.zeta(a))
    return g


def generators():
    """S, T generating the 5-dim Weil representation of PSL(2,11) over Q(zeta_11).

    Rebuilt from the defining formulas (same normalisation as
    certificates/exact_weil_check.py), NOT read from any file.
    """
    g = gauss_sum()
    assert g * g == Cyc.from_int(-11), 'gauss sum g^2 = -11 failed'
    js = [1, 3, 2, 5, 4]
    signs = [1, 1, -1, 1, 1]
    S = [[Cyc.from_frac(signs[k], signs[i]) *
          (Cyc.zeta(9 * j * l) - Cyc.zeta(-9 * j * l)) * (-g) / 11
          for k, l in enumerate(js)] for i, j in enumerate(js)]
    T = [[Cyc.zeta(js[i] * js[i]) if i == j else ZERO for j in range(5)]
         for i in range(5)]
    return S, T


def mat_key(A):
    return tuple((x.n, x.d) for row in A for x in row)


def build_group():
    """BFS closure of <S,T>; returns list of 5x5 matrices over Q(zeta_11)."""
    S, T = generators()
    I = identity(5)
    seen = {mat_key(I): I}
    frontier = [I]
    while frontier:
        nxt = []
        for A in frontier:
            for gmat in (S, T):
                B = mat_mul(A, gmat)
                k = mat_key(B)
                if k not in seen:
                    seen[k] = B
                    nxt.append(B)
        frontier = nxt
    return list(seen.values())


class Grp:
    """The matrix group <S,T> with O(1)-ish index arithmetic.

    Built by BFS under RIGHT multiplication by generators; every element gets
    a generator word, so products are computed by replaying words through the
    generator action tables (no further field arithmetic).
    """

    def __init__(self):
        S, T = generators()
        self.gens = [S, T]
        I = identity(5)
        self.mats = [I]
        self.index = {mat_key(I): 0}
        self.word = [()]
        self.act = [[None], [None]]
        q = [0]
        while q:
            nq = []
            for i in q:
                for gi, gm in enumerate(self.gens):
                    B = mat_mul(self.mats[i], gm)
                    k = mat_key(B)
                    j = self.index.get(k)
                    if j is None:
                        j = len(self.mats)
                        self.index[k] = j
                        self.mats.append(B)
                        self.word.append(self.word[i] + (gi,))
                        for a in self.act:
                            a.append(None)
                        nq.append(j)
                    self.act[gi][i] = j
            q = nq
        self.n = len(self.mats)
        # inverses and orders
        self.ord = [0] * self.n
        self.inv = [0] * self.n
        for i in range(self.n):
            k = i
            o = 1
            while k != 0:
                k = self.mul(k, i)
                o += 1
            self.ord[i] = o
            self.inv[i] = self.pow(i, o - 1)

    def mul(self, i, j):
        for g in self.word[j]:
            i = self.act[g][i]
        return i

    def pow(self, i, e):
        r = 0
        b = i
        while e:
            if e & 1:
                r = self.mul(r, b)
            b = self.mul(b, b)
            e >>= 1
        return r

    def conj(self, i, j):
        """j * i * j^{-1}"""
        return self.mul(self.mul(j, i), self.inv[j])

    def centralizer(self, i):
        return [j for j in range(self.n)
                if self.mul(i, j) == self.mul(j, i)]

    def subgroup_closure(self, gens):
        S = {0}
        frontier = [0]
        while frontier:
            nf = []
            for a in frontier:
                for g in gens:
                    b = self.mul(a, g)
                    if b not in S:
                        S.add(b)
                        nf.append(b)
            frontier = nf
        return sorted(S)


# --------------------------------------------------------- the Klein cubic

# F = x0^2 x1 + x1^2 x2 + x2^2 x3 + x3^2 x4 + x4^2 x0
KLEIN_TERMS = [((i, i, (i + 1) % 5)) for i in range(5)]


def klein_eval(v, F=Cyc):
    """F(v) for a length-5 vector over F."""
    zero = ZERO if F is Cyc else C3ZERO
    s = zero
    for i in range(5):
        s = s + v[i] * v[i] * v[(i + 1) % 5]
    return s


def klein_grad(v, F=Cyc):
    """gradient (dF/dx0,...,dF/dx4) at v."""
    zero = ZERO if F is Cyc else C3ZERO
    g = [zero] * 5
    for i in range(5):
        j = (i + 1) % 5
        g[i] = g[i] + v[i] * v[j] * 2
        g[j] = g[j] + v[i] * v[i]
    return g


# ---------------------------------------------- multivariate polynomials (exact)

class Poly:
    """sparse multivariate polynomial: dict exponent-tuple -> field element."""
    __slots__ = ('c', 'nv', 'F')

    def __init__(self, c=None, nv=1, F=Cyc):
        self.c = {} if c is None else {e: v for e, v in c.items() if v}
        self.nv = nv
        self.F = F

    @staticmethod
    def const(val, nv, F=Cyc):
        return Poly({(0,) * nv: val}, nv, F)

    @staticmethod
    def var(i, nv, F=Cyc):
        one = ONE if F is Cyc else C3ONE
        e = tuple(1 if k == i else 0 for k in range(nv))
        return Poly({e: one}, nv, F)

    def __add__(s, o):
        out = dict(s.c)
        for e, v in o.c.items():
            w = out.get(e)
            out[e] = v if w is None else w + v
        return Poly(out, s.nv, s.F)

    def __neg__(s):
        return Poly({e: -v for e, v in s.c.items()}, s.nv, s.F)

    def __sub__(s, o):
        return s + (-o)

    def __mul__(s, o):
        if not isinstance(o, Poly):
            return Poly({e: v * o for e, v in s.c.items()}, s.nv, s.F)
        out = {}
        for e1, v1 in s.c.items():
            for e2, v2 in o.c.items():
                e = tuple(a + b for a, b in zip(e1, e2))
                w = out.get(e)
                out[e] = v1 * v2 if w is None else w + v1 * v2
        return Poly(out, s.nv, s.F)

    __rmul__ = __mul__

    def __pow__(s, n):
        r = Poly.const(ONE if s.F is Cyc else C3ONE, s.nv, s.F)
        b = s
        while n:
            if n & 1:
                r = r * b
            b = b * b
            n >>= 1
        return r

    def is_zero(s):
        return not s.c

    def __repr__(s):
        if not s.c:
            return '0'
        return ' + '.join('(%r)*%s' % (v, e) for e, v in sorted(s.c.items()))
