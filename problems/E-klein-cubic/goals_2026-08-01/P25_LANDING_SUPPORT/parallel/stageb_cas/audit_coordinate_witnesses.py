#!/usr/bin/env python3
"""Find exact coordinate-point witnesses for contracted Stage-B subsystems.

At q=e_i, the cubic matrix A(q) is just the coefficient matrix of q_i^3.
If its rank is below six, an explicit nonzero b in its nullspace proves that
the corresponding contracted incidence (and its correct projective
saturation) is nonempty.  This is a statement about the contraction
subsystem only, not a landing candidate.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
P = 89


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def rref_and_nullspace(raw: np.ndarray) -> tuple[int, list[list[int]]]:
    matrix = raw.astype(np.int64) % P
    rows, columns = matrix.shape
    pivot_columns: list[int] = []
    pivot_row = 0
    for column in range(columns):
        candidates = np.flatnonzero(matrix[pivot_row:, column])
        if candidates.size == 0:
            continue
        selected = pivot_row + int(candidates[0])
        matrix[[pivot_row, selected]] = matrix[[selected, pivot_row]]
        matrix[pivot_row] = (
            matrix[pivot_row] * pow(int(matrix[pivot_row, column]), -1, P)
        ) % P
        factors = matrix[:, column].copy()
        factors[pivot_row] = 0
        nonzero_rows = np.flatnonzero(factors)
        if nonzero_rows.size:
            matrix[nonzero_rows] = (
                matrix[nonzero_rows]
                - factors[nonzero_rows, None] * matrix[pivot_row, None, :]
            ) % P
        pivot_columns.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    free = [column for column in range(columns) if column not in pivot_columns]
    basis: list[list[int]] = []
    for free_column in free:
        vector = np.zeros(columns, dtype=np.int64)
        vector[free_column] = 1
        for row, pivot_column in enumerate(pivot_columns):
            vector[pivot_column] = -matrix[row, free_column] % P
        if np.any((raw.astype(np.int64) @ vector) % P):
            raise RuntimeError("nullspace check failed")
        basis.append(vector.astype(int).tolist())
    return len(pivot_columns), basis


def main() -> None:
    monomials = weak_compositions(3, 37)
    index = {monomial: i for i, monomial in enumerate(monomials)}
    with np.load(P25 / "linear_syzygies_r48_reconstructed.npz") as frozen:
        syzygy_packets = {
            48: frozen["syzygies"].astype(np.uint8),
            96: frozen["old_syzygies"].astype(np.uint8),
        }
    with np.load(P25 / "linear_syzygies.npz") as frozen:
        syzygy_packets[256] = frozen["syzygies"].astype(np.uint8)
    records = []
    for rows in (48, 96, 256):
        source = P25 / f"syzygy_r{rows}_q0_contracted.npz"
        with np.load(source) as frozen:
            p3 = frozen["p3"].astype(np.uint8)
            if int(frozen["prime"]) != P:
                raise RuntimeError("wrong prime")
        ranks: list[int] = []
        witnesses = []
        syzygies = syzygy_packets[rows]
        active = np.any(syzygies != 0, axis=(0, 1))
        inactive = np.flatnonzero(~active).astype(int).tolist()
        stacked_rank, stacked_kernel = rref_and_nullspace(
            syzygies.reshape(-1, 37)
        )
        family = None
        if inactive:
            restricted_indices = [
                monomial_index
                for monomial_index, exponent in enumerate(monomials)
                if all(exponent[i] == 0 for i in range(37) if i not in inactive)
            ]
            restricted_zero = not np.any(p3[:, :, restricted_indices])
            if not restricted_zero:
                raise RuntimeError("inactive-syzygy subspace did not kill contractions")
            family = {
                "q_linear_subspace_basis_coordinates": inactive,
                "q_projective_dimension": len(inactive) - 1,
                "all_b_are_solutions": True,
                "restricted_cubic_coefficients_checked": len(restricted_indices),
                "restricted_contractions_all_zero": True,
            }
        for variable in range(37):
            exponent = [0] * 37
            exponent[variable] = 3
            evaluated = p3[:, :, index[tuple(exponent)]]
            rank, kernel = rref_and_nullspace(evaluated)
            ranks.append(rank)
            if kernel:
                b = kernel[0]
                if np.any((evaluated.astype(np.int64) @ np.asarray(b)) % P):
                    raise RuntimeError("witness evaluation failed")
                witnesses.append(
                    {
                        "q_coordinate": variable,
                        "q": [1 if i == variable else 0 for i in range(37)],
                        "matrix_rank": rank,
                        "kernel_dimension": 6 - rank,
                        "b": b,
                        "all_contracted_equations_zero": True,
                    }
                )
        records.append(
            {
                "rows": rows,
                "source": str(source),
                "source_sha256": sha256(source),
                "coordinate_ranks": ranks,
                "deficient_coordinate_points": witnesses,
                "coordinate_witness_count": len(witnesses),
                "stacked_syzygy_q_map_rank": stacked_rank,
                "stacked_syzygy_q_map_kernel_basis": stacked_kernel,
                "inactive_q_coordinates": inactive,
                "positive_dimensional_coordinate_family": family,
            }
        )
    payload = {
        "prime": P,
        "records": records,
        "interpretation": (
            "Each listed q,b is a nonzero exact point of that contracted Stage-B "
            "subsystem, so its projective saturation cannot be the unit ideal. "
            "It need not satisfy the 690 original equations."
        ),
    }
    target = HERE / "coordinate_witnesses.json"
    target.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
