#!/usr/bin/env python3
"""Probe the full invariant-gradient cross-product span at fresh primes.

This is a discovery helper.  It uses safe coefficientwise modular evaluation
throughout; the repository's generic sparse evaluator can overflow on NumPy
scalars in these degrees.
"""

from __future__ import annotations

import ctypes
import importlib.util
import itertools
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(ROOT / "tmp" / "generic_twist"))
sys.path.insert(0, str(ROOT / "tmp" / "kproj_arithmetic"))

import core  # noqa: E402
import phi_coefficients as phi  # noqa: E402


FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"
PRIMES = {419: 13, 463: 15}
TARGETS = {31: 198, 35: 361}


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def module_at(prime: int, zeta: int):
    wrapper = load(
        f"cross_probe_reconstructor_{prime}",
        ROOT / "tmp" / "degree13_opt" / "reconstruct_large_prime.py",
    )
    return wrapper.load_module(prime, zeta)


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    value = np.array(matrix, dtype=np.float64, order="C", copy=True)
    pointer = ctypes.POINTER(ctypes.c_size_t)()
    function = ctypes.CDLL(FFPACK).RowRankProfile_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_double),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_size_t)),
        ctypes.c_int,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rank = int(
        function(
            float(prime),
            *value.shape,
            value.ctypes.data_as(ctypes.POINTER(ctypes.c_double)),
            value.shape[1],
            ctypes.byref(pointer),
            2,
            True,
        )
    )
    ctypes.CDLL(None).free(pointer)
    return rank


def derivative(polynomial, variable: int):
    answer = {}
    for exponents, coefficient in polynomial.items():
        if exponents[variable]:
            lowered = list(exponents)
            lowered[variable] -= 1
            answer[tuple(lowered)] = int(coefficient) * exponents[variable]
    return answer


def evaluate(polynomial, point, prime: int) -> int:
    total = 0
    for exponents, coefficient in polynomial.items():
        term = int(coefficient) % prime
        for coordinate, exponent in zip(point, exponents):
            term = term * pow(int(coordinate), int(exponent), prime) % prime
        total = (total + term) % prime
    return total


def determinant(matrix, prime: int) -> int:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    answer = 1
    for column in range(len(value)):
        pivots = np.flatnonzero(value[column:, column])
        if not len(pivots):
            return 0
        pivot = column + int(pivots[0])
        if pivot != column:
            value[[column, pivot]] = value[[pivot, column]]
            answer = -answer
        scalar = int(value[column, column])
        answer = answer * scalar % prime
        inverse = pow(scalar, -1, prime)
        for row in range(column + 1, len(value)):
            if value[row, column]:
                factor = int(value[row, column]) * inverse % prime
                value[row] = (value[row] - factor * value[column]) % prime
    return answer % prime


def cross_value(names, gradients, point, prime: int):
    rows = [
        [evaluate(component, point, prime) for component in gradients[name]]
        for name in names
    ]
    answer = []
    for omitted in range(5):
        minor = [[row[j] for j in range(5) if j != omitted] for row in rows]
        value = determinant(minor, prime)
        answer.append(value if omitted % 2 == 0 else -value)
    return np.asarray(answer, dtype=np.int64) % prime


def multiplier_labels(degree: int):
    labels = []
    for secondary, secondary_degree in enumerate(core.SECONDARY_DEGREES):
        if secondary_degree <= degree:
            for exponents in core.weighted_exponents(degree - secondary_degree):
                labels.append((secondary, exponents))
    return labels


def multiplier(label):
    secondary, exponents = label
    return phi.multiply(
        core.primary_monomial(exponents), core.secondary_polynomials()[secondary]
    )


def directions(target: int):
    result = []
    degrees = tuple(sorted(core.forms()))
    for names in itertools.combinations(degrees, 4):
        cross_degree = sum(degree - 1 for degree in names)
        remainder = target - cross_degree
        if remainder < 0:
            continue
        for label in multiplier_labels(remainder):
            result.append((names, multiplier(label)))
    return result


def involution_plus(module, prime: int):
    identity = np.eye(5, dtype=np.int64) % prime
    for matrix in module.GROUP:
        matrix = np.asarray(matrix, dtype=np.int64) % prime
        if not np.array_equal(matrix, identity) and np.array_equal(
            matrix @ matrix % prime, identity
        ):
            value = (matrix - identity) % prime
            # Tiny RREF, then free-coordinate nullspace.
            pivot_columns = []
            row = 0
            for column in range(5):
                pivots = np.flatnonzero(value[row:, column])
                if not len(pivots):
                    continue
                pivot = row + int(pivots[0])
                value[[row, pivot]] = value[[pivot, row]]
                value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
                for other in range(5):
                    if other != row and value[other, column]:
                        value[other] = (
                            value[other] - value[other, column] * value[row]
                        ) % prime
                pivot_columns.append(column)
                row += 1
            free = [column for column in range(5) if column not in pivot_columns]
            basis = np.zeros((len(free), 5), dtype=np.int64)
            for i, column in enumerate(free):
                basis[i, column] = 1
                for pivot_row, pivot_column in enumerate(pivot_columns):
                    basis[i, pivot_column] = -value[pivot_row, column] % prime
            assert basis.shape == (3, 5)
            return basis
    raise AssertionError("no involution")


def main() -> None:
    forms = core.forms()
    gradients = {
        degree: [derivative(polynomial, variable) for variable in range(5)]
        for degree, polynomial in forms.items()
    }
    for target, expected in TARGETS.items():
        selected = directions(target)
        print(f"target={target} directions={len(selected)}", flush=True)
        for prime, zeta in PRIMES.items():
            module = module_at(prime, zeta)
            plus = involution_plus(module, prime)
            plane_points = np.asarray(
                [(1, 7, 11), (2, 5, 13), (3, 17, 19)], dtype=np.int64
            ) @ plus % prime
            state = 20260802003135 + target
            raw = []
            for _ in range((len(selected) + 4) // 5 + 20):
                point = []
                for _ in range(5):
                    state = (
                        6364136223846793005 * state + 1442695040888963407
                    ) % (1 << 64)
                    point.append((state >> 24) % prime)
                raw.append(point)
            points = np.asarray(raw, dtype=np.int64)
            rows = []
            for point in points:
                columns = []
                for names, scalar in selected:
                    columns.append(
                        cross_value(names, gradients, point, prime)
                        * evaluate(scalar, point, prime)
                        % prime
                    )
                rows.append(np.asarray(columns).T.reshape(-1))
            evaluation = np.asarray(rows, dtype=np.int64).reshape(-1, len(selected))
            rank = rank_mod(evaluation, prime)
            nonzero = 0
            for point in plane_points:
                for names, scalar in selected:
                    value = (
                        cross_value(names, gradients, point, prime)
                        * evaluate(scalar, point, prime)
                        % prime
                    )
                    nonzero += bool(np.any(value))
            print(
                f"target={target} prime={prime} rank={rank} "
                f"expected_arrangement={expected} plane_nonzero={nonzero}",
                flush=True,
            )


if __name__ == "__main__":
    main()
