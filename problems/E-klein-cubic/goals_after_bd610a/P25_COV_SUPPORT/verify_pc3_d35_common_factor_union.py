#!/usr/bin/env python3
"""Independent replay of all fifteen degree-35 lower-K1 factor graphs."""

from __future__ import annotations

import importlib.util
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
PRODUCER_NPZ = HERE / "pc3_d35_common_factor_union.npz"
PRODUCER_JSON = HERE / "pc3_d35_common_factor_union.json"
OUTPUT = HERE / "verify_pc3_d35_common_factor_union_result.json"

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


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


sys.path.insert(0, str(WORK))
sys.path.insert(0, str(HERE))
cross = load("pc3_d35_union_verify_cross", WORK / "produce_cross_basis.py")
shared = load(
    "pc3_d35_union_verify_shared",
    HERE / "verify_pc3_d31_common_factor_union.py",
)


def main() -> None:
    generators = json.loads(DUAL_PATH.read_text())["generators"]
    target_packet = json.loads(TARGET_PATH.read_text())
    points = cross.fixed_points(80)
    module419 = cross.module_at(419, 13)
    dual419 = cross.evaluate_fixed_dual_generators(
        cross.DualEvaluator(module419, points % 419, 419), generators
    )

    lower_bases = {}
    for factor_degree, (lower_degree, _, lower_dimension, _) in SPECS.items():
        lower_bases[factor_degree] = shared.independent_scan(
            lower_degree, lower_dimension, generators, dual419, points % 419, 419
        )
    assert lower_bases[10] == json.loads(FIXED_P25.read_text())["basis"]
    for degree in range(17):
        assert shared.independent_scan(
            degree, 0, generators, dual419, points % 419, 419
        ) == []

    computed: dict[str, np.ndarray] = {
        "fixed_evaluation_points": points.astype(np.uint16),
    }
    tangent_rows = {}
    prime_records = []
    with np.load(STRICT_MAPS, allow_pickle=False) as strict_packet:
        for prime, zeta in PRIMES.items():
            print(f"verify p={prime}: all degree-35 common-factor graphs", flush=True)
            module = module419 if prime == 419 else cross.module_at(prime, zeta)
            dual_values = dual419 if prime == 419 else cross.evaluate_fixed_dual_generators(
                cross.DualEvaluator(module, points % prime, prime), generators
            )
            target = cross.evaluate_fixed_crosses(
                target_packet["basis"], dual_values, points % prime, prime
            )
            target_rows = np.asarray(
                target_packet["fixed_maximal_minor_rows"], dtype=np.int64
            )
            target_inverse = shared.inverse(target[target_rows], prime)
            components = {}
            for factor_degree, (lower_degree, factor_dimension, lower_dimension, expected_rank) in SPECS.items():
                lower = shared.evaluate_records(
                    lower_bases[factor_degree], dual_values, points % prime, prime
                )
                assert shared.rank(lower, prime) == lower_dimension
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
                flattened = tensor.reshape(361, -1)
                assert shared.rank(flattened, prime) == expected_rank
                relation_kernel = shared.right_kernel(flattened, prime)
                assert relation_kernel.shape[1] == factor_dimension * lower_dimension - expected_rank
                tangent_matrix = shared.tangent(tensor, prime)
                expected_tangent = factor_dimension + lower_dimension - 1
                assert shared.rank(tangent_matrix, prime) == expected_tangent
                if factor_degree not in tangent_rows:
                    tangent_rows[factor_degree] = shared.row_profile(tangent_matrix, prime)
                assert shared.rank(
                    tangent_matrix[list(tangent_rows[factor_degree])], prime
                ) == expected_tangent
                samples = shared.verify_graph(tensor, prime)

                if factor_degree == 10:
                    f10_index = cross.invariant_labels(10).index(
                        (3, (0, 0, 0, 0, 0))
                    )
                    inclusion = strict_packet[f"strict_inclusion_p{prime}"].astype(np.int64)
                    strict_f10 = strict_packet[
                        f"strict_multiplier_map_d35_p{prime}"
                    ].astype(np.int64)
                    assert np.array_equal(
                        tensor[:, f10_index, :] @ inclusion % prime, strict_f10
                    )

                computed[f"tensor_e{factor_degree}_p{prime}"] = tensor.astype(np.uint16)
                computed[f"kernel_e{factor_degree}_p{prime}"] = relation_kernel.astype(np.uint16)
                computed[f"tangent_e{factor_degree}_p{prime}"] = tangent_matrix.astype(np.uint16)
                components[str(factor_degree)] = {
                    "lower_rank": shared.rank(lower, prime),
                    "flattened_rank": shared.rank(flattened, prime),
                    "kernel_dimension": relation_kernel.shape[1],
                    "tangent_rank": shared.rank(tangent_matrix, prime),
                    "graph_samples": samples,
                    "tensor_sha256": shared.sha256_array(tensor.astype(np.uint16)),
                }
            prime_records.append({"prime": prime, "components": components})

    for factor_degree, rows in tangent_rows.items():
        computed[f"tangent_minor_rows_e{factor_degree}"] = np.asarray(rows, dtype=np.uint16)

    with np.load(PRODUCER_NPZ, allow_pickle=False) as frozen:
        assert set(frozen.files) == set(computed)
        for name, expected in computed.items():
            assert np.array_equal(frozen[name], expected), name

    metadata = json.loads(PRODUCER_JSON.read_text())
    assert metadata["schema"] == "pc3-d35-lower-k1-factor-subunion-v2"
    assert metadata["artifact_sha256"] == shared.sha256_file(PRODUCER_NPZ)
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
        "schema": "verify-pc3-d35-common-factor-union-v1",
        "verdict": "PASS",
        "producer_imported": False,
        "stored_arrays_used_as_computational_inputs": False,
        "producer_artifact_sha256": shared.sha256_file(PRODUCER_NPZ),
        "producer_metadata_sha256": shared.sha256_file(PRODUCER_JSON),
        "factor_degrees": list(SPECS),
        "kernel_bearing_degrees": [6, 8, 9, 11, 12],
        "prime_records": prime_records,
        "strict_f10_crosscheck": True,
        "scope": (
            "Independent two-prime replay of all fifteen projective degree-35 "
            "lower-K1 factor graphs in literal K1 spaces."
        ),
        "boundary": (
            "This is not exhaustive for all common factors because the lower quotient "
            "after gcd division need not lie in K1. Target-only eliminated ideals and "
            "entrywise Q(zeta_11) tensors are not materialized."
        ),
    }
    OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PC3_D35_COMMON_FACTOR_UNION_VERIFIED", flush=True)


if __name__ == "__main__":
    main()
