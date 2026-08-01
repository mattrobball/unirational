#!/usr/bin/env python3
"""Seal every durable packet artifact at its exact nonterminal scope."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


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


def main() -> None:
    files = durable_files()
    seal = {
        "schema": "q-schur-index-one-seal-v1",
        "packet": "Q_SCHUR_INDEX_ONE",
        "exit": "Q-UNDECIDED",
        "headline": "OPEN",
        "binary_point_proved": False,
        "binary_pointlessness_proved": False,
        "pinned_repository_state": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "live_head_audited": "37d61c19a108781cf74af837e24810a9f7f7c3be",
        "goal_sha256": "e5600e7f41e0744e05c5dd961a0eda9f7a26f5d908b71d590a343b5c0b1446d9",
        "new_exact_marker": "Q_F55_ALL_PROJECTIVE_CHARACTERS_DEGREE_LE_8_EXACT",
        "exact_twist_model_marker": "Q_SCHUR_EXACT_FRAME_INDEPENDENT_REPLAY_OK",
        "file_count": len(files),
        "files": files,
        "strict_scope": (
            "This seal authenticates a Q-UNDECIDED packet and a complete "
            "degree-1-through-8 all-character 11:5 exclusion, the exact "
            "all-degree boundary, the nonterminal ENQ--V14 audit, and the "
            "exact Hilbert--90 frame/full cubic coefficient table only."
        ),
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print(f"sealed {len(files)} files")
    print("Q_SCHUR_INDEX_ONE_NONTERMINAL_SEAL_WRITTEN")


if __name__ == "__main__":
    main()
