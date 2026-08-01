#!/usr/bin/env python3
"""Independent replay for universal_marked_family.json.

This checker does not import the producer.  It reconstructs the serialized
cyclotomic lines, their PSL(2,11) action, the universal hyperplane sections,
and every named good-prime minor used in the generic-freeness argument.
"""

from __future__ import annotations

import hashlib
import json
import math
import sys
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
CERTIFICATES = PROBLEM / "certificates"
PAYLOAD = HERE / "universal_marked_family.json"
sys.path.insert(0, str(CERTIFICATES))
import exact_weil_check as ew  # noqa: E402


P = 67
ZETA = 64
F5_TERMS = (
    (1, (3, 0, 2, 0, 0)),
    (-1, (3, 0, 0, 1, 1)),
    (1, (2, 0, 0, 3, 0)),
    (-1, (1, 3, 0, 0, 1)),
    (-1, (1, 1, 3, 0, 0)),
    (3, (1, 1, 1, 1, 1)),
    (1, (0, 3, 0, 2, 0)),
    (1, (0, 2, 0, 0, 3)),
    (-1, (0, 1, 1, 3, 0)),
    (1, (0, 0, 3, 0, 2)),
    (-1, (0, 0, 1, 1, 3)),
)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def cmul_poly(left, right):
    out = [ew.C(0) for _ in range(len(left) + len(right) - 1)]
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            out[i + j] += a * b
    return out


def cpow_poly(linear, exponent):
    out = [ew.C(1)]
    for _ in range(exponent):
        out = cmul_poly(out, linear)
    return out


def f3_on_line(u, v):
    out = [ew.C(0) for _ in range(4)]
    for i in range(5):
        product = cmul_poly(cpow_poly([u[i], v[i]], 2), [u[(i + 1) % 5], v[(i + 1) % 5]])
        out = [a + b for a, b in zip(out, product)]
    return out


def f5_on_line(u, v):
    out = [ew.C(0) for _ in range(6)]
    for scalar, exponents in F5_TERMS:
        term = [ew.C(scalar)]
        for coordinate, exponent in enumerate(exponents):
            term = cmul_poly(term, cpow_poly([u[coordinate], v[coordinate]], exponent))
        out = [a + b for a, b in zip(out, term)]
    return out


def matvec(matrix, vector):
    return [sum(matrix[i][j] * vector[j] for j in range(5)) for i in range(5)]


def det3(rows):
    a, b, c = rows
    return (
        a[0] * (b[1] * c[2] - b[2] * c[1])
        - a[1] * (b[0] * c[2] - b[2] * c[0])
        + a[2] * (b[0] * c[1] - b[1] * c[0])
    )


def lies_in_plane(w, u, v):
    for i in range(5):
        for j in range(i + 1, 5):
            for k in range(j + 1, 5):
                if det3(([w[i], w[j], w[k]], [u[i], u[j], u[k]], [v[i], v[j], v[k]])) != 0:
                    return False
    return True


def cmod(value):
    total = 0
    power = 1
    for coefficient in value.a:
        total = (total + coefficient.numerator * pow(coefficient.denominator, -1, P) * power) % P
        power = power * ZETA % P
    return total


def monomials(nvars, degree):
    if nvars == 1:
        return [(degree,)]
    return [(first,) + tail for first in range(degree + 1) for tail in monomials(nvars - 1, degree - first)]


def determinant(matrix):
    a = [[value % P for value in row] for row in matrix]
    answer = 1
    for column in range(len(a)):
        pivot = next((row for row in range(column, len(a)) if a[row][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            a[column], a[pivot] = a[pivot], a[column]
            answer = -answer
        answer = answer * a[column][column] % P
        inverse = pow(a[column][column], -1, P)
        for row in range(column + 1, len(a)):
            scalar = a[row][column] * inverse % P
            a[row] = [(a[row][j] - scalar * a[column][j]) % P for j in range(len(a))]
    return answer % P


def rank(matrix):
    a = [[value % P for value in row] for row in matrix]
    if not a:
        return 0
    row = 0
    for column in range(len(a[0])):
        pivot = next((i for i in range(row, len(a)) if a[i][column]), None)
        if pivot is None:
            continue
        a[row], a[pivot] = a[pivot], a[row]
        inverse = pow(a[row][column], -1, P)
        a[row] = [value * inverse % P for value in a[row]]
        for i in range(row + 1, len(a)):
            scalar = a[i][column]
            if scalar:
                a[i] = [(a[i][j] - scalar * a[row][j]) % P for j in range(len(a[0]))]
        row += 1
        if row == len(a):
            break
    return row


def padd(left, right):
    out = dict(left)
    for exponent, coefficient in right.items():
        out[exponent] = (out.get(exponent, 0) + coefficient) % P
    return {exponent: coefficient for exponent, coefficient in out.items() if coefficient}


def pscale(scalar, polynomial):
    return {exponent: scalar * coefficient % P for exponent, coefficient in polynomial.items() if scalar * coefficient % P}


def pmul(left, right):
    out = {}
    for left_exp, left_coefficient in left.items():
        for right_exp, right_coefficient in right.items():
            exponent = tuple(a + b for a, b in zip(left_exp, right_exp))
            out[exponent] = (out.get(exponent, 0) + left_coefficient * right_coefficient) % P
    return {exponent: coefficient for exponent, coefficient in out.items() if coefficient}


def ppow(polynomial, exponent):
    out = {(0, 0, 0, 0): 1}
    for _ in range(exponent):
        out = pmul(out, polynomial)
    return out


def restricted_forms():
    variables = [{tuple(int(i == j) for i in range(4)): 1} for j in range(4)]
    inverse7 = pow(7, -1, P)
    x4 = {}
    for coefficient, variable in zip((-1, -1, -1, -2), variables):
        x4 = padd(x4, pscale(coefficient * inverse7, variable))
    forms = variables + [x4]
    f3 = {}
    for i in range(5):
        f3 = padd(f3, pmul(ppow(forms[i], 2), forms[(i + 1) % 5]))
    f5 = {}
    for scalar, exponents in F5_TERMS:
        term = {(0, 0, 0, 0): scalar % P}
        for form, exponent in zip(forms, exponents):
            term = pmul(term, ppow(form, exponent))
        f5 = padd(f5, term)
    return f3, f5


def main():
    payload = json.loads(PAYLOAD.read_text())
    assert payload["schema"] == "s19-universal-marked-family-v1"
    assert payload["terminal_marker"] == "S19_CANONICAL_MARKED_55_FAMILY_EXACT"
    assert "rho(g)^(-T)h" in payload["descent_equivariance"]["hyperplane_action"]
    assert "p_{g.i}" in payload["descent_equivariance"]["section_action"]
    assert payload["source_sha256"]["certificates/exact_weil_check.py"] == digest(CERTIFICATES / "exact_weil_check.py")
    assert payload["source_sha256"]["goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md"] == digest(PROBLEM / "goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md")

    raw_lines = payload["lines"]
    assert len(raw_lines) == 55
    lines = []
    for raw in raw_lines:
        u = [ew.C(coefficients) for coefficients in raw["u"]]
        v = [ew.C(coefficients) for coefficients in raw["v"]]
        assert any(u[i] * v[j] != u[j] * v[i] for i in range(5) for j in range(i + 1, 5))
        assert f3_on_line(u, v) == [ew.C(0)] * 4
        assert f5_on_line(u, v) == [ew.C(0)] * 6
        lines.append((u, v))

    permutations = payload["group"]["generator_permutations"]
    for name, matrix in (("S", ew.S), ("T", ew.T)):
        permutation = permutations[name]
        assert sorted(permutation) == list(range(55))
        for i, (u, v) in enumerate(lines):
            target_u, target_v = lines[permutation[i]]
            assert lies_in_plane(matvec(matrix, u), target_u, target_v)
            assert lies_in_plane(matvec(matrix, v), target_u, target_v)

    tensors = payload["universal_points"]["coefficient_tensor"]
    assert len(tensors) == 55
    for (u, v), tensor in zip(lines, tensors):
        for coordinate in range(5):
            for h_index in range(5):
                assert ew.C(tensor[coordinate][h_index]) == v[h_index] * u[coordinate] - u[h_index] * v[coordinate]

    witness = payload["good_open"]["hyperplane_witness"]
    points = []
    for index, ((u, v), gate) in enumerate(zip(lines, payload["good_open"]["line_chart_factors"])):
        u_mod = [cmod(value) for value in u]
        v_mod = [cmod(value) for value in v]
        a = sum(witness[i] * u_mod[i] for i in range(5)) % P
        b = sum(witness[i] * v_mod[i] for i in range(5)) % P
        assert gate["dot"] in ("u", "v")
        assert gate["value_mod_67"] == (a if gate["dot"] == "u" else b) != 0
        point = [(b * u_mod[i] - a * v_mod[i]) % P for i in range(5)]
        assert sum(witness[i] * point[i] for i in range(5)) % P == 0
        points.append(point)

    pair_gates = payload["good_open"]["pair_separation_factors"]
    assert len(pair_gates) == math.comb(55, 2)
    for gate in pair_gates:
        i, j = gate["i"], gate["j"]
        left, right = gate["coordinates"]
        value = (points[i][left] * points[j][right] - points[i][right] * points[j][left]) % P
        assert value == gate["value_mod_67"] != 0

    p3_points = [point[:4] for point in points]
    observed_hf = []
    for degree in range(7):
        exponents = monomials(4, degree)
        evaluation = [[math.prod(pow(point[i], exponent[i], P) for i in range(4)) % P for exponent in exponents] for point in p3_points]
        observed_hf.append(rank(evaluation))
        factor = payload["good_open"]["evaluation_minor_factors"][str(degree)]
        rows = factor["point_rows"]
        columns = [exponents.index(tuple(exponent)) for exponent in factor["monomial_columns"]]
        square = [[evaluation[i][j] for j in columns] for i in rows]
        assert len(rows) == len(columns) == factor["rank"]
        assert determinant(square) == factor["determinant_mod_67"] != 0
    assert observed_hf == payload["generic_freeness"]["hilbert_function_d0_to_d6"] == [1, 4, 10, 19, 31, 45, 55]

    f3, f5 = restricted_forms()
    quintics = monomials(4, 5)
    kernel = []
    for exponent in monomials(4, 2):
        product = pmul(f3, {exponent: 1})
        kernel.append([product.get(target, 0) for target in quintics])
    kernel.append([f5.get(target, 0) for target in quintics])
    factor = payload["good_open"]["kernel_independence_factor_degree5"]
    columns = [quintics.index(tuple(exponent)) for exponent in factor["coefficient_monomials"]]
    square = [[row[column] for column in columns] for row in kernel]
    assert rank(kernel) == factor["rank"] == 11
    assert determinant(square) == factor["determinant_mod_67"] != 0

    propagation = payload["good_open"]["propagation_linear_form"]
    values = [sum(propagation["coefficients"][i] * point[i] for i in range(4)) % P for point in p3_points]
    assert values == propagation["values_mod_67"]
    assert all(values)

    print("PASS 55 exact Q(zeta_11) lines lie on f3=f5=0")
    print("PASS serialized S,T permutations act on the exact line orbit")
    print("PASS universal point tensors equal (h.v)u-(h.u)v")
    print("PASS 1485 separation gates and all evaluation minors at F_67 witness")
    print("PASS Hilbert function 1,4,10,19,31,45,55 and degree-5 kernel independence")
    print("S19_UNIVERSAL_MARKED_FAMILY_INDEPENDENT_REPLAY_OK")


if __name__ == "__main__":
    main()
