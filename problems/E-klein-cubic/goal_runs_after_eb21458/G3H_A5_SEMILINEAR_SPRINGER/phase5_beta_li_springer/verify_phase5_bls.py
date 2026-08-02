#!/usr/bin/env python3
"""Independent verifier for G3H phase5_beta_li_springer.

Does not import produce_phase5_bls. Rebuilds non-containment specialization
from sealed polar_data + generic_cubic; checks gate closures and Springer honesty.
"""

from __future__ import annotations

import json
import random
import sys
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
PACKET = HERE.parent
ROOT = PACKET.parents[1]
PHASE5N = PACKET / "phase5_springer_next"
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"
G3P = ROOT / "goal_runs_after_0aecc89/G3P_POLAR_ODD_DEGREE_DESCENT"


def fail(msg: str) -> None:
    print(f"G3H_PHASE5_BLS_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def require(cond: bool, msg: str) -> None:
    if not cond:
        fail(msg)


def rebuild_noncontainment_sample(polar: dict, noncontainment: dict) -> None:
    """Recompute off-Q density at the recorded specialization; must stay positive."""
    gc = json.loads(GENERIC.read_text())
    t3, t6, t8, t11 = sp.symbols("t3 t6 t8 t11")
    tvals_list = noncontainment["specialization"]["tvals"]
    tvals = {t3: tvals_list[0], t6: tvals_list[1], t8: tvals_list[2], t11: tvals_list[3]}
    prime = noncontainment["specialization"]["prime"]
    random.seed(0)

    cmap = {}
    for item in gc["coefficients"]:
        triple = tuple(item["triple"])
        acc = sp.Integer(0)
        for e in item["normalized_entries"]:
            if e["secondary"] != 0:
                continue
            mon = sp.Rational(e["numerator"], e["denominator"])
            for pr, ex in zip([t3, t6, t8, t11], e["projective_exponents"]):
                mon *= pr**ex
            acc += mon
        val = sp.simplify(sp.sympify(acc).subs(tvals))
        num, den = sp.fraction(sp.together(val))
        den_i = int(den) % prime
        require(den_i != 0, "den zero")
        cmap[triple] = (int(num) % prime) * pow(den_i, -1, prime) % prime

    def elem0_fp(sparse):
        for c in sparse.get("components", []):
            if c.get("secondary_index") == 0:
                val = sp.simplify(sp.sympify(c["str"]).subs(tvals))
                num, den = sp.fraction(sp.together(val))
                return (int(num) % prime) * pow(int(den) % prime, -1, prime) % prime
        return 0

    M = [
        [elem0_fp(polar["first_polar_M"][i][j]) for j in range(5)] for i in range(5)
    ]
    rank_M = int(sp.Matrix(M).rank())
    require(rank_M == 5, f"rank M={rank_M}")
    require(rank_M == noncontainment["Q_q_matrix_rank"], "rank mismatch with produced")

    def phi_fp(a):
        total = 0
        for (i, j, k), c in cmap.items():
            total = (total + c * a[i] * a[j] * a[k]) % prime
        return total

    def D_fp(a):
        s = 0
        for i in range(5):
            for j in range(5):
                s = (s + M[i][j] * a[i] * a[j]) % prime
        return s

    cubic_pts = []
    for _ in range(200000):
        a = [random.randrange(prime) for _ in range(5)]
        if all(x == 0 for x in a):
            continue
        if phi_fp(a) == 0:
            cubic_pts.append(a)
            if len(cubic_pts) >= 400:
                break
    require(len(cubic_pts) >= 50, f"too few cubic points {len(cubic_pts)}")
    off = sum(1 for a in cubic_pts if D_fp(a) != 0)
    require(off > 0, "all cubic points on Q_q — noncontainment failed")
    require(off / len(cubic_pts) > 0.5, f"off fraction too small {off}/{len(cubic_pts)}")
    # Check produced example
    ex = noncontainment["example_cubic_not_on_Q_q"]["a"]
    require(phi_fp(ex) == 0, "produced example not on cubic")
    require(D_fp(ex) != 0, "produced example on Q_q")
    print(f"noncontainment rebuilt OK: off={off}/{len(cubic_pts)} rank_M={rank_M}")


def main() -> None:
    beta = json.loads((HERE / "secondary_beta_decision.json").read_text())
    hunt = json.loads((HERE / "L_point_decision.json").read_text())
    decision = json.loads((HERE / "springer_decision.json").read_text())
    noncontainment = json.loads((HERE / "noncontainment_Xgen_Qq.json").read_text())
    springer_thm = json.loads((HERE / "springer_quadratic_form.json").read_text())
    polar = json.loads((PHASE5N / "polar_data.json").read_text())

    # --- A. secondary beta obstruction ---
    require(
        beta.get("marker") == "G3H-AI-SECONDARY-TABLE-OBSTRUCTION",
        f"beta marker {beta.get('marker')}",
    )
    require(beta.get("closed_gate") == "G3H-AI-SECONDARY-TABLE-OPEN", "closed gate A")
    require(beta.get("closure_mode") == "NAMED_EXACT_OBSTRUCTION", "closure mode A")
    require(
        beta["exact_obstruction"]["name"] == "DEGREE-33-REYNOLDS-SECONDARY-EXPANSION",
        "obstruction name",
    )
    require(len(beta["classes"]) == 2, "both A5 classes")
    for cl in beta["classes"]:
        require(cl["n_beta_slots"] == 55, f"slots {cl['n_beta_slots']}")
        require(cl["secondary_tables_status"] == "OBSTRUCTION", "tables status")
        # Must not pretend cancelled components exist
        require(cl["n_slots_obstructed"] == 55, "all slots obstructed")
    # Dual binding to phase5_next
    exp = json.loads((PHASE5N / "a_i_expansion.json").read_text())
    require(exp.get("marker") == "G3H-AI-EXPANSION-DUAL-PASS", "dual expansion missing")
    print("secondary beta obstruction OK")

    # --- B. L_i-point NO ---
    require(
        hunt.get("marker") == "G3H-LI-POINT-ON-KPROJ-QUADRATIC-CLOSED-NO",
        f"hunt marker {hunt.get('marker')}",
    )
    require(
        hunt.get("closed_gate") == "G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN",
        "closed gate B",
    )
    require(hunt["certified_unconditional_L_i_point_on_Q_q"] is False, "fake Q_q point")
    require(
        hunt["certified_L_i_point_on_K_proj_quadratic_with_mapback"] is False,
        "fake mapback point",
    )
    require(hunt["n_yes"] == 0, "unexpected YES")
    require(hunt["n_attempts"] >= 5, "too few attempts")
    names = {a["name"] for a in hunt["attempts"]}
    for need in (
        "a_i_on_Q_q",
        "line_residual_binary",
        "any_L_i_point_on_Q_q",
        "trace_polar_Q_Tr_a_i",
    ):
        require(need in names, f"missing attempt {need}")
    for a in hunt["attempts"]:
        if a["name"] == "a_i_on_Q_q":
            require(a["status"] == "NO", "a_i_on_Q_q must be NO")
        if a["name"] == "line_residual_binary":
            require(a["defined_over_K_proj"] is False, "residual must not be over K")
        if a["name"] == "any_L_i_point_on_Q_q":
            require(a["status"] == "NO", "any L_i point must be NO")
    # Springer q.f. theorem binding
    require("odd" in springer_thm["statement"].lower() or "odd" in str(springer_thm), "odd")
    require(
        "Q_q(L_i)" in springer_thm["application_to_Q_q"]["conclusion"]
        or "⇔" in springer_thm["application_to_Q_q"]["conclusion"]
        or "<=>" in springer_thm["application_to_Q_q"]["conclusion"].replace(" ", ""),
        "equivalence conclusion",
    )
    require(
        "11" in str(springer_thm["application_to_Q_q"]["L"]),
        "degree 11 in application",
    )
    print("L_i-point closed NO OK")

    # Rebuild noncontainment
    require(noncontainment["Q_q_smooth_probe"] is True, "smooth probe")
    require(noncontainment["fraction_off_Q_q"] is not None, "fraction")
    require(noncontainment["fraction_off_Q_q"] > 0.5, "fraction")
    rebuild_noncontainment_sample(polar, noncontainment)

    # --- C. Springer kill honesty ---
    require(
        decision.get("marker") == "G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED",
        f"decision marker {decision.get('marker')}",
    )
    require(decision.get("route1_decision") == "KILL", "must KILL Route-1")
    for cl in decision["classes"]:
        chk = cl["springer_checklist"]
        require(chk["1_quadratic_object_over_K_proj"]["status"] == "YES", "Q_q")
        require(chk["2_L_i_point_on_that_object"]["status"] == "NO", "item2 NO")
        require(chk["3_degree_odd"]["status"] == "YES", "odd")
        require(chk["4_explicit_map_back_to_X_gen"]["status"] == "NO", "mapback")
        require(cl["springer_applied"] is False, "Springer applied")
        require(cl["produces_K_proj_cubic_point"] is False, "cubic point")
        require(cl["forbidden_inference"]["status"] == "REJECTED", "forbidden")
        require(
            cl["illegal_cubic_odd_degree_descent"]["status"] == "REJECTED",
            "illegal descent",
        )
    for bad in (
        "G3H-QUADRATIC-SPRINGER-REDUCTION-PASS",
        "G3P-POINT-HEADLINE-POSITIVE",
    ):
        require(bad in decision["stronger_markers_not_claimed"], f"must list {bad}")

    gates = decision["gates"]
    require(
        gates["G3H-AI-SECONDARY-TABLE-OPEN"]["status"] == "CLOSED_AS_OBSTRUCTION",
        "gate A",
    )
    require(
        gates["G3H-LI-POINT-ON-KPROJ-QUADRATIC-OPEN"]["status"] == "CLOSED_NO",
        "gate B",
    )
    require(
        gates["G3H-SPRINGER-MAPBACK-OPEN"]["status"] == "CLOSED_WITH_INTERFACE_KILL",
        "gate C",
    )

    # package STATUS / SEAL
    status = (PACKET / "STATUS.md").read_text()
    require(status.splitlines()[0].strip() == "G3H-SEMILINEAR-G3-FRAME-PASS", "STATUS line")
    require("G3H-AI-SECONDARY-TABLE-OBSTRUCTION" in status, "STATUS secondary")
    require("G3H-LI-POINT-ON-KPROJ-QUADRATIC-CLOSED-NO" in status, "STATUS L_i")
    require("KILL" in status or "kill" in status.lower(), "STATUS kill")
    require("G3H-QUADRATIC-INTERFACE-NO-GO-SCOPED" in status, "STATUS no-go")

    seal = json.loads((PACKET / "SEAL.json").read_text())
    require(seal["exit"] == "G3H-SEMILINEAR-G3-FRAME-PASS", "seal exit")
    require(seal["headline"] == "OPEN", "headline")
    require(
        seal.get("phase5_beta_li_springer", {}).get("route1_decision") == "KILL",
        "seal kill",
    )
    require(
        "G3H-AI-SECONDARY-TABLE-OBSTRUCTION" in seal.get("phase_markers", []),
        "seal markers secondary",
    )
    require(
        "G3H-LI-POINT-ON-KPROJ-QUADRATIC-CLOSED-NO" in seal.get("phase_markers", []),
        "seal markers L_i",
    )
    for bad in (
        "G3H-QUADRATIC-SPRINGER-REDUCTION-PASS",
        "G3P-POINT-HEADLINE-POSITIVE",
    ):
        require(bad not in seal.get("phase_markers", []), f"seal claims {bad}")

    g3p = (G3P / "STATUS.md").read_text().splitlines()[0].strip()
    require(g3p == "G3P-POLAR-SYSTEM-PASS", f"G3P {g3p}")

    # Phi(q) binding from sealed polar
    require(not polar["Phi_q"]["is_zero"], "Phi(q) zero")
    require("t3" in polar["Phi_q"]["components"][0]["str"], "Phi(q) t3")

    print(decision["marker"])
    print(beta["marker"])
    print(hunt["marker"])
    print("ROUTE1_KILL")
    print("G3H_PHASE5_BLS_OK")


if __name__ == "__main__":
    main()
