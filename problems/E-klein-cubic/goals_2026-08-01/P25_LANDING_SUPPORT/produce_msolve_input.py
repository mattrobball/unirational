#!/usr/bin/env python3
"""Build the exact homogeneous P25 landing system over F_89 for msolve.

The input is rebuilt from the sealed 746-row echelon basis.  Coefficient
coordinates are q0..q36,k0..k5; the solver order puts k0..k5 first so that the
56 K^3 and 690 QK^2 border pivots are exposed to DRL elimination.
"""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
EXACT = ROOT / "certificates" / "degree25_exact"
SOURCE = EXACT / "landing_cubics.npz"
P = 89

sys.path.insert(0, str(EXACT))
import common_p25x as common  # noqa: E402


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def monomial_string(exponents: tuple[int, ...], names: list[str]) -> str:
    factors: list[str] = []
    for exponent, name in zip(exponents, names):
        if exponent == 1:
            factors.append(name)
        elif exponent > 1:
            factors.append(f"{name}^{exponent}")
    return "*".join(factors) if factors else "1"


def polynomial_string(row: np.ndarray, monomials, names: list[str]) -> str:
    terms: list[str] = []
    for coefficient, exponents in zip(row, monomials):
        coefficient = int(coefficient) % P
        if coefficient == 0:
            continue
        monomial = monomial_string(exponents, names)
        terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms)


def main() -> None:
    with np.load(SOURCE) as frozen:
        rows = np.ascontiguousarray(frozen["p89"], dtype=np.uint8)
    assert rows.shape == (746, 14190)
    assert sha256_array(rows) == "403cd42146550e36baa71bc5d34070438a0ffdf63d1f65bd41ea3850255b7495"

    pivots = [int(np.flatnonzero(row)[0]) for row in rows]
    assert pivots == list(range(746))
    assert np.array_equal(rows[:, :746], np.eye(746, dtype=np.uint8))

    names = [f"q{i}" for i in range(37)] + [f"k{i}" for i in range(6)]
    solver_names = [f"k{i}" for i in range(6)] + [f"q{i}" for i in range(37)]
    monomials = common.cubic_monomials()
    assert len(monomials) == 14190
    assert all(sum(exponents) == 3 for exponents in monomials)
    assert all(sum(exponents[:37]) == 0 for exponents in monomials[:56])
    assert all(
        sum(exponents[:37]) == 1 and sum(exponents[37:]) == 2
        for exponents in monomials[56:746]
    )

    target = HERE / "landing_746_kfirst.ms"
    with target.open("w") as handle:
        handle.write(",".join(solver_names) + f"\n{P}\n")
        for index, row in enumerate(rows):
            handle.write(polynomial_string(row, monomials, names))
            handle.write(",\n" if index + 1 < len(rows) else "\n")

    payload = {
        "prime": P,
        "source": str(SOURCE),
        "source_sha256": sha256_file(SOURCE),
        "p89_rows_sha256": sha256_array(rows),
        "input": target.name,
        "input_sha256": sha256_file(target),
        "input_bytes": target.stat().st_size,
        "shape": list(rows.shape),
        "rank": 746,
        "pivot_columns": [0, 745],
        "pivot_profile": {"K3": 56, "QK2": 690},
        "variables": names,
        "solver_variable_order": solver_names,
        "criterion": (
            "A completed exact DRL leading ideal containing a pure power of "
            "each of the 43 variables proves that the homogeneous affine cone "
            "is supported only at the origin, hence the projective landing "
            "scheme over F_89 is empty."
        ),
    }
    (HERE / "msolve_input.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
