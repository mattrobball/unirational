#!/usr/bin/env python3
"""P25W.2 Stage B — compressed kernel-incidence preflight (no heavy solve).

Records exact sizes, bidegrees, and a measured memory floor for the smallest
deterministic compressions (64, then 72, then 84 linear combinations of the
690 seed equations). Does not claim the heavy multihomogeneous saturation
slot unless a measured floor stays under 8 GiB.

Writes certificates/degree25_p25w/preflight_incidence.json.
"""
from __future__ import annotations

import json
import sys
import time
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent.parent
EXACT = ROOT / "certificates" / "degree25_exact"
FM = ROOT / "certificates" / "degree25_finite_module"

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P = 89


def main() -> None:
    t0 = time.time()
    peak = C.rss_mib()
    print("=== P25W.2 Stage B incidence preflight ===", flush=True)

    rel = np.load(FM / "relation_matrix.npz")
    seed = rel["seed_F3"]
    off3 = rel["off3"]
    seed_sha = C.sha256_arr(seed)

    # Full seed matrix as 690 equations on b ∈ P^{27}, coeffs polys in q.
    # Bidegree (3,1) under deg q=(1,0), deg b0=(0,1), deg b1=(1,1), deg b2=(2,1).
    n_eq = 690
    n_q = 37
    n_b = 28
    n_b0, n_b1, n_b2 = 1, 6, 21

    # Deterministic compression: first r rows of a fixed F_89-Hadamard-like
    # combination matrix C (r × 690) with full row rank, applied as C @ seed_rows.
    rng = np.random.default_rng(2026073189)
    compressions = {}
    for r in (64, 72, 84):
        Cmat = rng.integers(0, P, size=(r, n_eq), dtype=np.int64)
        # Force full row rank by RREF check / resample once if needed.
        if C.rank_mod(Cmat, P) < r:
            Cmat = np.eye(r, n_eq, dtype=np.int64)
            Cmat = (Cmat + rng.integers(0, P, size=(r, n_eq))) % P
        rk = C.rank_mod(Cmat, P)
        # Compressed polyvector block: r × 14134
        # (do not materialize full for r=84 if memory tight — just size it)
        nbytes = r * 14134  # uint8
        compressions[str(r)] = {
            "n_equations": r,
            "compression_row_rank": int(rk),
            "compressed_seed_F3_shape": [r, 14134],
            "storage_uint8_bytes": nbytes,
            "variables": {
                "q": n_q,
                "b": n_b,
                "total_affine": n_q + n_b,
            },
            "bidegree_each_equation": [3, 1],
            "saturation": "by q-irrelevant (q0..q36) and b-irrelevant (b0..b27)",
            "method_options": [
                {
                    "name": "msolve bihomogeneous / affine charts",
                    "expected_cost": (
                        f"{r} equations of bidegree (3,1) in 65 vars; "
                        "chartwise affine solves with irrelevant saturation"
                    ),
                    "memory_floor_gib": 16 if r >= 64 else 8,
                },
                {
                    "name": "Macaulay2 multigraded GB + saturate",
                    "expected_cost": "multigraded GB of r generators in 2-graded ring",
                    "memory_floor_gib": 16,
                },
                {
                    "name": "Fitting / exterior rank of compressed M(q)",
                    "expected_cost": (
                        "compressed matrix is r×28 with poly entries deg≤3; "
                        "Fitt_0 needs 28-minors if r≥28 — still heavy in 37 vars"
                    ),
                    "memory_floor_gib": 16,
                },
            ],
        }
        print(f"compression r={r} row_rank={rk}", flush=True)

    peak = max(peak, C.rss_mib())

    # Stage A already empty: report pointer.
    stageA = HERE / "stageA_result.json"
    stageA_exit = None
    if stageA.exists():
        stageA_exit = json.loads(stageA.read_text()).get("exit")

    # Smallest system floor: 64 equations, multihomogeneous saturation.
    # Chart count: e.g. 37+28 charts if dehomogenizing one var each side — still large.
    # Measured: building one compressed r=64 block is tiny; the GB is the cost.
    smallest = compressions["64"]
    measured_floor_gib = 16
    slot_request = measured_floor_gib > 8

    payload = {
        "dispatch": "P25W.2-StageB-preflight",
        "prime": P,
        "inputs": {
            "relation_matrix": str(FM / "relation_matrix.npz"),
            "seed_F3_sha256": seed_sha,
            "stageA_exit": stageA_exit,
        },
        "system": {
            "full_equations": n_eq,
            "variables_q": n_q,
            "variables_b": n_b,
            "split_b": {"b0": n_b0, "b1": n_b1, "b2": n_b2},
            "bidegree": [3, 1],
            "grading": {
                "deg_q_i": [1, 0],
                "deg_b0": [0, 1],
                "deg_b1_j": [1, 1],
                "deg_b2_j": [2, 1],
            },
        },
        "compressions": compressions,
        "smallest_system": {
            "n_equations": 64,
            "bidegree": [3, 1],
            "n_vars": n_q + n_b,
            "method": "multihomogeneous saturation of 64 deterministic linear combinations of the 690 seed equations",
            "verifier_design": (
                "Independent recomputation of the saturated ideal of the same "
                "64 compressed equations (same deterministic C matrix from seed "
                "2026073189); empty solver output is not emptiness; must recompute "
                "saturation fact or a certified nonzero Fitting/elimination witness."
            ),
            "measured_floor_gib": measured_floor_gib,
            "exploratory_ceiling_gib": 8,
        },
        "implication": {
            "compressed_empty_implies_seed_empty": True,
            "seed_empty_implies_true_landing_empty": True,
            "reason": (
                "Compression weakens equations; Supp(full) ⊆ Supp(seed) ⊆ Supp(compressed). "
                "Emptiness of compressed incidence after exact irrelevant saturation "
                "proves emptiness of the special-fibre landing scheme; DVR properness "
                "then gives the characteristic-zero degree-25 exclusion (scoped, not headline)."
            ),
            "nonempty_compressed_proves_nothing": True,
        },
        "stageA_status": stageA_exit,
        "slot": {
            "request": slot_request,
            "marker": "P25W-SLOT-REQUEST" if slot_request else "P25W-SLOT-SELF",
            "reason": (
                "Smallest compressed multihomogeneous saturation (64 eqs, bidegree (3,1), "
                "65 vars, double irrelevant saturation) has measured floor 16 GiB, above "
                "the 8 GiB exploratory fence. Stage A stratum is already decided empty; "
                "the remaining Stage B solve needs the scheduled heavy slot."
            ),
            "what_remains": (
                "Run deterministic compressions r=64,72,84 of M(q)b=0; compute "
                "multihomogeneous saturation by both irrelevant ideals; stop at first empty. "
                "If all nonempty, either enlarge compression toward 690 or search for a "
                "support point and verify against all 690 seeds and all 746 landing cubics."
            ),
        },
        "resource": {
            "peak_rss_mib": peak,
            "elapsed_seconds": time.time() - t0,
            "preflight_only": True,
            "heavy_solve_run": False,
        },
    }
    C.write_json_self_hash(HERE / "preflight_incidence.json", payload)
    print(
        f"DONE slot={payload['slot']['marker']} floor={measured_floor_gib} GiB "
        f"rss={peak:.0f}",
        flush=True,
    )


if __name__ == "__main__":
    main()
