#!/usr/bin/env python3
"""Independent verifier for P25V.0 — does not import the producer.

Recomputes rank V_0 = 690 and shows all 126 T_quad deg0 cubics reduce to a
nonzero remainder against the RREF of V_0 (hence lie outside V_0). Checks exit
JSON consistency with the structural certificate and sealed input hashes.
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
FM = ROOT / "certificates" / "degree25_finite_module"

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P = 89


def rref_rows(M: np.ndarray):
    A = (M % P).astype(np.int64).copy()
    pivots: list[int] = []
    r = 0
    rows, cols = A.shape
    for c in range(cols):
        piv = None
        for i in range(r, rows):
            if A[i, c] % P:
                piv = i
                break
        if piv is None:
            continue
        if piv != r:
            A[[r, piv]] = A[[piv, r]]
        inv = pow(int(A[r, c]) % P, -1, P)
        A[r] = (A[r] * inv) % P
        col = A[:, c].copy()
        for i in range(rows):
            if i != r and col[i] % P:
                A[i] = (A[i] - col[i] * A[r]) % P
        pivots.append(c)
        r += 1
        if r == rows:
            break
    return A[:r], pivots


def reduce_vec(v: np.ndarray, ech: np.ndarray, pivots: list[int]) -> np.ndarray:
    v = (v % P).astype(np.int64).copy()
    for i, pc in enumerate(pivots):
        c = int(v[pc]) % P
        if c:
            v = (v - c * ech[i]) % P
    return v


def main() -> None:
    print("=== P25V.0 verify ===", flush=True)
    exit_path = HERE / "exit_p25v0.json"
    payload = json.loads(exit_path.read_text())
    assert payload["exit"] == "P25V-PRESENTATION-ENLARGED"
    assert payload["prime"] == P

    rel = np.load(FM / "relation_matrix.npz")
    seed = rel["seed_F3"]
    off3 = rel["off3"]
    seed_sha = C.sha256_arr(seed)
    assert seed_sha == payload["inputs"]["seed_F3_sha256"]

    mult = np.load(FM / "multiplication_matrices.npz")
    Tq = mult["T_quad_F3"]
    assert C.sha256_arr(Tq) == payload["inputs"]["T_quad_F3_sha256"]

    V0 = seed[:, int(off3[0]) : int(off3[1])].astype(np.int64) % P
    ech, pivots = rref_rows(V0)
    assert len(pivots) == 690, len(pivots)
    print(f"V0 rref rank={len(pivots)}", flush=True)

    Tq0 = Tq[:, :, int(off3[0]) : int(off3[1])].astype(np.int64) % P
    n_out = 0
    for i in range(6):
        for qi in range(21):
            t = Tq0[i, qi]
            assert np.any(t % P), f"unexpected zero Tq0[{i},{qi}]"
            rem = reduce_vec(t, ech, pivots)
            if np.any(rem % P):
                n_out += 1
    assert n_out == 126, n_out
    assert payload["structural_certificate"]["n_Tq0_out_V0"] == 126
    assert payload["deg0_membership"]["membership_all"] is False
    assert payload["deg0_membership"]["n_Ti_out"] == 4140
    assert payload["deg0_membership"]["n_comm_out"] == 315

    cert = np.load(HERE / "deg0_structural_cert.npz")
    assert int(cert["n_Tq0_out"]) == 126
    assert C.rank_mod(cert["V0"].astype(np.int64), P) == 690

    result = {
        "exit": payload["exit"],
        "verified_structural_Tq0_out_V0": 126,
        "verified_rank_V0": 690,
        "seed_F3_sha256": seed_sha,
        "method": "RREF of V0 + remainder of each Tq0 cubic",
        "ok": True,
    }
    C.write_json_self_hash(HERE / "verify_p25v0_result.json", result)
    print("PASS", result, flush=True)


if __name__ == "__main__":
    main()
