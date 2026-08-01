#!/usr/bin/env python3
"""Exact special-fibre landing equations for V6 self-covariants into I4=0."""

from __future__ import annotations

import argparse
import importlib.util
import json
import sys
from math import factorial
from pathlib import Path

import numpy as np

HERE = Path(__file__).resolve().parent
PROBE_SRC = HERE / "probe_self_covariants_palatinian.py"
spec = importlib.util.spec_from_file_location("self_probe_core", PROBE_SRC)
assert spec and spec.loader
core = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = core
spec.loader.exec_module(core)

P = core.P
EXPECTED = {1: 1, 3: 1, 5: 3, 7: 8, 9: 19}


def multinomial(alpha: tuple[int, ...]) -> int:
    answer = factorial(sum(alpha))
    for e in alpha:
        answer //= factorial(e)
    return answer


def rank_add(echelon: list[tuple[int, np.ndarray]], row: np.ndarray) -> bool:
    return core.add_row(echelon, row)


def build(degree: int, samples: int, stagnant_limit: int) -> None:
    probe = core.Probe()
    basis = probe.basis(degree, EXPECTED[degree])
    n = len(basis)
    coeff_monomials = core.monomials(4, n)
    factors = np.asarray([multinomial(a) for a in coeff_monomials], dtype=np.int64)
    echelon: list[tuple[int, np.ndarray]] = []
    accepted_points = []
    rng = np.random.default_rng(2026080103 + degree)
    stagnant = 0
    for sample in range(samples):
        x = rng.integers(0, P, 6, dtype=np.int64)
        values = np.stack([probe.eval_seed(*seed, x) for seed in basis])  # n x 6
        transformed = np.einsum("gij,nj->gni", probe.group, values, optimize=True) % P
        linear = transformed[:, :, 5]  # 1320 x n
        row = np.zeros(len(coeff_monomials), dtype=np.int64)
        for column, alpha in enumerate(coeff_monomials):
            terms = np.ones(len(linear), dtype=np.int64)
            for i, exponent in enumerate(alpha):
                if exponent:
                    terms = terms * np.power(linear[:, i], exponent) % P
            row[column] = int(np.sum(terms, dtype=np.int64) % P) * factors[column] % P
        if rank_add(echelon, row):
            accepted_points.append([int(v) for v in x])
            stagnant = 0
        else:
            stagnant += 1
        if sample % 25 == 0 or stagnant >= stagnant_limit:
            print(f"degree={degree} sample={sample+1} rank={len(echelon)}/{len(coeff_monomials)} stagnant={stagnant}", flush=True)
        if len(echelon) == len(coeff_monomials) or stagnant >= stagnant_limit:
            break
    rows = np.stack([row for _, row in echelon]).astype(np.uint8)
    np.savez_compressed(HERE / f"self_pal_d{degree}_rows.npz", rows=rows)
    pure_power_membership = {}
    for i in range(n):
        target = np.zeros(len(coeff_monomials), dtype=np.int64)
        alpha = tuple(4 if j == i else 0 for j in range(n))
        target[coeff_monomials.index(alpha)] = 1
        remainder = target
        for pivot, row in echelon:
            if remainder[pivot]:
                remainder = (remainder - remainder[pivot] * row) % P
        pure_power_membership[f"a{i}^4"] = not bool(np.any(remainder))
    payload = {
        "prime": P,
        "degree": degree,
        "basis": [[o, list(e)] for o, e in basis],
        "coefficient_dimension": n,
        "quartic_monomial_count": len(coeff_monomials),
        "equation_rank": len(echelon),
        "accepted_points": accepted_points,
        "full_quartic_span": len(echelon) == len(coeff_monomials),
        "pure_power_membership": pure_power_membership,
    }
    (HERE / f"self_pal_d{degree}.json").write_text(json.dumps(payload, indent=2) + "\n")
    print(json.dumps({k:v for k,v in payload.items() if k != "accepted_points"}, indent=2))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("degree", type=int, choices=sorted(EXPECTED))
    parser.add_argument("--samples", type=int, default=500)
    parser.add_argument("--stagnant", type=int, default=80)
    args = parser.parse_args()
    build(args.degree, args.samples, args.stagnant)


if __name__ == "__main__":
    main()
