#!/usr/bin/env python3
"""Produce the degree-35 factor subunion with lower factor in installed K1.

This is the degree-35 analogue of ``produce_pc3_d31_common_factor_union.py``.
Every component retains its auxiliary Segre coordinates, including the five
flattenings with nonzero kernels.  Stored tensor entries are reductions at
p=419 and p=463, not entrywise characteristic-zero expansions.
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
TARGET_PATH = WORK / "degree_35" / "m1_cross_basis_circuits.json"
FIXED_P25 = WORK / "degree_25_fixed_k1_basis.json"
STRICT_MAPS = HERE / "pc3_p25_multiplier_maps.npz"
OUTPUT_NPZ = HERE / "pc3_d35_common_factor_union.npz"
OUTPUT_JSON = HERE / "pc3_d35_common_factor_union.json"

PRIMES = {419: 13, 463: 15}
SPECS = {
    3: (32, 1, 232, 232),
    5: (30, 1, 165, 165),
    6: (29, 2, 138, 242),
    7: (28, 1, 115, 115),
    8: (27, 2, 91, 175),
    9: (26, 3, 75, 210),
    10: (25, 3, 59, 177),
    11: (24, 4, 44, 173),
    12: (23, 6, 34, 200),
    13: (22, 5, 25, 125),
    14: (21, 8, 16, 128),
    15: (20, 10, 11, 110),
    16: (19, 10, 7, 70),
    17: (18, 13, 3, 39),
    18: (17, 17, 2, 34),
}
EXPECTED_HASHES = {
    DUAL_PATH: "b9aa1f8fe852e15b1b786b6a0577f06cf3ce200c5b092bcbd4c444678add874b",
    TARGET_PATH: "f28effc9a4c9e8923980b4726d264672141a030a61a23a416534b426a301775a",
    FIXED_P25: "73e6132e19105d4489d70093edf310c766051b90583536ba3b3fa85e223722b1",
    STRICT_MAPS: "1821aa187af7573833bb132769e262af61858622657f7684116d104466451110",
}


sys.path.insert(0, str(WORK))
sys.path.insert(0, str(HERE))
import produce_cross_basis as cross  # noqa: E402
import produce_primitive_module as primitive  # noqa: E402
import produce_pc3_d31_common_factor_union as linear  # noqa: E402


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def main() -> None:
    for path, expected in EXPECTED_HASHES.items():
        assert sha256_file(path) == expected, path
    generators = json.loads(DUAL_PATH.read_text())["generators"]
    target_packet = json.loads(TARGET_PATH.read_text())
    fixed_p25_records = json.loads(FIXED_P25.read_text())["basis"]
    points = cross.fixed_points(80)
    assert np.array_equal(
        np.asarray(target_packet["fixed_evaluation_points"], dtype=np.int64), points
    )

    selection_module = cross.module_at(419, 13)
    selection_dual = cross.evaluate_fixed_dual_generators(
        cross.DualEvaluator(selection_module, points % 419, 419), generators
    )
    lower_bases = {}
    candidate_counts = {}
    for factor_degree, (lower_degree, _, lower_dimension, _) in SPECS.items():
        actual, selected, count = primitive.scan_degree(
            lower_degree, generators, selection_dual, points % 419, 419
        )
        assert actual == len(selected) == lower_dimension
        lower_bases[factor_degree] = selected
        candidate_counts[factor_degree] = count
    assert lower_bases[10] == fixed_p25_records
    for degree in range(17):
        actual, selected, count = primitive.scan_degree(
            degree, generators, selection_dual, points % 419, 419
        )
        assert actual == len(selected) == count == 0

    components = {}
    for factor_degree, (lower_degree, factor_dimension, lower_dimension, expected_rank) in SPECS.items():
        labels = cross.invariant_labels(factor_degree)
        assert len(labels) == factor_dimension
        components[str(factor_degree)] = {
            "factor_degree": factor_degree,
            "lower_degree": lower_degree,
            "factor_dimension": factor_dimension,
            "lower_dimension": lower_dimension,
            "tensor_columns": factor_dimension * lower_dimension,
            "expected_flattened_rank": expected_rank,
            "expected_kernel_dimension": factor_dimension * lower_dimension - expected_rank,
            "factor_basis": [cross.invariant_json(label) for label in labels],
            "lower_basis_circuits": lower_bases[factor_degree],
            "lower_candidate_count": candidate_counts[factor_degree],
            "domain": f"P^{factor_dimension - 1} x P^{lower_dimension - 1}",
            "domain_dimension": factor_dimension + lower_dimension - 2,
            "auxiliary_segre_variables": factor_dimension * lower_dimension,
            "segree_quadrics": comb(factor_dimension, 2) * comb(lower_dimension, 2),
            "graph_linear_equations": 361,
            "target_image_ideal_status": "defined by elimination of z; not materialized",
        }

    arrays: dict[str, np.ndarray] = {
        "fixed_evaluation_points": points.astype(np.uint16),
    }
    fixed_tangent_rows = {}
    prime_records = []
    with np.load(STRICT_MAPS, allow_pickle=False) as strict_packet:
        for prime, zeta in PRIMES.items():
            print(f"p={prime}: rebuilding all degree-35 factor tensors", flush=True)
            module = cross.module_at(prime, zeta)
            dual_values = cross.evaluate_fixed_dual_generators(
                cross.DualEvaluator(module, points % prime, prime), generators
            )
            target_values = cross.evaluate_fixed_crosses(
                target_packet["basis"], dual_values, points % prime, prime
            )
            assert linear.rank_mod(target_values, prime) == 361
            target_rows = np.asarray(
                target_packet["fixed_maximal_minor_rows"], dtype=np.int64
            )
            target_inverse = linear.inverse_mod(target_values[target_rows], prime)
            component_records = {}
            for factor_degree, (lower_degree, factor_dimension, lower_dimension, expected_rank) in SPECS.items():
                lower_values = linear.fixed_direction_matrix(
                    lower_bases[factor_degree], dual_values, points % prime, prime
                )
                assert linear.rank_mod(lower_values, prime) == lower_dimension
                legs = []
                residuals = []
                for label in cross.invariant_labels(factor_degree):
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
                    assert linear.rank_mod(leg, prime) == lower_dimension
                    legs.append(leg)
                    residuals.append(int(np.count_nonzero(residual)))
                tensor = np.stack(legs, axis=1) % prime
                flattened = tensor.reshape(361, factor_dimension * lower_dimension)
                assert linear.rank_mod(flattened, prime) == expected_rank
                kernel = linear.right_kernel(flattened, prime)
                assert kernel.shape[1] == factor_dimension * lower_dimension - expected_rank
                tangent = linear.tangent_matrix(tensor, prime)
                expected_tangent = factor_dimension + lower_dimension - 1
                assert linear.rank_mod(tangent, prime) == expected_tangent
                if factor_degree not in fixed_tangent_rows:
                    fixed_tangent_rows[factor_degree] = linear.independent_rows(tangent, prime)
                assert linear.rank_mod(
                    tangent[list(fixed_tangent_rows[factor_degree])], prime
                ) == expected_tangent
                sample_count = linear.graph_samples(tensor, prime)

                if factor_degree == 10:
                    labels = cross.invariant_labels(10)
                    f10_index = labels.index((3, (0, 0, 0, 0, 0)))
                    inclusion = strict_packet[f"strict_inclusion_p{prime}"].astype(np.int64)
                    strict_f10 = strict_packet[
                        f"strict_multiplier_map_d35_p{prime}"
                    ].astype(np.int64)
                    assert np.array_equal(
                        tensor[:, f10_index, :] @ inclusion % prime, strict_f10
                    )

                arrays[f"tensor_e{factor_degree}_p{prime}"] = tensor.astype(np.uint16)
                arrays[f"kernel_e{factor_degree}_p{prime}"] = kernel.astype(np.uint16)
                arrays[f"tangent_e{factor_degree}_p{prime}"] = tangent.astype(np.uint16)
                component_records[str(factor_degree)] = {
                    "lower_rank": linear.rank_mod(lower_values, prime),
                    "leg_ranks": [linear.rank_mod(leg, prime) for leg in legs],
                    "flattened_rank": linear.rank_mod(flattened, prime),
                    "flattened_kernel_dimension": kernel.shape[1],
                    "tensor_sha256": sha256_array(tensor.astype(np.uint16)),
                    "kernel_sha256": sha256_array(kernel.astype(np.uint16)),
                    "all_400_row_residual_nonzeros": residuals,
                    "projective_tangent_augmented_rank": linear.rank_mod(tangent, prime),
                    "graph_samples_checked": sample_count,
                    "strict_f10_crosscheck": factor_degree == 10,
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
                "target_rank": linear.rank_mod(target_values, prime),
                "components": component_records,
            })

    for factor_degree, rows in fixed_tangent_rows.items():
        arrays[f"tangent_minor_rows_e{factor_degree}"] = np.asarray(rows, dtype=np.uint16)
        components[str(factor_degree)]["tangent_minor_rows"] = list(rows)
    np.savez_compressed(OUTPUT_NPZ, **arrays)

    kernel_degrees = [
        degree for degree, (_, a, b, rank) in SPECS.items() if a * b > rank
    ]
    payload = {
        "schema": "pc3-d35-lower-k1-factor-subunion-v2",
        "field": "K=Q(zeta_11), Phi_11(zeta_11)=0",
        "target": "P(K1_35)=P^360",
        "input_hashes": {
            str(path.relative_to(ROOT)): digest for path, digest in EXPECTED_HASHES.items()
        },
        "gcd_theorem_and_scope_gap": {
            "gcd_invariant_theorem": (
                "For nonzero equivariant F, its component gcd spans a G-stable line. "
                "PSL_2(F_11) is perfect, so the resulting character is trivial and "
                "the gcd is invariant. Conversely division by an invariant factor "
                "preserves equivariance."
            ),
            "certified_subunion": (
                "This packet is the finite union of the images "
                "P(I_e)xP(K1_(35-e))->P(K1_35). Every image is factorable and "
                "closed, but this lower-K1 union is not exhaustive."
            ),
            "installed_nonempty_factor_degrees": list(SPECS),
            "missing_invariant_degrees_below_19": [1, 2, 4],
            "installed_K1_zero_degrees": {str(degree): 0 for degree in range(17)},
            "reason_no_e_at_least_19": "Then 35-e<=16 and the installed K1 circuit space is zero.",
            "closedness": "Each image is closed by properness; their finite union is closed.",
            "exhaustiveness_failure": (
                "Division F=hH proves only that H is equivariant. An invariant h may "
                "itself vanish on the involution arrangement, allowing hH in K1 with "
                "H outside lower K1; the fixed-word audit exhibits such families."
            ),
            "correct_exhaustive_source": (
                "Use P(I_e)xP(M_(35-e)) for the full lower equivariant space M, then "
                "cut the multiplication graph by the literal K1 restriction equations."
            ),
        },
        "graph_construction": {
            "equations": (
                "For each e impose every 2x2 minor of z_(a,b), followed by "
                "y_k-sum T_e[k,a,b]z_(a,b)=0 for k=0,...,360."
            ),
            "target_image_ideal": (
                "Eliminate z componentwise, then intersect the fifteen target ideals; "
                "these eliminations are specified but not materialized."
            ),
            "kernel_policy": (
                "All graphs retain z. Kernel-bearing degrees are "
                + ",".join(map(str, kernel_degrees))
                + "; none is treated by a false left inverse."
            ),
        },
        "components": components,
        "prime_records": prime_records,
        "artifact": OUTPUT_NPZ.name,
        "artifact_sha256": sha256_file(OUTPUT_NPZ),
        "scope": {
            "materialized": (
                "All fifteen degree-35 lower-K1 factor tensors, lower circuit bases, "
                "kernels, all-400-row identities, projective graph counts, and tangent "
                "witnesses at p=419 and p=463."
            ),
            "not_materialized": (
                "No target-only eliminations and no entrywise Q(zeta_11) tensors."
            ),
            "landing_dependency": (
                "On a factor component Klein(hH)=h^3*Klein(H), so its landing "
                "intersection pulls back the corresponding lower landing scheme. "
                "The e=10/f10 leg contains the unresolved authoritative PC.2 image."
            ),
        },
        "exit": "PC3-D35-LOWER-K1-FACTOR-SUBUNION-TWO-PRIME-PASS",
    }
    OUTPUT_JSON.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PC3_D35_COMMON_FACTOR_UNION_PRODUCED", flush=True)


if __name__ == "__main__":
    main()
