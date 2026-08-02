#!/usr/bin/env python3
"""Independent two-prime replay of the PC.3 pure-composition graphs."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
LEDGER = HERE / "pc3_composition_graphs.json"
CERTIFICATE = HERE / "pc3_composition_graphs.npz"
PRODUCER = HERE / "produce_pc3_composition_graphs.py"


def load_producer():
    spec = importlib.util.spec_from_file_location("pc3_composition_graph_producer", PRODUCER)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def main() -> None:
    producer = load_producer()
    ledger = json.loads(LEDGER.read_text())
    assert ledger["schema"] == "pc3-pure-composition-projective-graphs-v1"
    assert ledger["status"] == "PC3-COMPOSITION-GRAPHS-SCOPED-PASS"
    assert ledger["global_status"] == "PC-UNDECIDED"
    assert producer.sha256_file(CERTIFICATE) == ledger["certificate"]["sha256"]

    for relative, expected in ledger["inputs"].items():
        path = ROOT / relative
        assert path.is_file(), path
        assert producer.sha256_file(path) == expected, path

    dimensions = ledger["lower_self_covariant_spaces"]
    assert [dimensions[f"degree_{degree}"]["dimension"] for degree in range(1, 8)] == [
        1, 0, 0, 2, 1, 2, 4
    ]
    active = [degree for degree in range(2, 8) if dimensions[f"degree_{degree}"]["dimension"]]
    assert active == [4, 5, 6, 7]
    assert [(a, b) for a in active for b in active if a * b == 31] == []
    assert [(a, b) for a in active for b in active if a * b == 35] == [(5, 7), (7, 5)]
    assert ledger["degree_arithmetic"]["31"]["nontrivial_pure_composition_components"] == []
    assert ledger["degree_arithmetic"]["35"]["nontrivial_pure_composition_components"] == [
        "D_after_M7", "M7_after_D"
    ]

    old31 = producer.classify_old_ansatz(31)
    old35 = producer.classify_old_ansatz(35)
    assert old31 == ledger["old_named_ansatz_classification"]["degree_31"]
    assert old35 == ledger["old_named_ansatz_classification"]["degree_35"]
    assert old31["pure_named_directions"] == []
    assert old35["pure_named_directions"] == [["D", "K"], ["K", "D"]]

    with np.load(CERTIFICATE, allow_pickle=False) as frozen:
        expected_shapes = ledger["certificate"]["arrays"]
        assert set(frozen.files) == set(expected_shapes)
        for key, shape in expected_shapes.items():
            assert list(frozen[key].shape) == shape, key
        fixed_points = frozen["fixed_evaluation_points"].astype(np.int64)
        frame_rows = frozen["target_frame_rows"].astype(np.int64)
        monomials = frozen["veronese_degree5_exponents"].astype(np.int64)
        quadrics = frozen["veronese_quadratic_circuits"].astype(np.int64)
        rebuilt_monomials, rebuilt_quadrics = producer.veronese_quadrics()
        assert np.array_equal(monomials, rebuilt_monomials)
        assert np.array_equal(quadrics, rebuilt_quadrics)

        full_records = json.loads(producer.TARGET_FULL.read_text())
        k1_packet = json.loads(producer.TARGET_K1.read_text())
        dual_records = json.loads(producer.DUAL.read_text())["generators"]
        expected_dimensions = [0, 1, 0, 0, 2, 1, 2, 4]

        for prime, zeta in producer.PRIMES.items():
            print(f"p={prime}: independently replaying composition graphs", flush=True)
            record = ledger["prime_records"][str(prime)]
            module = producer.cross.module_at(prime, zeta)
            actual_dimensions = producer.self_covariant_dimensions(module, prime)
            assert actual_dimensions == expected_dimensions
            assert actual_dimensions == record["self_covariant_dimensions_d0_through_d7"]

            lower = producer.lower_basis_values(fixed_points[:20] % prime, prime)
            lower_ranks = {
                str(degree): producer.rank_mod(values.reshape(-1, values.shape[2]), prime)
                for degree, values in lower.items()
            }
            assert lower_ranks == record["installed_lower_basis_ranks"]

            full_values = producer.cross.full_seed_evaluations(
                module, full_records, fixed_points % prime, prime
            )
            assert producer.rank_mod(full_values[frame_rows], prime) == 637

            dual_evaluator = producer.cross.DualEvaluator(
                module, fixed_points % prime, prime
            )
            dual_values = producer.cross.evaluate_fixed_dual_generators(
                dual_evaluator, dual_records
            )
            k1_values = producer.cross.evaluate_fixed_crosses(
                k1_packet["basis"], dual_values, fixed_points % prime, prime
            )
            k1_frame = k1_values[frame_rows]
            stored_k1_frame = frozen[f"k1_target_frame_p{prime}"].astype(np.int64)
            assert np.array_equal(k1_frame, stored_k1_frame)
            assert producer.rank_mod(k1_frame, prime) == 361

            quotient = producer.right_kernel(k1_frame.T, prime).T
            stored_quotient = frozen[f"k1_quotient_p{prime}"].astype(np.int64)
            assert np.array_equal(quotient, stored_quotient)
            assert quotient.shape == (276, 637)
            assert producer.rank_mod(quotient, prime) == 276
            assert not np.any(quotient @ k1_frame % prime)

            plus = producer.cross.plus_basis(module, prime)
            assert np.array_equal(plus, frozen[f"plus_basis_p{prime}"].astype(np.int64))
            plane_points = producer.cross.plane_points(plus, 35, prime)
            assert plane_points.shape == (666, 5)

            for name, evaluator, source_columns in (
                ("D_after_M7", producer.d_after_m7_evaluations, 56),
                ("M7_after_D", producer.m7_after_d_evaluations, 4),
            ):
                target_map = evaluator(fixed_points % prime, prime)[frame_rows] % prime
                plane_restriction = evaluator(plane_points, prime) % prime
                stored_target = frozen[f"target_map_{name}_p{prime}"].astype(np.int64)
                stored_plane = frozen[
                    f"plus_plane_restriction_{name}_p{prime}"
                ].astype(np.int64)
                assert np.array_equal(target_map, stored_target)
                assert np.array_equal(plane_restriction, stored_plane)

                kernel = producer.right_kernel(target_map, prime)
                assert np.array_equal(
                    kernel, frozen[f"target_kernel_{name}_p{prime}"].astype(np.int64)
                )
                assert kernel.shape == (source_columns, 0)
                obstruction = quotient @ target_map % prime
                assert np.array_equal(
                    obstruction,
                    frozen[f"k1_obstruction_{name}_p{prime}"].astype(np.int64),
                )
                assert producer.rank_mod(target_map, prime) == source_columns
                assert producer.rank_mod(obstruction, prime) == source_columns
                assert producer.rank_mod(plane_restriction, prime) == source_columns
                assert producer.rank_mod(
                    np.vstack([obstruction, plane_restriction]), prime
                ) == source_columns

                family_record = record["families"][name]
                assert family_record["target_map_rank"] == source_columns
                assert family_record["target_map_kernel_dimension"] == 0
                assert family_record["K1_obstruction_rank"] == source_columns
                assert family_record["plus_plane_restriction_rank"] == source_columns
                assert family_record["K1_projective_intersection_empty"] is True

            for sample in range(3):
                parameters = np.asarray(
                    [1, sample + 2, 2 * sample + 3, 3 * sample + 5], dtype=np.int64
                ) % prime
                vector = producer.veronese_vector(parameters, prime)
                producer.verify_veronese_circuits(vector, quadrics, prime)

    intersections = ledger["incidence_intersections"]
    assert intersections["D_after_M7_with_literal_K1_35"] == "empty"
    assert intersections["M7_after_D_with_literal_K1_35"] == "empty"
    assert intersections[
        "either_graph_with_corrected_exhaustive_common_factor_locus_in_full_M35"
    ] == "not computed"
    assert "not used" in intersections["factor_boundary"]
    assert "saturation" in ledger["theorem_boundary"]["does_not_prove"]
    assert ledger["global_status"] == "PC-UNDECIDED"

    print("PASS_PC3_NO_NONTRIVIAL_DEGREE31_PURE_COMPOSITION")
    print("PASS_PC3_D35_TWO_KERNEL_AWARE_GRAPHS_TWO_PRIMES")
    print("PASS_PC3_D35_COMPOSITION_K1_INTERSECTIONS_EMPTY_SCOPED")
    print("BOUNDARY_PC3_CORRECTED_COMMON_FACTOR_INTERSECTIONS_OPEN")


if __name__ == "__main__":
    main()
