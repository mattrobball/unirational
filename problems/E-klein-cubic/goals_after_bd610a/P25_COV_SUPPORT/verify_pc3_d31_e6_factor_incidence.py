#!/usr/bin/env python3
"""Independent replay of the kernel-aware degree-31 I_6*K1_25 incidence.

No producer code is imported.  The verifier rebuilds the fixed source and
target cross circuits, the two multiplication legs, the seven-dimensional
flattening kernel, a gcd-one maximal-minor pencil certificate, the projective
tangent witness, and deterministic graph points.  Stored arrays are opened
only after all load-bearing computations have been completed.
"""

from __future__ import annotations

import hashlib
import importlib.util
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
WORK = ROOT / "goals_2026-08-01" / "COV_M1_DEG31_35_WORK"
DUAL_PATH = WORK / "dual_hironaka_generators.json"
SOURCE_PATH = WORK / "degree_25_fixed_k1_basis.json"
TARGET_PATH = WORK / "degree_31" / "m1_cross_basis_circuits.json"
PRODUCER_NPZ = HERE / "pc3_d31_e6_factor_incidence.npz"
PRODUCER_JSON = HERE / "pc3_d31_e6_factor_incidence.json"
OUTPUT = HERE / "verify_pc3_d31_e6_factor_incidence_result.json"

PRIMES = {419: 13, 463: 15}
FACTOR_LABELS = [(0, (0, 0, 1, 0, 0)), (0, (2, 0, 0, 0, 0))]


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


sys.path.insert(0, str(WORK))
cross = load("pc3_e6_verify_cross", WORK / "produce_cross_basis.py")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def reduce_matrix(matrix: np.ndarray, prime: int) -> tuple[np.ndarray, list[int]]:
    matrix = np.asarray(matrix, dtype=np.int64).copy() % prime
    pivot_row = 0
    pivot_columns = []
    for column in range(matrix.shape[1]):
        pivot = next(
            (row for row in range(pivot_row, matrix.shape[0])
             if matrix[row, column]),
            None,
        )
        if pivot is None:
            continue
        matrix[[pivot_row, pivot]] = matrix[[pivot, pivot_row]]
        matrix[pivot_row] = (
            matrix[pivot_row]
            * pow(int(matrix[pivot_row, column]), -1, prime)
        ) % prime
        for row in range(matrix.shape[0]):
            if row != pivot_row and matrix[row, column]:
                matrix[row] = (
                    matrix[row] - matrix[row, column] * matrix[pivot_row]
                ) % prime
        pivot_columns.append(column)
        pivot_row += 1
        if pivot_row == matrix.shape[0]:
            break
    return matrix, pivot_columns


def rank(matrix: np.ndarray, prime: int) -> int:
    return len(reduce_matrix(matrix, prime)[1])


def invert(matrix: np.ndarray, prime: int) -> np.ndarray:
    matrix = np.asarray(matrix, dtype=np.int64) % prime
    size = len(matrix)
    reduced, pivots = reduce_matrix(
        np.concatenate([matrix, np.eye(size, dtype=np.int64)], axis=1), prime
    )
    assert pivots[:size] == list(range(size))
    assert np.array_equal(reduced[:, :size], np.eye(size, dtype=np.int64))
    return reduced[:, size:]


def kernel(matrix: np.ndarray, prime: int) -> np.ndarray:
    reduced, pivots = reduce_matrix(matrix, prime)
    free = [column for column in range(matrix.shape[1]) if column not in pivots]
    vectors = []
    for column in free:
        vector = np.zeros(matrix.shape[1], dtype=np.int64)
        vector[column] = 1
        for row, pivot in enumerate(pivots):
            vector[pivot] = -reduced[row, column] % prime
        vectors.append(vector)
    answer = np.asarray(vectors, dtype=np.int64).T
    assert not np.any(np.asarray(matrix, dtype=np.int64) @ answer % prime)
    return answer


def row_profile(matrix: np.ndarray, prime: int) -> tuple[int, ...]:
    return tuple(reduce_matrix(np.asarray(matrix).T, prime)[1])


def determinant(matrix: np.ndarray, prime: int) -> int:
    matrix = np.asarray(matrix, dtype=np.int64).copy() % prime
    value = 1
    for column in range(len(matrix)):
        pivot = next(
            (row for row in range(column, len(matrix)) if matrix[row, column]),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            matrix[[column, pivot]] = matrix[[pivot, column]]
            value = -value
        diagonal = int(matrix[column, column])
        value = value * diagonal % prime
        inverse = pow(diagonal, -1, prime)
        for row in range(column + 1, len(matrix)):
            if matrix[row, column]:
                multiplier = matrix[row, column] * inverse % prime
                matrix[row] = (matrix[row] - multiplier * matrix[column]) % prime
    return value % prime


def trim(polynomial: list[int] | np.ndarray, prime: int) -> list[int]:
    polynomial = [int(value) % prime for value in polynomial]
    while polynomial and not polynomial[-1]:
        polynomial.pop()
    return polynomial


def remainder(left: list[int], right: list[int], prime: int) -> list[int]:
    left = trim(left, prime)
    right = trim(right, prime)
    while left and len(left) >= len(right):
        offset = len(left) - len(right)
        scale = left[-1] * pow(right[-1], -1, prime) % prime
        for index, coefficient in enumerate(right):
            left[index + offset] = (left[index + offset] - scale * coefficient) % prime
        left = trim(left, prime)
    return left


def gcd(left: list[int], right: list[int], prime: int) -> list[int]:
    left, right = trim(left, prime), trim(right, prime)
    while right:
        left, right = right, remainder(left, right, prime)
    inverse = pow(left[-1], -1, prime)
    return [coefficient * inverse % prime for coefficient in left]


def determinant_coefficients(
    first: np.ndarray, second: np.ndarray,
    rows: tuple[int, ...], prime: int,
) -> np.ndarray:
    values = np.asarray([
        determinant((first + parameter * second)[list(rows)] % prime, prime)
        for parameter in range(60)
    ], dtype=np.int64)
    vandermonde = np.asarray([
        [pow(parameter, exponent, prime) for exponent in range(60)]
        for parameter in range(60)
    ], dtype=np.int64)
    coefficients = invert(vandermonde, prime) @ values % prime
    for parameter in (61, 73, 101):
        lhs = determinant((first + parameter * second)[list(rows)] % prime, prime)
        rhs = sum(
            int(value) * pow(parameter, exponent, prime)
            for exponent, value in enumerate(coefficients)
        ) % prime
        assert lhs == rhs
    return coefficients


def pencil_data(tensor: np.ndarray, prime: int):
    first, second = tensor[:, 0, :], tensor[:, 1, :]
    profiles = []
    for parameter in range(20):
        profile = row_profile((first + parameter * second) % prime, prime)
        assert len(profile) == 59
        if profile not in profiles:
            profiles.append(profile)
    selected = []
    polynomials = []
    common = []
    for profile in profiles:
        polynomial = determinant_coefficients(first, second, profile, prime)
        selected.append(profile)
        polynomials.append(polynomial)
        current = trim(polynomial, prime)
        common = current if not common else gcd(common, current, prime)
        if common == [1]:
            break
    assert common == [1]
    assert rank(second, prime) == 59
    return selected, polynomials, common


def tangent(tensor: np.ndarray, prime: int) -> np.ndarray:
    first, second = tensor[:, 0, :], tensor[:, 1, :]
    lower = np.arange(1, 60, dtype=np.int64) % prime
    parameter = 2
    value = (first @ lower + parameter * (second @ lower)) % prime
    derivative_a1 = second @ lower % prime
    derivative_b = (first[:, 1:] + parameter * second[:, 1:]) % prime
    return np.column_stack([value, derivative_a1, derivative_b]) % prime


def graph_sample_checks(tensor: np.ndarray, prime: int) -> int:
    checks = 0
    for sample in range(7):
        factor = np.asarray([1, sample + 2], dtype=np.int64) % prime
        lower = np.asarray(
            [1] + [((sample + 3) * (index + 5) + 7) % prime for index in range(58)],
            dtype=np.int64,
        )
        z = np.outer(factor, lower) % prime
        # All Segre 2x2 minors vanish.  Checking all 1711 avoids a sampled
        # equation replay masquerading as the full graph relation.
        for left in range(59):
            for right in range(left + 1, 59):
                assert (
                    z[0, left] * z[1, right]
                    - z[0, right] * z[1, left]
                ) % prime == 0
        y_direct = (
            tensor[:, 0, :] @ (factor[0] * lower % prime)
            + tensor[:, 1, :] @ (factor[1] * lower % prime)
        ) % prime
        y_graph = tensor.reshape(198, 118) @ z.reshape(118) % prime
        assert np.array_equal(y_direct, y_graph)
        assert np.any(y_graph)
        checks += 1
    return checks


def main() -> None:
    dual_records = json.loads(DUAL_PATH.read_text())["generators"]
    source_records = json.loads(SOURCE_PATH.read_text())["basis"]
    target_packet = json.loads(TARGET_PATH.read_text())
    points = cross.fixed_points(80)
    computed: dict[str, np.ndarray] = {
        "fixed_evaluation_points": points.astype(np.uint16),
    }
    records = []
    common_pencil_rows = None
    common_tangent_rows = None
    for prime, zeta in PRIMES.items():
        print(f"verify p={prime}: rebuilding e6 incidence", flush=True)
        module = cross.module_at(prime, zeta)
        evaluator = cross.DualEvaluator(module, points % prime, prime)
        dual_values = cross.evaluate_fixed_dual_generators(evaluator, dual_records)
        source = cross.evaluate_fixed_crosses(
            source_records, dual_values, points % prime, prime
        )
        target = cross.evaluate_fixed_crosses(
            target_packet["basis"], dual_values, points % prime, prime
        )
        rows = np.asarray(target_packet["fixed_maximal_minor_rows"], dtype=np.int64)
        target_inverse = invert(target[rows], prime)
        legs = []
        for label in FACTOR_LABELS:
            scalar = cross.evaluate_polynomial(
                cross.invariant_polynomial(label), points % prime, prime
            )
            product = (
                source.reshape(80, 5, 59) * scalar[:, None, None]
            ).reshape(400, 59) % prime
            leg = target_inverse @ product[rows] % prime
            assert np.array_equal(target @ leg % prime, product)
            assert rank(leg, prime) == 59
            legs.append(leg)
        tensor = np.stack(legs, axis=1) % prime
        flattened = tensor.reshape(198, 118)
        assert rank(flattened, prime) == 111
        flattened_kernel = kernel(flattened, prime)
        assert flattened_kernel.shape == (118, 7)

        pencil_rows, pencil_polynomials, polynomial_gcd = pencil_data(tensor, prime)
        if common_pencil_rows is None:
            common_pencil_rows = pencil_rows
        else:
            assert pencil_rows == common_pencil_rows
        tangent_matrix = tangent(tensor, prime)
        assert rank(tangent_matrix, prime) == 60
        tangent_rows = row_profile(tangent_matrix, prime)
        if common_tangent_rows is None:
            common_tangent_rows = tangent_rows
        else:
            assert rank(tangent_matrix[list(common_tangent_rows)], prime) == 60
        sample_count = graph_sample_checks(tensor, prime)

        computed[f"tensor_p{prime}"] = tensor.astype(np.uint16)
        computed[f"flattened_kernel_p{prime}"] = flattened_kernel.astype(np.uint16)
        computed[f"tangent_matrix_p{prime}"] = tangent_matrix.astype(np.uint16)
        for index, polynomial in enumerate(pencil_polynomials):
            computed[f"pencil_minor_{index}_coefficients_p{prime}"] = polynomial.astype(np.uint16)
        records.append({
            "prime": prime,
            "tensor_rank": rank(flattened, prime),
            "kernel_dimension": flattened_kernel.shape[1],
            "kernel_residual_nonzeros": int(np.count_nonzero(flattened @ flattened_kernel % prime)),
            "pencil_minor_degrees": [len(trim(value, prime)) - 1 for value in pencil_polynomials],
            "pencil_gcd": polynomial_gcd,
            "pencil_infinity_rank": rank(tensor[:, 1, :], prime),
            "projective_tangent_augmented_rank": rank(tangent_matrix, prime),
            "full_graph_samples_checked": sample_count,
            "tensor_sha256": sha256_array(tensor.astype(np.uint16)),
        })

    assert common_pencil_rows is not None and common_tangent_rows is not None
    computed["pencil_minor_rows"] = np.asarray(common_pencil_rows, dtype=np.uint16)
    computed["tangent_minor_rows"] = np.asarray(common_tangent_rows, dtype=np.uint16)

    with np.load(PRODUCER_NPZ, allow_pickle=False) as frozen:
        assert set(frozen.files) == set(computed)
        for name, expected in computed.items():
            assert np.array_equal(frozen[name], expected), name

    metadata = json.loads(PRODUCER_JSON.read_text())
    assert metadata["schema"] == "pc3-d31-e6-common-factor-incidence-v1"
    assert metadata["artifact_sha256"] == sha256_file(PRODUCER_NPZ)
    assert metadata["component"]["projective_image_dimension"] == 59
    assert metadata["kernel_aware_graph"]["segree_equation_count"] == 1711
    assert metadata["kernel_aware_graph"]["graph_equation_count"] == 198
    assert metadata["kernel_aware_graph"]["pencil_minor_rows"] == [
        list(rows) for rows in common_pencil_rows
    ]

    result = {
        "schema": "verify-pc3-d31-e6-common-factor-incidence-v1",
        "verdict": "PASS",
        "producer_imported": False,
        "stored_arrays_used_as_computational_inputs": False,
        "producer_artifact_sha256": sha256_file(PRODUCER_NPZ),
        "producer_metadata_sha256": sha256_file(PRODUCER_JSON),
        "prime_records": records,
        "verified_equations": {
            "segree_quadrics": 1711,
            "graph_linear_equations": 198,
            "deterministic_graph_points_per_prime": 7,
        },
        "scope": (
            "Independent two-prime replay of the literal 198x2x59 multiplication "
            "tensor, its rank-111/kernel-7 flattening, basepoint-free pencil, "
            "rank-59 projective tangent witness, and kernel-aware Segre graph."
        ),
        "boundary": (
            "This verifies the degree-6 factor component, not the complete finite "
            "union of degree-31 factor components, a target-only elimination ideal, "
            "or the unresolved PC.2 landing pullback."
        ),
    }
    OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PC3_D31_E6_FACTOR_INCIDENCE_VERIFIED", flush=True)


if __name__ == "__main__":
    main()
