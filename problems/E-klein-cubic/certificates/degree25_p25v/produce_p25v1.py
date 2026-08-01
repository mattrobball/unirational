#!/usr/bin/env python3
"""P25V.1 — assemble compressed-incidence exit from stored compressions and solver logs.

Does not claim emptiness from empty solver output alone. Records deterministic
compression matrices (seed 2026073189), Stage A inheritance, and either an
accepted certificate form or a precise UNDECIDED blocker.
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
TMP = ROOT / "tmp" / "p25v_incidence"
HERE.mkdir(parents=True, exist_ok=True)
TMP.mkdir(parents=True, exist_ok=True)

sys.path.insert(0, str(EXACT))
import common_p25x as C  # noqa: E402

P = 89
SEED_RNG = 2026073189


def main() -> None:
    t0 = time.time()
    peak = C.rss_mib()
    print("=== P25V.1 assemble ===", flush=True)

    rel = np.load(FM / "relation_matrix.npz")
    seed_sha = C.sha256_arr(rel["seed_F3"])

    compressions = {}
    for r in (28, 32, 40, 64, 72, 84):
        path = TMP / f"compression_r{r}.npz"
        if not path.exists():
            continue
        z = np.load(path)
        compressions[str(r)] = {
            "n_equations": r,
            "C_shape": list(z["C"].shape),
            "C_sha256": C.sha256_arr(z["C"]),
            "compressed_sha256": C.sha256_arr(z["compressed"]),
            "seed_rng": SEED_RNG,
            "path": str(path),
        }
        print(f"r={r} C_sha={compressions[str(r)]['C_sha256'][:16]}...", flush=True)

    # Parse msolve logs for F4 progress (not certificates)
    solver_notes = {}
    for name in ("msolve_b0_1_solve.log", "msolve_r28.log", "msolve_b0_1_gb.log"):
        p = TMP / name
        if p.exists():
            text = p.read_text(errors="replace")
            solver_notes[name] = {
                "bytes": p.stat().st_size,
                "tail": text[-1500:],
                "has_unit_basis": ("length of basis:      1 element" in text and "\n1\n" in text),
                "output_file_exists": (TMP / name.replace(".log", ".out")).exists()
                or (TMP / "msolve_b0_1_solve.out").exists()
                or (TMP / "msolve_r28.out").exists(),
            }

    # Check for accepted emptiness outputs
    empty_cert = None
    for out_name in ("msolve_b0_1_solve.out", "msolve_r28.out", "sat_r64_result.json"):
        op = TMP / out_name
        if not op.exists() or op.stat().st_size == 0:
            continue
        text = op.read_text(errors="replace")
        if text.strip().startswith("[-1]") or '"is_unit_saturated": true' in text:
            empty_cert = {"file": str(op), "form": "solver_report", "preview": text[:500]}
            break

    if empty_cert is None:
        exit_code = "P25V-SUPPORT-UNDECIDED"
        blocker = {
            "last_completed_invariant": (
                "Deterministic compressions stored for r∈{28,32,40,64} with published seed "
                "2026073189; Stage A empty; specialized rank(M(q))=28 on 200 random q (discovery only)"
            ),
            "matrix_algebra_dimensions": {
                "compressed_r64": "64 eqs, bidegree (3,1), 65 multiprojective vars / 63 affine chart",
                "msolve_r64_deg5_matrix": "56949 × 1828991 (2.48% dens), 1593 new basis elems",
                "msolve_r28_deg5_matrix": "25232 × 1832458 (1.93% dens), 336 new",
            },
            "observed_rss": {
                "r64_active_approx_gib": 40,
                "r28_active_approx_gib": 21,
                "budget_gib": 64,
            },
            "smallest_reformulation": (
                "M2 multihomogeneous saturate(I, qideal*bideal) on r=64 matrix form; "
                "or FittingIdeal(0, coker M) saturated by q-irrelevant; "
                "or chartwise msolve with higher wall budget after deg-6 F4 completes"
            ),
            "headline_capable": True,
            "reason": (
                "msolve F4 on affine charts climbs past degree 5 with multi-million-column "
                "Macaulay matrices; no accepted emptiness certificate (saturated unit ideal / "
                "irrelevant-power containment / Nullstellensatz identity) was obtained before "
                "dispatch wall. Empty solver output is not emptiness. Route remains valid."
            ),
        }
    else:
        exit_code = "P25-DEGREE25-EMPTY"
        blocker = None

    payload = {
        "dispatch": "P25V.1",
        "exit": exit_code,
        "prime": P,
        "compression_seed_rng": SEED_RNG,
        "order_attempted": [64, 72, 84],
        "also_tried_weaker": [28, 32, 40],
        "compressions": compressions,
        "stageA": "P25W-STAGEA-EMPTY",
        "implication": {
            "compressed_empty_implies_seed_empty": True,
            "seed_empty_implies_true_landing_empty": True,
            "dvr_gives_char0_degree25_exclusion": True,
            "scoped_not_headline": True,
            "nonempty_compressed_proves_nothing": True,
        },
        "empty_certificate": empty_cert,
        "blocker": blocker,
        "solver_notes": {k: {kk: vv for kk, vv in v.items() if kk != "tail"} for k, v in solver_notes.items()},
        "inputs": {
            "seed_F3_sha256": seed_sha,
            "relation_matrix": str(FM / "relation_matrix.npz"),
        },
        "resource": {
            "peak_rss_mib_assemble": peak,
            "elapsed_seconds": time.time() - t0,
            "budget_gib": 64,
            "preflight_floor_gib": 16,
        },
        "theorem": {
            "proves": (
                "None beyond setup: compressions and Stage A inheritance are recorded. "
                if exit_code.endswith("UNDECIDED")
                else "Compressed incidence empty after saturation ⇒ seed incidence empty "
                "⇒ p=89 landing empty ⇒ char-0 degree-25 exclusion (scoped)."
            ),
            "does_not_prove": (
                "Full kernel-incidence emptiness (no accepted certificate yet); "
                "any char-0 row rank; presentation exactness (see P25V.0 ENLARGED)."
            ),
            "scope": "F_89 special fibre; lower presentation N_0.",
        },
    }
    C.write_json_self_hash(HERE / "exit_p25v1.json", payload)
    print(f"DONE exit={exit_code}", flush=True)


if __name__ == "__main__":
    main()
