#!/usr/bin/env python3
"""Select a low-term, support-balanced 43-row packet from the full basis.

The hard constraints are exact over F_89:

* rank P3(e_i) = 6 for all 37 coordinate points;
* every q coefficient direction occurs in the selected C(q)'s;
* the 43 degree-three module rows, and each component block, have rank 43.

The objective is the number of nonzero expanded P3 coefficients.  Several
weighted exact-rank greedy covers are followed by deterministic one-row
exchange descent.  Selection is heuristic, while every property asserted for
the returned packet is checked exactly.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path

import numpy as np

from produce_full_basis import NULLITY, NQ, P, RELATION, sha256


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
BASIS = HERE / "full_linear_syzygy_basis.npy"
BASIS_STATS = HERE / "global_basis_statistics.npz"
P3 = HERE / "full_p3_contractions.npy"
P3_STATS = HERE / "full_p3_statistics.npz"
OLD_PACKET = P25 / "parallel" / "stageb_structure" / "support_cover_r43_stageB.npz"
OUTPUT = HERE / "support_balanced_r43_stageB.npz"


def rank_small(matrix: np.ndarray) -> int:
    a = np.asarray(matrix, dtype=np.int64).copy() % P
    if a.size == 0:
        return 0
    rows, columns = a.shape
    row = 0
    for column in range(columns):
        pivots = np.flatnonzero(a[row:, column])
        if not len(pivots):
            continue
        pivot = row + int(pivots[0])
        if pivot != row:
            a[[row, pivot]] = a[[pivot, row]]
        a[row] = a[row] * pow(int(a[row, column]), -1, P) % P
        for other in range(rows):
            if other != row and a[other, column]:
                a[other] = (a[other] - a[other, column] * a[row]) % P
        row += 1
        if row == rows:
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


def rref_basis(matrix: np.ndarray) -> tuple[np.ndarray, list[int]]:
    a = np.asarray(matrix, dtype=np.int64).copy() % P
    if not len(a):
        return np.empty((0, a.shape[1]), dtype=np.int64), []
    row = 0
    pivots: list[int] = []
    for column in range(a.shape[1]):
        choices = np.flatnonzero(a[row:, column])
        if not len(choices):
            continue
        pivot = row + int(choices[0])
        a[[row, pivot]] = a[[pivot, row]]
        a[row] = a[row] * pow(int(a[row, column]), -1, P) % P
        for other in range(len(a)):
            if other != row and a[other, column]:
                a[other] = (a[other] - a[other, column] * a[row]) % P
        pivots.append(column)
        row += 1
        if row == len(a):
            break
    return a[:row], pivots


def independent_flags(vectors: np.ndarray, basis_rows: np.ndarray) -> np.ndarray:
    reduced = np.asarray(vectors, dtype=np.int64).copy() % P
    rref, pivots = rref_basis(basis_rows)
    for row, pivot in enumerate(pivots):
        factors = reduced[:, pivot].copy()
        reduced = (reduced - factors[:, None] * rref[row][None, :]) % P
    return np.any(reduced != 0, axis=1)


def coordinate_ranks(evaluations: np.ndarray, selected: list[int]) -> np.ndarray:
    return np.asarray(
        [rank_small(evaluations[selected, q, :]) for q in range(NQ)],
        dtype=np.int8,
    )


def greedy_cover(
    evaluations: np.ndarray, costs: np.ndarray, alpha: float
) -> list[int]:
    selected: list[int] = []
    ranks = np.zeros(NQ, dtype=np.int8)
    available = np.ones(NULLITY, dtype=bool)
    while np.any(ranks < 6):
        gains = np.zeros(NULLITY, dtype=np.int16)
        for q in range(NQ):
            if ranks[q] == 6:
                continue
            flags = independent_flags(evaluations[:, q, :], evaluations[selected, q, :])
            gains += flags.astype(np.int16)
        gains[~available] = 0
        candidates = np.flatnonzero(gains)
        if not len(candidates):
            raise AssertionError("coordinate cover stalled")
        denominator = np.power(costs[candidates].astype(np.float64), alpha)
        score = gains[candidates].astype(np.float64) / denominator
        best_score = float(score.max())
        tied = candidates[np.flatnonzero(score == best_score)]
        best = int(tied[np.argmin(costs[tied] * (NULLITY + 1) + tied)])
        selected.append(best)
        available[best] = False
        ranks = coordinate_ranks(evaluations, selected)
    return selected


def fill_to_43(selected: list[int], costs: np.ndarray) -> list[int]:
    answer = list(dict.fromkeys(selected))
    for candidate in np.argsort(costs, kind="stable"):
        item = int(candidate)
        if item not in answer:
            answer.append(item)
        if len(answer) == 43:
            break
    if len(answer) > 43:
        raise AssertionError("coordinate cover already exceeds 43")
    return answer


def exchange_descent(
    evaluations: np.ndarray, costs: np.ndarray, selected: list[int]
) -> list[int]:
    """Deterministic improving one-row exchanges preserving all axis ranks."""
    chosen = list(selected)
    changed = True
    while changed:
        changed = False
        chosen_set = set(chosen)
        unselected = [
            int(i)
            for i in np.argsort(costs, kind="stable")
            if int(i) not in chosen_set
        ]
        for removed in sorted(chosen, key=lambda i: (-int(costs[i]), i)):
            base = [item for item in chosen if item != removed]
            ranks = coordinate_ranks(evaluations, base)
            deficient = np.flatnonzero(ranks < 6)
            for candidate in unselected:
                if int(costs[candidate]) >= int(costs[removed]):
                    break
                good = True
                for q in deficient:
                    if not independent_flags(
                        evaluations[candidate : candidate + 1, q, :],
                        evaluations[base, q, :],
                    )[0]:
                        good = False
                        break
                if good:
                    chosen = base + [candidate]
                    changed = True
                    break
            if changed:
                break
    return sorted(chosen)


def main() -> None:
    required = [BASIS, BASIS_STATS, P3, P3_STATS, OLD_PACKET, RELATION]
    for path in required:
        if not path.is_file():
            raise FileNotFoundError(path)
    basis = np.load(BASIS, mmap_mode="r")
    p3 = np.load(P3, mmap_mode="r")
    with np.load(BASIS_STATS, allow_pickle=False) as frozen:
        evaluations = frozen["coordinate_p3_evaluations"].astype(np.uint8)
        basis_nnz = frozen["nnz"].astype(np.int32)
        support_masks = frozen["q_support_masks"].astype(np.uint64)
    with np.load(P3_STATS, allow_pickle=False) as frozen:
        costs = frozen["p3_nnz"].astype(np.int32)
    if basis.shape != (NULLITY, 690, NQ):
        raise AssertionError("full basis shape mismatch")
    if p3.shape != (NULLITY, 6, 9139):
        raise AssertionError("full P3 shape mismatch")
    if evaluations.shape != (NULLITY, NQ, 6):
        raise AssertionError("coordinate evaluation shape mismatch")

    trials: list[dict] = []
    best: list[int] | None = None
    best_cost: int | None = None
    for alpha in (0.0, 0.25, 0.5, 0.75, 1.0):
        cover = greedy_cover(evaluations, costs, alpha)
        packet = exchange_descent(evaluations, costs, fill_to_43(cover, costs))
        ranks = coordinate_ranks(evaluations, packet)
        if len(packet) != 43 or not np.all(ranks == 6):
            raise AssertionError("selection trial lost coordinate coverage")
        cost = int(np.sum(costs[packet]))
        trials.append(
            {
                "alpha": alpha,
                "initial_coordinate_cover_cardinality": len(cover),
                "initial_coordinate_cover": cover,
                "final_cost": cost,
            }
        )
        if best_cost is None or (cost, packet) < (best_cost, best or []):
            best = packet
            best_cost = cost

    # A deterministic structured search in the only support-feasible
    # four-intersection case found this eight-row coordinate cover.  Keep it
    # explicit so replay is fast; all 37 ranks are rechecked before it enters
    # the same exchange descent as the greedy trials.
    structured_cover8 = [9595, 9945, 10156, 10267, 10303, 10375, 10412, 10627]
    structured_ranks = coordinate_ranks(evaluations, structured_cover8)
    if not np.all(structured_ranks == 6):
        raise AssertionError("stored structured eight-row cover failed replay")
    structured_packet = exchange_descent(
        evaluations, costs, fill_to_43(structured_cover8, costs)
    )
    structured_cost = int(np.sum(costs[structured_packet]))
    trials.append(
        {
            "mode": "structured eight-row support-feasible search",
            "initial_coordinate_cover_cardinality": 8,
            "initial_coordinate_cover": structured_cover8,
            "final_cost": structured_cost,
        }
    )
    if (structured_cost, structured_packet) < (best_cost, best):
        best = structured_packet
        best_cost = structured_cost
    assert best is not None and best_cost is not None

    selected_basis = np.asarray(basis[best], dtype=np.uint8)
    selected_p3 = np.asarray(p3[best], dtype=np.uint8)
    ranks = coordinate_ranks(evaluations, best)
    support_union = np.bitwise_or.reduce(support_masks[best])
    expected_union = (np.uint64(1) << np.uint64(NQ)) - np.uint64(1)
    if support_union != expected_union:
        raise AssertionError("selected C(q) packet misses a q direction")
    equation_rank = rank_fflas(selected_p3.reshape(43, -1))
    component_ranks = [rank_fflas(selected_p3[:, j, :]) for j in range(6)]
    if equation_rank != 43 or component_ranks != [43] * 6:
        raise AssertionError("selected degree-three rows are not independent")

    with np.load(OLD_PACKET, allow_pickle=False) as frozen:
        old_p3 = frozen["p3"].astype(np.uint8)
    old_terms = int(np.count_nonzero(old_p3))
    old_syzygy_terms = None
    if "syzygies" in np.load(OLD_PACKET, allow_pickle=False).files:
        with np.load(OLD_PACKET, allow_pickle=False) as frozen:
            old_syzygy_terms = int(np.count_nonzero(frozen["syzygies"]))

    np.savez_compressed(
        OUTPUT,
        p3=selected_p3,
        syzygies=selected_basis,
        full_basis_columns=np.asarray(best, dtype=np.int32),
        p3_term_counts=costs[best],
        syzygy_nnz=basis_nnz[best],
        coordinate_ranks=ranks,
        q_support_masks=support_masks[best],
        prime=np.int32(P),
        full_basis_sha256=np.asarray(sha256(BASIS)),
        full_p3_sha256=np.asarray(sha256(P3)),
        relation_matrix_sha256=np.asarray(sha256(RELATION)),
    )
    payload = {
        "status": "PASS_SUPPORT_BALANCED_R43",
        "prime": P,
        "rows": 43,
        "selection_trials": trials,
        "selected_full_basis_columns": best,
        "selected_p3_term_counts": costs[best].astype(int).tolist(),
        "selected_syzygy_nnz": basis_nnz[best].astype(int).tolist(),
        "total_p3_terms": best_cost,
        "total_syzygy_nnz": int(np.sum(basis_nnz[best])),
        "coordinate_ranks": ranks.astype(int).tolist(),
        "q_support_union": list(range(NQ)),
        "equation_row_rank": equation_rank,
        "six_component_ranks": component_ranks,
        "comparison": {
            "old_support_cover_r43": str(OLD_PACKET.relative_to(P25)),
            "old_support_cover_r43_sha256": sha256(OLD_PACKET),
            "old_p3_terms": old_terms,
            "new_to_old_p3_term_ratio": best_cost / old_terms,
            "p3_terms_saved": old_terms - best_cost,
            "old_syzygy_nnz": old_syzygy_terms,
            "new_to_old_syzygy_nnz_ratio": (
                None
                if old_syzygy_terms is None
                else int(np.sum(basis_nnz[best])) / old_syzygy_terms
            ),
        },
        "artifact": {
            "file": OUTPUT.name,
            "sha256": sha256(OUTPUT),
        },
        "source_hashes": {str(path): sha256(path) for path in required},
        "scope": (
            "The packet gives necessary Stage-B equations with exact coordinate "
            "rank and full q support. Only a completed module or saturation unit "
            "certificate can prove global Stage-B emptiness."
        ),
    }
    certificate = HERE / "support_balanced_r43_certificate.json"
    certificate.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
