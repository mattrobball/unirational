#!/usr/bin/env python3
"""Independent phase-5 verifier: Springer checklist honesty."""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PHASE5 = HERE / "phase5_springer"
G3P = ROOT / "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT"


def fail(msg: str) -> None:
    print(f"G3H_PHASE5_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    summary = json.loads((PHASE5 / "springer_decision.json").read_text())
    marker = summary.get("marker")
    if marker not in (
        "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED",
        "G3H-QUADRATIC-SPRINGER-REDUCTION-PASS",
    ):
        fail(f"unexpected marker {marker}")

    # Refuse fake Springer pass without checklist
    if marker == "G3H-QUADRATIC-SPRINGER-REDUCTION-PASS":
        for cl in summary["classes"]:
            chk = cl["springer_checklist"]
            for key in (
                "1_quadratic_object_over_K_proj",
                "2_L_i_point_on_that_object",
                "3_degree_odd",
                "4_explicit_map_back_to_X_gen",
            ):
                if chk[key].get("status") not in ("YES", "PASS", True):
                    fail(f"Springer pass but checklist {key} not YES")
            if cl.get("forbidden_inference", {}).get("status") != "REJECTED":
                fail("must still reject forbidden bare inference language")
    else:
        # Scoped no-go path
        if summary.get("springer_applied" if False else "marker") != marker:
            pass
        for cl in summary["classes"]:
            chk = cl["springer_checklist"]
            if chk["1_quadratic_object_over_K_proj"]["status"] != "YES":
                fail("Q_q must be over K_proj")
            if chk["3_degree_odd"]["status"] != "YES":
                fail("degree odd")
            if chk["4_explicit_map_back_to_X_gen"]["status"] in ("YES", "PASS"):
                # if map-back claimed under no-go marker, fail
                if marker == "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED":
                    fail("no-go marker but map-back claimed YES")
            if cl.get("springer_applied") is True:
                fail("no-go must not apply Springer")
            if cl.get("produces_K_proj_cubic_point") is True:
                fail("must not produce K_proj cubic point under no-go")
            if cl["forbidden_inference"]["status"] != "REJECTED":
                fail("forbidden inference must be rejected")
            if cl["illegal_cubic_odd_degree_descent"]["status"] != "REJECTED":
                fail("illegal cubic descent must be rejected")

    g3p_status = (G3P / "STATUS.md").read_text().splitlines()[0].strip()
    if g3p_status != "G3P-POLAR-SYSTEM-PASS":
        fail(f"G3P status {g3p_status}")

    # Refuse headline
    if summary.get("produces_K_proj_cubic_point") is True:
        fail("headline point claimed")

    print(marker)
    print("G3H_PHASE5_OK")


if __name__ == "__main__":
    main()
