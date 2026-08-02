#!/usr/bin/env python3
"""Exact Hilbert-dimension obstruction to the proposed quadratic tests."""

from __future__ import annotations

from math import comb
import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
RELATION = Path(
    "/Users/worker/unirational/problems/E-klein-cubic/certificates/"
    "degree25_finite_module/relation_matrix.npz"
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def s(d: int) -> int:
    """dim Sym^d(F^37)."""
    return comb(36 + d, d)


def main() -> None:
    seeds = 690
    koszul = comb(seeds, 2)

    # Stage A+B faithful embedding:
    # A_1=(S2 V tensor B1) + (V tensor B2).
    w1 = 6 * s(2) + 21 * s(1)
    w2_terms = {
        "S4V_tensor_Sym2B1": s(4) * comb(6 + 1, 2),
        "S3V_tensor_B1_tensor_B2": s(3) * 6 * 21,
        "S2V_tensor_Sym2B2": s(2) * comb(21 + 1, 2),
    }
    w2 = sum(w2_terms.values())
    w_source = seeds * w1
    w_rank_upper = w_source - koszul
    w_cokernel_lower = w2 - w_rank_upper
    assert w1 == 4995
    assert w2 == 3_233_097
    assert w_source == 3_446_550
    assert koszul == 237_705
    assert w_rank_upper == 3_208_845
    assert w_cokernel_lower == 24_252
    k1 = w1 - seeds
    k1_quad = k1 * (k1 + 1) // 2

    # All-stage faithful embedding:
    # A_1=S3 V + (S2 V tensor B1) + (V tensor B2).
    w3_1 = s(3) + 6 * s(2) + 21 * s(1)
    w3_2_terms = {
        "S6V_b0_squared": s(6),
        "S5V_tensor_B1": s(5) * 6,
        "S4V_tensor_B2": s(4) * 21,
        "S4V_tensor_Sym2B1": s(4) * comb(6 + 1, 2),
        "S3V_tensor_B1_tensor_B2": s(3) * 6 * 21,
        "S2V_tensor_Sym2B2": s(2) * comb(21 + 1, 2),
    }
    w3_2 = sum(w3_2_terms.values())
    w3_source = seeds * w3_1
    w3_rank_upper = w3_source - koszul
    w3_cokernel_lower = w3_2 - w3_rank_upper
    assert w3_1 == 14_134
    assert w3_2 == 14_894_461
    assert w3_source == 9_752_460
    assert w3_cokernel_lower == 5_379_706
    k3 = w3_1 - seeds
    k3_quad = k3 * (k3 + 1) // 2

    payload = {
        "status": "PASS_QUADRATIC_FULL_SPAN_REFUTED_BY_EXACT_DIMENSIONS",
        "prime": 89,
        "seed_rank": seeds,
        "unavoidable_degree_two_Koszul_kernel": koszul,
        "relation_sha256": sha256(RELATION),
        "stageA_plus_B_faithful_W": {
            "A1_dimension": w1,
            "A2_terms": w2_terms,
            "A2_dimension": w2,
            "seed_times_A1_source": w_source,
            "multiplication_rank_upper_bound": w_rank_upper,
            "degree_two_quotient_lower_bound": w_cokernel_lower,
            "K_dimension": k1,
            "Sym2_K_dimension": k1_quad,
            "restricted_minor_rank_upper_bound": k1_quad - w_cokernel_lower,
            "conclusion": (
                "The restricted outer 2x2 minors cannot span Sym2(K^*); "
                "at least 24252 quadratic classes survive."
            ),
        },
        "all_stages_faithful_W3": {
            "A1_dimension": w3_1,
            "A2_terms": w3_2_terms,
            "A2_dimension": w3_2,
            "seed_times_A1_source": w3_source,
            "multiplication_rank_upper_bound": w3_rank_upper,
            "degree_two_quotient_lower_bound": w3_cokernel_lower,
            "K_dimension": k3,
            "Sym2_K_dimension": k3_quad,
            "restricted_minor_rank_upper_bound": k3_quad - w3_cokernel_lower,
            "raw_outer_minor_count": comb(37, 2) * comb(946, 2),
            "conclusion": (
                "The simultaneous restricted outer minors cannot span Sym2(K^*); "
                "at least 5379706 quadratic classes survive."
            ),
        },
        "proof_note": (
            "For the faithful rank-one coordinate ring A, imposing the 690 "
            "independent seed linear forms in degree one uses the multiplication "
            "map L tensor A1 -> A2.  The injective alternating map Lambda2(L) -> "
            "L tensor A1 lies in its kernel because A is commutative and p is odd."
        ),
        "scope_guard": (
            "Failure of quadratic full span is not a point and does not disprove "
            "emptiness.  It only retires this proposed degree-two certificate."
        ),
    }
    (HERE / "faithful_segre_dimension_result.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("PASS_QUADRATIC_FULL_SPAN_REFUTED_BY_EXACT_DIMENSIONS")


if __name__ == "__main__":
    main()
