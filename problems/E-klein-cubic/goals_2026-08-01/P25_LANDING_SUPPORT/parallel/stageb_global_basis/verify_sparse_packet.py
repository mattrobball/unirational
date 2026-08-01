#!/usr/bin/env python3
"""Independent exact replay for the full-basis Stage-B packet.

This verifier checks the stored full basis' systematic identity minor and
global sparsity statistics, then independently checks every selected identity
C(q)M2(q)=0 and rebuilds every P3 coefficient from the sealed relation tensor.
It does not run a saturation and therefore does not claim Stage-B emptiness.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path

import numpy as np

from produce_full_basis import (
    NQ,
    NULLITY,
    P,
    RELATION,
    sha256,
    weak_compositions,
)


HERE = Path(__file__).resolve().parent
BASIS = HERE / "full_linear_syzygy_basis.npy"
BASIS_STATS = HERE / "global_basis_statistics.npz"
FULL_P3 = HERE / "full_p3_contractions.npy"
P3_STATS = HERE / "full_p3_statistics.npz"
PACKET = HERE / "support_balanced_r43_stageB.npz"
STAGEBC = HERE / "support_balanced_r43_stageBC.npz"


def rank_small(matrix: np.ndarray) -> int:
    a = np.asarray(matrix, dtype=np.int64).copy() % P
    if a.size == 0:
        return 0
    row = 0
    for column in range(a.shape[1]):
        choices = np.flatnonzero(a[row:, column])
        if not len(choices):
            continue
        pivot = row + int(choices[0])
        a[[row, pivot]] = a[[pivot, row]]
        a[row] = a[row] * pow(int(a[row, column]), -1, P) % P
        for other in range(row + 1, len(a)):
            if a[other, column]:
                a[other] = (a[other] - a[other, column] * a[row]) % P
        row += 1
        if row == len(a):
            break
    return row


def rank_fflas(matrix: np.ndarray) -> int:
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.Rank_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
    rows, columns = dense.shape
    return int(function(float(P), rows, columns, dense, columns, False))


def multiplication_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: i for i, monomial in enumerate(target)}
    answer = np.empty((NQ, len(source)), dtype=np.int32)
    for variable in range(NQ):
        for source_index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, source_index] = target_index[tuple(exponent)]
    return answer


def direct_syzygy_check(syzygy: np.ndarray, m2: np.ndarray) -> bool:
    raw = (
        syzygy.T.astype(np.int64) @ m2.reshape(690, -1).astype(np.int64)
    ) % P
    raw = raw.reshape(NQ, 21, NQ)
    for u in range(NQ):
        if np.any(raw[u, :, u]):
            return False
        for v in range(u + 1, NQ):
            if np.any((raw[u, :, v] + raw[v, :, u]) % P):
                return False
    return True


def contract_p3(
    syzygy: np.ndarray,
    block: np.ndarray,
    product_map: np.ndarray,
    target_size: int,
) -> np.ndarray:
    coefficients = syzygy.T.astype(np.int64) @ block.astype(np.int64) % P
    output = np.zeros(target_size, dtype=np.int64)
    np.add.at(output, product_map.ravel(), coefficients.ravel())
    return (output % P).astype(np.uint8)


def contract_p4_batch(
    syzygies: np.ndarray,
    block: np.ndarray,
    product_map: np.ndarray,
    target_size: int,
) -> np.ndarray:
    output = np.zeros((len(syzygies), target_size), dtype=np.uint8)
    block_double = np.asarray(block, dtype=np.float64)
    for variable in range(NQ):
        product = (
            np.ascontiguousarray(syzygies[:, :, variable], dtype=np.float64)
            @ block_double
        )
        np.remainder(product, float(P), out=product)
        indices = product_map[variable]
        updated = output[:, indices].astype(np.uint16)
        updated += product.astype(np.uint8)
        np.remainder(updated, P, out=updated)
        output[:, indices] = updated.astype(np.uint8)
    return output


def main() -> None:
    required = [BASIS, BASIS_STATS, FULL_P3, P3_STATS, PACKET, STAGEBC, RELATION]
    for path in required:
        if not path.is_file():
            raise FileNotFoundError(path)
    basis = np.load(BASIS, mmap_mode="r")
    full_p3 = np.load(FULL_P3, mmap_mode="r")
    with np.load(BASIS_STATS, allow_pickle=False) as frozen:
        saved_nnz = frozen["nnz"].astype(np.int32)
        saved_masks = frozen["q_support_masks"].astype(np.uint64)
        identity_rows = frozen["systematic_identity_rows"].astype(np.int32)
    with np.load(P3_STATS, allow_pickle=False) as frozen:
        saved_p3_nnz = frozen["p3_nnz"].astype(np.int32)
    with np.load(PACKET, allow_pickle=False) as frozen:
        syzygies = frozen["syzygies"].astype(np.uint8)
        p3 = frozen["p3"].astype(np.uint8)
        columns = frozen["full_basis_columns"].astype(np.int32)
        stored_ranks = frozen["coordinate_ranks"].astype(np.int8)
        if int(frozen["prime"]) != P:
            raise AssertionError("packet prime mismatch")
    with np.load(STAGEBC, allow_pickle=False) as frozen:
        stagebc_p4 = frozen["p4"].astype(np.uint8)
        stagebc_p3 = frozen["p3"].astype(np.uint8)
        stagebc_syzygies = frozen["syzygies"].astype(np.uint8)
        stagebc_columns = frozen["full_basis_columns"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("Stage-BC packet prime mismatch")
    if basis.shape != (NULLITY, 690, NQ):
        raise AssertionError("basis shape mismatch")
    if full_p3.shape != (NULLITY, 6, 9139):
        raise AssertionError("full P3 shape mismatch")
    if syzygies.shape != (43, 690, NQ) or p3.shape != (43, 6, 9139):
        raise AssertionError("packet shape mismatch")
    if stagebc_p4.shape != (43, 91390):
        raise AssertionError("Stage-BC P4 shape mismatch")
    if not np.array_equal(stagebc_p3, p3):
        raise AssertionError("Stage-BC P3 differs from Stage-B packet")
    if not np.array_equal(stagebc_syzygies, syzygies):
        raise AssertionError("Stage-BC syzygies differ from Stage-B packet")
    if not np.array_equal(stagebc_columns, columns):
        raise AssertionError("Stage-BC basis columns differ from Stage-B packet")
    if not np.array_equal(syzygies, basis[columns]):
        raise AssertionError("packet syzygies do not match full basis")
    if not np.array_equal(p3, full_p3[columns]):
        raise AssertionError("packet P3 does not match full contraction tensor")

    # Replay the 10,767 x 10,767 systematic identity minor in narrow strips.
    flat = basis.reshape(NULLITY, 690 * NQ)
    for start in range(0, NULLITY, 64):
        end = min(NULLITY, start + 64)
        strip = np.asarray(flat[:, identity_rows[start:end]], dtype=np.uint8)
        expected = np.zeros((NULLITY, end - start), dtype=np.uint8)
        expected[np.arange(start, end), np.arange(end - start)] = 1
        if not np.array_equal(strip, expected):
            raise AssertionError(f"systematic identity strip {start}:{end} failed")

    # Recompute every global sparsity/support statistic from the stored basis.
    bit_weights = np.uint64(1) << np.arange(NQ, dtype=np.uint64)
    replay_nnz = np.empty(NULLITY, dtype=np.int32)
    replay_masks = np.empty(NULLITY, dtype=np.uint64)
    replay_p3_nnz = np.empty(NULLITY, dtype=np.int32)
    for start in range(0, NULLITY, 64):
        end = min(NULLITY, start + 64)
        chunk = np.asarray(basis[start:end], dtype=np.uint8)
        replay_nnz[start:end] = np.count_nonzero(chunk, axis=(1, 2))
        support = np.any(chunk != 0, axis=1)
        replay_masks[start:end] = np.sum(
            support.astype(np.uint64) * bit_weights[None, :], axis=1
        )
        replay_p3_nnz[start:end] = np.count_nonzero(
            full_p3[start:end], axis=(1, 2)
        )
    if not np.array_equal(replay_nnz, saved_nnz):
        raise AssertionError("global basis nnz statistics mismatch")
    if not np.array_equal(replay_masks, saved_masks):
        raise AssertionError("global q-support statistics mismatch")
    if not np.array_equal(replay_p3_nnz, saved_p3_nnz):
        raise AssertionError("global P3 nnz statistics mismatch")

    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise AssertionError("relation prime mismatch")
    q1 = weak_compositions(1, NQ)
    q2 = weak_compositions(2, NQ)
    q3 = weak_compositions(3, NQ)
    q4 = weak_compositions(4, NQ)
    variable_of = [monomial.index(1) for monomial in q1]
    m2 = np.empty((690, 21, NQ), dtype=np.uint8)
    for j in range(21):
        block = seeds[:, int(offsets[7 + j]) : int(offsets[8 + j])]
        for monomial_index, variable in enumerate(variable_of):
            m2[:, j, variable] = block[:, monomial_index]
    for index, syzygy in enumerate(syzygies):
        if not direct_syzygy_check(syzygy, m2):
            raise AssertionError(f"selected syzygy {index} failed C(q)M2(q)=0")

    product_map = multiplication_map(q2, q3)
    rebuilt = np.empty_like(p3)
    for row, syzygy in enumerate(syzygies):
        for component in range(6):
            block = seeds[
                :, int(offsets[1 + component]) : int(offsets[2 + component])
            ]
            rebuilt[row, component] = contract_p3(
                syzygy, block, product_map, len(q3)
            )
    if not np.array_equal(rebuilt, p3):
        raise AssertionError("independent P3 coefficient rebuild failed")
    map_3_to_4 = multiplication_map(q3, q4)
    b0_block = seeds[:, int(offsets[0]) : int(offsets[1])]
    rebuilt_p4 = contract_p4_batch(
        syzygies, b0_block, map_3_to_4, len(q4)
    )
    if not np.array_equal(rebuilt_p4, stagebc_p4):
        raise AssertionError("independent P4 coefficient rebuild failed")

    q3_index = {monomial: i for i, monomial in enumerate(q3)}
    pure3: list[int] = []
    for variable in range(NQ):
        exponent = [0] * NQ
        exponent[variable] = 3
        pure3.append(q3_index[tuple(exponent)])
    ranks = np.asarray(
        [rank_small(p3[:, :, pure3[q]]) for q in range(NQ)], dtype=np.int8
    )
    if not np.array_equal(ranks, stored_ranks) or not np.all(ranks == 6):
        raise AssertionError("coordinate rank replay failed")
    support_union = np.any(syzygies != 0, axis=(0, 1))
    if not np.all(support_union):
        raise AssertionError("selected packet misses a q coefficient direction")
    equation_rank = rank_fflas(p3.reshape(43, -1))
    component_ranks = [rank_fflas(p3[:, j, :]) for j in range(6)]
    if equation_rank != 43 or component_ranks != [43] * 6:
        raise AssertionError("packet module rows lost exact rank")

    result = {
        "status": "PASS_EXACT_PACKET_REPLAY",
        "prime": P,
        "full_basis_systematic_rank": NULLITY,
        "global_basis_statistics_replayed": True,
        "global_p3_term_counts_replayed": True,
        "selected_syzygies_directly_checked": 43,
        "selected_p3_rows_rebuilt": 43,
        "selected_p4_rows_rebuilt": 43,
        "coordinate_ranks": ranks.astype(int).tolist(),
        "q_support_complete": True,
        "equation_row_rank": equation_rank,
        "component_ranks": component_ranks,
        "packet_p3_terms": int(np.count_nonzero(p3)),
        "packet_p4_terms": int(np.count_nonzero(stagebc_p4)),
        "hashes": {str(path): sha256(path) for path in required},
        "scope": "Exact equation/module replay only; no saturation verdict.",
    }
    result_path = HERE / "verify_sparse_packet_result.json"
    result_path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print("PASS: full-basis packet and direct contractions replayed")
    print(json.dumps(result, sort_keys=True))


if __name__ == "__main__":
    main()
