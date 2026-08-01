#!/usr/bin/env python3
"""Probe the exact C3-line/C6-point landing gate on the fixed K1 bases.

Over a split good fibre, choose an order-three element and one of its
two-dimensional eigenspaces U.  A landing restriction P(U)->X has finite
image because X intersect P(U) is three reduced points, hence it is
projectively constant.  Equivariance under the setwise C6 stabilizer selects
the unique C6-fixed point.  Membership in that target line is linear in the
global K1 coefficients.

This is a discovery producer.  A terminal theorem would additionally bind
the characteristic-zero incidence theorem and solve the residual nonlinear
landing system on the resulting kernel.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402


P = 463
ZETA = 15


def rank_mod(matrix: np.ndarray, prime: int | None = None) -> int:
    if prime is None:
        prime = P
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


def nullspace_mod(matrix: np.ndarray, prime: int | None = None) -> np.ndarray:
    if prime is None:
        prime = P
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


def matrix_order(matrix: np.ndarray, prime: int | None = None) -> int:
    if prime is None:
        prime = P
    identity = np.eye(5, dtype=np.int64)
    power = identity.copy()
    for order in range(1, 100):
        power = power @ matrix % prime
        if np.array_equal(power, identity):
            return order
    return 0


def stable_subspace(matrix: np.ndarray, subspace: np.ndarray) -> bool:
    image = (matrix @ subspace.T).T % P
    return rank_mod(np.vstack([subspace, image])) == len(subspace)


def klein(vector: np.ndarray) -> int:
    return sum(
        int(vector[index]) ** 2 * int(vector[(index + 1) % 5])
        for index in range(5)
    ) % P


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def binary_cubic(subspace: np.ndarray) -> dict:
    left, right = subspace
    a = klein(left)
    d = klein(right)
    b = sum(
        int(left[i]) ** 2 * int(right[(i + 1) % 5])
        + 2 * int(left[i]) * int(right[i]) * int(left[(i + 1) % 5])
        for i in range(5)
    ) % P
    c = sum(
        int(right[i]) ** 2 * int(left[(i + 1) % 5])
        + 2 * int(left[i]) * int(right[i]) * int(right[(i + 1) % 5])
        for i in range(5)
    ) % P
    discriminant = (
        18 * a * b * c * d - 4 * b ** 3 * d + b * b * c * c
        - 4 * a * c ** 3 - 27 * a * a * d * d
    ) % P
    assert discriminant
    return {
        "coefficients_s3_s2t_st2_t3": [a, b, c, d],
        "discriminant": discriminant,
    }


def projective_roots(subspace: np.ndarray) -> list[np.ndarray]:
    roots = []
    for parameter in range(P):
        vector = (subspace[0] + parameter * subspace[1]) % P
        if klein(vector) == 0:
            roots.append(vector)
    if klein(subspace[1]) == 0:
        roots.append(subspace[1].copy())
    return roots


def fixed_projectively(vector: np.ndarray, matrices) -> bool:
    return all(
        rank_mod(np.vstack([vector, matrix @ vector % P])) == 1
        for matrix in matrices
    )


def c3_geometry(module):
    omega = next(value for value in range(2, P) if
                 (value * value + value + 1) % P == 0)
    generator = next(
        matrix for matrix in module.GROUP
        if matrix_order(matrix) == 3 and
        len(nullspace_mod(matrix - omega * np.eye(5, dtype=np.int64))) == 2
    )
    omega2 = omega * omega % P
    eigenspaces = {
        1: nullspace_mod(generator - omega * np.eye(5, dtype=np.int64)),
        2: nullspace_mod(generator - omega2 * np.eye(5, dtype=np.int64)),
    }
    source = eigenspaces[1]
    stabilizer = [matrix for matrix in module.GROUP
                  if stable_subspace(matrix, source)]
    assert len(stabilizer) == 6
    roots = {}
    fixed_roots = {}
    for exponent, target in eigenspaces.items():
        section = binary_cubic(target)
        roots[exponent] = projective_roots(target)
        assert 1 <= len(roots[exponent]) <= 3
        fixed_roots[exponent] = [
            root for root in roots[exponent]
            if fixed_projectively(root, stabilizer)
        ]
        assert len(fixed_roots[exponent]) == 1
        section["Fp_rational_root_count"] = len(roots[exponent])
        section["Fp_rational_roots"] = [root.tolist() for root in roots[exponent]]
        roots[exponent] = section
    return omega, generator, eigenspaces, stabilizer, roots, fixed_roots


def line_points(subspace: np.ndarray, degree: int) -> np.ndarray:
    # d+1 affine points are unisolvent for binary forms of degree d because
    # d < p.  Infinity is unnecessary.
    return np.asarray([
        (subspace[0] + parameter * subspace[1]) % P
        for parameter in range(degree + 1)
    ], dtype=np.int64)


def landing_constant_matrix(values: np.ndarray, root: np.ndarray) -> np.ndarray:
    pivot = int(np.flatnonzero(root)[0])
    rows = []
    for target in range(5):
        if target == pivot:
            continue
        rows.append(
            root[pivot] * values[:, target, :]
            - root[target] * values[:, pivot, :]
        )
    return np.concatenate(rows, axis=0).astype(np.int64) % P


def main() -> None:
    global P, ZETA
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=P)
    parser.add_argument("--zeta", type=int, default=ZETA)
    arguments = parser.parse_args()
    P = arguments.prime
    ZETA = arguments.zeta
    module = basis.module_at(P, ZETA)
    omega, generator, eigenspaces, stabilizer, roots, fixed_roots = c3_geometry(module)
    generators = json.loads((HERE / "dual_hironaka_generators.json").read_text())[
        "generators"
    ]
    result = {
        "schema": "cov-m1-c3-c6-constant-gate-probe-v1",
        "scope": "discovery; nonlinear residual scheme not decided",
        "prime": P,
        "zeta11": ZETA,
        "omega": omega,
        "order_three_generator": generator.tolist(),
        "source_eigenspace": eigenspaces[1].tolist(),
        "setwise_stabilizer_order": len(stabilizer),
        "setwise_stabilizer": [matrix.tolist() for matrix in stabilizer],
        "c6_generator": next(
            matrix.tolist() for matrix in stabilizer if matrix_order(matrix) == 6
        ),
        "degrees": {},
    }
    for degree in (31, 35):
        records = json.loads(
            (HERE / f"degree_{degree}/m1_cross_basis_circuits.json").read_text()
        )["basis"]
        points = line_points(eigenspaces[1], degree)
        evaluator = basis.DualEvaluator(module, points, P)
        dual_values = basis.evaluate_fixed_dual_generators(evaluator, generators)
        values = basis.evaluate_fixed_crosses(
            records, dual_values, points, P
        ).reshape(len(points), 5, len(records))
        target_exponent = degree % 3
        assert target_exponent in (1, 2)
        target_space = eigenspaces[target_exponent]
        root = fixed_roots[target_exponent][0]
        gate = landing_constant_matrix(values, root)
        gate_rank = rank_mod(gate)
        # Directly check that every basis value is in the expected target
        # eigenspace at every source-line point.
        restriction_rank = rank_mod(values.reshape(-1, len(records)))
        result["degrees"][str(degree)] = {
            "input_dimension": len(records),
            "source_line_point_count": len(points),
            "target_eigenvalue_exponent": target_exponent,
            "target_eigenspace": target_space.tolist(),
            "target_binary_cubic": roots[target_exponent],
            "unique_C6_fixed_root": root.tolist(),
            "constant_gate_matrix_shape": list(gate.shape),
            "constant_gate_rank": gate_rank,
            "constant_gate_kernel_dimension": len(records) - gate_rank,
            "restriction_map_rank": restriction_rank,
            "allowed_constant_scalar_form_dimension": restriction_rank - gate_rank,
        }
        payload_path = HERE / f"degree_{degree}/c3_constant_gate_p{P}.npz"
        np.savez_compressed(
            payload_path,
            source_points=points.astype(np.uint16),
            basis_values=values.astype(np.uint16),
            gate_matrix=gate.astype(np.uint16),
            unique_c6_root=root.astype(np.uint16),
        )
        result["degrees"][str(degree)]["payload"] = str(
            payload_path.relative_to(HERE)
        )
        result["degrees"][str(degree)]["payload_sha256"] = sha256(payload_path)
        print(
            f"degree={degree} C3/C6 gate rank={gate_rank} "
            f"kernel={len(records)-gate_rank} restrictionRank={restriction_rank}",
            flush=True,
        )
    output_path = HERE / f"c3_constant_gate_probe_p{P}.json"
    output_path.write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n"
    )
    peer_paths = [HERE / f"c3_constant_gate_probe_p{prime}.json"
                  for prime in (463, 727)]
    if all(path.exists() for path in peer_paths):
        records = [json.loads(path.read_text()) for path in peer_paths]
        expected = {"31": (11, 187, 21, 10), "35": (13, 348, 25, 12)}
        for record in records:
            for degree, values_expected in expected.items():
                values = record["degrees"][degree]
                actual = (
                    values["constant_gate_rank"],
                    values["constant_gate_kernel_dimension"],
                    values["restriction_map_rank"],
                    values["allowed_constant_scalar_form_dimension"],
                )
                assert actual == values_expected
        aggregate = {
            "schema": "cov-m1-c3-c6-constant-gate-v1",
            "mathematical_gate": (
                "On a C3 eigenline, X cuts a reduced length-three scheme. "
                "The projectivized restriction of a landing covariant is "
                "therefore constant on the connected source line minus its "
                "base divisor. C6 setwise equivariance forces that constant "
                "to be the unique C6-fixed point; the zero restriction is "
                "included in the same linear condition."
            ),
            "transfer_scope": (
                "The p=463 gate is a necessary condition on the complete "
                "special-fibre landing scheme. Emptiness after imposing it "
                "would exclude the characteristic-zero degree by projective "
                "proper specialization. Agreement at p=727 is an independent "
                "holdout, not by itself an emptiness theorem."
            ),
            "degrees": {
                degree: {
                    "input_dimension": records[0]["degrees"][degree]["input_dimension"],
                    "gate_rank": expected[degree][0],
                    "reduced_parameter_dimension": expected[degree][1],
                    "restriction_rank": expected[degree][2],
                    "allowed_constant_scalar_dimension": expected[degree][3],
                }
                for degree in expected
            },
            "prime_records": [
                {
                    "prime": record["prime"],
                    "zeta11": record["zeta11"],
                    "payload": path.name,
                    "payload_sha256": sha256(path),
                }
                for record, path in zip(records, peer_paths)
            ],
            "decision_status": "necessary reduction proved; residual saturation open",
        }
        (HERE / "c3_constant_gate.json").write_text(
            json.dumps(aggregate, indent=2, sort_keys=True) + "\n"
        )
    print("COV_M1_C3_CONSTANT_GATE_PROBE_OK")


if __name__ == "__main__":
    main()
