#!/usr/bin/env python3
"""Probe the nested D_12 + <p_0,...,p_(k-1)> landing slices.

This maps the first support size at which the sampled degree-12 landing
scheme ceases to be projectively empty.  It is a candidate-discovery tool;
only a verified nonzero coefficient vector can contribute to the headline.
"""

from __future__ import annotations

import argparse
import json
from math import comb
from pathlib import Path

import degree12_triple_slices as slices


HERE = Path(__file__).resolve().parent
OUTPUTS = HERE / "degree12_nested_outputs"
SUMMARY = HERE / "degree12_nested_results.json"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--start-size", type=int, default=4)
    parser.add_argument("--stop-size", type=int, default=8)
    parser.add_argument("--timeout", type=int, default=300)
    parser.add_argument("--threads", type=int, default=2)
    arguments = parser.parse_args()
    assert 3 <= arguments.start_size < arguments.stop_size <= slices.PRIMITIVE + 1
    assert 1 <= arguments.timeout <= 1800 and 1 <= arguments.threads <= 8
    OUTPUTS.mkdir(exist_ok=True)
    slices.OUTPUTS = OUTPUTS
    prior = json.loads(SUMMARY.read_text()) if SUMMARY.is_file() else {"results": []}
    result_map = {value["primitive_count"]: value for value in prior["results"]}
    metadata, outputs, cubic, tensor = slices.global_outputs()
    for size in range(arguments.start_size, arguments.stop_size):
        if result_map.get(size, {}).get("status") in {
            "empty", "nonempty_or_inconclusive"
        }:
            print(f"primitiveCount={size} SKIP", flush=True)
            continue
        selection = tuple(range(size))
        slices.DIMENSION = slices.OLD + size
        slices.CUBICS = comb(slices.DIMENSION + 2, 3)
        rows, monomial_basis = slices.slice_rows(
            outputs, cubic, tensor, selection
        )
        result = slices.solve_slice(
            rows, monomial_basis, size, selection,
            arguments.timeout, arguments.threads,
        )
        result["primitive_count"] = size
        result["primitive_selection"] = list(selection)
        result["slice_dimension"] = slices.DIMENSION
        result["coefficient_cubic_monomials"] = slices.CUBICS
        result_map[size] = result
        prior = {
            "field_characteristic": slices.P,
            "basis": "16 multiplication-span plus initial primitive Reynolds seeds",
            "sample_count": metadata["sample_count"],
            "logical_scope": (
                "empty has only nested-slice scope; nonempty is a discovery "
                "signal pending complete special-fibre and characteristic-zero checks"
            ),
            "results": [result_map[index] for index in sorted(result_map)],
        }
        SUMMARY.write_text(json.dumps(prior, indent=2) + "\n")
        print(
            f"primitiveCount={size} dimension={slices.DIMENSION} "
            f"rank={result['rank']} status={result['status']} "
            f"seconds={result['seconds']:.3f}",
            flush=True,
        )
        if result["status"] != "empty":
            break


if __name__ == "__main__":
    main()
