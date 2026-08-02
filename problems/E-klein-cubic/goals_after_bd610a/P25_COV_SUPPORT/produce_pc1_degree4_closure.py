#!/usr/bin/env python3
"""PC.1 partial: canonical degree-four quotient and generator ledger.

This computes the actual polynomial quotient S1(V0+W)/S1V0 using the PC.0
kernel, reduces all transition and commutator classes to canonical quotient
normal forms, and selects a minimal 2,053-row transition basis.  It does not
claim stabilization of the coupled module in higher degree.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FM = ROOT / "certificates" / "degree25_finite_module"
RELATION = FM / "relation_matrix.npz"
MULTIPLICATION = FM / "multiplication_matrices.npz"
KERNEL = HERE / "pc0_multiplication_kernel.npz"
PC0 = HERE / "pc0_rank_certificate.json"
P = 89
NQ, NSEED, NW, NV = 37, 690, 56, 746
NK, NQUAD = 6, 21
FORMAL = NQ * NW


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 22):
            digest.update(chunk)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def rank_and_profile(matrix: np.ndarray) -> tuple[int, np.ndarray]:
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.RowRankProfile_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_size_t)),
        ctypes.c_int,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    pointer = ctypes.POINTER(ctypes.c_size_t)()
    rows, columns = dense.shape
    rank = int(
        function(
            float(P), rows, columns, dense, columns, ctypes.byref(pointer), 1, False
        )
    )
    profile = np.ctypeslib.as_array(pointer, shape=(rank,)).copy().astype(np.int32)
    return rank, profile


def rref_rows(matrix: np.ndarray) -> tuple[np.ndarray, np.ndarray]:
    a = np.ascontiguousarray(matrix, dtype=np.int64) % P
    pivots: list[int] = []
    row = 0
    for column in range(a.shape[1]):
        candidates = np.flatnonzero(a[row:, column])
        if not len(candidates):
            continue
        pivot = row + int(candidates[0])
        if pivot != row:
            a[[row, pivot]] = a[[pivot, row]]
        a[row] = a[row] * pow(int(a[row, column]), -1, P) % P
        factors = a[:, column].copy()
        factors[row] = 0
        for target in np.flatnonzero(factors):
            a[target] = (a[target] - int(factors[target]) * a[row]) % P
        pivots.append(column)
        row += 1
        if row == a.shape[0]:
            break
    return a[:row].astype(np.uint8), np.asarray(pivots, dtype=np.int32)


def quotient_coordinates(
    rows: np.ndarray, kernel_rref: np.ndarray, pivots: np.ndarray
) -> tuple[np.ndarray, np.ndarray]:
    reduced = np.ascontiguousarray(rows, dtype=np.int64) % P
    for index, pivot in enumerate(pivots):
        factors = reduced[:, int(pivot)].copy()
        active = np.flatnonzero(factors)
        for target in active:
            reduced[target] = (
                reduced[target]
                - int(factors[target]) * kernel_rref[index].astype(np.int64)
            ) % P
    nonpivots = np.asarray(
        [column for column in range(FORMAL) if column not in set(map(int, pivots))],
        dtype=np.int32,
    )
    return np.ascontiguousarray(reduced[:, nonpivots], dtype=np.uint8), nonpivots


def main() -> None:
    pc0 = json.loads(PC0.read_text())
    assert pc0["multiplication_map"]["kernel_dimension"] == 19
    assert pc0["multiplication_map"]["quotient_image_dimension"] == 2053
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        assert int(frozen["prime"]) == P
    with np.load(MULTIPLICATION, allow_pickle=False) as frozen:
        tquad = frozen["T_quad_F3"].astype(np.uint8)
        assert int(frozen["prime"]) == P
    with np.load(KERNEL, allow_pickle=False) as frozen:
        kernel = frozen["kernel"].astype(np.uint8)
        assert int(frozen["prime"]) == P

    tq0 = np.ascontiguousarray(tquad[:, :, offsets[0] : offsets[1]].reshape(126, -1))
    w = np.unique(tq0, axis=0)
    key_type = np.dtype((np.void, w.dtype.itemsize * w.shape[1]))
    w_keys = np.ascontiguousarray(w).view(key_type).ravel()
    lookup = {bytes(key): index for index, key in enumerate(w_keys)}
    tq_w = np.zeros((126, NW), dtype=np.uint8)
    for row, key in enumerate(np.ascontiguousarray(tq0).view(key_type).ravel()):
        tq_w[row, lookup[bytes(key)]] = 1
    tq_w = tq_w.reshape(NK, NQUAD, NW)

    m2 = np.stack(
        [seeds[:, offsets[7 + b] : offsets[8 + b]] for b in range(NQUAD)], axis=1
    ).astype(np.uint8)
    blocks = []
    for operator in range(NK):
        block = m2.transpose(0, 2, 1).astype(np.int64) @ tq_w[operator].astype(np.int64) % P
        blocks.append(np.ascontiguousarray(block.reshape(NSEED, FORMAL), dtype=np.uint8))
    transitions = np.ascontiguousarray(np.vstack(blocks), dtype=np.uint8)

    tqq = np.empty((NK, NQUAD, NQUAD, NQ), dtype=np.uint8)
    for operator in range(NK):
        for source in range(NQUAD):
            for target in range(NQUAD):
                tqq[operator, source, target] = tquad[
                    operator, source, offsets[7 + target] : offsets[8 + target]
                ]
    commutators = []
    labels = []
    for left in range(NK):
        for right in range(left + 1, NK):
            for source in range(NQUAD):
                first = tqq[right, source].T.astype(np.int64) @ tq_w[left]
                second = tqq[left, source].T.astype(np.int64) @ tq_w[right]
                commutators.append(np.ascontiguousarray((first - second) % P).reshape(-1))
                labels.append((left, right, source))
    commutators = np.ascontiguousarray(np.vstack(commutators), dtype=np.uint8)

    kernel_blocks = kernel.reshape(NQ, NV, 19)
    kernel_w_rows = np.ascontiguousarray(
        kernel_blocks[:, NSEED:].reshape(FORMAL, 19).T, dtype=np.uint8
    )
    kernel_rref, kernel_pivots = rref_rows(kernel_w_rows)
    if len(kernel_pivots) != 19:
        raise AssertionError("kernel-W rank changed")
    transition_q, quotient_nonpivots = quotient_coordinates(
        transitions, kernel_rref, kernel_pivots
    )
    commutator_q, quotient_nonpivots_2 = quotient_coordinates(
        commutators, kernel_rref, kernel_pivots
    )
    if not np.array_equal(quotient_nonpivots, quotient_nonpivots_2):
        raise AssertionError("quotient basis mismatch")
    transition_rank, transition_profile = rank_and_profile(transition_q)
    commutator_rank, commutator_profile = rank_and_profile(commutator_q)
    combined_rank, _combined_profile = rank_and_profile(
        np.vstack([transition_q, commutator_q])
    )
    if (transition_rank, commutator_rank, combined_rank) != (2053, 210, 2053):
        raise AssertionError("unexpected quotient ranks")
    if np.any(~np.any(transition_q, axis=1)) or np.any(~np.any(commutator_q, axis=1)):
        raise AssertionError("an individual class vanished in the quotient")

    block_ranks = []
    cumulative_ranks = []
    for operator in range(NK):
        start, stop = operator * NSEED, (operator + 1) * NSEED
        block_ranks.append(rank_and_profile(transition_q[start:stop])[0])
        cumulative_ranks.append(rank_and_profile(transition_q[:stop])[0])

    selected_labels = np.column_stack(
        [transition_profile // NSEED, transition_profile % NSEED]
    ).astype(np.int32)
    selected_basis = np.ascontiguousarray(transition_q[transition_profile], dtype=np.uint8)
    if rank_and_profile(selected_basis)[0] != 2053:
        raise AssertionError("selected transition basis lost rank")

    artifact = HERE / "pc1_degree4_closure.npz"
    np.savez_compressed(
        artifact,
        prime=np.int32(P),
        kernel_w_rref=kernel_rref,
        kernel_w_pivots=kernel_pivots,
        quotient_nonpivot_columns=quotient_nonpivots,
        transition_quotient=transition_q,
        commutator_quotient=commutator_q,
        transition_basis_rows=transition_profile,
        transition_basis_labels=selected_labels,
        commutator_basis_rows=commutator_profile,
        commutator_labels=np.asarray(labels, dtype=np.int16),
    )
    result = {
        "status": "PC1-DEGREE4-CLOSURE-PASS",
        "prime": P,
        "inputs": {
            str(RELATION.relative_to(ROOT)): sha256_file(RELATION),
            str(MULTIPLICATION.relative_to(ROOT)): sha256_file(MULTIPLICATION),
            KERNEL.name: sha256_file(KERNEL),
            PC0.name: sha256_file(PC0),
        },
        "old_degree4_rank": 25530,
        "multiplication_kernel_dimension": 19,
        "formal_missing_tensor_dimension": 2072,
        "actual_new_quotient_dimension": 2053,
        "new_degree4_rank": 27583,
        "transition_rows": 4140,
        "transition_syzygy_dimension_in_quotient": 4140 - transition_rank,
        "transition_block_ranks_mod_old": block_ranks,
        "transition_cumulative_ranks_mod_old": cumulative_ranks,
        "minimal_transition_generators": transition_rank,
        "minimal_transition_labels_sha256": sha256_array(selected_labels),
        "commutator_rows": 315,
        "commutator_rank_mod_old": commutator_rank,
        "commutator_syzygy_dimension_mod_old": 315 - commutator_rank,
        "commutators_add_directions": combined_rank - transition_rank,
        "individual_transition_memberships_old": 0,
        "individual_commutator_memberships_old": 0,
        "normal_form": {
            "kernel_pivot_columns": kernel_pivots.tolist(),
            "quotient_basis_dimension": len(quotient_nonpivots),
            "rule": "eliminate the 19 kernel-W pivots, then retain the 2053 nonpivot coordinates",
        },
        "artifact": artifact.name,
        "artifact_sha256": sha256_file(artifact),
        "transition_quotient_sha256": sha256_array(transition_q),
        "commutator_quotient_sha256": sha256_array(commutator_q),
        "theorem_boundary": {
            "proves": (
                "The exact pure-q degree-four closure quotient over F_89 has dimension "
                "2053, with a canonical normal-form basis and minimal selected transition "
                "generators. Commutators have quotient rank 210 and add no direction."
            ),
            "does_not_prove": (
                "Closure of the coupled 28-component module in degree five or higher, "
                "a stabilization/regularity bound, representation characters, or support."
            ),
        },
    }
    (HERE / "pc1_degree4_closure.json").write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n"
    )
    print("PASS_PC1_DEGREE4_CLOSURE", flush=True)


if __name__ == "__main__":
    main()
