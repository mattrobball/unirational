#!/usr/bin/env python3
"""Independent replay of all eleven degree-31 lower-K1 factor graphs.

The verifier does not import the producer.  It independently reselects every
lower fixed cross-circuit basis at p=419, holds those records fixed at p=463,
rebuilds all multiplication tensors and kernels, checks full projective graph
samples and tangent minors, and only then compares the producer artifact.
"""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
WORK = ROOT / "goals_2026-08-01" / "COV_M1_DEG31_35_WORK"
DUAL_PATH = WORK / "dual_hironaka_generators.json"
TARGET_PATH = WORK / "degree_31" / "m1_cross_basis_circuits.json"
PRODUCER_NPZ = HERE / "pc3_d31_common_factor_union.npz"
PRODUCER_JSON = HERE / "pc3_d31_common_factor_union.json"
E6_NPZ = HERE / "pc3_d31_e6_factor_incidence.npz"
OUTPUT = HERE / "verify_pc3_d31_common_factor_union_result.json"

PRIMES = {419: 13, 463: 15}
SPECS = {
    3: (28, 1, 115, 115),
    5: (26, 1, 75, 75),
    6: (25, 2, 59, 111),
    7: (24, 1, 44, 44),
    8: (23, 2, 34, 68),
    9: (22, 3, 25, 75),
    10: (21, 3, 16, 48),
    11: (20, 4, 11, 44),
    12: (19, 6, 7, 42),
    13: (18, 5, 3, 15),
    14: (17, 8, 2, 16),
}


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


sys.path.insert(0, str(WORK))
cross = load("pc3_d31_union_verify_cross", WORK / "produce_cross_basis.py")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def echelon(matrix: np.ndarray, prime: int) -> tuple[np.ndarray, list[int]]:
    matrix = np.asarray(matrix, dtype=np.int64).copy() % prime
    row = 0
    pivots = []
    for column in range(matrix.shape[1]):
        pivot = next(
            (candidate for candidate in range(row, matrix.shape[0])
             if matrix[candidate, column]),
            None,
        )
        if pivot is None:
            continue
        matrix[[row, pivot]] = matrix[[pivot, row]]
        matrix[row] = matrix[row] * pow(int(matrix[row, column]), -1, prime) % prime
        for other in range(matrix.shape[0]):
            if other != row and matrix[other, column]:
                matrix[other] = (
                    matrix[other] - matrix[other, column] * matrix[row]
                ) % prime
        pivots.append(column)
        row += 1
        if row == matrix.shape[0]:
            break
    return matrix, pivots


def rank(matrix: np.ndarray, prime: int) -> int:
    return len(echelon(matrix, prime)[1])


def inverse(matrix: np.ndarray, prime: int) -> np.ndarray:
    matrix = np.asarray(matrix, dtype=np.int64) % prime
    size = len(matrix)
    reduced, pivots = echelon(
        np.hstack([matrix, np.eye(size, dtype=np.int64)]), prime
    )
    assert pivots[:size] == list(range(size))
    assert np.array_equal(reduced[:, :size], np.eye(size, dtype=np.int64))
    return reduced[:, size:]


def right_kernel(matrix: np.ndarray, prime: int) -> np.ndarray:
    reduced, pivots = echelon(matrix, prime)
    free = [column for column in range(matrix.shape[1]) if column not in pivots]
    vectors = np.zeros((matrix.shape[1], len(free)), dtype=np.int64)
    vectors[free, np.arange(len(free))] = 1
    for row, pivot in enumerate(pivots):
        vectors[pivot] = -reduced[row, free] % prime
    assert not np.any(np.asarray(matrix, dtype=np.int64) @ vectors % prime)
    return vectors


def row_profile(matrix: np.ndarray, prime: int) -> tuple[int, ...]:
    return tuple(echelon(np.asarray(matrix).T, prime)[1])


class IncrementalBasis:
    def __init__(self, prime: int):
        self.prime = prime
        self.rows: list[tuple[int, np.ndarray]] = []

    def add(self, vector: np.ndarray) -> bool:
        value = np.asarray(vector, dtype=np.int64).copy() % self.prime
        for pivot, row in self.rows:
            if value[pivot]:
                value = (value - value[pivot] * row) % self.prime
        nonzero = np.flatnonzero(value)
        if not len(nonzero):
            return False
        pivot = int(nonzero[0])
        value = value * pow(int(value[pivot]), -1, self.prime) % self.prime
        self.rows.append((pivot, value))
        return True


def independent_scan(
    degree: int, expected: int, generators: list[dict],
    dual_values: np.ndarray, points: np.ndarray, prime: int,
) -> list[dict]:
    generator_degrees = [int(record["degree"]) for record in generators]
    basis = IncrementalBasis(prime)
    selected = []
    for indices in itertools.combinations(range(len(generators)), 4):
        residual = degree - sum(generator_degrees[index] for index in indices)
        if residual < 0:
            continue
        wedge = cross.cross4(dual_values, indices, prime)
        for label in cross.invariant_labels(residual):
            scalar = cross.evaluate_polynomial(
                cross.invariant_polynomial(label), points, prime
            )
            value = wedge * scalar[:, None] % prime
            if basis.add(value.reshape(-1)):
                selected.append(cross.direction_json(indices, label))
                if len(selected) == expected:
                    return selected
    assert expected == 0 and not selected
    return selected


def evaluate_records(
    records: list[dict], dual_values: np.ndarray,
    points: np.ndarray, prime: int,
) -> np.ndarray:
    columns = []
    for record in records:
        indices = tuple(map(int, record["dual_generator_indices"]))
        label_record = record["multiplier"]
        label = (
            int(label_record["secondary_index"]),
            tuple(map(int, label_record["primary_exponents"])),
        )
        wedge = cross.cross4(dual_values, indices, prime)
        scalar = cross.evaluate_polynomial(
            cross.invariant_polynomial(label), points, prime
        )
        columns.append((wedge * scalar[:, None] % prime).reshape(-1))
    return np.column_stack(columns)


def tangent(tensor: np.ndarray, prime: int) -> np.ndarray:
    _, factor_dimension, lower_dimension = tensor.shape
    factor = np.arange(1, factor_dimension + 1, dtype=np.int64) % prime
    lower = np.arange(1, lower_dimension + 1, dtype=np.int64) % prime
    value = np.einsum("kab,a,b->k", tensor, factor, lower) % prime
    columns = [value]
    for index in range(1, factor_dimension):
        columns.append(tensor[:, index, :] @ lower % prime)
    for index in range(1, lower_dimension):
        columns.append(tensor[:, :, index] @ factor % prime)
    return np.column_stack(columns) % prime


def verify_graph(tensor: np.ndarray, prime: int) -> int:
    target_dimension, factor_dimension, lower_dimension = tensor.shape
    for sample in range(3):
        factor = np.asarray(
            [1] + [((sample + 2) * (index + 3) + 1) % prime
                   for index in range(factor_dimension - 1)], dtype=np.int64
        )
        lower = np.asarray(
            [1] + [((sample + 5) * (index + 7) + 2) % prime
                   for index in range(lower_dimension - 1)], dtype=np.int64
        )
        z = np.outer(factor, lower) % prime
        for a in range(factor_dimension):
            for c in range(a + 1, factor_dimension):
                for b in range(lower_dimension):
                    for d in range(b + 1, lower_dimension):
                        assert (z[a, b] * z[c, d] - z[a, d] * z[c, b]) % prime == 0
        direct = np.einsum("kab,a,b->k", tensor, factor, lower) % prime
        graph = tensor.reshape(target_dimension, -1) @ z.reshape(-1) % prime
        assert np.array_equal(direct, graph)
        assert np.any(graph)
    return 3


def main() -> None:
    generators = json.loads(DUAL_PATH.read_text())["generators"]
    target_packet = json.loads(TARGET_PATH.read_text())
    points = cross.fixed_points(80)

    module419 = cross.module_at(419, 13)
    evaluator419 = cross.DualEvaluator(module419, points % 419, 419)
    dual419 = cross.evaluate_fixed_dual_generators(evaluator419, generators)
    lower_bases = {}
    for factor_degree, (lower_degree, _, lower_dimension, _) in SPECS.items():
        lower_bases[factor_degree] = independent_scan(
            lower_degree, lower_dimension, generators, dual419, points % 419, 419
        )
    for degree in range(17):
        assert independent_scan(
            degree, 0, generators, dual419, points % 419, 419
        ) == []

    computed: dict[str, np.ndarray] = {
        "fixed_evaluation_points": points.astype(np.uint16),
    }
    records = []
    tangent_rows = {}
    for prime, zeta in PRIMES.items():
        print(f"verify p={prime}: all degree-31 common-factor graphs", flush=True)
        module = module419 if prime == 419 else cross.module_at(prime, zeta)
        dual_values = dual419 if prime == 419 else cross.evaluate_fixed_dual_generators(
            cross.DualEvaluator(module, points % prime, prime), generators
        )
        target = cross.evaluate_fixed_crosses(
            target_packet["basis"], dual_values, points % prime, prime
        )
        target_rows = np.asarray(target_packet["fixed_maximal_minor_rows"], dtype=np.int64)
        target_inverse = inverse(target[target_rows], prime)
        component_records = {}
        for factor_degree, (lower_degree, factor_dimension, lower_dimension, expected_rank) in SPECS.items():
            lower = evaluate_records(
                lower_bases[factor_degree], dual_values, points % prime, prime
            )
            assert rank(lower, prime) == lower_dimension
            legs = []
            for label in cross.invariant_labels(factor_degree):
                scalar = cross.evaluate_polynomial(
                    cross.invariant_polynomial(label), points % prime, prime
                )
                product = (
                    lower.reshape(80, 5, lower_dimension) * scalar[:, None, None]
                ).reshape(400, lower_dimension) % prime
                leg = target_inverse @ product[target_rows] % prime
                assert np.array_equal(target @ leg % prime, product)
                legs.append(leg)
            tensor = np.stack(legs, axis=1) % prime
            flattened = tensor.reshape(198, -1)
            assert rank(flattened, prime) == expected_rank
            relation_kernel = right_kernel(flattened, prime)
            tangent_matrix = tangent(tensor, prime)
            expected_tangent = factor_dimension + lower_dimension - 1
            assert rank(tangent_matrix, prime) == expected_tangent
            if factor_degree not in tangent_rows:
                tangent_rows[factor_degree] = row_profile(tangent_matrix, prime)
            assert rank(tangent_matrix[list(tangent_rows[factor_degree])], prime) == expected_tangent
            sample_count = verify_graph(tensor, prime)

            computed[f"tensor_e{factor_degree}_p{prime}"] = tensor.astype(np.uint16)
            computed[f"kernel_e{factor_degree}_p{prime}"] = relation_kernel.astype(np.uint16)
            computed[f"tangent_e{factor_degree}_p{prime}"] = tangent_matrix.astype(np.uint16)
            component_records[str(factor_degree)] = {
                "lower_rank": rank(lower, prime),
                "flattened_rank": rank(flattened, prime),
                "kernel_dimension": relation_kernel.shape[1],
                "tangent_rank": rank(tangent_matrix, prime),
                "graph_samples": sample_count,
                "tensor_sha256": sha256_array(tensor.astype(np.uint16)),
            }
        records.append({"prime": prime, "components": component_records})

    for factor_degree, rows in tangent_rows.items():
        computed[f"tangent_minor_rows_e{factor_degree}"] = np.asarray(rows, dtype=np.uint16)

    with np.load(PRODUCER_NPZ, allow_pickle=False) as frozen:
        assert set(frozen.files) == set(computed)
        for name, expected in computed.items():
            assert np.array_equal(frozen[name], expected), name

    # The separately verified deep e=6 artifact must use the identical tensor.
    with np.load(E6_NPZ, allow_pickle=False) as e6:
        for prime in PRIMES:
            assert np.array_equal(
                computed[f"tensor_e6_p{prime}"], e6[f"tensor_p{prime}"]
            )

    metadata = json.loads(PRODUCER_JSON.read_text())
    assert metadata["schema"] == "pc3-d31-lower-k1-factor-subunion-v2"
    assert metadata["artifact_sha256"] == sha256_file(PRODUCER_NPZ)
    assert metadata["gcd_theorem_and_scope_gap"]["installed_nonempty_factor_degrees"] == list(SPECS)
    assert metadata["gcd_theorem_and_scope_gap"]["installed_K1_zero_degrees"] == {
        str(degree): 0 for degree in range(17)
    }
    for factor_degree, basis in lower_bases.items():
        assert metadata["components"][str(factor_degree)]["lower_basis_circuits"] == basis
        assert metadata["components"][str(factor_degree)]["tangent_minor_rows"] == list(
            tangent_rows[factor_degree]
        )

    result = {
        "schema": "verify-pc3-d31-common-factor-union-v1",
        "verdict": "PASS",
        "producer_imported": False,
        "stored_arrays_used_as_computational_inputs": False,
        "producer_artifact_sha256": sha256_file(PRODUCER_NPZ),
        "producer_metadata_sha256": sha256_file(PRODUCER_JSON),
        "factor_degrees": list(SPECS),
        "prime_records": records,
        "e6_deep_tensor_identity": True,
        "scope": (
            "Independent two-prime replay of all eleven projective degree-31 "
            "lower-K1 factor graphs in the literal K1 spaces, including "
            "fixed lower bases, tensors, kernels, graph equations, and tangent minors."
        ),
        "boundary": (
            "This is a certified factorable subunion, not the exhaustive common-factor "
            "locus: the lower quotient after gcd division need only be equivariant. "
            "Target-only ideals and entrywise Q(zeta_11) tensors are not materialized."
        ),
    }
    OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PC3_D31_COMMON_FACTOR_UNION_VERIFIED", flush=True)


if __name__ == "__main__":
    main()
