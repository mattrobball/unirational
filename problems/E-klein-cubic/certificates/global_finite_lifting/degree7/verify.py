#!/usr/bin/env python3
"""Independent verifier for the degree-7 finite global lifting tower.

Does NOT import produce.py. Rebuilds polar ranks, stage ledger, and the
ker-L1 free-fibre residual at F-order 10 from common_d7 helpers only.
"""

from __future__ import annotations

import json
import sys
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
GFL = HERE.parent
CERT = GFL.parent
ROOT = CERT.parent
sys.path.insert(0, str(HERE))

from common_d7 import (  # noqa: E402
    D,
    M,
    L_matrix_sparse,
    domain_basis_Eplus,
    free_rank_jet,
    jet_dimension_table,
    matrix_from_coo,
    monoms_bin,
    nullspace,
    solve_least_particular,
    stage_ledger,
)


def pack_jet(order: int, target: str, coeffs: list[Q]) -> dict:
    if target == "E_minus":
        keys = [(mon, j) for mon in monoms_bin(order) for j in (0, 1)]
    else:
        keys = domain_basis_Eplus(order)
    assert len(coeffs) == len(keys)
    return {keys[i]: Q(coeffs[i]) for i in range(len(keys))}


def Phi_plus(u, v, w) -> Q:
    s = Q(0)
    for t in range(3):
        s += u[t] * v[t] * w[t]
    s += (
        -Q(1, 2)
        * (
            u[0] * v[1] * w[2]
            + u[0] * v[2] * w[1]
            + u[1] * v[0] * w[2]
            + u[1] * v[2] * w[0]
            + u[2] * v[0] * w[1]
            + u[2] * v[1] * w[0]
        )
    )
    return s


def B_form(z, yA, yB) -> Q:
    return (
        z[0] * (yA[0] * yB[1] + yA[1] * yB[0])
        + z[1] * yA[1] * yB[1]
        + z[2] * yA[0] * yB[0]
    )


def Phi_mixed(u_type, u, v_type, v, w_type, w) -> Q:
    types = (u_type, v_type, w_type)
    n_plus = types.count("E_plus")
    n_minus = types.count("E_minus")
    if n_minus == 3:
        return Q(0)
    if n_plus == 3:
        return Phi_plus(u, v, w)
    if n_plus == 1 and n_minus == 2:
        if u_type == "E_plus":
            return B_form(u, v, w) / Q(3)
        if v_type == "E_plus":
            return B_form(v, u, w) / Q(3)
        return B_form(w, u, v) / Q(3)
    return Q(0)


def expand_F_order_N(jets, N, m=M):
    orders = sorted(o for o in jets if o >= m)
    cod = monoms_bin(N)
    acc = [Q(0) for _ in cod]
    cod_index = {mn: i for i, mn in enumerate(cod)}
    for i in orders:
        for j in orders:
            for k in orders:
                if i + j + k != N:
                    continue
                ti, ji = jets[i]
                tj, jj = jets[j]
                tk, jk = jets[k]
                for (ai, ii), ci in ji.items():
                    if ci == 0:
                        continue
                    for (aj, jj_), cj in jj.items():
                        if cj == 0:
                            continue
                        for (ak, kk_), ck in jk.items():
                            if ck == 0:
                                continue
                            tot = (
                                ai[0] + aj[0] + ak[0],
                                ai[1] + aj[1] + ak[1],
                            )
                            if tot not in cod_index:
                                continue

                            def vec(target, idx):
                                dim = 3 if target == "E_plus" else 2
                                v = [Q(0)] * dim
                                v[idx] = Q(1)
                                return v

                            phi = Phi_mixed(
                                ti, vec(ti, ii), tj, vec(tj, jj_), tk, vec(tk, kk_)
                            )
                            acc[cod_index[tot]] += phi * ci * cj * ck
    return acc


def load(name: str) -> dict:
    return json.loads((HERE / name).read_text())


def main() -> int:
    print("=== G2 degree-7 tower independent verifier ===")

    # Required artifacts
    required = [
        "stage_ledger.json",
        "jet_dimensions.json",
        "free_Lr_ranks.json",
        "first_terminal_stage.json",
        "global_correction_modules.json",
        "tower_sample_based_zero.json",
        "tower_sample_kerL1.json",
        "reconcile_degree7_exclusion.json",
        "exit.json",
        "SUMMARY.json",
        "TOWER.md",
        "common_d7.py",
    ]
    for name in required:
        assert (HERE / name).is_file(), f"missing {name}"
    print(f"PASS {len(required)} required artifacts present")

    # Rebuild ledger
    ledger = stage_ledger(M, D)
    assert ledger["terminal_F_order"] == 21
    assert ledger["nonautomatic_orders"] == [4, 6, 8, 10, 12, 14, 16, 18, 20]
    saved = load("stage_ledger.json")
    assert saved["nonautomatic_orders"] == ledger["nonautomatic_orders"]
    print("PASS stage ledger rebuild matches")

    # First non-isolable stage = 10
    first = load("first_terminal_stage.json")
    assert first["first_stage_without_Eplus_poly_isolator"] == 10
    assert first["last_isolable_Eplus_F_order"] == 8
    print("PASS first terminal stage F-order 10")

    # Jet dims
    jets = jet_dimension_table(M, D)
    saved_j = load("jet_dimensions.json")
    assert saved_j["total_multi_rees_dim"] == jets["total_multi_rees_dim"] == 722
    print("PASS multi-Rees total dim 722")

    # Free L_r ranks at a_triv
    a_triv = [Q(0), Q(1), Q(1), Q(0)]
    for r, exp_shape, exp_rank, exp_coker in (
        (1, [5, 9], 5, 0),
        (3, [7, 15], 7, 0),
        (5, [9, 21], 9, 0),
    ):
        L = L_matrix_sparse(M, r, a_triv)
        assert L["shape"] == exp_shape
        assert L["rank_over_Q"] == exp_rank
        assert L["cokernel_dim_over_Q"] == exp_coker
    print("PASS free L1,L3,L5 surjective on a_triv (exact Q ranks)")

    # G4 architecture present
    g4 = load("global_correction_modules.json")
    assert g4["architecture"].startswith("plane_normalization")
    assert g4["irrelevant_torsion_retained"] is True
    assert g4["repaired_category_retained"] is True
    for st in g4["stages"]:
        assert len(st["layers"]) == 3
        names = [ly["layer"] for ly in st["layers"]]
        assert names == [
            "plane_normalization",
            "triple_line_equalizer",
            "residual_point_kernel",
        ]
    print(f"PASS G4 architecture on {len(g4['stages'])} stages")

    # Rebuild ker-L1 sample residual at F-order 10
    L1 = L_matrix_sparse(M, 1, a_triv)
    A1 = matrix_from_coo(
        L1["shape"][0],
        L1["shape"][1],
        L1["coo_rows"],
        L1["coo_cols"],
        [Q(x) for x in L1["coo_data"]],
    )
    ker = nullspace(A1)
    assert len(ker) == 4
    b2 = ker[0]
    jets_map = {
        1: ("E_minus", pack_jet(1, "E_minus", a_triv)),
        2: ("E_plus", pack_jet(2, "E_plus", b2)),
        3: ("E_minus", pack_jet(3, "E_minus", [Q(0)] * free_rank_jet(3, 2))),
    }
    L3 = L_matrix_sparse(M, 3, a_triv)
    res6 = expand_F_order_N(jets_map, 6)
    A3 = matrix_from_coo(
        L3["shape"][0],
        L3["shape"][1],
        L3["coo_rows"],
        L3["coo_cols"],
        [Q(x) for x in L3["coo_data"]],
    )
    sol4, _ = solve_least_particular(A3, [-x for x in res6])
    assert sol4 is not None
    jets_map[4] = ("E_plus", pack_jet(4, "E_plus", sol4))
    jets_map[5] = ("E_minus", pack_jet(5, "E_minus", [Q(0)] * free_rank_jet(5, 2)))
    L5 = L_matrix_sparse(M, 5, a_triv)
    res8 = expand_F_order_N(jets_map, 8)
    A5 = matrix_from_coo(
        L5["shape"][0],
        L5["shape"][1],
        L5["coo_rows"],
        L5["coo_cols"],
        [Q(x) for x in L5["coo_data"]],
    )
    sol6, _ = solve_least_particular(A5, [-x for x in res8])
    assert sol6 is not None
    jets_map[6] = ("E_plus", pack_jet(6, "E_plus", sol6))
    jets_map[7] = ("E_minus", pack_jet(7, "E_minus", [Q(0)] * free_rank_jet(7, 2)))

    for N in (4, 6, 8):
        r = expand_F_order_N(jets_map, N)
        assert all(x == 0 for x in r), f"early F-order {N} not solved"
    res10 = expand_F_order_N(jets_map, 10)
    nsq = sum(x * x for x in res10)
    assert nsq != 0, "terminal residual at F-order 10 vanished unexpectedly"
    saved_s1 = load("tower_sample_kerL1.json")
    assert saved_s1["first_nonzero_terminal_F_order"] == 10
    assert saved_s1["terminal_residuals"]["10"]["is_zero"] is False
    # Match sealed norm if present
    sealed_nsq = Q(saved_s1["terminal_residuals"]["10"]["residual_norm_sq"])
    assert sealed_nsq == nsq, (sealed_nsq, nsq)
    print(f"PASS ker-L1 free-fibre residual at F-order 10 nonzero (norm^2={nsq})")

    # Exit
    exit_j = load("exit.json")
    assert exit_j["exit"] == "G7-OBSTRUCTION"
    assert exit_j["headline"] == "OPEN"
    assert exit_j["gate_G1"] == "PASS"
    assert exit_j["not_a_covariant"] is True
    print("PASS exit G7-OBSTRUCTION, headline OPEN")

    # Reconcile
    recon = load("reconcile_degree7_exclusion.json")
    assert recon["consistency"] == "TOWER_AGREES_WITH_EXCLUSION"
    assert recon["accepted_exclusion"]["landing_exclusion"]["septic_script_pass"] is True
    print("PASS reconcile with degree-7 exclusion")

    # G1 theorem still present
    assert (GFL / "FINITE_TRUNCATION_THEOREM.md").is_file()
    assert "Gate G1: PASS" in (GFL / "FINITE_TRUNCATION_THEOREM.md").read_text()
    print("PASS G1 theorem present")

    print("G7_TOWER_VERIFY_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
