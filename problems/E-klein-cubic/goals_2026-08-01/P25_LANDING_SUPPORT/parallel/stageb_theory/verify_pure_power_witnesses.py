#!/usr/bin/env python3
"""Verify sparse degree-five pure-power Stage-B module identities.

Each input NPZ must contain a sparse homogeneous degree-three row multiplier
C(q) in the following canonical arrays:

    row_indices              int32, shape (nnz,)
    monomial3_indices        int32, shape (nnz,)
    coefficients             uint8, shape (nnz,)
    target_q                 scalar int32 in [0,37)
    target_b1                scalar int32 in [0,6)
    prime                    scalar int32 equal to 89
    relation_matrix_sha256   scalar string

The verifier rebuilds the sealed mixed matrix and checks, coefficient by
coefficient, that

    C(q) M2(q) = 0,
    C(q) M1(q) = q_target^5 e_target_b1.

With --require-complete, exactly all 37*6 targets must be present.  Such a set
is a decisive Stage-B emptiness certificate: on q_i != 0 the six identities
generate every b1-dual basis vector.  The verifier never treats a missing or
failed witness as a nonmembership result.
"""

from __future__ import annotations

import argparse
import hashlib
import math
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
P = 89


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            h.update(chunk)
    return h.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    result: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            result.append((first,) + tail)
    return result


def weak_composition_index(exponent: tuple[int, ...]) -> int:
    """Index in weak_compositions(sum(exponent),len(exponent)) without a dict."""
    total = sum(exponent)
    parts = len(exponent)
    index = 0
    remaining = total
    for position, value in enumerate(exponent[:-1]):
        tail_parts = parts - position - 1
        for smaller in range(value):
            tail_total = remaining - smaller
            index += math.comb(tail_total + tail_parts - 1, tail_parts - 1)
        remaining -= value
    return index


def added_index(base: tuple[int, ...], addition: tuple[int, ...]) -> int:
    return weak_composition_index(tuple(x + y for x, y in zip(base, addition)))


def scalar_string(value: np.ndarray) -> str:
    return str(np.asarray(value).item())


def verify_one(
    path: Path,
    seeds: np.ndarray,
    offsets: np.ndarray,
    monomials1: list[tuple[int, ...]],
    monomials2: list[tuple[int, ...]],
    monomials3: list[tuple[int, ...]],
    relation_hash: str,
) -> tuple[int, int, int]:
    with np.load(path, allow_pickle=False) as frozen:
        required = {
            "row_indices",
            "monomial3_indices",
            "coefficients",
            "target_q",
            "target_b1",
            "prime",
            "relation_matrix_sha256",
        }
        if not required.issubset(frozen.files):
            raise AssertionError(f"{path}: missing {sorted(required-set(frozen.files))}")
        rows = frozen["row_indices"].astype(np.int32)
        monomial_indices = frozen["monomial3_indices"].astype(np.int32)
        coefficients = frozen["coefficients"].astype(np.int64) % P
        target_q = int(frozen["target_q"])
        target_b1 = int(frozen["target_b1"])
        assert int(frozen["prime"]) == P
        assert scalar_string(frozen["relation_matrix_sha256"]) == relation_hash

    assert rows.ndim == monomial_indices.ndim == coefficients.ndim == 1
    assert len(rows) == len(monomial_indices) == len(coefficients) > 0
    assert 0 <= target_q < 37 and 0 <= target_b1 < 6
    assert np.all((0 <= rows) & (rows < 690))
    assert np.all((0 <= monomial_indices) & (monomial_indices < 9139))
    assert np.all(coefficients != 0)
    pairs = np.stack([rows, monomial_indices], axis=1)
    order = np.lexsort((pairs[:, 1], pairs[:, 0]))
    assert np.array_equal(order, np.arange(len(order))), f"{path}: entries not sorted"
    assert len(np.unique(pairs, axis=0)) == len(pairs), f"{path}: duplicate entries"

    # Dense output coefficient vectors are only about 52 MiB as int64.  The
    # huge Macaulay matrix itself is never formed.
    output_b1 = np.zeros((6, math.comb(41, 5)), dtype=np.int64)
    output_b2 = np.zeros((21, math.comb(40, 4)), dtype=np.int64)
    map5_cache: dict[int, np.ndarray] = {}
    map4_cache: dict[int, np.ndarray] = {}

    for row, monomial_index, coefficient in zip(rows, monomial_indices, coefficients):
        row_i = int(row)
        monomial_i = int(monomial_index)
        scalar = int(coefficient)
        base = monomials3[monomial_i]
        if monomial_i not in map5_cache:
            map5_cache[monomial_i] = np.asarray(
                [added_index(base, addition) for addition in monomials2],
                dtype=np.int32,
            )
            map4_cache[monomial_i] = np.asarray(
                [added_index(base, addition) for addition in monomials1],
                dtype=np.int32,
            )
        indices5 = map5_cache[monomial_i]
        indices4 = map4_cache[monomial_i]
        for b1 in range(6):
            block = seeds[
                row_i, int(offsets[1 + b1]) : int(offsets[2 + b1])
            ].astype(np.int64)
            np.add.at(output_b1[b1], indices5, scalar * block)
        for b2 in range(21):
            block = seeds[
                row_i, int(offsets[7 + b2]) : int(offsets[8 + b2])
            ].astype(np.int64)
            np.add.at(output_b2[b2], indices4, scalar * block)

    output_b1 %= P
    output_b2 %= P
    target_exponent = [0] * 37
    target_exponent[target_q] = 5
    target_index = weak_composition_index(tuple(target_exponent))
    if np.any(output_b2):
        raise AssertionError(f"{path}: C(q)M2(q) is nonzero")
    if int(np.count_nonzero(output_b1)) != 1:
        raise AssertionError(f"{path}: C(q)M1(q) is not a pure basis vector")
    if int(output_b1[target_b1, target_index]) != 1:
        raise AssertionError(f"{path}: wrong pure target or normalization")
    return target_q, target_b1, len(rows)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("witnesses", nargs="+", type=Path)
    parser.add_argument("--require-complete", action="store_true")
    arguments = parser.parse_args()

    relation_hash = sha256(RELATION)
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        assert int(frozen["prime"]) == P
    monomials1 = weak_compositions(1, 37)
    monomials2 = weak_compositions(2, 37)
    monomials3 = weak_compositions(3, 37)
    assert [len(x) for x in (monomials1, monomials2, monomials3)] == [37, 703, 9139]

    targets: set[tuple[int, int]] = set()
    total_nnz = 0
    for path in arguments.witnesses:
        target_q, target_b1, nnz = verify_one(
            path,
            seeds,
            offsets,
            monomials1,
            monomials2,
            monomials3,
            relation_hash,
        )
        target = (target_q, target_b1)
        if target in targets:
            raise AssertionError(f"duplicate target {target}")
        targets.add(target)
        total_nnz += nnz
        print(f"PASS witness q{target_q}^5 e{target_b1}: nnz={nnz}")

    if arguments.require_complete:
        expected = {(q, b1) for q in range(37) for b1 in range(6)}
        if targets != expected:
            missing = sorted(expected - targets)
            raise AssertionError(f"incomplete pure-power cover; missing {missing}")
        print("PASS_DECISIVE_STAGE_B_PURE_POWER_COVER")
    else:
        print("PASS_PARTIAL_PURE_POWER_WITNESSES_NONVERDICT")
    print(f"witnesses={len(targets)} sparse_nnz={total_nnz}")


if __name__ == "__main__":
    main()
