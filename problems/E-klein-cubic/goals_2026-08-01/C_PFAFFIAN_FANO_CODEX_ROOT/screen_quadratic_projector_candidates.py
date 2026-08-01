#!/usr/bin/env python3
"""Screen one-prime Q(c) coefficient guesses at unused split primes."""

from __future__ import annotations

import json
import runpy
from itertools import combinations
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PRIMES = ((67, 9), (89, 2))


def period(zeta: int, prime: int) -> int:
    return sum(pow(zeta, exponent, prime) for exponent in (1, 3, 4, 5, 9)) % prime


def pluecker_zero(values, pair_index, prime) -> bool:
    for i, j, k, ell in combinations(range(6), 4):
        residual = (
            values[pair_index[(i, j)]] * values[pair_index[(k, ell)]]
            - values[pair_index[(i, k)]] * values[pair_index[(j, ell)]]
            + values[pair_index[(i, ell)]] * values[pair_index[(j, k)]]
        ) % prime
        if residual:
            return False
    return True


def main() -> None:
    pairing = json.loads((HERE / "ambient_degree12_pairing_p23.json").read_text())
    candidates = []
    for row in pairing["pairings"]:
        for branch in row["branches"]:
            candidates.append({
                "permutation": row["permutation"],
                "branch": branch["first_index"],
                "coefficients": branch["coefficients_A_plus_Bc_centered"],
                "passes": [],
            })

    rng = np.random.default_rng(20260801)
    for prime, zeta in PRIMES:
        namespace = runpy.run_path(str(ROOT / "tmp/pfaffian_rank2_idempotent_attack/full_wedge.py"))
        live = namespace["FullWedgeScanner"].__init__.__globals__
        fano_live = live["fano"]["six_dimensional_generators"].__globals__
        live["P"] = prime
        fano_live["P"] = prime
        fano_live["ZETA"] = zeta
        scanner = namespace["FullWedgeScanner"]()
        metadata = json.loads((HERE / f"ambient_degree12_p{prime}.json").read_text())
        seeds = [(row[0], tuple(row[1])) for row in metadata["seeds"]]
        c = period(zeta, prime)
        points = [rng.integers(0, prime, size=5, dtype=np.int64) for _ in range(16)]
        evaluation_matrices = [
            np.stack([scanner.evaluate_seed(output, exponents, point) for output, exponents in seeds])
            for point in points
        ]
        for candidate in candidates:
            coefficient_vector = np.array(
                [(a + b * c) % prime for a, b in candidate["coefficients"]],
                dtype=np.int64,
            )
            passed = True
            for values in evaluation_matrices:
                wedge = coefficient_vector @ values % prime
                if not np.any(wedge) or not pluecker_zero(wedge, live["fano"]["PAIR_INDEX"], prime):
                    passed = False
                    break
            candidate["passes"].append({"prime": prime, "zeta11": zeta, "passed": passed})

    survivors = [
        candidate for candidate in candidates
        if all(check["passed"] for check in candidate["passes"])
    ]
    payload = {
        "format": "small-quadratic-projector-screen-v1",
        "scope": "finite screen of centered p23 coefficient guesses only",
        "candidates_tested": len(candidates),
        "test_primes": [row[0] for row in PRIMES],
        "survivors": survivors,
        "all_candidates": candidates,
        "theorem_boundary": (
            "rejection excludes only centered one-prime guesses; survival would "
            "still require exact characteristic-zero expansion and substitution"
        ),
    }
    (HERE / "small_quadratic_projector_screen.json").write_text(
        json.dumps(payload, indent=2) + "\n"
    )
    print(json.dumps({
        "candidates_tested": len(candidates),
        "survivors": len(survivors),
    }, indent=2))
    print("SMALL-QUADRATIC-PROJECTOR-CANDIDATES-SCREENED")


if __name__ == "__main__":
    main()
