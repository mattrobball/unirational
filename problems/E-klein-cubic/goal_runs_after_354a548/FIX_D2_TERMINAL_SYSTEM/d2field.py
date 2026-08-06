"""FIX-D2 : exact field K = Q(om, nu),  om^2+om+1 = 0,  nu^2 = -11.

Basis over Q:  (1, om, nu, om*nu).   No sympy, no floats anywhere.
Shared by produce_d2.py.  verify_d2.py has its OWN independent copy
(different internal representation) -- see that file.
"""
from fractions import Fraction as Fr

DIM = 4
NAMES = ("1", "om", "nu", "om*nu")


def K(*coeffs):
    c = [Fr(x) for x in coeffs] + [Fr(0)] * (DIM - len(coeffs))
    return tuple(c[:DIM])


ZERO = K(0)
ONE = K(1)
OM = K(0, 1)
NU = K(0, 0, 1)
OMNU = K(0, 0, 0, 1)
# delta = om - om^2 = 1 + 2om ;  delta^2 = -3
DELTA = K(1, 2)
# sqrt33 = -nu*delta = -nu - 2*om*nu   (positive real root in the H1 embedding)
S33 = K(0, 0, -1, -2)

# multiplication table on the basis, as coefficient vectors
_MUL = [[None] * DIM for _ in range(DIM)]
_MUL[0][0] = K(1)
_MUL[0][1] = K(0, 1)
_MUL[0][2] = K(0, 0, 1)
_MUL[0][3] = K(0, 0, 0, 1)
_MUL[1][1] = K(-1, -1)                  # om^2 = -1-om
_MUL[1][2] = K(0, 0, 0, 1)              # om*nu
_MUL[1][3] = K(0, 0, -1, -1)            # om^2 nu = -nu - om nu
_MUL[2][2] = K(-11)                     # nu^2
_MUL[2][3] = K(0, -11)                  # om nu^2 = -11 om
_MUL[3][3] = K(11, 11)                  # om^2 nu^2 = 11 + 11 om
for i in range(DIM):
    for j in range(DIM):
        if _MUL[i][j] is None:
            _MUL[i][j] = _MUL[j][i]


def add(a, b):
    return tuple(x + y for x, y in zip(a, b))


def sub(a, b):
    return tuple(x - y for x, y in zip(a, b))


def neg(a):
    return tuple(-x for x in a)


def mul(a, b):
    out = [Fr(0)] * DIM
    for i in range(DIM):
        if a[i] == 0:
            continue
        for j in range(DIM):
            if b[j] == 0:
                continue
            t = a[i] * b[j]
            m = _MUL[i][j]
            for k in range(DIM):
                if m[k]:
                    out[k] += t * m[k]
    return tuple(out)


def scal(q, a):
    q = Fr(q)
    return tuple(q * x for x in a)


def is_zero(a):
    return all(x == 0 for x in a)


def eq(a, b):
    return is_zero(sub(a, b))


def _mulmatrix(a):
    """matrix of multiplication-by-a in the basis (columns = a*e_j)."""
    cols = []
    for j in range(DIM):
        e = [Fr(0)] * DIM
        e[j] = Fr(1)
        cols.append(mul(a, tuple(e)))
    return [[cols[j][i] for j in range(DIM)] for i in range(DIM)]


def inv(a):
    if is_zero(a):
        raise ZeroDivisionError("K.inv(0)")
    M = _mulmatrix(a)
    rhs = [Fr(1), Fr(0), Fr(0), Fr(0)]
    n = DIM
    A = [row[:] + [rhs[i]] for i, row in enumerate(M)]
    piv = 0
    where = [-1] * n
    for col in range(n):
        r = None
        for i in range(piv, n):
            if A[i][col] != 0:
                r = i
                break
        if r is None:
            continue
        A[piv], A[r] = A[r], A[piv]
        p = A[piv][col]
        A[piv] = [x / p for x in A[piv]]
        for i in range(n):
            if i != piv and A[i][col] != 0:
                f = A[i][col]
                A[i] = [x - f * y for x, y in zip(A[i], A[piv])]
        where[col] = piv
        piv += 1
    if any(w < 0 for w in where):
        raise ZeroDivisionError("not invertible (should not happen: K is a field)")
    return tuple(A[where[j]][n] for j in range(n))


def div(a, b):
    return mul(a, inv(b))


def tostr(a):
    parts = []
    for i, x in enumerate(a):
        if x == 0:
            continue
        s = str(x)
        parts.append(s if i == 0 else "(%s)*%s" % (s, NAMES[i]))
    return " + ".join(parts) if parts else "0"


# ---------------------------------------------------------------- numeric
def tonum(a, om_c, nu_c):
    """evaluate in C given complex values of om and nu (sanity layer only)."""
    return (complex(a[0]) + complex(a[1]) * om_c + complex(a[2]) * nu_c
            + complex(a[3]) * om_c * nu_c)


# ---------------------------------------------------------------- lin alg
def rref(rows):
    """Gauss-Jordan over K.  rows = list of lists of K-elements.
    Returns (R, pivots)."""
    R = [list(r) for r in rows]
    if not R:
        return R, []
    n = len(R[0])
    piv = 0
    pivots = []
    for col in range(n):
        r = None
        for i in range(piv, len(R)):
            if not is_zero(R[i][col]):
                r = i
                break
        if r is None:
            continue
        R[piv], R[r] = R[r], R[piv]
        ip = inv(R[piv][col])
        R[piv] = [mul(ip, x) for x in R[piv]]
        for i in range(len(R)):
            if i != piv and not is_zero(R[i][col]):
                f = R[i][col]
                R[i] = [sub(x, mul(f, y)) for x, y in zip(R[i], R[piv])]
        pivots.append(col)
        piv += 1
        if piv == len(R):
            break
    return R, pivots


def rank(rows):
    return len(rref(rows)[1])


def nullspace(rows, ncols=None):
    """basis of {v : rows . v = 0}, as list of K-vectors of length ncols."""
    if ncols is None:
        ncols = len(rows[0]) if rows else 0
    if not rows:
        rows = [[ZERO] * ncols]
    R, pivots = rref(rows)
    free = [j for j in range(ncols) if j not in pivots]
    basis = []
    for f in free:
        v = [ZERO] * ncols
        v[f] = ONE
        for i, p in enumerate(pivots):
            v[p] = neg(R[i][f])
        basis.append(v)
    return basis
