#!/usr/bin/env python3
"""Hash the immutable systematic-module packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = [
    "WORK_SCOPE.md",
    "produce_affine_msolve.py",
    "run_bounded_msolve.py",
    "affine_q0_b1_0_all690.ms",
    "affine_q0_b1_0_all690.json",
    "affine_q0_b1_0_all690.leading",
    "affine_q0_b1_0_all690.log",
    "affine_q0_b1_0_all690.run.json",
    "produce_homogenized_module_jobs.py",
    "systematic_m2_decomposition.npz",
    "systematic_leading_terms.json",
    "systematic_stageB_homogenized_all222.sing",
    "systematic_stageB_homogenized_all222.json",
    "systematic_full28_homogenized_degree8.sing",
    "systematic_full28_homogenized_degree8.json",
    "produce_leading_check.py",
    "systematic_stageB_leading_check.sing",
    "systematic_stageB_leading_check.json",
    "verify_systematic.py",
    "verify_systematic_result.json",
    "run_bounded_singular.py",
    "run_bounded_python.py",
    "profile_degree3_closure.py",
    "degree3_block1.log",
    "degree3_block1.run.json",
    "degree3_full.log",
    "degree3_full.run.json",
    "degree3_pivot_profile.npz",
    "degree3_pivot_profile.json",
    "produce_dprevlex_shifted_job.py",
    "systematic_stageB_hblock_dp_all222.sing",
    "systematic_stageB_hblock_dp_all222.json",
    "systematic_stageB_hblock_dp_leading_check.sing",
    "profile_degree3_dprevlex.py",
    "degree3_dp_full.log",
    "degree3_dp_full.run.json",
    "degree3_dp_pivot_profile.npz",
    "degree3_dp_pivot_profile.json",
    "sample_degree4_dp_pairs.py",
    "degree4_dp_sample8.log",
    "degree4_dp_sample8.run.json",
    "degree4_dp_pair_sample.npz",
    "degree4_dp_pair_sample.json",
    "build_degree4_dp_schedule.py",
    "degree4_dp_schedule.npz",
    "degree4_dp_schedule.json",
    "REPORT.md",
    "make_seal.py",
    "verify_seal.py",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    missing = [name for name in FILES if not (HERE / name).is_file()]
    if missing:
        raise FileNotFoundError(missing)
    payload = {
        "status": "SEALED_SYSTEMATIC_GRADED_PREFLIGHT_NONVERDICT",
        "source_sha256": "6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb",
        "affine_run": {
            "status": "TIMEOUT_NONVERDICT",
            "input_sha256": "14467ceed6e1e8ba991e25a0aebf8fe8cf1f6646dc8cb07ebf9481b06c63b5e3",
            "elapsed_seconds": 600.161296,
            "peak_rss_bytes_polled": 3172761600,
        },
        "systematic_term_order": {
            "status": "PASS_INDEPENDENT_SYSTEMATIC_LEADING_TERMS",
            "unit_columns": 690,
            "free_columns": 87,
            "standard_basis_completed": False,
        },
        "graded_closure": {
            "status": "PASS_EXACT_DEGREE3_PROFILES_AND_DEGREE4_SCHEDULE",
            "first_layer": {
                "same_component_spairs": 10992,
                "residual_standard_rank": 225,
                "pure_m1_cubic_rows": 10767,
            },
            "degree3_Dp": {
                "rank": 10767,
                "degree4_shadow": 143415,
                "degree4_difference_rows": 254964,
                "degree4_standard_columns": 404925,
                "peak_rss_bytes_polled": 3208937472,
            },
            "degree3_dp": {
                "rank": 10767,
                "degree4_shadow": 232326,
                "degree4_difference_rows": 166053,
                "degree4_standard_columns": 316014,
                "peak_rss_bytes_polled": 4482547712,
            },
            "degree4_schedule": {
                "all_prolongations": 398379,
                "product_fibers": 232326,
                "star_tree_difference_rows": 166053,
                "row_space_coverage_verified": True,
            },
            "degree4_bounded_sample": {
                "pairs": 8,
                "peak_rss_bytes_polled": 2440871936,
                "dense_uint8_rectangle_bytes": 52475072742,
                "dense_modular_double_rectangle_bytes": 419800581936,
                "full_coefficient_reduction_completed": False,
            },
        },
        "files": {
            name: {"bytes": (HERE / name).stat().st_size, "sha256": sha256(HERE / name)}
            for name in FILES
        },
        "scope": (
            "Exact prepared route, streamed degree-three profiles, compact "
            "degree-four schedule, and bounded nonverdict traces only; no "
            "degree-four coefficient rank, target membership, Stage-B, Stage-C, "
            "or P25 terminal verdict."
        ),
    }
    target = HERE / "SEAL.json"
    target.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
