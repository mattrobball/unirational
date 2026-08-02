#!/usr/bin/env python3
"""Independent G7C point / headline boundary verifier.

Does not import produce_geometry.py. Confirms that this packet does not claim
a K_proj-point or effective degree-two headline, and that no bridge artifacts
are present. If POINT.md / BRIDGE_DOUBLE_A5_POS.md ever appear, this verifier
must be extended to full Phi/G2/Klein/G3A checks — currently they must be absent.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]


def fail(msg: str) -> None:
    print(f"G7C_VERIFY_POINT_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def main() -> None:
    require("produce_geometry" not in sys.modules, "producer imported")

    status = (HERE / "STATUS.md").read_text()
    first = status.splitlines()[0].strip()
    require(
        first in {
            "G7-RESIDUAL-GEOMETRY-PASS",
            "G7-UNDECIDED",
            "G7-CANONICAL-INPUT-FAIL",
            # headline exits would require full bridge checks (not installed)
        },
        f"unexpected STATUS exit {first}",
    )
    require(
        first not in {
            "G7-POINT-HEADLINE-POSITIVE",
            "G7-EFFECTIVE-DEGREE2-HEADLINE-POSITIVE",
        },
        "headline exit without bridge path",
    )

    require(not (HERE / "POINT.md").is_file(), "POINT.md must be absent for non-headline")
    require(
        not (HERE / "BRIDGE_DOUBLE_A5_POS.md").is_file(),
        "BRIDGE_DOUBLE_A5_POS.md must be absent",
    )

    eff = json.loads((HERE / "effective_cycles.json").read_text())
    require(eff["K_proj_point_of_X_gen"] is False, "K_proj point claim")
    require(eff["effective_length_two_over_K_proj"] is False, "eff deg2 claim")
    require(eff["K_proj_line_on_X_gen"] is False, "K_proj line claim")
    require(eff["plane_conic_residual_line"] is False, "conic claim")
    require(eff["bridge"]["BRIDGE_DOUBLE_A5_POS"] is False, "bridge flag")

    ops = json.loads((HERE / "operations.json").read_text())
    require(ops["landing"]["K_proj_point_from_ops"] is False, "ops point claim")
    require(ops["summary"]["n_rational_on_cubic"] == 0, "rational on cubic ops")

    residual = json.loads((HERE / "residual_cycles.json").read_text())
    require(residual["n_rational_residual_Q"] == 0, "rational residual thirds")
    require(residual["search"]["effective_degree_two_subscheme"] is False, "eff2 search")

    # Explicit non-promotion of split-model classical points
    require("Headline remains" in (HERE / "EFFECTIVE_CYCLES.md").read_text()
            or "OPEN" in status, "headline open text")

    print("G7C_VERIFY_POINT_OK")
    print("NO_HEADLINE_POINT")
    print(first)


if __name__ == "__main__":
    main()
