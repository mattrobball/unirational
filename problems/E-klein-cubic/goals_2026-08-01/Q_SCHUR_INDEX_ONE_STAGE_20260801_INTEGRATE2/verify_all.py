#!/usr/bin/env python3
"""Independent end-to-end audit of decision, computations, and seal."""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

import verify_f55_covariants


HERE = Path(__file__).resolve().parent


def source_root() -> Path:
    # Installed location: <root>/goal_runs_after_35fa/Q_SCHUR_INDEX_ONE.
    # Staged replays pass Q_SCHUR_SOURCE_ROOT explicitly.
    return (
        Path(os.environ["Q_SCHUR_SOURCE_ROOT"]).resolve()
        if "Q_SCHUR_SOURCE_ROOT" in os.environ
        else HERE.parents[1]
    )


def run_replay(relative: str, marker: str) -> None:
    process = subprocess.run(
        [sys.executable, "-u", str(HERE / relative)],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        cwd=HERE,
    )
    assert marker in process.stdout, (relative, process.stdout)
    print(process.stdout, end="")


def run_source_replay(relative: str, marker: str) -> None:
    process = subprocess.run(
        [sys.executable, "-u", str(source_root() / relative)],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        cwd=source_root(),
    )
    assert marker in process.stdout, (relative, process.stdout)
    print(process.stdout, end="")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def durable_files() -> dict[str, str]:
    return {
        str(path.relative_to(HERE)): sha256(path)
        for path in sorted(HERE.rglob("*"))
        if path.is_file()
        and path.name != "SEAL.json"
        and "__pycache__" not in path.parts
    }


def verify_manifest() -> None:
    manifest = json.loads((HERE / "SOURCE_MANIFEST.json").read_text())
    assert manifest["pinned_repository_state"] == "35fa8f59b6a1423cc89300aeaceefe91552be5ba"
    for name, record in manifest["imports"].items():
        assert sha256(HERE / "imports" / name) == record["sha256"]
    for relative, record in manifest["replay_sources"].items():
        assert sha256(source_root() / relative) == record["sha256"]
    negative = manifest["imports"]["negative_obstruction_audit.json"]
    assert negative["provenance"] == "working-tree snapshot at run start; not the pinned 35fa8f blob"
    assert negative["pinned_35fa8f_blob_sha256"] == "5d1811f0cb6e3f1f4ff0a8df6f79821aa263e2b0196365c01bb9d1b14eebda1d"
    assert negative["sha256"] != negative["pinned_35fa8f_blob_sha256"]


def verify_decision() -> None:
    decision = json.loads((HERE / "decision.json").read_text())
    assert decision["exit"] == "Q-UNDECIDED"
    assert decision["headline"] == "OPEN"
    assert decision["binary"] == {
        "point_proved": False,
        "pointlessness_proved": False,
    }
    assert decision["index"]["effective_degrees"] == [3, 11, 55]
    assert decision["index"]["bezout_coefficients"] == [4, -1, 0]
    assert decision["index"]["value"] == 1
    exact = decision["exact_genuine_twist"]
    assert exact["characteristic_zero_hilbert90_frame_verified"] is True
    assert exact["reynolds_frame_degree"] == 8
    assert exact["projective_group_terms"] == 660
    assert exact["full_descended_cubic_coefficient_entries"] == 35
    assert exact["ordered_reynolds_products"] == 625
    assert exact["minimal_invariant_field_presentation_installed"] is False
    assert exact["ten_coordinate_fibration_comparison_replayed"] is False
    assert exact["K_Schur_point_found"] is False
    assert exact["K_Schur_pointlessness_proved"] is False
    a5 = decision["a5_valuation_elimination"]
    assert a5["embedded_maximal_classes"] == 2
    assert a5["exact_degree11_landing_maps_verified"] == 2
    assert a5["honest_source_representation_dimension"] == 3
    assert a5["every_twist_over_an_extension_of_C_is_soluble"] is True
    assert a5["eliminated_decomposition_groups"] == ["A5_class_1", "A5_class_2"]
    assert a5["surviving_decomposition_groups"] == ["PSL(2,11)", "11:5"]
    assert a5["global_K_Schur_point_found"] is False
    degree11 = decision["a5_degree11_cycle"]
    assert degree11["effective_degree"] == 11
    assert degree11["prime_degree_point_field"] is True
    assert degree11["six_explicit_transferred_cycles_replayed"] is True
    assert degree11["quadric_complete_intersection_degree"] == 16
    assert degree11["quadric_base_intersect_X_degree"] == 11
    assert degree11["secant_residual_degree"] == 55
    assert degree11["secant_pair_stabilizer"] == "D12"
    assert degree11["rational_normal_quartic_residual_point_criterion"] is True
    assert degree11["rnc_incidence_dimension"] == 21
    assert degree11["rnc_incidence_generic_degree_over_X7"] == 120
    assert degree11["rnc_point_constructed"] is False
    assert decision["new_exact_result"]["schemes_replayed"] == 45
    assert decision["new_exact_result"]["complete_homogeneous_degrees_excluded"] == list(range(1, 10))
    assert decision["new_exact_result"]["coefficient_dimensions"] == [1, 1, 3, 7, 11, 19, 30, 45, 65]
    assert decision["new_exact_result"]["degree9_visited_supports"] == 26912397
    trace = decision["trace_ansatz_exclusions"]
    assert trace["constant_coefficient_two_laurent_all_exponents"] is True
    assert trace["full_K_two_kummer_basis_pairs"] == 10
    assert trace["full_K_two_kummer_basis_pairs_excluded"] == 10
    assert trace["three_kummer_coordinate_planes"] == 10
    assert trace["three_kummer_coordinate_planes_generically_smooth_integral"] == 10
    assert trace["three_kummer_coordinate_boundary_K_points_excluded"] is True
    assert trace["three_kummer_single_laurent_coordinates_all_exponents_excluded"] == 10
    assert trace["three_kummer_laurent_integral_exponent_candidates_checked"] == 673010
    assert trace["four_kummer_coordinate_hyperplanes"] == 5
    assert trace["four_kummer_single_laurent_coordinates_all_exponents_excluded"] == 5
    assert trace["four_kummer_rank3_integral_exponent_candidates_checked"] == 177365
    assert trace["four_kummer_rank2_candidate_restrictions_checked"] == 37770
    assert trace["four_kummer_rank1_candidates_checked"] == 605
    assert trace["constant_five_kummer_coordinates_excluded"] is True
    assert trace["constant_five_R_basis_coordinates_excluded"] is True
    assert trace["constant_five_coordinate_good_primes"] == [11, 31]
    assert trace["all_five_kummer_single_laurent_coordinates_excluded"] is False
    assert trace["plane_012_jacobian_extracted"] is True
    assert trace["plane_012_fisher_c4_grouped_terms"] == 14
    assert trace["plane_012_fisher_c6_grouped_terms"] == 40
    assert trace["plane_012_fisher_c4_sha256"] == (
        "f06672c95ae3843d645424600b4a6ae118fd34a4d0942b74ff16acb7606fb9f3"
    )
    assert trace["plane_012_fisher_c6_sha256"] == (
        "c3a56da44cf47a1d26dfbaa52216c664ca705ce94259ecce7078fdcf986e1374"
    )
    assert trace["plane_012_full_substituted_hessian_identity_checked"] is False
    assert trace["plane_012_torsor_class_computed"] is False
    assert trace["plane_012_K_point_decided"] is False
    assert trace["three_kummer_plane_K_points_decided"] == 0
    assert trace["plane_012_one_parameter_specialization_terms"] == 26
    assert trace["plane_012_polynomial_sections_degree_at_most_3_excluded"] is True
    assert trace["plane_012_one_parameter_point_decided"] is False
    assert trace["arbitrary_E_element_excluded"] is False
    boundary = decision["all_degree_boundary"]
    assert boundary["hsop_degrees"] == [3, 5, 6, 8, 11]
    assert boundary["secondary_rank"] == 720
    assert boundary["primitive_module_combinations_unbounded"] is True
    assert boundary["hsop_and_freeness_input_reconstructed"] is False
    model = decision["new_birational_model"]
    assert model["smooth_elliptic_normal_quintic_over_K_Schur"] is True
    assert model["associated_V14_over_K_Schur"] is True
    assert model["V14_rational_point_proved"] is False
    assert model["D10_66_line_common_incidence_empty"] is True
    assert model["D12_55_line_common_incidence_empty"] is True
    palatini = decision["full_schur_palatinian"]
    assert palatini["characteristic_zero_B5_lift_verified"] is True
    assert palatini["palatini_equals_unique_invariant_I4"] is True
    assert palatini["degree7_projective_frame_verified"] is True
    assert palatini["constant_coefficient_self_covariants_excluded_through_degree"] == 9
    assert palatini["complete_degree9_self_covariant_dimension"] == 19
    assert palatini["degree9_projective_landing_scheme_empty"] is True
    assert palatini["natural_pencils_checked"] == 10
    assert palatini["canonical_three_frame_generic_curve_genus"] == 3
    assert palatini["canonical_three_frame_ratio_pairs_checked"] == 218596225
    assert palatini["canonical_three_frame_ratio_survivors"] == 0
    assert palatini["invariant_rational_quartic_point_found"] is False
    bridge = decision["fixed_curve_bridge"]
    assert bridge["actual_odd_degree_genus_zero_map_forces_point"] is True
    assert bridge["actual_generalized_twisted_cubic_hilbert_point_forces_point"] is True
    assert bridge["actual_object_constructed"] is False
    assert decision["fibration_pass"] is False
    assert decision["strict_nonclaims"] == [
        "no K_Schur point is constructed",
        "no pointless K_Schur twist is proved",
        "no all-degree 11:5 covariant exclusion is proved beyond the exact degree-1-through-9 range",
        "no local nonpoint is constructed",
        "Problem E remains open",
        (
            "no minimal invariant-field presentation is installed, and the inherited ten "
            "coordinate-fibration comparison is not machine-replayed here; the exact full "
            "coefficient table is not rewritten in minimal invariant coordinates"
        ),
        (
            "the trace exclusions do not cover coordinate sums, the five-coordinate "
            "Laurent-monomial case, or arbitrary elements of E; none of the ten "
            "three-Kummer curves is decided, and the C_012 torsor class is uncomputed"
        ),
        "the Palatini packet gives a point identity but no invariant-rational solution",
    ]
    status = (HERE / "STATUS.md").read_text()
    audit = (HERE / "COMPLETION_AUDIT.md").read_text()
    assert status.startswith("Q-UNDECIDED\n")
    assert "NOT PROVED" in status and "OPEN" not in status.splitlines()[0]
    assert "Q-SCHUR-POINT-HEADLINE-POSITIVE      no" in audit
    assert "Q-SCHUR-POINTLESS-HEADLINE-NEGATIVE no" in audit


def verify_seal() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["schema"] == "q-schur-index-one-seal-v1"
    assert seal["exit"] == "Q-UNDECIDED" and seal["headline"] == "OPEN"
    assert seal["binary_point_proved"] is False
    assert seal["binary_pointlessness_proved"] is False
    assert seal["exact_twist_model_marker"] == "Q_SCHUR_EXACT_FRAME_INDEPENDENT_REPLAY_OK"
    assert seal["a5_valuation_marker"] == "Q_SCHUR_A5_VALUATION_ELIMINATION_OK"
    assert seal["a5_degree11_marker"] == "Q_SCHUR_EFFECTIVE_DEGREE11_ZERO_CYCLE_VERIFIED"
    assert seal["a5_degree11_incidence_marker"] == (
        "A5_DEGREE11_ALL_SIX_SECANT_DESCENT_AUDIT_OK"
    )
    assert seal["a5_rnc_marker"] == "Q_SCHUR_A5_DEGREE11_RNC_INCIDENCE_EXACT"
    assert seal["new_exact_marker"] == "Q_F55_ALL_PROJECTIVE_CHARACTERS_DEGREE_LE_9_EXACT"
    assert seal["three_kummer_laurent_marker"] == (
        "H_TRACE_THREE_KUMMER_LAURENT_MONOMIAL_ALL_EXPONENT_EXCLUSION_OK"
    )
    assert seal["four_kummer_laurent_marker"] == (
        "Q_11_5_FOUR_KUMMER_PACKET_VERIFY_ALL_OK"
    )
    assert seal["plane_012_jacobian_marker"] == "H_TRACE_PLANE_012_FISHER_JACOBIAN_OK"
    assert seal["constant_five_trace_marker"] == (
        "H_TRACE_CONSTANT_FIVE_COORDINATE_TWO_BASIS_EXCLUSION_OK"
    )
    assert seal["c012_oneparam_marker"] == "C012_ONE_PARAMETER_BOUNDED_STOP_OK"
    assert seal["palatini_degree9_marker"] == (
        "FULL_DEGREE9_CHAR0_PALATINI_LANDING_EXCLUSION_REPLAY_OK"
    )
    assert seal["palatini_three_frame_marker"] == (
        "FULL_SCHUR_CANONICAL_THREE_FRAME_SLICE_REPLAY_OK"
    )
    files = durable_files()
    assert seal["file_count"] == len(files)
    assert seal["files"] == files


def main() -> None:
    verify_manifest()
    run_source_replay(
        "goals_2026-08-01/Q_SCHUR_DESCENT/verify_q0.py",
        "Q_SCHUR_Q0_LEDGER_EXACT",
    )
    run_source_replay(
        "goals_2026-08-01/Q_SCHUR_DESCENT/verify_zero_cycle_ledger.py",
        "Q_SCHUR_ZERO_CYCLE_LEDGER_EXACT",
    )
    run_replay(
        "exact_schur_frame/verify_all.py",
        "Q_SCHUR_EXACT_FRAME_PACKET_VERIFY_ALL_OK",
    )
    run_replay(
        "a5_valuation_elimination/verify.py",
        "Q_SCHUR_A5_VALUATION_ELIMINATION_OK",
    )
    run_replay(
        "a5_degree11_cycle_next/verify.py",
        "Q_SCHUR_EFFECTIVE_DEGREE11_ZERO_CYCLE_VERIFIED",
    )
    run_replay(
        "degree11_secant_descent_agent/verify.py",
        "A5_DEGREE11_ALL_SIX_SECANT_DESCENT_AUDIT_OK",
    )
    run_replay(
        "incidence_splitting/verify_a5_rnc_chart.py",
        "Q_SCHUR_A5_DEGREE11_RNC_INCIDENCE_EXACT",
    )
    verify_f55_covariants.main()
    run_replay(
        "f55_degree6_degree7/verify_certificate.py",
        "F55_DEGREE6_DEGREE7_CERTIFICATE_INDEPENDENT_REPLAY_OK",
    )
    run_replay(
        "f55_degree8/verify.py",
        "F55_DEGREE8_SINGLETON_CERTIFICATE_INDEPENDENT_REPLAY_OK",
    )
    run_replay(
        "f55_degree9/verify.py",
        "F55_DEGREE9_SINGLETON_CERTIFICATE_INDEPENDENT_REPLAY_OK",
    )
    run_replay(
        "h_trace_two_laurent/verify.py",
        "H_TRACE_TWO_LAURENT_ALL_EXPONENT_EXCLUSION_OK",
    )
    run_replay(
        "h_trace_fourier_pair_k/verify.py",
        "H_TRACE_FOURIER_TWO_BASIS_FULL_K_NEWTON_EXCLUSION_OK",
    )
    run_replay(
        "h_trace_three_kummer_planes/verify.py",
        "H_TRACE_THREE_KUMMER_TEN_GENERIC_SMOOTH_OK",
    )
    run_replay(
        "h_trace_three_kummer_laurent/verify.py",
        "H_TRACE_THREE_KUMMER_LAURENT_MONOMIAL_ALL_EXPONENT_EXCLUSION_OK",
    )
    run_replay(
        "h_trace_four_kummer_laurent/verify_all.py",
        "Q_11_5_FOUR_KUMMER_PACKET_VERIFY_ALL_OK",
    )
    run_replay(
        "h_trace_plane_012_jacobian/verify.py",
        "H_TRACE_PLANE_012_FISHER_JACOBIAN_OK",
    )
    run_replay(
        "full_trace_tropical_obstruction_next/verify.py",
        "H_TRACE_CONSTANT_FIVE_COORDINATE_TWO_BASIS_EXCLUSION_OK",
    )
    run_replay(
        "c012_oneparam_section_agent/verify.py",
        "C012_ONE_PARAMETER_BOUNDED_STOP_OK",
    )
    run_replay(
        "f55_all_degree_boundary/verify.py",
        "H_TRACE_HILBERT_NEWTON_AUDIT_OK",
    )
    run_replay(
        "schur_enq_v14/verify.py",
        "Q_SCHUR_ENQ_V14_AUDIT_EXACT_NONTERMINAL",
    )
    run_replay(
        "full_schur_palatinian/verify.py",
        "FULL_SCHUR_CHAR0_PALATINI_PACKET_OK",
    )
    run_replay(
        "full_schur_palatinian_point_next/verify_seal.py",
        "FULL_SCHUR_PALATINIAN_POINT_NEXT_STRICT_SEAL_OK",
    )
    run_replay(
        "full_schur_palatinian_point_next/verify.py",
        "FULL_SCHUR_TEN_PENCIL_IRREDUCIBILITY_REPLAY_OK",
    )
    run_replay(
        "full_schur_palatinian_point_next/verify_degree9_projective_emptiness.py",
        "FULL_DEGREE9_CHAR0_PALATINI_LANDING_EXCLUSION_REPLAY_OK",
    )
    run_replay(
        "full_schur_palatinian_point_next/verify_three_frame_slice.py",
        "FULL_SCHUR_CANONICAL_THREE_FRAME_SLICE_REPLAY_OK",
    )
    run_replay(
        "fixed_curve_bridge/verify_bridge_cases.py",
        "Q_SCHUR_FIXED_CURVE_BRIDGE_EXACT",
    )
    verify_decision()
    verify_seal()
    print("PASS immutable source manifest")
    print("PASS requirement-level Q-UNDECIDED decision and strict nonclaims")
    print("PASS SEAL.json binds every durable packet file")
    print("Q_SCHUR_INDEX_ONE_PACKET_VERIFY_ALL_OK")


if __name__ == "__main__":
    main()
