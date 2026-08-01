#!/usr/bin/env python3
"""Seal every durable artifact in the scoped COV result packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
PINNED = "715faf441289e2589b9325311b6613ea0331bf88"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def included_files() -> list[Path]:
    return sorted(
        path
        for path in HERE.rglob("*")
        if path.is_file()
        and path.name != "SEAL.json"
        and "__pycache__" not in path.parts
    )


def main() -> None:
    consumed_head = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=HERE, text=True
    ).strip()
    hashes = {str(path.relative_to(HERE)): sha256(path) for path in included_files()}
    payload = {
        "schema": "COV_STRUCTURED_SEARCH_SEAL_V1",
        "exit": "COV-STRUCTURED-DEGREES-EMPTY-SCOPED",
        "headline": "OPEN",
        "positive_mission_achieved": False,
        "pinned_mathematical_baseline": PINNED,
        "consumed_repository_head": consumed_head,
        "selected_pairs": [
            {"degree": 25, "plane_order": 3, "residual_degree": 7, "dimension": 0},
            {"degree": 31, "plane_order": 5, "residual_degree": 1, "dimension": 0},
            {"degree": 35, "plane_order": 5, "residual_degree": 5, "dimension": 0},
        ],
        "scope_exclusion": (
            "no nonzero global covariant in the selected m>=3 residual families; "
            "m=1 branches, whole-degree landing schemes, the all-degree question, "
            "and the unirationality headline are not decided"
        ),
        "decision_primes": {
            "global_jets_discovery": 67,
            "global_jets_characteristic_zero_minor_holdout": 89,
            "sparse_family": [89, 199],
            "independent_molien": [199, 353],
        },
        "replay": [
            "/opt/homebrew/bin/python3 -u verify_all.py",
        ],
        "files": hashes,
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"sealed_files={len(hashes)}")
    print("COV_SEAL_PRODUCED")


if __name__ == "__main__":
    main()
