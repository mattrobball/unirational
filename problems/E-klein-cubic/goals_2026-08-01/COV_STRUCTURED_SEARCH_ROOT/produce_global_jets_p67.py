#!/usr/bin/env python3
"""Build complete global representative-plane jet kernels over split F_67.

The seed labels are characteristic-zero Reynolds circuits.  This producer
uses the established split-fibre arithmetic only for rank discovery and for
compact kernel payloads; the independent non-67 holdout lives in
``verify_global_jets_holdout.py``.
"""

from __future__ import annotations

import argparse
import importlib.util
import json
import math
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PRIME = 67
SELECTED = {25: (3, 7), 31: (5, 1), 35: (5, 5)}


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


jets = load(
    "cov_structured_upstream_jets",
    PROBLEM / "tmp" / "symbolic_compatibility_complex" / "jet_scan.py",
)


def seed_records(degree: int, dimension: int, module):
    own = HERE / f"degree_{degree}" / "covariant_basis_seeds.json"
    if own.exists():
        records = json.loads(own.read_text())
    elif degree == 25:
        records = json.loads(
            (PROBLEM / "tmp" / "degree25_structural_probe" / "seeds.json").read_text()
        )
    elif degree == 35:
        records = json.loads(
            (
                PROBLEM
                / "tmp"
                / "m1_t1_f3_colon_degree35_audit"
                / "ambient_seeds_35.json"
            ).read_text()
        )
    else:
        rng = np.random.default_rng(202608013100 + degree)
        module.SELECTION_POINTS = [
            rng.integers(0, PRIME, size=5, dtype=np.int64)
            for _ in range(max(32, math.ceil(dimension / 5) + 4))
        ]
        selected = module.covariant_basis(degree, dimension)
        records = [
            {"output": int(seed.output), "exponents": list(map(int, seed.exponents))}
            for seed in selected
        ]
    assert len(records) == dimension
    own.parent.mkdir(parents=True, exist_ok=True)
    own.write_text(json.dumps(records, indent=2, sort_keys=True) + "\n")
    return [
        module.ReynoldsSeed(int(item["output"]), tuple(map(int, item["exponents"])))
        for item in records
    ]


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("degree", type=int, choices=tuple(SELECTED))
    args = parser.parse_args()
    degree = args.degree
    plane_order, residual = SELECTED[degree]
    dimension = jets.d12.covariant_dimension(degree)

    reynolds = jets.audit.load(
        jets.audit.REYNOLDS, f"cov_structured_reynolds_{degree}"
    )
    module = reynolds.load_reynolds_module()
    _, _, _, _, plus, minus, _, _ = jets.d12.adapted_d12_basis(module)
    seeds = seed_records(degree, dimension, module)

    rng = np.random.default_rng(202608016700 + degree)
    selection_points = np.array(
        [
            rng.integers(0, PRIME, size=5, dtype=np.int64)
            for _ in range(math.ceil(dimension / 5) + 10)
        ],
        dtype=np.int64,
    )
    basis_rank = jets.audit.rank(
        jets.audit.batch_seed_evaluations(module, seeds, selection_points, degree)
    )
    assert basis_rank == dimension

    remaining = np.eye(dimension, dtype=np.int64)
    arrays = {"kernel_before_order_0": remaining}
    records = []
    for order in range(plane_order):
        seed_map = jets.higher_jet_seed_matrix(
            module, seeds, plus, minus, degree, order
        )
        restricted = seed_map @ remaining.T % PRIME
        rank = jets.audit.rank(restricted)
        relative_kernel = jets.nullspace_matrix(restricted)
        remaining = relative_kernel @ remaining % PRIME
        arrays[f"kernel_after_order_{order}"] = remaining
        record = {
            "order": order,
            "input_dimension": int(restricted.shape[1]),
            "jet_rank": int(rank),
            "kernel_dimension": int(len(remaining)),
            "unisolvent_rows": int(seed_map.shape[0]),
        }
        records.append(record)
        print(
            f"p=67 d={degree} jet={order} input={record['input_dimension']} "
            f"rank={rank} kernel={len(remaining)}",
            flush=True,
        )
        if not len(remaining):
            break

    directory = HERE / f"degree_{degree}"
    np.savez_compressed(directory / "global_jet_kernels_p67.npz", **arrays)
    payload = {
        "schema": "COV_GLOBAL_JETS_SPLIT_FIBRE_V1",
        "prime": PRIME,
        "degree": degree,
        "plane_order": plane_order,
        "residual_degree": residual,
        "self_covariant_dimension": dimension,
        "basis_rank": basis_rank,
        "reynolds_seed_count": len(seeds),
        "orders": records,
        "selected_symbolic_kernel_dimension": int(len(remaining)),
        "scope": (
            "complete global G-covariants with common symbolic plane order; "
            "globality makes all line, point, C3 and elliptic incidence identities automatic"
        ),
    }
    (directory / "global_jets_p67.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(f"COV_GLOBAL_JETS_P67_PRODUCED degree={degree}")


if __name__ == "__main__":
    main()
