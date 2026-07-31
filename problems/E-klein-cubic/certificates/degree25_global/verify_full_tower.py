#!/usr/bin/env python3
"""Independent verifier for P25R.2 full finite tower.

Does not import produce_full_tower.py.
Replays free A_ad rank and residual-image nonsolvability at one holdout prime.
"""

from __future__ import annotations

import json
import sys
from fractions import Fraction as Q
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import common_p25r as C  # noqa: E402

ROOT = C.ROOT
GFL = ROOT / "certificates" / "global_finite_lifting"
sys.path.insert(0, str(GFL))
from common_g3 import (  # noqa: E402
    expand_F_order_N,
    free_rank_jet,
    isolable_r_list,
    L_matrix_sparse,
    matrix_from_coo,
    nullspace,
    pack_jet,
    parse_q,
    sample_leading_a_triv,
    solve_least_particular,
)


def check_self_hash(path: Path) -> None:
    data = json.loads(path.read_text())
    claimed = data["self_sha256"]
    body = {k: v for k, v in data.items() if k != "self_sha256"}
    assert claimed == C.sha256_bytes(C.canonical_json(body).encode()), path.name


def replay_ker0_residual_image(p: int = 89, z: int = 78) -> None:
    M, D, N_STAR = C.M_PLANE, C.DEGREE, C.N_STAR
    a0, _ = sample_leading_a_triv(M)
    Acache = {}
    for r in isolable_r_list(M, D):
        sp = L_matrix_sparse(M, r, a0)
        Acache[r] = matrix_from_coo(
            sp["shape"][0],
            sp["shape"][1],
            sp["coo_rows"],
            sp["coo_cols"],
            [parse_q(x) for x in sp["coo_data"]],
        )
    sp1 = L_matrix_sparse(M, 1, a0)
    A1 = matrix_from_coo(
        sp1["shape"][0],
        sp1["shape"][1],
        sp1["coo_rows"],
        sp1["coo_cols"],
        [parse_q(x) for x in sp1["coo_data"]],
    )
    ker1 = nullspace(A1)
    b2 = ker1[0]
    dim_ad = free_rank_jet(D, 2)

    jets = {
        M: ("E_minus", pack_jet(M, "E_minus", a0)),
        2: ("E_plus", pack_jet(2, "E_plus", b2)),
    }
    for k in range(3, D + 1, 2):
        jets[k] = ("E_minus", pack_jet(k, "E_minus", [Q(0)] * free_rank_jet(k, 2)))
    for r in isolable_r_list(M, D):
        if r == 1:
            continue
        res = expand_F_order_N(jets, 3 * M + r, M)
        sol, _ = solve_least_particular(Acache[r], [-x for x in res])
        jets[M + r] = ("E_plus", pack_jet(M + r, "E_plus", sol))
    for k in range(2, D + 1, 2):
        if k not in jets:
            jets[k] = ("E_plus", pack_jet(k, "E_plus", [Q(0)] * free_rank_jet(k, 3)))

    R0 = expand_F_order_N(jets, N_STAR, M)
    cols = []
    for j in range(dim_ad):
        ad = [Q(0)] * dim_ad
        ad[j] = Q(1)
        j2 = dict(jets)
        j2[D] = ("E_minus", pack_jet(D, "E_minus", ad))
        Rj = expand_F_order_N(j2, N_STAR, M)
        cols.append([Rj[i] - R0[i] for i in range(len(R0))])
    rk_free, ok_free, _ = C.solve_Q(cols, [-x for x in R0])
    assert rk_free == 27 and ok_free

    recon = C.load_reconstructor()
    module = recon.load_module(p, z)
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in C.load_seeds()
    ]
    _invol, plus, minus = C.involution_eigenspaces(module, p)
    ker = C.arrangement_kernel(module, seeds, plus, p)
    based = C.residual_restriction_map(module, seeds, ker, plus, minus, p)
    image = C.image_basis_from_map(based, p)
    assert image.shape[1] == 7

    A = np.zeros((len(R0), dim_ad), dtype=np.int64)
    for j, col in enumerate(cols):
        for i, v in enumerate(col):
            A[i, j] = C.reduce_Q_mod(v, p)
    Rm = np.array([C.reduce_Q_mod(v, p) for v in R0], dtype=np.int64)
    assert int(np.count_nonzero(Rm)) > 0
    Aimg = (A @ image) % p
    rk_img = C.rank_mod(Aimg, p)
    rk_aug = C.rank_mod(np.column_stack([Aimg, Rm]), p)
    assert rk_img == 7
    assert rk_aug == 8  # not solvable
    print(f"  replay p={p}: free solvable, residual-image unsolvable OK", flush=True)


def main() -> None:
    print("verify_full_tower: start", flush=True)
    for name in (
        "exit_p25r1.json",
        "exit_p25r2.json",
        "elimination_ledger.json",
        "equivalence_to_842.json",
        "projective_support_preborder.json",
        "tower_equations/free_path_A_ad.json",
        "tower_equations/residual_image_Nstar.json",
        "tower_equations/unresolved_sparse_system.json",
        "tower_equations/resource_preflight.json",
    ):
        check_self_hash(HERE / name)

    e2 = json.loads((HERE / "exit_p25r2.json").read_text())
    assert e2["exit"] == "P25R2-UNDECIDED"
    assert e2["P25_GLOBAL_EMPTY"] is False
    assert e2["P25_GLOBAL_SURVIVES"] is False
    assert e2["residual_free_path_killed_in_genuine_image"] is True
    assert e2["not_a_covariant"] is True

    free = json.loads((HERE / "tower_equations/free_path_A_ad.json").read_text())
    assert all(r["A_ad_free_rank"] == 27 for r in free["ker_L1"])
    assert all(r["free_a_d_cancellable"] for r in free["ker_L1"])

    res = json.loads((HERE / "tower_equations/residual_image_Nstar.json").read_text())
    assert res["promotion"]["primes_agree_nonsolvable"] is True
    for row in res["primes"]:
        assert row["all_ker_L1_nonsolvable"] is True
        assert row["residual_image_rank"] == 7

    equiv = json.loads((HERE / "equivalence_to_842.json").read_text())
    assert equiv["equivalence"]["row_ideal_containment_both_directions_over_Q"] is False
    assert "GAP" in equiv["equivalence"]["residual_gap"]

    pre = json.loads((HERE / "tower_equations/resource_preflight.json").read_text())
    assert pre["decision"] == "USE_SPARSE_POLAR"
    assert pre["dense_materialized"] is False

    assert (HERE / "FULL_FINITE_TOWER.md").is_file()
    replay_ker0_residual_image(89, 78)
    print("P25R2_FULL_TOWER_VERIFIED", flush=True)


if __name__ == "__main__":
    main()
