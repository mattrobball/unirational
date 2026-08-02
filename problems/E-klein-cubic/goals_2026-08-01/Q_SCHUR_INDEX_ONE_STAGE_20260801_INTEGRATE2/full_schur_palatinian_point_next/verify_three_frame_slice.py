#!/usr/bin/env python3
"""Independent replay of the canonical three-frame slice packet."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess

import three_frame_slice_geometry as geometry


HERE = Path(__file__).resolve().parent
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
PYTHON = "/opt/homebrew/bin/python3"
CERTIFICATE = HERE / "three_frame_slice_certificate.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(path: Path, marker: str) -> None:
    process = subprocess.run(
        [PYTHON, "-u", str(path)], cwd=path.parent,
        text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        check=False,
    )
    assert process.returncode == 0, process.stdout
    assert marker in process.stdout, process.stdout
    print(process.stdout, end="")


def main() -> None:
    frozen = json.loads(CERTIFICATE.read_text())
    for relative, expected in frozen["local_source_sha256"].items():
        assert sha256(HERE / relative) == expected, relative
    for relative, expected in frozen["external_source_sha256"].items():
        assert sha256(ROOT / relative) == expected, relative
    print("PASS frozen local and external source hashes")

    run(HERE / "verify_seal.py", "FULL_SCHUR_PALATINIAN_POINT_NEXT_STRICT_SEAL_OK")
    run(
        HERE / "verify_three_frame_slice_seal.py",
        "FULL_SCHUR_CANONICAL_THREE_FRAME_SLICE_SEAL_OK",
    )
    run(
        ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian/"
        "verify_char0_palatinian_lift.py",
        "CHAR0_PALATINI_EQUALS_REYNOLDS_I4_LIFT_OK",
    )

    regenerated = geometry.produce()
    assert regenerated == frozen
    assert frozen["selected_triple"] == [0, 1, 5]
    assert frozen["all_coordinate_triples"] == {
        "count": 20,
        "specializations_per_triple": 12,
        "irreducible_over_F23": 240,
        "total_specializations": 240,
    }
    selected = frozen["selected_slice"]
    assert selected["irreducible_specializations"] == 12
    assert selected["smooth_specializations"] == 12
    assert selected["witness_specialized_point"] == [1, 0, 0]
    search = frozen["low_complexity_invariant_ratio_search"]
    assert search["candidate_function_behaviors_after_deduplication"] == 14785
    assert search["eligible_pairs_defined_on_at_least_six_common_samples"] == 218596225
    assert search["survivor_count"] == 0
    print("PASS exact factor, projective smoothness, CRT basis, and invariant-ratio reconstruction")
    print("FULL_SCHUR_CANONICAL_THREE_FRAME_SLICE_REPLAY_OK")
    print("SCOPE: generic genus-three nonparametrization and bounded ratio search; no K_Schur point verdict")


if __name__ == "__main__":
    main()
