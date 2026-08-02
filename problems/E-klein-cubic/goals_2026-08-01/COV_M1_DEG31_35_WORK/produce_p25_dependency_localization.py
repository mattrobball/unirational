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
    allowed_parts = [based]
    zero_parts = [based]
    for path in first_paths(degree, prime):
        with np.load(path, allow_pickle=False) as frozen:
            allowed_parts.append(frozen["extra_gate_matrix"].astype(np.int64) % prime)
            zero_parts.append(
                frozen["derivative_values"].astype(np.int64).reshape(-1, dimension)
                % prime
            )
    result.append(("first_normal_allowed", np.concatenate(allowed_parts)))
    result.append(("second_based", np.concatenate(zero_parts)))
    pure_allowed_parts = list(zero_parts)
    pure_zero_parts = list(zero_parts)
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            pure_allowed_parts.append(
                frozen["extra_gate_matrix"].astype(np.int64) % prime
            )
            pure_zero_parts.append(
                frozen["second_normal_values"].astype(np.int64).reshape(-1, dimension)
                % prime
            )
    result.append(("pure_second_allowed", np.concatenate(pure_allowed_parts)))
    pure_zero = np.concatenate(pure_zero_parts)
    result.append(("pure_second_scalar_zero", pure_zero))
    with np.load(
        HERE / f"degree_{degree}/c3_second_mixed_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        mixed_gate = frozen["extra_gate_matrix"].astype(np.int64) % prime
        mixed_values = (
            frozen["mixed_second_values"].astype(np.int64).reshape(-1, dimension)
            % prime
        )
    result.append(("mixed_second_allowed", np.concatenate([pure_zero, mixed_gate])))
    third_based = np.concatenate([pure_zero, mixed_values])
    result.append(("third_based", third_based))
    third_allowed_parts = [third_based]
    third_zero_parts = [third_based]
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_{degree}/c3_third_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            third_allowed_parts.append(
                frozen["extra_gate_matrix"].astype(np.int64) % prime
            )
            third_zero_parts.append(
                frozen["third_normal_values"].astype(np.int64).reshape(-1, dimension)
                % prime
            )
    result.append(("pure_third_allowed", np.concatenate(third_allowed_parts)))
    pure_third_zero = np.concatenate(third_zero_parts)
    result.append(("pure_third_scalar_zero", pure_third_zero))
    if degree == 35:
        with np.load(
            HERE / f"degree_35/c3_third_mixed_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            b1_values = frozen["b1_values"].astype(np.int64).reshape(-1, dimension) % prime
            b1_gate = frozen["b1_extra_gate_matrix"].astype(np.int64) % prime
            b2_values = frozen["b2_values"].astype(np.int64).reshape(-1, dimension) % prime
            b2_gate = frozen["b2_extra_gate_matrix"].astype(np.int64) % prime
        result.append((
            "third_mixed_b1_allowed", np.concatenate([pure_third_zero, b1_gate])
        ))
        b1_zero = np.concatenate([pure_third_zero, b1_values])
        result.append(("third_mixed_b1_scalar_zero", b1_zero))
        result.append((
            "third_mixed_b2_allowed", np.concatenate([b1_zero, b2_gate])
        ))
        fifth_based = np.concatenate([pure_third_zero, b1_values, b2_values])
        result.append(("fifth_based", fifth_based))
        fourth_allowed_parts = [fifth_based]
        fourth_zero_parts = [fifth_based]
        for exponent in (0, 2):
            with np.load(
                HERE / f"degree_35/c3_fourth_normal_exp{exponent}_p{prime}.npz",
                allow_pickle=False,
            ) as frozen:
                fourth_allowed_parts.append(
                    frozen["extra_gate_matrix"].astype(np.int64) % prime
                )
                fourth_zero_parts.append(
                    frozen["fourth_normal_values"].astype(np.int64).reshape(
                        -1, dimension
                    ) % prime
                )
        result.append(("fourth_pure_allowed", np.concatenate(fourth_allowed_parts)))
        fourth_zero = np.concatenate(fourth_zero_parts)
        result.append(("fourth_pure_scalar_zero", fourth_zero))
        with np.load(
            HERE / f"degree_35/c3_fourth_mixed_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            q1_values = frozen["b1_values"].astype(np.int64).reshape(-1, dimension) % prime
            q2_values = frozen["b2_values"].astype(np.int64).reshape(-1, dimension) % prime
            q2_gate = frozen["b2_extra_gate_matrix"].astype(np.int64) % prime
        q1_zero = np.concatenate([fourth_zero, q1_values])
        result.append(("fourth_mixed_b1_zero", q1_zero))
        result.append((
            "fourth_mixed_b2_allowed", np.concatenate([q1_zero, q2_gate])
        ))
        result.append((
            "fourth_mixed_b2_scalar_zero", np.concatenate([q1_zero, q2_values])
        ))
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
        31: [51, 46, 27, 18, 3, 0, 0, 0, 0, 0],
        35: [59, 59, 51, 46, 38, 38, 27, 18, 13, 10,
             1, 1, 0, 0, 0, 0, 0, 0, 0],
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
            "degree-31 pure-second scalar-zero branch: its only possible "
            "degree-31 nonbased orders are C3-constant, first-normal, and "
            "pure-second.  The f10 image can enter only the degree-35 "
            "first-normal, mixed-second, and pure-third nonbased orders and "
            "has zero intersection with the fifth-based/fourth-order tree."
        ),
    }, indent=2, sort_keys=True) + "\n")
    print("COV_M1_P25_DEPENDENCY_LOCALIZATION_OK")


if __name__ == "__main__":
    main()
