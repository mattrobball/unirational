#!/usr/bin/env python3
"""Build exact structured homogeneous msolve probes for the p=89 P25 ideal.

The 746-row landing basis has a preferred K^3 | Q K^2 RREF.  Its 56 monic
K^3 rules make the landing algebra finite over F_89[q_0,...,q_36].  Each probe
keeps all 56 rules and a deterministic nested selection of residual rows.  A
probe whose homogeneous leading ideal contains a pure power of every variable
certifies that its projective zero locus is empty; because the probe is a
subsystem of the complete landing ideal, this also certifies complete-fibre
emptiness.

Only sealed artifacts are read.  All output is written beside this script.
"""

from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FM = ROOT / "certificates" / "degree25_finite_module"
P = 89
SEED = 2026080125
PROBE_SIZES = (96, 128, 160, 192, 256)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    """Match the repository's lexicographic weak-composition convention."""
    if parts == 1:
        return [(total,)]
    out: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in weak_compositions(total - first, parts - 1):
            out.append((first,) + tail)
    return out


def order_basis() -> tuple[list[tuple[int, ...]], list[int]]:
    payload = json.loads((FM / "basis_B.json").read_text())
    basis = [tuple(map(int, exp)) for exp in payload["B"]]
    degrees = list(map(int, payload["Bdeg"]))
    assert len(basis) == len(degrees) == 28
    assert degrees == [0] + [1] * 6 + [2] * 21
    return basis, degrees


def monomial_string(qexp: tuple[int, ...], kexp: tuple[int, ...]) -> str:
    factors: list[str] = []
    for i, exponent in enumerate(kexp):
        if exponent:
            factors.append(f"k{i}" if exponent == 1 else f"k{i}^{exponent}")
    for i, exponent in enumerate(qexp):
        if exponent:
            factors.append(f"q{i}" if exponent == 1 else f"q{i}^{exponent}")
    return "*".join(factors) if factors else "1"


def polyvector_string(
    vector: np.ndarray,
    offsets: np.ndarray,
    basis: list[tuple[int, ...]],
    degrees: list[int],
) -> str:
    terms: list[str] = []
    for bi, (kexp, bdeg) in enumerate(zip(basis, degrees)):
        qmonoms = weak_compositions(3 - bdeg, 37)
        block = vector[int(offsets[bi]) : int(offsets[bi + 1])]
        assert len(block) == len(qmonoms)
        for coefficient, qexp in zip(block, qmonoms):
            coefficient = int(coefficient) % P
            if not coefficient:
                continue
            monomial = monomial_string(qexp, kexp)
            terms.append(monomial if coefficient == 1 else f"{coefficient}*{monomial}")
    return "+".join(terms) if terms else "0"


def rule_string(
    kexp: tuple[int, ...],
    tail: np.ndarray,
    offsets: np.ndarray,
    basis: list[tuple[int, ...]],
    degrees: list[int],
) -> str:
    lead = monomial_string((0,) * 37, kexp)
    tail_text = polyvector_string(tail, offsets, basis, degrees)
    return lead if tail_text == "0" else f"{lead}+{tail_text}"


def main() -> None:
    HERE.mkdir(parents=True, exist_ok=True)
    basis, degrees = order_basis()
    with np.load(FM / "rewrite_rules.npz") as frozen:
        k_exponents = frozen["k_exp"].astype(np.int16)
        tails = frozen["tail_F3"].astype(np.uint8)
        offsets = frozen["off3"].astype(np.int32)
        assert int(frozen["prime"]) == P
    with np.load(FM / "relation_matrix.npz") as frozen:
        seeds = frozen["seed_F3"].astype(np.uint8)
        assert np.array_equal(offsets, frozen["off3"])
        assert int(frozen["prime"]) == P

    assert k_exponents.shape == (56, 6)
    assert tails.shape == (56, 14134)
    assert seeds.shape == (690, 14134)
    assert offsets.tolist()[-1] == 14134

    rule_polys = [
        rule_string(tuple(map(int, kexp)), tail, offsets, basis, degrees)
        for kexp, tail in zip(k_exponents, tails)
    ]
    seed_polys = [
        polyvector_string(row, offsets, basis, degrees) for row in seeds
    ]
    assert all(poly != "0" for poly in rule_polys + seed_polys)

    # One permutation makes the systems nested as the size increases.
    rng = np.random.default_rng(SEED)
    residual_order = rng.permutation(690).astype(np.int32)
    variable_order = [f"k{i}" for i in range(6)] + [f"q{i}" for i in range(37)]
    records = []
    for size in PROBE_SIZES:
        residual_count = size - 56
        assert 0 < residual_count <= 690
        selected = residual_order[:residual_count]
        polynomials = rule_polys + [seed_polys[int(i)] for i in selected]
        path = HERE / f"probe_{size:03d}_kfirst.ms"
        path.write_text(
            ",".join(variable_order)
            + f"\n{P}\n"
            + ",\n".join(polynomials)
            + "\n"
        )
        records.append(
            {
                "equations": size,
                "monic_K3_rules": 56,
                "residual_rows": residual_count,
                "residual_indices": selected.tolist(),
                "input": path.name,
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
        )

    metadata = {
        "prime": P,
        "variables": 43,
        "variable_order": variable_order,
        "seed": SEED,
        "systems_are_nested": True,
        "source": {
            "rewrite_rules": str((FM / "rewrite_rules.npz").relative_to(ROOT)),
            "rewrite_rules_sha256": sha256(FM / "rewrite_rules.npz"),
            "tail_F3_sha256": sha256_array(tails),
            "relation_matrix": str((FM / "relation_matrix.npz").relative_to(ROOT)),
            "relation_matrix_sha256": sha256(FM / "relation_matrix.npz"),
            "seed_F3_sha256": sha256_array(seeds),
        },
        "probes": records,
        "logical_scope": (
            "Every probe is a subsystem of the exact 746-row p=89 landing ideal. "
            "Artinian homogeneous quotient for any probe implies empty projective "
            "complete landing fibre. Non-Artinian or incomplete output is inconclusive."
        ),
        "dimensional_floor": {
            "base_projective_dimension_after_monic_K3": 36,
            "minimum_generic_residual_rows_for_expected_emptiness": 37,
            "first_probe_residual_rows": PROBE_SIZES[0] - 56,
        },
    }
    metadata_path = HERE / "probe_metadata.json"
    metadata_path.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(
        "built "
        + ", ".join(
            f"{record['equations']}eq/{record['bytes'] / 2**20:.1f}MiB"
            for record in records
        )
    )
    print(f"metadata_sha256={sha256(metadata_path)}")


if __name__ == "__main__":
    main()
