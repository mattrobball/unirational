#!/usr/bin/env python3
"""Build the complete 746-cubic system in its sealed standard RREF order."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
EXACT = ROOT / "certificates" / "degree25_exact"
SOURCE = EXACT / "landing_cubics.npz"
SEMANTIC = ROOT / "certificates" / "degree25_rowrank" / "landing_rows_unisolvent.npz"
P = 89

sys.path.insert(0, str(EXACT))
import common_p25x as common  # noqa: E402


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def monomial_string(exponents: tuple[int, ...], names: list[str]) -> str:
    factors = []
    for exponent, name in zip(exponents, names):
        if exponent == 1:
            factors.append(name)
        elif exponent > 1:
            factors.append(f"{name}^{exponent}")
    return "*".join(factors) if factors else "1"


def main() -> None:
    with np.load(SOURCE) as frozen:
        rows = np.ascontiguousarray(frozen["p89"], dtype=np.uint8)
    with np.load(SEMANTIC) as frozen:
        semantic = np.ascontiguousarray(frozen["echelon"], dtype=np.uint8)
        assert int(frozen["prime"]) == P and int(frozen["rank"]) == 746
    assert rows.shape == semantic.shape == (746, 14190)
    assert np.array_equal(rows, semantic)
    assert np.array_equal(rows[:, :746], np.eye(746, dtype=np.uint8))

    names = [f"q{i}" for i in range(37)] + [f"k{i}" for i in range(6)]
    monomials = common.cubic_monomials()
    monomial_text = [monomial_string(exponents, names) for exponents in monomials]
    target = HERE / "landing_746_standard.ms"
    with target.open("w") as handle:
        handle.write(",".join(names) + f"\n{P}\n")
        for row_index, row in enumerate(rows):
            terms = []
            for coefficient, monomial in zip(row, monomial_text):
                coefficient = int(coefficient) % P
                if coefficient:
                    terms.append(
                        monomial if coefficient == 1 else f"{coefficient}*{monomial}"
                    )
            handle.write("+".join(terms))
            handle.write(",\n" if row_index + 1 < len(rows) else "\n")

    lead_monomials = monomials[:746]
    degree4_shadow = {
        tuple(exponent + int(variable == index) for index, exponent in enumerate(monomial))
        for monomial in lead_monomials
        for variable in range(43)
    }
    metadata = {
        "prime": P,
        "source": str(SOURCE),
        "source_sha256": sha256_file(SOURCE),
        "semantic_rows": str(SEMANTIC),
        "semantic_rows_sha256": sha256_file(SEMANTIC),
        "rows_sha256": sha256_array(rows),
        "shape": list(rows.shape),
        "rank": 746,
        "pivot_columns": [0, 745],
        "pivot_block_identity": True,
        "degree4_initial_shadow_size": len(degree4_shadow),
        "input": target.name,
        "input_sha256": sha256_file(target),
        "input_bytes": target.stat().st_size,
        "variables": names,
        "criterion": (
            "A completed exact DRL leading ideal containing a pure power of "
            "each of the 43 variables proves empty projective support."
        ),
    }
    (HERE / "msolve_standard_input.json").write_text(
        json.dumps(metadata, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(metadata, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
