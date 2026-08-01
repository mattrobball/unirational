#!/usr/bin/env python3
"""Independent reconstruction of the composition-frame ansatz certificates.

This verifier does not import ``produce_ansatz``.  It reconstructs each map
from the authoritative integral formulas, recomputes every stored landing
row by summing ordered cubic terms, checks generator equivariance, and
recomputes the cubic/quartic ranks.
"""

from __future__ import annotations

import ctypes
import hashlib
import itertools
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]
sys.path.insert(0, str(E_ROOT / "tmp/generic_twist"))
sys.path.insert(0, str(E_ROOT / "tmp/kproj_arithmetic"))

import phi_coefficients as phi  # noqa: E402
import core as invariants  # noqa: E402


FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"
BASE_NAMES = ("x", "C", "D", "E", "K")
ZETAS = {89: 78, 199: 61}
JS = (1, 3, 2, 5, 4)
SIGNS = (1, 1, -1, 1, 1)
QR = {1, 3, 4, 5, 9}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    # The library performs elimination in place.  The verifier reuses the
    # reconstructed rows after rank computation, so it must rank a copy.
    value = np.array(matrix, dtype=np.int32, order="C", copy=True)
    rows = np.empty(value.shape[0], dtype=np.uintp)
    columns = np.empty(value.shape[1], dtype=np.uintp)
    function = ctypes.CDLL(FFPACK).RowEchelonForm_modular_int32_t
    function.argtypes = [
        ctypes.c_int32,
        ctypes.c_size_t,
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_int32),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_bool,
        ctypes.c_int,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    return int(
        function(
            prime,
            value.shape[0],
            value.shape[1],
            value.ctypes.data_as(ctypes.POINTER(ctypes.c_int32)),
            value.shape[1],
            rows.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
            columns.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
            False,
            2,
            True,
        )
    )


def eval_poly(polynomial, point, prime: int) -> int:
    total = 0
    for exponents, coefficient in polynomial.items():
        term = coefficient % prime
        for coordinate in range(5):
            term = term * pow(int(point[coordinate]), int(exponents[coordinate]), prime) % prime
        total = (total + term) % prime
    return int(total)


def eval_vector(vector, point, prime: int):
    return np.asarray([eval_poly(component, point, prime) for component in vector], dtype=np.int64)


def label_polynomial(record):
    secondary = int(record["secondary_index"])
    exponents = tuple(map(int, record["primary_exponents"]))
    assert record["secondary_name"] == invariants.SECONDARY_NAMES[secondary]
    assert record["secondary_degree"] == invariants.SECONDARY_DEGREES[secondary]
    assert record["primary_degrees"] == list(invariants.PRIMARY_DEGREES)
    weighted = record["secondary_degree"] + sum(
        exponent * degree for exponent, degree in zip(exponents, invariants.PRIMARY_DEGREES)
    )
    polynomial = phi.multiply(
        invariants.primary_monomial(exponents),
        invariants.secondary_polynomials()[secondary],
    )
    return weighted, polynomial


def direction_data(payload):
    _, frame, coefficients = phi.all_coefficients()
    phi.verify_expansion(frame, coefficients)
    frame = dict(zip(BASE_NAMES, frame))
    directions = []
    for record in payload["directions"]:
        word = tuple(record["word_outer_to_inner"])
        assert all(name in BASE_NAMES for name in word)
        weighted, multiplier = label_polynomial(record["multiplier"])
        assert weighted == record["multiplier_degree"]
        assert record["base_degree"] + weighted == payload["degree"]
        directions.append((word, multiplier))
    return frame, directions


def eval_direction(word, multiplier, point, prime: int, frame):
    value = np.asarray(point, dtype=np.int64) % prime
    for name in reversed(word):
        if name != "x":
            value = eval_vector(frame[name], value, prime) % prime
    return value * eval_poly(multiplier, point, prime) % prime


def rows_independent_formula(points, directions, frame, prime: int):
    dimension = len(directions)
    monomials = tuple(itertools.combinations_with_replacement(range(dimension), 3))
    index = {monomial: column for column, monomial in enumerate(monomials)}
    answer = np.zeros((len(points), len(monomials)), dtype=np.int32)
    for row_index, point in enumerate(points):
        vectors = np.asarray(
            [eval_direction(word, multiplier, point, prime, frame) for word, multiplier in directions],
            dtype=np.int64,
        )
        row = answer[row_index]
        # Literal expansion of sum_i L_i^2 L_{i+1}: r and s are the two
        # ordered choices from the square, t is the following-coordinate term.
        for r in range(dimension):
            for s in range(dimension):
                same = vectors[r] * vectors[s] % prime
                for t in range(dimension):
                    coefficient = sum(
                        int(same[coordinate]) * int(vectors[t, (coordinate + 1) % 5])
                        for coordinate in range(5)
                    ) % prime
                    column = index[tuple(sorted((r, s, t)))]
                    row[column] = (int(row[column]) + coefficient) % prime
    return answer


def quartic_rows(cubics: np.ndarray, dimension: int):
    cubic_monomials = tuple(itertools.combinations_with_replacement(range(dimension), 3))
    quartic_monomials = tuple(itertools.combinations_with_replacement(range(dimension), 4))
    qindex = {monomial: index for index, monomial in enumerate(quartic_monomials)}
    result = np.zeros((len(cubics) * dimension, len(quartic_monomials)), dtype=np.int32)
    for source, cubic in enumerate(cubics):
        for variable in range(dimension):
            target = result[source * dimension + variable]
            for coefficient, monomial in zip(cubic, cubic_monomials):
                if coefficient:
                    target[qindex[tuple(sorted(monomial + (variable,)))]] = coefficient
    return result


def generators(prime: int):
    zeta = ZETAS[prime]
    gamma = sum(
        (1 if exponent in QR else -1) * pow(zeta, exponent, prime)
        for exponent in range(1, 11)
    ) % prime
    assert gamma * gamma % prime == -11 % prime
    S = np.asarray(
        [
            [
                SIGNS[column]
                * pow(SIGNS[row], -1, prime)
                * (pow(zeta, 9 * JS[row] * JS[column], prime) - pow(zeta, -9 * JS[row] * JS[column], prime))
                * pow(gamma, -1, prime)
                % prime
                for column in range(5)
            ]
            for row in range(5)
        ],
        dtype=np.int64,
    )
    T = np.diag([pow(zeta, value * value, prime) for value in JS]).astype(np.int64)
    return S, T


def check_equivariance(frame, directions, points, prime: int):
    for generator in generators(prime):
        for point in points[:3]:
            transformed = generator @ point % prime
            for word, multiplier in directions:
                left = eval_direction(word, multiplier, transformed, prime, frame)
                right = generator @ eval_direction(word, multiplier, point, prime, frame) % prime
                assert np.array_equal(left % prime, right % prime)


def main() -> None:
    summary = json.loads((HERE / "ansatz_summary.json").read_text())
    for degree_text in ("25", "31", "35"):
        payload_path = HERE / f"degree_{degree_text}/ansatz.json"
        payload = json.loads(payload_path.read_text())
        assert payload == summary[degree_text]
        frame, directions = direction_data(payload)
        assert len(directions) == payload["direction_count"]
        for record in payload["prime_records"]:
            prime = int(record["prime"])
            data_path = payload_path.parent / record["payload"]
            assert sha256(data_path) == record["payload_sha256"]
            with np.load(data_path) as frozen:
                points = frozen["points"].astype(np.int64)
                stored = frozen["rows"].astype(np.int32)
                independent = frozen["independent_row_indices"].astype(np.int64)
            rebuilt = rows_independent_formula(points, directions, frame, prime)
            assert np.array_equal(stored, rebuilt)
            rank = rank_mod(rebuilt, prime)
            assert rank == record["rank"]
            check_equivariance(frame, directions, points, prime)
            if record["quartic_closure"] is None:
                assert rank == payload["symmetric_cube_dimension"]
            else:
                selected = rebuilt[independent]
                assert rank_mod(selected, prime) == rank
                quartics = quartic_rows(selected, len(directions))
                qrank = rank_mod(quartics, prime)
                assert list(quartics.shape) == record["quartic_closure"]["matrix_shape"]
                assert qrank == record["quartic_closure"]["rank"]
                assert qrank == record["quartic_closure"]["target_dimension"]
                del quartics
            print(f"verified degree={degree_text} prime={prime} rank={rank}", flush=True)
        assert payload["characteristic_zero_conclusion"] == "empty_projective_ansatz"
    print("COV_COMPOSITION_ANSATZ_VERIFIED", flush=True)


if __name__ == "__main__":
    main()
