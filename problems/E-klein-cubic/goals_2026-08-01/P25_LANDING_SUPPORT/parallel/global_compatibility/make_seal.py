#!/usr/bin/env python3
"""Hash the exact global-compatibility packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
OUTPUT = HERE / "SEAL.json"
FILES = [
    ".gitignore",
    "WORK_SCOPE.md",
    "REPORT.md",
    "augmented_coordinate_line_certificate.json",
    "augmented_coordinate_line_minors.npz",
    "b_pencil_common_profile.json",
    "b_star_line_job.json",
    "certify_b_star_lines.py",
    "certify_single_b_support.py",
    "direct_690_all_222_degree5.json",
    "direct_690_all_222_degree5.sing",
    "direct_full690_all28_degree8.json",
    "direct_full690_all28_degree8.sing",
    "explore_b_pencil_profiles.py",
    "make_seal.py",
    "produce_all_pure_power_job.py",
    "produce_augmented_coordinate_lines.py",
    "produce_full28_degree8_job.py",
    "run_immutable_singular.py",
    "single_b_support_certificate.json",
    "single_b_support_minors.npz",
    "singular_weighted_syntax_smoke.result",
    "singular_weighted_syntax_smoke.sing",
    "support_augmented_r66_stageBC.npz",
    "verify_all_pure_power_job.py",
    "verify_all_pure_power_job_result.json",
    "verify_augmented_coordinate_lines.py",
    "verify_augmented_coordinate_lines_result.json",
    "verify_full28_degree8_job.py",
    "verify_full28_degree8_job_result.json",
    "verify_seal.py",
    "verify_single_b_support.py",
    "verify_single_b_support_result.json",
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
        "status": "P25-UNDECIDED",
        "scope": (
            "Exact q-coordinate-line augmented rank and b-support-one Stage-B "
            "exclusion; uncompleted exact b-pencil and prepared but unrun "
            "direct weighted jobs."
        ),
        "files": {name: sha256(HERE / name) for name in FILES},
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps({"status": "PASS_SEAL_WRITTEN", "files": len(FILES)}, sort_keys=True))


if __name__ == "__main__":
    main()
