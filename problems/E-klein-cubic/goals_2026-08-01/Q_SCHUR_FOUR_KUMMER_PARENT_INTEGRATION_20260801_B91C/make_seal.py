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
        "exact_twist_model_marker": "Q_SCHUR_EXACT_FRAME_INDEPENDENT_REPLAY_OK",
        "a5_valuation_marker": "Q_SCHUR_A5_VALUATION_ELIMINATION_OK",
        "new_exact_marker": "Q_F55_ALL_PROJECTIVE_CHARACTERS_DEGREE_LE_9_EXACT",
        "three_kummer_laurent_marker": (
            "H_TRACE_THREE_KUMMER_LAURENT_MONOMIAL_ALL_EXPONENT_EXCLUSION_OK"
        ),
        "four_kummer_laurent_marker": "Q_11_5_FOUR_KUMMER_PACKET_VERIFY_ALL_OK",
        "plane_012_jacobian_marker": "H_TRACE_PLANE_012_FISHER_JACOBIAN_OK",
        "file_count": len(files),
        "files": files,
        "strict_scope": (
            "This seal authenticates a Q-UNDECIDED packet, an exact "
            "genuine-Schur Hilbert--90 frame and complete cubic table, a "
            "functorial elimination of both maximal A5 valuation classes, a "
            "degree-1-through-9 all-character 11:5 exclusion, four exact "
            "sparse trace-ansatz exclusions, ten exact three-Kummer genus-one "
            "frontiers, the exact C_012 Jacobian, the all-degree boundary, "
            "the Palatini model, fixed-curve bridge, and the nonterminal "
            "ENQ--V14 audit only."
        ),
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print(f"sealed {len(files)} files")
    print("Q_SCHUR_INDEX_ONE_NONTERMINAL_SEAL_WRITTEN")


if __name__ == "__main__":
    main()
