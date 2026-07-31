#!/usr/bin/env python3
"""T8-N1 producer seal. Does not import the verifier."""
from __future__ import annotations

import json
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]

REQUIRED = [
    "JACOBIAN_CORRECTION.md",
    "DEFLATED_SYSTEM.md",
    "HENSEL_AND_LIFT_STATUS.md",
    "NONUNIT_CONTINUATION.md",
    "RESULT.md",
    "exit_t8n1.json",
    "modular_audit.json",
    "verify_t8n1.py",
]


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def main() -> None:
    for name in REQUIRED:
        assert (HERE / name).is_file(), name

    exit_data = json.loads((HERE / "exit_t8n1.json").read_text())
    assert exit_data["exit"] == "T8-N1-UNDECIDED"
    assert exit_data["headline"] == "OPEN"

    result = (HERE / "RESULT.md").read_text()
    assert "T8-N1-UNDECIDED" in result
    assert "OPEN" in result
    assert "JACOBIAN" in result.upper() or "Jacobian" in result

    # Self-hashes of sealed narrative (write last-style: recompute now)
    hashes = {name: file_hash(HERE / name) for name in REQUIRED if name.endswith(".md") or name.endswith(".json") or name.endswith(".py")}
    seal = {
        "schema": "klein-cubic-T8N1-seal-v1",
        "exit": "T8-N1-UNDECIDED",
        "headline": "OPEN",
        "file_sha256": hashes,
        "terminal_marker": "FOLD_DECISION_T8N1_PRODUCER_SEALED",
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")
    print("FOLD_DECISION_T8N1_PRODUCER_SEALED")
    print("exit: T8-N1-UNDECIDED")


if __name__ == "__main__":
    main()
