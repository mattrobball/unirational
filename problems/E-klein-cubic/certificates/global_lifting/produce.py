#!/usr/bin/env python3
"""Attempt 5 Gate 1 (5B): formulate scheme-theoretic image of global states.

Produces global_state_image.json with exact defining data and size estimates
only.  Does NOT decide the containment G subset R_3.  Does NOT import
verify.py.  Does NOT run Fork A/B.  Headline remains OPEN.

Absolute paths only for optional tooling; this producer is pure Python exact
arithmetic / dimension counts.
"""

from __future__ import annotations

import hashlib
import json
import math
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
GT = CERT / "global_transition"
sys.path.insert(0, str(GT))

from common_global import (  # noqa: E402
    canonical_json,
    dim_d12_ordinary,
    dim_plane,
    dim_v4_line,
    load_json,
    n_triv,
    residual_e,
    sha256_bytes,
    sha256_file,
)

# ---------------------------------------------------------------------------
# Accepted inputs (hashes pinned at produce time)
# ---------------------------------------------------------------------------

ACCEPTED = [
    "certificates/transition_repair/category_repaired.json",
    "certificates/lifting/polar_expansion.json",
    "certificates/lifting/families/SUMMARY.json",
    "certificates/lifting/families/free_module_stages.json",
    "certificates/global_transition/level2_inverse_limit.json",
    "certificates/global_transition/level1_marked_states.json",
    "certificates/global_transition/necessity_theorem.json",
    "certificates/global_transition/diagram.json",
    "certificates/transitions/involution_plane/module.json",
]

SURVIVOR_FAMILIES = [
    "based_minus_lines_odd_m",
    "residual_e1_swap_both",
    "residual_e_ge7_generic_swap_both",
]

THREE_COPIES = {
    "L_t_src": {
        "id": "L_t_src",
        "symbol": "L_t^{src}",
        "ambient": "P(W)",
        "role": "source_fixed_line",
        "path_tag": "SOURCE",
        "meets_Z_t": False,
        "disjointness": "L_t^{src} ∩ Z_t = empty",
    },
    "P_E_minus_normal": {
        "id": "P_E_minus_normal",
        "symbol": "P(E_-)^{N}",
        "ambient": "P(N_{Z_t/Y}) ≅ Z_t × P(E_-)",
        "role": "exceptional_normal_direction",
        "path_tag": "NORMAL",
    },
    "L_t_tgt": {
        "id": "L_t_tgt",
        "symbol": "L_t^{tgt}",
        "ambient": "X^t subset X",
        "role": "target_fixed_line",
        "path_tag": "TARGET",
    },
}

BYTES_PER_ENTRY = 32
BYTES_PER_SPARSE = 40


def binom(n: int, k: int) -> int:
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)


def free_leading_rank(m: int) -> int:
    """Free R-rank of E_--valued order-m leading jets (odd m)."""
    return 2 * (m + 1)


def free_L1_shape(m: int) -> tuple[int, int]:
    """(codomain, domain) free ranks of L_1 over R = Sym(E_+^*)."""
    return (3 * m + 2, 3 * (m + 2))


def free_L3_shape(m: int) -> tuple[int, int]:
    """(codomain, domain) free ranks of L_3 over R."""
    return (3 * m + 4, 3 * (m + 4))


def dim_leading_C2(m: int, d: int) -> int:
    """Full C2 plane leading-jet dimension before residual projection."""
    if m % 2 == 0 or d < m:
        return 0
    # free rank 2(m+1) over Sym^{d-m} E_+^*
    return free_leading_rank(m) * binom(d - m + 2, 2)


def dim_L1_domain_C2(m: int, d: int) -> int:
    """Full C2 domain of L_1 (order m+1, E_+-valued) at global degree d."""
    if d < m + 1:
        return 0
    return 3 * (m + 2) * binom(d - (m + 1) + 2, 2)


def dim_L1_codomain_C2(m: int, d: int) -> int:
    """Full C2 codomain of L_1 (order 3m+1 landing, scalar normal upper)."""
    r = 3 * m + 1
    if d < r:
        return 0
    return (3 * m + 2) * binom(d - r + 2, 2)


def dim_L3_domain_C2(m: int, d: int) -> int:
    if d < m + 3:
        return 0
    return 3 * (m + 4) * binom(d - (m + 3) + 2, 2)


def dim_L3_codomain_C2(m: int, d: int) -> int:
    r = 3 * m + 3
    if d < r:
        return 0
    return (3 * m + 4) * binom(d - r + 2, 2)


def memory_floors(rows: int, cols: int, nnz: int) -> dict:
    dense = rows * cols * BYTES_PER_ENTRY
    sparse = nnz * BYTES_PER_SPARSE
    return {
        "bytes_per_entry_assumption": BYTES_PER_ENTRY,
        "bytes_per_sparse_assumption": BYTES_PER_SPARSE,
        "dense_bytes_floor": dense,
        "dense_GB_floor": round(dense / 1e9, 6),
        "sparse_bytes_floor": sparse,
        "sparse_GB_floor": round(sparse / 1e9, 6),
        "exceeds_8GB_dense": dense > 8 * (1 << 30),
        "exceeds_8GB_sparse": sparse > 8 * (1 << 30),
    }


def equalizer_target_upper(m: int, d: int) -> dict:
    """Upper bound on total equalizer target dimension (O(d) budget)."""
    j_line = 2 * dim_d12_ordinary(d)  # free rank-2 binary D12 residual
    j_v4 = dim_v4_line(m, d)
    j_pts = 200  # crude Molien O(1) envelope across D10/D12/A4 stalks
    j_c3 = 2 * dim_d12_ordinary(d)  # optional C3-line residual budget
    # coefficient-coupling target on L_t^src: residual dim at most dim_d12
    j_coupling = dim_d12_ordinary(d) if residual_e(m, d) is not None else 0
    total = j_line + j_v4 + j_pts + j_c3 + j_coupling
    return {
        "J_line_upper": j_line,
        "J_V4": j_v4,
        "J_points_envelope": j_pts,
        "J_C3_upper": j_c3,
        "J_coefficient_coupling_upper": j_coupling,
        "target_total_upper": total,
        "note": (
            "Upper envelope for equalizer codomain size; residual projection "
            "and character blocks cut further. Used only for memory floors."
        ),
    }


def sample_bidegrees() -> list[tuple[int, int, str]]:
    return [
        (1, 7, "based / e1 residual start"),
        (1, 13, "based / e>=7 residual start"),
        (1, 25, "based large-d regression"),
        (3, 19, "based / e1 at m=3"),
        (3, 25, "e>=7 residual at m=3"),
        (5, 35, "stress upper bound (not authorized to solve)"),
    ]


def build_size_estimates() -> dict:
    free_module = {}
    for m in (1, 3, 5, 7):
        cod1, dom1 = free_L1_shape(m)
        cod3, dom3 = free_L3_shape(m)
        nA = free_leading_rank(m)
        # nnz quadratic terms: scale from sealed m=1 (48, 80) and m=3 (320, 448)
        if m == 1:
            nnz1, nnz3 = 48, 80
        elif m == 3:
            nnz1, nnz3 = 320, 448
        else:
            # quadratic in nA, linear in matrix area relative to m=1
            scale_A = (nA / 4) ** 2
            nnz1 = int(round(48 * (cod1 * dom1) / (5 * 9) * scale_A))
            nnz3 = int(round(80 * (cod3 * dom3) / (7 * 15) * scale_A))
        n_minors_L1 = binom(dom1, cod1)  # max minors for full rank
        n_minors_L3 = binom(dom3, cod3)
        free_module[str(m)] = {
            "n_leading_free_coeffs": nA,
            "L1": {
                "shape_codomain_x_domain": [cod1, dom1],
                "generic_rank_pattern": cod1,
                "generic_nullity_pattern": dom1 - cod1,  # = 4
                "generic_coker_pattern": 0,
                "nnz_quadratic_terms": nnz1,
                "num_maximal_minors": n_minors_L1,
                "minor_total_degree_in_A": 2 * cod1,
                "memory": memory_floors(cod1, dom1, nnz1),
            },
            "L3": {
                "shape_codomain_x_domain": [cod3, dom3],
                "generic_rank_pattern": cod3,
                "generic_nullity_pattern": dom3 - cod3,  # = 8
                "generic_coker_pattern": 0,
                "nnz_quadratic_terms": nnz3,
                "num_maximal_minors": n_minors_L3,
                "minor_total_degree_in_A": 2 * cod3,
                "memory": memory_floors(cod3, dom3, nnz3),
            },
            "formula_L1_nullity": "3(m+2)-(3m+2)=4",
            "formula_L3_nullity": "3(m+4)-(3m+4)=8",
            "status_generic_ranks": (
                "PROVED_FOR_m_in_1_3_PATTERN"
                if m in (1, 3)
                else "PATTERN_EXTRAPOLATION_ONLY"
            ),
        }

    equalizer_rows = []
    for m, d, label in sample_bidegrees():
        j_plane = dim_plane(m, d)
        lead = dim_leading_C2(m, d)
        tgt = equalizer_target_upper(m, d)
        rows = tgt["target_total_upper"]
        cols = j_plane
        # structured specialization: ~O(1)–O(100) nonzeros per row upper
        nnz = min(rows * cols, rows * 100)
        L1_rows, L1_cols = dim_L1_codomain_C2(m, d), dim_L1_domain_C2(m, d)
        L3_rows, L3_cols = dim_L3_codomain_C2(m, d), dim_L3_domain_C2(m, d)
        # nnz upper for full-C2 L_r: each of L1_rows rows couples ~3*lead terms
        nnz_L1 = min(L1_rows * L1_cols, L1_rows * max(3 * lead, 1))
        nnz_L3 = min(L3_rows * L3_cols, L3_rows * max(3 * lead, 1))
        equalizer_rows.append(
            {
                "m": m,
                "d": d,
                "label": label,
                "e": residual_e(m, d),
                "dim_B_leading_C2": lead,
                "dim_J_plane_C2": j_plane,
                "equalizer_targets": tgt,
                "equalizer_matrix_shape_upper": [rows, cols],
                "equalizer_nnz_upper": nnz,
                "equalizer_memory": memory_floors(rows, cols, nnz),
                "L1_full_C2_shape_upper": [L1_rows, L1_cols],
                "L1_full_C2_nnz_upper": nnz_L1,
                "L1_full_C2_memory": memory_floors(L1_rows, L1_cols, nnz_L1),
                "L3_full_C2_shape_upper": [L3_rows, L3_cols],
                "L3_full_C2_nnz_upper": nnz_L3,
                "L3_full_C2_memory": memory_floors(L3_rows, L3_cols, nnz_L3),
                "free_module_preferred": {
                    "reason": (
                        "Relative free R-module matrices decide generic rank "
                        "and Fitting shape independent of d; instantiate d "
                        "only after residual projection."
                    ),
                    "L1_free_shape": list(free_L1_shape(m)),
                    "L3_free_shape": list(free_L3_shape(m)),
                },
            }
        )

    return {
        "section_7_2_compliance": (
            "Before any job expected to exceed 8 GB RSS: matrix/module "
            "dimensions, term counts, sparse/dense floors, certificate "
            "format, checkpoint plan, independent verifier design."
        ),
        "resource_gate_GB": 8,
        "formulation_RSS_estimate_GB": 0.05,
        "free_module_Fitting_and_ranks": free_module,
        "instantiated_bidegree_envelopes": equalizer_rows,
        "decision_path_recommended": [
            {
                "step": 1,
                "name": "free_module_Fitting_L3",
                "scope": "odd m in {1,3} first; free R-module only",
                "matrix_dims": "L3: (3m+4) x 3(m+4); entries quadratic in 2(m+1) A-coeffs",
                "expected_RSS": "<< 1 GB",
                "output": "generators or GB of Fitt_0(coker L_3) in Q[A_*]",
            },
            {
                "step": 2,
                "name": "global_equalizer_sparse_Lambda",
                "scope": "director start bidegrees (1,7),(1,13),(3,19)",
                "matrix_dims": "equalizer target_upper x J_plane_C2 (see table)",
                "expected_RSS": "< 1 GB sparse for listed starts",
                "output": "basis of Lambda_{m,d} over Q; plane projection = G",
            },
            {
                "step": 3,
                "name": "restrict_L3_to_G",
                "scope": "same bidegrees",
                "action": (
                    "Pull L_3 back to coordinate ring of G_{m,d}; compute "
                    "generic rank over frac(O(G)) or sample certified Q-points "
                    "of G with global-compatibility certificate"
                ),
                "expected_RSS": "dominated by step 2 + free Fitting",
                "verdict_rule": (
                    "If rank(L_3)|_G attains free generic rank on a Zariski-open "
                    "of G (char 0), then G meets B\\R_3. If Fitt vanishes "
                    "identically on G, then G ⊆ R_3."
                ),
            },
            {
                "step": 4,
                "name": "no_sample_alone",
                "action": (
                    "A bare modular or uncertified sample of a_m is "
                    "insufficient for either containment claim."
                ),
            },
        ],
        "certificate_format_proposed": {
            "name": "global_state_image_decision_packet",
            "files": [
                "Lambda_basis_CSR.json (exact Q sparse basis of equalizer kernel)",
                "G_projection_matrix.json (plane-component map π)",
                "Fitt_coker_L3.generators (M2/Singular ideal over Q[A] or O(G))",
                "rank_certificate.json (generic rank of L_3 over G with proof type)",
                "SHA256SUMS",
            ],
            "hash_policy": "content hashes only; self_sha256 after last byte; no timing fields",
            "exactness": "all ranks and ideals over Q (or DVR rank-preservation with hypotheses checked)",
        },
        "checkpoint_plan": [
            "CKPT-0: free-module L1/L3 sparse COO + generic ranks (already sealed in families/)",
            "CKPT-1: Fitt generators of coker L_3 over free leading ring for m=1",
            "CKPT-2: same for m=3; compare pattern",
            "CKPT-3: sparse equalizer matrix rows streamed per orbit-type arrow",
            "CKPT-4: Lambda basis for (m,d)=(1,7); project to G; store CSR",
            "CKPT-5: rank of L_3 over G at (1,7) with char-0 certificate",
            "CKPT-6: replicate at (1,13) and (3,19); stop if pattern stable or structural theorem appears",
            "On any CKPT exceeding 8 GB RSS: halt, emit dimensions, request director 96 GB only if sparse residual path is proved insufficient",
        ],
        "independent_verifier_design": {
            "script": "certificates/global_lifting/verify_decision.py (future Fork A/B)",
            "this_gate_verifier": "certificates/global_lifting/verify.py",
            "rules": [
                "Does not import produce.py",
                "Recomputes defining data hashes of accepted inputs",
                "Checks three P(E_-) copies remain distinguished in formulation",
                "Checks R_1, R_3 written as Fitting loci of accepted L_r",
                "Checks decision statement exact; containment_status is UNDECIDED",
                "Rejects any formal state labelled as covariant",
                "Rejects timing fields; checks self_sha256",
                "Future decision verifier: rebuild equalizer rows from incidence + local modules; recompute ker; recompute Fitt or rank over G independently",
            ],
            "tools": {
                "M2": "/opt/homebrew/bin/M2",
                "Singular": "/opt/homebrew/bin/Singular",
                "GAP": "/opt/homebrew/Caskroom/miniforge/base/bin/gap",
                "python3": "/opt/homebrew/bin/python3",
                "note": "gap shell alias is git apply; gp alias is git push — use absolute paths",
            },
        },
    }


def build_formulation() -> dict:
    return {
        "name": "scheme_theoretic_image_of_global_states",
        "corrected_category": {
            "source": "certificates/transition_repair/category_repaired.json",
            "three_copies_of_P_E_minus": THREE_COPIES,
            "forbidden_identifications": [
                "L_t^{src} subset Z_t",
                "L_t^{src} = P(E_-)^{N}",
                "L_t^{src} = L_t^{tgt}",
                "plane_to_minus_line as ordinary restriction of first normal jet on Z_t",
            ],
            "arrow_types": [
                "SOURCE-RESTRICTION",
                "NORMAL-CONE-SPECIALIZATION",
                "TARGET-EVALUATION",
                "COEFFICIENT-COUPLING",
            ],
            "replacement_span": (
                "Z_t^{src} ← P(N_{Z_t/Y}) → L_t^{tgt}  +  "
                "L_t^{src} ⇢ X^t  +  coefficient coupling p|_{E_-}=p_d(0,y)"
            ),
        },
        "Lambda": {
            "symbol": "Lambda^{rep}_{m,d}",
            "definition": (
                "Corrected residual-equivariant equalizer of the incidence "
                "diagram of local bigraded modules M_S on objects of the "
                "repaired category C^{rep}, in fixed odd normal order m and "
                "global degree d."
            ),
            "legacy_source": "certificates/global_transition/level2_inverse_limit.json",
            "repair": (
                "Use C^{rep} (WP-R0), not the legacy plane→minus-line arrow. "
                "Forgetful map Lambda^{rep} → Lambda_legacy is surjective on "
                "linear data; size AT_LEAST_AS_LARGE."
            ),
            "architecture_55_plane": (
                "plane normalization → triple-line equalizer → residual point "
                "kernel, retaining finite irrelevant torsion T_m"
            ),
            "additional_equalizer_factors": [
                "C3 lines (not forced base)",
                "A4 points (Molien)",
                "minus-line D12 modules on L_t^{src}",
                "marked elliptic charge-compatible restrictions",
                "coefficient coupling p|_{E_-}=p_d(0,y) (based: 0; residual: Delta_t^m h_t)",
                "target evaluation of odd-m jet to L_t^{tgt}",
                "normal-cone projection P(N) → Z_t",
            ],
            "nonemptiness": (
                "For every odd m≥1 and all sufficiently large d, "
                "dim Lambda_{m,d} ≥ c_m d^2 − C_m d − C'_m > 0 (WP-5 Exit P; char 0)."
            ),
            "house_rule_8": "Elements of Lambda are formal states, never covariants.",
        },
        "B_leading_jet_space": {
            "symbol": "B_{m,d}",
            "definition": (
                "Leading-jet parameter space for a_m: residual-allowed "
                "E_--valued normal jets of order m and global degree d along "
                "plus-planes, i.e. the plane-component ambient of the free "
                "R-module of rank 2(m+1) (R=Sym(E_+^*)), multi-Rees restored "
                "as Sym^{d-m} E_+^* ⊗ (free leading fibre), before or after "
                "residual D12 projection as labelled in size tables."
            ),
            "free_R_rank": "2(m+1) for odd m",
            "lives_on": "P(N_{Z_t/Y}) / Z_t  (normal side), not on L_t^{src}",
            "B0_free_module": (
                "Coordinate ring Q[A_0..A_{2m+1}] of free leading fibre "
                "(sealed free_module_stages.json); multi-Rees lifts to all d."
            ),
            "relation_to_families": (
                "B_0 in the obstruction tower is this leading space; families "
                "restrict by coefficient coupling on L_t^{src}, not by "
                "replacing L_r."
            ),
        },
        "projection_and_image": {
            "pi": {
                "symbol": "π_{m,d}",
                "type": "linear projection of Q-vector spaces (affine cones)",
                "source": "Lambda^{rep}_{m,d}",
                "target": "B_{m,d}",
                "rule": (
                    "Retain only the C2_plane / normal-cone leading jet "
                    "component a_m; forget residual line, V4, point, C3, and "
                    "marked decorations (already constrained by the equalizer)."
                ),
            },
            "G": {
                "symbol": "G_{m,d}",
                "definition": "scheme-theoretic image of π_{m,d}",
                "as_schemes": (
                    "G_{m,d} := Spec( O(B_{m,d}) / ker(π^*) ) ⊆ B_{m,d}"
                ),
                "linear_structure": (
                    "Because Lambda and B are affine spaces (graded pieces of "
                    "linear modules) and π is linear, G_{m,d} = im(π) is a "
                    "linear subspace (cone) of B_{m,d}, closed in the Zariski "
                    "topology. Scheme-theoretic and set-theoretic images agree."
                ),
                "exact_defining_data": [
                    "Repaired incidence category C^{rep} with four arrow types",
                    "Local modules M_S from accepted transitions/* module.json",
                    "Equalizer presentation of Lambda^{rep}_{m,d}",
                    "Component projection π onto plane leading jet a_m",
                    "Ideal of G = kernel of the dual map on coordinate rings "
                    "(equivalently row-span of a basis of Lambda under π)",
                ],
                "family_refinements": {
                    "note": (
                        "Level-1 families cut discrete residual ledgers / "
                        "based vs residual coupling; each induces a closed "
                        "subscheme G^{fam}_{m,d} ⊆ G_{m,d}."
                    ),
                    "families": SURVIVOR_FAMILIES,
                    "formal_parameters_per_family": {
                        "a_m": "point of G^{fam} (leading jet)",
                        "b_{m+1}": "ker L_1 fibre (generic rank 4)",
                        "a_{m+2}": "free relative (stage r=2 has no exclusive equation)",
                    },
                },
            },
        },
        "rank_drop_loci": {
            "operators_source": {
                "polar_expansion": "certificates/lifting/polar_expansion.json",
                "free_module_stages": "certificates/lifting/families/free_module_stages.json",
                "universal_equations": {
                    "U.3m+1": "B(b_{m+1}; a_m, a_m) = 0",
                    "U.3m+3": (
                        "B(b_{m+3}; a_m, a_m) + 2 B(b_{m+1}; a_m, a_{m+2}) "
                        "+ F_+(b_{m+1}) = 0"
                    ),
                },
            },
            "L_1": {
                "definition": "L_1(b_{m+1}) = B(b_{m+1}; a_m, a_m)",
                "depends_on": "a_m only (quadratic in leading coefficients)",
                "free_shape": "(3m+2) × 3(m+2)",
                "RHS_R1": "0",
                "omega_1": "0 identically in coker L_1",
            },
            "L_3": {
                "definition": "L_3(b_{m+3}) = B(b_{m+3}; a_m, a_m)",
                "depends_on": "a_m only for the linear operator matrix",
                "RHS_R3": "2 B(b_{m+1}; a_m, a_{m+2}) + F_+(b_{m+1})",
                "free_shape": "(3m+4) × 3(m+4)",
                "omega_3": "class of R_3 in coker L_3 (coherent sheaf on stage base)",
            },
            "R_1_m": {
                "symbol": "R_{1,m}",
                "definition": "V( Fitt_0( coker L_1 ) ) ⊆ B_{m,*}",
                "meaning": (
                    "Closed locus of leading jets a_m where L_1 fails to be "
                    "surjective (Fitting ideal of the cokernel module over "
                    "the leading-jet coordinate ring)."
                ),
                "generic_status_m_1_3": (
                    "On the free-module base, generic coker L_1 = 0, so R_{1,m} "
                    "is a proper closed subset of free B_0 (for m=1,3 sealed)."
                ),
            },
            "R_3_m": {
                "symbol": "R_{3,m}",
                "definition": "V( Fitt_0( coker L_3 ) ) ⊆ B_{m,*}",
                "meaning": (
                    "Closed locus of leading jets a_m where L_3 fails to be "
                    "surjective. Only here can omega_3 obstruct; on the "
                    "complement L_3 is surjective so omega_3=0 for every R_3."
                ),
                "generic_status_m_1_3": (
                    "Generic coker L_3 = 0 for m=1,3 (sealed); R_{3,m} proper "
                    "closed in free B_0."
                ),
            },
            "ambient_for_loci": (
                "Primary ambient is free/multi-Rees B_{m,*} (leading a_m). "
                "Instantiated B_{m,d} inherits by base change / residual "
                "projection. Comparison with G uses the same ambient."
            ),
        },
        "required_decision": {
            "statement": (
                "Either G_{m,d} ⊆ R_{3,m}, or "
                "G_{m,d} ∩ (B_{m,d} \\ R_{3,m}) ≠ ∅."
            ),
            "exclusive_forks": {
                "containment_in_rank_drop": "Fork A (5C) — obstruction on rank drop",
                "meets_generic_surjective": "Fork B (5D) — construction through generic surjectivity",
            },
            "sample_point_policy": (
                "A sample point is insufficient for either claim unless both "
                "characteristic-zero validity and global compatibility "
                "(membership in Lambda^{rep}) are certified."
            ),
            "status_this_dispatch": "UNDECIDED",
            "structural_free_results": [
                {
                    "claim": "R_{3,m} is a proper closed subset of free B_0 for m=1,3",
                    "reason": (
                        "Sealed free-module generic rank of L_3 equals the "
                        "codomain rank over Q (coker 0 on a Zariski-open). "
                        "Hence the Fitting ideal of coker L_3 does not cut out "
                        "the whole free leading base: R_{3,m} ≠ free B_0."
                    ),
                    "label": "structural",
                    "not_a_containment_of_G": True,
                },
                {
                    "claim": "G_{m,d} ≠ 0 (as a cone) for every odd m and all large d",
                    "reason": "WP-5 Level-2 nonemptiness of Lambda + π linear",
                    "label": "structural",
                    "not_a_containment_into_R3": True,
                },
                {
                    "claim": (
                        "No free structural proof that G ⊆ R_3 or that G meets "
                        "the open, from accepted packets alone"
                    ),
                    "reason": (
                        "Equalizer conditions are O(d) linear cuts; R_3 is a "
                        "nonlinear determinantal locus of polar type. Their "
                        "incidence is not settled by growth or generic free "
                        "ranks alone."
                    ),
                    "label": "structural_negative_meta",
                },
            ],
            "not_decided_by_sampling": True,
        },
        "survivor_families": {
            "ids": SURVIVOR_FAMILIES,
            "exit_L_P": True,
            "note": (
                "Formal parameters and omega_3 sheaf as sealed in "
                "lifting/families/SUMMARY.json; never called covariants."
            ),
        },
    }


def main() -> None:
    accepted_hashes = {}
    for rel in ACCEPTED:
        p = ROOT / rel
        if not p.is_file():
            raise SystemExit(f"missing accepted input: {rel}")
        accepted_hashes[rel] = sha256_file(p)

    # Sanity: repair three-copy structure present
    repaired = load_json(ROOT / "certificates/transition_repair/category_repaired.json")
    assert repaired.get("headline") == "OPEN"
    three = repaired["three_copies_of_P_E_minus"]
    assert set(three.keys()) >= {"L_t_src", "P_E_minus_normal", "L_t_tgt"}
    assert "forbidden_identifications" in repaired
    assert repaired["corrected_necessity_theorem"]["surviving_families_retained"] == (
        SURVIVOR_FAMILIES
    )

    summary = load_json(ROOT / "certificates/lifting/families/SUMMARY.json")
    assert summary["decision_exit"] == "L-P"
    assert summary["headline"] == "OPEN"

    payload = {
        "attempt": 5,
        "gate": "5B — Gate 1: image of global states in leading-jet space",
        "work_package": "A5-G1",
        "headline": "OPEN",
        "containment_status": "UNDECIDED",
        "scope": {
            "includes": [
                "formulation of G_{m,d} ⊆ B_{m,d}",
                "rank-drop loci R_{1,m}, R_{3,m}",
                "precise decision statement",
                "size estimates per WORKORDER §7.2",
            ],
            "excludes": [
                "Fork A (5C) rank-drop obstruction computation",
                "Fork B (5D) generic-surjectivity construction",
                "generic local lifting continuation (house rule 4)",
                "containment decision by sampling",
            ],
        },
        "accepted_input_sha256": accepted_hashes,
        "formulation": build_formulation(),
        "size_estimates": build_size_estimates(),
        "theorem_boundary": {
            "proved_here": [
                "Exact defining data for G_{m,d} as scheme-theoretic image of π: Lambda^{rep} → B",
                "R_{1,m} and R_{3,m} as Fitting-ideal loci of accepted L_1, L_3",
                "Required decision stated; forks A/B identified",
                "Size estimates (dimensions, nnz, sparse/dense floors) for deciding it",
                "Structural: R_3 proper in free B_0 for m=1,3; G nonzero for large d",
            ],
            "not_proved_here": [
                "G ⊆ R_3",
                "G meets B \\ R_3",
                "Closed-form Fitting generators of R_3 in all m",
                "Existence of a landing covariant",
                "Emptiness of any survivor family",
            ],
        },
        "terminal_marker": "GLOBAL_STATE_IMAGE_FORMULATION_OK",
        "producer": {
            "script": "certificates/global_lifting/produce.py",
            "does_not_import": "verify.py",
        },
    }

    out = HERE / "global_state_image.json"
    body = {k: v for k, v in payload.items() if k != "self_sha256"}
    h = sha256_bytes(canonical_json(body).encode())
    payload["self_sha256"] = h
    out.write_text(canonical_json(payload))
    print(f"wrote {out.relative_to(ROOT)}")
    print(f"self_sha256={h}")
    print("GLOBAL_STATE_IMAGE_FORMULATION_OK")


if __name__ == "__main__":
    main()
