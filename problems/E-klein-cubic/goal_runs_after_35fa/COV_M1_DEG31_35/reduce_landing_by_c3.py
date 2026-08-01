#!/usr/bin/env python3
"""Restrict the complete p=463 landing circuits to the C3/C6 gate kernel.

The output remains factored: for each unisolvent source node it stores the
five reduced linear forms whose Klein cubic is one complete landing equation.
It also records the two exact C3 strata: zero restriction, and the complement
covered by the displayed scalar-form coordinates.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PRIME = 463
EXPECTED = {31: (198, 187, 10, 177), 35: (361, 348, 12, 336)}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def rref_kernel(matrix: np.ndarray, prime: int):
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    row = 0
    pivots = []
    for column in range(value.shape[1]):
        candidates = np.flatnonzero(value[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
        factors = value[:, column].copy()
        indices = np.flatnonzero(factors)
        indices = indices[indices != row]
        if len(indices):
            value[indices] = (
                value[indices] - factors[indices, None] * value[row]
            ) % prime
        pivots.append(column)
        row += 1
        if row == value.shape[0]:
            break
    free = [column for column in range(value.shape[1]) if column not in pivots]
    kernel = np.zeros((value.shape[1], len(free)), dtype=np.int64)
    kernel[free, np.arange(len(free))] = 1
    if pivots:
        kernel[np.asarray(pivots)] = -value[:len(pivots), free] % prime
    return np.asarray(pivots), np.asarray(free), kernel % prime


def rank_mod(matrix: np.ndarray, prime: int) -> int:
    value = np.asarray(matrix, dtype=np.int64).copy() % prime
    row = 0
    for column in range(value.shape[1]):
        candidates = np.flatnonzero(value[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        value[[row, pivot]] = value[[pivot, row]]
        value[row] = value[row] * pow(int(value[row, column]), -1, prime) % prime
        factors = value[:, column].copy()
        indices = np.flatnonzero(factors)
        indices = indices[indices != row]
        if len(indices):
            value[indices] = (
                value[indices] - factors[indices, None] * value[row]
            ) % prime
        row += 1
        if row == value.shape[0]:
            break
    return row


def restrict_forms(forms: np.ndarray, pivots: np.ndarray, free: np.ndarray,
                   kernel: np.ndarray, prime: int) -> np.ndarray:
    answer = np.empty((len(forms), len(free)), dtype=np.uint16)
    pivot_part = kernel[pivots]
    for start in range(0, len(forms), 2048):
        stop = min(start + 2048, len(forms))
        block = forms[start:stop].astype(np.int64)
        reduced = block[:, free]
        if len(pivots):
            reduced = reduced + block[:, pivots] @ pivot_part
        answer[start:stop] = (reduced % prime).astype(np.uint16)
    return answer


def main() -> None:
    aggregate = {
        "schema": "cov-m1-c3-reduced-complete-landing-v1",
        "prime": PRIME,
        "scope": (
            "complete p=463 landing equations after the necessary C3/C6 "
            "linear gate; projective emptiness is not asserted"
        ),
        "degrees": {},
    }
    for degree, (dimension, reduced_dimension, scalar_rank,
                 based_dimension) in EXPECTED.items():
        gate_path = HERE / f"degree_{degree}/c3_constant_gate_p{PRIME}.npz"
        landing_path = HERE / f"degree_{degree}/landing_circuits_p{PRIME}.npz"
        with np.load(gate_path, allow_pickle=False) as frozen:
            gate = frozen["gate_matrix"].astype(np.int64)
            line_values = frozen["basis_values"].astype(np.int64)
            root = frozen["unique_c6_root"].astype(np.int64)
        pivots, free, kernel = rref_kernel(gate, PRIME)
        assert len(free) == reduced_dimension
        assert not np.any(gate @ kernel % PRIME)
        with np.load(landing_path, allow_pickle=False) as frozen:
            points = frozen["fixed_source_points"].copy()
            values = frozen["basis_values"].astype(np.uint16)
        assert values.shape[2] == dimension
        reduced_forms = restrict_forms(
            values.reshape(-1, dimension), pivots, free, kernel, PRIME
        ).reshape(values.shape[0], 5, reduced_dimension)
        del values
        # The circuit nodes see every reduced parameter direction.
        form_rank = rank_mod(
            reduced_forms.reshape(-1, reduced_dimension)[:2 * reduced_dimension],
            PRIME,
        )
        assert form_rank == reduced_dimension
        line_reduced = restrict_forms(
            line_values.reshape(-1, dimension), pivots, free, kernel, PRIME
        ).reshape(line_values.shape[0], 5, reduced_dimension)
        root_pivot = int(np.flatnonzero(root)[0])
        scalar_forms = (
            pow(int(root[root_pivot]), -1, PRIME)
            * line_reduced[:, root_pivot, :].astype(np.int64)
        ) % PRIME
        assert all(
            np.array_equal(
                line_reduced[:, target, :].astype(np.int64) % PRIME,
                root[target] * scalar_forms % PRIME,
            )
            for target in range(5)
        )
        assert rank_mod(scalar_forms, PRIME) == scalar_rank
        scalar_pivots, scalar_free, based_kernel = rref_kernel(
            scalar_forms, PRIME
        )
        assert len(scalar_free) == based_dimension
        assert not np.any(scalar_forms @ based_kernel % PRIME)
        payload_path = HERE / f"degree_{degree}/c3_reduced_landing_p{PRIME}.npz"
        np.savez_compressed(
            payload_path,
            source_points=points,
            reduced_basis_values=reduced_forms,
            c3_kernel_basis=kernel.astype(np.uint16),
            c3_pivot_columns=pivots.astype(np.uint16),
            c3_free_columns=free.astype(np.uint16),
            c3_scalar_forms=scalar_forms.astype(np.uint16),
            based_kernel_basis=based_kernel.astype(np.uint16),
            scalar_pivot_columns=scalar_pivots.astype(np.uint16),
            scalar_free_columns=scalar_free.astype(np.uint16),
        )
        record = {
            "prime": PRIME,
            "original_parameter_dimension": dimension,
            "c3_gate_rank": dimension - reduced_dimension,
            "reduced_parameter_dimension": reduced_dimension,
            "complete_equation_count": int(len(points)),
            "factored_linear_form_shape": list(reduced_forms.shape),
            "factored_linear_form_rank": form_rank,
            "c3_scalar_form_rank": scalar_rank,
            "based_restriction_zero_dimension": based_dimension,
            "nonbased_chart_count": scalar_rank,
            "nonbased_cover": (
                "the complement of the based stratum is covered by normalizing "
                "one of the displayed independent scalar-form coordinates"
            ),
            "gate_payload": str(gate_path.relative_to(HERE)),
            "gate_payload_sha256": sha256(gate_path),
            "landing_payload": str(landing_path.relative_to(HERE)),
            "landing_payload_sha256": sha256(landing_path),
            "payload": str(payload_path.relative_to(HERE)),
            "payload_sha256": sha256(payload_path),
            "decision_status": "complete reduced equations; saturation open",
        }
        metadata_path = HERE / f"degree_{degree}/c3_reduced_landing_p{PRIME}.json"
        metadata_path.write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
        aggregate["degrees"][str(degree)] = {
            "metadata": str(metadata_path.relative_to(HERE)),
            "metadata_sha256": sha256(metadata_path),
            **record,
        }
        print(
            f"d={degree}: {len(points)} cubics on {reduced_dimension}; "
            f"based={based_dimension}, nonbased charts={scalar_rank}",
            flush=True,
        )
    aggregate_path = HERE / "c3_reduced_landing.json"
    aggregate_path.write_text(json.dumps(aggregate, indent=2, sort_keys=True) + "\n")
    print("COV_M1_C3_REDUCED_LANDING_OK")


if __name__ == "__main__":
    main()
