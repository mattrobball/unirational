#!/usr/bin/env python3
"""Intersect P25 branch A with the strict 43-dimensional coefficient space."""

from __future__ import annotations

import argparse
import contextlib
import io
import sys
from pathlib import Path

import numpy as np

import produce_cross_basis as basis
import probe_c3_constant_gate as c3
from probe_cubic_scalar_cubes import cubic_coefficients, independent_rows
from produce_canonical_bases import rank_profile
from verify_all import rank_mod_ffpack_int32


HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]
P25_EXACT = E_ROOT / "certificates/degree25_exact"
sys.path.insert(0, str(P25_EXACT))
import common_p25x as p25  # noqa: E402


PRIMES = {199: 61, 331: 270}
DEGREE = 25


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, choices=PRIMES, default=199)
    parser.add_argument("--samples", type=int, default=1600)
    args = parser.parse_args()
    prime = args.prime
    zeta = PRIMES[prime]
    c3.P = prime
    c3.ZETA = zeta
    module = basis.module_at(prime, zeta)
    seed_data = p25.load_seeds()
    seeds = [
        module.ReynoldsSeed(int(record["output"]), tuple(record["exponents"]))
        for record in seed_data
    ]
    with np.load(
        P25_EXACT / "covariant_basis/basis43_multiprime.npz",
        allow_pickle=False,
    ) as frozen:
        basis43 = frozen[f"basis43_p{prime}"].astype(np.int64) % prime
    assert basis43.shape == (43, 189)

    _, _, eigenspaces, _, _, fixed_roots = c3.c3_geometry(module)
    source_points = c3.line_points(eigenspaces[1], DEGREE)
    reynolds = p25.batch_seed_evaluations(
        module, seeds, source_points, prime
    ).reshape(len(source_points), 5, 189)
    values = np.einsum("psw,bw->psb", reynolds, basis43) % prime
    root = fixed_roots[DEGREE % 3][0]
    gate = c3.landing_constant_matrix(values, root)
    gate_rank = c3.rank_mod(gate, prime)
    kernel = c3.nullspace_mod(gate, prime).T
    restricted = np.einsum("pjn,nk->pjk", values, kernel) % prime
    pivot = int(np.flatnonzero(root)[0])
    scalar = (
        pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :]
    ) % prime
    assert all(np.array_equal(
        restricted[:, output, :] % prime,
        root[output] * scalar % prime,
    ) for output in range(5))
    scalar_rows = independent_rows(scalar, prime)
    print(
        f"p={prime}: strict=43 C3-gate-rank={gate_rank} "
        f"branch={kernel.shape[1]} scalar-rank={len(scalar_rows)}",
        flush=True,
    )

    rng = np.random.default_rng(20260731 + prime)
    landing_points = rng.integers(
        0, prime, size=(args.samples, 5), dtype=np.int64
    )
    reynolds = p25.batch_seed_evaluations(
        module, seeds, landing_points, prime
    ).reshape(args.samples, 5, 189)
    strict_values = np.einsum("psw,bw->psb", reynolds, basis43) % prime
    branch_values = np.einsum(
        "pjn,nk->pjk", strict_values, kernel
    ) % prime
    with contextlib.redirect_stdout(io.StringIO()):
        monomials, coefficients = cubic_coefficients(
            branch_values, prime, chunk=32
        )
    landing_rank = rank_mod_ffpack_int32(coefficients, prime)
    rows = rank_profile(
        "RowRankProfile_modular_double", coefficients, prime
    )
    assert len(rows) == landing_rank
    output = HERE / f"p25_strict_branch_a_p{prime}.npz"
    np.savez_compressed(
        output,
        source_points=source_points.astype(np.uint16),
        strict_c3_basis_values=values.astype(np.uint16),
        strict_c3_gate=gate.astype(np.uint16),
        strict_branch_kernel=kernel.astype(np.uint16),
        strict_c3_reduced_values=restricted.astype(np.uint16),
        leading_target_root=root.astype(np.uint16),
        independent_scalar_forms=scalar[scalar_rows].astype(np.uint16),
        landing_sample_points=landing_points.astype(np.uint16),
        reduced_basis_values=branch_values.astype(np.uint16),
        cubic_monomials=monomials.astype(np.uint16),
        landing_cubic_coefficients=coefficients[rows],
        landing_fixed_row_profile=rows.astype(np.uint16),
    )
    print(
        f"p={prime}: restricted landing rank={landing_rank}/"
        f"{len(monomials)}; wrote {output.name} ({output.stat().st_size} bytes)",
        flush=True,
    )


if __name__ == "__main__":
    main()
