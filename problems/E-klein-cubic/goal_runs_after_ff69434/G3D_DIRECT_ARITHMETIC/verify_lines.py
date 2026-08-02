#!/usr/bin/env python3
"""Independent verifier for line/sixer ledger honesty (no false K-line claims)."""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def main() -> None:
    lines = json.loads((HERE / "line_27_algebra.json").read_text())
    six = json.loads((HERE / "sixer_descent.json").read_text())
    det = json.loads((HERE / "surface_determinantal.json").read_text())

    require(lines.get("K_rational_line") is None, "false K-line claim")
    require(lines.get("point_from_line") is False, "false point from line")
    require(len(lines.get("charts", [])) == 6, "six charts")
    require(six.get("status") == "NO_K_SIXER_CERTIFIED", "sixer status")
    require(det.get("status") == "NO_DETERMINANTAL_MATRIX_OVER_K", "determinantal")

    # Any claimed all-component rational line must be recorded honestly
    for h in lines.get("rational_lines_all_components", []):
        if h.get("all_secondary_components_vanish"):
            # Would be a specialized P0-line, not automatically a K-line
            require("u" in h and "v" in h, "line vectors present")

    print("G3D_LINES_OK")


if __name__ == "__main__":
    main()
