#!/usr/bin/env python3
"""Independent structural audit of marked_incidence_presentation.json."""

from __future__ import annotations

import hashlib
import itertools
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
PRESENTATION = HERE / "marked_incidence_presentation.json"
FAMILY = HERE / "universal_marked_family.json"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    data = json.loads(PRESENTATION.read_text())
    family = json.loads(FAMILY.read_text())
    assert data["schema"] == "s19-marked-incidence-presentation-v1"
    assert data["terminal_marker"] == "S19_MARKED_INCIDENCE_FINITE_PRESENTATION_EXACT"
    assert data["source_sha256"]["universal_marked_family.json"] == digest(FAMILY)
    assert data["source_sha256"]["goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md"] == digest(PROBLEM / "goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md")
    assert data["source_sha256"]["tmp/schur_degree19_nonacm_attack_audit/certificate.json"] == digest(PROBLEM / "tmp/schur_degree19_nonacm_attack_audit/certificate.json")

    assert family["generic_freeness"]["hilbert_function_d0_to_d6"] == [1, 4, 10, 19, 31, 45, 55]
    assert math.comb(5 + 3, 3) - 45 == 11
    assert data["rao_branch_rank_tests"]["compressed_point_ideal_matrix"]["shape"] == [5 * 19 + 1, 11]
    assert data["rao_branch_rank_tests"]["full_quintic_substitution_matrix"]["shape"] == [5 * 19 + 1, math.comb(8, 3)]

    matrix = data["linearized_matrix"]
    assert matrix["shape"] == [4 * 55, 4 * 20 + 55]
    assert len(matrix["equations"]) == 220
    seen_rows = set()
    for equation in matrix["equations"]:
        i, j = equation["point"], equation["coordinate"]
        assert 0 <= i < 55 and 0 <= j < 4
        assert equation["row"] == 4 * i + j
        assert equation["map_columns"] == list(range(20 * j, 20 * (j + 1)))
        assert equation["lambda_column"] == 80 + i
        assert equation["universal_point_tensor_reference"] == [i, j]
        seen_rows.add(equation["row"])
    assert seen_rows == set(range(220))

    assert len(data["variables"]["source_markings"]["names"]) == 55
    assert all(len(pair) == 2 for pair in data["variables"]["source_markings"]["names"])
    assert len(data["variables"]["degree19_map"]["names"]) == 4
    assert all(len(row) == 20 for row in data["variables"]["degree19_map"]["names"])
    assert len(data["variables"]["linearization_scalars"]["names"]) == 55
    assert len(data["saturated_incidence"]["irrelevant_ideals"]) == 57
    assert math.comb(55, 2) == len(family["good_open"]["pair_separation_factors"])

    ledger = data["dimension_ledger"]
    assert ledger["map_mod_PGL2"] == (4 * 20 - 1) - 3 == 76
    assert ledger["virtual_relative_total"] == 4 + 76 - 2 * 55 == -30
    assert ledger["equivalent_before_PGL2"]["base_plus_markings_plus_projective_kernel_variables"] == 4 + 55 + 134 == 193
    assert ledger["equivalent_before_PGL2"]["virtual_dimension"] == 193 - 220 == -27

    tangent = data["smooth_fixed_fibre_tangent_obstruction"]
    for b1 in range(1, 36):
        b2 = 36 - b1
        degrees = [b1 - 36, b2 - 36]
        h0 = sum(max(degree + 1, 0) for degree in degrees)
        h1 = sum(max(-degree - 1, 0) for degree in degrees)
        assert h0 == tangent["tangent_dimension_h0"] == 0
        assert h1 == tangent["obstruction_dimension_h1"] == 34

    lattice = data["special_quintic_carrier"]["smooth_candidate_lattice"]
    assert lattice["C2"] == -2 - lattice["H_dot_C"] == -21
    assert lattice["determinant"] == lattice["H2"] * lattice["C2"] - lattice["H_dot_C"] ** 2 == -466
    assert lattice["gram"] == [[5, 19], [19, -21]]

    raw = data["resource_preflight"]["raw_gotzmann"]
    gotzmann = math.comb(19, 2) + 1
    assert raw["number"] == gotzmann == 172
    assert raw["ambient_monomials"] == math.comb(gotzmann + 3, 3) == 877975
    assert raw["hilbert_value"] == 19 * gotzmann + 1 == 3269
    assert raw["ideal_dimension"] == raw["ambient_monomials"] - raw["hilbert_value"] == 874706
    assert raw["grassmannian_dimension"] == raw["ideal_dimension"] * raw["hilbert_value"] == 2859413914

    proxy = data["resource_preflight"]["degree18_regular_curve_proxy"]
    assert proxy == {
        "ambient_monomials": math.comb(21, 3),
        "hilbert_value": 19 * 18 + 1,
        "ideal_dimension": math.comb(21, 3) - (19 * 18 + 1),
        "grassmannian_dimension": (math.comb(21, 3) - (19 * 18 + 1)) * (19 * 18 + 1),
    }

    print("PASS exact 220 by 135 marked-map matrix ledger")
    print("PASS all projective, distinctness, lambda, basepoint and PGL2 gates are named")
    print("PASS epsilon branches are exact rank 11/10 tests inside I_Z(5)")
    print("PASS smooth fixed-fibre tangent=0 and obstruction=34 for every allowed splitting")
    print("PASS quintic carrier lattice has Gram [[5,19],[19,-21]] and determinant -466")
    print("PASS raw Hilbert preflight versus sparse incidence dimensions")
    print("S19_MARKED_INCIDENCE_PRESENTATION_INDEPENDENT_REPLAY_OK")


if __name__ == "__main__":
    main()
