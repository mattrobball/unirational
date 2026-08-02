#!/usr/bin/env python3
"""Point/boundary verifier for G3P: no false headline point; G3P.3 policy checks."""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def main() -> None:
    status = (HERE / "STATUS.md").read_text().splitlines()
    require(status, "STATUS nonempty")
    exit_line = status[0].strip()
    allowed = {
        "G3P-POINT-HEADLINE-POSITIVE",
        "G3P-QUADRATIC-SPRINGER-REDUCTION-PASS",
        "G3P-RATIONAL-FIBRATION-PASS",
        "G3P-POLAR-SYSTEM-PASS",
        "G3P-UNDECIDED",
        "G3P-CANONICAL-INPUT-FAIL",
    }
    require(exit_line in allowed, f"unauthorized exit {exit_line}")

    point_path = HERE / "POINT.md"
    bridge_path = HERE / "BRIDGE_POLAR_POS.md"

    if exit_line == "G3P-POINT-HEADLINE-POSITIVE":
        require(point_path.is_file(), "POINT.md required for headline")
        require(bridge_path.is_file(), "BRIDGE_POLAR_POS.md required for headline")
    else:
        # No headline point package
        if point_path.is_file():
            txt = point_path.read_text()
            require("NOT OBTAINED" in txt or "no point" in txt.lower(), "stray POINT.md")
        require(not bridge_path.is_file(), "BRIDGE must not exist without headline")

    odd = json.loads((HERE / "odd_degree_descent.json").read_text())
    require(odd["schema"] == "g3p3-odd-degree-descent-v1", "odd schema")
    require(odd["K_proj_point_via_springer"] is False, "no springer point claimed")
    require(len(odd["A5_classes"]) == 2, "both A5 classes")
    for cls in odd["A5_classes"]:
        require(cls["degree_odd"] is True, "degree odd")
        require(cls["coordinates_in_G3_frame"] is False, "no fake coordinates")
        require(cls["produces_K_proj_cubic_point"] is False, "no cubic point")
        require(
            cls["springer_path"]["illegal_cubic_odd_degree_descent"] == "REJECTED",
            "must reject illegal descent",
        )
        require(
            cls["springer_path"]["step4_springer_on_quadratic"] == "NOT APPLIED",
            "springer not falsely applied",
        )

    # G4 residual consistency
    g4_land = json.loads(
        (ROOT / "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER/landing_tests.json").read_text()
    )
    require(g4_land["K_proj_point_found"] is False, "G4 has no K_proj point")

    polar = json.loads((HERE / "polar_system.json").read_text())
    require(polar["ambient_point_q"]["on_cubic"] is False, "q off cubic")

    # STATUS body must say HEADLINE OPEN for non-headline exits
    body = "\n".join(status)
    if exit_line != "G3P-POINT-HEADLINE-POSITIVE":
        require("OPEN" in body, "headline open")

    print("G3P_POINT_BOUNDARY_OK")
    print(exit_line)
    if exit_line != "G3P-POINT-HEADLINE-POSITIVE":
        print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
