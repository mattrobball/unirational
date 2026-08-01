#!/usr/bin/env python3
"""Independently audit exact Reynolds basis and zero-module manifests."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
EXPECTED = {25: (189, 3, 7), 31: (410, 5, 1), 35: (637, 5, 5)}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    ranking = json.loads((HERE / "degree_ranking.json").read_text())
    ranked = {item["degree"]: item for item in ranking["ranking"]}
    summary = json.loads((HERE / "global_module_summary.json").read_text())
    assert len(summary["selected_pairs"]) == len(EXPECTED)

    for degree, (dimension, plane_order, residual) in EXPECTED.items():
        directory = HERE / f"degree_{degree}"
        seeds = json.loads((directory / "covariant_basis_seeds.json").read_text())
        basis = json.loads((directory / "basis_manifest.json").read_text())
        candidate = json.loads((directory / "candidate.json").read_text())
        p67 = json.loads((directory / "global_jets_p67.json").read_text())
        p89 = json.loads((directory / "global_jets_p89.json").read_text())

        assert len(seeds) == dimension == ranked[degree]["self_covariant_dimension"]
        labels = set()
        for item in seeds:
            assert 0 <= item["output"] < 5
            exponents = tuple(item["exponents"])
            assert len(exponents) == 5 and min(exponents) >= 0
            assert sum(exponents) == degree
            label = (item["output"], exponents)
            assert label not in labels
            labels.add(label)
        assert basis["seed_payload_sha256"] == sha256(
            directory / "covariant_basis_seeds.json"
        )
        assert basis["basis_dimension"] == basis["molien_dimension"] == dimension
        assert basis["independent_holdout_basis_rank"] == {
            "prime": 89,
            "rank": dimension,
            "zeta11": 78,
        }

        assert (p67["plane_order"], p67["residual_degree"]) == (
            plane_order,
            residual,
        )
        assert p67["orders"] == p89["orders"]
        inputs = [item["input_dimension"] for item in p89["orders"]]
        kernels = [item["kernel_dimension"] for item in p89["orders"]]
        ranks = [item["jet_rank"] for item in p89["orders"]]
        assert inputs[0] == dimension
        assert all(inputs[index] == kernels[index - 1] for index in range(1, len(inputs)))
        assert all(left == rank + kernel for left, rank, kernel in zip(inputs, ranks, kernels))
        assert kernels[-1] == 0 and sum(ranks) == dimension

        with np.load(directory / "global_jet_kernels_p67.npz") as archive:
            assert archive["kernel_before_order_0"].shape == (dimension, dimension)
            for order, kernel_dimension in enumerate(kernels):
                assert archive[f"kernel_after_order_{order}"].shape == (
                    kernel_dimension,
                    dimension,
                )

        assert candidate["candidate"] is None
        assert candidate["decision"] == "EMPTY_BEFORE_LANDING"
        assert candidate["characteristic_zero_global_module_dimension"] == 0
        assert candidate["primitive_quotient_dimension"] == 0
        assert candidate["landing_equations_after_linear_elimination"] == 0
        print(f"verified exact basis and selected zero module d={degree}", flush=True)

    source_manifest = json.loads((HERE / "SOURCE_MANIFEST.json").read_text())
    for relative, digest in source_manifest["sources"].items():
        assert sha256(PROBLEM / relative) == digest
    print("COV_MANIFESTS_VERIFIED")


if __name__ == "__main__":
    main()
