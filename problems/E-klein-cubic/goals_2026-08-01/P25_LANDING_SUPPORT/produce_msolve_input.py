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
ROOT = HERE.parents[1]
EXACT = ROOT / "certificates" / "degree25_exact"
SOURCE = ROOT / "tmp" / "p25yf4_border" / "rows_qk.npz"
RREF_CACHE = ROOT / "tmp" / "p25z1_probe" / "rref_A.npz"
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
        source_rows = np.ascontiguousarray(frozen["rows"], dtype=np.uint8)
    assert source_rows.shape == (746, 14190)
    assert sha256_array(source_rows) == "0bc3f799c4cc776e708d0ea8984e0450cb34f52c82d5824405c135ab2a7af5cc"

    with np.load(RREF_CACHE) as frozen:
        rows = np.ascontiguousarray(frozen["A"], dtype=np.uint8)
        pivots = frozen["pivots"].astype(np.int32)
        permutation = frozen["perm"].astype(np.int32)
    assert rows.shape == (746, 14190)
    assert sha256_array(rows) == "f7ed78ff0e9414529acb7e437b6d3bb2928fdec878e08c2874a278faa44ddf6a"
    assert pivots.tolist() == list(range(746))
    assert np.array_equal(rows[:, :746], np.eye(746, dtype=np.uint8))

    names = [f"q{i}" for i in range(37)] + [f"k{i}" for i in range(6)]
    solver_names = [f"k{i}" for i in range(6)] + [f"q{i}" for i in range(37)]
    original_monomials = common.cubic_monomials()
    monomials = [original_monomials[int(index)] for index in permutation]
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
        "source_rows_sha256": sha256_array(source_rows),
        "rref_cache": str(RREF_CACHE),
        "rref_cache_sha256": sha256_file(RREF_CACHE),
        "rref_rows_sha256": sha256_array(rows),
        "permutation_sha256": sha256_array(permutation),
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
