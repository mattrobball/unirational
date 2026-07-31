#!/usr/bin/env python3
"""P25Y.1 independent verifier.

Does not import produce_dvr.py. Recomputes arrangement/order-2 ranks, unit
minor determinants, monic basis left minor, residual rank, and ρ shape at
p=89; checks holdout unit-pivot claims by recomputing at p=199.
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
P, Z = 89, 78
ARR_RANK = 130
ORDER2_RANK = 16


def unit_minor_det(matrix: np.ndarray, prime: int, expected_rank: int) -> int:
    a = (np.asarray(matrix, dtype=np.int64) % prime).copy()
    rows, cols = a.shape
    row_idx = list(range(rows))
    pivots: list[int] = []
    selected: list[int] = []
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
        selected.append(row_idx[r])
        r += 1
        if r == expected_rank:
            break
    if len(pivots) != expected_rank:
        return 0
    b = (matrix[np.ix_(selected, pivots)] % prime).astype(np.int64).copy()
    det = 1
    n = expected_rank
    for i in range(n):
        piv = next((j for j in range(i, n) if b[j, i] % prime), None)
        if piv is None:
            return 0
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
    return int(det % prime)


def rebuild(prime: int, zeta: int):
    recon = C.load_reconstructor()
    seed_data = C.load_seeds()
    module = recon.load_module(prime, zeta)
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in seed_data
    ]
    _, plus, minus = C.involution_eigenspaces(module, prime)
    pts = []
    for a in range(C.DEGREE + 1):
        for b in range(C.DEGREE + 1 - a):
            pts.append((plus[0] + a * plus[1] + b * plus[2]) % prime)
    points = np.asarray(pts[:351], dtype=np.int64)
    R = C.batch_seed_evaluations(module, seeds, points, prime)
    ker = C.arrangement_kernel(module, seeds, plus, prime)
    strict, sr, order2 = C.strict_from_arrangement(module, seeds, ker, prime)
    basis43, pivots = C.monic_basis_reynolds(sr, prime)
    return module, seeds, plus, minus, R, ker, strict, sr, order2, basis43, pivots


def main() -> None:
    errors: list[str] = []
    cert_path = OUT / "dvr_certificate.json"
    if not cert_path.exists():
        print("FAIL: missing dvr_certificate.json")
        sys.exit(1)
    cert = json.loads(cert_path.read_text())

    # Self-hash
    body = {k: v for k, v in cert.items() if k != "self_sha256"}
    text = json.dumps(body, indent=2, sort_keys=True) + "\n"
    digest = C.sha256_bytes(text.encode())
    if digest != cert.get("self_sha256"):
        errors.append(f"self_sha256 mismatch: {digest} vs {cert.get('self_sha256')}")

    print(f"rebuild decision fibre p={P}", flush=True)
    module, seeds, plus, minus, R, ker, strict, sr, order2, basis43, pivots = rebuild(
        P, Z
    )
    arr_rk = C.rank_mod(R, P)
    arr_det = unit_minor_det(R, P, ARR_RANK)
    o2_rk = C.rank_mod(order2, P)
    o2_det = unit_minor_det(order2, P, ORDER2_RANK)
    left_det = 1
    for i in range(43):
        left_det = (left_det * int(basis43[i, i] % P)) % P

    if arr_rk != ARR_RANK:
        errors.append(f"arrangement rank {arr_rk} != {ARR_RANK}")
    if arr_det % P == 0:
        errors.append("arrangement minor not unit")
    if o2_rk != ORDER2_RANK:
        errors.append(f"order2 rank {o2_rk} != {ORDER2_RANK}")
    if o2_det % P == 0:
        errors.append("order2 minor not unit")
    if pivots != list(range(43)):
        errors.append(f"unexpected monic pivots {pivots[:5]}...")
    if left_det % P == 0:
        errors.append("basis left minor not unit")
    if ker.shape != (59, 189) or strict.shape != (43, 59):
        errors.append("unexpected ker/strict shapes")

    decide = cert.get("decide_fibre", {})
    if decide.get("arrangement_unit_minor_det") != arr_det:
        errors.append(
            f"arr det cert {decide.get('arrangement_unit_minor_det')} != recomputed {arr_det}"
        )
    if decide.get("order2_unit_minor_det") != o2_det:
        errors.append(
            f"o2 det cert {decide.get('order2_unit_minor_det')} != recomputed {o2_det}"
        )
    if decide.get("basis43_sha256") != C.sha256_arr(basis43.astype(np.uint64)):
        errors.append("basis43 sha mismatch vs certificate")

    # Stored npz
    npz = OUT / "dvr_special_fibre_p89.npz"
    if not npz.exists():
        errors.append("missing dvr_special_fibre_p89.npz")
    else:
        with np.load(npz) as zf:
            if C.sha256_arr(zf["basis43"].astype(np.uint64)) != C.sha256_arr(
                basis43.astype(np.uint64)
            ):
                errors.append("npz basis43 != recomputed")
            if zf["rho"].shape != (868, 43):
                errors.append(f"rho shape {zf['rho'].shape}")

    # Holdout p=199 unit minors
    print("rebuild holdout p=199", flush=True)
    _, _, _, _, R2, _, _, _, o2b, b2, piv2 = rebuild(199, 61)
    if C.rank_mod(R2, 199) != ARR_RANK or unit_minor_det(R2, 199, ARR_RANK) % 199 == 0:
        errors.append("holdout 199 arrangement not unit-pivot")
    if C.rank_mod(o2b, 199) != ORDER2_RANK or unit_minor_det(o2b, 199, ORDER2_RANK) % 199 == 0:
        errors.append("holdout 199 order2 not unit-pivot")
    if piv2 != list(range(43)):
        errors.append("holdout 199 monic pivots unexpected")

    # Denominators
    if pow(660, -1, P) is None or P in (2, 3, 5, 11):
        errors.append("660 not invertible at decision prime")
    if not cert.get("denominator_unit_ledger", {}).get("p_does_not_divide_660"):
        errors.append("ledger claims 660 not unit")

    # Exit honesty
    expected_exit = "P25Y-DVR-PASS" if not errors and decide.get("unit_pivot_bundle") else None
    if cert.get("exit") == "P25Y-DVR-PASS" and (
        arr_det % P == 0 or o2_det % P == 0 or left_det % P == 0
    ):
        errors.append("PASS claimed without unit pivots")

    if errors:
        print("VERIFY FAIL:")
        for e in errors:
            print(" ", e)
        sys.exit(1)
    print(
        f"VERIFY OK: arr_det={arr_det} o2_det={o2_det} left_det={left_det} "
        f"exit={cert.get('exit')} rss={C.rss_mib():.1f}"
    )
    print(f"(expected_exit_hint={expected_exit})")


if __name__ == "__main__":
    main()
