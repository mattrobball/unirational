#!/usr/bin/env python3
"""Assemble the two-prime strict localization of residual P25 branch A."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np

from probe_c3_constant_gate import rank_mod
from verify_all import rank_mod_ffpack_int32


HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]
PRIMES = {199: 61, 331: 270}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    records = []
    for prime, zeta in PRIMES.items():
        path = HERE / f"p25_strict_branch_a_p{prime}.npz"
        with np.load(path, allow_pickle=False) as frozen:
            assert frozen["strict_c3_basis_values"].shape == (26, 5, 43)
            gate = frozen["strict_c3_gate"].astype(np.int64)
            kernel = frozen["strict_branch_kernel"].astype(np.int64)
            scalars = frozen["independent_scalar_forms"].astype(np.int64)
            monomials = frozen["cubic_monomials"]
            cubics = frozen["landing_cubic_coefficients"].astype(np.int64)
            sample_points = frozen["landing_sample_points"]
        assert gate.shape == (104, 43) and rank_mod(gate, prime) == 6
        assert kernel.shape == (43, 37) and not np.any(gate @ kernel % prime)
        assert scalars.shape == (5, 37) and rank_mod(scalars, prime) == 5
        assert monomials.shape == (9139, 3)
        assert cubics.shape == (716, 9139)
        assert rank_mod_ffpack_int32(cubics, prime) == 716
        assert sample_points.shape == (1600, 5)
        records.append({
            "prime": prime,
            "zeta11": zeta,
            "strict_dimension": 43,
            "c3_gate_rank": 6,
            "strict_branch_dimension": 37,
            "leading_scalar_rank": 5,
            "landing_sample_count": 1600,
            "restricted_landing_cubic_rank": 716,
            "restricted_cubic_monomial_count": 9139,
            "payload": path.name,
            "payload_sha256": sha256(path),
        })
    basis_path = (
        E_ROOT / "certificates/degree25_exact/covariant_basis/"
        "basis43_multiprime.npz"
    )
    landing_path = E_ROOT / "certificates/degree25_exact/landing_cubics.npz"
    seeds_path = E_ROOT / "tmp/degree25_structural_probe/seeds.json"
    output = HERE / "p25_strict_branch_a.json"
    output.write_text(json.dumps({
        "schema": "cov-m1-p25-strict-branch-a-v1",
        "source_strict_basis": str(basis_path.relative_to(E_ROOT)),
        "source_strict_basis_sha256": sha256(basis_path),
        "source_landing_sample_basis": str(landing_path.relative_to(E_ROOT)),
        "source_landing_sample_basis_sha256": sha256(landing_path),
        "source_reynolds_seeds": str(seeds_path.relative_to(E_ROOT)),
        "source_reynolds_seeds_sha256": sha256(seeds_path),
        "prime_records": records,
        "conclusion": (
            "imposing the binding common-line order-two strict equalizer "
            "reduces common P25 branch A from the 51-dimensional arrangement "
            "upper bound to dimension at most 37 in characteristic zero; its "
            "leading scalar cover has rank five"
        ),
        "scope": (
            "fixed-circuit two-prime linear localization plus exact modular "
            "sample landing spans; the 716 sampled cubics are a necessary "
            "subsystem, and no normalized affine chart or projective branch "
            "is declared empty"
        ),
    }, indent=2, sort_keys=True) + "\n")
    print("P25_STRICT_BRANCH_A_TWO_PRIME_LOCALIZATION_OK")


if __name__ == "__main__":
    main()
