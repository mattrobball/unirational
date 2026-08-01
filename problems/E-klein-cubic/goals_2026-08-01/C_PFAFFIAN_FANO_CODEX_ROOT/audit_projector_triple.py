#!/usr/bin/env python3
"""Audit algebraic relations among a split residue's three projectors.

This is deliberately a modular diagnostic.  A spectral triple would expose
an etale cubic subalgebra, but it would not by itself descend one rank-two
idempotent to the characteristic-zero invariant field.
"""

from __future__ import annotations

import argparse
import json
import runpy
from itertools import combinations
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
EXTRACT = runpy.run_path(str(HERE / "extract_ambient_projector_points.py"))


def matrix_rank(matrix: np.ndarray, prime: int) -> int:
    work = matrix.astype(np.int64).copy() % prime
    pivot_row = 0
    for column in range(work.shape[1]):
        candidates = np.flatnonzero(work[pivot_row:, column])
        if not len(candidates):
            continue
        row = pivot_row + int(candidates[0])
        work[[pivot_row, row]] = work[[row, pivot_row]]
        work[pivot_row] *= pow(int(work[pivot_row, column]), -1, prime)
        work[pivot_row] %= prime
        for other in range(work.shape[0]):
            if other != pivot_row and work[other, column]:
                work[other] -= work[other, column] * work[pivot_row]
                work[other] %= prime
        pivot_row += 1
        if pivot_row == work.shape[0]:
            break
    return pivot_row


def pfaffian6(matrix: np.ndarray, prime: int) -> int:
    assert matrix.shape == (6, 6)
    answer = 0
    for j in range(1, 6):
        remaining = [index for index in range(1, 6) if index != j]
        a, b, c, d = remaining
        pf4 = (
            matrix[a, b] * matrix[c, d]
            - matrix[a, c] * matrix[b, d]
            + matrix[a, d] * matrix[b, c]
        )
        answer += (-1 if j % 2 == 0 else 1) * matrix[0, j] * pf4
    return int(answer) % prime


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, required=True)
    parser.add_argument("--zeta", type=int, required=True)
    parser.add_argument("--point", nargs=5, type=int, default=(2, 5, 7, 11, 13))
    args = parser.parse_args()
    prime = args.prime
    zeta = args.zeta % prime
    suffix = f"_zeta{zeta}"

    metadata = json.loads((HERE / f"ambient_degree12_p{prime}{suffix}.json").read_text())
    degree, eliminant, roots, vectors = EXTRACT["parse_rur"](
        HERE / f"ambient_degree12_p{prime}{suffix}_a47.rur", prime
    )
    assert degree == 3 and len(roots) == 3

    namespace = runpy.run_path(
        str(ROOT / "tmp/pfaffian_rank2_idempotent_attack/full_wedge.py")
    )
    live = namespace["FullWedgeScanner"].__init__.__globals__
    fano_live = live["fano"]["six_dimensional_generators"].__globals__
    live["P"] = prime
    fano_live["P"] = prime
    fano_live["ZETA"] = zeta
    scanner = namespace["FullWedgeScanner"]()
    fano = live["fano"]
    seeds = [(entry[0], tuple(entry[1])) for entry in metadata["seeds"]]
    six = fano["six_dimensional_generators"]()
    dual = tuple(fano["inv"](generator).T % prime for generator in six)
    dual_wedge = tuple(fano["exterior_square"](generator) for generator in dual)
    domain_basis, _ = fano["invariant_summands"](dual_wedge)
    pairs = tuple(combinations(range(6), 2))

    point = np.array(args.point, dtype=np.int64) % prime
    values = np.stack([
        scanner.evaluate_seed(output, exponents, point)
        for output, exponents in seeds
    ])
    q = EXTRACT["skew"](domain_basis @ point % prime, pairs, prime)
    projectors = []
    for vector in vectors:
        wedge = np.array(vector, dtype=np.int64) @ values % prime
        assert EXTRACT["pluecker"](wedge, fano["PAIR_INDEX"], prime) == [0] * 15
        projectors.append(EXTRACT["projector"](wedge, q, pairs, prime))

    identity = np.eye(6, dtype=np.int64) % prime
    total = sum(projectors, np.zeros((6, 6), dtype=np.int64)) % prime
    c1 = int(np.trace(total)) * pow(2, -1, prime) % prime
    c2 = (
        2 * c1 * c1 - int(np.trace(total @ total % prime))
    ) * pow(4, -1, prime) % prime
    c3 = pfaffian6(q @ total % prime, prime) * pow(pfaffian6(q, prime), -1, prime) % prime
    trace_cubic = [(-c3) % prime, c2, (-c1) % prime, 1]
    trace_roots = [
        value for value in range(prime)
        if sum(coefficient * pow(value, exponent, prime)
               for exponent, coefficient in enumerate(trace_cubic)) % prime == 0
    ]
    pair_records = []
    for left in range(3):
        for right in range(left + 1, 3):
            lr = projectors[left] @ projectors[right] % prime
            rl = projectors[right] @ projectors[left] % prime
            pair_records.append({
                "roots": [roots[left], roots[right]],
                "commute": bool(np.array_equal(lr, rl)),
                "left_right_product_rank": matrix_rank(lr, prime),
                "right_left_product_rank": matrix_rank(rl, prime),
                "orthogonal": bool(not np.any(lr) and not np.any(rl)),
            })
    payload = {
        "format": "ambient-projector-triple-audit-v1",
        "scope": "modular auxiliary projectors only",
        "prime": prime,
        "zeta11": zeta,
        "point": [int(value) for value in point],
        "eliminant_coefficients_ascending": eliminant,
        "roots": roots,
        "sum_is_identity": bool(np.array_equal(total, identity)),
        "sum_minus_identity_rank": matrix_rank(total - identity, prime),
        "trace_projector_sum_pfaffian_characteristic_ascending": trace_cubic,
        "trace_projector_sum_roots": trace_roots,
        "pairs": pair_records,
        "theorem_boundary": (
            "even a spectral residue triple would not supply a K_proj-rational "
            "rank-two idempotent without exact characteristic-zero descent"
        ),
    }
    target = HERE / f"ambient_projector_triple_p{prime}{suffix}.json"
    target.write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps(payload, indent=2))
    print("AMBIENT-PROJECTOR-TRIPLE-MODULAR-AUDITED")


if __name__ == "__main__":
    main()
