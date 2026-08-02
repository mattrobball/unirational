#!/usr/bin/env python3
"""Produce one immutable all-690 affine Stage-B input for msolve.

The chart is q0=1 and b1_0=1.  Its 62 variables are

    b2_0,...,b2_20, b1_1,...,b1_5, q1,...,q36.

Every equation is rebuilt directly from the sealed 690-row lower
presentation; no syzygy contraction or sampled row selection is used.
This producer never launches msolve and refuses to overwrite mismatching
immutable artifacts.
"""

from __future__ import annotations

import hashlib
import json
from collections import defaultdict
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
RELATION = ROOT / "certificates" / "degree25_finite_module" / "relation_matrix.npz"
INPUT = HERE / "affine_q0_b1_0_all690.ms"
MANIFEST = HERE / "affine_q0_b1_0_all690.json"
P = 89
NQ = 37


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def term_text(coefficient: int, factors: tuple[str, ...]) -> str:
    monomial = "*".join(factors) if factors else "1"
    return monomial if coefficient == 1 else f"{coefficient}*{monomial}"


def equation(
    row: int,
    m1: list[np.ndarray],
    m2: list[np.ndarray],
    q2: list[tuple[int, ...]],
    q1: list[tuple[int, ...]],
) -> str:
    # Collapse after q0=1 and b1_0=1.  A dictionary also combines terms that
    # become equal under dehomogenization (the source monomials themselves are
    # distinct before the substitution).
    coefficients: dict[tuple[str, ...], int] = defaultdict(int)
    for component, block in enumerate(m1):
        b_factor = () if component == 0 else (f"b1_{component}",)
        for raw, exponent in zip(block[row], q2):
            value = int(raw) % P
            if not value:
                continue
            q_factors: list[str] = []
            for variable, power in enumerate(exponent):
                if variable == 0 or not power:
                    continue
                q_factors.extend([f"q{variable}"] * power)
            key = b_factor + tuple(q_factors)
            coefficients[key] = (coefficients[key] + value) % P
    for component, block in enumerate(m2):
        for raw, exponent in zip(block[row], q1):
            value = int(raw) % P
            if not value:
                continue
            q_factors: list[str] = []
            for variable, power in enumerate(exponent):
                if variable == 0 or not power:
                    continue
                q_factors.extend([f"q{variable}"] * power)
            key = (f"b2_{component}",) + tuple(q_factors)
            coefficients[key] = (coefficients[key] + value) % P
    terms = [
        term_text(value, factors)
        for factors, value in coefficients.items()
        if value % P
    ]
    return "+".join(terms) if terms else "0"


def write_immutable(path: Path, data: bytes) -> None:
    if path.exists():
        if path.read_bytes() != data:
            raise RuntimeError(f"refusing to overwrite mismatching artifact: {path}")
        return
    path.write_bytes(data)


def main() -> None:
    with np.load(RELATION, allow_pickle=False) as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        prime = int(frozen["prime"])
    if prime != P or seeds.shape != (690, 14134):
        raise AssertionError("sealed relation layout mismatch")
    q2 = weak_compositions(2, NQ)
    q1 = weak_compositions(1, NQ)
    m1 = [
        seeds[:, int(offsets[1 + component]) : int(offsets[2 + component])]
        for component in range(6)
    ]
    m2 = [
        seeds[:, int(offsets[7 + component]) : int(offsets[8 + component])]
        for component in range(21)
    ]
    if any(block.shape != (690, 703) for block in m1):
        raise AssertionError("M1 layout mismatch")
    if any(block.shape != (690, 37) for block in m2):
        raise AssertionError("M2 layout mismatch")

    # Put the variables occurring linearly through M2 first.  This is an exact
    # DRL computation regardless of ordering; the choice is only heuristic.
    variables = (
        [f"b2_{component}" for component in range(21)]
        + [f"b1_{component}" for component in range(1, 6)]
        + [f"q{variable}" for variable in range(1, NQ)]
    )
    equations = [equation(row, m1, m2, q2, q1) for row in range(690)]
    if any(polynomial == "0" for polynomial in equations):
        raise AssertionError("unexpected zero affine equation")
    content = (
        ",".join(variables)
        + f"\n{P}\n"
        + ",\n".join(equations)
        + "\n"
    ).encode()
    write_immutable(INPUT, content)

    payload = {
        "status": "PREPARED_NOT_RUN",
        "prime": P,
        "chart": {"q0": 1, "b1_0": 1},
        "equations": 690,
        "variables": variables,
        "variable_count": len(variables),
        "variable_order": "b2_0..b2_20,b1_1..b1_5,q1..q36",
        "source": {"path": str(RELATION), "sha256": sha256(RELATION)},
        "input": {
            "file": INPUT.name,
            "bytes": INPUT.stat().st_size,
            "sha256": sha256(INPUT),
            "immutable_rebuild_match": True,
        },
        "equation_term_counts": {
            "min": min(polynomial.count("+") + 1 for polynomial in equations),
            "max": max(polynomial.count("+") + 1 for polynomial in equations),
            "sum": sum(polynomial.count("+") + 1 for polynomial in equations),
        },
        "criterion": (
            "A completed exact msolve Groebner output [1] proves the affine "
            "chart q0=1,b1_0=1 is empty over the algebraic closure of F_89."
        ),
        "scope": (
            "This is one of 37*6 possible q/b1 flag charts. A nonunit output, "
            "timeout, crash, resource kill, or absent terminal output is a "
            "nonverdict even for this chart."
        ),
    }
    manifest = (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode()
    write_immutable(MANIFEST, manifest)
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()

