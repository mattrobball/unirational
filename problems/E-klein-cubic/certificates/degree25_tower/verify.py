#!/usr/bin/env python3
"""Independent verifier for P25.1 degree-25 finite Path G tower.

Does NOT import produce.py. Rebuilds stage ledger, free L_r ranks, ker-L1
particular residual at N_star, and both families' residual zero-locus
cancellations from common_g3.
"""

from __future__ import annotations

import json
import sys
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
GFL = HERE.parent / "global_finite_lifting"
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
    monoms_bin,
    nullspace,
    pack_jet,
    parse_q,
    sample_leading_a_triv,
    solve_least_particular,
    stage_ledger,
)

M, D = 1, 25
TERMINAL = 3 * D
N_STAR = D + 2 * M + 1


def load(name: str) -> dict:
    return json.loads((HERE / name).read_text())


def mat_rank_solve(cols, target):
    n = len(target)
    m = len(cols)
    if m == 0:
        return 0, all(x == 0 for x in target), []
    A = [[cols[j][i] for j in range(m)] + [target[i]] for i in range(n)]
    pivots = []
    r = 0
    for c in range(m):
        piv = next((i for i in range(r, n) if A[i][c] != 0), None)
        if piv is None:
            continue
        A[r], A[piv] = A[piv], A[r]
        inv = Q(1) / A[r][c]
        A[r] = [inv * x for x in A[r]]
        for i in range(n):
            if i != r and A[i][c] != 0:
                f = A[i][c]
                A[i] = [A[i][j] - f * A[r][j] for j in range(m + 1)]
        pivots.append(c)
        r += 1
        if r == n:
            break
    for i in range(r, n):
        if A[i][m] != 0:
            return r, False, None
    x = [Q(0)] * m
    for i, c in enumerate(pivots):
        x[c] = A[i][m]
    return r, True, x


def build_tower(a_coeffs, b2, Acache, a_d=None):
    jets = {
        M: ("E_minus", pack_jet(M, "E_minus", a_coeffs)),
        2: ("E_plus", pack_jet(2, "E_plus", b2)),
    }
    for k in range(3, D + 1, 2):
        if a_d is not None and k == D:
            jets[k] = ("E_minus", pack_jet(k, "E_minus", a_d))
        else:
            jets[k] = (
                "E_minus",
                pack_jet(k, "E_minus", [Q(0)] * free_rank_jet(k, 2)),
            )
    particular = {2: list(b2)}
    for r in isolable_r_list(M, D):
        if r == 1:
            continue
        order_b = M + r
        F_order = 3 * M + r
        res = expand_F_order_N(jets, F_order, M)
        sol, _ = solve_least_particular(Acache[r], [-x for x in res])
        assert sol is not None, f"L_{r} failed"
        particular[order_b] = sol
        jets[order_b] = ("E_plus", pack_jet(order_b, "E_plus", sol))
    for k in range(2, D + 1, 2):
        if k not in jets:
            jets[k] = (
                "E_plus",
                pack_jet(k, "E_plus", [Q(0)] * free_rank_jet(k, 3)),
            )
    return jets, particular


def main() -> int:
    print("=== P25.1 degree-25 tower independent verifier ===")

    required = [
        "stage_ledger.json",
        "jet_dimensions.json",
        "free_Lr_ranks.json",
        "first_terminal_stage.json",
        "resource_preflight.json",
        "global_correction_modules.json",
        "tower_sample_based_zero.json",
        "tower_sample_kerL1.json",
        "zero_locus_Nstar.json",
        "family_based_minus_lines_odd_m.json",
        "family_residual_e_ge7_generic_swap_both.json",
        "exit.json",
        "SUMMARY.json",
        "SEAL.json",
        "TOWER.md",
        "input_hashes.json",
        "SHA256SUMS",
        "produce.py",
    ]
    for name in required:
        assert (HERE / name).is_file(), f"missing {name}"
    print(f"PASS {len(required)} required artifacts present")

    # Combinatorics
    ledger = stage_ledger(M, D)
    assert ledger["terminal_F_order"] == TERMINAL
    saved = load("stage_ledger.json")
    assert saved["nonautomatic_orders"] == ledger["nonautomatic_orders"]
    print("PASS stage ledger rebuild matches")

    first = first_stage_no_poly_correction(ledger)
    assert first["first_stage_without_Eplus_poly_isolator"] == N_STAR
    assert first["last_isolable_Eplus_F_order"] == D + 2 * M - 1  # 26
    assert N_STAR == D + 2 * M + 1
    saved_f = load("first_terminal_stage.json")
    assert saved_f["first_stage_without_Eplus_poly_isolator"] == N_STAR
    print(f"PASS N_star={N_STAR} (= d+2m+1), last isolable E+ F-order {D + 2 * M - 1}")

    jets = jet_dimension_table(M, D)
    saved_j = load("jet_dimensions.json")
    assert saved_j["total_multi_rees_dim"] == jets["total_multi_rees_dim"]
    print(f"PASS multi-Rees total dim {jets['total_multi_rees_dim']}")

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
    assert g4.get("irrelevant_torsion_retained") is True
    assert g4.get("source_line_coupling_retained") is True
    assert g4.get("repaired_category_retained") is True
    print(f"PASS G4 architecture on {len(g4['stages'])} stages")

    # Free-fibre samples
    s0 = load("tower_sample_based_zero.json")
    assert s0["first_nonzero_terminal_F_order"] is None
    s1 = load("tower_sample_kerL1.json")
    assert s1["first_nonzero_terminal_F_order"] == N_STAR
    sealed_nsq = parse_q(s1["terminal_residuals"][str(N_STAR)]["residual_norm_sq"])
    assert sealed_nsq != 0
    print(f"PASS particular ker-L1 residual at {N_STAR} nonzero (norm^2={sealed_nsq})")

    # Rebuild ker-L1 residual independently
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
    Acache = {1: A1}
    for r in isolable_r_list(M, D):
        if r == 1:
            continue
        L = L_matrix_sparse(M, r, a_coeffs)
        Acache[r] = matrix_from_coo(
            L["shape"][0],
            L["shape"][1],
            L["coo_rows"],
            L["coo_cols"],
            [parse_q(x) for x in L["coo_data"]],
        )
        K = nullspace(Acache[r])
        # store for based cancel
        if r == 1:
            pass

    jets_map, particular = build_tower(a_coeffs, ker[0], Acache)
    res28 = expand_F_order_N(jets_map, N_STAR, M)
    nsq = sum(x * x for x in res28)
    assert nsq == sealed_nsq, (nsq, sealed_nsq)
    print("PASS independent rebuild of particular residual matches seal")

    rebuilt = free_fibre_tower(M, D, a_coeffs, mode="ker_L1", a_label=a_label)
    assert rebuilt["first_nonzero_terminal_F_order"] == N_STAR
    print("PASS free_fibre_tower rebuild agrees")

    # Residual family: a_d cancellation for ker[0]
    dim_ad = free_rank_jet(D, 2)
    R0 = res28
    cols_ad = []
    for s in range(dim_ad):
        ad = [Q(0)] * dim_ad
        ad[s] = Q(1)
        j2 = dict(jets_map)
        j2[D] = ("E_minus", pack_jet(D, "E_minus", ad))
        Rs = expand_F_order_N(j2, N_STAR, M)
        cols_ad.append([Rs[i] - R0[i] for i in range(len(R0))])
    rk_ad, ok_ad, sol_ad = mat_rank_solve(cols_ad, [-x for x in R0])
    assert ok_ad and sol_ad is not None
    j2 = dict(jets_map)
    j2[D] = ("E_minus", pack_jet(D, "E_minus", sol_ad))
    assert all(x == 0 for x in expand_F_order_N(j2, N_STAR, M))
    fam_res = load("family_residual_e_ge7_generic_swap_both.json")
    assert fam_res["zero_locus"]["killed"] is False
    assert fam_res["zero_locus"]["status"] == "NONEMPTY"
    sealed_sol = fam_res["ker_L1_0_explicit_system"]["particular_solution_a_d_nonzero"]
    # check sealed solution cancels
    ad_sealed = [Q(0)] * dim_ad
    for entry in sealed_sol:
        ad_sealed[entry["a_d_index"]] = parse_q(entry["coeff"])
    j3 = dict(jets_map)
    j3[D] = ("E_minus", pack_jet(D, "E_minus", ad_sealed))
    assert all(x == 0 for x in expand_F_order_N(j3, N_STAR, M))
    print(f"PASS residual family a_d cancellation (rank={rk_ad})")

    # Based family: high-order ker cancellation for ker[0]
    Kercache = {}
    for r in isolable_r_list(M, D):
        if r == 1:
            Kercache[r] = ker
        else:
            Kercache[r] = nullspace(Acache[r])

    linear_rs = [r for r in isolable_r_list(M, D) if r >= 13]
    cols = []
    meta = []
    for r in linear_rs:
        order_b = M + r
        for j, v in enumerate(Kercache[r]):
            j2 = dict(jets_map)
            base = particular[order_b]
            j2[order_b] = (
                "E_plus",
                pack_jet(
                    order_b,
                    "E_plus",
                    [base[i] + v[i] for i in range(len(base))],
                ),
            )
            Rj = expand_F_order_N(j2, N_STAR, M)
            col = [Rj[i] - R0[i] for i in range(len(R0))]
            if any(c != 0 for c in col):
                cols.append(col)
                meta.append((order_b, r, j, v))
    rk_h, ok_h, sol_h = mat_rank_solve(cols, [-x for x in R0])
    assert ok_h and sol_h is not None
    j2 = dict(jets_map)
    deltas = {}
    for (order_b, r, j, v), s in zip(meta, sol_h):
        if s == 0:
            continue
        deltas.setdefault(order_b, [Q(0)] * len(v))
        for t in range(len(v)):
            deltas[order_b][t] += s * v[t]
    for order_b, delta in deltas.items():
        base = particular[order_b]
        j2[order_b] = (
            "E_plus",
            pack_jet(
                order_b,
                "E_plus",
                [base[i] + delta[i] for i in range(len(base))],
            ),
        )
    assert all(x == 0 for x in expand_F_order_N(j2, N_STAR, M))
    fam_based = load("family_based_minus_lines_odd_m.json")
    assert fam_based["zero_locus"]["killed"] is False
    assert fam_based["zero_locus"]["status"] == "NONEMPTY"
    print(f"PASS based family high-order ker cancellation (rank={rk_h})")

    # Exit checks
    exit_j = load("exit.json")
    assert exit_j["exit"] == "P25-TOWER-SURVIVES"
    assert exit_j["headline"] == "OPEN"
    assert exit_j["not_a_covariant"] is True
    assert exit_j["gate_G1"] == "PASS"
    assert exit_j["N_star"] == N_STAR
    assert exit_j["terminal_F_order"] == TERMINAL
    assert exit_j["families"]["based_minus_lines_odd_m"]["killed"] is False
    assert exit_j["families"]["residual_e_ge7_generic_swap_both"]["killed"] is False
    print("PASS exit P25-TOWER-SURVIVES, headline OPEN")

    zl = load("zero_locus_Nstar.json")
    assert zl["decision"]["exit"] == "P25-TOWER-SURVIVES"
    assert zl["decision"]["both_families_killed"] is False
    print("PASS zero_locus decision consistent")

    seal = load("SEAL.json")
    assert seal["terminal_marker"] == "P25-TOWER-SURVIVES"
    assert seal["headline"] == "OPEN"
    assert seal["resource_exceeded_8GB"] is False
    print("PASS SEAL")

    assert (GFL / "FINITE_TRUNCATION_THEOREM.md").is_file()
    pre = load("resource_preflight.json")
    assert pre["exceeded_8GB"] is False
    assert pre["max_RSS_authorized_GB"] == 8
    print("PASS G1 theorem present; resource under 8 GiB")

    # Monomial check for residual support
    support = [i for i, c in enumerate(R0) if c != 0]
    mons = monoms_bin(N_STAR)
    print(
        f"PASS residual support monoms={[list(mons[i]) for i in support]} "
        f"coeffs={[str(R0[i]) for i in support]}"
    )

    print("P25_1_TOWER_VERIFY_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
