#!/usr/bin/env python3
"""Produce the kernel-aware degree-31 common-factor component I_6*K1_25.

The component is the image of

    P(I_6) x P(K1_25) = P^1 x P^58 -> P(K1_31)=P^197,
    ([a0:a1],[b]) |-> (a0*f6 + a1*f3^2) * q_b.

Its 198 x 2 x 59 multiplication tensor is rebuilt at p=419 and p=463 in
the installed literal K1 bases.  The flattened tensor has a seven-dimensional
kernel, so the incidence is retained through 118 auxiliary Segre coordinates;
no left inverse or linear quotient is used.

The output is a two-prime materialization of fixed characteristic-zero
arithmetic circuits.  It does not expand tensor entries in Q(zeta_11), does
not eliminate the auxiliary Segre variables, and does not decide the PC.2
landing subscheme inside K1_25.
"""

from __future__ import annotations

import hashlib
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
INVARIANT_PATH = WORK / "invariant_generators.json"
STRICT_MAPS = HERE / "pc3_p25_multiplier_maps.npz"
OUTPUT_NPZ = HERE / "pc3_d31_e6_factor_incidence.npz"
OUTPUT_JSON = HERE / "pc3_d31_e6_factor_incidence.json"

EXPECTED_HASHES = {
    DUAL_PATH: "b9aa1f8fe852e15b1b786b6a0577f06cf3ce200c5b092bcbd4c444678add874b",
    SOURCE_PATH: "73e6132e19105d4489d70093edf310c766051b90583536ba3b3fa85e223722b1",
    TARGET_PATH: "8adc3f91db76f97a47d1df6d3f9cccee9e8eef62a825c2dff045ad96db6ff2f6",
    INVARIANT_PATH: "1912db3e0c30c09d7485804adb03e9aeaed739076e2b87b8a2890007727c6421",
    STRICT_MAPS: "1821aa187af7573833bb132769e262af61858622657f7684116d104466451110",
}
PRIMES = {419: 13, 463: 15}
TARGET_DIMENSION = 198
FACTOR_DIMENSION = 2
LOWER_DIMENSION = 59
TENSOR_COLUMNS = FACTOR_DIMENSION * LOWER_DIMENSION


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


def rref(matrix: np.ndarray, prime: int) -> tuple[np.ndarray, list[int]]:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
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


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    return len(rref(matrix, prime)[1])


def inverse_mod(matrix: np.ndarray, prime: int) -> np.ndarray:
    matrix = np.asarray(matrix, dtype=np.int64) % prime
    size = len(matrix)
    augmented = np.hstack([matrix, np.eye(size, dtype=np.int64)])
    reduced, pivots = rref(augmented, prime)
    assert pivots[:size] == list(range(size))
    assert np.array_equal(reduced[:, :size], np.eye(size, dtype=np.int64))
    return reduced[:, size:]


def right_kernel(matrix: np.ndarray, prime: int) -> np.ndarray:
    reduced, pivots = rref(matrix, prime)
    free = [column for column in range(matrix.shape[1]) if column not in pivots]
    answer = np.zeros((matrix.shape[1], len(free)), dtype=np.int64)
    answer[free, np.arange(len(free))] = 1
    for row, pivot in enumerate(pivots):
        answer[pivot] = -reduced[row, free] % prime
    assert not np.any(np.asarray(matrix, dtype=np.int64) @ answer % prime)
    return answer


def independent_rows(matrix: np.ndarray, prime: int) -> tuple[int, ...]:
    return tuple(rref(np.asarray(matrix).T, prime)[1])


def determinant_mod(matrix: np.ndarray, prime: int) -> int:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    determinant = 1
    for column in range(len(value)):
        candidates = np.flatnonzero(value[column:, column])
        if not len(candidates):
            return 0
        pivot = column + int(candidates[0])
        if pivot != column:
            value[[column, pivot]] = value[[pivot, column]]
            determinant = -determinant
        entry = int(value[column, column])
        determinant = determinant * entry % prime
        inverse = pow(entry, -1, prime)
        for row in range(column + 1, len(value)):
            if value[row, column]:
                value[row] = (
                    value[row] - value[row, column] * inverse % prime * value[column]
                ) % prime
    return determinant % prime


def trim_polynomial(coefficients: list[int] | np.ndarray, prime: int) -> list[int]:
    result = [int(value) % prime for value in coefficients]
    while result and result[-1] == 0:
        result.pop()
    return result


def polynomial_divmod(
    numerator: list[int], denominator: list[int], prime: int
) -> tuple[list[int], list[int]]:
    numerator = trim_polynomial(numerator, prime)
    denominator = trim_polynomial(denominator, prime)
    assert denominator
    quotient = [0] * max(1, len(numerator) - len(denominator) + 1)
    while numerator and len(numerator) >= len(denominator):
        offset = len(numerator) - len(denominator)
        scale = numerator[-1] * pow(denominator[-1], -1, prime) % prime
        quotient[offset] = scale
        for index, coefficient in enumerate(denominator):
            numerator[index + offset] = (
                numerator[index + offset] - scale * coefficient
            ) % prime
        numerator = trim_polynomial(numerator, prime)
    return trim_polynomial(quotient, prime), numerator


def polynomial_gcd(left: list[int], right: list[int], prime: int) -> list[int]:
    left = trim_polynomial(left, prime)
    right = trim_polynomial(right, prime)
    while right:
        _, remainder = polynomial_divmod(left, right, prime)
        left, right = right, remainder
    if left:
        inverse = pow(left[-1], -1, prime)
        left = [coefficient * inverse % prime for coefficient in left]
    return left


def determinant_polynomial(
    first_leg: np.ndarray, second_leg: np.ndarray,
    rows: tuple[int, ...], prime: int,
) -> np.ndarray:
    # A 59x59 determinant of first_leg + t*second_leg has degree at most 59.
    samples = np.asarray([
        determinant_mod(
            (first_leg + parameter * second_leg)[list(rows)] % prime, prime
        )
        for parameter in range(60)
    ], dtype=np.int64)
    vandermonde = np.asarray(
        [[pow(parameter, exponent, prime) for exponent in range(60)]
         for parameter in range(60)],
        dtype=np.int64,
    )
    coefficients = inverse_mod(vandermonde, prime) @ samples % prime
    # Interpolation replay at points outside the selection grid.
    for parameter in (61, 73, 101):
        expected = determinant_mod(
            (first_leg + parameter * second_leg)[list(rows)] % prime, prime
        )
        actual = sum(
            int(coefficient) * pow(parameter, exponent, prime)
            for exponent, coefficient in enumerate(coefficients)
        ) % prime
        assert actual == expected
    return coefficients


def pencil_certificate(
    tensor: np.ndarray, prime: int,
    fixed_rows: list[tuple[int, ...]] | None,
) -> tuple[list[tuple[int, ...]], list[np.ndarray], list[int]]:
    first, second = tensor[:, 0, :], tensor[:, 1, :]
    assert rank_mod(first, prime) == rank_mod(second, prime) == 59
    if fixed_rows is None:
        candidates = []
        for parameter in range(20):
            rows = independent_rows((first + parameter * second) % prime, prime)
            assert len(rows) == 59
            if rows not in candidates:
                candidates.append(rows)
        fixed_rows = []
        gcd: list[int] = []
        polynomials = []
        for rows in candidates:
            polynomial = determinant_polynomial(first, second, rows, prime)
            coefficients = trim_polynomial(polynomial, prime)
            gcd = coefficients if not gcd else polynomial_gcd(gcd, coefficients, prime)
            fixed_rows.append(rows)
            polynomials.append(polynomial)
            if gcd == [1]:
                break
        assert gcd == [1]
    else:
        polynomials = [
            determinant_polynomial(first, second, rows, prime)
            for rows in fixed_rows
        ]
        gcd = []
        for polynomial in polynomials:
            coefficients = trim_polynomial(polynomial, prime)
            gcd = coefficients if not gcd else polynomial_gcd(gcd, coefficients, prime)
        assert gcd == [1]
    return fixed_rows, polynomials, gcd


def tangent_matrix(tensor: np.ndarray, prime: int) -> np.ndarray:
    # Affine chart a0=b0=1 at t=a1=2 and b_j=j+1.
    first, second = tensor[:, 0, :], tensor[:, 1, :]
    parameter = 2
    lower = np.arange(1, 60, dtype=np.int64) % prime
    value = (first @ lower + parameter * (second @ lower)) % prime
    derivative_parameter = second @ lower % prime
    derivative_lower = (first[:, 1:] + parameter * second[:, 1:]) % prime
    return np.column_stack([value, derivative_parameter, derivative_lower]) % prime


def main() -> None:
    for path, expected in EXPECTED_HASHES.items():
        assert sha256_file(path) == expected, path

    dual_records = json.loads(DUAL_PATH.read_text())["generators"]
    source_records = json.loads(SOURCE_PATH.read_text())["basis"]
    target_packet = json.loads(TARGET_PATH.read_text())
    factor_labels = cross.invariant_labels(6)
    assert factor_labels == [
        (0, (0, 0, 1, 0, 0)),  # f6
        (0, (2, 0, 0, 0, 0)),  # f3^2
    ]
    points = cross.fixed_points(80)
    assert np.array_equal(
        np.asarray(target_packet["fixed_evaluation_points"], dtype=np.int64), points
    )

    arrays: dict[str, np.ndarray] = {
        "fixed_evaluation_points": points.astype(np.uint16),
    }
    prime_records = []
    fixed_pencil_rows = None
    fixed_tangent_rows = None
    with np.load(STRICT_MAPS, allow_pickle=False) as strict_packet:
        for prime, zeta in PRIMES.items():
            print(f"p={prime}: building I6 x K1_25 -> K1_31 tensor", flush=True)
            module = cross.module_at(prime, zeta)
            evaluator = cross.DualEvaluator(module, points % prime, prime)
            dual_values = cross.evaluate_fixed_dual_generators(evaluator, dual_records)
            source_values = cross.evaluate_fixed_crosses(
                source_records, dual_values, points % prime, prime
            )
            target_values = cross.evaluate_fixed_crosses(
                target_packet["basis"], dual_values, points % prime, prime
            )
            assert rank_mod(source_values, prime) == 59
            assert rank_mod(target_values, prime) == 198
            target_rows = np.asarray(
                target_packet["fixed_maximal_minor_rows"], dtype=np.int64
            )
            target_inverse = inverse_mod(target_values[target_rows], prime)

            legs = []
            evaluation_residuals = []
            for label in factor_labels:
                scalar = cross.evaluate_polynomial(
                    cross.invariant_polynomial(label), points % prime, prime
                )
                product = (
                    source_values.reshape(len(points), 5, 59)
                    * scalar[:, None, None]
                ).reshape(-1, 59) % prime
                leg = target_inverse @ product[target_rows] % prime
                residual = target_values @ leg % prime - product
                residual %= prime
                assert not np.any(residual)
                assert rank_mod(leg, prime) == 59
                legs.append(leg)
                evaluation_residuals.append(int(np.count_nonzero(residual)))
            tensor = np.stack(legs, axis=1) % prime
            flattened = tensor.reshape(TARGET_DIMENSION, TENSOR_COLUMNS)
            assert rank_mod(flattened, prime) == 111
            kernel = right_kernel(flattened, prime)
            assert kernel.shape == (118, 7)

            # The first invariant is f6.  Its restriction to the fixed strict
            # inclusion must reproduce the separately built PC.3 map.
            inclusion = strict_packet[f"strict_inclusion_p{prime}"].astype(np.int64)
            strict_f6 = strict_packet[
                f"strict_multiplier_map_d31_p{prime}"
            ].astype(np.int64)
            assert np.array_equal(tensor[:, 0, :] @ inclusion % prime, strict_f6)

            fixed_pencil_rows, determinant_polynomials, gcd = pencil_certificate(
                tensor, prime, fixed_pencil_rows
            )
            assert gcd == [1]
            tangent = tangent_matrix(tensor, prime)
            assert rank_mod(tangent, prime) == 60
            if fixed_tangent_rows is None:
                fixed_tangent_rows = independent_rows(tangent, prime)
                assert len(fixed_tangent_rows) == 60
            assert rank_mod(tangent[list(fixed_tangent_rows)], prime) == 60

            arrays[f"tensor_p{prime}"] = tensor.astype(np.uint16)
            arrays[f"flattened_kernel_p{prime}"] = kernel.astype(np.uint16)
            arrays[f"tangent_matrix_p{prime}"] = tangent.astype(np.uint16)
            for index, polynomial in enumerate(determinant_polynomials):
                arrays[f"pencil_minor_{index}_coefficients_p{prime}"] = (
                    polynomial.astype(np.uint16)
                )
            prime_records.append({
                "prime": prime,
                "zeta11": zeta,
                "source_rank": rank_mod(source_values, prime),
                "target_rank": rank_mod(target_values, prime),
                "leg_ranks": [rank_mod(leg, prime) for leg in legs],
                "flattened_shape": [198, 118],
                "flattened_rank": rank_mod(flattened, prime),
                "flattened_kernel_dimension": kernel.shape[1],
                "flattened_kernel_sha256": sha256_array(kernel.astype(np.uint16)),
                "tensor_sha256": sha256_array(tensor.astype(np.uint16)),
                "all_400_row_residual_nonzeros": evaluation_residuals,
                "pencil_minor_degrees": [
                    len(trim_polynomial(polynomial, prime)) - 1
                    for polynomial in determinant_polynomials
                ],
                "pencil_maximal_minor_gcd": gcd,
                "pencil_infinity_rank": rank_mod(tensor[:, 1, :], prime),
                "strict_f6_map_crosscheck": True,
                "projective_tangent_augmented_rank": rank_mod(tangent, prime),
            })

    assert fixed_pencil_rows is not None and len(fixed_pencil_rows) >= 2
    assert fixed_tangent_rows is not None
    arrays["pencil_minor_rows"] = np.asarray(fixed_pencil_rows, dtype=np.uint16)
    arrays["tangent_minor_rows"] = np.asarray(fixed_tangent_rows, dtype=np.uint16)
    np.savez_compressed(OUTPUT_NPZ, **arrays)

    payload = {
        "schema": "pc3-d31-e6-common-factor-incidence-v1",
        "field": "K=Q(zeta_11), Phi_11(zeta_11)=0",
        "input_hashes": {
            str(path.relative_to(ROOT)): digest for path, digest in EXPECTED_HASHES.items()
        },
        "component": {
            "target": "P(K1_31)=P^197",
            "domain": "P(I_6) x P(K1_25)=P^1 x P^58",
            "factor_basis": [cross.invariant_json(label) for label in factor_labels],
            "factor_basis_names": ["f6", "f3^2"],
            "lower_basis": str(SOURCE_PATH.relative_to(ROOT)),
            "target_basis": str(TARGET_PATH.relative_to(ROOT)),
            "map": "([a0:a1],[b]) -> [(a0*f6+a1*f3^2) q_b]",
            "exact_no_basepoint_proof": (
                "The polynomial ring over Q(zeta_11) is a domain. Every nonzero "
                "h=a0*f6+a1*f3^2 and nonzero covariant q have h*q nonzero."
            ),
            "projective_image_dimension": 59,
            "dimension_proof": (
                "The domain has dimension 59. The fixed augmented value/Jacobian "
                "minor has rank 60 after good reduction at p=419 (and at p=463), "
                "so the projective differential has rank 59 in characteristic zero."
            ),
        },
        "kernel_aware_graph": {
            "target_variables": 198,
            "auxiliary_segre_variables": 118,
            "auxiliary_index": "z_(a,b), a=0,1 and b=0,...,58",
            "segree_equations": (
                "z_(0,b) z_(1,c) - z_(0,c) z_(1,b) = 0 for 0<=b<c<59"
            ),
            "segree_equation_count": 1711,
            "graph_equations": "y_k - sum_(a,b) T_(k,a,b) z_(a,b) = 0, k=0,...,197",
            "graph_equation_count": 198,
            "target_image_ideal": (
                "Eliminate all z_(a,b) from the homogeneous graph ideal generated "
                "by the 1711 Segre quadrics and 198 displayed linear equations."
            ),
            "why_auxiliaries_are_required": (
                "The 198x118 flattening has rank 111 and kernel dimension 7. "
                "There is no left inverse, while the gcd-one pencil certificate "
                "shows that this kernel contains no decomposable Segre point."
            ),
            "pencil_minor_rows": [list(rows) for rows in fixed_pencil_rows],
            "tangent_minor_rows": list(fixed_tangent_rows),
        },
        "prime_records": prime_records,
        "artifact": OUTPUT_NPZ.name,
        "artifact_sha256": sha256_file(OUTPUT_NPZ),
        "scope": {
            "proved_component": (
                "A replayable kernel-aware graph for the degree-6 invariant-factor "
                "component of the literal degree-31 common-factor locus, with two-prime "
                "tensor identities, kernel dimensions, basepoint exclusion, and image "
                "dimension."
            ),
            "not_yet_full_union": (
                "The other factor degrees 3,5,7,8,9,10,11,12,13,14 are not "
                "materialized in this artifact, so PC-FACTOR-INCIDENCE-PASS is not issued."
            ),
            "pc2_dependency": (
                "Inside the degree-31 landing scheme, this component pulls back to the "
                "authoritative PC.2 landing scheme in the b variables because "
                "F(hq)=h^3 F(q). That nonlinear lower ideal remains unresolved."
            ),
            "char0_boundary": (
                "The exact circuit and nonzero-minor consequences are fixed, but the "
                "stored tensor entries are only their p=419 and p=463 reductions; no "
                "entrywise Q(zeta_11) tensor or target-only eliminated ideal is claimed."
            ),
        },
    }
    OUTPUT_JSON.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PC3_D31_E6_FACTOR_INCIDENCE_PRODUCED", flush=True)


if __name__ == "__main__":
    main()
