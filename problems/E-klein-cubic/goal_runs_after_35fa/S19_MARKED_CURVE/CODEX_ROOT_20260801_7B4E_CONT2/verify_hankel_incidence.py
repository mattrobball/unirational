#!/usr/bin/env python3
"""Independent replay of the S19 105-by-20 Hankel compression and probe."""

from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
FAMILY = HERE.parent / "CODEX_ROOT_20260801_7B4E" / "universal_marked_family.json"
PROBE = HERE / "hankel_probe.json"


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def cyclotomic_mod(coefficients, zeta, prime):
    return sum(int(coefficient) * pow(zeta, exponent, prime)
               for exponent, coefficient in enumerate(coefficients)) % prime


def rref(matrix, prime):
    matrix = [[int(value) % prime for value in row] for row in matrix]
    rows = len(matrix)
    columns = len(matrix[0])
    pivots = []
    pivot_row = 0
    for column in range(columns):
        selected = next((row for row in range(pivot_row, rows) if matrix[row][column]), None)
        if selected is None:
            continue
        matrix[pivot_row], matrix[selected] = matrix[selected], matrix[pivot_row]
        inverse = pow(matrix[pivot_row][column], -1, prime)
        matrix[pivot_row] = [value * inverse % prime for value in matrix[pivot_row]]
        for row in range(rows):
            if row != pivot_row and matrix[row][column]:
                factor = matrix[row][column]
                matrix[row] = [(left - factor * right) % prime
                               for left, right in zip(matrix[row], matrix[pivot_row])]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    return matrix, pivots


def rank(matrix, prime):
    return len(rref(matrix, prime)[1])


def nullspace(matrix, prime):
    reduced, pivots = rref(matrix, prime)
    free = [column for column in range(len(reduced[0])) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * len(reduced[0])
        vector[free_column] = 1
        for row, pivot in reversed(list(enumerate(pivots))):
            vector[pivot] = -reduced[row][free_column] % prime
        basis.append(vector)
    return basis


def points_from_family(family, prime, zeta, hyperplane):
    points = []
    for line in family["lines"]:
        u = [cyclotomic_mod(coefficient, zeta, prime) for coefficient in line["u"]]
        v = [cyclotomic_mod(coefficient, zeta, prime) for coefficient in line["v"]]
        a = sum(hyperplane[index] * u[index] for index in range(5)) % prime
        b = sum(hyperplane[index] * v[index] for index in range(5)) % prime
        assert a or b
        points.append([(b * u[index] - a * v[index]) % prime for index in range(4)])
    return points


def polynomial_values(coefficients, parameters, prime):
    answer = []
    for parameter in parameters:
        value = 0
        for coefficient in reversed(coefficients):
            value = (value * parameter + coefficient) % prime
        answer.append(value)
    return answer


def weights(parameters, prime):
    answer = []
    for index, parameter in enumerate(parameters):
        derivative = 1
        for other_index, other in enumerate(parameters):
            if other_index != index:
                derivative = derivative * (parameter - other) % prime
        answer.append(pow(derivative, -1, prime))
    return answer


def hankel(points, y0_coefficients, parameters, prime):
    assert len(set(parameters)) == 55
    y0 = [sum(y0_coefficients[j] * point[j] for j in range(4)) % prime for point in points]
    assert all(y0)
    derivative_weights = weights(parameters, prime)
    result = []
    for coordinate in range(3):
        ratios = [points[index][coordinate] * pow(y0[index], -1, prime) % prime
                  for index in range(55)]
        moments = [sum(derivative_weights[index] * ratios[index]
                       * pow(parameters[index], exponent, prime)
                       for index in range(55)) % prime
                   for exponent in range(54)]
        for moment in range(35):
            result.append(moments[moment:moment + 20])
    return result


def interpolate(parameters, values, prime):
    augmented = [[pow(parameters[row], column, prime) for column in range(20)]
                 + [values[row] % prime] for row in range(20)]
    reduced, pivots = rref(augmented, prime)
    assert pivots[:20] == list(range(20))
    coefficients = [reduced[row][20] for row in range(20)]
    assert polynomial_values(coefficients, parameters, prime) == [value % prime for value in values]
    return coefficients


def planted_control(prime):
    parameters = list(range(55))
    # q(t)=1+t^19 has no root among 0,...,54 for this fixed prime; adjust if needed.
    q = [1] + [0] * 18 + [1]
    if not all(polynomial_values(q, parameters, prime)):
        q[0] = 2
    forms = [q]
    for shift in (3, 7, 11):
        forms.append([(shift + (index + 1) ** 3) % prime for index in range(20)])
    values = [polynomial_values(form, parameters, prime) for form in forms]
    # Original coordinates are (A1,A2,A3,A0), so y0=X3.
    points = [[values[1][i], values[2][i], values[3][i], values[0][i]] for i in range(55)]
    matrix = hankel(points, [0, 0, 0, 1], parameters, prime)
    assert rank(matrix, prime) < 20
    kernels = nullspace(matrix, prime)
    assert kernels
    recovered_q = kernels[0]
    recovered_values = polynomial_values(recovered_q, parameters, prime)
    assert all(recovered_values)
    y0 = [point[3] for point in points]
    scales = [recovered_values[i] * pow(y0[i], -1, prime) % prime for i in range(55)]
    for coordinate in range(4):
        target_values = [scales[i] * points[i][coordinate] % prime for i in range(55)]
        interpolate(parameters, target_values, prime)
    return rank(matrix, prime)


def main():
    probe = json.loads(PROBE.read_text())
    family = json.loads(FAMILY.read_text())
    assert probe["schema"] == "s19-hankel-incidence-probe-v2"
    assert probe["source_sha256"]["universal_marked_family.json"] == digest(FAMILY)
    assert probe["terminal_marker"] == "S19_HANKEL_MODULAR_RECONNAISSANCE_COMPLETE"
    prime = probe["prime"]
    zeta = probe["zeta11"]
    assert prime == 397 and pow(zeta, 11, prime) == 1 and zeta != 1
    points = points_from_family(family, prime, zeta, probe["hyperplane"])
    best = probe["best_tested_point"]
    actual = hankel(points, probe["nonvanishing_target_coordinate"], best["tau"], prime)
    assert len(actual) == 105 and len(actual[0]) == 20
    assert rank(actual, prime) == best["rank"] == 20
    print("PASS independently rebuilt the actual 105-by-20 best-tested matrix at F_397")

    planted_rank = planted_control(prime)
    assert planted_rank < 20
    print(f"PASS planted degree-19 incidence drops rank to {planted_rank} and reconstructs four forms")

    assert probe["candidate"] is None
    assert probe["rank_histogram"] == {"20": sum(probe["tested_distinct_by_family"].values())}
    total = sum(probe["tested_distinct_by_family"].values())
    assert total > 5305
    assert any(name.startswith("target_rational_degree_le_")
               for name in probe["tested_distinct_by_family"])
    assert "a full-rank sample does not prove characteristic-zero or geometric emptiness" in probe["strict_scope"]
    print(f"PASS {total:,} tested distinct parameters were full rank with the nonverdict boundary intact")
    print("S19_HANKEL_COMPRESSION_INDEPENDENT_REPLAY_OK")


if __name__ == "__main__":
    main()
