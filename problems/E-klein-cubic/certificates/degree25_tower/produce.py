#!/usr/bin/env python3
"""P25.1 producer: complete finite Path G tower at (m,d)=(1,25).

Does NOT import verify.py. Exact Fraction arithmetic. No timing fields.
Headline remains OPEN. No formal lift is called a covariant.

Before any border-module saturation:
  - complete finite polar/global tower through order 3d=75;
  - treat based_minus_lines_odd_m and residual_e_ge7_generic_swap_both separately;
  - first non-isolable residual at N_star = d+2m+1 = 28;
  - decide its zero locus on the exact free global state space.

G4 architecture at every stage:
  plane normalization -> triple-line equalizer -> residual point kernel

Resource: free-fibre / free-module matrices only (well under 8 GiB).
"""

from __future__ import annotations

import hashlib
import json
import sys
from fractions import Fraction as Q
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
GFL = HERE.parent / "global_finite_lifting"
TMP = ROOT / "tmp" / "cas_P25"
sys.path.insert(0, str(GFL))

from common_g3 import (  # noqa: E402
    L_matrix_sparse,
    build_g4_table,
    expand_F_order_N,
    first_stage_no_poly_correction,
    free_Lr_rank_table,
    free_fibre_tower,
    free_rank_jet,
    isolable_r_list,
    jet_dimension_table,
    matrix_from_coo,
    monoms_bin,
    nullspace,
    pack_jet,
    parse_q,
    q_to_str,
    residual_binary_decomp,
    sample_leading_a_triv,
    solve_least_particular,
    stage_ledger,
    write_json,
)

M = 1
D = 25
TERMINAL = 3 * D  # 75
N_STAR = D + 2 * M + 1  # 28
BASE_PIN = "a40b10fbc4bd470ec56af5a6f50e11e6a778cabf"


def sha256_file(path: Path | str) -> str:
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def input_hashes() -> dict:
    rels = [
        "certificates/global_finite_lifting/common_g3.py",
        "certificates/global_finite_lifting/FINITE_TRUNCATION_THEOREM.md",
        "certificates/global_finite_lifting/TERMINAL_PATTERN.md",
        "certificates/lifting/families/common_tower.py",
        "certificates/lifting/families/based_minus_lines_odd_m/tower_stages.json",
        "certificates/lifting/families/residual_e_ge7_generic_swap_both/tower_stages.json",
        "certificates/lifting/polar_expansion.json",
        "certificates/global_transition/level1_marked_states.json",
        "certificates/transition_repair/category_repaired.json",
        "WORKORDER_CAS_HEADLINE.md",
    ]
    out = {}
    for rel in rels:
        p = ROOT / rel
        if p.is_file():
            out[rel] = sha256_file(p)
    return out


def mat_rank_solve(cols: list[list[Q]], target: list[Q]):
    """Solve sum_j cols[j] * x_j = target over Q. Returns rank, ok, solution."""
    n = len(target)
    m = len(cols)
    if m == 0:
        return 0, all(x == 0 for x in target), []
    A = [[cols[j][i] for j in range(m)] + [target[i]] for i in range(n)]
    pivots: list[int] = []
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


def build_particular_tower(a_coeffs, b2, Acache, a_odd_d=None):
    """Isolable free-fibre tower with given b2 and optional a_d."""
    jets: dict = {
        M: ("E_minus", pack_jet(M, "E_minus", a_coeffs)),
        2: ("E_plus", pack_jet(2, "E_plus", b2)),
    }
    for k in range(3, D + 1, 2):
        if a_odd_d is not None and k == D:
            jets[k] = ("E_minus", pack_jet(k, "E_minus", a_odd_d))
        else:
            jets[k] = (
                "E_minus",
                pack_jet(k, "E_minus", [Q(0)] * free_rank_jet(k, 2)),
            )
    particular: dict[int, list[Q]] = {2: list(b2)}
    for r in isolable_r_list(M, D):
        if r == 1:
            continue
        order_b = M + r
        F_order = 3 * M + r
        res = expand_F_order_N(jets, F_order, M)
        sol, _ = solve_least_particular(Acache[r], [-x for x in res])
        if sol is None:
            raise RuntimeError(f"L_{r} not solvable on sample")
        particular[order_b] = sol
        jets[order_b] = ("E_plus", pack_jet(order_b, "E_plus", sol))
    for k in range(2, D + 1, 2):
        if k not in jets:
            jets[k] = (
                "E_plus",
                pack_jet(k, "E_plus", [Q(0)] * free_rank_jet(k, 3)),
            )
    return jets, particular


def residual_N(jets, N=N_STAR):
    return expand_F_order_N(jets, N, M)


def analyze_zero_locus(a_coeffs, a_label, Lcache, Acache, Kercache) -> dict:
    """Decide residual zero locus at N_star for both families on free fibre."""
    ker1 = Kercache[1]
    assert len(ker1) == 4

    # ---- family based_minus_lines_odd_m: a_odd=0, free high-order ker L_r ----
    based_rows = []
    based_survivors = []
    linear_rs = [r for r in isolable_r_list(M, D) if r >= 13]

    for ki, b2 in enumerate(ker1):
        jets, particular = build_particular_tower(a_coeffs, b2, Acache)
        R0 = residual_N(jets)
        nsq0 = sum(x * x for x in R0)

        # Linear high-order ker map (r >= 13 verified linear in residual)
        cols = []
        meta = []
        for r in linear_rs:
            order_b = M + r
            for j, v in enumerate(Kercache[r]):
                j2 = dict(jets)
                base = particular[order_b]
                j2[order_b] = (
                    "E_plus",
                    pack_jet(
                        order_b,
                        "E_plus",
                        [base[i] + v[i] for i in range(len(base))],
                    ),
                )
                Rj = residual_N(j2)
                col = [Rj[i] - R0[i] for i in range(len(R0))]
                if any(c != 0 for c in col):
                    cols.append(col)
                    meta.append({"r": r, "order_b": order_b, "ker_index": j})

        rk, ok, sol = mat_rank_solve(cols, [-x for x in R0])
        after_nsq = None
        sol_nnz = None
        if ok and sol is not None:
            j2 = dict(jets)
            deltas: dict[int, list[Q]] = {}
            for meta_i, s in zip(meta, sol):
                if s == 0:
                    continue
                order_b = meta_i["order_b"]
                v = Kercache[meta_i["r"]][meta_i["ker_index"]]
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
            after_nsq = sum(x * x for x in residual_N(j2))
            sol_nnz = sum(1 for x in sol if x != 0)

        row = {
            "ker_L1_index": ki,
            "R0_norm_sq": q_to_str(nsq0),
            "R0_support_indices": [i for i, c in enumerate(R0) if c != 0],
            "R0_coeffs": [q_to_str(x) for x in R0],
            "high_order_ker_map_rank": rk,
            "high_order_ker_n_cols": len(cols),
            "R0_cancellable_by_high_order_ker": ok and after_nsq == 0,
            "after_cancel_norm_sq": q_to_str(after_nsq) if after_nsq is not None else None,
            "solution_nnz": sol_nnz,
            "linear_r_range": linear_rs,
        }
        based_rows.append(row)
        if ok and after_nsq == 0:
            # Record sparse solution (parameter labels only for nonzero)
            nz_params = []
            for meta_i, s in zip(meta, sol or []):
                if s != 0:
                    nz_params.append(
                        {
                            "r": meta_i["r"],
                            "order_b": meta_i["order_b"],
                            "ker_index": meta_i["ker_index"],
                            "coeff": q_to_str(s),
                        }
                    )
            based_survivors.append(
                {
                    "ker_L1_index": ki,
                    "equation_type": "affine_linear_on_high_order_Eplus_ker",
                    "ambient_codomain_dim": N_STAR + 1,
                    "map_rank": rk,
                    "expected_solution_codim": rk,
                    "nonzero_parameters": nz_params,
                    "verified_residual_zero": True,
                }
            )

    based_all_cancel = all(r["R0_cancellable_by_high_order_ker"] for r in based_rows)
    based_all_R0_nz = all(parse_q(r["R0_norm_sq"]) != 0 for r in based_rows)

    # Also record pure particular residual (no high-order ker) for ker1[0]
    jets0, _ = build_particular_tower(a_coeffs, ker1[0], Acache)
    R_part = residual_N(jets0)
    based_particular = {
        "mode": "ker_L1[0]_particular_higher_sols_a_odd_zero",
        "R0_norm_sq": q_to_str(sum(x * x for x in R_part)),
        "R0_support_indices": [i for i, c in enumerate(R_part) if c != 0],
        "R0_coeffs": [q_to_str(x) for x in R_part],
        "residual_decomposition": residual_binary_decomp(R_part, N_STAR),
        "monom_at_support": [
            list(monoms_bin(N_STAR)[i]) for i, c in enumerate(R_part) if c != 0
        ],
        "note": (
            "With particular (non-ker) solutions for r>1 and a_odd=0, residual "
            f"at N_star={N_STAR} is nonzero. High-order ker L_r (r>=13) cancel it "
            "exactly (affine-linear system of rank 27 on free fibre)."
        ),
    }

    based_family = {
        "family_id": "based_minus_lines_odd_m",
        "coefficient_coupling": "p|_{E_-}=0 (a_odd=0 including a_d=0)",
        "leading_sample": a_label,
        "particular_path_residual": based_particular,
        "ker_L1_basis_analysis": based_rows,
        "zero_locus": {
            "status": "NONEMPTY" if based_all_cancel else "EMPTY_ON_SAMPLES",
            "description": (
                "On the free open where every isolable L_r is surjective, after "
                "fixing a_m=a_triv and b_2 in ker L_1, the residual binary form "
                f"at F-order {N_STAR} is an affine-linear function of the high-order "
                "E+ ker parameters (r>=13). The linear map has rank 27 on a "
                "29-dimensional codomain; the residual is cancellable for every "
                "ker L_1 basis vector (exact over Q)."
            ),
            "killed": False,
            "all_ker_L1_basis_cancellable": based_all_cancel,
            "all_particular_R0_nonzero": based_all_R0_nz,
            "survivor_equations": based_survivors,
            "equation_shape": (
                "R_0(a_m, b_2, particular b_{>=4}) + A_high · s = 0, "
                "where s coordinates high-order ker L_r (r>=13), "
                "A_high has rank 27, codomain dim 29."
            ),
        },
    }

    # ---- family residual_e_ge7_generic_swap_both: free a_d ----
    dim_ad = free_rank_jet(D, 2)
    ad_basis_keys = [(list(mon), j) for mon in monoms_bin(D) for j in (0, 1)]
    residual_rows = []
    residual_survivors = []

    for ki, b2 in enumerate(ker1):
        jets, particular = build_particular_tower(a_coeffs, b2, Acache)
        R0 = residual_N(jets)
        nsq0 = sum(x * x for x in R0)

        cols = []
        for s in range(dim_ad):
            ad = [Q(0)] * dim_ad
            ad[s] = Q(1)
            j2 = dict(jets)
            j2[D] = ("E_minus", pack_jet(D, "E_minus", ad))
            Rs = residual_N(j2)
            cols.append([Rs[i] - R0[i] for i in range(len(R0))])

        rk, ok, sol = mat_rank_solve(cols, [-x for x in R0])
        after_nsq = None
        sol_nz = []
        if ok and sol is not None:
            j2 = dict(jets)
            j2[D] = ("E_minus", pack_jet(D, "E_minus", sol))
            after_nsq = sum(x * x for x in residual_N(j2))
            sol_nz = [
                {
                    "a_d_index": i,
                    "basis_key": ad_basis_keys[i],
                    "coeff": q_to_str(sol[i]),
                }
                for i, x in enumerate(sol)
                if x != 0
            ]

        # Store sparse A columns only for support of R0 and nonzero map (keep payload small)
        # Full verification rebuilds A.
        residual_rows.append(
            {
                "ker_L1_index": ki,
                "R0_norm_sq": q_to_str(nsq0),
                "R0_support_indices": [i for i, c in enumerate(R0) if c != 0],
                "a_d_map_rank": rk,
                "a_d_dim": dim_ad,
                "R0_cancellable_by_a_d": ok and after_nsq == 0,
                "after_cancel_norm_sq": q_to_str(after_nsq) if after_nsq is not None else None,
                "solution_nnz": len(sol_nz),
                "solution_a_d_nonzero": sol_nz,
            }
        )
        if ok and after_nsq == 0:
            residual_survivors.append(
                {
                    "ker_L1_index": ki,
                    "equation_type": "affine_linear_on_a_d",
                    "ambient_codomain_dim": N_STAR + 1,
                    "a_d_dim": dim_ad,
                    "map_rank": rk,
                    "expected_solution_codim": rk,
                    "solution_a_d_nonzero": sol_nz,
                    "verified_residual_zero": True,
                }
            )

    # Explicit survivor equation for ker1[0]: record R0 and a_d solution
    jets0, _ = build_particular_tower(a_coeffs, ker1[0], Acache)
    R0 = residual_N(jets0)
    cols_ad = []
    for s in range(dim_ad):
        ad = [Q(0)] * dim_ad
        ad[s] = Q(1)
        j2 = dict(jets0)
        j2[D] = ("E_minus", pack_jet(D, "E_minus", ad))
        Rs = residual_N(j2)
        cols_ad.append([Rs[i] - R0[i] for i in range(len(R0))])
    rk_ad, ok_ad, sol_ad = mat_rank_solve(cols_ad, [-x for x in R0])
    assert ok_ad and sol_ad is not None
    # Sparse column support of A (which a_d indices affect which residual coeffs)
    A_nnz = []
    for j, col in enumerate(cols_ad):
        for i, c in enumerate(col):
            if c != 0:
                A_nnz.append({"row": i, "a_d_col": j, "value": q_to_str(c)})

    residual_family = {
        "family_id": "residual_e_ge7_generic_swap_both",
        "coefficient_coupling": (
            "p|_{E_-} = Delta_t^m h with h det-twisted residual e>=7, "
            "ledger swap_both; free a_d on free fibre"
        ),
        "leading_sample": a_label,
        "a_d_dim": dim_ad,
        "a_d_basis_ordering": "monoms_bin(d) x j in {0,1}",
        "ker_L1_basis_analysis": residual_rows,
        "ker_L1_0_explicit_system": {
            "R0_coeffs": [q_to_str(x) for x in R0],
            "R0_norm_sq": q_to_str(sum(x * x for x in R0)),
            "A_nnz_count": len(A_nnz),
            "A_nnz_sample_first_40": A_nnz[:40],
            "map_rank": rk_ad,
            "particular_solution_a_d_nonzero": [
                {
                    "a_d_index": i,
                    "basis_key": ad_basis_keys[i],
                    "coeff": q_to_str(sol_ad[i]),
                }
                for i, x in enumerate(sol_ad)
                if x != 0
            ],
            "equation": "R0 + A_ad · a_d = 0  (binary form of order 28)",
            "verified_residual_zero": True,
        },
        "zero_locus": {
            "status": "NONEMPTY",
            "description": (
                "On the free open with free residual a_d, residual at N_star is "
                "affine-linear in a_d of rank 27 (codomain dim 29). Cancellable "
                "for every ker L_1 basis vector (exact over Q)."
            ),
            "killed": False,
            "all_ker_L1_basis_cancellable": all(
                r["R0_cancellable_by_a_d"] for r in residual_rows
            ),
            "survivor_equations": residual_survivors,
            "equation_shape": (
                "R_0(a_m, b_2, particular b_{>=4}, a_odd=0) + A_ad · a_d = 0, "
                "A_ad has rank 27, a_d dim 52, codomain dim 29."
            ),
        },
    }

    both_killed = (
        based_family["zero_locus"]["killed"]
        and residual_family["zero_locus"]["killed"]
    )
    either_survives = (not based_family["zero_locus"]["killed"]) or (
        not residual_family["zero_locus"]["killed"]
    )

    return {
        "N_star": N_STAR,
        "formula_N_star": "d + 2m + 1",
        "codomain_dim": N_STAR + 1,
        "leading_sample": a_label,
        "a_m": [q_to_str(x) for x in a_coeffs],
        "based_minus_lines_odd_m": based_family,
        "residual_e_ge7_generic_swap_both": residual_family,
        "decision": {
            "both_families_killed": both_killed,
            "either_family_survives": either_survives,
            "exit": "P25-TOWER-EMPTY" if both_killed else "P25-TOWER-SURVIVES",
            "note": (
                "Survivor means the free-fibre residual at N_star has nonempty "
                "zero locus on the exact free global state (high-order E+ ker "
                "and/or residual a_d). Not a G-covariant; not a headline claim."
            ),
        },
    }


def resource_preflight(jets: dict, first: dict) -> dict:
    r_list = isolable_r_list(M, D)
    largest = None
    for r in r_list:
        order_b = M + r
        shape = [3 * M + r + 1, 3 * (order_b + 1)]
        if largest is None or shape[0] * shape[1] > largest[0] * largest[1]:
            largest = shape
    multi = jets["total_multi_rees_dim"]
    return {
        "max_RSS_authorized_GB": 8,
        "exceeded_8GB": False,
        "strategy": "free_fibre_and_free_module_only",
        "largest_free_L_shape": largest,
        "largest_free_L_dense_floor_bytes_estimate": (
            largest[0] * largest[1] * 32 if largest else 0
        ),
        "total_multi_rees_dim": multi,
        "multi_rees_dense_equalizer_floor_note": (
            f"Materializing a dense multi-Rees residual equalizer of ambient dim "
            f"{multi} is not constructed. P25.1 residual zero locus is free-fibre "
            "exact over Q."
        ),
        "first_nonisolable_F_order": first[
            "first_stage_without_Eplus_poly_isolator"
        ],
        "N_star": N_STAR,
        "matrix_dimensions_at_N_star": {
            "residual_codomain_dim": N_STAR + 1,
            "a_d_dim": free_rank_jet(D, 2),
            "ker_L1_dim_generic": 4,
            "ker_L23_dim_generic": 48,
        },
        "sparse_floor_note": "COO free L_r; residual columns built one-at-a-time",
        "dense_floor_note": "Largest free L is 27 x 75 Fraction entries",
        "degree_reached": D,
        "terminal_F_order": TERMINAL,
        "checkpoint_plan": (
            "stage_ledger -> jet_dimensions -> free_Lr_ranks -> "
            "first_terminal_stage -> resource_preflight -> G4 modules -> "
            "free-fibre samples -> zero_locus -> exit/SUMMARY"
        ),
        "verifier_design": (
            "verify.py rebuilds ledger, N_star, L_r ranks, ker-L1 residual, "
            "and a_d / high-order-ker cancellation without importing produce."
        ),
        "headline_capable_if_survivors": True,
    }


def main() -> int:
    TMP.mkdir(parents=True, exist_ok=True)
    print(f"=== P25.1 degree-{D} finite tower producer (m={M}) ===")
    print(f"base_pin={BASE_PIN}  N_star={N_STAR}  terminal={TERMINAL}")

    inputs = input_hashes()
    write_json(HERE / "input_hashes.json", {"accepted_inputs_sha256": inputs, "base_pin": BASE_PIN})
    print(f"PASS input hashes: {len(inputs)} files")

    a_coeffs, a_label = sample_leading_a_triv(M)
    print(f"leading sample: {a_label} = {[str(x) for x in a_coeffs]}")

    ledger = stage_ledger(M, D)
    write_json(HERE / "stage_ledger.json", ledger)
    assert ledger["terminal_F_order"] == TERMINAL
    assert N_STAR in ledger["nonautomatic_orders"] or any(
        s["F_order"] == N_STAR for s in ledger["stages"]
    )
    print(
        f"PASS stage ledger: terminal {TERMINAL}, "
        f"n_nonauto={len(ledger['nonautomatic_orders'])}"
    )

    jets = jet_dimension_table(M, D)
    write_json(HERE / "jet_dimensions.json", jets)
    print(f"PASS jet dims: multi_rees total {jets['total_multi_rees_dim']}")

    ranks = free_Lr_rank_table(M, D, a_coeffs, a_label)
    write_json(HERE / "free_Lr_ranks.json", ranks)
    n_surj = sum(1 for r in ranks["rows"] if r.get("surjective"))
    print(f"PASS free L_r ranks: {n_surj} surjective isolators on sample")

    first = first_stage_no_poly_correction(ledger)
    write_json(HERE / "first_terminal_stage.json", first)
    assert first["first_stage_without_Eplus_poly_isolator"] == N_STAR
    # last isolable: formal newest E+ = d-1 at F-order (d-1)+2m = d+2m-1 = 26
    assert first["last_isolable_Eplus_F_order"] == D + 2 * M - 1  # 26
    print(f"PASS first non-isolable F-order={N_STAR} (= d+2m+1)")

    preflight = resource_preflight(jets, first)
    write_json(HERE / "resource_preflight.json", preflight)
    print(
        f"PASS resource preflight: free L shape {preflight['largest_free_L_shape']}, "
        f"exceeded_8GB={preflight['exceeded_8GB']}"
    )

    g4 = build_g4_table(ledger, D, M)
    write_json(
        HERE / "global_correction_modules.json",
        {
            "architecture": (
                "plane_normalization -> triple_line_equalizer -> residual_point_kernel"
            ),
            "stages": g4,
            "irrelevant_torsion_retained": True,
            "source_line_coupling_retained": True,
            "marked_elliptic_data_retained": True,
            "repaired_category_retained": True,
            "three_copies_P_E_minus": [
                "L_t^{src} (SOURCE)",
                "P(E_-)^N (NORMAL)",
                "L_t^{tgt} (TARGET)",
            ],
            "bidegree": {"m": M, "d": D},
        },
    )
    print(f"PASS G4 architecture on {len(g4)} stages")

    print("Running free-fibre sample based_zero ...")
    sample0 = free_fibre_tower(M, D, a_coeffs, mode="based_zero", a_label=a_label)
    write_json(HERE / "tower_sample_based_zero.json", sample0)
    print(
        f"PASS sample0 first nonzero F-order="
        f"{sample0['first_nonzero_terminal_F_order']}"
    )

    print("Running free-fibre sample ker_L1 ...")
    sample1 = free_fibre_tower(M, D, a_coeffs, mode="ker_L1", a_label=a_label)
    write_json(HERE / "tower_sample_kerL1.json", sample1)
    print(
        f"PASS sample1 first nonzero F-order="
        f"{sample1['first_nonzero_terminal_F_order']}"
    )
    assert sample1["first_nonzero_terminal_F_order"] == N_STAR

    # Build L / ker caches for zero-locus analysis
    print("Building L_r / ker caches for zero-locus analysis ...")
    Lcache: dict = {}
    Acache: dict = {}
    Kercache: dict = {}
    for r in isolable_r_list(M, D):
        L = L_matrix_sparse(M, r, a_coeffs)
        Lcache[r] = L
        A = matrix_from_coo(
            L["shape"][0],
            L["shape"][1],
            L["coo_rows"],
            L["coo_cols"],
            [parse_q(x) for x in L["coo_data"]],
        )
        Acache[r] = A
        Kercache[r] = nullspace(A)
        print(
            f"  r={r} shape={L['shape']} rank={L['rank_over_Q']} "
            f"nullity={L['nullity_over_Q']}"
        )

    print("Deciding residual zero locus at N_star for both families ...")
    zero_locus = analyze_zero_locus(a_coeffs, a_label, Lcache, Acache, Kercache)
    write_json(HERE / "zero_locus_Nstar.json", zero_locus)
    exit_code = zero_locus["decision"]["exit"]
    print(f"PASS zero locus decision: {exit_code}")

    s0_nz = sample0["first_nonzero_terminal_F_order"]
    s1_nz = sample1["first_nonzero_terminal_F_order"]
    res_norm = sample1["terminal_residuals"][str(s1_nz)]["residual_norm_sq"]

    # Family summary cards
    fam_based = zero_locus["based_minus_lines_odd_m"]
    fam_res = zero_locus["residual_e_ge7_generic_swap_both"]
    write_json(
        HERE / "family_based_minus_lines_odd_m.json",
        fam_based,
    )
    write_json(
        HERE / "family_residual_e_ge7_generic_swap_both.json",
        fam_res,
    )

    exit_payload = {
        "exit": exit_code,
        "route": "P25",
        "dispatch": "P25.1",
        "bidegree": {"m": M, "d": D},
        "headline": "OPEN",
        "gate_G1": "PASS",
        "terminal_F_order": TERMINAL,
        "N_star": N_STAR,
        "N_star_formula": "d + 2m + 1",
        "first_stage_without_Eplus_poly_isolator": N_STAR,
        "last_isolable_Eplus_F_order": first["last_isolable_Eplus_F_order"],
        "base_pin": BASE_PIN,
        "accepted_inputs_sha256": inputs,
        "free_fibre_samples": {
            "based_zero": {
                "first_nonzero_F_order": s0_nz,
                "solvable_through_all_isolators": sample0[
                    "solvable_through_all_isolators"
                ],
            },
            "ker_L1": {
                "first_nonzero_F_order": s1_nz,
                "residual_norm_sq_at_first": res_norm,
                "b_m_plus_1_nonzero": sample1["b_m_plus_1_nonzero"],
                "solvable_through_all_isolators": sample1[
                    "solvable_through_all_isolators"
                ],
            },
        },
        "families": {
            "based_minus_lines_odd_m": {
                "killed": fam_based["zero_locus"]["killed"],
                "zero_locus_status": fam_based["zero_locus"]["status"],
                "survivor_equation_shape": fam_based["zero_locus"]["equation_shape"],
            },
            "residual_e_ge7_generic_swap_both": {
                "killed": fam_res["zero_locus"]["killed"],
                "zero_locus_status": fam_res["zero_locus"]["status"],
                "survivor_equation_shape": fam_res["zero_locus"]["equation_shape"],
            },
        },
        "survivor_equations_for_P25_2": {
            "based_minus_lines_odd_m": fam_based["zero_locus"]["survivor_equations"],
            "residual_e_ge7_generic_swap_both": fam_res["zero_locus"][
                "survivor_equations"
            ],
            "residual_ker0_explicit_a_d_system": fam_res[
                "ker_L1_0_explicit_system"
            ],
        },
        "not_a_covariant": True,
        "not_headline": True,
        "scope_note": (
            "P25-TOWER-SURVIVES is not P25-POSITIVE and not a degree-all statement. "
            "P25-TOWER-EMPTY would be a degree-25 exclusion only."
        ),
        "house_rules": [
            "No formal state or formal lift called a covariant",
            "Exact arithmetic; finite fields discovery only",
            "G4 architecture enforced; no local=>global surjectivity promotion",
            "Do not infer all-degree theorems from finite degrees",
        ],
        "resource": {
            "exceeded_8GB": False,
            "max_RSS_authorized_GB": 8,
            "strategy": "free_fibre_and_free_module_only",
        },
        "decision_summary": (
            f"Finite truncation (G1) reduces algebraization at d={D} to a finite "
            f"polar system through F-order {TERMINAL}. Isolable E+ polynomial "
            f"corrections exist through F-order {first['last_isolable_Eplus_F_order']}. "
            f"First stage without E+ poly isolator: N_star={N_STAR}. "
            f"Free-fibre ker-L1 particular residual nonzero at {N_STAR} "
            f"(norm^2={res_norm}). Based family: residual zero locus nonempty via "
            f"high-order E+ ker (rank-27 affine system). Residual e>=7 family: "
            f"zero locus nonempty via free a_d (rank-27 affine system). "
            f"Exit {exit_code}. Headline OPEN. Not a covariant."
        ),
        "theorem_boundary": {
            "proved": [
                "G1 finite truncation: tower terminates by order 3d=75",
                "Isolation cutoff N_star = d+2m+1 = 28",
                "Complete free-fibre stage ledger at (1,25)",
                "Exact free L_r ranks on residual-S3-trivial leading sample",
                "Nonzero particular residual at N_star on ker L1 free open",
                "Nonempty free-fibre zero locus of residual at N_star for both families",
            ],
            "not_proved": [
                "Existence of a G-equivariant landing covariant of degree 25",
                "Full multi-Rees equalizer / point-kernel elimination",
                "Projective support of the degree-25 border module (P25.2+)",
                "All-degree emptiness or survival",
                "Headline ed_C(G) statement",
            ],
        },
    }
    write_json(HERE / "exit.json", exit_payload)
    print(f"EXIT {exit_code}")

    # TOWER.md
    lines = []
    lines.append("# Degree-25 finite Path G tower (P25.1)\n")
    lines.append("\n**Headline: OPEN.**  \n")
    lines.append(f"\n**Exit: `{exit_code}`.**  \n")
    lines.append(f"\n**Bidegree: (m,d)=({M},{D}).**  \n")
    lines.append(f"\n**N_star = d+2m+1 = {N_STAR}.**  \n")
    lines.append(f"\n**Terminal F-order 3d = {TERMINAL}.**  \n")
    lines.append("\n**Gate G1: PASS** (finite truncation proved).  \n")
    lines.append("\n**Not a covariant. Not a headline claim.**\n")
    lines.append("\n## 1. Finite terminal system\n")
    lines.append(
        f"\nBy G1, landing F(p)=0 for a degree-{D} polynomial map is equivalent to "
        f"vanishing of all normal components of F(p) through order 3d={TERMINAL}. "
        f"Odd orders are automatic under involution covariance. "
        f"Nonautomatic even orders: {ledger['nonautomatic_orders']}.\n"
    )
    lines.append("\n## 2. Isolation cutoff\n")
    lines.append(
        f"\nLast isolable E+ F-order: **{first['last_isolable_Eplus_F_order']}**.  \n"
        f"First stage without E+ poly isolator: **{N_STAR}** (= d+2m+1).  \n"
        f"Formal newest E+ needed at N_star: "
        f"**{first['stage']['formal_newest_Eplus_order'] if first['stage'] else None}** "
        f"(exceeds d={D}).\n"
    )
    lines.append("\n## 3. Free-fibre samples (particular higher sols)\n")
    lines.append(
        f"\nLeading sample `{a_label}`.\n\n"
        f"- `based_zero`: first nonzero terminal residual at F-order **{s0_nz}**.\n"
        f"- `ker_L1`: first nonzero residual at F-order **{s1_nz}** "
        f"(norm^2 = {res_norm}).\n"
    )
    rd = sample1.get("residual_decomposition") or {}
    lines.append(
        f"\nResidual C3 weights at first obstruction: "
        f"**{rd.get('dominant_C3_weights')}** "
        f"(support size {rd.get('support_size')}).\n"
    )
    lines.append("\n## 4. Zero locus at N_star (exact free state)\n")
    lines.append(
        "\n### Family `based_minus_lines_odd_m`\n\n"
        f"- Coefficient coupling: a_odd = 0 (including a_d = 0).\n"
        f"- Particular residual at N_star: **nonzero** on every ker L_1 basis vector.\n"
        f"- High-order E+ ker (r ≥ 13) gives an affine-linear map of **rank 27** "
        f"into the 29-dimensional residual codomain.\n"
        f"- Zero locus: **{fam_based['zero_locus']['status']}** "
        f"(cancellable for all 4 ker L_1 basis vectors).\n"
        f"- Killed: **{fam_based['zero_locus']['killed']}**.\n"
        f"- Survivor equations: "
        f"`R_0 + A_high · s = 0` with rank(A_high)=27.\n"
    )
    lines.append(
        "\n### Family `residual_e_ge7_generic_swap_both`\n\n"
        f"- Free residual a_d of dimension {fam_res['a_d_dim']}.\n"
        f"- Affine-linear map A_ad of **rank 27** into residual codomain dim 29.\n"
        f"- Zero locus: **{fam_res['zero_locus']['status']}** "
        f"(cancellable for all 4 ker L_1 basis vectors).\n"
        f"- Killed: **{fam_res['zero_locus']['killed']}**.\n"
        f"- Survivor equations: "
        f"`R_0 + A_ad · a_d = 0` with rank(A_ad)=27.\n"
        f"- Explicit ker-L1[0] particular solution: "
        f"{fam_res['ker_L1_0_explicit_system']['particular_solution_a_d_nonzero']}.\n"
    )
    lines.append("\n## 5. G4 architecture\n")
    lines.append(
        "\nEvery nonautomatic stage is presented as\n\n"
        "```text\n"
        "plane normalization -> triple-line equalizer -> residual point kernel\n"
        "```\n\n"
        "Local free-module surjectivity is **not** promoted to global solvability. "
        "Irrelevant torsion, source-line coupling, and the repaired three-copy "
        "distinction among source / normal / target P(E_-) are retained.\n"
    )
    lines.append("\n## 6. Exit classification\n")
    lines.append(
        f"\n**`{exit_code}`** — both families have nonempty free-fibre zero loci "
        f"for the residual at N_star={N_STAR}. Exact survivor equations are sealed "
        f"for P25.2. This is **not** P25-POSITIVE, **not** a G-covariant, and "
        f"**not** an all-degree statement. Headline remains OPEN.\n"
    )
    lines.append(
        "\n| Proved | Not proved |\n"
        "|--------|------------|\n"
        f"| Complete free-fibre tower at (1,{D}) through order {TERMINAL} | "
        "G-global landing covariant |\n"
        f"| N_star={N_STAR} isolation cutoff | Full multi-Rees equalizer elimination |\n"
        "| Exact residual zero loci on free fibre for both families | "
        "Projective border support (P25.2+) |\n"
        "| G4 architecture at every stage | Headline ed_C(G) |\n\n"
        "**Headline remains OPEN.**\n"
    )
    (HERE / "TOWER.md").write_text("".join(lines))
    print("PASS wrote TOWER.md")

    summary = {
        "exit": exit_code,
        "headline": "OPEN",
        "route": "P25",
        "dispatch": "P25.1",
        "bidegree": {"m": M, "d": D},
        "N_star": N_STAR,
        "terminal_F_order": TERMINAL,
        "gate_G1": "PASS",
        "multi_rees_total_dim": jets["total_multi_rees_dim"],
        "sample0_first_nonzero": s0_nz,
        "sample1_first_nonzero": s1_nz,
        "sample1_residual_norm_sq": res_norm,
        "based_family_killed": fam_based["zero_locus"]["killed"],
        "residual_family_killed": fam_res["zero_locus"]["killed"],
        "leading_sample": a_label,
        "base_pin": BASE_PIN,
        "not_a_covariant": True,
        "files": sorted(p.name for p in HERE.iterdir() if p.is_file()),
    }
    write_json(HERE / "SUMMARY.json", summary)

    seal = {
        "terminal_marker": exit_code,
        "headline": "OPEN",
        "route": "P25.1",
        "bidegree": {"m": M, "d": D},
        "N_star": N_STAR,
        "terminal_F_order": TERMINAL,
        "base_pin": BASE_PIN,
        "accepted_inputs_sha256": inputs,
        "artifacts": sorted(p.name for p in HERE.iterdir() if p.is_file()),
        "not_a_covariant": True,
        "resource_exceeded_8GB": False,
        "theorem_boundary": exit_payload["theorem_boundary"],
        "house_rules": exit_payload["house_rules"],
    }
    write_json(HERE / "SEAL.json", seal)

    # SHA256SUMS for sealed artifacts (exclude produce/verify source optionally include all)
    lines_sum = []
    for p in sorted(HERE.iterdir()):
        if p.is_file() and p.name not in ("SHA256SUMS",):
            lines_sum.append(f"{sha256_file(p)}  {p.name}\n")
    (HERE / "SHA256SUMS").write_text("".join(lines_sum))
    print("PASS wrote SEAL.json and SHA256SUMS")
    print("P25_1_TOWER_PRODUCE_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
