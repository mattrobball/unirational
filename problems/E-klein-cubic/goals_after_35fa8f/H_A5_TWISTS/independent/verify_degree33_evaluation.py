#!/usr/bin/env python3
"""Exact six-point injectivity check for the degree-33 A5 invariants."""

from __future__ import annotations

import importlib.util
from fractions import Fraction
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent


def import_file(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


exact = import_file(
    "h3_exact_reynolds_eval_audit",
    ROOT / "common" / "exact_degree11.py",
)

POINTS = ((1, 2, 3), (1, 2, 4), (1, 2, 5), (1, 2, 6), (1, 2, 7), (1, 3, 2))


def linear_value(row, point):
    out = exact.ZERO
    for coefficient, coordinate in zip(row, point):
        out = exact.qadd(out, exact.qscale(coordinate, coefficient))
    return out


def invariants_and_jacobian(source, point):
    values = {}
    gradients = {}
    for degree in (2, 6, 10):
        value = exact.ZERO
        gradient = [exact.ZERO, exact.ZERO, exact.ZERO]
        for matrix in source.values():
            linear = linear_value(matrix[2], point)
            value = exact.qadd(value, exact.qpow(linear, degree))
            power = exact.qpow(linear, degree - 1)
            for coordinate in range(3):
                gradient[coordinate] = exact.qadd(
                    gradient[coordinate],
                    exact.qmul(
                        exact.q5(degree),
                        exact.qmul(power, matrix[2][coordinate]),
                    ),
                )
        values[degree] = value
        gradients[degree] = gradient
    return values, [gradients[degree] for degree in (2, 6, 10)]


def determinant(matrix):
    work = [[entry for entry in row] for row in matrix]
    out = exact.ONE
    for column in range(len(work)):
        pivot = next(row for row in range(column, len(work)) if work[row][column] != exact.ZERO)
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            out = exact.qneg(out)
        pivot_value = work[column][column]
        out = exact.qmul(out, pivot_value)
        inverse = exact.qinv(pivot_value)
        for row in range(column + 1, len(work)):
            scalar = exact.qmul(work[row][column], inverse)
            work[row] = [
                exact.qsub(left, exact.qmul(scalar, right))
                for left, right in zip(work[row], work[column])
            ]
    return out


def degree33_row(source, point):
    values, jacobian = invariants_and_jacobian(source, point)
    f15 = determinant(jacobian)
    f2, f6, f10 = values[2], values[6], values[10]
    return [
        exact.qmul(f15, exact.qpow(f2, 9)),
        exact.qmul(f15, exact.qmul(exact.qpow(f2, 6), f6)),
        exact.qmul(f15, exact.qmul(exact.qpow(f2, 3), exact.qpow(f6, 2))),
        exact.qmul(f15, exact.qpow(f6, 3)),
        exact.qmul(f15, exact.qmul(exact.qpow(f2, 4), f10)),
        exact.qmul(f15, exact.qmul(f2, exact.qmul(f6, f10))),
    ]


def qmod89(value):
    def reduce_fraction(item: Fraction):
        return item.numerator * pow(item.denominator, -1, 89) % 89

    return (reduce_fraction(value[0]) + 19 * reduce_fraction(value[1])) % 89


def main():
    # Coefficient of t^33 in (1+t^15)/((1-t^2)(1-t^6)(1-t^10)).
    dimension = sum(
        1
        for epsilon in (0, 1)
        for a in range(17)
        for b in range(6)
        for c in range(4)
        if 15 * epsilon + 2 * a + 6 * b + 10 * c == 33
    )
    assert dimension == 6
    source = exact.exact_source_representation()
    matrix = [degree33_row(source, point) for point in POINTS]
    det = determinant(matrix)
    assert det != exact.ZERO
    det_mod89 = qmod89(det)
    assert det_mod89 != 0
    print("degree33_invariant_dimension=6")
    print(f"exact_evaluation_determinant_nonzero=True det_mod_89={det_mod89}")
    print("H3_DEGREE33_EXACT_EVALUATION_VERIFY_OK")


if __name__ == "__main__":
    main()
