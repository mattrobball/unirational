#!/usr/bin/env python3
"""Identify the two common nonbased P25 branches in degrees 31 and 35."""

from __future__ import annotations

import contextlib
import hashlib
import io
import json
from pathlib import Path

import numpy as np

from combine_c3_first_normal_nonbased_tangent_gate import klein_gradient
from probe_c3_constant_gate import nullspace_mod, rank_mod
from probe_cubic_scalar_cubes import cubic_coefficients, independent_rows
from produce_canonical_bases import rank_profile
from verify_all import rank_mod_ffpack_int32


HERE = Path(__file__).resolve().parent
PRIMES = (463, 727)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def first_paths(degree: int, prime: int) -> list[Path]:
    paths = [HERE / f"degree_{degree}/c3_first_normal_exp0_p{prime}.npz"]
    if degree == 31:
        paths.append(HERE / f"degree_31/c3_first_normal_exp2_p{prime}.npz")
    else:
        paths.extend([
            HERE / f"degree_35/c3_first_normal_exp2_dir0_p{prime}.npz",
            HERE / f"degree_35/c3_first_normal_exp2_dir1_p{prime}.npz",
        ])
    return paths


def first_tangent_gate(degree: int, dimension: int, prime: int):
    with np.load(
        HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        parts = [frozen["basis_values"].astype(np.int64).reshape(-1, dimension)]
    paths = first_paths(degree, prime)
    for path in paths:
        with np.load(path, allow_pickle=False) as frozen:
            parts.append(frozen["extra_gate_matrix"].astype(np.int64))
    leading_path = paths[1] if degree == 31 else paths[0]
    with np.load(leading_path, allow_pickle=False) as frozen:
        leading = frozen["derivative_values"].astype(np.int64)
        root = frozen["target_root"].astype(np.int64)
    gradient = klein_gradient(root, prime)
    values = []
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            values.append(frozen["second_normal_values"].astype(np.int64))
    with np.load(
        HERE / f"degree_{degree}/c3_second_mixed_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        values.append(frozen["mixed_second_values"].astype(np.int64))
    parts.extend([
        np.einsum("i,pin->pn", gradient, block) % prime for block in values
    ])
    return np.concatenate(parts) % prime, leading, root


def scalar_forms(values: np.ndarray, root: np.ndarray,
                 target_kernel: np.ndarray, prime: int) -> np.ndarray:
    restricted = np.einsum("pjn,nk->pjk", values, target_kernel) % prime
    pivot = int(np.flatnonzero(root)[0])
    scalar = (
        pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :]
    ) % prime
    assert all(np.array_equal(
        restricted[:, output, :] % prime,
        root[output] * scalar % prime,
    ) for output in range(5))
    return scalar


def main() -> None:
    prime_records = []
    canonical = {}
    for prime in PRIMES:
        embeddings = {
            degree: np.load(
                HERE / f"degree_{degree}/p25_multiplier_embedding_p{prime}.npz",
                allow_pickle=False,
            )["multiplier_embedding"].astype(np.int64) % prime
            for degree in (31, 35)
        }
        c31 = embeddings[31]
        c35 = embeddings[35]

        with np.load(
            HERE / f"degree_31/c3_constant_gate_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            a31_gate = frozen["gate_matrix"].astype(np.int64)
            a31_values = frozen["basis_values"].astype(np.int64)
            a31_root = frozen["unique_c6_root"].astype(np.int64)
        a31 = nullspace_mod(a31_gate @ c31 % prime, prime).T
        a35_gate, a35_values, a35_root = first_tangent_gate(35, 361, prime)
        a35 = nullspace_mod(a35_gate @ c35 % prime, prime).T
        assert a31.shape == a35.shape == (59, 51)
        assert rank_mod(np.column_stack([a31, a35]), prime) == 51

        b31_gate, b31_values, b31_root = first_tangent_gate(31, 198, prime)
        b31 = nullspace_mod(b31_gate @ c31 % prime, prime).T
        with np.load(
            HERE / f"degree_35/c3_second_mixed_nonbased_tangent_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            b35_gate = np.concatenate([
                frozen["base_gate_matrix"].astype(np.int64),
                frozen["tangent_gate_matrix"].astype(np.int64),
            ]) % prime
        b35 = nullspace_mod(b35_gate @ c35 % prime, prime).T
        with np.load(
            HERE / f"degree_35/c3_second_mixed_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            b35_values = frozen["mixed_second_values"].astype(np.int64)
            b35_root = frozen["target_root"].astype(np.int64)
        assert b31.shape == b35.shape == (59, 20)
        assert rank_mod(np.column_stack([b31, b35]), prime) == 20

        a31_scalar = scalar_forms(a31_values, a31_root, c31 @ a31, prime)
        a35_scalar = scalar_forms(a35_values, a35_root, c35 @ a31, prime)
        b31_scalar = scalar_forms(b31_values, b31_root, c31 @ b31, prime)
        b35_scalar = scalar_forms(b35_values, b35_root, c35 @ b31, prime)
        assert (rank_mod(a31_scalar, prime), rank_mod(a35_scalar, prime),
                rank_mod(np.vstack([a31_scalar, a35_scalar]), prime)) == (5, 5, 5)
        assert (rank_mod(b31_scalar, prime), rank_mod(b35_scalar, prime),
                rank_mod(np.vstack([b31_scalar, b35_scalar]), prime)) == (7, 7, 7)
        a_selected = independent_rows(a31_scalar, prime)
        b_selected = independent_rows(b31_scalar, prime)
        assert len(a_selected) == 5 and len(b_selected) == 7
        prime_records.append({
            "prime": prime,
            "branch_A_dimension": 51,
            "branch_A_scalar_rank": 5,
            "branch_A_cross_degree_union_rank": 51,
            "branch_A_scalar_union_rank": 5,
            "branch_B_dimension": 20,
            "branch_B_scalar_rank": 7,
            "branch_B_cross_degree_union_rank": 20,
            "branch_B_scalar_union_rank": 7,
        })
        canonical[prime] = {
            "A": a31,
            "A_scalars": a31_scalar[a_selected],
            "B": b31,
            "B_scalars": b31_scalar[b_selected],
            "C31": c31,
            "C35": c35,
        }
        print(f"p={prime}: A=51/scalar5, B=20/scalar7 cross-degree OK")

    prime = 463
    data = canonical[prime]
    b_coefficients = {}
    reduced_values = {}
    monomials = None
    for degree in (31, 35):
        with np.load(
            HERE / f"degree_{degree}/landing_circuits_p463.npz",
            allow_pickle=False,
        ) as frozen:
            old_values = frozen["basis_values"].astype(np.int64)
        reduced = np.einsum(
            "pjn,nk->pjk", old_values,
            data[f"C{degree}"] @ data["B"] % prime,
        ) % prime
        with contextlib.redirect_stdout(io.StringIO()):
            degree_monomials, coefficients = cubic_coefficients(
                reduced, prime, chunk=64
            )
        if monomials is None:
            monomials = degree_monomials
        else:
            assert np.array_equal(monomials, degree_monomials)
        b_coefficients[degree] = coefficients
        reduced_values[degree] = reduced
    ranks = {
        degree: rank_mod_ffpack_int32(matrix, prime)
        for degree, matrix in b_coefficients.items()
    }
    union_rank = rank_mod_ffpack_int32(
        np.vstack([b_coefficients[31], b_coefficients[35]]), prime
    )
    assert ranks == {31: 574, 35: 574} and union_rank == 574
    rows = rank_profile(
        "RowRankProfile_modular_double", b_coefficients[31], prime
    )
    assert len(rows) == 574
    payload_path = HERE / "p25_common_nonbased_branches_p463.npz"
    np.savez_compressed(
        payload_path,
        branch_A_degree25_kernel=data["A"].astype(np.uint16),
        branch_A_scalar_forms=data["A_scalars"].astype(np.uint16),
        branch_B_degree25_kernel=data["B"].astype(np.uint16),
        branch_B_scalar_forms=data["B_scalars"].astype(np.uint16),
        branch_B_d31_target_kernel=(data["C31"] @ data["B"] % prime).astype(np.uint16),
        branch_B_d35_target_kernel=(data["C35"] @ data["B"] % prime).astype(np.uint16),
        d31_reduced_basis_values=reduced_values[31].astype(np.uint16),
        d35_reduced_basis_values=reduced_values[35].astype(np.uint16),
        cubic_monomials=monomials.astype(np.uint16),
        d31_cubic_coefficients=b_coefficients[31],
        d35_cubic_coefficients=b_coefficients[35],
        d31_fixed_row_profile=rows.astype(np.uint16),
    )
    output = HERE / "p25_common_nonbased_branches.json"
    output.write_text(json.dumps({
        "schema": "cov-m1-p25-common-nonbased-branches-v1",
        "prime_records": prime_records,
        "branch_A": {
            "dimension": 51,
            "scalar_rank": 5,
            "degree_31_realization": "C3-constant nonbased",
            "degree_35_realization": "first-normal nonbased after tangent",
        },
        "branch_B": {
            "dimension": 20,
            "scalar_rank": 7,
            "degree_31_realization": "first-normal nonbased after tangent",
            "degree_35_realization": "mixed-second nonbased after tangent",
            "cubic_monomial_count": 1540,
            "d31_cubic_span_rank": 574,
            "d35_cubic_span_rank": 574,
            "cross_degree_cubic_union_rank": 574,
            "fixed_row_profile_length": 574,
        },
        "payload": payload_path.name,
        "payload_sha256": sha256(payload_path),
        "scope": (
            "two intrinsic fixed-circuit P25 nonbased branches identified in "
            "the degree-31 and degree-35 multiplier trees; their affine scalar "
            "chart saturations remain undecided"
        ),
    }, indent=2, sort_keys=True) + "\n")
    print("P25_COMMON_NONBASED_BRANCHES_OK")


if __name__ == "__main__":
    main()
