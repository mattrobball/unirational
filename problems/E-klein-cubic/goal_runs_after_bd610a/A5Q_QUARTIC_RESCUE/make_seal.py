#!/usr/bin/env python3
"""Create or check the content seal for the A5Q quartic-rescue packet."""

from __future__ import annotations

import argparse
from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"

REQUIRED = {
    "CHARACTERISTIC_ZERO_LIFT.md",
    "COMPLETION_AUDIT.md",
    "FIELD_L1.json",
    "FIELD_L2.json",
    "INDEX11_POINT_CLASS1.json",
    "INDEX11_POINT_CLASS2.json",
    "INPUT_MANIFEST.json",
    "INTERPOLATION_INCIDENCE.md",
    "REPLAY.md",
    "RESIDUAL_IDENTITY.md",
    "STATUS.md",
    "SUBGROUP_DESCENT.md",
    "VARIANTS.md",
    "discover_modular_index11.py",
    "make_seal.py",
    "modular_index11_discovery.json",
    "produce_packet_artifacts.py",
    "verify_all.py",
}


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def durable_files():
    return sorted(
        path
        for path in HERE.iterdir()
        if path.is_file()
        and path.name != SEAL.name
        and not path.name.startswith(".")
        and path.suffix != ".pyc"
    )


def payload():
    files = durable_files()
    names = {path.name for path in files}
    missing = sorted(REQUIRED - names)
    if missing:
        raise SystemExit(f"required files missing: {missing}")
    return {
        "format": "a5q-quartic-rescue-seal-v1",
        "binding_goal": (
            "goals_after_bd610a/GOAL_A5Q_INDEX11_QUARTIC_RESCUE.md"
        ),
        "pinned_state": "bd610a032bb9561d2daeb91a2cb60c48c082ca2f",
        "scope": (
            "two exact transported index-11 points and full degree-four "
            "interpolation emptiness for those points only"
        ),
        "terminal_markers": [
            "A5Q_INDEX11_CLOSED_POINT_OK",
            "A5Q-INDEX11-CLOSED-POINT-PASS",
            "A5Q-DEGREE4-RESCUE-EMPTY-SCOPED",
        ],
        "files": {
            path.name: {"sha256": digest(path), "bytes": path.stat().st_size}
            for path in files
        },
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    current = payload()
    if args.check:
        if not SEAL.is_file():
            raise SystemExit("SEAL.json is missing")
        recorded = json.loads(SEAL.read_text())
        if recorded != current:
            raise SystemExit("SEAL_MISMATCH")
        print("A5Q_SEAL_OK")
        return
    SEAL.write_text(json.dumps(current, indent=2, sort_keys=True) + "\n")
    print("A5Q_SEAL_WRITTEN")


if __name__ == "__main__":
    main()
