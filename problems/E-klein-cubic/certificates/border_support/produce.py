#!/usr/bin/env python3
"""WP-6 producer: sparse translation of the WP-5 state onto the rank-28 border module.

Scope: Gate 5 / WP-6 only. Does not launch raw 43-variable solves, unstructured
degree ladders, or dense global degree-four expansions. If a decisive Fitting /
saturation job needs more than 8 GiB RSS, this producer STOPS with a complete
formulation for the director gate.

Headline remains OPEN. Exit P is a necessary formal state only.
"""

from __future__ import annotations

import json
import resource
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import common as C  # noqa: E402

ROOT = C.ROOT
P = C.P
DEGREE = C.DEGREE
OUT_TMP = ROOT / "tmp" / "strata_machine_wp6"
CERT = HERE
OUT_TMP.mkdir(parents=True, exist_ok=True)


def rss_mib() -> float:
    value = resource.getrusage(resource.RUSAGE_SELF).ru_maxrss
    return value / (1024 * 1024) if sys.platform == "darwin" else value / 1024


def linear_forms_to_sparse(reduced_qk: np.ndarray, family: str, forced: bool):
    rows = []
    for j, row in enumerate(np.asarray(reduced_qk, dtype=np.int64) % P):
        terms = []
        for i in range(C.QDIM):
            coef = int(row[i]) % P
            if coef:
                terms.append(
                    {
                        "component": 0,
                        "component_name": "1",
                        "q_monomial": [i],
                        "coeff_mod_67": coef,
                    }
                )
        for b in range(C.KDIM):
            coef = int(row[C.QDIM + b]) % P
            if coef:
                terms.append(
                    {
                        "component": 1 + b,
                        "component_name": f"K_{b}",
                        "q_monomial": [],
                        "coeff_mod_67": coef,
                    }
                )
        rows.append(
            {
                "row_index": j,
                "family": family,
                "forced": forced,
                "degree_in_F": 1,
                "term_count": len(terms),
                "terms": terms,
            }
        )
    return rows


def main() -> None:
    d12 = C.load_module("d12_wp6_prod", ROOT / "tmp" / "d12_block_attack" / "analyze.py")
    audit = d12.audit
    reynolds = audit.load(audit.REYNOLDS, "wp6_prod_reynolds")
    module = reynolds.load_reynolds_module()
    seeds = [
        module.ReynoldsSeed(int(record["output"]), tuple(record["exponents"]))
        for record in json.loads(
            (ROOT / "tmp" / "degree25_structural_probe" / "seeds.json").read_text()
        )
    ]
    kernel = np.load(ROOT / "tmp" / "degree25_structural_probe" / "kernel.npy") % P
    strict = np.load(ROOT / "tmp" / "degree25_structural_probe" / "strict.npy") % P
    strict_reynolds = (strict @ kernel) % P
    assert kernel.shape == (59, 189)
    assert strict.shape == (43, 59)

    (
        _centralizer,
        _positions,
        rotation,
        _reflection,
        _plus,
        minus,
        basis,
        _basis_inv,
    ) = d12.adapted_d12_basis(module)
    minus = np.asarray(minus, dtype=np.int64) % P
    adapted = np.asarray(basis, dtype=np.int64) % P
    adapted_inv = C.invert_mod(adapted)
    identity = np.eye(5, dtype=np.int64)

    # --- based residual of the 43-space on L_t ---
    line_points = np.array(
        [(minus[0] + int(t) * minus[1]) % P for t in range(DEGREE + 1)],
        dtype=np.int64,
    )
    values = audit.batch_seed_evaluations(module, seeds, line_points, DEGREE)
    values = values.reshape(len(line_points), 5, 189)
    restriction = np.einsum("pwo,so->spw", values, strict_reynolds) % P
    coords = np.einsum("ij,spj->spi", adapted_inv, restriction) % P
    assert int(np.max(coords[:, :, :3])) == 0
    based_map = coords[:, :, 3:].reshape(43, -1)
    C_based = based_map.T % P
    based_rank = C.rank_mod(C_based)
    based_kernel = C.nullspace_rows(C_based)
    assert based_rank == 7
    assert based_kernel.shape == (36, 43)

    with np.load(ROOT / "tmp" / "m1_full_plane_block_rank" / "block_matrices.npz") as frozen:
        Qb = frozen["quotient_basis"].astype(np.int64) % P
        Kb = frozen["kernel_basis"].astype(np.int64) % P
    filt_k = (
        np.load(ROOT / "tmp" / "m1_compact_degree25" / "filtration_matrices.npz")[
            "common_order3_kernel"
        ].astype(np.int64)
        % P
    )
    assert np.array_equal(Kb, filt_k)
    assert C.rank_mod(np.vstack([Qb, Kb])) == 43

    C_Q = (C_based @ Qb.T) % P
    C_K = (C_based @ Kb.T) % P
    reduced_full, pivots = C.rref(np.hstack([C_Q, C_K]) % P)
    reduced_based = (reduced_full[: len(pivots)] % P).astype(np.uint8)
    assert len(pivots) == 7

    # Geometric regression: residual vanishes at the six plus-plane meetings on L_t.
    involutions = []
    for index in range(len(module.GROUP)):
        matrix = module.GROUP[index] % P
        if np.array_equal((matrix @ matrix) % P, identity) and not np.array_equal(
            matrix, identity
        ):
            involutions.append(matrix)
    six_points = []
    for involution in involutions:
        mm = ((involution - identity) @ minus.T) % P
        for coefficients in C.nullspace_rows(mm):
            point = (
                int(coefficients[0]) * minus[0] + int(coefficients[1]) * minus[1]
            ) % P
            if not np.any(point):
                continue
            scale = next(int(entry) for entry in point if entry % P)
            normalized = (point * pow(scale, -1, P)) % P
            if not any(np.array_equal(normalized, old) for old in six_points):
                six_points.append(normalized)
    assert len(six_points) == 6
    six_values = audit.batch_seed_evaluations(
        module, seeds, np.asarray(six_points, dtype=np.int64), DEGREE
    ).reshape(6, 5, 189)
    six_residual = np.einsum("pwo,so->spw", six_values, strict_reynolds) % P
    assert int(np.max(six_residual)) == 0

    # --- C3 optional block (not forced base) ---
    order_three = None
    cube_roots = None
    for index in range(len(module.GROUP)):
        matrix = module.GROUP[index] % P
        power = identity.copy()
        order = None
        for n in range(1, 8):
            power = (power @ matrix) % P
            if np.array_equal(power, identity):
                order = n
                break
        if order != 3:
            continue
        roots = [t for t in range(P) if pow(t, 3, P) == 1]
        if len(roots) < 3:
            continue
        dims = [5 - C.rank_mod((matrix - lam * identity) % P) for lam in roots]
        if sorted(dims) == [1, 2, 2]:
            order_three = matrix
            cube_roots = roots
            break
    assert order_three is not None and cube_roots is not None
    nontrivial = [root for root in cube_roots if root != 1]
    U = C.nullspace_rows((order_three - nontrivial[0] * identity) % P)
    assert U.shape == (2, 5)
    c3_points = np.array(
        [(U[0] + int(t) * U[1]) % P for t in range(DEGREE + 1)], dtype=np.int64
    )
    c3_values = audit.batch_seed_evaluations(module, seeds, c3_points, DEGREE).reshape(
        len(c3_points), 5, 189
    )
    c3_map = np.einsum("pwo,so->spw", c3_values, strict_reynolds).reshape(43, -1) % P
    c3_rank = C.rank_mod(c3_map.T)
    c3_QK = np.hstack([(c3_map.T @ Qb.T) % P, (c3_map.T @ Kb.T) % P]) % P
    c3_red, c3_piv = C.rref(c3_QK)
    reduced_c3 = (c3_red[: len(c3_piv)] % P).astype(np.uint8)

    # --- A4 character-line value block ---
    found_v4 = None
    for i, first in enumerate(involutions):
        for second in involutions[i + 1 :]:
            if not np.array_equal((first @ second) % P, (second @ first) % P):
                continue
            product = (first @ second) % P
            if (
                np.array_equal(product, identity)
                or np.array_equal(product, first)
                or np.array_equal(product, second)
            ):
                continue
            if not np.array_equal((product @ product) % P, identity):
                continue
            found_v4 = (first, second, product)
            break
        if found_v4 is not None:
            break
    assert found_v4 is not None
    a_mat, b_mat, ab_mat = found_v4
    Aspace = C.nullspace_rows(
        np.vstack([(a_mat - identity) % P, (b_mat - identity) % P])
    )
    assert Aspace.shape[0] == 2
    r_a4 = None
    for index in range(len(module.GROUP)):
        r_mat = module.GROUP[index] % P
        power = identity.copy()
        order = None
        for n in range(1, 8):
            power = (power @ r_mat) % P
            if np.array_equal(power, identity):
                order = n
                break
        if order != 3:
            continue
        r_inv = (r_mat @ r_mat) % P
        images = [(r_mat @ x @ r_inv) % P for x in (a_mat, b_mat, ab_mat)]
        if all(any(np.array_equal(image, y) for y in (a_mat, b_mat, ab_mat)) for image in images):
            if not (
                np.array_equal(images[0], a_mat) and np.array_equal(images[1], b_mat)
            ):
                r_a4 = r_mat
                break
    assert r_a4 is not None

    def coords_in_aspace(vector: np.ndarray) -> np.ndarray:
        for i in range(5):
            for j in range(i + 1, 5):
                block = np.array(
                    [[Aspace[0, i], Aspace[1, i]], [Aspace[0, j], Aspace[1, j]]],
                    dtype=np.int64,
                ) % P
                det = int(block[0, 0] * block[1, 1] - block[0, 1] * block[1, 0]) % P
                if det == 0:
                    continue
                inv_det = pow(det, -1, P)
                inverse = (
                    np.array(
                        [[block[1, 1], -block[0, 1]], [-block[1, 0], block[0, 0]]],
                        dtype=np.int64,
                    )
                    * inv_det
                    % P
                )
                return (inverse @ np.array([vector[i], vector[j]], dtype=np.int64)) % P
        raise RuntimeError("A-space coordinates unavailable")

    r2 = np.zeros((2, 2), dtype=np.int64)
    for j in range(2):
        r2[:, j] = coords_in_aspace((r_a4 @ Aspace[j]) % P)
    trace = int(r2[0, 0] + r2[1, 1]) % P
    det = int(r2[0, 0] * r2[1, 1] - r2[0, 1] * r2[1, 0]) % P
    disc = (trace * trace - 4 * det) % P
    sqrt_disc = next(s for s in range(P) if (s * s) % P == disc)
    inv2 = pow(2, -1, P)
    eigenvalues = [((trace + sqrt_disc) * inv2) % P, ((trace - sqrt_disc) * inv2) % P]
    a4_lines = []
    for eigenvalue in eigenvalues:
        m = (r2 - eigenvalue * np.eye(2, dtype=np.int64)) % P
        row = m[0] if np.any(m[0] % P) else m[1]
        if row[0] % P == 0:
            coef = np.array([0, 1], dtype=np.int64)
        else:
            coef = np.array(
                [(-int(row[1])) * pow(int(row[0]), -1, P) % P, 1], dtype=np.int64
            )
        vector = (coef[0] * Aspace[0] + coef[1] * Aspace[1]) % P
        klein = sum(int(vector[i]) ** 2 * int(vector[(i + 1) % 5]) for i in range(5)) % P
        assert klein != 0
        a4_lines.append(vector)
    a4_values = audit.batch_seed_evaluations(
        module, seeds, np.asarray(a4_lines, dtype=np.int64), DEGREE
    ).reshape(2, 5, 189)
    a4_map = np.einsum("pwo,so->spw", a4_values, strict_reynolds).reshape(43, -1) % P
    a4_rank = C.rank_mod(a4_map.T)
    a4_QK = np.hstack([(a4_map.T @ Qb.T) % P, (a4_map.T @ Kb.T) % P]) % P
    a4_red, a4_piv = C.rref(a4_QK)
    reduced_a4 = (a4_red[: len(a4_piv)] % P).astype(np.uint8)

    # --- C6 endpoints on L_t ---
    rot = np.asarray(rotation, dtype=np.int64) % P
    rmin = np.zeros((2, 2), dtype=np.int64)
    for j in range(2):
        image = (rot @ minus[j]) % P
        local = (adapted_inv @ image) % P
        rmin[:, j] = local[3:]
    trace = int(rmin[0, 0] + rmin[1, 1]) % P
    det = int(rmin[0, 0] * rmin[1, 1] - rmin[0, 1] * rmin[1, 0]) % P
    disc = (trace * trace - 4 * det) % P
    sqrt_disc = next(s for s in range(P) if (s * s) % P == disc)
    eigenvalues = [((trace + sqrt_disc) * inv2) % P, ((trace - sqrt_disc) * inv2) % P]
    c6_points = []
    for eigenvalue in eigenvalues:
        m = (rmin - eigenvalue * np.eye(2, dtype=np.int64)) % P
        row = m[0] if np.any(m[0] % P) else m[1]
        if row[0] % P == 0:
            coef = np.array([0, 1], dtype=np.int64)
        else:
            coef = np.array(
                [(-int(row[1])) * pow(int(row[0]), -1, P) % P, 1], dtype=np.int64
            )
        c6_points.append((coef[0] * minus[0] + coef[1] * minus[1]) % P)
    c6_values = audit.batch_seed_evaluations(
        module, seeds, np.asarray(c6_points, dtype=np.int64), DEGREE
    ).reshape(2, 5, 189)
    c6_map = np.einsum("pwo,so->spw", c6_values, strict_reynolds).reshape(43, -1) % P
    c6_rank = C.rank_mod(c6_map.T)
    c6_QK = np.hstack([(c6_map.T @ Qb.T) % P, (c6_map.T @ Kb.T) % P]) % P
    c6_red, c6_piv = C.rref(c6_QK)
    reduced_c6 = (c6_red[: len(c6_piv)] % P).astype(np.uint8)

    # --- persist matrices ---
    np.savez_compressed(
        OUT_TMP / "wp6_translation_matrices.npz",
        based_reduced_qk=reduced_based,
        based_C=C_based.astype(np.uint8),
        based_kernel=based_kernel.astype(np.uint8),
        C_Q=C_Q.astype(np.uint8),
        C_K=C_K.astype(np.uint8),
        c3_reduced_optional=reduced_c3,
        c3_map=c3_map.astype(np.uint8),
        a4_reduced=reduced_a4,
        a4_map=a4_map.astype(np.uint8),
        c6_reduced=reduced_c6,
        c6_map=c6_map.astype(np.uint8),
        Qb=Qb.astype(np.uint8),
        Kb=Kb.astype(np.uint8),
        minus_line_six_points=np.asarray(six_points, dtype=np.uint8),
    )
    np.savez_compressed(
        CERT / "sparse_blocks.npz",
        based_reduced_qk=reduced_based,
        c3_optional_reduced_qk=reduced_c3,
        a4_reduced_qk=reduced_a4,
        c6_reduced_qk=reduced_c6,
    )

    sparse_based = linear_forms_to_sparse(reduced_based, "based_minus_lines_odd_m", True)
    sparse_c3 = linear_forms_to_sparse(
        reduced_c3, "C3_optional_based_NOT_forced", False
    )
    sparse_a4 = linear_forms_to_sparse(reduced_a4, "A4_character_value_map", False)
    sparse_c6 = linear_forms_to_sparse(reduced_c6, "C6_endpoint_value_map", False)

    cubic_coeff_sha = C.coefficients_sha256_from_npz(
        ROOT / "tmp" / "m1_full_plane_block_rank" / "full_cubic_basis.npz"
    )
    expected_cubic = "2fd6a5ad83f17de8826eb1787e062e79c66f6aac681197c24702c65df6135f76"
    assert cubic_coeff_sha == expected_cubic

    formulation = {
        "module": {
            "name": "restricted_relative_border_module",
            "free_module": "F = S^{28}",
            "S": "k[q0,...,q36]",
            "order_ideal": ["1", "K_i (i=0..5)", "K_i K_j (0<=i<=j<=5)"],
            "component_shifts": [0] + [1] * 6 + [2] * 21,
            "classical_submodule_N": {
                "seed_relations": 786,
                "neighbor_commutators_raw": 315,
                "neighbor_commutators_basis": 210,
                "T_i_stable_closure": True,
                "source": "tmp/m1_relative_border_rank28 + tmp/m1_border_module_m2",
            },
            "new_generators_N_based": {
                "count": 7,
                "degree": 1,
                "family": "based_minus_lines_odd_m",
                "description": (
                    "Seven independent linear forms L_j(q,k)=0 cutting the based-minus-line "
                    "family inside V=Q⊕K. Encoded as degree-1 elements of F: "
                    "L_j = sum_i a_ji q_i · e_1 + sum_b b_jb · e_{K_b}."
                ),
            },
            "optional_blocks_not_in_forced_N": {
                "C3": {
                    "forced_base": False,
                    "optional_based_rank_on_43": c3_rank,
                    "optional_reduced_rows": int(reduced_c3.shape[0]),
                },
                "A4": {
                    "reduced_rows": int(reduced_a4.shape[0]),
                    "rank_on_43": a4_rank,
                },
                "C6": {
                    "reduced_rows": int(reduced_c6.shape[0]),
                    "rank_on_43": c6_rank,
                },
            },
            "restricted_module": "F / N' with N' = N + N_based (based family only)",
        },
        "level1_family_translation": {
            "based_minus_lines_odd_m": {
                "live_at_m1_d25": True,
                "linear_conditions_rank": 7,
                "kernel_dim_in_43": 36,
                "forced_sparse_rows": 7,
            },
            "residual_e1_swap_both": {
                "live_at_m1_d25": False,
                "reason": "Requires residual e=1 i.e. d=6m+1=7 for m=1; not degree 25.",
            },
            "residual_e_ge7_generic_swap_both": {
                "live_at_m1_d25": True,
                "residual_module_dim": 7,
                "residual_e": 19,
                "linear_cut": None,
                "note": (
                    "The arrangement kernel already surjects onto the full residual module "
                    "of rank 7 at m=1,d=25. Generic swap_both is Zariski-open in P^6; no "
                    "additional linear block. Nonlinear landing remains the classical border system."
                ),
            },
        },
        "graded_dimensions": {
            str(d): {
                "dim_F_d": C.dim_border_piece(d),
                "extra_based_multiples_in_degree_d": 7 * C.binom(d - 1 + 36, 36),
                "dense_uint8_GiB_square_lower_bound": (C.dim_border_piece(d) ** 2)
                / (1024**3),
            }
            for d in range(3, 9)
        },
        "memory_gate": {
            "exploratory_ceiling_RSS_GiB": 8,
            "classical_global_degree4": {
                "columns": 160987,
                "first_closure_rows_upper": 34113,
                "cannot_be_full_by_row_count": True,
            },
            "earliest_degree_not_excluded_by_raw_row_count": 7,
            "degree7_dense_square_GiB": (C.dim_border_piece(7) ** 2) / (1024**3),
            "observed_producer_RSS_MiB": rss_mib(),
            "decision": (
                "Global Macaulay/Fitting emptiness of the restricted module exceeds the "
                "8 GiB exploratory ceiling (same obstruction as the unrestricted rank-28 "
                "packet: degree 4 cannot close by row count; degree ≥7 is the first "
                "counting-possible degree and is far beyond 8 GiB dense). STOP with "
                "formulation rather than launching a large job."
            ),
        },
        "certificate_formats_authorized_after_director_gate": [
            {
                "name": "exact_char0_annihilator_or_Fitting",
                "description": (
                    "Generators of Ann(F/N') or a Fitting ideal with radical equal to "
                    "the irrelevant ideal (q0..q36), over Q or a DVR with written rank preservation."
                ),
            },
            {
                "name": "projective_DVR_properness_with_good_fiber",
                "description": (
                    "Integral model of the restricted border module at "
                    "p=(67, zeta_11-64) with complete good-fiber emptiness and certified "
                    "rank preservation to characteristic zero (house rule 9)."
                ),
            },
            {
                "name": "structured_saturation_certificate",
                "description": (
                    "Sparse T_i-stable saturation of N' using the 7 based generators + "
                    "786 seeds + 210 commutator basis, with hashed row streams and independent verifier."
                ),
            },
        ],
        "checkpoint_plan": [
            "1. Hash-lock sparse based rows and classical K3/seed/comm streams",
            "2. Build degree-3 restricted presentation (seeds + based) and record rank over F_67",
            "3. Degree-4 first closure with based multiples on coordinate slices P^k, k≤16",
            "4. Only after director approval: sparse saturation / Fitting at degree ≥7 with >8 GiB budget",
            "5. Promote emptiness by DVR properness using the existing char0_lift pattern",
        ],
        "forbidden_by_stopping_rule": [
            "raw_43_variable_projective_solve",
            "unstructured_degree_ladder",
            "standard_chart_sweep_without_structural_reduction",
            "dense_expansion_of_global_degree_four_block",
            "isolated_finite_field_point_tests_as_geometric_support",
        ],
    }

    provenance = {
        "full_cubic_coefficients_sha256": cubic_coeff_sha,
        "block_matrices_sha256": C.sha256_file(
            ROOT / "tmp" / "m1_full_plane_block_rank" / "block_matrices.npz"
        ),
        "kernel_sha256": C.sha256_file(
            ROOT / "tmp" / "degree25_structural_probe" / "kernel.npy"
        ),
        "strict_sha256": C.sha256_file(
            ROOT / "tmp" / "degree25_structural_probe" / "strict.npy"
        ),
        "level1_sha256": C.sha256_file(
            ROOT / "certificates" / "global_transition" / "level1_marked_states.json"
        ),
        "level2_sha256": C.sha256_file(
            ROOT / "certificates" / "global_transition" / "level2_inverse_limit.json"
        ),
        "exit_sha256": C.sha256_file(
            ROOT / "certificates" / "global_transition" / "exit.json"
        ),
        "border_rank28_results_sha256": C.sha256_file(
            ROOT / "tmp" / "m1_relative_border_rank28" / "results.json"
        ),
    }

    translation = {
        "work_package": "WP-6",
        "headline": "OPEN",
        "exit_P_status": (
            "necessary formal state only; not a parametrization; not a landing covariant"
        ),
        "prime_discovery_fiber": P,
        "degree": DEGREE,
        "plane_order_m": 1,
        "strict_space_dim": 43,
        "Q_dim": C.QDIM,
        "K_dim": C.KDIM,
        "based_minus_line": {
            "residual_image_rank": based_rank,
            "matches_expected_residual_dim_7": True,
            "residual_e": 19,
            "based_condition_rank": 7,
            "based_kernel_dim": 36,
            "reduced_qk_shape": list(reduced_based.shape),
            "reduced_qk_sha256": C.sha256_arr(reduced_based),
            "geometric_regression": {
                "plus_plane_intersections_on_L_t": 6,
                "residual_vanishes_there_on_all_43": True,
            },
            "plus_component_of_odd_restriction": 0,
        },
        "families": formulation["level1_family_translation"],
        "provenance": provenance,
        "sparse_based_term_counts": [row["term_count"] for row in sparse_based],
        "producer": "certificates/border_support/produce.py",
        "verifier": "certificates/border_support/verify.py",
    }
    C.write_json_with_self_hash(CERT / "translation.json", translation)

    blocks = {
        "work_package": "WP-6",
        "headline": "OPEN",
        "note": (
            "C3/A4/C6 added as sparse block row data; raw 43-variable cubic system NOT rebuilt."
        ),
        "forced_blocks": {
            "based_minus_lines": {
                "rows": sparse_based,
                "matrix_sha256": C.sha256_arr(reduced_based),
                "rank": 7,
            }
        },
        "optional_discovery_blocks": {
            "C3_not_forced_base": {
                "forced_base": False,
                "reduced_rank": int(reduced_c3.shape[0]),
                "matrix_sha256": C.sha256_arr(reduced_c3),
                "sample_term_counts": [row["term_count"] for row in sparse_c3[:3]],
                "full_rows_stored_in": "sparse_blocks.npz:c3_optional_reduced_qk",
            },
            "A4_character_values": {
                "reduced_rank": int(reduced_a4.shape[0]),
                "matrix_sha256": C.sha256_arr(reduced_a4),
                "off_X_verified": True,
                "full_rows_stored_in": "sparse_blocks.npz:a4_reduced_qk",
            },
            "C6_endpoints_on_L_t": {
                "reduced_rank": int(reduced_c6.shape[0]),
                "matrix_sha256": C.sha256_arr(reduced_c6),
                "full_rows_stored_in": "sparse_blocks.npz:c6_reduced_qk",
            },
        },
        "border_components": {
            "count": C.BORDER_RANK,
            "names": (
                ["1"]
                + [f"K_{i}" for i in range(6)]
                + [f"K_{i}*K_{j}" for i in range(6) for j in range(i, 6)]
            ),
        },
        "producer": "certificates/border_support/produce.py",
        "verifier": "certificates/border_support/verify.py",
    }
    C.write_json_with_self_hash(CERT / "c3_a4_c6_blocks.json", blocks)

    restricted = {
        "work_package": "WP-6",
        "headline": "OPEN",
        "module_name": "F/N' (rank-28 relative border, restricted by WP-5 based family)",
        "classical_isomorphism": (
            "F/N ≅ R/I for the normalized 842-cubic landing ideal (prior packet)"
        ),
        "restriction": "N' = N + <7 based linear generators in F_1>",
        "commutator_closure": {
            "status": "classical 315 raw / 210 basis retained unchanged",
            "based_generators_degree": 1,
            "neighbor_syzygies_among_based_rows": (
                "vacuous in F_1 relative to monic K^3 rewrite; T_i-multiples enter degree 2"
            ),
            "computed_in_this_dispatch": (
                "classical commutator basis shape retained; no new global T_i-stable "
                "closure launched under the 8 GiB gate"
            ),
        },
        "saturation_fitting_support": {
            "status": "NOT_DECIDED under 8GiB exploratory gate",
            "reason": formulation["memory_gate"]["decision"],
        },
        "formulation": formulation,
        "producer": "certificates/border_support/produce.py",
        "verifier": "certificates/border_support/verify.py",
    }
    C.write_json_with_self_hash(CERT / "restricted_module.json", restricted)

    support = {
        "work_package": "WP-6",
        "headline": "OPEN",
        "support_decision": "NOT_DECIDED",
        "exit_N3": "not reached",
        "exit_P_carry_forward": True,
        "meaning": (
            "WP-5 Exit P remains a necessary formal state only. WP-6 produced the sparse "
            "translation and restricted-module formulation but did not certify emptiness or "
            "nonemptiness of the nonlinear landing support in characteristic zero."
        ),
        "surviving_point_claimed": False,
        "covariant_reconstructed": False,
        "landing_equivariance_primitivity_dominance_checked": False,
        "finite_field_points_as_solutions": False,
        "stop_reason": "memory_gate_8GiB_formulation_returned",
        "authoritative_next": "director gate on formulation in restricted_module.json",
        "producer": "certificates/border_support/produce.py",
        "verifier": "certificates/border_support/verify.py",
    }
    C.write_json_with_self_hash(CERT / "support_status.json", support)

    seal_files = [
        "translation.json",
        "c3_a4_c6_blocks.json",
        "restricted_module.json",
        "support_status.json",
        "sparse_blocks.npz",
    ]
    seal = {
        "work_package": "WP-6",
        "headline": "OPEN",
        "gate": 5,
        "artifacts": {name: C.sha256_file(CERT / name) for name in seal_files},
        "terminal_marker": "BORDER_SUPPORT_WP6_SEALED",
        "producer": "certificates/border_support/produce.py",
        "verifier": "certificates/border_support/verify.py",
    }
    C.write_json_with_self_hash(CERT / "SEAL.json", seal)

    (OUT_TMP / "produce_meta.json").write_text(
        json.dumps(
            {
                "rss_mib_peak": rss_mib(),
                "based_rank": based_rank,
                "c3_rank": c3_rank,
                "a4_rank": a4_rank,
                "c6_rank": c6_rank,
            },
            indent=2,
            sort_keys=True,
        )
        + "\n"
    )
    print("BORDER_SUPPORT_WP6_BUILT")
    print(f"RSS_MiB={rss_mib():.2f}")


if __name__ == "__main__":
    main()
