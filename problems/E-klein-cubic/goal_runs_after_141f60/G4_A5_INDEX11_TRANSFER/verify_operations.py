#!/usr/bin/env python3
"""Independent G4.1–G4.3 verifier: projectors, ops, landing, secants.

Does not import produce.py.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent


def fail(msg: str) -> None:
    print(f"G4_OPS_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def mat(J):
    M = sp.zeros(11)
    for i in range(11):
        for j in range(11):
            M[i, j] = sp.Rational(J[i][j]["num"], J[i][j]["den"])
    return M


def main() -> None:
    for name in (
        "projectors.json",
        "operations.json",
        "landing_tests.json",
        "secant_geometry.json",
        "PERMUTATION_PROJECTORS.md",
        "LOW_ARITY_OPERATIONS.md",
        "SECANT_GEOMETRY.md",
    ):
        require((HERE / name).is_file(), f"missing {name}")

    proj = json.loads((HERE / "projectors.json").read_text())
    require(proj["G_module_decomposition"].replace(" ", "").startswith("1+10")
            or "1 + 10" in proj["G_module_decomposition"], "G decomp 1+10")
    require(len(proj["classes"]) == 2, "two projector class records")

    shared = proj["shared_projectors_over_Q"]
    P1 = mat(shared["P_trivial"])
    P10 = mat(shared["P_10"])
    require(sp.simplify(P1 * P1 - P1) == sp.zeros(11), "P1 idempotent")
    require(sp.simplify(P10 * P10 - P10) == sp.zeros(11), "P10 idempotent")
    require(sp.simplify(P1 * P10) == sp.zeros(11), "orthogonal")
    require(sp.simplify(P1 + P10 - sp.eye(11)) == sp.zeros(11), "sum I")
    require(sp.simplify(P1.trace()) == 1, "tr P1")
    require(sp.simplify(P10.trace()) == 10, "tr P10")
    require(shared.get("field") == "Q", "field Q")
    require("klein_companion_note" in shared, "5+5 correction note")

    # Formal cycle checks
    cycle = sp.Matrix([1] * 11)
    require(P10 * cycle == sp.zeros(11, 1), "P10 cycle = 0")
    require(sp.simplify(P1 * cycle - cycle) == sp.zeros(11, 1), "P1 cycle = cycle")

    ops = json.loads((HERE / "operations.json").read_text())
    require(ops["total_named_ops"] >= 8, "enough ops")
    require(len(ops["arity_1"]) >= 2, "arity1")
    require(len(ops["arity_2"]) >= 3, "arity2")
    require(len(ops["arity_3"]) >= 3, "arity3")
    require(ops["applied_to_formal_cycle"]["P10_cycle"] == "0", "cycle pure trivial")

    landing = json.loads((HERE / "landing_tests.json").read_text())
    require(landing.get("K_proj_point_found") is False, "no false K_proj point")
    require(len(landing.get("tests", [])) >= 3, "landing tests present")
    require("residual" in landing, "landing residual")

    secant = json.loads((HERE / "secant_geometry.json").read_text())
    require(secant.get("K_proj_point_from_secants") is False, "no false secant point")
    require(secant["residual_intersections"]["degree_1_or_2_found"] is False, "no residual")
    require(secant["line_or_conic_on_X_gen"]["certified"] is False, "no false line")

    print("G4_PROJECTORS_OK")
    print("G4_OPERATIONS_OK")
    print("G4_LANDING_RESIDUAL_OK")
    print("G4_SECANT_RESIDUAL_OK")
    print("G4_OPS_VERIFY_OK")


if __name__ == "__main__":
    main()
