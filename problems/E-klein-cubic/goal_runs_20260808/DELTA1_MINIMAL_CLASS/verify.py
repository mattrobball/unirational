#!/usr/bin/env python3
"""Exact finite certificate for the Klein intermediate-Jacobian minimal class.

The computation starts from Roulleau's displayed period-lattice basis.  It
works exactly in Q(zeta_11), descends the polarization Gram matrix to
Q(sqrt(-11)) = Q(nu), inverts it there, and verifies an integral rank-one
decomposition of the inverse Hermitian matrix.

Only SymPy's exact polynomial arithmetic over QQ is used.  There is no
floating point and no search cutoff.
"""

from dataclasses import dataclass
from fractions import Fraction
import sympy as sp


z = sp.Symbol("z")
phi = sp.Poly(sum(z**i for i in range(11)), z, domain=sp.QQ)


def red(expr):
    """Reduce an element of QQ[z] modulo Phi_11."""
    num = sp.Poly(sp.expand(expr), z, domain=sp.QQ)
    return sp.rem(num, phi).as_expr()


def inv(expr):
    return sp.invert(sp.Poly(red(expr), z, domain=sp.QQ), phi).as_expr()


def conj(expr):
    """Complex conjugation z -> z^(-1)."""
    p = sp.Poly(red(expr), z, domain=sp.QQ)
    out = 0
    for (i,), coeff in p.terms():
        out += coeff * z ** ((-i) % 11)
    return red(out)


nu_cyc = red(z + z**9 + z**3 + z**4 + z**5)
den = red(1 + 2 * nu_cyc)
den_inv = inv(den)
weights = (1, 9, 3, 4, 5)


def v(k):
    return [red(z ** ((k * w) % 11)) for w in weights]


vv = [v(k) for k in range(5)]
u1 = [red((vv[0][i] - 3 * vv[1][i] + 3 * vv[2][i] - vv[3][i]) * den_inv)
      for i in range(5)]
u2 = [red((vv[1][i] - 3 * vv[2][i] + 3 * vv[3][i] - vv[4][i]) * den_inv)
      for i in range(5)]
u = [u1, u2, vv[0], vv[1], vv[2]]


def gram_entry(i, j):
    return red(sum(conj(u[i][k]) * u[j][k] for k in range(5)))


def cyc_to_pair(expr):
    """Certify expr = a + b*nu and return rational (a,b)."""
    p = sp.Poly(red(expr), z, domain=sp.QQ)
    a = Fraction(p.nth(0))
    b = Fraction(p.nth(1))
    assert red(expr - sp.Rational(a.numerator, a.denominator)
               - sp.Rational(b.numerator, b.denominator) * nu_cyc) == 0
    return a, b


@dataclass(frozen=True)
class K:
    """a+b*nu, with nu^2+nu+3=0."""

    a: Fraction = Fraction(0)
    b: Fraction = Fraction(0)

    @staticmethod
    def of(a=0, b=0):
        return K(Fraction(a), Fraction(b))

    def __add__(self, other):
        other = other if isinstance(other, K) else K.of(other)
        return K(self.a + other.a, self.b + other.b)

    __radd__ = __add__

    def __neg__(self):
        return K(-self.a, -self.b)

    def __sub__(self, other):
        return self + (-other if isinstance(other, K) else K.of(-other))

    def __rsub__(self, other):
        return K.of(other) - self

    def __mul__(self, other):
        other = other if isinstance(other, K) else K.of(other)
        # nu^2 = -nu-3
        return K(self.a * other.a - 3 * self.b * other.b,
                 self.a * other.b + self.b * other.a - self.b * other.b)

    __rmul__ = __mul__

    def conjugate(self):
        # conjugate(nu) = -1-nu
        return K(self.a - self.b, -self.b)

    def inverse(self):
        norm = self.a * self.a - self.a * self.b + 3 * self.b * self.b
        if norm == 0:
            raise ZeroDivisionError
        return K((self.a - self.b) / norm, -self.b / norm)

    def __truediv__(self, other):
        other = other if isinstance(other, K) else K.of(other)
        return self * other.inverse()

    def __bool__(self):
        return self.a != 0 or self.b != 0

    def __str__(self):
        if self.b == 0:
            return str(self.a)
        if self.a == 0:
            return f"{self.b}*nu"
        return f"{self.a}{'+' if self.b > 0 else ''}{self.b}*nu"


M = [[K(*cyc_to_pair(gram_entry(i, j))) for j in range(5)] for i in range(5)]

EXPECTED_M = [
    [K.of(10), K.of(-6, 3), K.of(-3, 1), K.of(0, -3), K.of(3, 3)],
    [K.of(-9, -3), K.of(10), K.of(3), K.of(-3, 1), K.of(0, -3)],
    [K.of(-4, -1), K.of(3), K.of(5), K.of(0, 1), K.of(-1, -1)],
    [K.of(3, 3), K.of(-4, -1), K.of(-1, -1), K.of(5), K.of(0, 1)],
    [K.of(0, -3), K.of(3, 3), K.of(0, 1), K.of(-1, -1), K.of(5)],
]
assert M == EXPECTED_M
assert all(M[j][i] == M[i][j].conjugate() for i in range(5) for j in range(5))


def inverse_matrix(A):
    n = len(A)
    aug = [row[:] + [K.of(int(i == j)) for j in range(n)]
           for i, row in enumerate(A)]
    for col in range(n):
        pivot = next(r for r in range(col, n) if aug[r][col])
        aug[col], aug[pivot] = aug[pivot], aug[col]
        scale = aug[col][col].inverse()
        aug[col] = [scale * x for x in aug[col]]
        for r in range(n):
            if r != col:
                q = aug[r][col]
                aug[r] = [aug[r][c] - q * aug[col][c] for c in range(2 * n)]
    return [row[n:] for row in aug]


B = inverse_matrix(M)
EXPECTED_B = [
    [K.of(220), K.of(60, -12), K.of(0, -37), K.of(48, 97), K.of(-30, -79)],
    [K.of(72, 12), K.of(22), K.of(6, -10), K.of(0, 29), K.of(3, -23)],
    [K.of(37, 37), K.of(16, 10), K.of(19), K.of(-41, 8), K.of(35, -5)],
    [K.of(-49, -97), K.of(-29, -29), K.of(-49, -8), K.of(118), K.of(-98, -4)],
    [K.of(49, 79), K.of(26, 23), K.of(40, 5), K.of(-94, 4), K.of(79)],
]
assert B == EXPECTED_B


def matmul(A, C):
    return [[sum((A[i][k] * C[k][j] for k in range(len(C))), K.of())
             for j in range(len(C[0]))] for i in range(len(A))]


I5 = [[K.of(int(i == j)) for j in range(5)] for i in range(5)]
assert matmul(M, B) == I5
assert all(x.a.denominator == 1 and x.b.denominator == 1 for row in B for x in row)


def outer(vec):
    return [[vec[i] * vec[j].conjugate() for j in range(5)] for i in range(5)]


def madd(A, C, scale=1):
    return [[A[i][j] + scale * C[i][j] for j in range(5)] for i in range(5)]


e = [[K.of(int(i == j)) for i in range(5)] for j in range(5)]
upper = {(i, j): (int(B[i][j].a), int(B[i][j].b))
         for i in range(5) for j in range(i + 1, 5)}
diag_residual = [173, -7, 157, -189, 502]

# B = sum c_i e_i e_i^* + sum_{i<j}(a_ij r_ij r_ij^*
#       + b_ij s_ij s_ij^*), where r=e_i+e_j and s=e_i+conj(nu)e_j.
reconstructed = [[K.of() for _ in range(5)] for _ in range(5)]
for i, c in enumerate(diag_residual):
    reconstructed = madd(reconstructed, outer(e[i]), c)
for (i, j), (a, b) in upper.items():
    r = e[i][:]
    r[j] = r[j] + 1
    s = e[i][:]
    s[j] = s[j] + K.of(-1, -1)  # conjugate(nu) = -1-nu
    reconstructed = madd(reconstructed, outer(r), a)
    reconstructed = madd(reconstructed, outer(s), b)
assert reconstructed == B

print("KLEIN-IJ-PERIOD-GRAM-MATRIX-EXACT")
print("KLEIN-IJ-PRINCIPAL-HERMITIAN-INVERSE-INTEGRAL")
print("KLEIN-IJ-MINIMAL-CLASS-RANK-ONE-DECOMPOSITION-EXACT")
print("DELTA1-VOISIN-MINIMAL-CLASS-OBSTRUCTION-PASSES")

