#!/usr/bin/env python3
"""Compute the exact full landing-cubic rank on residual P25 branch A."""

from __future__ import annotations

import contextlib
import io
from pathlib import Path

import numpy as np

from probe_cubic_scalar_cubes import cubic_coefficients
from produce_canonical_bases import rank_profile
from verify_all import rank_mod_ffpack_int32


HERE = Path(__file__).resolve().parent
PRIME = 463


def main() -> None:
    with np.load(
        HERE / "p25_common_nonbased_branches_p463.npz",
        allow_pickle=False,
    ) as frozen:
        degree25_kernel = frozen["branch_A_degree25_kernel"].astype(np.int64)
    with np.load(
        HERE / "degree_31/p25_multiplier_embedding_p463.npz",
        allow_pickle=False,
    ) as frozen:
        embedding = frozen["multiplier_embedding"].astype(np.int64)
    with np.load(
        HERE / "degree_31/landing_circuits_p463.npz",
        allow_pickle=False,
    ) as frozen:
        basis_values = frozen["basis_values"].astype(np.int64)

    target_kernel = embedding @ degree25_kernel % PRIME
    assert target_kernel.shape == (198, 51)
    reduced = np.einsum(
        "pjn,nk->pjk", basis_values, target_kernel
    ) % PRIME
    print(f"reduced values: {reduced.shape}", flush=True)
    with contextlib.redirect_stdout(io.StringIO()):
        monomials, coefficients = cubic_coefficients(
            reduced, PRIME, chunk=16
        )
    assert monomials.shape == (23426, 3)
    assert coefficients.shape == (5349, 23426)
    print(f"cubic coefficient matrix: {coefficients.shape}", flush=True)
    rank = rank_mod_ffpack_int32(coefficients, PRIME)
    print(f"P25_BRANCH_A_CUBIC_RANK={rank}", flush=True)
    rows = rank_profile(
        "RowRankProfile_modular_double", coefficients, PRIME
    )
    assert len(rows) == rank
    output = HERE / "p25_branch_a_cubic_span_p463.npz"
    np.savez_compressed(
        output,
        degree25_kernel=degree25_kernel.astype(np.uint16),
        target_kernel=target_kernel.astype(np.uint16),
        reduced_basis_values=reduced.astype(np.uint16),
        cubic_monomials=monomials.astype(np.uint16),
        fixed_row_profile=rows.astype(np.uint16),
        independent_cubic_coefficients=coefficients[rows],
    )
    print(f"wrote {output} ({output.stat().st_size} bytes)", flush=True)


if __name__ == "__main__":
    main()
