#!/usr/bin/env python3
from __future__ import annotations

import itertools
import math
import re
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
OUT = HERE / "t3_node_Aminus6_uminus6.out"
P_TSV = (
    ROOT
    / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
)
A0 = U0 = -6
B, Y, Z = sp.symbols("B Y Z")
text = OUT.read_text()


def expr(source: str):
    return sp.sympify(source.replace("^", "**"), locals={"B": B, "Y": Y, "Z": Z})


lex = re.search(r"^LEX=\{(.*)\}$", text, re.M).group(1).split(",")
assert len(lex) == 3
w_expr, y_rel, b_rel = map(expr, lex)
w_poly = sp.Poly(w_expr, Z, domain=sp.QQ)
n = w_poly.degree()
assert n == 6
factor_content, factor_data = sp.factor_list(w_expr)
assert factor_content == 1
assert len(factor_data) == 1 and factor_data[0][1] == 1
assert sp.Poly(factor_data[0][0], Z, domain=sp.QQ) == w_poly
w = [Fraction(w_poly.nth(i)) for i in range(n + 1)]


def from_expr(value):
    p = sp.Poly(value, Z, domain=sp.QQ)
    answer = [Fraction(0) for _ in range(n)]
    for i in range(n):
        answer[i] = Fraction(p.nth(i))
    return answer


def add(x, y):
    return [a + b for a, b in zip(x, y)]


def scale(c, x):
    return [c * a for a in x]


def mul(x, y):
    raw = [Fraction(0) for _ in range(2 * n - 1)]
    for i, a in enumerate(x):
        for j, b in enumerate(y):
            raw[i + j] += a * b
    lc = w[n]
    for d in range(len(raw) - 1, n - 1, -1):
        c = raw[d]
        if not c:
            continue
        for i in range(n):
            raw[d - n + i] -= c * w[i] / lc
    return raw[:n]


def power(x, e):
    answer = [Fraction(1)] + [Fraction(0)] * (n - 1)
    base = x
    while e:
        if e & 1:
            answer = mul(answer, base)
        base = mul(base, base)
        e //= 2
    return answer


def solve_linear(rel, variable):
    p = sp.Poly(rel, variable)
    assert p.degree() == 1
    leading = p.coeff_monomial(variable)
    constant = rel.subs(variable, 0)
    return from_expr(-constant / leading)


zq = [Fraction(0), Fraction(1)] + [Fraction(0)] * (n - 2)
yq = solve_linear(y_rel, Y)
bq = solve_linear(b_rel, B)
bpow = [power(bq, e) for e in range(7)]
ypow = [power(yq, e) for e in range(7)]
zpow = [power(zq, e) for e in range(13)]

terms = []
with P_TSV.open() as stream:
    assert next(stream).strip() == "A\tB\tY\tZ\tu\tcoefficient"
    for line in stream:
        a, b, y, z, u, c = map(int, line.split())
        terms.append(([a, b, y, z, u], c))


def derivative(indices):
    answer = [Fraction(0)] * n
    for exponents0, coefficient0 in terms:
        exponents = exponents0[:]
        coefficient = coefficient0
        for index in indices:
            coefficient *= exponents[index]
            if not exponents[index]:
                break
            exponents[index] -= 1
        else:
            coefficient *= A0 ** exponents[0]
            coefficient *= U0 ** exponents[4]
            value = mul(mul(bpow[exponents[1]], ypow[exponents[2]]), zpow[exponents[3]])
            answer = add(answer, scale(Fraction(coefficient), value))
    return answer


coords = (1, 2, 3)
matrix = []
for i in coords:
    matrix.append([derivative([i, j]) for j in coords] + [derivative([4, i])])
matrix.append([derivative([4, j]) for j in coords] + [[Fraction(0)] * n])

for label, indices in (
    ("P", []),
    ("Pu", [4]),
    ("PA", [0]),
    ("PB", [1]),
    ("PY", [2]),
    ("PZ", [3]),
):
    value = derivative(indices)
    assert all(c == 0 for c in value), f"{label} does not vanish in the quotient"


def parity(permutation):
    size = len(permutation)
    inversions = sum(
        permutation[i] > permutation[j]
        for i in range(size)
        for j in range(i + 1, size)
    )
    return -1 if inversions % 2 else 1


def determinant(entries):
    size = len(entries)
    answer = [Fraction(0)] * n
    for permutation in itertools.permutations(range(size)):
        product = [Fraction(1)] + [Fraction(0)] * (n - 1)
        for i, j in enumerate(permutation):
            product = mul(product, entries[i][j])
        answer = add(answer, scale(Fraction(parity(permutation)), product))
    return answer


d_quot = determinant(matrix)
j_quot = determinant([row[:3] for row in matrix[:3]])

d_recorded = from_expr(expr(re.search(r"^DREM=(.*)$", text, re.M).group(1)))
assert d_quot == d_recorded, "independent bordered-Hessian remainder mismatch"
j_recorded = from_expr(expr(re.search(r"^JREM=(.*)$", text, re.M).group(1)))
assert j_quot == j_recorded, "independent chart-determinant remainder mismatch"

# The determinant of multiplication by d is the field norm.  This avoids the
# leading-coefficient correction required when using the nonmonic eliminant.
def field_norm(value):
    columns = [mul(value, zpow[j]) for j in range(n)]
    mult_matrix = sp.Matrix(
        n,
        n,
        lambda i, j: sp.Rational(
            columns[j][i].numerator, columns[j][i].denominator
        ),
    )
    return Fraction(mult_matrix.det())


norm = field_norm(d_quot)
chart_norm = field_norm(j_quot)
assert chart_norm != 0
res_num, res_den = map(int, re.search(r"^NORM=(\d+)/(\d+)$", text, re.M).groups())
recorded_res = Fraction(res_num, res_den)
assert norm == recorded_res / (w[n] ** 5)
assert norm != 0

# PARI factorization of the exact norm gives this square class.  Verify the
# claim without trusting the factorization engine: both quotients must be
# literal integer squares.
squarefree_part = int(
    "1225218781398035017274311805993749028078559822648842787814154826112957440765"
)
assert norm.numerator % squarefree_part == 0
numerator_square = norm.numerator // squarefree_part
assert math.isqrt(numerator_square) ** 2 == numerator_square
assert math.isqrt(norm.denominator) ** 2 == norm.denominator

print("NODE_REMAINDER_INDEPENDENT_OK")
print("eliminant_irreducible=true")
print("defining_equations_zero=true")
print("bordered_hessian_remainder_matches=true")
print("chart_determinant_remainder_matches=true")
print("chart_determinant_norm_nonzero=true")
print("norm_nonzero=true")
print("norm_is_square=false")
print(f"norm_squarefree_part={squarefree_part}")
print(f"norm_numerator_digits={len(str(norm.numerator))}")
print(f"norm_denominator_digits={len(str(norm.denominator))}")
