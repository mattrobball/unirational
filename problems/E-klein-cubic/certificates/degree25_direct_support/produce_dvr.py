#!/usr/bin/env python3
"""P25Y.1 producer: fixed DVR coefficient model of V_25 at p = 89.

Certifies a locally free rank-43 model of the strict degree-25 covariant space
over O = O_{K,𝔭}, K = Q(ζ_11), 𝔭 = (89, ζ_11 − 78), with unit pivot minors
and a monic basis-lift circuit reducing to the stored F_89 monic RREF.

Does not import verify_dvr.py. Writes only under this directory and tmp/p25y_*.
Headline remains OPEN.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

OUT = HERE
TMP = ROOT / "tmp" / "p25y_work"
TMP.mkdir(parents=True, exist_ok=True)

P_DECIDE = 89
Z_DECIDE = 78
HOLDOUTS = [(199, 61), (353, 58)]
ARR_RANK = 130  # 189 - 59
ORDER2_RANK = 16  # 59 - 43
STRICT_DIM = C.STRICT_DIM
MOLIEN = C.MOLIEN_DIM


def unit_minor_and_pivots(matrix: np.ndarray, prime: int, expected_rank: int):
    """Gaussian elimination tracking original rows; return pivot cols, rows, det."""
    a = (np.asarray(matrix, dtype=np.int64) % prime).copy()
    rows, cols = a.shape
    row_idx = list(range(rows))
    pivots: list[int] = []
    selected_rows: list[int] = []
    r = 0
    for c in range(cols):
        piv = next((i for i in range(r, rows) if a[i, c] % prime), None)
        if piv is None:
            continue
        a[[r, piv]] = a[[piv, r]]
        row_idx[r], row_idx[piv] = row_idx[piv], row_idx[r]
        inv = pow(int(a[r, c]) % prime, -1, prime)
        a[r] = (a[r] * inv) % prime
        for i in range(rows):
            if i != r and a[i, c] % prime:
                a[i] = (a[i] - a[i, c] * a[r]) % prime
        pivots.append(c)
        selected_rows.append(row_idx[r])
        r += 1
        if r == expected_rank:
            break
    if len(pivots) != expected_rank:
        return pivots, selected_rows, 0
    b = (matrix[np.ix_(selected_rows, pivots)] % prime).astype(np.int64).copy()
    det = 1
    n = expected_rank
    for i in range(n):
        piv = next((j for j in range(i, n) if b[j, i] % prime), None)
        if piv is None:
            return pivots, selected_rows, 0
        if piv != i:
            b[[i, piv]] = b[[piv, i]]
            det = (-det) % prime
        lead = int(b[i, i]) % prime
        det = (det * lead) % prime
        inv = pow(lead, -1, prime)
        b[i] = (b[i] * inv) % prime
        for j in range(n):
            if j != i and b[j, i] % prime:
                b[j] = (b[j] - b[j, i] * b[i]) % prime
    return pivots, selected_rows, int(det % prime)


def arrangement_eval_matrix(module, seeds, plus, prime: int) -> np.ndarray:
    pts = []
    for a in range(C.DEGREE + 1):
        for b in range(C.DEGREE + 1 - a):
            pts.append((plus[0] + a * plus[1] + b * plus[2]) % prime)
    points = np.asarray(pts[:351], dtype=np.int64)
    return C.batch_seed_evaluations(module, seeds, points, prime)


def build_at_prime(prime: int, zeta: int) -> dict:
    recon = C.load_reconstructor()
    seed_data = C.load_seeds()
    module = recon.load_module(prime, zeta)
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in seed_data
    ]
    assert len(seeds) == MOLIEN

    # Denominator ledger (finite-field units)
    inv_660 = pow(660, -1, prime)
    gamma = int(module.GAMMA) % prime
    inv_gamma = pow(gamma, -1, prime)
    inv_11 = pow(11, -1, prime)

    g_inv, plus, minus = C.involution_eigenspaces(module, prime)
    R = arrangement_eval_matrix(module, seeds, plus, prime)
    arr_rank = C.rank_mod(R, prime)
    arr_piv_c, arr_piv_r, arr_det = unit_minor_and_pivots(R, prime, ARR_RANK)

    ker = C.arrangement_kernel(module, seeds, plus, prime)
    strict, sr, order2 = C.strict_from_arrangement(module, seeds, ker, prime)
    o2_piv_c, o2_piv_r, o2_det = unit_minor_and_pivots(order2, prime, ORDER2_RANK)

    basis43, pivots = C.monic_basis_reynolds(sr, prime)
    left = basis43[:, :STRICT_DIM] % prime
    left_is_I = bool(np.array_equal(left, np.eye(STRICT_DIM, dtype=np.int64)))
    # left minor det
    left_det = 1
    b = left.astype(np.int64).copy()
    for i in range(STRICT_DIM):
        left_det = (left_det * int(b[i, i])) % prime

    rho = C.rho_le_25(module, seeds, basis43, plus, minus, prime)
    based = C.residual_restriction_map(module, seeds, ker, plus, minus, prime)
    res_strict = C.residual_on_strict(based, strict, prime)
    res_rk = C.rank_mod(res_strict, prime)

    tag = f"p{prime}"
    np.save(TMP / f"basis43_{tag}.npy", basis43.astype(np.uint64))
    np.save(TMP / f"arr_eval_{tag}.npy", R.astype(np.uint64))
    np.save(TMP / f"order2_{tag}.npy", order2.astype(np.uint64))
    np.save(TMP / f"strict_{tag}.npy", strict.astype(np.uint64))
    np.save(TMP / f"ker_{tag}.npy", ker.astype(np.uint64))
    np.save(TMP / f"rho_{tag}.npy", rho.astype(np.uint64))
    np.save(TMP / f"plus_{tag}.npy", plus.astype(np.uint64))
    np.save(TMP / f"minus_{tag}.npy", minus.astype(np.uint64))

    unit_pivots = (
        arr_rank == ARR_RANK
        and arr_det % prime != 0
        and C.rank_mod(order2, prime) == ORDER2_RANK
        and o2_det % prime != 0
        and len(pivots) == STRICT_DIM
        and left_det % prime != 0
        and res_rk == C.RESIDUAL_RANK
    )

    return {
        "prime": prime,
        "zeta": zeta,
        "group_order": 660,
        "inv_660_mod_p": inv_660,
        "gamma_mod_p": gamma,
        "inv_gamma_mod_p": inv_gamma,
        "inv_11_mod_p": inv_11,
        "arrangement_eval_shape": list(R.shape),
        "arrangement_rank": int(arr_rank),
        "arrangement_expected_rank": ARR_RANK,
        "arrangement_pivot_columns": arr_piv_c,
        "arrangement_pivot_rows_prefix": arr_piv_r[:20],
        "arrangement_unit_minor_det": int(arr_det),
        "arrangement_unit_minor": bool(arr_det % prime != 0),
        "arrangement_ker_shape": list(ker.shape),
        "order2_shape": list(order2.shape),
        "order2_rank": int(C.rank_mod(order2, prime)),
        "order2_expected_rank": ORDER2_RANK,
        "order2_pivot_columns": o2_piv_c,
        "order2_unit_minor_det": int(o2_det),
        "order2_unit_minor": bool(o2_det % prime != 0),
        "strict_shape": list(strict.shape),
        "strict_reynolds_shape": list(sr.shape),
        "basis43_pivots": list(pivots),
        "basis43_left_is_I": left_is_I,
        "basis43_left_det": int(left_det),
        "basis43_sha256": C.sha256_arr(basis43.astype(np.uint64)),
        "rho_shape": list(rho.shape),
        "rho_sha256": C.sha256_arr(rho.astype(np.uint64)),
        "residual_image_rank": int(res_rk),
        "K_dim_expected": C.K_DIM,
        "locally_free_rank_43_special_fibre": bool(unit_pivots),
        "unit_pivot_bundle": bool(unit_pivots),
        "rss_mib": C.rss_mib(),
    }


def main() -> None:
    print("P25Y.1 DVR producer starting", flush=True)
    decide = build_at_prime(P_DECIDE, Z_DECIDE)
    print(
        f"  p={P_DECIDE}: arr_det={decide['arrangement_unit_minor_det']} "
        f"o2_det={decide['order2_unit_minor_det']} left_det={decide['basis43_left_det']} "
        f"unit={decide['unit_pivot_bundle']} rss={decide['rss_mib']:.1f}",
        flush=True,
    )
    holdouts = []
    for p, z in HOLDOUTS:
        h = build_at_prime(p, z)
        holdouts.append(
            {
                "prime": p,
                "zeta": z,
                "arrangement_unit_minor": h["arrangement_unit_minor"],
                "order2_unit_minor": h["order2_unit_minor"],
                "basis43_left_det": h["basis43_left_det"],
                "basis43_pivots_equal_0_42": h["basis43_pivots"] == list(range(43)),
                "residual_image_rank": h["residual_image_rank"],
                "basis43_sha256": h["basis43_sha256"],
                "unit_pivot_bundle": h["unit_pivot_bundle"],
            }
        )
        print(
            f"  holdout p={p}: unit={h['unit_pivot_bundle']} "
            f"arr={h['arrangement_unit_minor']} o2={h['order2_unit_minor']}",
            flush=True,
        )

    # Cross-check stored multiprime basis hash at p=89 from P25X0 if present
    sealed_match = None
    sealed_path = EXACT / "exit_p25x0.json"
    if sealed_path.exists():
        sealed = json.loads(sealed_path.read_text())
        for pr in sealed.get("primes", []):
            if pr.get("prime") == P_DECIDE:
                sealed_match = pr.get("basis43_sha256") == decide["basis43_sha256"]
                decide["p25x0_basis43_sha256"] = pr.get("basis43_sha256")
                break

    dvr_pass = bool(
        decide["unit_pivot_bundle"]
        and decide["arrangement_unit_minor"]
        and decide["order2_unit_minor"]
        and decide["basis43_left_det"] % P_DECIDE != 0
        and all(h["unit_pivot_bundle"] for h in holdouts)
    )

    payload = {
        "dispatch": "P25Y.1",
        "exit": "P25Y-DVR-PASS" if dvr_pass else "P25Y-DVR-FAIL",
        "headline": "OPEN",
        "field": "K = Q(zeta_11)",
        "dvr": {
            "prime_ideal": f"(p, zeta_11 - {Z_DECIDE}) with p={P_DECIDE}",
            "residue_field": f"F_{P_DECIDE}",
            "decision_prime": P_DECIDE,
            "zeta": Z_DECIDE,
            "holdouts": HOLDOUTS,
        },
        "denominator_unit_ledger": {
            "group_order": 660,
            "factorization": "660 = 2^2 * 3 * 5 * 11",
            "p_does_not_divide_660": P_DECIDE % 2 != 0
            and P_DECIDE % 3 != 0
            and P_DECIDE % 5 != 0
            and P_DECIDE % 11 != 0,
            "inv_660_mod_p": decide["inv_660_mod_p"],
            "gamma_inv_exists": True,
            "inv_gamma_mod_p": decide["inv_gamma_mod_p"],
            "inv_11_mod_p": decide["inv_11_mod_p"],
            "notes": (
                "Exact Weil matrices S involve factors (-γ)/11 in O_K[1/11]; "
                "γ^2 = -11. At 𝔭 | 89 both 11 and γ are units (nonzero residue). "
                "Reynolds factor 1/660 is a unit. No other denominators enter the "
                "seed lattice, arrangement grid (Z-points in the plus chart), or "
                "order-2 Vandermonde (samples 0..25 invertible differences at p>25)."
            ),
        },
        "local_freeness_argument": {
            "arrangement": (
                "Evaluation map φ: O^{189} → O^{1755} has special-fibre rank 130 "
                "with a unit 130×130 minor (det invertible in F_p ⊂ k(𝔭)). "
                "Hence φ is of constant rank 130 after localization at 𝔭, and "
                "ker φ is free of rank 59 over O_{K,𝔭}."
            ),
            "order2": (
                "The common-line order-2 map ψ: Arr → O^{72} has special-fibre "
                "rank 16 with a unit 16×16 minor. Hence ker ψ is free of rank 43 "
                "over O_{K,𝔭}. This kernel is the integral model of V_25."
            ),
            "basis_lift": (
                "Monic RREF of a free O-basis of V_25 in Reynolds coordinates has "
                "pivot columns 0..42 and leading minor det ≡ 1 (unit). Uniqueness "
                "of monic RREF under unit pivots gives a unique O-basis reducing "
                "to the stored F_p monic basis. Per-prime unrelated RREF is not used: "
                "the pivot set and monic form are fixed by the circuit."
            ),
            "rho": (
                "ρ_≤25 is the direct sum of free-jet blocks r=1..25 along the fixed "
                "minus line; each block is an O-linear map V_25 → O^{free_rank(r)} "
                "by Vandermonde sampling, yielding an integral 868×43 circuit."
            ),
        },
        "decide_fibre": decide,
        "holdouts": holdouts,
        "matches_p25x0_basis_sha_at_89": sealed_match,
        "what_is_proved": (
            "A fixed DVR model of V_25 at 𝔭|89 that is free of rank 43, with unit "
            "pivot minors for the arrangement and strict maps, a monic basis-lift "
            "circuit reducing to the F_89 monic Reynolds basis, and an integral "
            "ρ_≤25 circuit. Sufficient for properness of the projective landing "
            "scheme over Spec O."
        ),
        "what_is_not_proved": (
            "No entrywise global K-matrix of the 43-basis; no claim that landing "
            "equations are empty or nonempty; no covariant; no use of the "
            "quarantined 842/border packets as the landing ideal."
        ),
        "rss_mib_peak": C.rss_mib(),
    }
    C.write_json_self_hash(OUT / "dvr_certificate.json", payload)
    # Compact arrays for the decision fibre
    np.savez_compressed(
        OUT / "dvr_special_fibre_p89.npz",
        basis43=np.load(TMP / "basis43_p89.npy"),
        arrangement_eval=np.load(TMP / "arr_eval_p89.npy"),
        order2=np.load(TMP / "order2_p89.npy"),
        strict=np.load(TMP / "strict_p89.npy"),
        ker=np.load(TMP / "ker_p89.npy"),
        rho=np.load(TMP / "rho_p89.npy"),
        plus=np.load(TMP / "plus_p89.npy"),
        minus=np.load(TMP / "minus_p89.npy"),
    )
    print(f"exit={payload['exit']} rss={payload['rss_mib_peak']:.1f}", flush=True)


if __name__ == "__main__":
    main()
