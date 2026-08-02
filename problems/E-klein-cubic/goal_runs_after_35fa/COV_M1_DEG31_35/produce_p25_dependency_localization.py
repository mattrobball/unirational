#!/usr/bin/env python3
"""Localize the degree-25 multiplier dependency inside the C3 gate tree.

The fixed degree-25 K1 basis is selected once from characteristic-zero
Reynolds circuits.  At each holdout prime we multiply it by f6 and f10,
express the results in the fixed degree-31 and degree-35 K1 bases, and record
the exact preimage dimensions of the successive based Taylor gates.

This is a linear localization of the shared P25.2 dependency.  It does not
decide the nonlinear degree-25 landing scheme or any remaining affine chart.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np

import produce_cross_basis as base
import produce_primitive_module as primitive
from probe_c3_constant_gate import rank_mod


HERE = Path(__file__).resolve().parent
PRIMES = {463: 15, 727: 46}
TARGETS = {31: 198, 35: 361}
MULTIPLIERS = {
    31: (0, (0, 0, 1, 0, 0)),  # primary f6
    35: (3, (0, 0, 0, 0, 0)),  # secondary f10
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def inverse_mod(matrix: np.ndarray, prime: int) -> np.ndarray:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    assert value.shape[0] == value.shape[1]
    inverse = np.eye(len(value), dtype=np.int64)
    for column in range(len(value)):
        candidates = np.flatnonzero(value[column:, column])
        assert len(candidates)
        pivot = column + int(candidates[0])
        value[[column, pivot]] = value[[pivot, column]]
        inverse[[column, pivot]] = inverse[[pivot, column]]
        scale = pow(int(value[column, column]), -1, prime)
        value[column] = value[column] * scale % prime
        inverse[column] = inverse[column] * scale % prime
        rows = np.flatnonzero(value[:, column])
        rows = rows[rows != column]
        if len(rows):
            factors = value[rows, column].copy()
            value[rows] = (value[rows] - factors[:, None] * value[column]) % prime
            inverse[rows] = (
                inverse[rows] - factors[:, None] * inverse[column]
            ) % prime
    assert np.array_equal(value, np.eye(len(value), dtype=np.int64))
    return inverse


def independent_rows(matrix: np.ndarray, dimension: int, prime: int) -> np.ndarray:
    selected = []
    current = np.empty((0, matrix.shape[1]), dtype=np.int64)
    for index, row in enumerate(matrix):
        candidate = np.vstack([current, row])
        if rank_mod(candidate, prime) > len(selected):
            selected.append(index)
            current = candidate
            if len(selected) == dimension:
                break
    assert len(selected) == dimension
    return np.asarray(selected, dtype=np.int64)


def first_paths(degree: int, prime: int) -> list[Path]:
    paths = [HERE / f"degree_{degree}/c3_first_normal_exp0_p{prime}.npz"]
    if degree == 31:
        paths.append(HERE / f"degree_31/c3_first_normal_exp2_p{prime}.npz")
    else:
        paths.extend([
            HERE / f"degree_35/c3_first_normal_exp2_dir0_p{prime}.npz",
            HERE / f"degree_35/c3_first_normal_exp2_dir1_p{prime}.npz",
        ])
    return paths


def hierarchy(degree: int, dimension: int, prime: int) -> list[tuple[str, np.ndarray]]:
    with np.load(
        HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        allowed = frozen["gate_matrix"].astype(np.int64) % prime
        based = frozen["basis_values"].astype(np.int64).reshape(-1, dimension) % prime
    result = [("c3_allowed", allowed), ("c3_based", based)]
    parts = [based]
    for path in first_paths(degree, prime):
        with np.load(path, allow_pickle=False) as frozen:
            parts.append(
                frozen["derivative_values"].astype(np.int64).reshape(-1, dimension)
                % prime
            )
    result.append(("first_based", np.concatenate(parts)))
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            parts.append(
                frozen["second_normal_values"].astype(np.int64).reshape(-1, dimension)
                % prime
            )
    result.append(("pure_second_based", np.concatenate(parts)))
    with np.load(
        HERE / f"degree_{degree}/c3_second_mixed_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        parts.append(
            frozen["mixed_second_values"].astype(np.int64).reshape(-1, dimension)
            % prime
        )
    result.append(("third_based", np.concatenate(parts)))
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_{degree}/c3_third_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            parts.append(
                frozen["third_normal_values"].astype(np.int64).reshape(-1, dimension)
                % prime
            )
    result.append(("pure_third_scalar_zero", np.concatenate(parts)))
    return result


def main() -> None:
    generator_path = HERE / "dual_hironaka_generators.json"
    generators = json.loads(generator_path.read_text())["generators"]
    points = base.fixed_points(80)

    # Select the fixed circuit basis once at the first holdout prime.
    module = base.module_at(463, PRIMES[463])
    evaluator = base.DualEvaluator(module, points % 463, 463)
    values = base.evaluate_fixed_dual_generators(evaluator, generators)
    rank, lower_basis, candidate_count = primitive.scan_degree(
        25, generators, values, points % 463, 463
    )
    assert rank == len(lower_basis) == 59
    basis_path = HERE / "degree_25_fixed_k1_basis.json"
    basis_path.write_text(json.dumps({
        "schema": "cov-m1-fixed-degree25-k1-circuits-v1",
        "degree": 25,
        "dimension": 59,
        "candidate_count": candidate_count,
        "basis": lower_basis,
    }, indent=2, sort_keys=True) + "\n")

    prime_records = []
    expected = {
        31: [51, 46, 18, 0, 0, 0],
        35: [59, 59, 46, 38, 18, 10],
    }
    for prime, zeta in PRIMES.items():
        print(f"p={prime}: evaluating fixed degree-25 and target bases", flush=True)
        module = base.module_at(prime, zeta)
        evaluator = base.DualEvaluator(module, points % prime, prime)
        values = base.evaluate_fixed_dual_generators(evaluator, generators)
        lower_values = np.column_stack([
            primitive.fixed_direction_value(record, values, points % prime, prime)
            .reshape(-1)
            for record in lower_basis
        ])
        assert rank_mod(lower_values, prime) == 59
        degree_records = {}
        for degree, dimension in TARGETS.items():
            target_basis = json.loads(
                (HERE / f"degree_{degree}/m1_cross_basis_circuits.json").read_text()
            )["basis"]
            target_values = np.column_stack([
                primitive.fixed_direction_value(record, values, points % prime, prime)
                .reshape(-1)
                for record in target_basis
            ])
            assert rank_mod(target_values, prime) == dimension
            rows = independent_rows(target_values, dimension, prime)
            scalar = base.evaluate_polynomial(
                base.invariant_polynomial(MULTIPLIERS[degree]), points % prime, prime
            )
            multiplied = (
                lower_values.reshape(len(points), 5, 59)
                * scalar[:, None, None]
            ).reshape(-1, 59) % prime
            embedding = (
                inverse_mod(target_values[rows], prime) @ multiplied[rows]
            ) % prime
            assert np.array_equal(target_values @ embedding % prime, multiplied)
            assert rank_mod(embedding, prime) == 59
            stages = []
            for name, gate in hierarchy(degree, dimension, prime):
                gate_rank = rank_mod(gate @ embedding % prime, prime)
                stages.append({
                    "stage": name,
                    "restricted_gate_rank": gate_rank,
                    "degree25_preimage_dimension": 59 - gate_rank,
                })
            actual = [record["degree25_preimage_dimension"] for record in stages]
            assert actual == expected[degree], (prime, degree, actual)
            payload_path = (
                HERE / f"degree_{degree}/p25_multiplier_embedding_p{prime}.npz"
            )
            np.savez_compressed(
                payload_path,
                fixed_evaluation_points=points.astype(np.uint16),
                target_basis_minor_rows=rows.astype(np.uint16),
                multiplier_values=scalar.astype(np.uint16),
                multiplier_embedding=embedding.astype(np.uint16),
            )
            degree_records[str(degree)] = {
                "multiplier": "f6" if degree == 31 else "f10",
                "target_dimension": dimension,
                "embedding_rank": 59,
                "payload": str(payload_path.relative_to(HERE)),
                "payload_sha256": sha256(payload_path),
                "stages": stages,
            }
            print(f"p={prime} d={degree}: preimages {actual}", flush=True)
        prime_records.append({
            "prime": prime,
            "zeta11": zeta,
            "degree25_basis_rank": 59,
            "degrees": degree_records,
        })

    output = HERE / "p25_dependency_localization.json"
    output.write_text(json.dumps({
        "schema": "cov-m1-p25-dependency-localization-v1",
        "degree25_basis": basis_path.name,
        "degree25_basis_sha256": sha256(basis_path),
        "dual_generators_sha256": sha256(generator_path),
        "prime_records": prime_records,
        "scope": (
            "exact two-prime fixed-circuit linear localization of the f6 and "
            "f10 images of K1_25 inside the necessary C3 Taylor gate tree; "
            "the displayed fibre dimensions are characteristic-zero upper "
            "bounds by their nonzero fixed minors, but this neither decides "
            "the P25.2 landing scheme nor closes an affine chart"
        ),
        "conclusion": (
            "The f6 image has zero characteristic-zero intersection with the "
            "degree-31 pure-second based branch, so P25.2 can only enter "
            "earlier degree-31 nonbased covers.  The f10 image has fibre "
            "preimage dimensions 59,59,46,38,18,10 through the displayed "
            "degree-35 based stages, giving the same characteristic-zero "
            "upper bounds."
        ),
    }, indent=2, sort_keys=True) + "\n")
    print("COV_M1_P25_DEPENDENCY_LOCALIZATION_OK")


if __name__ == "__main__":
    main()
