#!/usr/bin/env python3
"""Seal the load-bearing files of the terminal P25 packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
REQUIRED = [
    "STATUS.md",
    "SUPPORT.md",
    "candidate_or_empty.json",
    "WORK_SCOPE.md",
    "ACCEPTANCE_AUDIT.md",
    "PREFLIGHT.md",
    "NONVERDICT_RUNS.md",
    "saturation_attempts.json",
    "produce_linear_syzygies.py",
    "produce_syzygy_charts.py",
    "produce_syzygy_singular.py",
    "produce_syzygy_bcharts.py",
    "reconstruct_syzygies96.py",
    "verify_syzygy_empty.py",
    "verify_undecided.py",
    "run_singular.py",
    "verify_seal.py",
    "make_seal.py",
    "syzygy_r48_q0_contracted.npz",
    "syzygy_r48_q0.json",
    "linear_syzygies.npz",
    "linear_syzygies.json",
    "syzygy_r256_q0_contracted.npz",
    "syzygy_r256_q0.json",
    "linear_syzygies_r48_reconstructed.npz",
    "syzygy_reconstruction_replay.log",
    "stageA_replay.log",
    "stageA_replay_result.json",
    "rowrank_replay.log",
    "rowrank_replay_report.json",
    "border_replay.log",
    "dvr_replay.log",
    "syzygy_r43_boundary_saturate.sing",
    "syzygy_r43_boundary_singular.json",
    "syzygy_r96_boundary_saturate.sing",
    "syzygy_r96_boundary_singular.json",
    "syzygy_r256_boundary_saturate.sing",
    "syzygy_r256_boundary_singular.json",
    "verify_undecided_result.json",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    missing = [name for name in REQUIRED if not (HERE / name).is_file()]
    if missing:
        raise SystemExit(f"cannot seal; missing {missing}")
    payload = {
        "exit": "P25-UNDECIDED",
        "scope": (
            "honest stop: Stage B saturated incidence unresolved; no degree-25 "
            "positive or negative theorem; headline remains OPEN"
        ),
        "files": {
            name: {
                "bytes": (HERE / name).stat().st_size,
                "sha256": sha256(HERE / name),
            }
            for name in REQUIRED
        },
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"sealed {len(REQUIRED)} files")


if __name__ == "__main__":
    main()
