#!/usr/bin/env python3
"""Produce the fixed C3/C6 landing gate in degrees 31 and 35.

For a C3 eigenline U, a landing restriction P(U) -> X has finite image and
is therefore projectively constant.  Global equivariance under the setwise
C6 stabilizer forces the constant to be the unique C6-fixed point of
X intersect P(U_target).  Proportionality to this point is linear in the
fixed global K1 coefficients.

The construction uses the same abstract group element, stabilizer indices,
evaluation rows, and minor columns at two split primes.  Its exact circuit is
defined over Q(zeta_11, omega), omega^2+omega+1=0; modular RREF is used only
to certify a fixed nonzero minor, not to change the global K1 basis.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402


PRIMES = {397: 16, 463: 15}
DIMENSIONS = {31: 198, 35: 361}
EXPECTED_RANKS = {31: 11, 35: 13}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    value = np.array(matrix, dtype=np.int64, copy=True) % prime
    row = 0
    for column in range(value.shape[1]):
        candidates = np.flatnonzero(value[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
        factors = value[:, column].copy()
        indices = np.flatnonzero(factors)
        indices = indices[indices != row]
        if len(indices):
            value[indices] = (
                value[indices] - factors[indices, None] * value[row]
            ) % prime
        row += 1
        if row == value.shape[0]:
            break
    return row


def nullspace_mod(matrix: np.ndarray, prime: int) -> np.ndarray:
    value = np.array(matrix, dtype=np.int64, copy=True) % prime
    row = 0
    pivots = []
    for column in range(value.shape[1]):
        candidates = np.flatnonzero(value[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
        factors = value[:, column].copy()
        indices = np.flatnonzero(factors)
        indices = indices[indices != row]
        if len(indices):
            value[indices] = (
                value[indices] - factors[indices, None] * value[row]
            ) % prime
        pivots.append(column)
        row += 1
        if row == value.shape[0]:
            break
    free = [column for column in range(value.shape[1]) if column not in pivots]
    answer = []
    for column in free:
        vector = np.zeros(value.shape[1], dtype=np.int64)
        vector[column] = 1
        for pivot_row, pivot_column in enumerate(pivots):
            vector[pivot_column] = -value[pivot_row, column] % prime
        answer.append(vector)
    return np.asarray(answer, dtype=np.int64)


def matrix_order(matrix: np.ndarray, prime: int) -> int:
    identity = np.eye(5, dtype=np.int64)
    power = identity.copy()
    for order in range(1, 100):
        power = power @ matrix % prime
        if np.array_equal(power, identity):
            return order
    raise AssertionError("matrix order exceeds 99")


def stable_subspace(matrix: np.ndarray, subspace: np.ndarray, prime: int) -> bool:
    image = (matrix @ subspace.T).T % prime
    return rank_mod(np.vstack([subspace, image]), prime) == len(subspace)


def klein(vector: np.ndarray, prime: int) -> int:
    return sum(
        int(vector[index]) ** 2 * int(vector[(index + 1) % 5])
        for index in range(5)
    ) % prime


def projective_roots(subspace: np.ndarray, prime: int) -> list[np.ndarray]:
    roots = []
    for parameter in range(prime):
        vector = (subspace[0] + parameter * subspace[1]) % prime
        if klein(vector, prime) == 0:
            roots.append(vector)
    if klein(subspace[1], prime) == 0:
        roots.append(subspace[1].copy())
    return roots


def fixed_projectively(vector: np.ndarray, matrices, prime: int) -> bool:
    return all(
        rank_mod(np.vstack([vector, matrix @ vector % prime]), prime) == 1
        for matrix in matrices
    )


def geometry(module, prime: int, generator_index=None, stabilizer_indices=None):
    omega = next(
        value for value in range(2, prime)
        if (value * value + value + 1) % prime == 0
    )
    if generator_index is None:
        generator_index = next(
            index for index, matrix in enumerate(module.GROUP)
            if matrix_order(matrix, prime) == 3
            and len(nullspace_mod(
                matrix - omega * np.eye(5, dtype=np.int64), prime
            )) == 2
        )
    generator = module.GROUP[generator_index]
    assert matrix_order(generator, prime) == 3
    eigenspaces = {
        1: nullspace_mod(
            generator - omega * np.eye(5, dtype=np.int64), prime
        ),
        2: nullspace_mod(
            generator - omega * omega % prime * np.eye(5, dtype=np.int64), prime
        ),
    }
    source = eigenspaces[1]
    if stabilizer_indices is None:
        stabilizer_indices = [
            index for index, matrix in enumerate(module.GROUP)
            if stable_subspace(matrix, source, prime)
        ]
    stabilizer = [module.GROUP[index] for index in stabilizer_indices]
    assert len(stabilizer) == 6
    assert all(stable_subspace(matrix, source, prime) for matrix in stabilizer)
    roots = {}
    fixed_roots = {}
    for exponent, target in eigenspaces.items():
        roots[exponent] = projective_roots(target, prime)
        assert len(roots[exponent]) == 3
        fixed_roots[exponent] = [
            root for root in roots[exponent]
            if fixed_projectively(root, stabilizer, prime)
        ]
        assert len(fixed_roots[exponent]) == 1
    return omega, generator_index, eigenspaces, stabilizer_indices, roots, fixed_roots


def line_points(subspace: np.ndarray, degree: int, prime: int) -> np.ndarray:
    return np.asarray([
        (subspace[0] + parameter * subspace[1]) % prime
        for parameter in range(degree + 1)
    ], dtype=np.int64)


def constant_gate(values: np.ndarray, root: np.ndarray, prime: int) -> np.ndarray:
    pivot = int(np.flatnonzero(root)[0])
    rows = [
        root[pivot] * values[:, target, :]
        - root[target] * values[:, pivot, :]
        for target in range(5) if target != pivot
    ]
    return np.concatenate(rows, axis=0).astype(np.int64) % prime


def main() -> None:
    generators_path = HERE / "dual_hironaka_generators.json"
    generators = json.loads(generators_path.read_text())["generators"]
    result = {
        "schema": "cov-m1-c3-c6-constant-gate-v2",
        "field": "Q(zeta_11,omega), omega^2+omega+1=0",
        "scope": (
            "fixed characteristic-zero necessary linear landing gate; "
            "residual nonlinear scheme not decided"
        ),
        "dual_generators_sha256": sha256(generators_path),
        "circuit": (
            "RREF eigenspace of one fixed order-three group element; evaluate "
            "each fixed Reynolds cross at d+1 affine points; wedge the value "
            "against the unique projectively C6-fixed Klein root"
        ),
        "prime_records": {},
        "degrees": {},
    }
    generator_index = None
    stabilizer_indices = None
    fixed_minors = {}
    for prime, zeta in PRIMES.items():
        module = basis.module_at(prime, zeta)
        (omega, current_generator, eigenspaces, current_stabilizer,
         roots, fixed_roots) = geometry(
            module, prime, generator_index, stabilizer_indices
        )
        if generator_index is None:
            generator_index = current_generator
            stabilizer_indices = current_stabilizer
        assert current_generator == generator_index
        assert current_stabilizer == stabilizer_indices
        prime_record = {
            "prime": prime,
            "zeta11": zeta,
            "omega": omega,
            "order_three_generator_index": generator_index,
            "source_eigenspace": eigenspaces[1].tolist(),
            "setwise_stabilizer_indices": stabilizer_indices,
            "degrees": {},
        }
        for degree, dimension in DIMENSIONS.items():
            basis_path = HERE / f"degree_{degree}/m1_cross_basis_circuits.json"
            records = json.loads(basis_path.read_text())["basis"]
            assert len(records) == dimension
            points = line_points(eigenspaces[1], degree, prime)
            evaluator = basis.DualEvaluator(module, points, prime)
            dual_values = basis.evaluate_fixed_dual_generators(evaluator, generators)
            values = basis.evaluate_fixed_crosses(
                records, dual_values, points, prime
            ).reshape(len(points), 5, dimension)
            exponent = degree % 3
            root = fixed_roots[exponent][0]
            gate = constant_gate(values, root, prime)
            gate_rank = rank_mod(gate, prime)
            assert gate_rank == EXPECTED_RANKS[degree]
            restriction_rank = rank_mod(values.reshape(-1, dimension), prime)
            if degree not in fixed_minors:
                rows = basis.rank_profile(gate, prime)
                columns = basis.rank_profile(gate[rows].T, prime)
                assert len(rows) == len(columns) == gate_rank
                fixed_minors[degree] = rows, columns
            rows, columns = fixed_minors[degree]
            assert rank_mod(gate[np.ix_(rows, columns)], prime) == gate_rank
            payload_path = HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz"
            np.savez_compressed(
                payload_path,
                source_points=points.astype(np.uint16),
                basis_values=values.astype(np.uint16),
                gate_matrix=gate.astype(np.uint16),
                unique_c6_root=root.astype(np.uint16),
                fixed_minor_rows=rows.astype(np.uint16),
                fixed_minor_columns=columns.astype(np.uint16),
            )
            prime_record["degrees"][str(degree)] = {
                "basis_sha256": sha256(basis_path),
                "payload": str(payload_path.relative_to(HERE)),
                "payload_sha256": sha256(payload_path),
                "input_dimension": dimension,
                "source_line_point_count": len(points),
                "target_eigenvalue_exponent": exponent,
                "target_three_roots": [item.tolist() for item in roots[exponent]],
                "unique_C6_fixed_root": root.tolist(),
                "gate_matrix_shape": list(gate.shape),
                "gate_rank": gate_rank,
                "gate_kernel_dimension": dimension - gate_rank,
                "restriction_map_rank": restriction_rank,
                "allowed_constant_scalar_form_dimension": restriction_rank - gate_rank,
                "fixed_minor_rows": rows.tolist(),
                "fixed_minor_columns": columns.tolist(),
            }
            print(
                f"p={prime} d={degree}: C3/C6 rank={gate_rank}, "
                f"kernel={dimension-gate_rank}, restriction={restriction_rank}",
                flush=True,
            )
        result["prime_records"][str(prime)] = prime_record
    result["fixed_group_data"] = {
        "order_three_generator_index": generator_index,
        "setwise_stabilizer_indices": stabilizer_indices,
    }
    for degree, dimension in DIMENSIONS.items():
        ranks = {
            str(prime): result["prime_records"][str(prime)]["degrees"][str(degree)][
                "gate_rank"
            ] for prime in PRIMES
        }
        result["degrees"][str(degree)] = {
            "input_dimension": dimension,
            "fixed_gate_rank_lower_bound_in_characteristic_zero": EXPECTED_RANKS[degree],
            "equalizer_dimension_upper_bound_in_characteristic_zero": (
                dimension - EXPECTED_RANKS[degree]
            ),
            "two_split_prime_ranks": ranks,
            "rank_scope": (
                "The fixed nonzero minor proves the characteristic-zero lower "
                "bound on constraint rank. A separate exact upper theorem has "
                "not been supplied, so equality is not asserted."
            ),
        }
    output = HERE / "c3_constant_gate.json"
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("COV_M1_C3_CONSTANT_GATE_PRODUCED")


if __name__ == "__main__":
    main()
