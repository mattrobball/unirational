#!/usr/bin/env python3
"""Independent G4.4 / point verifier.

Confirms no fabricated K_proj-point claim and that headline remains OPEN
unless POINT.md + BRIDGE_A5_TRANSFER_POS.md both exist and verify.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def fail(msg: str) -> None:
    print(f"G4_POINT_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def main() -> None:
    status = (HERE / "STATUS.md").read_text()
    first = status.splitlines()[0].strip()
    authorized = {
        "G4-POINT-HEADLINE-POSITIVE",
        "G4-INDUCED-DEGREE11-POINT-PASS",
        "G4-COSET-PROJECTOR-REDUCTION-PASS",
        "G4-SECANT-RESIDUAL-PASS",
        "G4-UNDECIDED",
        "G4-CANONICAL-INPUT-FAIL",
    }
    require(first in authorized, f"unauthorized exit {first!r}")

    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal.get("headline") == "OPEN" or first == "G4-POINT-HEADLINE-POSITIVE",
            "headline/exit consistency")

    point_md = HERE / "POINT.md"
    bridge = HERE / "BRIDGE_A5_TRANSFER_POS.md"
    landing = json.loads((HERE / "landing_tests.json").read_text())
    secant = json.loads((HERE / "secant_geometry.json").read_text())

    if first == "G4-POINT-HEADLINE-POSITIVE":
        require(point_md.is_file(), "POINT.md required for headline")
        require(bridge.is_file(), "BRIDGE required for headline")
        require(landing.get("K_proj_point_found") is True, "landing must find point")
    else:
        require(not point_md.is_file(), "no POINT.md without headline claim")
        require(not bridge.is_file(), "no BRIDGE without headline claim")
        require(landing.get("K_proj_point_found") is False, "no false landing point")
        require(secant.get("K_proj_point_from_secants") is False, "no false secant point")
        require(seal.get("exit") != "G4-POINT-HEADLINE-POSITIVE", "seal exit")
        require(seal.get("headline") == "OPEN", "headline OPEN")

    # Induced degree-11 is not a headline
    if first == "G4-INDUCED-DEGREE11-POINT-PASS":
        ind = json.loads((HERE / "induced_points.json").read_text())
        require(len(ind["classes"]) == 2, "both classes")
        for cl in ind["classes"]:
            require(cl["degree"] == 11, "degree 11")
            require(cl["K_proj_cycle"]["defined_over_K_proj"] is True, "K_proj")

    print("G4_POINT_BOUNDARY_OK")
    print(first)
    print("HEADLINE-OPEN" if seal.get("headline") == "OPEN" else "HEADLINE-CLAIM")


if __name__ == "__main__":
    main()
