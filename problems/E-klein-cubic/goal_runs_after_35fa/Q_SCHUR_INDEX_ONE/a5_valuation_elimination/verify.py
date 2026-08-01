#!/usr/bin/env python3
"""Independent source-bound replay of the A5 valuation refinement."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent


def repository_root() -> Path:
    for candidate in HERE.parents:
        if (candidate / "SPEC.md").is_file() and (candidate / "certificates").is_dir():
            return candidate
    raise AssertionError("Problem E repository root not found")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def replay(command: list[str], cwd: Path, marker: str) -> None:
    completed = subprocess.run(
        command,
        cwd=cwd,
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
    )
    assert marker in completed.stdout, completed.stdout
    print(completed.stdout, end="")


def main():
    root = repository_root()
    manifest = json.loads((HERE / "source_manifest.json").read_text())
    for relative, expected in manifest["sources"].items():
        assert sha256(root / relative) == expected, relative

    status = (HERE / "imports" / "H_A5_STATUS.md").read_text()
    point1 = (HERE / "imports" / "A5_class_1_POINT.md").read_text()
    point2 = (HERE / "imports" / "A5_class_2_POINT.md").read_text()
    valuation = (HERE / "imports" / "LOW_RANK_VALUATION_THEOREM.md").read_text()
    assert "H-A5-CLASS1-RATIONAL-POINT" in status
    assert "H-A5-CLASS2-RATIONAL-POINT" in status
    assert "degree-11" in point1 and "degree-11" in point2
    assert "maximal `A5`" in valuation and "maximal `11:5`" in valuation

    a5 = root / "goal_runs_after_35fa" / "H_A5_TWISTS"
    replay(
        [sys.executable, str(a5 / "common" / "verify_exact_points_direct.py")],
        a5,
        "H3_EXACT_BOTH_A5_POINTS_VERIFIED",
    )
    valuation_dir = (
        root / "goals_2026-08-01" / "G_ALL_DEGREE" / "attacks" /
        "low_rank_valuations_v2"
    )
    replay(
        [sys.executable, str(valuation_dir / "verify.py")],
        valuation_dir,
        "G_LOW_RANK_C1_RESIDUE_LOCAL_SOLUBILITY_EXACT",
    )

    theorem = (HERE / "THEOREM.md").read_text()
    status_here = (HERE / "STATUS.md").read_text()
    assert "{G, 11:5}" in theorem
    assert status_here.startswith("Q-UNDECIDED\n")
    assert "{PSL(2,11), 11:5}" in status_here
    seal = json.loads((HERE / "SEAL.json").read_text())
    files = {
        str(path.relative_to(HERE)): sha256(path)
        for path in sorted(HERE.rglob("*"))
        if path.is_file() and path.name != "SEAL.json" and "__pycache__" not in path.parts
    }
    assert seal["governing_status"] == "Q-UNDECIDED"
    assert seal["surviving_decomposition_groups"] == ["PSL(2,11)", "11:5"]
    assert seal["files"] == files
    print("PASS honest-P2 twisting and weak-versality bridge for both A5 classes")
    print("PASS refined survivor set {G,11:5}")
    print(f"PASS recursive packet seal files={len(files)}")
    print("Q_SCHUR_A5_VALUATION_ELIMINATION_OK")


if __name__ == "__main__":
    main()
