#!/usr/bin/env python3
"""Produce the degree-31 factor subunion with lower factor in installed K1.

For each e in {3,5,6,7,8,9,10,11,12,13,14}, this constructs the literal
multiplication tensor

    I_e tensor K1_(31-e) -> K1_31

in fixed Reynolds/cross circuit bases at p=419 and p=463.  Each projective
image is represented by its auxiliary Segre graph

    z in Segre(P(I_e) x P(K1_(31-e))),  y = T_e z.

This remains valid for e=6, where the flattened tensor has a seven-dimensional
kernel.  No component is replaced by its linear span and no module quotient
is formed.

Equivariance makes the gcd invariant, but division by that invariant yields
an arbitrary lower equivariant covariant, not necessarily a lower K1 vector.
Thus this packet is a certified closed subunion, not the exhaustive common-
factor locus.  Invariant factors that themselves vanish on the involution
arrangement give additional components; the named-word audit exhibits them.

Stored entries are two finite-field reductions of exact arithmetic circuits.
Target-only elimination ideals and entrywise Q(zeta_11) tensors are not
materialized here.
"""

from __future__ import annotations

from math import comb
import hashlib
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
WORK = ROOT / "goals_2026-08-01" / "COV_M1_DEG31_35_WORK"
DUAL_PATH = WORK / "dual_hironaka_generators.json"
TARGET_PATH = WORK / "degree_31" / "m1_cross_basis_circuits.json"
INVARIANT_PATH = WORK / "invariant_generators.json"
E6_PACKET = HERE / "pc3_d31_e6_factor_incidence.json"
OUTPUT_NPZ = HERE / "pc3_d31_common_factor_union.npz"
OUTPUT_JSON = HERE / "pc3_d31_common_factor_union.json"

PRIMES = {419: 13, 463: 15}
FACTOR_SPECS = {
    3: (28, 1, 115),
    5: (26, 1, 75),
    6: (25, 2, 59),
    7: (24, 1, 44),
    8: (23, 2, 34),
    9: (22, 3, 25),
    10: (21, 3, 16),
    11: (20, 4, 11),
    12: (19, 6, 7),
    13: (18, 5, 3),
    14: (17, 8, 2),
}
EXPECTED_FLATTENED_RANKS = {
    3: 115,
    5: 75,
    6: 111,
    7: 44,
    8: 68,
    9: 75,
    10: 48,
    11: 44,
    12: 42,
    13: 15,
    14: 16,
}
EXPECTED_HASHES = {
    DUAL_PATH: "b9aa1f8fe852e15b1b786b6a0577f06cf3ce200c5b092bcbd4c444678add874b",
    TARGET_PATH: "8adc3f91db76f97a47d1df6d3f9cccee9e8eef62a825c2dff045ad96db6ff2f6",
    INVARIANT_PATH: "1912db3e0c30c09d7485804adb03e9aeaed739076e2b87b8a2890007727c6421",
}


sys.path.insert(0, str(WORK))
import produce_cross_basis as cross  # noqa: E402
import produce_primitive_module as primitive  # noqa: E402


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
    reduced, pivots = rref(
        np.hstack([matrix, np.eye(size, dtype=np.int64)]), prime
    )
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


def fixed_direction_matrix(
    records: list[dict], dual_values: np.ndarray,
    points: np.ndarray, prime: int,
) -> np.ndarray:
    return np.column_stack([
        primitive.fixed_direction_value(record, dual_values, points, prime).reshape(-1)
        for record in records
    ])


def tangent_matrix(tensor: np.ndarray, prime: int) -> np.ndarray:
    target, factor_dimension, lower_dimension = tensor.shape
    factor = np.arange(1, factor_dimension + 1, dtype=np.int64) % prime
    lower = np.arange(1, lower_dimension + 1, dtype=np.int64) % prime
    value = np.einsum("kab,a,b->k", tensor, factor, lower) % prime
    factor_derivatives = np.column_stack([
        np.einsum("kb,b->k", tensor[:, index, :], lower) % prime
        for index in range(1, factor_dimension)
    ]) if factor_dimension > 1 else np.empty((target, 0), dtype=np.int64)
    lower_derivatives = np.column_stack([
        np.einsum("ka,a->k", tensor[:, :, index], factor) % prime
        for index in range(1, lower_dimension)
    ]) if lower_dimension > 1 else np.empty((target, 0), dtype=np.int64)
    return np.column_stack([value, factor_derivatives, lower_derivatives]) % prime


def graph_samples(tensor: np.ndarray, prime: int) -> int:
    target_dimension, factor_dimension, lower_dimension = tensor.shape
    for sample in range(3):
        factor = np.asarray(
            [1] + [((sample + 2) * (index + 3) + 1) % prime
                   for index in range(factor_dimension - 1)],
            dtype=np.int64,
        )
        lower = np.asarray(
            [1] + [((sample + 5) * (index + 7) + 2) % prime
                   for index in range(lower_dimension - 1)],
            dtype=np.int64,
        )
        z = np.outer(factor, lower) % prime
        # Full Segre replay, including the large e=6 component.
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
    for path, expected in EXPECTED_HASHES.items():
        assert sha256_file(path) == expected, path
    assert E6_PACKET.is_file()

    generators = json.loads(DUAL_PATH.read_text())["generators"]
    target_packet = json.loads(TARGET_PATH.read_text())
    points = cross.fixed_points(80)
    assert np.array_equal(
        np.asarray(target_packet["fixed_evaluation_points"], dtype=np.int64), points
    )

    # Select every lower fixed circuit basis once at p=419.  The second prime
    # evaluates these exact same records; it never changes the bases.
    selection_module = cross.module_at(419, PRIMES[419])
    selection_evaluator = cross.DualEvaluator(selection_module, points % 419, 419)
    selection_dual = cross.evaluate_fixed_dual_generators(
        selection_evaluator, generators
    )
    lower_bases = {}
    candidate_counts = {}
    for factor_degree, (lower_degree, _, expected_dimension) in FACTOR_SPECS.items():
        actual, selected, candidate_count = primitive.scan_degree(
            lower_degree, generators, selection_dual, points % 419, 419
        )
        assert actual == len(selected) == expected_dimension
        lower_bases[factor_degree] = selected
        candidate_counts[factor_degree] = candidate_count

    # Cross circuits have minimal degree 17.  This is the installed zero
    # ledger which removes factor degrees >=15 from the degree-31 union.
    zero_ledger = {}
    for degree in range(17):
        actual, selected, candidate_count = primitive.scan_degree(
            degree, generators, selection_dual, points % 419, 419
        )
        assert actual == len(selected) == candidate_count == 0
        zero_ledger[str(degree)] = 0

    arrays: dict[str, np.ndarray] = {
        "fixed_evaluation_points": points.astype(np.uint16),
    }
    prime_records = []
    fixed_tangent_rows = {}
    component_metadata = {}
    for factor_degree, (lower_degree, factor_dimension, lower_dimension) in FACTOR_SPECS.items():
        labels = cross.invariant_labels(factor_degree)
        assert len(labels) == factor_dimension
        component_metadata[str(factor_degree)] = {
            "factor_degree": factor_degree,
            "lower_degree": lower_degree,
            "factor_dimension": factor_dimension,
            "lower_dimension": lower_dimension,
            "tensor_columns": factor_dimension * lower_dimension,
            "factor_basis": [cross.invariant_json(label) for label in labels],
            "lower_basis_circuits": lower_bases[factor_degree],
            "lower_candidate_count": candidate_counts[factor_degree],
            "domain": f"P^{factor_dimension - 1} x P^{lower_dimension - 1}",
            "domain_dimension": factor_dimension + lower_dimension - 2,
            "auxiliary_segre_variables": factor_dimension * lower_dimension,
            "segree_quadrics": comb(factor_dimension, 2) * comb(lower_dimension, 2),
            "graph_linear_equations": 198,
            "target_image_ideal_status": "defined by elimination of z; not materialized",
        }

    for prime, zeta in PRIMES.items():
        print(f"p={prime}: rebuilding all degree-31 factor tensors", flush=True)
        module = cross.module_at(prime, zeta)
        evaluator = cross.DualEvaluator(module, points % prime, prime)
        dual_values = cross.evaluate_fixed_dual_generators(evaluator, generators)
        target_values = cross.evaluate_fixed_crosses(
            target_packet["basis"], dual_values, points % prime, prime
        )
        assert rank_mod(target_values, prime) == 198
        target_rows = np.asarray(
            target_packet["fixed_maximal_minor_rows"], dtype=np.int64
        )
        target_inverse = inverse_mod(target_values[target_rows], prime)
        components = {}
        for factor_degree, (lower_degree, factor_dimension, lower_dimension) in FACTOR_SPECS.items():
            labels = cross.invariant_labels(factor_degree)
            lower_values = fixed_direction_matrix(
                lower_bases[factor_degree], dual_values, points % prime, prime
            )
            assert lower_values.shape == (400, lower_dimension)
            assert rank_mod(lower_values, prime) == lower_dimension
            legs = []
            residual_nonzeros = []
            for label in labels:
                scalar = cross.evaluate_polynomial(
                    cross.invariant_polynomial(label), points % prime, prime
                )
                product = (
                    lower_values.reshape(80, 5, lower_dimension)
                    * scalar[:, None, None]
                ).reshape(400, lower_dimension) % prime
                leg = target_inverse @ product[target_rows] % prime
                residual = target_values @ leg % prime - product
                residual %= prime
                assert not np.any(residual)
                assert rank_mod(leg, prime) == lower_dimension
                legs.append(leg)
                residual_nonzeros.append(int(np.count_nonzero(residual)))
            tensor = np.stack(legs, axis=1) % prime
            flattened = tensor.reshape(198, factor_dimension * lower_dimension)
            expected_rank = EXPECTED_FLATTENED_RANKS[factor_degree]
            assert rank_mod(flattened, prime) == expected_rank
            kernel = right_kernel(flattened, prime)
            assert kernel.shape[1] == factor_dimension * lower_dimension - expected_rank
            tangent = tangent_matrix(tensor, prime)
            expected_tangent_rank = factor_dimension + lower_dimension - 1
            assert rank_mod(tangent, prime) == expected_tangent_rank
            if factor_degree not in fixed_tangent_rows:
                fixed_tangent_rows[factor_degree] = independent_rows(tangent, prime)
            assert len(fixed_tangent_rows[factor_degree]) == expected_tangent_rank
            assert rank_mod(
                tangent[list(fixed_tangent_rows[factor_degree])], prime
            ) == expected_tangent_rank
            sample_count = graph_samples(tensor, prime)

            arrays[f"tensor_e{factor_degree}_p{prime}"] = tensor.astype(np.uint16)
            arrays[f"kernel_e{factor_degree}_p{prime}"] = kernel.astype(np.uint16)
            arrays[f"tangent_e{factor_degree}_p{prime}"] = tangent.astype(np.uint16)
            components[str(factor_degree)] = {
                "lower_degree": lower_degree,
                "factor_dimension": factor_dimension,
                "lower_dimension": lower_dimension,
                "lower_rank": rank_mod(lower_values, prime),
                "leg_ranks": [rank_mod(leg, prime) for leg in legs],
                "flattened_rank": rank_mod(flattened, prime),
                "flattened_kernel_dimension": kernel.shape[1],
                "tensor_sha256": sha256_array(tensor.astype(np.uint16)),
                "kernel_sha256": sha256_array(kernel.astype(np.uint16)),
                "all_400_row_residual_nonzeros": residual_nonzeros,
                "projective_tangent_augmented_rank": rank_mod(tangent, prime),
                "graph_samples_checked": sample_count,
            }
            print(
                f"  e={factor_degree} I={factor_dimension} K1_{lower_degree}={lower_dimension} "
                f"flat={expected_rank}/{factor_dimension * lower_dimension} "
                f"image-dim={factor_dimension + lower_dimension - 2}",
                flush=True,
            )
        prime_records.append({
            "prime": prime,
            "zeta11": zeta,
            "target_rank": rank_mod(target_values, prime),
            "components": components,
        })

    for factor_degree, rows in fixed_tangent_rows.items():
        arrays[f"tangent_minor_rows_e{factor_degree}"] = np.asarray(rows, dtype=np.uint16)
        component_metadata[str(factor_degree)]["tangent_minor_rows"] = list(rows)
    np.savez_compressed(OUTPUT_NPZ, **arrays)

    payload = {
        "schema": "pc3-d31-lower-k1-factor-subunion-v2",
        "field": "K=Q(zeta_11), Phi_11(zeta_11)=0",
        "target": "P(K1_31)=P^197",
        "input_hashes": {
            str(path.relative_to(ROOT)): digest for path, digest in EXPECTED_HASHES.items()
        },
        "gcd_theorem_and_scope_gap": {
            "gcd_invariant_theorem": (
                "For a nonzero G-equivariant covariant F, the gcd h of its five "
                "components spans a G-stable line: g sends h to an associate. "
                "This gives a character G->G_m. Since PSL_2(F_11) is perfect, "
                "the character is trivial and h is invariant. Conversely, if "
                "F=hH with invariant h, then H is equivariant."
            ),
            "certified_subunion": (
                "This packet is the union over e>0 of the projective multiplication "
                "images P(I_e)xP(K1_(31-e))->P(K1_31). Every displayed image is an "
                "actual common-factor component, but their union need not be exhaustive."
            ),
            "installed_nonempty_factor_degrees": list(FACTOR_SPECS),
            "missing_invariant_degrees_below_15": [1, 2, 4],
            "installed_K1_zero_degrees": zero_ledger,
            "reason_no_e_at_least_15": (
                "Then 31-e<=16, and the installed dual-cross K1 circuit ledger is zero."
            ),
            "closedness": (
                "Each domain is projective, so its multiplication image is closed by "
                "properness; a finite union of these images is closed."
            ),
            "exhaustiveness_failure": (
                "From F=hH one obtains H equivariant, not H in lower K1. If h itself "
                "vanishes on every involution plus-plane, then hH may lie in K1 while "
                "H does not. The fixed-word audit gives explicit nonzero such families."
            ),
            "correct_exhaustive_source": (
                "For each e use P(I_e)xP(M_(31-e)), where M is the full equivariant "
                "covariant space, and cut the Segre graph by the literal K1 restriction "
                "equations after multiplication."
            ),
        },
        "graph_construction": {
            "component_equations": (
                "For each e introduce z_(a,b). Impose all 2x2 minors of the "
                "dim(I_e) x dim(K1_(31-e)) matrix z, then impose "
                "y_k-sum_(a,b)T_e[k,a,b]z_(a,b)=0 for k=0,...,197."
            ),
            "target_image_ideal": (
                "Eliminate that component's z variables. The reduced common-factor "
                "support is the union, hence the target ideal is the intersection of "
                "the eleven eliminated component ideals."
            ),
            "kernel_policy": (
                "Auxiliary Segre variables are retained for every component. In "
                "particular e=6 has tensor kernel dimension 7, so no left inverse "
                "or reshaped target-coordinate Segre equations are used."
            ),
        },
        "components": component_metadata,
        "prime_records": prime_records,
        "deep_e6_certificate": {
            "path": E6_PACKET.name,
            "sha256": sha256_file(E6_PACKET),
            "role": "gcd-one pencil certificate excluding decomposable points in the 7-kernel",
        },
        "artifact": OUTPUT_NPZ.name,
        "artifact_sha256": sha256_file(OUTPUT_NPZ),
        "scope": {
            "materialized": (
                "All eleven degree-31 lower-K1 factor multiplication tensors, "
                "fixed lower circuit bases, flattening kernels, all-400-row identities, "
                "auxiliary graph equation counts, and projective tangent witnesses at "
                "p=419 and p=463."
            ),
            "exact_circuit": (
                "Every factor, lower covariant, and target basis vector is a fixed "
                "characteristic-zero Hironaka/Reynolds/cross circuit. Nonzero good-fibre "
                "minors give characteristic-zero independence and image-dimension lower "
                "bounds for these installed components."
            ),
            "not_materialized": (
                "No entrywise Q(zeta_11) tensors and no target-only eliminated ideals. "
                "The JSON specifies the projective graph and elimination exactly; the "
                "NPZ contains only its two modular reductions."
            ),
            "landing_dependency": (
                "For F=hH, the Klein landing equation satisfies Klein(F)=h^3*Klein(H). "
                "Thus landing points on each factor component require the corresponding "
                "lower landing scheme. In particular e=6 retains the unresolved PC.2 "
                "degree-25 landing ideal in its b variables."
            ),
        },
        "exit": "PC3-D31-LOWER-K1-FACTOR-SUBUNION-TWO-PRIME-PASS",
    }
    OUTPUT_JSON.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PC3_D31_COMMON_FACTOR_UNION_PRODUCED", flush=True)


if __name__ == "__main__":
    main()
