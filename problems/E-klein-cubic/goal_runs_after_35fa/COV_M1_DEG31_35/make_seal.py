#!/usr/bin/env python3
"""Generate the content-only seal for the accepted COV.2 packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent

ROOT_FILES = [
    "assemble_d31_third_pure_msolve.py",
    "assemble_c3_deep_gate.py",
    "assemble_c3_second_normal_gate.py",
    "COMPLETION_AUDIT.md",
    "EXIT.json",
    "FINAL_FILES.txt",
    "INPUTS.json",
    "README.md",
    "REQUIREMENTS.md",
    "STATUS.md",
    "VERIFY_LOG.txt",
    "c3_constant_gate.json",
    "c3_constant_gate_probe_p463.json",
    "c3_constant_gate_probe_p727.json",
    "c3_deep_normal_gate.json",
    "c3_first_normal_gate.json",
    "c3_first_normal_reduced_landing.json",
    "c3_reduced_landing.json",
    "c3_second_normal_gate.json",
    "c3_third_based_reduced_landing.json",
    "canonical_bases.json",
    "combine_c3_first_normal_gate.py",
    "combine_c3_first_normal_nonbased_tangent_gate.py",
    "combine_c3_second_mixed_nonbased_tangent_gate.py",
    "combine_c3_fourth_normal_gate.py",
    "combine_c3_third_normal_gate.py",
    "combine_c3_third_mixed_nonbased_tangent_gate.py",
    "dual_hironaka_generators.json",
    "d31_third_pure_msolve.json",
    "export_d31_third_pure_msolve.py",
    "export_invariant_generators.py",
    "invariant_generators.json",
    "landing_ideals.json",
    "make_seal.py",
    "ordered_equalizers.json",
    "p25_dependency_localization.json",
    "primitive_module.json",
    "primitive_quotient_counterexample.json",
    "probe_c3_first_normal_gate.py",
    "probe_c3_fourth_mixed_gate.py",
    "probe_c3_fourth_normal_gate.py",
    "probe_c3_second_mixed_gate.py",
    "probe_c3_second_normal_gate.py",
    "probe_c3_third_mixed_gate.py",
    "probe_c3_third_normal_gate.py",
    "probe_c3_constant_gate.py",
    "probe_d31_deep_cubic_span.py",
    "probe_d35_deep_cubic_span.py",
    "probe_cubic_scalar_cubes.py",
    "fflas_rank_u16.cpp",
    "produce_cross_basis.py",
    "produce_landing_circuits.py",
    "produce_landing_ideal.py",
    "produce_ordered_equalizer.py",
    "produce_p25_dependency_localization.py",
    "produce_primitive_counterexample.py",
    "produce_primitive_module.py",
    "reduce_landing_by_c3.py",
    "reduce_landing_by_first_normal.py",
    "reduce_landing_by_second_normal.py",
    "select_common_invariant_frame.py",
    "verify_all.py",
    "degree_25_fixed_k1_basis.json",
]
DEGREE_FILES = [
    "basis_holdout_p419.npz",
    "basis_holdout_p463.npz",
    "fixed_invariant_multiple_basis.json",
    "full_reynolds_circuits.json",
    "landing_ideal_p419.json",
    "landing_ideal_p463.json",
    "landing_ideal_circuits.json",
    "landing_circuits_p419.npz",
    "landing_circuits_p463.npz",
    "landing_nodes_p419.npz",
    "landing_nodes_p463.npz",
    "m1_cross_basis_circuits.json",
    "ordered_equalizer.json",
    "positive_multiples_p419.npz",
    "positive_multiples_p463.npz",
    "c3_constant_gate_p463.npz",
    "c3_constant_gate_p727.npz",
    "c3_reduced_landing_p463.json",
    "c3_reduced_landing_p463.npz",
    "c3_first_normal_exp0_p463.npz",
    "c3_first_normal_exp0_p727.npz",
    "c3_first_normal_reduced_landing_p463.json",
    "c3_first_normal_reduced_landing_p463.npz",
    "c3_second_normal_exp0_p463.npz",
    "c3_second_normal_exp0_p727.npz",
    "c3_second_normal_exp2_p463.npz",
    "c3_second_normal_exp2_p727.npz",
    "c3_second_mixed_p463.npz",
    "c3_second_mixed_p727.npz",
    "c3_third_based_reduced_landing_p463.json",
    "c3_third_based_reduced_landing_p463.npz",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    paths = ROOT_FILES + [
        f"degree_{degree}/{name}"
        for degree in (31, 35)
        for name in DEGREE_FILES
    ]
    paths.append("degree_35/invariant_frame_points.json")
    paths.extend([
        "degree_31/c3_first_normal_exp2_p463.npz",
        "degree_31/c3_first_normal_exp2_p727.npz",
        "degree_35/c3_first_normal_exp2_dir0_p463.npz",
        "degree_35/c3_first_normal_exp2_dir0_p727.npz",
        "degree_35/c3_first_normal_exp2_dir1_p463.npz",
        "degree_35/c3_first_normal_exp2_dir1_p727.npz",
        "degree_31/c3_third_normal_exp0_p463.npz",
        "degree_31/c3_third_normal_exp0_p727.npz",
        "degree_31/c3_third_normal_exp2_p463.npz",
        "degree_31/c3_third_normal_exp2_p727.npz",
        "degree_31/c3_third_mixed_p463.npz",
        "degree_31/c3_third_mixed_p727.npz",
        "degree_31/c3_second_mixed_nonbased_tangent_p463.npz",
        "degree_31/c3_second_mixed_nonbased_tangent_p727.npz",
        "degree_31/d31_deep_cubic_span_p463.npz",
        "degree_31/d31_third_pure_scalar_cubes_p463.npz",
        "degree_31/d31_third_pure_scalar_cubes_p463.bin.rows",
        "degree_31/d31_third_pure_chart0_p463.msolve.out",
        "degree_31/d31_third_pure_chart1_p463.msolve.out",
        "degree_31/p25_multiplier_embedding_p463.npz",
        "degree_31/p25_multiplier_embedding_p727.npz",
        "degree_35/c3_third_normal_exp0_p463.npz",
        "degree_35/c3_third_normal_exp0_p727.npz",
        "degree_35/c3_third_normal_exp2_p463.npz",
        "degree_35/c3_third_normal_exp2_p727.npz",
        "degree_35/c3_third_mixed_p463.npz",
        "degree_35/c3_third_mixed_p727.npz",
        "degree_35/c3_second_mixed_nonbased_tangent_p463.npz",
        "degree_35/c3_second_mixed_nonbased_tangent_p727.npz",
        "degree_35/c3_third_mixed_nonbased_tangent_p463.npz",
        "degree_35/c3_third_mixed_nonbased_tangent_p727.npz",
        "degree_35/c3_fourth_normal_exp0_p463.npz",
        "degree_35/c3_fourth_normal_exp0_p727.npz",
        "degree_35/c3_fourth_normal_exp2_p463.npz",
        "degree_35/c3_fourth_normal_exp2_p727.npz",
        "degree_35/c3_fourth_mixed_p463.npz",
        "degree_35/c3_fourth_mixed_p727.npz",
        "degree_35/d35_deep_cubic_span_p463.npz",
        "degree_35/p25_multiplier_embedding_p463.npz",
        "degree_35/p25_multiplier_embedding_p727.npz",
    ])
    paths = sorted(paths)
    (HERE / "FINAL_FILES.txt").write_text(
        "\n".join(sorted([*paths, "SEAL.json"])) + "\n"
    )
    missing = [path for path in paths if not (HERE / path).is_file()]
    if missing:
        raise FileNotFoundError(f"missing accepted artifacts: {missing}")
    seal = {
        "schema": "cov-m1-content-seal-v1",
        "exit": "COV-UNDECIDED",
        "pinned_state": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "theorem_boundary": (
            "Fixed characteristic-zero K1 bases, the ordered literal-global "
            "equalizer, the standard module quotient bounds, and complete "
            "landing ideals are certified, including empty deepest C3-normal "
            "tails and two empty degree-31 pure-third charts only in the "
            "special fibre over F_463. The characteristic-zero cover, the "
            "remaining affine chart saturations and the now-localized "
            "P25.2-dependent landing decision remain open."
        ),
        "files": [
            {"path": path, "sha256": sha256(HERE / path)} for path in paths
        ],
    }
    (HERE / "SEAL.json").write_text(
        json.dumps(seal, indent=2, sort_keys=True) + "\n"
    )
    print(f"SEALED {len(paths)} FILES")


if __name__ == "__main__":
    main()
