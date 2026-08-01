#!/usr/bin/env python3
"""Producer: recompute the exact witness from the parent covariant source."""

from __future__ import annotations

import itertools
import json
import sys
from pathlib import Path

import sympy as sp

ROOT = Path(__file__).resolve().parents[4]
sys.path.insert(0, str(ROOT / "tmp" / "generic_twist"))
import phi_coefficients as phi  # noqa: E402


def determinant(columns):
    total = 0
    for permutation in itertools.permutations(range(5)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(5)
            for j in range(i + 1, 5)
        )
        term = 1
        for column in range(5):
            term *= columns[column][permutation[column]]
        total += -term if inversions % 2 else term
    return total


def main():
    _, frame, _ = phi.all_coefficients()
    point = (-2, -2, -2, -2, -1)
    columns = [phi.evaluate_vector(vector, point) for vector in frame]
    a = sp.symbols("a0:3")
    image = [sum(a[j] * columns[j][i] for j in range(3)) for i in range(5)]
    polynomial = sp.Poly(sp.expand(phi.klein(image)), *a)
    result = {
        "point": point,
        "frame_columns": columns,
        "frame_determinant": determinant(columns),
        "plane_cubic_terms": [
            {"exponents": monomial, "coefficient": int(coefficient)}
            for monomial, coefficient in polynomial.terms()
        ],
    }
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
