#!/usr/bin/env python3
"""Replay the isolated root worker's exact honest-stop boundary."""

from __future__ import annotations

from pathlib import Path
import hashlib
import json
import subprocess
import sys


HERE = Path(__file__).resolve().parent
PARENT = HERE.parent


def run(command: list[str], cwd: Path) -> str:
    return subprocess.run(
        command,
        cwd=cwd,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
        timeout=600,
    ).stdout


def main() -> None:
    assert (HERE / "STATUS.md").read_text().splitlines()[0] == "F-UNDECIDED"
    audit = (HERE / "SOURCE_VALUATION_AUDIT.md").read_text()
    for phrase in (
        "do not change the binding exit",
        "six cubic remainder",
        "alternative sufficient completion",
    ):
        assert phrase in audit

    stabilizer = run(
        [sys.executable, str(HERE / "verify_source_hyperplane_stabilizer.py")],
        HERE,
    )
    assert "SOURCE_HYPERPLANE_STABILIZER_TRIVIAL_660_ACCEPT" in stabilizer
    assert "SOURCE_HYPERPLANE_MEETS_F3_F5_OPEN_ACCEPT" in stabilizer

    parent = run([sys.executable, str(PARENT / "verify.py")], PARENT)
    assert "GOAL_F_EXACT_FIELD_LAYER_ACCEPT" in parent
    assert "GOAL_F_UNDECIDED_BOUNDARY_ACCEPT" in parent

    seal_path = HERE / "SEAL.json"
    if seal_path.exists():
        seal = json.loads(seal_path.read_text())
        assert seal["exit"] == "F-UNDECIDED"
        for relative, expected in seal["sha256"].items():
            actual = hashlib.sha256((HERE / relative).read_bytes()).hexdigest()
            assert actual == expected, relative

    print("ROOT_SOURCE_HYPERPLANE_SCOPE_ACCEPT")
    print("ROOT_GOAL_F_UNDECIDED_AUDIT_ACCEPT")


if __name__ == "__main__":
    main()
