#!/usr/bin/env python3
"""Solve the mixed composition plus arrangement-cross landing ansatz.

Only deterministic inputs, exact direction labels, ranks, and byte digests are
stored.  The independent verifier reconstructs every matrix entry instead of
trusting a large frozen matrix.
"""

from __future__ import annotations

import hashlib
import itertools
import json
import math
from pathlib import Path
import ctypes

import numpy as np

import produce_ansatz as comp
import produce_cross_ansatz as cross


HERE = Path(__file__).resolve().parent
TARGETS = (25, 31, 35)
PRIMES = ((199, 2026083199), (353, 2026083353))
FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"


def digest(array: np.ndarray) -> str:
    value = np.ascontiguousarray(array)
    return hashlib.sha256(value.view(np.uint8)).hexdigest()


def rank_profile(name: str, matrix: np.ndarray, prime: int) -> np.ndarray:
    value = np.array(matrix, dtype=np.float64, order="C", copy=True)
    pointer = ctypes.POINTER(ctypes.c_size_t)()
    function = getattr(ctypes.CDLL(FFPACK), name)
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
    result = np.ctypeslib.as_array(pointer, shape=(rank,)).copy().astype(np.int64)
    libc = ctypes.CDLL(None)
    libc.free.argtypes = [ctypes.c_void_p]
    libc.free(pointer)
    return result


def right_nullspace(matrix: np.ndarray, prime: int, expected_rank: int) -> np.ndarray:
    row_indices = rank_profile("RowRankProfile_modular_double", matrix, prime)
    assert len(row_indices) == expected_rank
    independent = np.asarray(matrix[row_indices], dtype=np.int32)
    pivot_columns = rank_profile(
        "ColumnRankProfile_modular_double", independent, prime
    )
    assert len(pivot_columns) == expected_rank
    pivot_set = set(map(int, pivot_columns))
    free_columns = np.asarray(
        [column for column in range(matrix.shape[1]) if column not in pivot_set],
        dtype=np.int64,
    )
    pivot = np.array(independent[:, pivot_columns], dtype=np.float64, order="C")
    remainder = np.asarray(independent[:, free_columns], dtype=np.float64)
    nullity = ctypes.c_int()
    inverse = ctypes.CDLL(FFPACK).Invertin_modular_double
    inverse.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_double),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_int),
        ctypes.c_bool,
    ]
    inverse.restype = ctypes.POINTER(ctypes.c_double)
    returned = inverse(
        float(prime),
        len(pivot),
        pivot.ctypes.data_as(ctypes.POINTER(ctypes.c_double)),
        pivot.shape[1],
        ctypes.byref(nullity),
        True,
    )
    assert nullity.value == 0
    assert ctypes.addressof(returned.contents) == pivot.ctypes.data
    solved = (-np.rint(pivot @ remainder).astype(np.int64)) % prime
    answer = np.zeros((len(free_columns), matrix.shape[1]), dtype=np.int32)
    answer[:, pivot_columns] = solved.T.astype(np.int32)
    answer[:, free_columns] = np.eye(len(free_columns), dtype=np.int32)
    assert not np.any(
        np.asarray(matrix, dtype=np.int64) @ answer.astype(np.int64).T % prime
    )
    return answer


def quartic_dual_compatibility(cubic_dual: np.ndarray) -> np.ndarray:
    """Compatibility matrix for contractions of a symmetric quartic.

    A quartic functional annihilates V times the cubic landing space iff each
    of its n contractions lies in ``cubic_dual``.  Equality of coefficients
    shared by different contractions gives this small exact matrix.
    """

    nullity, n_cubics = cubic_dual.shape
    n = next(
        value for value in range(1, 100) if math.comb(value + 2, 3) == n_cubics
    )
    cubics = tuple(itertools.combinations_with_replacement(range(n), 3))
    cubic_index = {monomial: index for index, monomial in enumerate(cubics)}
    quartics = tuple(itertools.combinations_with_replacement(range(n), 4))
    row_count = sum(len(set(monomial)) - 1 for monomial in quartics)
    matrix = np.zeros((row_count, n * nullity), dtype=np.int32)
    row = 0
    for monomial in quartics:
        support = sorted(set(monomial))
        anchor = support[0]
        anchor_list = list(monomial)
        anchor_list.remove(anchor)
        anchor_coefficients = cubic_dual[:, cubic_index[tuple(anchor_list)]]
        for variable in support[1:]:
            reduced = list(monomial)
            reduced.remove(variable)
            matrix[row, anchor * nullity:(anchor + 1) * nullity] = anchor_coefficients
            matrix[row, variable * nullity:(variable + 1) * nullity] = (
                -cubic_dual[:, cubic_index[tuple(reduced)]]
            )
            row += 1
    assert row == row_count
    return matrix


def combined_values(comp_directions, cross_directions, frame, gradients, point, prime):
    first = comp.evaluate_directions(comp_directions, point, prime, frame)
    second = []
    for direction in cross_directions:
        vector = cross.cross_value(direction["invariants"], gradients, point, prime)
        scalar = cross.eval_poly(direction["multiplier"], point, prime)
        second.append(vector * scalar % prime)
    return np.vstack((first, np.asarray(second, dtype=np.int64))) % prime


def main() -> None:
    frame = comp.frame_data()
    _forms, gradients = cross.invariant_data()
    summary = {}
    for degree in TARGETS:
        comp_directions = comp.select_directions(degree)
        cross_directions = cross.directions(degree)
        n_comp = len(comp_directions)
        n_cross = len(cross_directions)
        n = n_comp + n_cross
        sym3 = math.comb(n + 2, 3)
        records = []
        for prime, seed in PRIMES:
            rng = np.random.default_rng(seed + degree)
            points = rng.integers(0, prime, size=(sym3 + 64, 5), dtype=np.int64)
            direction_points = rng.integers(
                0, prime, size=(math.ceil(n / 5) + 8, 5), dtype=np.int64
            )
            direction_matrix = np.vstack(
                [
                    combined_values(
                        comp_directions, cross_directions, frame, gradients, point, prime
                    ).T
                    for point in direction_points
                ]
            ).astype(np.int32)
            direction_rank = comp.rank_mod(direction_matrix, prime)
            assert direction_rank == n

            rows = np.empty((len(points), sym3), dtype=np.int32)
            triples = tuple(itertools.combinations_with_replacement(range(n), 3))
            for index, point in enumerate(points):
                rows[index] = comp.cubic_row(
                    combined_values(
                        comp_directions, cross_directions, frame, gradients, point, prime
                    ),
                    prime,
                    triples,
                )
                if index and index % 1000 == 0:
                    print(
                        f"combined degree={degree} prime={prime} rows={index}/{len(points)}",
                        flush=True,
                    )
            rank = comp.rank_mod(rows, prime)
            landing_shape = list(rows.shape)
            cubic_dual = right_nullspace(rows, prime, rank)
            landing_digest = digest(rows)
            del rows
            compatibility = quartic_dual_compatibility(cubic_dual)
            compatibility_rank = comp.rank_mod(compatibility, prime)
            quartic_dual_nullity = compatibility.shape[1] - compatibility_rank
            records.append(
                {
                    "prime": prime,
                    "rng_seed": seed + degree,
                    "point_count": len(points),
                    "direction_point_count": len(direction_points),
                    "direction_matrix_sha256": digest(direction_matrix),
                    "direction_rank": direction_rank,
                    "landing_matrix_shape": landing_shape,
                    "landing_matrix_sha256": landing_digest,
                    "landing_rank": rank,
                    "full_symmetric_cube_rank": rank == sym3,
                    "cubic_dual_dimension": len(cubic_dual),
                    "cubic_dual_sha256": digest(cubic_dual),
                    "quartic_dual_compatibility_shape": list(compatibility.shape),
                    "quartic_dual_compatibility_sha256": digest(compatibility),
                    "quartic_dual_compatibility_rank": compatibility_rank,
                    "quartic_dual_nullity": quartic_dual_nullity,
                    "quartic_closure_contains_all_quartics": quartic_dual_nullity == 0,
                }
            )
            print(
                f"combined degree={degree} prime={prime} n={n} sym3={sym3} "
                f"rank={rank} quarticDual={quartic_dual_nullity}",
                flush=True,
            )
            del direction_matrix, cubic_dual, compatibility

        payload = {
            "degree": degree,
            "ansatz": "linear span of the composition-frame and invariant-gradient cross-product directions",
            "integral_model": True,
            "composition_direction_count": n_comp,
            "cross_direction_count": n_cross,
            "direction_count": n,
            "symmetric_cube_dimension": sym3,
            "composition_payload": "ansatz.json",
            "cross_payload": "cross_ansatz.json",
            "prime_records": records,
            "characteristic_zero_conclusion": (
                "empty_projective_combined_ansatz"
                if all(record["quartic_closure_contains_all_quartics"] for record in records)
                else "not_decided"
            ),
            "proof_rule": (
                "The dual contraction-integrability calculation proves that the degree-four "
                "closure of the polarized cubic landing ideal is every quartic modulo each "
                "good prime. The exact integral projective family therefore has empty "
                "characteristic-zero fibre; the second prime is an independent holdout."
            ),
        }
        path = HERE / f"degree_{degree}/combined_ansatz.json"
        path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
        summary[str(degree)] = payload
    (HERE / "combined_ansatz_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n"
    )
    print("COV_COMBINED_ANSATZ_PRODUCED")


if __name__ == "__main__":
    main()
