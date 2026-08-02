#!/usr/bin/env python3
"""Write a deterministic size/SHA-256 inventory for this investigation."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
P3 = HERE.parent / "stageb_global_basis" / "full_p3_contractions.npy"
RELATION = Path(
    "/Users/worker/unirational/problems/E-klein-cubic/"
    "certificates/degree25_finite_module/relation_matrix.npz"
)

LOCAL_FILES = [
    "WORK_SCOPE.md",
    "REPORT.md",
    "analyze_affine_profiles.py",
    "affine_rank_profiles.json",
    "produce_affine_border.py",
    "axis0_selected_rows.npy",
    "axis0_low_inverse.npy",
    "axis0_border_tails.npy",
    "axis0_border_packet.npz",
    "axis0_border_manifest.json",
    "reduce_affine_border.py",
    "axis0_border_reduction.npz",
    "axis0_border_reduction.json",
    "produce_direct_module_singular.py",
    "direct_axis0_component0_degree5.sing",
    "direct_axis0_component0_degree5.json",
    "run_bounded_singular.py",
    "direct_axis0_component0_degree5.log",
    "direct_axis0_component0_degree5.run.json",
    "verify_affine_border.py",
    "verify_affine_border_result.json",
    "make_seal.py",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def record(path: Path, display: str) -> dict[str, object]:
    if not path.is_file():
        raise FileNotFoundError(path)
    return {
        "path": display,
        "bytes": path.stat().st_size,
        "sha256": sha256(path),
    }


def main() -> None:
    payload = {
        "status": "SEALED_EXACT_NONVERDICT_PACKET",
        "prime": 89,
        "verdict": "PURE_POWER_MEMBERSHIP_UNDECIDED",
        "external_inputs": [
            record(P3, "../stageb_global_basis/full_p3_contractions.npy"),
            record(RELATION, str(RELATION)),
        ],
        "local_files": [record(HERE / name, name) for name in LOCAL_FILES],
        "deliberately_absent": ["direct_axis0_component0_degree5.result"],
        "scope": (
            "Exact affine-border construction and bounded direct-test record. "
            "The packet contains no membership or nonmembership verdict."
        ),
    }
    (HERE / "SEAL.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()
