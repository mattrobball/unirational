#!/usr/bin/env python3
"""Produce exact modular certificates for composition-frame landing ansatze.

The maps are defined over Z.  Each direction is an invariant multiple of one
of x,C,D,E,K or an ordered two-fold composition of C,D,E,K.  Directions are
homogenized to degrees 25, 31, and 35.  At a split good prime the evaluation
rows are the coefficients of F(sum a_i p_i(x)) in the parameter monomials.
Full column rank of this matrix proves that no nonzero member of the entire
ansatz lands in the Klein cubic, over the finite field and in characteristic
zero.
"""

from __future__ import annotations

import ctypes
import hashlib
import itertools
import json
import math
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]
sys.path.insert(0, str(E_ROOT / "tmp/generic_twist"))
sys.path.insert(0, str(E_ROOT / "tmp/kproj_arithmetic"))

import phi_coefficients as phi  # noqa: E402
import core as invariants  # noqa: E402


TARGET_DEGREES = (25, 31, 35)
PRIMES = ((89, 2026080189), (199, 2026080199))
FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"
BASE_NAMES = ("x", "C", "D", "E", "K")
BASE_DEGREES = {"x": 1, "C": 4, "D": 5, "E": 6, "K": 7}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def rank_mod_details(matrix: np.ndarray, prime: int) -> tuple[int, np.ndarray]:
    # FFPACK overwrites its matrix argument.  A forced copy is load-bearing:
    # the original evaluation rows are subsequently stored and, in the
    # corank-one cases, multiplied into the quartic closure.
    value = np.array(matrix, dtype=np.int32, order="C", copy=True)
    row_permutation = np.empty(value.shape[0], dtype=np.uintp)
    pivot_columns = np.empty(value.shape[1], dtype=np.uintp)
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
    rank = int(
        function(
            prime,
            value.shape[0],
            value.shape[1],
            value.ctypes.data_as(ctypes.POINTER(ctypes.c_int32)),
            value.shape[1],
            row_permutation.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
            pivot_columns.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
            False,
            2,
            True,
        )
    )
    row_order = np.empty_like(row_permutation)
    convert = ctypes.CDLL(FFPACK).LAPACKPerm2MathPerm
    convert.argtypes = [
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_size_t,
    ]
    convert.restype = None
    convert(
        row_order.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        row_permutation.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        len(row_order),
    )
    assert sorted(row_order.tolist()) == list(range(len(row_order)))
    return rank, row_order.astype(np.int64)


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    return rank_mod_details(matrix, prime)[0]


def invariant_labels(degree: int):
    labels = []
    for secondary_index, secondary_degree in enumerate(invariants.SECONDARY_DEGREES):
        if secondary_degree > degree:
            continue
        for exponents in invariants.weighted_exponents(degree - secondary_degree):
            labels.append((secondary_index, tuple(map(int, exponents))))
    return labels


def invariant_polynomial(label):
    secondary_index, exponents = label
    return phi.multiply(
        invariants.primary_monomial(exponents),
        invariants.secondary_polynomials()[secondary_index],
    )


def label_json(label):
    secondary_index, exponents = label
    return {
        "secondary_index": int(secondary_index),
        "secondary_name": invariants.SECONDARY_NAMES[secondary_index],
        "secondary_degree": int(invariants.SECONDARY_DEGREES[secondary_index]),
        "primary_exponents": list(map(int, exponents)),
        "primary_degrees": list(map(int, invariants.PRIMARY_DEGREES)),
    }


def all_words():
    words = [((name,), BASE_DEGREES[name]) for name in BASE_NAMES]
    nonidentity = BASE_NAMES[1:]
    for outer in nonidentity:
        for inner in nonidentity:
            degree = BASE_DEGREES[outer] * BASE_DEGREES[inner]
            if degree <= max(TARGET_DEGREES):
                words.append(((outer, inner), degree))
    return words


def select_directions(target: int):
    occurrence: dict[int, int] = {}
    directions = []
    for word, base_degree in all_words():
        residual = target - base_degree
        if residual < 0:
            continue
        labels = invariant_labels(residual)
        if not labels:
            continue
        index = occurrence.get(residual, 0) % len(labels)
        occurrence[residual] = occurrence.get(residual, 0) + 1
        label = labels[index]
        directions.append(
            {
                "word": word,
                "base_degree": base_degree,
                "multiplier_degree": residual,
                "multiplier_label": label,
                "multiplier": invariant_polynomial(label),
            }
        )
    return directions


def eval_poly_mod(polynomial, point, prime: int) -> int:
    answer = 0
    for exponents, coefficient in polynomial.items():
        term = coefficient % prime
        for value, exponent in zip(point, exponents):
            if exponent:
                term = term * pow(int(value), int(exponent), prime) % prime
        answer = (answer + term) % prime
    return int(answer)


def frame_data():
    _names, frame, _coefficients = phi.all_coefficients()
    return dict(zip(BASE_NAMES, frame))


def eval_vector_mod(vector, point, prime: int):
    return np.array(
        [eval_poly_mod(component, point, prime) for component in vector],
        dtype=np.int64,
    )


def eval_word(word, point, prime: int, frame):
    value = np.asarray(point, dtype=np.int64) % prime
    for name in reversed(word):
        if name == "x":
            continue
        value = eval_vector_mod(frame[name], value, prime)
    return value % prime


def coefficient_triples(dimension: int):
    return tuple(itertools.combinations_with_replacement(range(dimension), 3))


def cubic_row(vectors: np.ndarray, prime: int, triples) -> np.ndarray:
    answer = np.zeros(len(triples), dtype=np.int32)
    for column, triple in enumerate(triples):
        multiplicities = {index: triple.count(index) for index in set(triple)}
        if len(multiplicities) == 1:
            u = vectors[triple[0]]
            value = sum(
                int(u[i]) * int(u[i]) * int(u[(i + 1) % 5])
                for i in range(5)
            )
        elif len(multiplicities) == 2:
            repeated = next(i for i, count in multiplicities.items() if count == 2)
            singleton = next(i for i, count in multiplicities.items() if count == 1)
            u, v = vectors[repeated], vectors[singleton]
            value = sum(
                int(u[i]) * int(u[i]) * int(v[(i + 1) % 5])
                + 2 * int(u[i]) * int(v[i]) * int(u[(i + 1) % 5])
                for i in range(5)
            )
        else:
            u, v, w = (vectors[index] for index in triple)
            value = 2 * sum(
                int(u[i]) * int(v[i]) * int(w[(i + 1) % 5])
                + int(u[i]) * int(w[i]) * int(v[(i + 1) % 5])
                + int(v[i]) * int(w[i]) * int(u[(i + 1) % 5])
                for i in range(5)
            )
        answer[column] = value % prime
    return answer


def quartic_multiples(cubics: np.ndarray, dimension: int) -> np.ndarray:
    triples = coefficient_triples(dimension)
    quartics = tuple(itertools.combinations_with_replacement(range(dimension), 4))
    quartic_index = {monomial: index for index, monomial in enumerate(quartics)}
    positions = np.array(
        [
            [quartic_index[tuple(sorted(triple + (variable,)))] for triple in triples]
            for variable in range(dimension)
        ],
        dtype=np.int32,
    )
    answer = np.zeros(
        (len(cubics) * dimension, len(quartics)),
        dtype=np.int32,
    )
    for variable in range(dimension):
        rows = np.arange(variable, len(answer), dimension)
        answer[rows[:, None], positions[variable][None, :]] = cubics
    return answer


def evaluate_directions(directions, point, prime: int, frame):
    rows = []
    for direction in directions:
        multiplier = eval_poly_mod(direction["multiplier"], point, prime)
        vector = eval_word(direction["word"], point, prime, frame)
        rows.append(vector * multiplier % prime)
    return np.asarray(rows, dtype=np.int64)


def produce_degree(target: int, frame) -> dict:
    directory = HERE / f"degree_{target}"
    directory.mkdir(exist_ok=True)
    directions = select_directions(target)
    triples = coefficient_triples(len(directions))
    records = []
    for prime, seed in PRIMES:
        rng = np.random.default_rng(seed + target)
        point_count = len(triples) + 64
        points = rng.integers(0, prime, size=(point_count, 5), dtype=np.int64)
        rows = np.vstack(
            [
                cubic_row(
                    evaluate_directions(directions, point, prime, frame),
                    prime,
                    triples,
                )
                for point in points
            ]
        ).astype(np.int32)
        rank, row_order = rank_mod_details(rows, prime)
        independent_rows = row_order[:rank]
        quartic_record = None
        if rank < len(triples):
            quartic_dimension = math.comb(len(directions) + 3, 4)
            estimated_bytes = rank * len(directions) * quartic_dimension * 4
            selected = rows[independent_rows]
            quartic_matrix = quartic_multiples(selected, len(directions))
            quartic_rank = rank_mod(quartic_matrix, prime)
            quartic_record = {
                "matrix_shape": list(quartic_matrix.shape),
                "estimated_dense_bytes": estimated_bytes,
                "rank": quartic_rank,
                "target_dimension": quartic_dimension,
                "contains_all_quartics": quartic_rank == quartic_dimension,
            }
            del quartic_matrix
        np.savez_compressed(
            directory / f"landing_evaluations_p{prime}.npz",
            points=points.astype(np.int32),
            rows=rows,
            independent_row_indices=independent_rows.astype(np.int32),
        )
        records.append(
            {
                "prime": prime,
                "rng_seed": seed + target,
                "point_count": point_count,
                "matrix_shape": list(rows.shape),
                "rank": rank,
                "full_symmetric_cube_rank": rank == len(triples),
                "quartic_closure": quartic_record,
                "payload": f"landing_evaluations_p{prime}.npz",
                "payload_sha256": sha256(directory / f"landing_evaluations_p{prime}.npz"),
            }
        )
        print(
            f"degree={target} prime={prime} directions={len(directions)} "
            f"sym3={len(triples)} rank={rank} "
            f"quartic={None if quartic_record is None else quartic_record['rank']}",
            flush=True,
        )

    payload = {
        "degree": target,
        "ansatz": "invariant-scaled x,C,D,E,K and all homogenizable ordered two-fold compositions",
        "integral_model": True,
        "direction_count": len(directions),
        "symmetric_cube_dimension": len(triples),
        "directions": [
            {
                "word_outer_to_inner": list(direction["word"]),
                "base_degree": direction["base_degree"],
                "multiplier_degree": direction["multiplier_degree"],
                "multiplier": label_json(direction["multiplier_label"]),
            }
            for direction in directions
        ],
        "prime_records": records,
        "characteristic_zero_conclusion": (
            "empty_projective_ansatz"
            if all(
                record["full_symmetric_cube_rank"]
                or record["quartic_closure"]["contains_all_quartics"]
                for record in records
            )
            else "not_decided"
        ),
        "proof_rule": (
            "Modulo a good prime, the homogeneous landing ideal either spans "
            "the full cubic parameter space or its degree-four closure spans "
            "every quartic. Thus its projective special fibre is empty. The "
            "directions and landing equations have an integral model, so "
            "projectivity (equivalently proper specialization) makes the "
            "characteristic-zero projective fibre empty. The second prime is "
            "an independent holdout, not the characteristic-zero bridge."
        ),
        "scope": "this globally equivariant composition-frame ansatz only",
    }
    (directory / "ansatz.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    return payload


def main() -> None:
    frame = frame_data()
    phi.verify_expansion(tuple(frame[name] for name in BASE_NAMES), phi.all_coefficients()[2])
    summary = {str(degree): produce_degree(degree, frame) for degree in TARGET_DEGREES}
    (HERE / "ansatz_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n"
    )
    print("COV_COMPOSITION_ANSATZ_PRODUCED", flush=True)


if __name__ == "__main__":
    main()
