#!/usr/bin/env python3
"""Select a sparse Stage-B contraction subsystem without coordinate base loci.

This is a selection diagnostic, not an emptiness certificate.  It reads the
already verified 256 contracted rows and greedily chooses rows that increase
the exact F_89 row rank of P3(q) on every coordinate point and every two-term
point q=e_i+e_j.  The resulting indices can be fed to an exact saturation or
Fitting computation; sampled ranks are never promoted to a theorem.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parent
P = 89


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    out: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            out.append((first,) + tail)
    return out


def rank_mod(rows: np.ndarray) -> int:
    a = np.asarray(rows, dtype=np.int64).copy() % P
    if a.size == 0:
        return 0
    nr, nc = a.shape
    rank = 0
    for col in range(nc):
        pivots = np.flatnonzero(a[rank:, col])
        if not len(pivots):
            continue
        pivot = rank + int(pivots[0])
        if pivot != rank:
            a[[rank, pivot]] = a[[pivot, rank]]
        a[rank] = a[rank] * pow(int(a[rank, col]), P - 2, P) % P
        for row in range(nr):
            if row != rank and a[row, col]:
                a[row] = (a[row] - a[row, col] * a[rank]) % P
        rank += 1
        if rank == nr or rank == nc:
            break
    return rank


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--rows", type=int, default=43)
    parser.add_argument("--mode", choices=("coverage", "ratio"), default="ratio")
    args = parser.parse_args()
    contracted_path = P25 / "syzygy_r256_q0_contracted.npz"
    syzygy_path = P25 / "linear_syzygies.npz"
    with np.load(contracted_path) as frozen:
        p3 = frozen["p3"].astype(np.uint8)
        chosen_source = frozen["chosen_syzygies"].astype(np.int32)
    with np.load(syzygy_path) as frozen:
        syzygies = frozen["syzygies"].astype(np.uint8)
    assert p3.shape == (256, 6, 9139)
    assert len(np.unique(chosen_source)) == 256

    monomials = weak_compositions(3, 37)
    monomial_index = {m: i for i, m in enumerate(monomials)}
    points: list[tuple[str, list[int]]] = []
    for i in range(37):
        exponent = [0] * 37
        exponent[i] = 3
        points.append((f"e{i}", [monomial_index[tuple(exponent)]]))
    for i in range(37):
        for j in range(i + 1, 37):
            indices = []
            for a in range(4):
                exponent = [0] * 37
                exponent[i] = a
                exponent[j] = 3 - a
                indices.append(monomial_index[tuple(exponent)])
            points.append((f"e{i}+e{j}", indices))

    # At q=e_i+e_j every supported degree-three monomial evaluates to one.
    evaluations = np.empty((len(points), 256, 6), dtype=np.uint8)
    for point_index, (_, indices) in enumerate(points):
        evaluations[point_index] = np.sum(
            p3[:, :, indices].astype(np.int16), axis=2
        ) % P

    nnz_all = np.count_nonzero(syzygies, axis=(1, 2)).astype(np.int64)
    nnz = nnz_all[chosen_source]
    selected: list[int] = []
    ranks = np.zeros(len(points), dtype=np.int8)
    remaining = set(range(256))
    while len(selected) < args.rows:
        best = None
        best_key = None
        for candidate in sorted(remaining):
            gains = 0
            for point_index in range(len(points)):
                old = int(ranks[point_index])
                if old == 6:
                    continue
                rows = evaluations[point_index, selected + [candidate], :]
                if rank_mod(rows) > old:
                    gains += 1
            # Rank coverage is primary; sparsity and stable index break ties.
            if args.mode == "coverage":
                key = (float(gains), gains, -int(nnz[candidate]), -candidate)
            else:
                key = (
                    float(gains) / float(nnz[candidate]),
                    gains,
                    -int(nnz[candidate]),
                    -candidate,
                )
            if best_key is None or key > best_key:
                best_key = key
                best = candidate
        assert best is not None
        selected.append(best)
        remaining.remove(best)
        for point_index in range(len(points)):
            ranks[point_index] = rank_mod(evaluations[point_index, selected, :])
        print(
            f"selected={len(selected):02d} row={best:03d} nnz={nnz[best]} "
            f"rank6={int(np.count_nonzero(ranks == 6))}/{len(points)} "
            f"minrank={int(ranks.min())}",
            flush=True,
        )

    payload = {
        "prime": P,
        "scope": (
            "Selection heuristic only. Exact ranks are certified only on the "
            "listed finite evaluation set; no projective emptiness follows."
        ),
        "source": {
            "contracted": contracted_path.name,
            "contracted_sha256": sha256(contracted_path),
            "linear_syzygies": syzygy_path.name,
            "linear_syzygies_sha256": sha256(syzygy_path),
        },
        "selection": selected,
        "selection_mode": args.mode,
        "source_syzygy_indices": chosen_source[selected].astype(int).tolist(),
        "selected_nnz": nnz[selected].astype(int).tolist(),
        "points": len(points),
        "point_family": "37 coordinate points and 666 points e_i+e_j",
        "rank_histogram": {
            str(rank): int(np.count_nonzero(ranks == rank)) for rank in range(7)
        },
        "all_tested_points_rank_6": bool(np.all(ranks == 6)),
    }
    out = HERE / f"support_cover_{args.mode}_r{args.rows}.json"
    out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {out}", flush=True)


if __name__ == "__main__":
    main()
