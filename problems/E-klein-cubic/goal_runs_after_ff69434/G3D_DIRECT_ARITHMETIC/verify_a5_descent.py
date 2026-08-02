#!/usr/bin/env python3
"""Independent verifier for A5 structured descent protocol."""

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
    c1 = json.loads((HERE / "a5_structured_descent_class_1.json").read_text())
    c2 = json.loads((HERE / "a5_structured_descent_class_2.json").read_text())
    meta = json.loads((HERE / "A5_structured_descent_meta.json").read_text())

    require(meta["marker"] == "G3D-A5-STRUCTURED-DESCENT-PASS", "marker")
    require(meta["point_produced"] is False, "no point")
    require(c1["A5_class"] == 1 and c2["A5_class"] == 2, "classes")
    require(c1["illegal_cubic_descent_rejected"], "class1 illegal rejected")
    require(c2["illegal_cubic_descent_rejected"], "class2 illegal rejected")

    forbidden = meta["forbidden_uses"]
    require(any("X(L_i)" in f for f in forbidden), "forbidden cubic descent listed")

    # Binding inputs exist
    for key in ("H_A5", "G4"):
        p = Path(meta["inputs"][key])
        # paths may be absolute
        require(p.exists() or (ROOT / p).exists() or Path(str(p)).exists(), f"missing {key}")
        # softer: check known relative
    require(
        (ROOT / "goal_runs_after_35fa" / "H_A5_TWISTS" / "STATUS.md").exists(),
        "H_A5 STATUS",
    )
    require(
        (ROOT / "goal_runs_after_141f60" / "G4_A5_INDEX11_TRANSFER" / "STATUS.md").exists(),
        "G4 STATUS",
    )

    print("G3D_A5_OK")


if __name__ == "__main__":
    main()
