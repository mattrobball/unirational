#!/usr/bin/env python3
"""Verify the immutable phase seal and its deliberately nonterminal scope."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    seal = json.loads(SEAL.read_text())
    if seal["status"] != "SEALED_MDS34_COVER_ALL_CHARTS_UNSOLVED":
        raise AssertionError("wrong seal status")
    if seal["headline"] != "P25-UNDECIDED":
        raise AssertionError("nonterminal headline guard changed")
    for name, expected in seal["files"].items():
        path = HERE / name
        if path.stat().st_size != expected["bytes"] or sha256(path) != expected["sha256"]:
            raise AssertionError(f"sealed file changed: {name}")
    exact = seal["exact_conclusions"]
    if exact["stageB_mds34_cover"] is not True:
        raise AssertionError("MDS theorem missing")
    if exact["all_stageB_chart_emptiness_results"] != 0:
        raise AssertionError("false Stage-B chart result promoted")
    if exact["all_stageC_chart_emptiness_results"] != 0:
        raise AssertionError("false Stage-C chart result promoted")
    if "P25 degree-25 emptiness" not in seal["not_proved"]:
        raise AssertionError("terminal scope guard missing")
    print("PASS_DETERMINANTAL_COVER_SEAL")


if __name__ == "__main__":
    main()
