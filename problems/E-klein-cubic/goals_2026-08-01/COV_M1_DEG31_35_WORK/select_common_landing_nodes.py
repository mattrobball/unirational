#!/usr/bin/env python3
"""Select one degree-35 invariant node minor valid at both holdout primes."""

from __future__ import annotations

import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402
import produce_landing_ideal as landing  # noqa: E402


DEGREE = 35
INVARIANT_DIMENSION = 8555
CANDIDATE_COUNT = INVARIANT_DIMENSION + 256
RNG_SEED = 202608020105463


def main() -> None:
    candidates = landing.fixed_nodes(CANDIDATE_COUNT)
    rng = np.random.default_rng(RNG_SEED)
    permutation = rng.permutation(CANDIDATE_COUNT)

    nodes419 = candidates % 419
    labels, matrix419 = landing.invariant_evaluation_matrix(
        nodes419, 3 * DEGREE, 419
    )
    assert len(labels) == INVARIANT_DIMENSION
    profile = basis.rank_profile(matrix419[permutation], 419)
    assert len(profile) == INVARIANT_DIMENSION
    selected = permutation[profile[:INVARIANT_DIMENSION]]
    determinant419 = landing.determinant_mod(matrix419[selected], 419)
    assert determinant419
    del matrix419
    print(f"common-node det419={determinant419}", flush=True)

    nodes463 = candidates[selected] % 463
    labels463, matrix463 = landing.invariant_evaluation_matrix(
        nodes463, 3 * DEGREE, 463
    )
    assert labels463 == labels
    determinant463 = landing.determinant_mod(matrix463, 463)
    assert determinant463, (
        "deterministic randomized basis missed the common open; change RNG_SEED"
    )
    print(f"common-node det463={determinant463}", flush=True)

    path = HERE / "degree_35" / "landing_node_selection.json"
    path.write_text(json.dumps({
        "schema": "cov-m1-fixed-landing-node-selection-v1",
        "degree": DEGREE,
        "candidate_count": CANDIDATE_COUNT,
        "node_rule": "fixed_nodes from produce_landing_ideal.py",
        "selection_rule": "row profile after fixed RNG permutation at prime 419",
        "selection_prime": 419,
        "rng_seed": RNG_SEED,
        "selected_candidate_rows": selected.tolist(),
        "determinant_residues": {"419": determinant419, "463": determinant463},
    }, indent=2, sort_keys=True) + "\n")
    print("COV_M1_COMMON_LANDING_NODES_SELECTED", flush=True)


if __name__ == "__main__":
    main()
