#!/usr/bin/env python3
"""Independently verify every hash in SEAL.json."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text(encoding="utf-8"))
    assert seal["schema"] == "t-target-branch-t0-seal-v1"
    assert seal["exit"] == "T-ROUTE-REFUTED"
    assert seal["t0_subexit"] == "T-BRIDGE-BLOCKED"
    assert seal["problem_e_headline"] == "OPEN"

    head = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
    ).strip()
    assert seal["consumed_head"] == head

    for relative, expected in seal["artifacts"].items():
        assert sha256(HERE / relative) == expected, relative
    for relative, expected in seal["upstream_sources"].items():
        assert sha256(ROOT / relative) == expected, relative

    print("T_TARGET_BRANCH_SEAL_VERIFIER_ACCEPT")


if __name__ == "__main__":
    main()
