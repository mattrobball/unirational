#!/usr/bin/env python3
"""P25X.1 independent verifier.

Does not import produce_p25x1.py. Recomputes a sample landing rank at one
holdout prime and checks JSON/array consistency and residual-gap honesty.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import common_p25x as C  # noqa: E402

OUT = HERE


def load_json(name: str) -> dict:
    return json.loads((OUT / name).read_text())


def main() -> None:
    errors: list[str] = []
    exit_payload = load_json("exit_p25x1.json")
    landing = load_json("landing_cubics.json")
    rowspace = load_json("rowspace_comparison.json")
    border = load_json("equivalence_to_border.json")

    # Honesty checks
    if border.get("row_ideal_containment_both_directions_over_K") is True:
        errors.append("border claims both-way containment — not established")
    if rowspace.get("rank_842_rowspaces_recovered_as_historical_object") is True:
        errors.append("claims 842 recovery — not established")
    if "residual_gap" not in border:
        errors.append("missing residual_gap in equivalence_to_border")

    # Files
    for rel in (
        "LANDING_IDEAL.md",
        "landing_cubics.npz",
        "landing_cubics.json",
        "rowspace_comparison.json",
        "equivalence_to_border.json",
        "exit_p25x1.json",
    ):
        if not (OUT / rel).exists():
            errors.append(f"missing {rel}")

    # Recompute small sample rank at p=89 and compare to stored
    p, z = 89, 78
    print(f"recompute landing sample at p={p}", flush=True)
    recon = C.load_reconstructor()
    seed_data = C.load_seeds()
    module = recon.load_module(p, z)
    seeds = [
        module.ReynoldsSeed(int(r["output"]), tuple(r["exponents"]))
        for r in seed_data
    ]
    g, plus, minus = C.involution_eigenspaces(module, p)
    ker = C.arrangement_kernel(module, seeds, plus, p)
    strict, sr, _ = C.strict_from_arrangement(module, seeds, ker, p)
    basis43, _ = C.monic_basis_reynolds(sr, p)

    rng = np.random.default_rng(99)
    n = 400
    points = rng.integers(0, p, size=(n, 5), dtype=np.int64)
    R = C.batch_seed_evaluations(module, seeds, points, p).reshape(n, 5, C.MOLIEN_DIM)
    vals = np.einsum("nsw,bw->nbs", R, basis43) % p
    echelon: list = []
    for i in range(n):
        row = C.fast_cubic_row(vals[i], p)
        C.add_echelon_row(echelon, row, p)
    sample_rank = len(echelon)
    stored_rank = None
    for pr in landing.get("primes", []):
        if pr["prime"] == p:
            stored_rank = pr["landing_rank"]
    if stored_rank is None:
        errors.append("no stored rank at p=89")
    elif sample_rank > stored_rank:
        errors.append(
            f"verifier sample rank {sample_rank} exceeds stored {stored_rank}"
        )
    # sample_rank with fewer samples should be ≤ stored
    if stored_rank is not None and sample_rank < 1:
        errors.append("verifier got zero landing rank")

    # Stored npz row spaces
    npz = OUT / "landing_cubics.npz"
    if npz.exists():
        with np.load(npz) as zfile:
            if "p89" not in zfile.files:
                errors.append("landing_cubics.npz missing p89")
            else:
                mat = zfile["p89"]
                if mat.ndim != 2 or mat.shape[1] != C.CUBIC_MONOM_DIM:
                    errors.append(f"p89 landing shape {mat.shape}")
                elif mat.shape[0] != stored_rank:
                    errors.append(
                        f"p89 rows {mat.shape[0]} != stored rank {stored_rank}"
                    )
                # check monic echelon-ish: pivot columns unique
                rk = C.rank_mod(mat, p)
                if rk != mat.shape[0]:
                    errors.append(f"stored p89 not full row rank ({rk})")

    # Exit consistency: if PASS claimed, 842 must be recovered
    if exit_payload.get("exit") == "P25X1-PASS":
        if not rowspace.get("rank_842_rowspaces_recovered_as_historical_object"):
            errors.append("PASS claimed without 842 recovery")
        if border.get("row_ideal_containment_both_directions_over_K"):
            pass  # ok if true
        elif "residual_gap" not in border:
            errors.append("PASS without border containment or gap")

    if errors:
        print("P25X1_VERIFY_FAIL")
        for e in errors:
            print(" ", e)
        sys.exit(1)

    print("P25X1_VERIFY_OK")
    print(f"  p=89 stored_rank={stored_rank} verifier_sample_rank={sample_rank}")
    print(f"  exit={exit_payload.get('exit')} residual_gap recorded")
    print(f"  rss={C.rss_mib():.1f} MiB")


if __name__ == "__main__":
    main()
