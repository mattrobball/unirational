"""Exact arithmetic in the degree-4 field K0 = QQ(om, nu),
om^2+om+1 = 0, nu^2 = -11  (so K0 = QQ(zeta_3, sqrt(-11))).

Elements are 4-tuples of Fractions in the QQ-basis (1, om, nu, om*nu).
Self-contained; independent of `klein_exact` (used as the second engine).
"""
from fractions import Fraction as Fr

DIM = 4
# multiplication table of the basis (1, om, nu, om nu)
#   om^2      = -1 - om
#   om*nu     = om nu
#   om*(om nu)= om^2 nu = -nu - om nu
#   nu^2      = -11
#   nu*(om nu)= -11 om
#   (om nu)^2 = om^2 nu^2 = 11 + 11 om
_MT = [[None] * DIM for _ in range(DIM)]
_MT[0][0] = (1, 0, 0, 0)
_MT[0][1] = _MT[1][0] = (0, 1, 0, 0)
_MT[0][2] = _MT[2][0] = (0, 0, 1, 0)
_MT[0][3] = _MT[3][0] = (0, 0, 0, 1)
_MT[1][1] = (-1, -1, 0, 0)
_MT[1][2] = _MT[2][1] = (0, 0, 0, 1)
_MT[1][3] = _MT[3][1] = (0, 0, -1, -1)
_MT[2][2] = (-11, 0, 0, 0)
_MT[2][3] = _MT[3][2] = (0, -11, 0, 0)
_MT[3][3] = (11, 11, 0, 0)


class K:
    __slots__ = ('c',)

    def __init__(self, c=(0, 0, 0, 0)):
        self.c = tuple(Fr(v) for v in c)

    @staticmethod
    def rat(p, q=1):
        return K((Fr(p, q), 0, 0, 0))

    def __eq__(s, o):
        o = _co(o)
        return s.c == o.c

    def __hash__(s):
        return hash(s.c)

    def __bool__(s):
        return any(s.c)

    def is_zero(s):
        return not any(s.c)

    def __neg__(s):
        return K(tuple(-v for v in s.c))

    def __add__(s, o):
        o = _co(o)
        return K(tuple(a + b for a, b in zip(s.c, o.c)))
    __radd__ = __add__

    def __sub__(s, o):
        return s + (-_co(o))

    def __rsub__(s, o):
        return _co(o) + (-s)

    def __mul__(s, o):
        o = _co(o)
        out = [Fr(0)] * DIM
        for i, a in enumerate(s.c):
            if not a:
                continue
            for j, b in enumerate(o.c):
                if not b:
                    continue
                t = _MT[i][j]
                ab = a * b
                for k in range(DIM):
                    if t[k]:
                        out[k] += ab * t[k]
        return K(out)
    __rmul__ = __mul__

    def __pow__(s, n):
        r = ONE
        b = s
        while n:
            if n & 1:
                r = r * b
            b = b * b
            n >>= 1
        return r

    def inv(s):
        assert not s.is_zero(), 'division by zero in K0'
        # solve  s * t = 1  as a 4x4 rational system
        rows = []
        for k in range(DIM):
            row = []
            for j in range(DIM):
                acc = Fr(0)
                for i in range(DIM):
                    if s.c[i] and _MT[i][j][k]:
                        acc += s.c[i] * _MT[i][j][k]
                row.append(acc)
            row.append(Fr(1) if k == 0 else Fr(0))
            rows.append(row)
        sol = _solve_q(rows, DIM)
        t = K(sol)
        assert (s * t) == ONE, 'inverse failed'
        return t

    def __truediv__(s, o):
        return s * _co(o).inv()

    def __rtruediv__(s, o):
        return _co(o) * s.inv()

    def conj_om(s):
        """the automorphism om -> om^2 (nu fixed)."""
        a, b, c, d = s.c
        # om -> -1-om ; om nu -> (-1-om) nu = -nu - om nu
        return K((a - b, -b, c - d, -d))

    def conj_nu(s):
        """the automorphism nu -> -nu (om fixed)."""
        a, b, c, d = s.c
        return K((a, b, -c, -d))

    def __repr__(s):
        parts = []
        for v, nm in zip(s.c, ('1', 'om', 'nu', 'om*nu')):
            if v:
                parts.append('%s%s' % (v, '' if nm == '1' else '*' + nm))
        return ' + '.join(parts) if parts else '0'

    def cplx(s):
        import cmath
        om = cmath.exp(2j * cmath.pi / 3)
        nu = 1j * (11 ** 0.5)
        return (float(s.c[0]) + float(s.c[1]) * om + float(s.c[2]) * nu
                + float(s.c[3]) * om * nu)


def _co(o):
    if isinstance(o, K):
        return o
    if isinstance(o, (int, Fr)):
        return K((Fr(o), 0, 0, 0))
    raise TypeError(type(o))


def _solve_q(rows, n):
    """solve an n x (n+1) rational system with a unique solution."""
    M = [list(r) for r in rows]
    piv = []
    r = 0
    for c in range(n):
        pr = None
        for rr in range(r, len(M)):
            if M[rr][c]:
                pr = rr
                break
        if pr is None:
            continue
        M[r], M[pr] = M[pr], M[r]
        f = M[r][c]
        M[r] = [v / f for v in M[r]]
        for rr in range(len(M)):
            if rr != r and M[rr][c]:
                g = M[rr][c]
                M[rr] = [a - g * b for a, b in zip(M[rr], M[r])]
        piv.append(c)
        r += 1
    sol = [Fr(0)] * n
    for i, c in enumerate(piv):
        sol[c] = M[i][n]
    return sol


ZERO = K((0, 0, 0, 0))
ONE = K((1, 0, 0, 0))
OM = K((0, 1, 0, 0))
OM2 = K((-1, -1, 0, 0))
NU = K((0, 0, 1, 0))
# kappa_+ = (13 + 3 sqrt 33)/16 ; sqrt33 = -(2om+1) nu
DL = K((1, 2, 0, 0))                     # 2om+1 = sqrt(-3)
KP = (K.rat(13) - K.rat(3) * DL * NU) / K.rat(16)
KM = K.rat(13, 8) - KP


# ------------------------------------------------------- linear algebra over K
def rref(rows):
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
        f = M[r][c].inv()
        M[r] = [v * f for v in M[r]]
        for rr in range(len(M)):
            if rr != r and M[rr][c]:
                g = M[rr][c]
                M[rr] = [a - g * b for a, b in zip(M[rr], M[r])]
        piv.append(c)
        r += 1
        if r == len(M):
            break
    return M[:r], piv


def rank(rows):
    return len(rref(rows)[1])


def nullspace(rows, ncol):
    if not rows:
        return [[ONE if i == j else ZERO for i in range(ncol)]
                for j in range(ncol)]
    R, piv = rref(rows)
    free = [c for c in range(ncol) if c not in piv]
    out = []
    for fc in free:
        v = [ZERO] * ncol
        v[fc] = ONE
        for i, pc in enumerate(piv):
            v[pc] = -R[i][fc]
        out.append(v)
    return out
