#!/usr/bin/env python3
"""Build a complete higher-degree matched-Fano coefficient system at p=23."""

from __future__ import annotations

import argparse
import importlib.util
import json
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "tmp" / "fano14_degree12" / "degree12_msolve.py"
P = 23
EXPECTED_DIMENSIONS = {18: 121, 19: 142, 20: 172}


def load_pipeline():
    spec = importlib.util.spec_from_file_location("higher_degree_fano_pipeline", SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--degree", type=int, choices=sorted(EXPECTED_DIMENSIONS), required=True)
    parser.add_argument("--extra-points", type=int, default=500)
    args = parser.parse_args()
    assert args.extra_points >= 300
    degree = args.degree
    dimension = EXPECTED_DIMENSIONS[degree]
    pipeline = load_pipeline()
    scanner_module = pipeline.load_scanner_module()
    scanner = scanner_module.Scanner()
    # The historical scanner uses ten 10-coordinate evaluation blocks, so
    # its discovery matrix has rank at most 100.  Higher degrees need more
    # deterministic blocks before Reynolds seed selection.
    required_selection_points = (dimension + 9) // 10 + 4
    while len(scanner.selection_points) < required_selection_points:
        scanner.selection_points.append(
            scanner.rng.integers(0, P, size=5, dtype=scanner.selection_points[0].dtype)
        )
    seeds = scanner.covariant_basis(degree)
    assert len(seeds) == dimension, (len(seeds), dimension)
    print(f"covariantDimension={len(seeds)}", flush=True)
    equations = scanner.landing_equations(seeds, extra_points=args.extra_points)
    rows = [row for _pivot, row in equations]
    pairs = tuple(pipeline.quadratic_pairs(dimension))
    polynomials = [pipeline.polynomial(row, pairs) for row in rows]
    stem = f"degree{degree}_fano_p23"
    source = HERE / f"{stem}.in"
    source.write_text(
        ",".join(f"a{index}" for index in range(dimension))
        + f"\n{P}\n"
        + ",\n".join(polynomials)
        + "\n"
    )
    metadata = {
        "format": f"degree{degree}-matched-fano-input-p23-v1",
        "scope": f"complete degree-{degree} homogeneous polynomial covariant space",
        "prime": P,
        "degree": degree,
        "covariant_dimension": len(seeds),
        "quadratic_monomial_count": len(pairs),
        "landing_equation_rank": len(equations),
        "extra_evaluation_points": args.extra_points,
        "covariant_selection_point_count": len(scanner.selection_points),
        "seed_labels": [
            {"output": int(seed.output), "exponents": list(seed.exponents)} for seed in seeds
        ],
        "input_file": source.name,
        "theorem_boundary": "the input alone gives no projective-scheme verdict",
    }
    output = HERE / f"{stem}.json"
    output.write_text(json.dumps(metadata, indent=2) + "\n")
    print(f"landingEquationRank={len(equations)} inputBytes={source.stat().st_size}")
    print(f"WROTE {source} and {output}")
    print(f"DEGREE{degree}-MATCHED-FANO-INPUT-BUILT")


if __name__ == "__main__":
    main()
