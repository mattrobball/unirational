#!/usr/bin/env python3
"""Independent verifier for the (1,13) finite global lifting tower.

Does NOT import produce.py. Rebuilds stage ledger, free L_r ranks, and the
ker-L1 free-fibre residual at the first non-isolable F-order from common_g3.
"""

from __future__ import annotations

import json
import sys
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
GFL = HERE.parent
sys.path.insert(0, str(GFL))

from common_g3 import (  # noqa: E402
    L_matrix_sparse,
    expand_F_order_N,
    first_stage_no_poly_correction,
    free_fibre_tower,
    free_rank_jet,
    isolable_r_list,
    jet_dimension_table,
    matrix_from_coo,
    nullspace,
    pack_jet,
    parse_q,
    sample_leading_a_triv,
    solve_least_particular,
    stage_ledger,
)

M, D = 1, 13
TERMINAL = 3 * D


def load(name: str) -> dict:
    return json.loads((HERE / name).read_text())


def main() -> int:
    print("=== G3 degree-13 tower independent verifier ===")

    required = [
        "stage_ledger.json",
        "jet_dimensions.json",
        "free_Lr_ranks.json",
        "first_terminal_stage.json",
        "global_correction_modules.json",
        "tower_sample_based_zero.json",
        "tower_sample_kerL1.json",
        "exit.json",
        "SUMMARY.json",
        "TOWER.md",
        "produce.py",
    ]
    for name in required:
        assert (HERE / name).is_file(), f"missing {name}"
    print(f"PASS {len(required)} required artifacts present")

    ledger = stage_ledger(M, D)
    assert ledger["terminal_F_order"] == TERMINAL
    assert ledger["d_minus_6m"] == 7
    saved = load("stage_ledger.json")
    assert saved["nonautomatic_orders"] == ledger["nonautomatic_orders"]
    print("PASS stage ledger rebuild matches")

    first = first_stage_no_poly_correction(ledger)
    saved_f = load("first_terminal_stage.json")
    assert first["first_stage_without_Eplus_poly_isolator"] == 16
    assert first["last_isolable_Eplus_F_order"] == 14
    assert saved_f["first_stage_without_Eplus_poly_isolator"] == 16
    # combinatorial formula for odd m,d: first_noniso = d + 2m + 1
    assert 16 == D + 2 * M + 1
    print("PASS first non-isolable F-order 16 (= d+2m+1)")

    jets = jet_dimension_table(M, D)
    saved_j = load("jet_dimensions.json")
    assert saved_j["total_multi_rees_dim"] == jets["total_multi_rees_dim"] == 5649
    print("PASS multi-Rees total dim 5649")

    a_coeffs, a_label = sample_leading_a_triv(M)
    assert a_label == "residual_S3_trivial_a_triv"
    for r in isolable_r_list(M, D):
        L = L_matrix_sparse(M, r, a_coeffs)
        assert L["cokernel_dim_over_Q"] == 0, (r, L)
    print(f"PASS free L_r surjective for all isolable r={isolable_r_list(M, D)}")

    g4 = load("global_correction_modules.json")
    assert g4["architecture"].startswith("plane_normalization")
    for st in g4["stages"]:
        names = [ly["layer"] for ly in st["layers"]]
        assert names == [
            "plane_normalization",
            "triple_line_equalizer",
            "residual_point_kernel",
        ]
    print(f"PASS G4 architecture on {len(g4['stages'])} stages")

    # Rebuild ker-L1 residual independently (short path to first non-isolable)
    L1 = L_matrix_sparse(M, 1, a_coeffs)
    A1 = matrix_from_coo(
        L1["shape"][0],
        L1["shape"][1],
        L1["coo_rows"],
        L1["coo_cols"],
        [parse_q(x) for x in L1["coo_data"]],
    )
    ker = nullspace(A1)
    assert len(ker) == 4
    b2 = ker[0]
    jets_map: dict = {
        1: ("E_minus", pack_jet(1, "E_minus", a_coeffs)),
        2: ("E_plus", pack_jet(2, "E_plus", b2)),
    }
    for k in range(3, D + 1, 2):
        jets_map[k] = (
            "E_minus",
            pack_jet(k, "E_minus", [Q(0)] * free_rank_jet(k, 2)),
        )
    for r in isolable_r_list(M, D):
        if r == 1:
            continue
        order_b = M + r
        F_order = 3 * M + r
        L = L_matrix_sparse(M, r, a_coeffs)
        res = expand_F_order_N(jets_map, F_order, M)
        A = matrix_from_coo(
            L["shape"][0],
            L["shape"][1],
            L["coo_rows"],
            L["coo_cols"],
            [parse_q(x) for x in L["coo_data"]],
        )
        sol, _ = solve_least_particular(A, [-x for x in res])
        assert sol is not None, f"L_{r} failed"
        jets_map[order_b] = ("E_plus", pack_jet(order_b, "E_plus", sol))

    for r in isolable_r_list(M, D):
        N = 3 * M + r
        rr = expand_F_order_N(jets_map, N, M)
        assert all(x == 0 for x in rr), f"early F-order {N} not solved"

    res16 = expand_F_order_N(jets_map, 16, M)
    nsq = sum(x * x for x in res16)
    assert nsq != 0, "terminal residual at F-order 16 vanished"
    saved_s1 = load("tower_sample_kerL1.json")
    assert saved_s1["first_nonzero_terminal_F_order"] == 16
    sealed = Q(saved_s1["terminal_residuals"]["16"]["residual_norm_sq"])
    assert sealed == nsq, (sealed, nsq)
    print(f"PASS ker-L1 residual at F-order 16 nonzero (norm^2={nsq})")

    # Cross-check full free_fibre_tower rebuild matches sealed first-nz
    rebuilt = free_fibre_tower(M, D, a_coeffs, mode="ker_L1", a_label=a_label)
    assert rebuilt["first_nonzero_terminal_F_order"] == 16
    print("PASS free_fibre_tower rebuild agrees")

    exit_j = load("exit.json")
    assert exit_j["exit"] == "G13-OBSTRUCTION"
    assert exit_j["headline"] == "OPEN"
    assert exit_j["not_a_covariant"] is True
    assert exit_j["gate_G1"] == "PASS"
    print("PASS exit G13-OBSTRUCTION, headline OPEN")

    s0 = load("tower_sample_based_zero.json")
    assert s0["first_nonzero_terminal_F_order"] is None
    print("PASS based_zero branch has vanishing free-fibre F")

    assert (GFL / "FINITE_TRUNCATION_THEOREM.md").is_file()
    print("PASS G1 theorem present")

    print("G13_TOWER_VERIFY_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
