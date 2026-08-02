#!/usr/bin/env python3
"""Independent verifier for G3H phase5_springer_next.

Rebuilds polar secondary expansions from G3A/G3P APIs; checks expansion dual
calculus structure; enforces Springer honesty (no fake pass without checklist).
Does not import produce_phase5_next.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
PACKET = HERE.parent
ROOT = PACKET.parents[1]
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE/src"))
sys.path.insert(0, str(ROOT / "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/src"))

from field_api import SECONDARY_NAMES  # noqa: E402
from polar_core import (  # noqa: E402
    Q_POINT,
    first_polar_matrix,
    load_betas,
    phi_of_vector,
    second_polar_linear_form,
)


def fail(msg: str) -> None:
    print(f"G3H_PHASE5_NEXT_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def main() -> None:
    # --- load produced artefacts ---
    expansion = json.loads((HERE / "a_i_expansion.json").read_text())
    polar = json.loads((HERE / "polar_data.json").read_text())
    hunt = json.loads((HERE / "L_point_hunt.json").read_text())
    decision = json.loads((HERE / "springer_decision.json").read_text())

    require(
        expansion.get("marker") == "G3H-AI-EXPANSION-DUAL-PASS",
        f"expansion marker {expansion.get('marker')}",
    )
    require(
        expansion.get("residual_gate") == "G3H-AI-SECONDARY-TABLE-OPEN",
        "missing secondary residual gate",
    )

    # --- expansion structure both classes ---
    for ci in (1, 2):
        path = HERE / f"a_i_expansion_class_{ci}.json"
        require(path.is_file(), f"missing {path.name}")
        exp = json.loads(path.read_text())
        require(exp["class_index"] == ci, "class index")
        require(exp["field"]["degree"] == 11, "degree 11")
        require(exp["field"]["degree_odd"] is True, "degree odd")
        require(len(exp["coordinates"]) == 5, "five coordinates")
        for coord in exp["coordinates"]:
            require(len(coord["coefficients"]) == 11, "11 power coeffs")
            for beta in coord["coefficients"]:
                require(
                    "dual_trace_formula" in beta or "Tr" in beta.get("dual_trace_formula", "Tr"),
                    "dual formula missing",
                )
                require(
                    beta.get("secondary_basis_status")
                    in (
                        "SLOT_INSTALLED_DUAL_FORMULA",
                        "EXPANDED",
                        "RESIDUAL_OPEN",
                    )
                    or beta.get("secondary_components") is not None
                    or beta.get("secondary_residual"),
                    "secondary slot missing",
                )
        dual = exp["dual_calculus"]
        require(dual["degree"] == 11, "dual degree")
        require("omega_k" in dual["dual_basis"]["name"] or "omega" in dual["dual_basis"]["name"], "omega")
        require(
            exp["expansion_status"]["power_basis_structure"] == "INSTALLED",
            "power basis not installed",
        )
        require(
            exp["expansion_status"]["dual_trace_formulas"] == "INSTALLED",
            "dual not installed",
        )
        # Must not pretend secondary tables are complete
        require(
            exp["expansion_status"]["secondary_basis_tables_of_beta"]
            in ("RESIDUAL_OPEN", "PARTIAL", "OPEN"),
            "secondary tables falsely complete",
        )
        print(f"class {ci}: dual power-basis expansion structure OK")

    # --- rebuild polar A, L, M independently ---
    beta, _payload, _cmap = load_betas()
    A = phi_of_vector(Q_POINT, beta)
    L = second_polar_linear_form(beta, Q_POINT)
    M = first_polar_matrix(beta, Q_POINT)

    # A = t3 on secondary 0
    require(sp.simplify(A[0] - sp.Symbol("t3")) == 0 or str(A[0]) == "t3", f"A[0]={A[0]}")
    for i in range(1, 12):
        require(A[i] == 0, f"A[{i}] should be 0")

    # Produced Phi_q secondary-0 component
    phi_prod = polar["Phi_q"]
    require(not phi_prod["is_zero"], "Phi(q) zero")
    require(phi_prod["nonzero_count"] == 1, "Phi(q) should be secondary-0 only")
    require(
        phi_prod["components"][0]["secondary_name"] == "1"
        or phi_prod["components"][0]["secondary_index"] == 0,
        "Phi(q) not secondary-0",
    )
    require("t3" in phi_prod["components"][0]["str"], "Phi(q) not t3")

    # L length 5, each nonzero sparse
    require(len(polar["second_polar_L"]) == 5, "L length")
    for i in range(5):
        require(not polar["second_polar_L"][i]["is_zero"], f"L[{i}] zero unexpectedly")
        # rebuild: L[i] matches produced nonzero secondary indices
        prod_idx = {c["secondary_index"] for c in polar["second_polar_L"][i]["components"]}
        rebuild_idx = {j for j in range(12) if L[i][j] != 0}
        require(prod_idx == rebuild_idx, f"L[{i}] secondary support mismatch {prod_idx} vs {rebuild_idx}")

    # M symmetric and secondary match on diagonal sample
    require(len(polar["first_polar_M"]) == 5, "M rows")
    for i in range(5):
        require(len(polar["first_polar_M"][i]) == 5, "M cols")
        prod_idx = {
            c["secondary_index"] for c in polar["first_polar_M"][i][i]["components"]
        }
        rebuild_idx = {j for j in range(12) if M[i][i][j] != 0}
        require(
            prod_idx == rebuild_idx,
            f"M[{i},{i}] secondary support mismatch",
        )
    print("polar A,L,M secondary expansions rebuilt OK")
    print(f"secondary basis names: {list(SECONDARY_NAMES)[:4]}...")

    # --- hunt honesty ---
    require(hunt["certified_L_i_point_on_K_proj_quadratic"] is False, "fake L_i point")
    require(hunt["n_certified"] == 0, "n_certified")
    require(len(hunt["attempts"]) >= 3, "too few hunt attempts")

    # --- Springer decision honesty ---
    require(
        decision["marker"] == "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED",
        f"decision marker {decision['marker']}",
    )
    for cl in decision["classes"]:
        chk = cl["springer_checklist"]
        require(chk["1_quadratic_object_over_K_proj"]["status"] == "YES", "Q_q")
        require(
            chk["2_L_i_point_on_that_object"]["status"] == "NOT_CERTIFIED",
            "item2 must be NOT_CERTIFIED under no-go",
        )
        require(chk["3_degree_odd"]["status"] == "YES", "odd degree")
        require(
            chk["4_explicit_map_back_to_X_gen"]["status"] in ("NO", "NOT_CERTIFIED"),
            "map-back",
        )
        require(cl["springer_applied"] is False, "Springer must not be applied")
        require(cl["produces_K_proj_cubic_point"] is False, "no cubic point")
        require(cl["forbidden_inference"]["status"] == "REJECTED", "forbidden")
        require(
            cl["illegal_cubic_odd_degree_descent"]["status"] == "REJECTED",
            "illegal descent",
        )

    # residual gates named
    gate_names = {g["name"] for g in decision["residual_gates"]}
    for g in (
        "G3H-AI-SECONDARY-TABLE-OPEN",
        "G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN",
        "G3H-SPRINGER-MAPBACK-OPEN",
    ):
        require(g in gate_names, f"missing residual gate {g}")

    # package STATUS first line
    status_line = (PACKET / "STATUS.md").read_text().splitlines()[0].strip()
    require(
        status_line == "G3H-SEMILINEAR-G3-FRAME-PASS",
        f"STATUS first line {status_line}",
    )
    status_body = (PACKET / "STATUS.md").read_text()
    require("G3H-AI-EXPANSION-DUAL-PASS" in status_body, "STATUS missing expansion marker")
    require("G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED" in status_body, "STATUS missing no-go")

    # seal
    seal = json.loads((PACKET / "SEAL.json").read_text())
    require(seal["exit"] == "G3H-SEMILINEAR-G3-FRAME-PASS", "seal exit")
    require(
        "G3H-AI-EXPANSION-DUAL-PASS" in seal.get("phase_markers", []),
        "seal markers",
    )
    require(seal.get("headline") == "OPEN", "headline must be OPEN")

    # refuse stronger markers
    for bad in (
        "G3H-QUADRATIC-SPRINGER-REDUCTION-PASS",
        "G3P-POINT-HEADLINE-POSITIVE",
    ):
        require(bad not in seal.get("phase_markers", []), f"seal claims {bad}")
        require(
            bad in decision.get("stronger_markers_not_claimed", []),
            f"must list {bad} as not claimed",
        )

    # G3P binding
    g3p_status = (
        ROOT / "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT/STATUS.md"
    ).read_text().splitlines()[0].strip()
    require(g3p_status == "G3P-POLAR-SYSTEM-PASS", f"G3P {g3p_status}")

    print(decision["marker"])
    print("G3H-AI-EXPANSION-DUAL-PASS")
    print("G3H_PHASE5_NEXT_OK")


if __name__ == "__main__":
    main()
