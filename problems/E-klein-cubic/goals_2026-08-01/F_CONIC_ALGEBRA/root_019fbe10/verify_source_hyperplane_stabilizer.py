#!/usr/bin/env python3
"""Verify the chosen source hyperplane has trivial decomposition group.

Good reduction at 331 preserves all 660 projective representation matrices.
If an exact group element stabilized the characteristic-zero hyperplane, its
reduction would stabilize the reduced covector.  Exhaustion modulo 331 is
therefore a certificate of trivial exact setwise stabilizer.
"""

from __future__ import annotations

import importlib.util
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
CERTIFICATES = PROBLEM / "certificates"
sys.path.insert(0, str(CERTIFICATES))

import exact_weil_check as ew  # noqa: E402


PRIME = 331
ZETA = 74
COVECTOR = (1, 1, 0, 0, 0)


def reduce_fraction(value):
    return value.numerator % PRIME * pow(value.denominator % PRIME, -1, PRIME) % PRIME


def reduce_cyclotomic(value):
    return sum(
        reduce_fraction(coefficient) * pow(ZETA, exponent, PRIME)
        for exponent, coefficient in enumerate(value.a)
    ) % PRIME


def reduce_matrix(matrix):
    return [[reduce_cyclotomic(entry) for entry in row] for row in matrix]


def covector_times_matrix(covector, matrix):
    return tuple(
        sum(covector[i] * matrix[i][j] for i in range(5)) % PRIME
        for j in range(5)
    )


def proportional(left, right):
    pivot = next(index for index, value in enumerate(right) if value % PRIME)
    scalar = left[pivot] * pow(right[pivot], -1, PRIME) % PRIME
    return all(a % PRIME == scalar * b % PRIME for a, b in zip(left, right))


def load_invariants():
    path = PROBLEM / "tmp/kproj_arithmetic/core.py"
    spec = importlib.util.spec_from_file_location("goal_f_stabilizer_kproj", path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.forms()


def evaluate(terms, point):
    return sum(
        int(coefficient)
        * __import__("math").prod(pow(value, exponent, PRIME) for value, exponent in zip(point, powers))
        for powers, coefficient in terms.items()
    ) % PRIME


def main() -> None:
    assert pow(ZETA, 11, PRIME) == 1
    reduced = [reduce_matrix(matrix) for matrix in ew.rho.values()]
    assert len({tuple(value for row in matrix for value in row) for matrix in reduced}) == 660
    covector = tuple(value % PRIME for value in COVECTOR)
    stabilizers = [
        matrix for matrix in reduced
        if proportional(covector_times_matrix(covector, matrix), covector)
    ]
    assert len(stabilizers) == 1
    orbit = {
        tuple(
            value * pow(next(entry for entry in image if entry), -1, PRIME) % PRIME
            for value in image
        )
        for matrix in reduced
        for image in [covector_times_matrix(covector, matrix)]
    }
    assert len(orbit) == 660

    forms = load_invariants()
    # x0+x1=0 at this deterministic point.
    point = (1, -1, 2, 3, 4)
    assert sum(coefficient * value for coefficient, value in zip(COVECTOR, point)) == 0
    assert evaluate(forms[3], point) != 0
    assert evaluate(forms[5], point) != 0

    print("SOURCE_HYPERPLANE_STABILIZER_TRIVIAL_660_ACCEPT")
    print("SOURCE_HYPERPLANE_MEETS_F3_F5_OPEN_ACCEPT")


if __name__ == "__main__":
    main()
