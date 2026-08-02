#!/usr/bin/env python3
"""Produce the exact pure-composition graph ledger for PC.3.

The lower self-covariant spaces through degree seven have integral circuit
bases

    M1 = <x>,                 M4 = <F*x,C>,
    M5 = <D>,                M6 = <H*x,E>,
    M7 = <K,F*C,F^2*x,J*x>.

Degree 31 is prime, so it has no nontrivial pure two-fold composition.
Degree 35 has precisely the ordered families D o M7 and M7 o D, both with
source P(M7)=P^3.  This producer constructs their projective graph maps in a
fixed injective evaluation frame for M35.  It separately computes restriction
to one involution plus-plane, hence intersection with the literal K1_35.

No invariant multiplier, common-factor component, linear span of an image,
landing saturation, or target-only elimination ideal is substituted for an
actual composition graph.
"""

from __future__ import annotations

from collections import defaultdict
import ctypes
import hashlib
import json
from itertools import combinations_with_replacement
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
WORK = ROOT / "goals_2026-08-01" / "COV_M1_DEG31_35_WORK"
STRUCTURED = ROOT / "goals_2026-08-01" / "COV_STRUCTURED_SEARCH"
EXACT = ROOT / "certificates" / "exact_covariants_check.py"
SEPTIC = ROOT / "certificates" / "septic_landing_check.py"
TARGET_FULL = WORK / "degree_35" / "full_reynolds_circuits.json"
TARGET_K1 = WORK / "degree_35" / "m1_cross_basis_circuits.json"
DUAL = WORK / "dual_hironaka_generators.json"
CANONICAL = WORK / "canonical_bases.json"
OLD_ANSATZ = {
    31: STRUCTURED / "degree_31" / "ansatz.json",
    35: STRUCTURED / "degree_35" / "ansatz.json",
}
OUTPUT_JSON = HERE / "pc3_composition_graphs.json"
OUTPUT_NPZ = HERE / "pc3_composition_graphs.npz"

PRIMES = {419: 13, 463: 15}
P35_FULL_DIMENSION = 637
P35_K1_DIMENSION = 361
M7_DIMENSION = 4

sys.path.insert(0, str(WORK))
import produce_cross_basis as cross  # noqa: E402


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
    function = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib").Rank_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rows, columns = dense.shape
    return int(function(float(prime), rows, columns, dense, columns, False))


def rref(matrix: np.ndarray, prime: int) -> tuple[np.ndarray, list[int]]:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    pivots: list[int] = []
    row = 0
    for column in range(value.shape[1]):
        choices = np.flatnonzero(value[row:, column])
        if not len(choices):
            continue
        pivot = row + int(choices[0])
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
        factors = value[:, column].copy()
        factors[row] = 0
        active = np.flatnonzero(factors)
        if len(active):
            value[active] = (
                value[active] - factors[active, None] * value[row][None, :]
            ) % prime
        pivots.append(column)
        row += 1
        if row == value.shape[0]:
            break
    return value, pivots


def right_kernel(matrix: np.ndarray, prime: int) -> np.ndarray:
    reduced, pivots = rref(matrix, prime)
    free = [column for column in range(matrix.shape[1]) if column not in pivots]
    answer = np.zeros((matrix.shape[1], len(free)), dtype=np.int64)
    answer[free, np.arange(len(free))] = 1
    for row, pivot in enumerate(pivots):
        answer[pivot] = -reduced[row, free] % prime
    assert not np.any(np.asarray(matrix, dtype=np.int64) @ answer % prime)
    return answer


def weak_compositions(total: int, slots: int) -> list[tuple[int, ...]]:
    if slots == 1:
        return [(total,)]
    answer = []
    for first in range(total + 1):
        answer.extend(
            (first,) + tail for tail in weak_compositions(total - first, slots - 1)
        )
    return answer


def cyclic_vector(base: dict[tuple[int, ...], int]) -> list[dict[tuple[int, ...], int]]:
    return [
        {
            tuple(exponents[(coordinate - shift) % 5] for coordinate in range(5)): coefficient
            for exponents, coefficient in base.items()
            if coefficient
        }
        for shift in range(5)
    ]


C0 = {
    (0, 0, 0, 4, 0): 1,
    (0, 1, 1, 0, 2): 4,
    (1, 0, 0, 2, 1): 4,
    (1, 2, 1, 0, 0): 8,
    (2, 0, 0, 0, 2): 6,
    (3, 1, 0, 0, 0): 4,
}
D0 = {
    (0, 0, 2, 0, 3): -5,
    (0, 1, 0, 3, 1): -5,
    (0, 3, 1, 1, 0): 5,
    (0, 5, 0, 0, 0): -1,
    (1, 1, 0, 1, 2): 10,
    (1, 1, 2, 0, 1): -5,
    (2, 0, 1, 2, 0): -5,
    (2, 2, 0, 1, 0): -5,
    (3, 0, 1, 0, 1): 5,
}
H0 = {
    (3, 0, 2, 0, 0): 1,
    (3, 0, 0, 1, 1): -1,
    (2, 0, 0, 3, 0): 1,
    (1, 3, 0, 0, 1): -1,
    (1, 1, 3, 0, 0): -1,
    (1, 1, 1, 1, 1): 3,
    (0, 3, 0, 2, 0): 1,
    (0, 2, 0, 0, 3): 1,
    (0, 1, 1, 3, 0): -1,
    (0, 0, 3, 0, 2): 1,
    (0, 0, 1, 1, 3): -1,
}
EPARAMS = [
    (0, 0, 1, 3, 2), (0, 0, 3, 2, 1), (0, 0, 5, 1, 0),
    (0, 1, 0, 0, 5), (0, 2, 0, 2, 2), (0, 2, 2, 1, 1),
    (0, 2, 4, 0, 0), (0, 4, 1, 0, 1), (1, 0, 1, 1, 3),
    (1, 0, 3, 0, 2), (1, 1, 1, 3, 0), (1, 2, 0, 0, 3),
    (1, 3, 0, 2, 0), (2, 1, 1, 1, 1), (2, 1, 3, 0, 0),
    (2, 3, 0, 0, 1), (3, 0, 0, 3, 0), (4, 0, 0, 1, 1),
    (4, 0, 2, 0, 0),
]
ECO = [-2, 1, 0, 1, 3, 3, -1, -1, 0, 0, 4, 2, 1, 0, 3, -3, -1, -1, 0]
KPARAMS = [
    (0, 0, 0, 6, 1), (0, 0, 1, 0, 6), (0, 0, 2, 5, 0),
    (0, 1, 1, 2, 3), (0, 1, 3, 1, 2), (0, 1, 5, 0, 1),
    (0, 2, 1, 4, 0), (0, 3, 0, 1, 3), (0, 3, 2, 0, 2),
    (0, 4, 0, 3, 0), (1, 0, 0, 4, 2), (1, 0, 2, 3, 1),
    (1, 0, 4, 2, 0), (1, 1, 1, 0, 4), (1, 2, 1, 2, 1),
    (1, 2, 3, 1, 0), (1, 4, 0, 1, 1), (1, 4, 2, 0, 0),
    (2, 0, 0, 2, 3), (2, 0, 2, 1, 2), (2, 0, 4, 0, 1),
    (2, 1, 0, 4, 0), (2, 2, 1, 0, 2), (3, 0, 0, 0, 4),
    (3, 1, 0, 2, 1), (3, 1, 2, 1, 0), (3, 3, 1, 0, 0),
    (4, 1, 0, 0, 2), (5, 0, 1, 1, 0), (5, 2, 0, 0, 0),
]
KCO = [
    0, -1, -1, -4, 0, -2, -1, -4, 2, -1, 0, 0, 3, -16, 28,
    0, -18, 0, -6, 22, -11, -10, 16, 3, 20, 12, -8, -9, -12, 4,
]

CV = cyclic_vector(C0)
DV = cyclic_vector(D0)
EV = cyclic_vector({e: c for e, c in zip(EPARAMS, ECO) if c})
KV = cyclic_vector({e: c for e, c in zip(KPARAMS, KCO) if c})


def evaluate_polynomial(
    polynomial: dict[tuple[int, ...], int], points: np.ndarray, prime: int
) -> np.ndarray:
    points = np.asarray(points, dtype=np.int64) % prime
    answer = np.zeros(len(points), dtype=np.int64)
    for exponents, coefficient in polynomial.items():
        value = np.full(len(points), coefficient % prime, dtype=np.int64)
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                value = value * np.asarray(
                    [pow(int(x), exponent, prime) for x in points[:, coordinate]],
                    dtype=np.int64,
                ) % prime
        answer = (answer + value) % prime
    return answer


def evaluate_vector(polynomials, points: np.ndarray, prime: int) -> np.ndarray:
    return np.column_stack([
        evaluate_polynomial(polynomial, points, prime) for polynomial in polynomials
    ])


def invariant_F(points: np.ndarray, prime: int) -> np.ndarray:
    points = np.asarray(points, dtype=np.int64) % prime
    return sum(
        points[:, i] ** 2 % prime * points[:, (i + 1) % 5]
        for i in range(5)
    ) % prime


def gradient_q(points: np.ndarray, prime: int) -> np.ndarray:
    points = np.asarray(points, dtype=np.int64) % prime
    return np.column_stack([
        (2 * points[:, i] * points[:, (i + 1) % 5]
         + points[:, (i - 1) % 5] ** 2) % prime
        for i in range(5)
    ])


def lower_basis_values(points: np.ndarray, prime: int) -> dict[int, np.ndarray]:
    points = np.asarray(points, dtype=np.int64) % prime
    x = points
    f = invariant_F(points, prime)
    c = evaluate_vector(CV, points, prime)
    d = evaluate_vector(DV, points, prime)
    h = evaluate_polynomial(H0, points, prime)
    e = evaluate_vector(EV, points, prime)
    k = evaluate_vector(KV, points, prime)
    q = gradient_q(points, prime)
    j = np.sum(q * c, axis=1) * pow(3, -1, prime) % prime
    return {
        1: x[:, :, None],
        4: np.stack([f[:, None] * x % prime, c], axis=2),
        5: d[:, :, None],
        6: np.stack([h[:, None] * x % prime, e], axis=2),
        7: np.stack(
            [k, f[:, None] * c % prime, f[:, None] ** 2 % prime * x % prime,
             j[:, None] * x % prime],
            axis=2,
        ),
    }


def self_covariant_dimensions(module, prime: int, maximum: int = 7) -> list[int]:
    group = np.asarray(module.GROUP, dtype=np.int64) % prime
    inverses = np.asarray(module.INVERSES, dtype=np.int64) % prime
    totals = [0] * (maximum + 1)
    for matrix, inverse in zip(group, inverses):
        powers = np.eye(5, dtype=np.int64)
        traces = []
        for _ in range(maximum):
            powers = powers @ inverse % prime
            traces.append(int(np.trace(powers) % prime))
        complete = [1]
        for degree in range(1, maximum + 1):
            numerator = sum(
                traces[k - 1] * complete[degree - k]
                for k in range(1, degree + 1)
            ) % prime
            complete.append(numerator * pow(degree, -1, prime) % prime)
        target_trace = int(np.trace(matrix) % prime)
        for degree in range(maximum + 1):
            totals[degree] = (totals[degree] + target_trace * complete[degree]) % prime
    inverse_order = pow(len(group), -1, prime)
    return [value * inverse_order % prime for value in totals]


def multiply_parameter_polynomials(left, right, prime: int):
    answer: dict[tuple[int, ...], int] = {}
    for a, ca in left.items():
        for b, cb in right.items():
            exponent = tuple(x + y for x, y in zip(a, b))
            answer[exponent] = (answer.get(exponent, 0) + ca * cb) % prime
    return {key: value for key, value in answer.items() if value}


def linear_power(coefficients: np.ndarray, exponent: int, prime: int):
    one = {(0, 0, 0, 0): 1}
    linear = {
        tuple(1 if i == j else 0 for i in range(4)): int(value) % prime
        for j, value in enumerate(coefficients)
        if value % prime
    }
    answer = one
    for _ in range(exponent):
        answer = multiply_parameter_polynomials(answer, linear, prime)
    return answer


def d_after_m7_evaluations(points: np.ndarray, prime: int) -> np.ndarray:
    """Coefficients of D(sum a_i Q7_i(x)) in the degree-five a-monomials."""
    monomials = weak_compositions(5, 4)
    monomial_index = {item: index for index, item in enumerate(monomials)}
    m7 = lower_basis_values(points, prime)[7]
    answer = np.zeros((len(points) * 5, len(monomials)), dtype=np.int64)
    for point_index in range(len(points)):
        powers = [
            [linear_power(m7[point_index, coordinate], degree, prime)
             for degree in range(6)]
            for coordinate in range(5)
        ]
        for output, polynomial in enumerate(DV):
            accumulated: dict[tuple[int, ...], int] = {}
            for exponents, coefficient in polynomial.items():
                term = {(0, 0, 0, 0): coefficient % prime}
                for coordinate, exponent in enumerate(exponents):
                    term = multiply_parameter_polynomials(
                        term, powers[coordinate][exponent], prime
                    )
                for parameter_exponents, value in term.items():
                    accumulated[parameter_exponents] = (
                        accumulated.get(parameter_exponents, 0) + value
                    ) % prime
            row = point_index * 5 + output
            for parameter_exponents, value in accumulated.items():
                answer[row, monomial_index[parameter_exponents]] = value
    return answer % prime


def m7_after_d_evaluations(points: np.ndarray, prime: int) -> np.ndarray:
    d = evaluate_vector(DV, points, prime)
    return lower_basis_values(d, prime)[7].reshape(len(points) * 5, 4)


def veronese_vector(parameters: np.ndarray, prime: int) -> np.ndarray:
    return np.asarray([
        np.prod([
            pow(int(parameters[index]), exponent, prime)
            for index, exponent in enumerate(monomial)
        ], dtype=object) % prime
        for monomial in weak_compositions(5, 4)
    ], dtype=np.int64)


def veronese_quadrics() -> tuple[np.ndarray, np.ndarray]:
    monomials = np.asarray(weak_compositions(5, 4), dtype=np.int8)
    groups: dict[tuple[int, ...], list[tuple[int, int]]] = defaultdict(list)
    for left, right in combinations_with_replacement(range(len(monomials)), 2):
        groups[tuple(map(int, monomials[left] + monomials[right]))].append((left, right))
    circuits = []
    for pairs in groups.values():
        reference = pairs[0]
        circuits.extend((left, right, reference[0], reference[1]) for left, right in pairs[1:])
    return monomials, np.asarray(circuits, dtype=np.int16)


def verify_veronese_circuits(vector: np.ndarray, circuits: np.ndarray, prime: int) -> None:
    for left, right, ref_left, ref_right in circuits:
        assert (
            int(vector[left]) * int(vector[right])
            - int(vector[ref_left]) * int(vector[ref_right])
        ) % prime == 0


def classify_old_ansatz(degree: int) -> dict:
    payload = json.loads(OLD_ANSATZ[degree].read_text())
    compositions = [
        record for record in payload["directions"]
        if len(record["word_outer_to_inner"]) >= 2
    ]
    pure = [record for record in compositions if record["multiplier_degree"] == 0]
    scaled = [record for record in compositions if record["multiplier_degree"] > 0]
    return {
        "old_named_composition_directions": len(compositions),
        "pure_named_directions": [record["word_outer_to_inner"] for record in pure],
        "positive_invariant_scaled_named_directions": len(scaled),
        "classification": (
            "Positive-invariant-scaled directions belong to the common scalar-factor "
            "union. They are not components of the pure composition locus."
        ),
    }


def main() -> None:
    input_paths = [EXACT, SEPTIC, TARGET_FULL, TARGET_K1, DUAL, CANONICAL, *OLD_ANSATZ.values()]
    input_hashes = {str(path.relative_to(ROOT)): sha256_file(path) for path in input_paths}
    full_records = json.loads(TARGET_FULL.read_text())
    k1_packet = json.loads(TARGET_K1.read_text())
    dual_records = json.loads(DUAL.read_text())["generators"]
    assert len(full_records) == P35_FULL_DIMENSION
    assert len(k1_packet["basis"]) == P35_K1_DIMENSION

    fixed_points = cross.fixed_points(140)
    holdout419 = np.load(WORK / "degree_35" / "basis_holdout_p419.npz")
    frame_rows = holdout419["full_basis_minor_rows"].astype(np.int32)
    assert frame_rows.shape == (P35_FULL_DIMENSION,)
    monomials, quadrics = veronese_quadrics()
    assert monomials.shape == (56, 4)
    assert len(quadrics) == 1310
    installed_nontrivial_degrees = [4, 5, 6, 7]
    assert [
        (left, right)
        for left in installed_nontrivial_degrees
        for right in installed_nontrivial_degrees
        if left * right == 31
    ] == []
    assert [
        (left, right)
        for left in installed_nontrivial_degrees
        for right in installed_nontrivial_degrees
        if left * right == 35
    ] == [(5, 7), (7, 5)]

    arrays: dict[str, np.ndarray] = {
        "fixed_evaluation_points": fixed_points.astype(np.uint16),
        "target_frame_rows": frame_rows,
        "veronese_degree5_exponents": monomials,
        "veronese_quadratic_circuits": quadrics,
    }
    prime_records = {}
    expected_dimensions = [0, 1, 0, 0, 2, 1, 2, 4]
    for prime, zeta in PRIMES.items():
        print(f"p={prime}: lower-space and degree-35 composition graphs", flush=True)
        module = cross.module_at(prime, zeta)
        dimensions = self_covariant_dimensions(module, prime)
        assert dimensions == expected_dimensions
        small_points = fixed_points[:20] % prime
        lower = lower_basis_values(small_points, prime)
        lower_ranks = {
            str(degree): rank_mod(values.reshape(-1, values.shape[2]), prime)
            for degree, values in lower.items()
        }
        assert lower_ranks == {"1": 1, "4": 2, "5": 1, "6": 2, "7": 4}

        full_values = cross.full_seed_evaluations(
            module, full_records, fixed_points % prime, prime
        )
        assert full_values.shape == (700, P35_FULL_DIMENSION)
        assert rank_mod(full_values, prime) == P35_FULL_DIMENSION
        assert rank_mod(full_values[frame_rows], prime) == P35_FULL_DIMENSION

        dual_evaluator = cross.DualEvaluator(module, fixed_points % prime, prime)
        dual_values = cross.evaluate_fixed_dual_generators(dual_evaluator, dual_records)
        k1_values = cross.evaluate_fixed_crosses(
            k1_packet["basis"], dual_values, fixed_points % prime, prime
        )
        k1_frame = k1_values[frame_rows]
        assert rank_mod(k1_frame, prime) == P35_K1_DIMENSION
        quotient = right_kernel(k1_frame.T, prime).T
        assert quotient.shape == (P35_FULL_DIMENSION - P35_K1_DIMENSION, P35_FULL_DIMENSION)
        assert rank_mod(quotient, prime) == 276
        assert not np.any(quotient @ k1_frame % prime)

        plus = cross.plus_basis(module, prime)
        plane_points = cross.plane_points(plus, 35, prime)
        assert plane_points.shape == (666, 5)

        families = {}
        for name, evaluator, source_columns in (
            ("D_after_M7", d_after_m7_evaluations, 56),
            ("M7_after_D", m7_after_d_evaluations, 4),
        ):
            evaluations = evaluator(fixed_points % prime, prime)
            plane_restriction = evaluator(plane_points, prime)
            assert evaluations.shape == (700, source_columns)
            assert plane_restriction.shape == (3330, source_columns)
            target_map = evaluations[frame_rows] % prime
            target_rank = rank_mod(target_map, prime)
            target_kernel = right_kernel(target_map, prime)
            obstruction = quotient @ target_map % prime
            obstruction_rank = rank_mod(obstruction, prime)
            plane_rank = rank_mod(plane_restriction, prime)
            assert target_rank == source_columns
            assert target_kernel.shape == (source_columns, 0)
            assert obstruction_rank == plane_rank == source_columns
            assert rank_mod(np.vstack([obstruction, plane_restriction]), prime) == source_columns

            arrays[f"target_map_{name}_p{prime}"] = target_map.astype(np.uint16)
            arrays[f"target_kernel_{name}_p{prime}"] = target_kernel.astype(np.uint16)
            arrays[f"k1_obstruction_{name}_p{prime}"] = obstruction.astype(np.uint16)
            arrays[f"plus_plane_restriction_{name}_p{prime}"] = plane_restriction.astype(np.uint16)

            sample_count = 0
            for sample in range(3):
                parameters = np.asarray(
                    [1, sample + 2, 2 * sample + 3, 3 * sample + 5], dtype=np.int64
                ) % prime
                if name == "D_after_M7":
                    source = veronese_vector(parameters, prime)
                    verify_veronese_circuits(source, quadrics, prime)
                    m7_at_points = lower_basis_values(fixed_points % prime, prime)[7]
                    inner = np.einsum("pci,i->pc", m7_at_points, parameters) % prime
                    direct = evaluate_vector(DV, inner, prime).reshape(-1)[frame_rows]
                else:
                    source = parameters
                    direct = target_map @ source % prime
                graph = target_map @ source % prime
                assert np.array_equal(graph, direct)
                assert np.any(graph)
                sample_count += 1
            families[name] = {
                "source_linearization_columns": source_columns,
                "target_map_rank": target_rank,
                "target_map_kernel_dimension": target_kernel.shape[1],
                "K1_obstruction_rank": obstruction_rank,
                "plus_plane_restriction_rank": plane_rank,
                "K1_projective_intersection_empty": True,
                "target_map_sha256": sha256_array(target_map.astype(np.uint16)),
                "K1_obstruction_sha256": sha256_array(obstruction.astype(np.uint16)),
                "plus_plane_restriction_sha256": sha256_array(
                    plane_restriction.astype(np.uint16)
                ),
                "graph_samples_checked": sample_count,
            }
            print(
                f"  {name}: target={target_rank}/{source_columns} "
                f"K1-obstruction={obstruction_rank}/{source_columns}",
                flush=True,
            )

        arrays[f"k1_target_frame_p{prime}"] = k1_frame.astype(np.uint16)
        arrays[f"k1_quotient_p{prime}"] = quotient.astype(np.uint16)
        arrays[f"plus_basis_p{prime}"] = plus.astype(np.uint16)
        prime_records[str(prime)] = {
            "prime": prime,
            "zeta11": zeta,
            "self_covariant_dimensions_d0_through_d7": dimensions,
            "installed_lower_basis_ranks": lower_ranks,
            "target_full_frame_rank": rank_mod(full_values[frame_rows], prime),
            "target_K1_frame_rank": rank_mod(k1_frame, prime),
            "target_K1_quotient_rank": rank_mod(quotient, prime),
            "families": families,
        }

    np.savez_compressed(OUTPUT_NPZ, **arrays)
    payload = {
        "schema": "pc3-pure-composition-projective-graphs-v1",
        "status": "PC3-COMPOSITION-GRAPHS-SCOPED-PASS",
        "global_status": "PC-UNDECIDED",
        "field": "Q(zeta_11), with exact integral lower-map circuits and good reductions at 419 and 463",
        "lower_self_covariant_spaces": {
            "degree_1": {"dimension": 1, "basis": ["x"], "parameter_space": "P^0"},
            "degree_2": {"dimension": 0, "basis": [], "parameter_space": "empty"},
            "degree_3": {"dimension": 0, "basis": [], "parameter_space": "empty"},
            "degree_4": {
                "dimension": 2,
                "basis": ["F*x", "C=grad(F_dual)(grad(F))"],
                "parameter_space": "P^1",
                "primitive_quotient": "M4/<F*x> is one-dimensional, represented by C",
            },
            "degree_5": {"dimension": 1, "basis": ["D"], "parameter_space": "P^0"},
            "degree_6": {"dimension": 2, "basis": ["H*x", "E"], "parameter_space": "P^1"},
            "degree_7": {
                "dimension": 4,
                "basis": ["K", "F*C", "F^2*x", "J*x"],
                "parameter_space": "P^3",
            },
            "circuit_source": str(EXACT.relative_to(ROOT)),
            "septic_basis_source": str(SEPTIC.relative_to(ROOT)),
        },
        "degree_arithmetic": {
            "31": {
                "factorization": "31 is prime",
                "nontrivial_pure_composition_components": [],
                "conclusion": "No pure lower-degree two-fold composition has degree 31.",
            },
            "35": {
                "factorization": "35=5*7=7*5",
                "nontrivial_pure_composition_components": ["D_after_M7", "M7_after_D"],
                "complete_union": True,
            },
            "primitive_quartic": (
                "Degree 4 divides neither 31 nor 35. Any old degree-31/35 direction "
                "containing C therefore also has a positive invariant multiplier and "
                "belongs to the common scalar-factor union, not the pure composition union."
            ),
        },
        "projective_graphs": {
            "D_after_M7": {
                "source": "P(M7)=P^3",
                "source_embedding": "fifth Veronese nu_5:P^3->P^55",
                "veronese_coordinates": 56,
                "veronese_quadratic_circuits": int(len(quadrics)),
                "target": "P(M35)=P^636 in the fixed 637-coordinate evaluation frame",
                "map": "[z] -> [T_D_after_M7 z]",
                "graph_equations": "Veronese quadrics in z and y wedge (Tz)=0",
                "kernel_guard": "Saturate by the entries of Tz if ker(T) meets the source. Here T has zero linear kernel at both good primes, so there is no projective base locus.",
                "K1_intersection": "Add Qy=0, equivalently the exact plus-plane restriction matrix times z equals zero.",
            },
            "M7_after_D": {
                "source": "P(M7)=P^3",
                "target": "P(M35)=P^636 in the fixed 637-coordinate evaluation frame",
                "map": "[a] -> [T_M7_after_D a]",
                "graph_equations": "y wedge (Ta)=0",
                "kernel_guard": "T has zero kernel at both good primes, so this is a projective linear embedding.",
                "K1_intersection": "Add Qy=0, equivalently the exact plus-plane restriction matrix times a equals zero.",
            },
        },
        "K1_result": {
            "degree_35": (
                "For each ordered pure composition family, restriction to one full "
                "degree-35 triangular grid on an involution plus-plane has full source-"
                "linearization rank at p=419 and p=463. Thus neither projective graph "
                "meets the literal K1_35 space in characteristic zero."
            ),
            "scope": (
                "This excludes only the two pure lower-degree composition graphs from "
                "literal K1_35. It is not a landing-ideal saturation or a statement about "
                "the complement of the composition union."
            ),
        },
        "incidence_intersections": {
            "D_after_M7_with_literal_K1_35": "empty",
            "M7_after_D_with_literal_K1_35": "empty",
            "either_graph_with_literal_K1_35_and_any_common_factor_locus": (
                "empty, formally because each graph already has empty intersection "
                "with literal K1_35"
            ),
            "either_graph_with_corrected_exhaustive_common_factor_locus_in_full_M35": "not computed",
            "mutual_intersection_of_the_two_full_M35_graphs": "not computed",
            "factor_boundary": (
                "The corrected common-factor incidence must allow h*H in literal K1 "
                "even when H is not in a lower literal K1 space, because the invariant "
                "factor h may itself vanish on every involution plane. The smaller "
                "union I_e*K1_(35-e) is not used here as the exhaustive factor locus."
            ),
        },
        "old_named_ansatz_classification": {
            "degree_31": classify_old_ansatz(31),
            "degree_35": classify_old_ansatz(35),
            "warning": "The old ansatz files tested fixed directions and linear spans; they are not definitions of the nonlinear composition graphs constructed here.",
        },
        "prime_records": prime_records,
        "certificate": {
            "file": OUTPUT_NPZ.name,
            "sha256": sha256_file(OUTPUT_NPZ),
            "arrays": {key: list(map(int, value.shape)) for key, value in arrays.items()},
        },
        "inputs": input_hashes,
        "theorem_boundary": {
            "proves": (
                "The exact lower self-map parameter spaces through degree seven; the "
                "complete pure-composition census in degrees 31 and 35; two kernel-aware "
                "degree-35 projective graph constructions; and emptiness of their "
                "intersections with literal K1_35."
            ),
            "does_not_prove": (
                "A common-factor incidence result, equality with any linear span, a named-"
                "ansatz union theorem, saturation away from composition/factor loci, a "
                "degree-31/35 landing survivor or emptiness theorem, or the headline."
            ),
        },
    }
    OUTPUT_JSON.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS_PC3_LOWER_SELF_MAP_CIRCUIT_CENSUS")
    print("PASS_PC3_D35_TWO_KERNEL_AWARE_COMPOSITION_GRAPHS")
    print("PASS_PC3_D35_PURE_COMPOSITIONS_DISJOINT_FROM_LITERAL_K1")


if __name__ == "__main__":
    main()
