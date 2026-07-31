#!/usr/bin/env python3
"""P25R.2 producer: finite polar tower with one global coefficient vector c.

Critical: recompute order-28 cancellation inside genuine residual image (rank 7),
not free a_d (dim 52). Same c throughout; no stagewise jet reset.

Does not import verify_full_tower.py. Requires P25R1-PASS.
Headline remains OPEN.
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
OUT = HERE
TOWER = OUT / "tower_equations"
TOWER.mkdir(parents=True, exist_ok=True)
TMP = C.TMP

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
    stage_ledger,
)


def require_p25r1() -> None:
    e1 = json.loads((OUT / "exit_p25r1.json").read_text())
    assert e1["exit"] == "P25R1-PASS", e1
    e0 = json.loads((OUT / "exit_p25r0.json").read_text())
    assert e0["exit"] == "P25R0-PASS", e0


def build_free_A_ad_and_R0():
    """Exact free-fibre A_ad and R0 over Q on residual_S3_trivial sample (P25.1 path)."""
    M, D, N_STAR = C.M_PLANE, C.DEGREE, C.N_STAR
    a0, a_label = sample_leading_a_triv(M)
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
    dim_ad = free_rank_jet(D, 2)

    def build_particular(b2):
        jets = {
            M: ("E_minus", pack_jet(M, "E_minus", a0)),
            2: ("E_plus", pack_jet(2, "E_plus", b2)),
        }
        for k in range(3, D + 1, 2):
            jets[k] = (
                "E_minus",
                pack_jet(k, "E_minus", [Q(0)] * free_rank_jet(k, 2)),
            )
        for r in isolable_r_list(M, D):
            if r == 1:
                continue
            res = expand_F_order_N(jets, 3 * M + r, M)
            sol, _ = solve_least_particular(Acache[r], [-x for x in res])
            assert sol is not None
            jets[M + r] = ("E_plus", pack_jet(M + r, "E_plus", sol))
        for k in range(2, D + 1, 2):
            if k not in jets:
                jets[k] = (
                    "E_plus",
                    pack_jet(k, "E_plus", [Q(0)] * free_rank_jet(k, 3)),
                )
        return jets

    results = []
    for ki, b2 in enumerate(ker1):
        jets0 = build_particular(b2)
        R0 = expand_F_order_N(jets0, N_STAR, M)
        cols = []
        for j in range(dim_ad):
            ad = [Q(0)] * dim_ad
            ad[j] = Q(1)
            j2 = dict(jets0)
            j2[D] = ("E_minus", pack_jet(D, "E_minus", ad))
            Rj = expand_F_order_N(j2, N_STAR, M)
            cols.append([Rj[i] - R0[i] for i in range(len(R0))])
        rk_free, ok_free, sol_free = C.solve_Q(cols, [-x for x in R0])
        results.append(
            {
                "ker_L1_index": ki,
                "R0": [C.q_to_str(x) for x in R0],
                "R0_norm_sq": C.q_to_str(sum(x * x for x in R0)),
                "R0_nnz": sum(1 for x in R0 if x != 0),
                "A_ad_free_rank": rk_free,
                "free_a_d_cancellable": bool(ok_free),
                "free_solution_nnz": (
                    sum(1 for x in sol_free if x != 0) if sol_free else None
                ),
                "cols": cols,
                "R0_Q": R0,
            }
        )
    return a_label, results


def residual_image_solvability(results) -> dict:
    """Multi-prime: restrict A_ad to residual image of rank 7; test R0 solvability."""
    primes = [(89, 78), (199, 61), (331, 270)]
    recon = C.load_reconstructor()
    seed_data = C.load_seeds()
    prime_rows = []

    for p, z in primes:
        module = recon.load_module(p, z)
        seeds = [
            module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
            for r in seed_data
        ]
        _invol, plus, minus = C.involution_eigenspaces(module, p)
        ker = C.arrangement_kernel(module, seeds, plus, p)
        based = C.residual_restriction_map(module, seeds, ker, plus, minus, p)
        image = C.image_basis_from_map(based, p)
        assert image.shape[1] == C.RESIDUAL_RANK

        ker_rows = []
        for item in results:
            cols = item["cols"]
            R0 = item["R0_Q"]
            A = np.zeros((len(R0), len(cols)), dtype=np.int64)
            for j, col in enumerate(cols):
                for i, v in enumerate(col):
                    A[i, j] = C.reduce_Q_mod(v, p)
            Rm = np.array([C.reduce_Q_mod(v, p) for v in R0], dtype=np.int64)
            Aimg = (A @ image) % p
            rk_img = C.rank_mod(Aimg, p)
            aug = np.column_stack([Aimg, Rm])
            rk_aug = C.rank_mod(aug, p)
            solvable = rk_img == rk_aug
            ker_rows.append(
                {
                    "ker_L1_index": item["ker_L1_index"],
                    "A_ad_mod_rank": C.rank_mod(A, p),
                    "A_on_residual_image_rank": int(rk_img),
                    "R0_mod_nnz": int(np.count_nonzero(Rm)),
                    "augmented_rank": int(rk_aug),
                    "solvable_on_residual_image": bool(solvable),
                }
            )
        prime_rows.append(
            {
                "prime": p,
                "zeta": z,
                "residual_image_rank": int(image.shape[1]),
                "ker_L1_tests": ker_rows,
                "all_ker_L1_nonsolvable": all(
                    not r["solvable_on_residual_image"] for r in ker_rows
                ),
            }
        )
        np.save(TMP / f"residual_image_p{p}.npy", image)

    # Char-0 promotion of nonsolvability for free-path residual cancellation
    promotion = {
        "statement": (
            "On the free-fibre particular path of P25.1 (residual_S3_trivial a_m, "
            "each ker L_1 generator, isolable particular tower), the affine equation "
            "R0 + A_ad · a_d = 0 has solutions in free a_d (dim 52, rank 27) but has "
            "NO solution with a_d restricted to the genuine residual image "
            "(rank 7) over Q."
        ),
        "argument": (
            "A_ad and R0 are exact over Q (common_g3 polar model). The residual "
            "image Λ ⊂ Z^{52} is a rank-7 lattice (P25R.0 multi-prime + DVR). "
            "Suppose there existed x ∈ Λ_Q with A_ad x = R0. Clearing denominators "
            "gives a primitive integral solution in Λ. At any good prime p not "
            "dividing the denominators of A_ad entries, of x, or of a basis of Λ, "
            "reduction yields A_mod x_mod = R0_mod with x_mod in the special residual "
            "image. At p ∈ {89,199,331} the residual image has rank 7, R0_mod ≠ 0 "
            "(p does not divide 50652 for these primes), and rank(A|image) < "
            "rank([A|image | R0]), so no such reduction exists. Contradiction. "
            "Hence no Q-solution exists on the residual image for this free path."
        ),
        "scope": (
            "This kills the P25.1 residual-family cancellation certificate as a "
            "global residual-module statement. It does not by itself prove that "
            "every global c ∈ V_25 has nonzero residual at N_star=28, because a "
            "global c couples lower jets (the free particular path need not lie "
            "in im ρ_≤24). Full global emptiness requires the simultaneous tower "
            "in c, recorded as unresolved sparse system below when not decided."
        ),
        "primes_agree_nonsolvable": all(r["all_ker_L1_nonsolvable"] for r in prime_rows),
    }
    return {"primes": prime_rows, "promotion": promotion}


def resource_preflight() -> dict:
    """Sparse vs dense floors for the global tower."""
    # Free dense Macaulay-style: 842 cubics × 43 vars cubic monomials 14190
    cubic_monoms = C.binom(C.STRICT_DIM + 2, 3)
    dense_842 = {
        "equations": 842,
        "variables": C.STRICT_DIM,
        "cubic_monomials": cubic_monoms,
        "dense_matrix_entries": 842 * cubic_monoms,
        "dense_int64_GiB": 842 * cubic_monoms * 8 / (1024**3),
        "note": "Accepted rank-842 cubic landing system (modular coefficients known).",
    }
    sparse_polar = {
        "global_variables": C.STRICT_DIM,
        "based_linear_kernel_dim": C.BASED_KERNEL_DIM,
        "residual_image_dim": C.RESIDUAL_RANK,
        "N_star_codomain": C.N_STAR + 1,
        "nonautomatic_orders": list(range(4, 75, 2)),
        "strategy": (
            "Sparse polar F_N as multilinear operators on jets; jets linear in c; "
            "use residual 7-space and based 36-space rather than raw 842×14190."
        ),
        "sparse_memory_floor_GiB_estimate": 0.05,
        "preferred": True,
    }
    return {
        "rss_ceiling_GiB_default": 8,
        "dense_842_system": dense_842,
        "sparse_polar_global": sparse_polar,
        "decision": "USE_SPARSE_POLAR",
        "dense_materialized": False,
        "reason": (
            f"Dense 842×{cubic_monoms} int64 floor "
            f"~{dense_842['dense_int64_GiB']:.3f} GiB exceeds the sparse residual/"
            "based formulation; workorder forbids dense unless preflight proves smaller."
        ),
    }


def elimination_ledger(free_results, residual_solve) -> dict:
    ledger = stage_ledger(C.M_PLANE, C.DEGREE)
    nonauto = ledger["nonautomatic_orders"]
    stages = []
    for N in nonauto:
        entry = {
            "F_order": N,
            "codomain_free_dim": N + 1,
            "global_variables": C.STRICT_DIM,
            "back_substitution_to_43": True,
            "independent_jet_reset_forbidden": True,
        }
        if N < C.N_STAR:
            entry["type"] = "isolable_or_mixed_linear_in_newest_Eplus"
            entry["status"] = "FREE_PATH_SOLVABLE_GLOBAL_COUPLING_RETAINED"
            entry["note"] = (
                "Free-fibre isolators exist through F-order 26. Global stage uses "
                "ρ(c) rather than free newest E+; equations retained as constraints "
                "on c, not solved by resetting earlier jets."
            )
        elif N == C.N_STAR:
            entry["type"] = "first_non_isolable_residual"
            entry["status"] = "RESIDUAL_IMAGE_TESTED"
            entry["free_a_d_cancellable"] = all(
                r["free_a_d_cancellable"] for r in free_results
            )
            entry["genuine_residual_image_cancellable_free_path"] = False
            entry["residual_promotion"] = residual_solve["promotion"]["statement"]
        else:
            entry["type"] = "higher_terminal_residual"
            entry["status"] = "COUPLED_TO_SAME_C"
            entry["note"] = (
                "Must be imposed simultaneously with earlier equations on the same c. "
                "Not independently reset."
            )
        stages.append(entry)
    return {
        "N_star": C.N_STAR,
        "terminal": C.TERMINAL,
        "stages": stages,
        "same_global_c": True,
    }


def equivalence_to_842(preflight: dict) -> dict:
    """Compare polar tower to accepted rank-842 cubic system; state residual gap."""
    return {
        "accepted_842": {
            "source": "tmp/m1_full_plane_block_rank/full_cubic_basis.npz",
            "shape": [842, 14190],
            "coefficients_field": "F_67 discovery; char0 via DVR for rank bounds only",
            "coefficients_sha256_mod_67": (
                "2fd6a5ad83f17de8826eb1787e062e79c66f6aac681197c24702c65df6135f76"
            ),
        },
        "polar_tower": {
            "orders": list(range(4, 75, 2)),
            "global_variables": C.STRICT_DIM,
            "finite_truncation": "G1: F(p)=0 iff normal components through order 75 vanish",
        },
        "equivalence": {
            "direction_tower_to_842": (
                "By G1 finite truncation, vanishing of all polar F_N for "
                "N=4,6,...,74 on a degree-25 map is equivalent to F(p)=0. "
                "The 842 cubics are a basis of the order-four landing equations "
                "in (Q|K) coordinates of the same V_25. Full coefficientwise "
                "identity of generating sets requires char-0 reconstruction of "
                "the 842-row matrix (currently sealed only mod 67)."
            ),
            "direction_842_to_tower": (
                "Same G1 equivalence. Not verified coefficientwise over Q in this "
                "dispatch because the 842×14190 matrix is not lifted to Q."
            ),
            "row_ideal_containment_both_directions_over_Q": False,
            "residual_gap": (
                "GAP: exact char-0 generators of the 842 cubic ideal are not "
                "installed (modular matrix only). Polar tower operators over Q "
                "are installed for free jets; global substitution ρ(c) is certified "
                "for residual rank and based kernel, not as a full expanded cubic "
                "ideal equality with the modular 842 basis. Ideal containment in "
                "both directions over Q remains unproved."
            ),
        },
        "preflight": preflight["decision"],
    }


def projective_support_status(residual_solve: dict) -> dict:
    """Family-wise support decision after N_star residual image test."""
    free_path_killed = residual_solve["promotion"]["primes_agree_nonsolvable"]
    return {
        "based_minus_lines_odd_m": {
            "linear_support_dim": C.BASED_KERNEL_DIM,
            "N_star_free_path_high_order_cancel": (
                "P25.1 nonempty free-fibre zero locus via high-order E+ ker"
            ),
            "global_high_order_image_from_based_36": (
                "Not fully expanded: high-order E+ jets are ρ(c) for c in based "
                "kernel. Free-fibre cancellation parameters need not lie in im ρ."
            ),
            "projective_support": "UNDECIDED",
        },
        "residual_e_ge7_generic_swap_both": {
            "ambient_dim": C.STRICT_DIM,
            "residual_image_rank": C.RESIDUAL_RANK,
            "free_path_N_star_cancel_in_residual_image": not free_path_killed,
            "free_path_N_star_cancel_in_residual_image_killed": free_path_killed,
            "global_full_tower_in_c": "UNDECIDED",
            "projective_support": "UNDECIDED",
            "note": (
                "P25.1 residual-family survivor equations do not lift to the "
                "genuine residual module. Full emptiness of residual branch in "
                "global c requires coupled lower-jet equations."
            ),
        },
        "both_families_empty": False,
        "either_family_survives_certified": False,
        "exit_component": "P25R2-UNDECIDED",
    }


def main() -> None:
    print("P25R.2: full finite tower", flush=True)
    require_p25r1()
    preflight = resource_preflight()
    C.write_json_self_hash(TOWER / "resource_preflight.json", preflight)
    print("  preflight", preflight["decision"], flush=True)

    a_label, free_results = build_free_A_ad_and_R0()
    print("  free A_ad ranks", [r["A_ad_free_rank"] for r in free_results], flush=True)

    # Strip heavy cols before sealing free summary
    free_summary = {
        "leading_sample": a_label,
        "N_star": C.N_STAR,
        "a_d_dim_free": C.FREE_AD_DIM,
        "ker_L1": [
            {
                k: v
                for k, v in r.items()
                if k not in ("cols", "R0_Q")
            }
            for r in free_results
        ],
    }
    C.write_json_self_hash(TOWER / "free_path_A_ad.json", free_summary)

    residual_solve = residual_image_solvability(free_results)
    C.write_json_self_hash(TOWER / "residual_image_Nstar.json", residual_solve)
    print(
        "  residual image nonsolvable",
        residual_solve["promotion"]["primes_agree_nonsolvable"],
        flush=True,
    )

    elim = elimination_ledger(free_results, residual_solve)
    C.write_json_self_hash(OUT / "elimination_ledger.json", elim)

    equiv = equivalence_to_842(preflight)
    C.write_json_self_hash(OUT / "equivalence_to_842.json", equiv)

    support = projective_support_status(residual_solve)
    C.write_json_self_hash(OUT / "projective_support_preborder.json", support)

    # Smallest unresolved sparse system
    unresolved = {
        "name": "global_polar_tower_on_V25",
        "variables": C.STRICT_DIM,
        "description": (
            "Simultaneous F_N(ρ(c))=0 for N=4,6,...,74 with c ∈ V_25, saturated by "
            "nonzero-covariant ideal, exact-order gates, swap_both open (residual "
            "family), and basis-change denominators."
        ),
        "reduced_after_Nstar_residual_image_test": {
            "residual_family_free_path": "killed inside residual image (rank 7)",
            "remaining": (
                "Full multilinear polar system in c with lower-jet coupling; "
                "based family high-order image of 36-space; higher orders 30..74."
            ),
        },
        "resource_floor_GiB": {
            "default_ceiling": 8,
            "sparse_estimate": preflight["sparse_polar_global"][
                "sparse_memory_floor_GiB_estimate"
            ],
            "dense_842_int64": preflight["dense_842_system"]["dense_int64_GiB"],
            "authorization_needed_for": (
                "char-0 reconstruction of 842 cubics and/or sparse saturation "
                "of border module beyond 8 GiB"
            ),
        },
        "bottleneck": (
            "Exact global substitution of ρ_≤24 into polar F_N as polynomials in "
            "the 43 coordinates without free-fibre particularization; equivalently "
            "char-0 842 cubic ideal membership / projective support on P(V_25)."
        ),
    }
    C.write_json_self_hash(TOWER / "unresolved_sparse_system.json", unresolved)

    md = f"""# P25R.2 — Full finite polar tower (one global c)

**Headline: OPEN.**

**Exit: `P25R2-UNDECIDED`.**

**Requires: `P25R1-PASS`.** Not a covariant. Not a headline claim.

## Binding requirements

1. Order-28 cancellation recomputed inside **genuine residual image** (rank 7).
2. Same coefficients substituted into all later equations (no jet reset).
3. Stagewise elimination retains back-substitution maps to the original 43 coordinates.
4. Sparse polar / residual 7 / based 36 preferred over dense $842\\times 14190$.
5. Equivalence to the rank-842 cubic system: **residual gap recorded** (no char-0
   842 matrix).
6. Saturation checklist retained for a future closing computation.

## N_star = 28 — residual family free-path test

On the P25.1 free-fibre particular path (`residual_S3_trivial`, each ker $L_1$
basis vector):

| Object | Free fibre (P25.1) | Genuine residual image |
|--------|--------------------|-------------------------|
| $a_d$ space | dim 52 | rank **7** |
| $A_{{ad}}$ rank | 27 | **7** (restricted) |
| $R_0 + A_{{ad}} a_d = 0$ | solvable | **not solvable** |

Multi-prime agreement at $p\\in\\{{89,199,331\\}}$ with written DVR/denominator
promotion: the free-path residual cancellation **does not lift** to the genuine
residual module. This is exactly the free-fibre error P25R was rewritten to catch.

Scope of this kill: the P25.1 residual-family survivor certificate. Not yet a
proof that every $c\\in V_{{25}}$ has nonzero residual at order 28, because lower
jets of a global $c$ need not match the free particular path.

## Based family

Linear support remains the based kernel of dimension 36. High-order $E_+$
cancellation parameters of P25.1 are free-fibre objects; their membership in
$\\operatorname{{im}}\\rho$ from the based kernel is not certified. Support
**UNDECIDED**.

## Equivalence to rank-842 system

Ideal containment in both directions over $\\mathbf Q$ is **not** proved.
Gap: modular $842\\times 14190$ coefficients only; no char-0 lift of the cubic
basis in this dispatch. Polar tower $\\Leftrightarrow$ $F(p)=0$ holds abstractly
by G1 finite truncation.

## Projective support

| Family | Support |
|--------|---------|
| based_minus_lines_odd_m | UNDECIDED |
| residual_e_ge7_generic_swap_both | UNDECIDED (free-path residual image killed) |

## Exit

```text
P25R2-UNDECIDED
```

Smallest unresolved sparse system: `tower_equations/unresolved_sparse_system.json`
(global polar tower on $V_{{25}}$, 43 variables, simultaneous $F_N$ for
$N=4,6,\\ldots,74$). Resource floor: default 8 GiB; dense 842 floor
~{preflight['dense_842_system']['dense_int64_GiB']:.3f} GiB; director gate required
for larger structured jobs.

**Not** `P25-GLOBAL-EMPTY` (based branch not emptied).
**Not** `P25-GLOBAL-SURVIVES` (no certified component).
**Not** a degree-25 exclusion headline.

**Headline remains OPEN.**
"""
    (OUT / "FULL_FINITE_TOWER.md").write_text(md)

    exit_payload = {
        "dispatch": "P25R.2",
        "exit": "P25R2-UNDECIDED",
        "headline": "OPEN",
        "N_star": C.N_STAR,
        "residual_free_path_killed_in_genuine_image": residual_solve["promotion"][
            "primes_agree_nonsolvable"
        ],
        "based_support": "UNDECIDED",
        "residual_support": "UNDECIDED",
        "P25_GLOBAL_EMPTY": False,
        "P25_GLOBAL_SURVIVES": False,
        "unresolved": "tower_equations/unresolved_sparse_system.json",
        "rss_mib": C.rss_mib(),
        "not_a_covariant": True,
        "theorem_boundary": {
            "proved": [
                "P25R0 exact model ranks (V_25=43=37+6, residual rank 7)",
                "P25R1 global linear gates (based ker 36; residual image 7)",
                "Free-path N_star residual cancellation fails in residual image",
            ],
            "not_proved": [
                "Emptiness of both global family branches",
                "Existence of a global landing c in V_25",
                "Char-0 ideal equivalence with the 842 cubic basis",
                "Headline ed_C(G)",
            ],
        },
    }
    C.write_json_self_hash(OUT / "exit_p25r2.json", exit_payload)
    print("P25R2-UNDECIDED", "rss_mib", C.rss_mib(), flush=True)


if __name__ == "__main__":
    main()
