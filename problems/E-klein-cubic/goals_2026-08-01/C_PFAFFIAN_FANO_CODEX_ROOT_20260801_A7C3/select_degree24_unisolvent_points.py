#!/usr/bin/env python3
"""Select 40 points unisolvent for the integral degree-24 invariant basis."""

from __future__ import annotations

import hashlib
import json
import random
import runpy
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
P = 23
SEED = 20260801


def add_echelon(echelon, row):
    remainder = list(row)
    for pivot, basis_row in echelon:
        if remainder[pivot]:
            scalar = remainder[pivot]
            remainder = [(left - scalar * right) % P for left, right in zip(remainder, basis_row)]
    nonzero = [index for index, value in enumerate(remainder) if value]
    if not nonzero:
        return False, None
    pivot = nonzero[0]
    pivot_value = remainder[pivot]
    inverse = pow(pivot_value, -1, P)
    echelon.append((pivot, [value * inverse % P for value in remainder]))
    return True, pivot_value


def matrix_rank_and_pivot_product(rows):
    echelon = []
    product = 1
    for row in rows:
        added, pivot = add_echelon(echelon, row)
        assert added and pivot is not None
        product = product * pivot % P
    return len(echelon), product


def main():
    core = runpy.run_path(str(ROOT / "tmp/kproj_arithmetic/core.py"))
    columns = core["module_columns"](24)
    assert len(columns) == 40
    polynomials = [column[2] for column in columns]
    rng = random.Random(SEED)
    points = []
    matrix = []
    echelon = []
    tried = 0
    while len(points) < 40 and tried < 10000:
        tried += 1
        point = tuple(rng.randrange(P) for _ in range(5))
        row = [core["evaluate_mod"](polynomial, point, P) for polynomial in polynomials]
        added, _pivot = add_echelon(echelon, row)
        if added:
            points.append(list(point))
            matrix.append(row)
            print(f"rank={len(points)} tried={tried}", flush=True)
    assert len(points) == 40
    rank, pivot_product = matrix_rank_and_pivot_product(matrix)
    assert rank == 40 and pivot_product != 0
    artifact = {
        "format": "degree24-invariant-unisolvent-p23-v1",
        "prime": P,
        "seed": SEED,
        "tried": tried,
        "basis_source": "tmp/kproj_arithmetic/core.py module_columns(24)",
        "basis_dimension": 40,
        "points": points,
        "evaluation_matrix_mod_23": matrix,
        "rank": rank,
        "pivot_product": pivot_product,
    }
    canonical = json.dumps(artifact, sort_keys=True, separators=(",", ":")).encode()
    artifact["payload_sha256"] = hashlib.sha256(canonical).hexdigest()
    output = HERE / "degree24_unisolvent_points.json"
    output.write_text(json.dumps(artifact, indent=2) + "\n")
    print(f"WROTE {output}")
    print("DEGREE24-INVARIANT-UNISOLVENT-40")


if __name__ == "__main__":
    main()
