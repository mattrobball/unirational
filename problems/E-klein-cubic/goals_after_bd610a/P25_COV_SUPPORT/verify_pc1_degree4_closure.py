#!/usr/bin/env python3
"""Independent replay of the PC.1 pure-q degree-four closure over F_89.

This verifier does not import the producer and does not use its stored quotient
matrices as inputs.  It reconstructs W, every transition and commutator row,
and the canonical quotient by the W-projection of the independently certified
PC.0 multiplication kernel.  Exact sparse modular elimination written here
then recomputes row-rank profiles before the stored artifact is opened and
compared array by array.

The result is only a degree-four statement over F_89.  In particular, this is
not a stabilization, higher-degree, representation-character, or support
certificate.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
from typing import Iterable

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FINITE_MODULE = ROOT / "certificates" / "degree25_finite_module"
RELATION = FINITE_MODULE / "relation_matrix.npz"
MULTIPLICATION = FINITE_MODULE / "multiplication_matrices.npz"
PC0_CERTIFICATE = HERE / "pc0_rank_certificate.json"
PC0_KERNEL = HERE / "pc0_multiplication_kernel.npz"
PRODUCER_RESULT = HERE / "pc1_degree4_closure.json"
PRODUCER_ARTIFACT = HERE / "pc1_degree4_closure.npz"
OUTPUT = HERE / "verify_pc1_degree4_result.json"

P = 89
NQ = 37
NSEED = 690
NW = 56
NV = NSEED + NW
NOPERATORS = 6
NQUADRATICS = 21
FORMAL_DIMENSION = NQ * NW
TRANSITION_ROWS = NOPERATORS * NSEED
COMMUTATOR_ROWS = 15 * NQUADRATICS


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 22):
            digest.update(chunk)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def packed_row_keys(matrix: np.ndarray) -> np.ndarray:
    matrix = np.ascontiguousarray(matrix)
    row_type = np.dtype((np.void, matrix.dtype.itemsize * matrix.shape[1]))
    return matrix.view(row_type).ravel()


def canonical_row_reduction(matrix: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    """Return the unique reduced row echelon basis and its pivot columns."""

    reduced = np.ascontiguousarray(matrix, dtype=np.int64) % P
    row = 0
    pivots: list[int] = []
    for column in range(reduced.shape[1]):
        candidates = np.flatnonzero(reduced[row:, column])
        if not len(candidates):
            continue
        source = row + int(candidates[0])
        if source != row:
            reduced[[row, source]] = reduced[[source, row]]
        reduced[row] *= pow(int(reduced[row, column]), -1, P)
        reduced[row] %= P
        factors = reduced[:, column].copy()
        factors[row] = 0
        active = np.flatnonzero(factors)
        if len(active):
            reduced[active] = (
                reduced[active]
                - factors[active, None] * reduced[row][None, :]
            ) % P
        pivots.append(column)
        row += 1
        if row == reduced.shape[0]:
            break
    return (
        np.ascontiguousarray(reduced[:row], dtype=np.uint8),
        np.asarray(pivots, dtype=np.int32),
    )


def quotient_normal_forms(
    rows: np.ndarray, kernel_rref: np.ndarray, kernel_pivots: np.ndarray
) -> tuple[np.ndarray, np.ndarray]:
    """Reduce rows by the canonical kernel rules and delete pivot columns."""

    normal = np.ascontiguousarray(rows, dtype=np.int64) % P
    for rule, pivot in zip(kernel_rref, kernel_pivots, strict=True):
        factors = normal[:, int(pivot)].copy()
        active = np.flatnonzero(factors)
        for target in active:
            normal[target] = (
                normal[target] - int(factors[target]) * rule.astype(np.int64)
            ) % P
    pivot_set = set(map(int, kernel_pivots))
    nonpivots = np.asarray(
        [column for column in range(FORMAL_DIMENSION) if column not in pivot_set],
        dtype=np.int32,
    )
    assert not np.any(normal[:, kernel_pivots])
    return np.ascontiguousarray(normal[:, nonpivots], dtype=np.uint8), nonpivots


SparseBasis = dict[int, dict[int, int]]


def reduce_sparse_row(row: np.ndarray, basis: SparseBasis) -> dict[int, int]:
    """Reduce one row exactly against a normalized sparse echelon basis."""

    current = {int(index): int(row[index]) for index in np.flatnonzero(row)}
    while current:
        pivot = min(current)
        reducer = basis.get(pivot)
        if reducer is None:
            break
        coefficient = current[pivot]
        for column, value in reducer.items():
            new_value = (current.get(column, 0) - coefficient * value) % P
            if new_value:
                current[column] = new_value
            else:
                current.pop(column, None)
    return current


def exact_sparse_row_profile(matrix: np.ndarray) -> tuple[np.ndarray, SparseBasis]:
    """Compute the lexicographic row-rank profile by exact F_89 elimination."""

    basis: SparseBasis = {}
    profile: list[int] = []
    for row_index, row in enumerate(matrix):
        remainder = reduce_sparse_row(row, basis)
        if not remainder:
            continue
        pivot = min(remainder)
        inverse = pow(remainder[pivot], -1, P)
        if inverse != 1:
            remainder = {
                column: (value * inverse) % P
                for column, value in remainder.items()
            }
        assert remainder[pivot] == 1 and pivot not in basis
        basis[pivot] = remainder
        profile.append(row_index)
    return np.asarray(profile, dtype=np.int32), basis


def rows_contained_in_basis(rows: Iterable[np.ndarray], basis: SparseBasis) -> bool:
    return all(not reduce_sparse_row(row, basis) for row in rows)


def reconstruct_sources() -> dict[str, np.ndarray | list[tuple[int, int, int]]]:
    """Rebuild all degree-four formal rows from the sealed source tensors."""

    with np.load(RELATION, allow_pickle=False) as frozen:
        assert int(frozen["prime"]) == P
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
    with np.load(MULTIPLICATION, allow_pickle=False) as frozen:
        assert int(frozen["prime"]) == P
        tquad = frozen["T_quad_F3"].astype(np.uint8)

    v0 = np.ascontiguousarray(seeds[:, offsets[0] : offsets[1]], dtype=np.uint8)
    tail = np.ascontiguousarray(
        tquad[:, :, offsets[0] : offsets[1]].reshape(
            NOPERATORS * NQUADRATICS, -1
        ),
        dtype=np.uint8,
    )
    w = np.ascontiguousarray(np.unique(tail, axis=0), dtype=np.uint8)
    assert v0.shape[0] == NSEED and w.shape[0] == NW

    w_lookup = {
        bytes(key): index for index, key in enumerate(packed_row_keys(w))
    }
    tail_to_w = np.zeros((len(tail), NW), dtype=np.uint8)
    for row, key in enumerate(packed_row_keys(tail)):
        tail_to_w[row, w_lookup[bytes(key)]] = 1
    assert np.array_equal(tail_to_w.astype(np.int64) @ w.astype(np.int64) % P, tail)
    tail_to_w = tail_to_w.reshape(NOPERATORS, NQUADRATICS, NW)

    quadratic_blocks = np.stack(
        [
            seeds[:, offsets[7 + block] : offsets[8 + block]]
            for block in range(NQUADRATICS)
        ],
        axis=1,
    ).astype(np.uint8)
    transition_blocks = []
    for operator in range(NOPERATORS):
        block = (
            quadratic_blocks.transpose(0, 2, 1).astype(np.int64)
            @ tail_to_w[operator].astype(np.int64)
        ) % P
        transition_blocks.append(
            np.ascontiguousarray(block.reshape(NSEED, FORMAL_DIMENSION), dtype=np.uint8)
        )
    transitions = np.ascontiguousarray(np.vstack(transition_blocks), dtype=np.uint8)
    assert transitions.shape == (TRANSITION_ROWS, FORMAL_DIMENSION)

    quadratic_action = np.empty(
        (NOPERATORS, NQUADRATICS, NQUADRATICS, NQ), dtype=np.uint8
    )
    for operator in range(NOPERATORS):
        for source in range(NQUADRATICS):
            for target in range(NQUADRATICS):
                quadratic_action[operator, source, target] = tquad[
                    operator,
                    source,
                    offsets[7 + target] : offsets[8 + target],
                ]

    commutator_rows: list[np.ndarray] = []
    commutator_labels: list[tuple[int, int, int]] = []
    for left in range(NOPERATORS):
        for right in range(left + 1, NOPERATORS):
            for source in range(NQUADRATICS):
                left_after_right = (
                    quadratic_action[right, source].T.astype(np.int64)
                    @ tail_to_w[left].astype(np.int64)
                )
                right_after_left = (
                    quadratic_action[left, source].T.astype(np.int64)
                    @ tail_to_w[right].astype(np.int64)
                )
                commutator_rows.append(
                    np.ascontiguousarray(
                        (left_after_right - right_after_left) % P,
                        dtype=np.uint8,
                    ).reshape(-1)
                )
                commutator_labels.append((left, right, source))
    commutators = np.ascontiguousarray(np.vstack(commutator_rows), dtype=np.uint8)
    assert commutators.shape == (COMMUTATOR_ROWS, FORMAL_DIMENSION)

    return {
        "v0": v0,
        "w": w,
        "tail_to_w": tail_to_w,
        "transitions": transitions,
        "commutators": commutators,
        "commutator_labels": commutator_labels,
    }


def assert_json_ledger(
    producer: dict[str, object],
    transition_profile: np.ndarray,
    commutator_profile: np.ndarray,
    block_ranks: list[int],
    cumulative_ranks: list[int],
    selected_labels: np.ndarray,
    transition_quotient: np.ndarray,
    commutator_quotient: np.ndarray,
    kernel_pivots: np.ndarray,
    quotient_nonpivots: np.ndarray,
) -> None:
    assert producer["status"] == "PC1-DEGREE4-CLOSURE-PASS"
    assert producer["prime"] == P
    assert producer["old_degree4_rank"] == 25530
    assert producer["multiplication_kernel_dimension"] == 19
    assert producer["formal_missing_tensor_dimension"] == FORMAL_DIMENSION
    assert producer["actual_new_quotient_dimension"] == len(quotient_nonpivots)
    assert producer["new_degree4_rank"] == 27583
    assert producer["transition_rows"] == TRANSITION_ROWS
    assert producer["transition_syzygy_dimension_in_quotient"] == (
        TRANSITION_ROWS - len(transition_profile)
    )
    assert producer["transition_block_ranks_mod_old"] == block_ranks
    assert producer["transition_cumulative_ranks_mod_old"] == cumulative_ranks
    assert producer["minimal_transition_generators"] == len(transition_profile)
    assert producer["minimal_transition_labels_sha256"] == sha256_array(selected_labels)
    assert producer["commutator_rows"] == COMMUTATOR_ROWS
    assert producer["commutator_rank_mod_old"] == len(commutator_profile)
    assert producer["commutator_syzygy_dimension_mod_old"] == (
        COMMUTATOR_ROWS - len(commutator_profile)
    )
    assert producer["commutators_add_directions"] == 0
    assert producer["individual_transition_memberships_old"] == 0
    assert producer["individual_commutator_memberships_old"] == 0
    assert producer["normal_form"]["kernel_pivot_columns"] == kernel_pivots.tolist()
    assert producer["normal_form"]["quotient_basis_dimension"] == len(
        quotient_nonpivots
    )
    assert producer["transition_quotient_sha256"] == sha256_array(
        transition_quotient
    )
    assert producer["commutator_quotient_sha256"] == sha256_array(
        commutator_quotient
    )


def main() -> None:
    pc0 = json.loads(PC0_CERTIFICATE.read_text())
    producer = json.loads(PRODUCER_RESULT.read_text())
    assert pc0["status"] == "PC0-INDEPENDENT-RANK-REPLICATION-PASS"
    assert pc0["prime"] == P
    assert pc0["multiplication_map"]["kernel_dimension"] == 19
    assert pc0["multiplication_map"]["quotient_image_dimension"] == 2053

    relation_key = str(RELATION.relative_to(ROOT))
    multiplication_key = str(MULTIPLICATION.relative_to(ROOT))
    input_hashes = {
        relation_key: sha256_file(RELATION),
        multiplication_key: sha256_file(MULTIPLICATION),
        PC0_KERNEL.name: sha256_file(PC0_KERNEL),
        PC0_CERTIFICATE.name: sha256_file(PC0_CERTIFICATE),
    }
    assert input_hashes[relation_key] == pc0["inputs"][relation_key]
    assert input_hashes[multiplication_key] == pc0["inputs"][multiplication_key]
    assert input_hashes[PC0_KERNEL.name] == pc0["multiplication_map"][
        "kernel_basis_file_sha256"
    ]
    assert producer["inputs"] == input_hashes

    rebuilt = reconstruct_sources()
    v0 = rebuilt["v0"]
    w = rebuilt["w"]
    tail_to_w = rebuilt["tail_to_w"]
    transitions = rebuilt["transitions"]
    commutators = rebuilt["commutators"]
    commutator_labels = rebuilt["commutator_labels"]
    assert isinstance(v0, np.ndarray)
    assert isinstance(w, np.ndarray)
    assert isinstance(tail_to_w, np.ndarray)
    assert isinstance(transitions, np.ndarray)
    assert isinstance(commutators, np.ndarray)
    assert isinstance(commutator_labels, list)
    _w_rref, w_pivots = canonical_row_reduction(w)
    assert len(w_pivots) == pc0["cubic_ledger"]["rank_W"] == NW
    assert sha256_array(np.vstack([v0, w])) == pc0["cubic_ledger"][
        "V0_plus_W_sha256"
    ]
    transition_source_sha = sha256_array(transitions)
    commutator_source_sha = sha256_array(commutators)
    assert transition_source_sha == pc0["transition_subspaces"][
        "transition_matrix_sha256"
    ]
    assert commutator_source_sha == pc0["transition_subspaces"][
        "commutator_matrix_sha256"
    ]

    with np.load(PC0_KERNEL, allow_pickle=False) as frozen:
        assert int(frozen["prime"]) == P
        kernel = frozen["kernel"].astype(np.uint8)
        assert int(frozen["full_residual_nonzero"]) == 0
    assert kernel.shape == (NQ * NV, 19)
    assert sha256_array(kernel) == pc0["multiplication_map"]["kernel_basis_sha256"]
    kernel_w_rows = np.ascontiguousarray(
        kernel.reshape(NQ, NV, 19)[:, NSEED:].reshape(FORMAL_DIMENSION, 19).T,
        dtype=np.uint8,
    )
    kernel_rref, kernel_pivots = canonical_row_reduction(kernel_w_rows)
    assert kernel_rref.shape == (19, FORMAL_DIMENSION)
    assert len(kernel_pivots) == 19

    transition_quotient, quotient_nonpivots = quotient_normal_forms(
        transitions, kernel_rref, kernel_pivots
    )
    commutator_quotient, quotient_nonpivots_again = quotient_normal_forms(
        commutators, kernel_rref, kernel_pivots
    )
    assert np.array_equal(quotient_nonpivots, quotient_nonpivots_again)
    assert len(quotient_nonpivots) == 2053
    assert not np.any(~np.any(transition_quotient, axis=1))
    assert not np.any(~np.any(commutator_quotient, axis=1))

    print("exact sparse transition row-profile replay", flush=True)
    transition_profile, transition_basis = exact_sparse_row_profile(
        transition_quotient
    )
    assert len(transition_profile) == 2053
    block_ranks = []
    for operator in range(NOPERATORS):
        start = operator * NSEED
        stop = start + NSEED
        block_profile, _ = exact_sparse_row_profile(transition_quotient[start:stop])
        block_ranks.append(len(block_profile))
    cumulative_ranks = [
        int(np.count_nonzero(transition_profile < (operator + 1) * NSEED))
        for operator in range(NOPERATORS)
    ]
    assert block_ranks == [690, 690, 690, 690, 690, 690]
    assert cumulative_ranks == [690, 1332, 1702, 1923, 2031, 2053]

    print("exact sparse commutator row-profile replay", flush=True)
    commutator_profile, _commutator_basis = exact_sparse_row_profile(
        commutator_quotient
    )
    assert len(commutator_profile) == 210
    assert rows_contained_in_basis(commutator_quotient, transition_basis)

    selected_labels = np.column_stack(
        [transition_profile // NSEED, transition_profile % NSEED]
    ).astype(np.int32)
    all_commutator_labels = np.asarray(commutator_labels, dtype=np.int16)
    assert_json_ledger(
        producer,
        transition_profile,
        commutator_profile,
        block_ranks,
        cumulative_ranks,
        selected_labels,
        transition_quotient,
        commutator_quotient,
        kernel_pivots,
        quotient_nonpivots,
    )

    # Only now open the producer artifact.  Every load-bearing array above was
    # reconstructed and ranked before this comparison.
    assert sha256_file(PRODUCER_ARTIFACT) == producer["artifact_sha256"]
    with np.load(PRODUCER_ARTIFACT, allow_pickle=False) as artifact:
        assert set(artifact.files) == {
            "prime",
            "kernel_w_rref",
            "kernel_w_pivots",
            "quotient_nonpivot_columns",
            "transition_quotient",
            "commutator_quotient",
            "transition_basis_rows",
            "transition_basis_labels",
            "commutator_basis_rows",
            "commutator_labels",
        }
        assert int(artifact["prime"]) == P
        comparisons = {
            "kernel_w_rref": kernel_rref,
            "kernel_w_pivots": kernel_pivots,
            "quotient_nonpivot_columns": quotient_nonpivots,
            "transition_quotient": transition_quotient,
            "commutator_quotient": commutator_quotient,
            "transition_basis_rows": transition_profile,
            "transition_basis_labels": selected_labels,
            "commutator_basis_rows": commutator_profile,
            "commutator_labels": all_commutator_labels,
        }
        for name, independently_rebuilt in comparisons.items():
            assert np.array_equal(artifact[name], independently_rebuilt), name

    result = {
        "status": "PASS_INDEPENDENT_PC1_DEGREE4_REPLAY",
        "ok": True,
        "prime": P,
        "inputs": input_hashes,
        "source_reconstruction": {
            "W_rows": len(w),
            "W_rank": len(w_pivots),
            "W_sha256": sha256_array(w),
            "tail_to_W_sha256": sha256_array(tail_to_w),
            "transition_rows": len(transitions),
            "transition_formal_sha256": transition_source_sha,
            "commutator_rows": len(commutators),
            "commutator_formal_sha256": commutator_source_sha,
            "kernel_W_projection_rank": len(kernel_pivots),
            "kernel_W_projection_sha256": sha256_array(kernel_w_rows),
        },
        "normal_form": {
            "kernel_pivot_columns": kernel_pivots.tolist(),
            "kernel_rref_sha256": sha256_array(kernel_rref),
            "quotient_nonpivot_columns_sha256": sha256_array(
                quotient_nonpivots
            ),
            "quotient_dimension": len(quotient_nonpivots),
        },
        "transition_quotient": {
            "rank": len(transition_profile),
            "syzygy_dimension": TRANSITION_ROWS - len(transition_profile),
            "block_ranks": block_ranks,
            "cumulative_ranks": cumulative_ranks,
            "row_profile_sha256": sha256_array(transition_profile),
            "selected_labels_sha256": sha256_array(selected_labels),
            "matrix_sha256": sha256_array(transition_quotient),
            "zero_rows": int(np.count_nonzero(~np.any(transition_quotient, axis=1))),
        },
        "commutator_quotient": {
            "rank": len(commutator_profile),
            "syzygy_dimension": COMMUTATOR_ROWS - len(commutator_profile),
            "row_profile_sha256": sha256_array(commutator_profile),
            "matrix_sha256": sha256_array(commutator_quotient),
            "zero_rows": int(np.count_nonzero(~np.any(commutator_quotient, axis=1))),
            "directions_added_to_transition_span": 0,
        },
        "degree4_rank_ledger": {
            "old_S1_V0_rank": 25530,
            "new_quotient_rank": len(transition_profile),
            "closed_degree4_rank": 25530 + len(transition_profile),
        },
        "producer_artifact_sha256": sha256_file(PRODUCER_ARTIFACT),
        "all_producer_arrays_match": True,
        "all_producer_ledger_fields_match": True,
        "rank_backend": (
            "independent pure-Python sparse Gaussian elimination over F_89; "
            "no producer import and no FFLAS row-profile call"
        ),
        "theorem_boundary": {
            "proves": (
                "Exactly over F_89, the pure-q degree-four quotient by S1 V0 "
                "has dimension 2053; the lexicographic minimal transition basis "
                "has 2053 rows; the 315 commutators have quotient rank 210 and "
                "add no direction."
            ),
            "does_not_prove": (
                "Coupled-module closure in degree five or above, stabilization "
                "or regularity, representation characters, projective support, "
                "or any characteristic-zero statement."
            ),
        },
    }
    OUTPUT.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS_INDEPENDENT_PC1_DEGREE4_REPLAY", flush=True)


if __name__ == "__main__":
    main()
