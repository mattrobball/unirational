#!/usr/bin/env python3
"""Independent reconstruction of the mixed structured landing ansatz."""

from __future__ import annotations

import hashlib
import itertools
import json
import math
from pathlib import Path
import ctypes

import numpy as np

import verify_ansatz as comp
import verify_cross_ansatz as cross


HERE = Path(__file__).resolve().parent
FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"


def digest(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).view(np.uint8)).hexdigest()


def rank_profile(name: str, matrix: np.ndarray, prime: int) -> np.ndarray:
    value = np.array(matrix, dtype=np.float64, order="C", copy=True)
    pointer = ctypes.POINTER(ctypes.c_size_t)()
    function = getattr(ctypes.CDLL(FFPACK), name)
    function.argtypes = [
        ctypes.c_double, ctypes.c_size_t, ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_double), ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_size_t)), ctypes.c_int, ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rank = int(function(
        float(prime), *value.shape,
        value.ctypes.data_as(ctypes.POINTER(ctypes.c_double)), value.shape[1],
        ctypes.byref(pointer), 2, True,
    ))
    result = np.ctypeslib.as_array(pointer, shape=(rank,)).copy().astype(np.int64)
    libc = ctypes.CDLL(None)
    libc.free.argtypes = [ctypes.c_void_p]
    libc.free(pointer)
    return result


def right_nullspace(matrix: np.ndarray, prime: int, expected_rank: int) -> np.ndarray:
    rows = rank_profile("RowRankProfile_modular_double", matrix, prime)
    assert len(rows) == expected_rank
    independent = np.asarray(matrix[rows], dtype=np.int32)
    pivots = rank_profile("ColumnRankProfile_modular_double", independent, prime)
    assert len(pivots) == expected_rank
    pivot_set = set(map(int, pivots))
    free = np.asarray(
        [column for column in range(matrix.shape[1]) if column not in pivot_set],
        dtype=np.int64,
    )
    square = np.array(independent[:, pivots], dtype=np.float64, order="C")
    rest = np.asarray(independent[:, free], dtype=np.float64)
    nullity = ctypes.c_int()
    function = ctypes.CDLL(FFPACK).Invertin_modular_double
    function.argtypes = [
        ctypes.c_double, ctypes.c_size_t, ctypes.POINTER(ctypes.c_double),
        ctypes.c_size_t, ctypes.POINTER(ctypes.c_int), ctypes.c_bool,
    ]
    function.restype = ctypes.POINTER(ctypes.c_double)
    returned = function(
        float(prime), len(square),
        square.ctypes.data_as(ctypes.POINTER(ctypes.c_double)), square.shape[1],
        ctypes.byref(nullity), True,
    )
    assert nullity.value == 0 and ctypes.addressof(returned.contents) == square.ctypes.data
    solved = (-np.rint(square @ rest).astype(np.int64)) % prime
    answer = np.zeros((len(free), matrix.shape[1]), dtype=np.int32)
    answer[:, pivots] = solved.T.astype(np.int32)
    answer[:, free] = np.eye(len(free), dtype=np.int32)
    assert not np.any(np.asarray(matrix, dtype=np.int64) @ answer.astype(np.int64).T % prime)
    return answer


def compatibility(cubic_dual: np.ndarray) -> np.ndarray:
    c, cubic_count = cubic_dual.shape
    n = next(value for value in range(1, 100) if math.comb(value + 2, 3) == cubic_count)
    cubics = tuple(itertools.combinations_with_replacement(range(n), 3))
    index = {monomial: location for location, monomial in enumerate(cubics)}
    quartics = tuple(itertools.combinations_with_replacement(range(n), 4))
    result = np.zeros(
        (sum(len(set(monomial)) - 1 for monomial in quartics), n * c),
        dtype=np.int32,
    )
    row = 0
    for monomial in quartics:
        support = sorted(set(monomial))
        anchor = support[0]
        reduced_anchor = list(monomial)
        reduced_anchor.remove(anchor)
        for variable in support[1:]:
            reduced = list(monomial)
            reduced.remove(variable)
            result[row, anchor * c:(anchor + 1) * c] = cubic_dual[:, index[tuple(reduced_anchor)]]
            result[row, variable * c:(variable + 1) * c] = -cubic_dual[:, index[tuple(reduced)]]
            row += 1
    return result


def combined_values(comp_payload, comp_directions, frame, cross_payload, gradients, point, prime):
    first = np.asarray(
        [
            comp.eval_direction(word, multiplier, point, prime, frame)
            for word, multiplier in comp_directions
        ],
        dtype=np.int64,
    )
    second = cross.direction_values(cross_payload, gradients, point, prime)
    return np.vstack((first, second)) % prime


def main() -> None:
    summary = json.loads((HERE / "combined_ansatz_summary.json").read_text())
    gradients = cross.gradient_data()
    for degree in (25, 31, 35):
        payload = json.loads((HERE / f"degree_{degree}/combined_ansatz.json").read_text())
        assert payload == summary[str(degree)]
        comp_payload = json.loads((HERE / f"degree_{degree}/ansatz.json").read_text())
        cross_payload = json.loads((HERE / f"degree_{degree}/cross_ansatz.json").read_text())
        frame, comp_directions = comp.direction_data(comp_payload)
        n = len(comp_directions) + cross_payload["direction_count"]
        assert n == payload["direction_count"]
        triples = tuple(itertools.combinations_with_replacement(range(n), 3))
        assert len(triples) == payload["symmetric_cube_dimension"]
        for record in payload["prime_records"]:
            prime = int(record["prime"])
            rng = np.random.default_rng(int(record["rng_seed"]))
            points = rng.integers(
                0, prime, size=(record["point_count"], 5), dtype=np.int64
            )
            direction_points = rng.integers(
                0, prime, size=(record["direction_point_count"], 5), dtype=np.int64
            )
            direction_matrix = np.vstack(
                [
                    combined_values(
                        comp_payload,
                        comp_directions,
                        frame,
                        cross_payload,
                        gradients,
                        point,
                        prime,
                    ).T
                    for point in direction_points
                ]
            ).astype(np.int32)
            assert digest(direction_matrix) == record["direction_matrix_sha256"]
            assert comp.rank_mod(direction_matrix, prime) == record["direction_rank"] == n

            rows = np.empty(tuple(record["landing_matrix_shape"]), dtype=np.int32)
            for index, point in enumerate(points):
                vectors = combined_values(
                    comp_payload,
                    comp_directions,
                    frame,
                    cross_payload,
                    gradients,
                    point,
                    prime,
                )
                # This branch-polarization routine is independently written
                # in the cross verifier; the producer uses its composition
                # routine on the same vectors.
                rows[index] = cross.cubic_row(vectors, prime)
                if index and index % 1000 == 0:
                    print(
                        f"verify combined degree={degree} prime={prime} rows={index}/{len(points)}",
                        flush=True,
                    )
            assert digest(rows) == record["landing_matrix_sha256"]
            rank = comp.rank_mod(rows, prime)
            assert rank == record["landing_rank"]
            cubic_dual = right_nullspace(rows, prime, rank)
            assert len(cubic_dual) == record["cubic_dual_dimension"]
            assert digest(cubic_dual) == record["cubic_dual_sha256"]
            del rows
            quartic_compatibility = compatibility(cubic_dual)
            assert list(quartic_compatibility.shape) == record["quartic_dual_compatibility_shape"]
            assert digest(quartic_compatibility) == record["quartic_dual_compatibility_sha256"]
            compatibility_rank = comp.rank_mod(quartic_compatibility, prime)
            assert compatibility_rank == record["quartic_dual_compatibility_rank"]
            assert quartic_compatibility.shape[1] - compatibility_rank == 0
            assert record["quartic_dual_nullity"] == 0
            assert record["quartic_closure_contains_all_quartics"]
            print(
                f"verified combined degree={degree} prime={prime} n={n} "
                f"rank={rank} quarticDual=0",
                flush=True,
            )
            del direction_matrix, cubic_dual, quartic_compatibility
        assert payload["characteristic_zero_conclusion"] == "empty_projective_combined_ansatz"
    print("COV_COMBINED_ANSATZ_VERIFIED")


if __name__ == "__main__":
    main()
