#!/usr/bin/env python3
"""Create the deterministic manifest for the complement-strategy audit."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent

ARTIFACTS = [
    "REPORT.md",
    "audit_inputs.py",
    "audit_result.json",
    "analyze_faithful_segre.py",
    "free_minor_union.cpp",
    "free_minor_union",
    "faithful_kernel_basis.npy",
    "faithful_cell_free_ids.raw",
    "faithful_free_minor_components.raw",
    "faithful_segre_free_block.json",
    "audit_free_quotient.py",
    "canonical_free_quotient_result.json",
    "faithful_segre_dimension_audit.py",
    "faithful_segre_dimension_result.json",
    "produce_affine_augmented_module.py",
    "run_bounded.py",
    "affine_q0_r64_augmented_module.sing",
    "affine_q0_r64_augmented_module.json",
    "affine_q0_r64_augmented_module.superseded.log",
    "make_seal.py",
    "verify_seal.py",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    missing = [name for name in ARTIFACTS if not (ROOT / name).is_file()]
    if missing:
        raise SystemExit(f"missing sealed artifacts: {missing}")

    audit = json.loads((ROOT / "audit_result.json").read_text())
    free = json.loads((ROOT / "faithful_segre_free_block.json").read_text())
    quotient = json.loads((ROOT / "canonical_free_quotient_result.json").read_text())
    dimensions = json.loads(
        (ROOT / "faithful_segre_dimension_result.json").read_text()
    )
    q0 = json.loads((ROOT / "affine_q0_r64_augmented_module.json").read_text())

    manifest = {
        name: {
            "bytes": (ROOT / name).stat().st_size,
            "sha256": sha256(ROOT / name),
        }
        for name in ARTIFACTS
    }

    seal = {
        "schema": "P25_COMPLEMENT_STRATEGY_SEAL_V1",
        "date": "2026-08-01",
        "prime": 89,
        "status": "P25_COMPLEMENT_STRATEGY_UNDECIDED_EXACT_AUDIT",
        "global_theorem_status": "P25-UNDECIDED",
        "exact_conclusions": {
            "closed_L8_stageB_empty": audit["exact_checks"][
                "closed_L8_stageB_exact_empty"
            ],
            "closed_L8_stageC_empty": audit["exact_checks"][
                "closed_L8_stageC_exact_empty"
            ],
            "old_r48_retired_on_H8_complement": {
                "point": "q=e12",
                "P3_rank": 4,
                "P3_target_rank": 6,
                "augmented_rank": 4,
                "augmented_target_rank": 7,
                "stageB_witness_b1": audit["exact_checks"][
                    "old_r48_e12_stageB_kernel_witness_b1"
                ],
                "normalized_stageC_witness_b1": audit["exact_checks"][
                    "old_r48_e12_normalized_stageC_witness_b1"
                ],
                "meaning": (
                    "These are exact points of the compressed r48 necessary "
                    "systems, not points of the full landing incidence."
                ),
            },
            "r64_viable_cover": {
                "charts": audit["H8_coordinates"],
                "chart_count": len(audit["H8_coordinates"]),
                "criterion": q0["criterion"],
                "completed_unit_charts_in_this_packet": 0,
            },
            "faithful_stageA_plus_B_free_block": {
                "all_free_minor_rank": free["free_minor_block"][
                    "successful_unions"
                ],
                "all_free_quotient_dimension": quotient["quotient_dimension"],
            },
            "quadratic_full_span_refuted": {
                "stageA_plus_B_degree_two_lower_bound": dimensions[
                    "stageA_plus_B_faithful_W"
                ]["degree_two_quotient_lower_bound"],
                "all_stages_degree_two_lower_bound": dimensions[
                    "all_stages_faithful_W3"
                ]["degree_two_quotient_lower_bound"],
                "meaning": (
                    "Failure of quadratic full span is not a landing point and "
                    "does not prove nonemptiness."
                ),
            },
        },
        "resource_floor": {
            "canonical_mu_shape": [3_233_097, 3_446_550],
            "raw_product_terms": 14_673_616_695,
            "coefficient_bytes_lower_bound": 14_673_616_695,
            "ordinary_CSR_estimate_bytes": 73_368_083_475,
            "residual_columns": 2_534_087,
            "maximum_residual_rank": 2_509_835,
            "degree_three_ambient_dimension": 767_100_243,
            "conclusion": (
                "No deterministic sub-8-GiB, sub-10-minute exact higher-degree "
                "certificate route was identified."
            ),
        },
        "input_bindings": audit["inputs"],
        "replay_markers": [
            audit["status"],
            free["status"],
            quotient["status"],
            dimensions["status"],
            "PASS_COMPLEMENT_STRATEGY_SEAL",
        ],
        "scope_guard": {
            "proved": (
                "old-r48 retirement; closed-L8 bindings; exact faithful-Segre "
                "free block and Koszul dimension obstructions"
            ),
            "not_proved": (
                "any r64 chart unit result; Stage B/C emptiness on D(H8); "
                "global degree-25 emptiness; characteristic-zero covariant"
            ),
        },
        "artifact_manifest": manifest,
    }

    (ROOT / "SEAL.json").write_text(
        json.dumps(seal, indent=2, sort_keys=True) + "\n"
    )
    print("WROTE_SEAL", ROOT / "SEAL.json")


if __name__ == "__main__":
    main()
