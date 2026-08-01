#!/usr/bin/env python3
"""Sealed replay for the Goal M structural exit."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
WORK_ROOT = HERE.parent
PROBLEM_ROOT = HERE.parents[1]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(path):
    completed = subprocess.run(
        [sys.executable, str(path)],
        cwd=WORK_ROOT,
        check=True,
        text=True,
        capture_output=True,
    )
    print(completed.stdout, end="")


def main():
    seal = json.loads((HERE / "SEAL.json").read_text())
    status = (HERE / "STATUS.md").read_text().splitlines()[0]
    assert status == seal["exit"] == "M-NEW-MORI-FIBRE-STRUCTURAL"

    for relative, expected in seal["local_files"].items():
        actual = digest(HERE / relative)
        assert actual == expected, (relative, expected, actual)
    for relative, expected in seal["upstream_inputs"].items():
        actual = digest(PROBLEM_ROOT / relative)
        assert actual == expected, (relative, expected, actual)
    print("PASS seal and pinned upstream-input hashes")

    run(PROBLEM_ROOT / "certificates" / "exact_covariants_check.py")
    run(PROBLEM_ROOT / "tmp" / "d12_line_restriction" / "verify.py")
    run(HERE / "verify_centres.py")
    run(HERE / "links" / "plane_cubic_dp3" / "verify.py")
    run(HERE / "links" / "plane_cubic_dp3" / "verify_section_frontier.py")
    print("PASS Goal M exit M-NEW-MORI-FIBRE-STRUCTURAL")


if __name__ == "__main__":
    main()
