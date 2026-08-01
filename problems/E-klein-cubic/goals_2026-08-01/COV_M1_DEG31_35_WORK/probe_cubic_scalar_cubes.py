#!/usr/bin/env python3
"""Build exact cubic-span matrices for recursive nonbased C3 charts.

The first target is the degree-31 pure third-normal gate.  If the cube of
each independent scalar form lies in the span of the complete landing
cubics, all corresponding normalization charts are empty.
"""

from __future__ import annotations

import argparse
import itertools
from pathlib import Path
import struct

import numpy as np

import combine_c3_third_normal_gate as third
import probe_c3_constant_gate as c3


HERE = Path(__file__).resolve().parent


def cubic_monomials(variables: int) -> np.ndarray:
    return np.asarray(
        list(itertools.combinations_with_replacement(range(variables), 3)),
        dtype=np.int64,
    )


def cubic_coefficients(values: np.ndarray, prime: int, chunk: int = 32) -> tuple[np.ndarray, np.ndarray]:
    """Expand sum_i L_i^2 L_{i+1}, using the three monomial multiplicity types."""
    variables = values.shape[2]
    monomials = cubic_monomials(variables)
    left, middle, right = monomials.T
    all_equal = (left == right)
    left_pair = (left == middle) & (middle != right)
    right_pair = (left != middle) & (middle == right)
    distinct = (left != middle) & (middle != right)
    answer = np.empty((len(values), len(monomials)), dtype=np.uint16)
    for start in range(0, len(values), chunk):
        stop = min(start + chunk, len(values))
        block = values[start:stop].astype(np.int64)
        coefficients = np.zeros((stop - start, len(monomials)), dtype=np.int64)
        for target in range(5):
            a = block[:, target]
            b = block[:, (target + 1) % 5]
            coefficients[:, all_equal] += (
                a[:, left[all_equal]] ** 2 * b[:, left[all_equal]]
            )
            coefficients[:, left_pair] += (
                a[:, left[left_pair]] ** 2 * b[:, right[left_pair]]
                + 2 * a[:, left[left_pair]] * a[:, right[left_pair]] * b[:, left[left_pair]]
            )
            coefficients[:, right_pair] += (
                a[:, right[right_pair]] ** 2 * b[:, left[right_pair]]
                + 2 * a[:, left[right_pair]] * a[:, right[right_pair]] * b[:, right[right_pair]]
            )
            coefficients[:, distinct] += 2 * (
                a[:, left[distinct]] * a[:, middle[distinct]] * b[:, right[distinct]]
                + a[:, left[distinct]] * a[:, right[distinct]] * b[:, middle[distinct]]
                + a[:, middle[distinct]] * a[:, right[distinct]] * b[:, left[distinct]]
            )
        answer[start:stop] = (coefficients % prime).astype(np.uint16)
        print(f"expanded landing rows {start}:{stop}", flush=True)
    return monomials, answer


def cube_coefficients(forms: np.ndarray, monomials: np.ndarray, prime: int) -> np.ndarray:
    left, middle, right = monomials.T
    answer = (
        forms[:, left] * forms[:, middle] % prime * forms[:, right] % prime
    )
    answer[:, (left == middle) & (middle != right)] *= 3
    answer[:, (left != middle) & (middle == right)] *= 3
    answer[:, (left != middle) & (middle != right)] *= 6
    return (answer % prime).astype(np.uint16)


def independent_rows(matrix: np.ndarray, prime: int) -> np.ndarray:
    chosen: list[int] = []
    current = np.empty((0, matrix.shape[1]), dtype=np.int64)
    for row in range(len(matrix)):
        candidate = np.vstack([current, matrix[row]])
        if c3.rank_mod(candidate, prime) > len(chosen):
            chosen.append(row)
            current = candidate
    return np.asarray(chosen, dtype=np.int64)


def degree31_third_pure(prime: int) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    dimension = 198
    gate = third.lower_matrix(31, prime, dimension)
    values = []
    roots = []
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_31/c3_third_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            gate = np.concatenate([
                gate, frozen["extra_gate_matrix"].astype(np.int64)
            ]) % prime
            values.append(frozen["third_normal_values"].astype(np.int64))
            roots.append(frozen["target_root"].astype(np.int64))
    assert c3.rank_mod(gate, prime) == 162
    kernel = c3.nullspace_mod(gate, prime).T
    assert kernel.shape == (dimension, 36)
    scalar_blocks = []
    for block, root in zip(values, roots):
        restricted = np.einsum("pjn,nk->pjk", block, kernel) % prime
        pivot = int(np.flatnonzero(root)[0])
        scalar_blocks.append(
            pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
        )
    scalars = np.concatenate(scalar_blocks) % prime
    selected = independent_rows(scalars, prime)
    assert len(selected) == 6
    with np.load(
        HERE / f"degree_31/landing_circuits_p{prime}.npz", allow_pickle=False
    ) as frozen:
        old_values = frozen["basis_values"].astype(np.int64)
    reduced = np.einsum("pjn,nk->pjk", old_values, kernel) % prime
    return kernel, scalars[selected], reduced


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    parser.add_argument("--case", choices=("d31-third-pure",), default="d31-third-pure")
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    kernel, scalar_forms, reduced_values = degree31_third_pure(prime)
    monomials, landing = cubic_coefficients(reduced_values, prime)
    targets = cube_coefficients(scalar_forms, monomials, prime)

    stem = HERE / f"degree_31/d31_third_pure_scalar_cubes_p{prime}"
    np.savez_compressed(
        stem.with_suffix(".npz"),
        gate_kernel_basis=kernel.astype(np.uint16),
        independent_scalar_forms=scalar_forms.astype(np.uint16),
        reduced_basis_values=reduced_values.astype(np.uint16),
        cubic_monomials=monomials.astype(np.uint16),
        landing_cubic_coefficients=landing,
        scalar_cube_coefficients=targets,
    )
    with stem.with_suffix(".bin").open("wb") as output:
        output.write(struct.pack("<QQQ", len(landing), landing.shape[1], prime))
        output.write(landing.tobytes(order="C"))
        output.write(struct.pack("<Q", len(targets)))
        output.write(targets.tobytes(order="C"))
    print(
        f"wrote {stem.name}: landing={landing.shape} targets={targets.shape}",
        flush=True,
    )


if __name__ == "__main__":
    main()
