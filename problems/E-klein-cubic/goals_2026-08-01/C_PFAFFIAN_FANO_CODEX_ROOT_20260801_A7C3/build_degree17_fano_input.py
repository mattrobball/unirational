#!/usr/bin/env python3
"""Build the complete good-fibre degree-17 matched-Fano coefficient system."""

from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SOURCE = ROOT / "tmp" / "fano14_degree12" / "degree12_msolve.py"
P = 23
DEGREE = 17
DIMENSION = 98


def load_pipeline():
    spec = importlib.util.spec_from_file_location("degree17_fano_pipeline", SOURCE)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def main():
    pipeline = load_pipeline()
    scanner_module = pipeline.load_scanner_module()
    scanner = scanner_module.Scanner()
    seeds = scanner.covariant_basis(DEGREE)
    assert len(seeds) == DIMENSION
    print(f"covariantDimension={len(seeds)}", flush=True)
    equations = scanner.landing_equations(seeds, extra_points=350)
    rows = [row for _pivot, row in equations]
    pairs = tuple(pipeline.quadratic_pairs(DIMENSION))
    polynomials = [pipeline.polynomial(row, pairs) for row in rows]
    source = HERE / "degree17_fano_p23.in"
    source.write_text(
        ",".join(f"a{index}" for index in range(DIMENSION))
        + f"\n{P}\n"
        + ",\n".join(polynomials)
        + "\n"
    )
    metadata = {
        "format": "degree17-matched-fano-input-p23-v1",
        "scope": "complete degree-17 homogeneous polynomial covariant space",
        "prime": P,
        "degree": DEGREE,
        "covariant_dimension": len(seeds),
        "quadratic_monomial_count": len(pairs),
        "landing_equation_rank": len(equations),
        "seed_labels": [
            {"output": int(seed.output), "exponents": list(seed.exponents)} for seed in seeds
        ],
        "input_file": source.name,
        "theorem_boundary": "the input alone gives no projective-scheme verdict",
    }
    output = HERE / "degree17_fano_p23.json"
    output.write_text(json.dumps(metadata, indent=2) + "\n")
    print(f"landingEquationRank={len(equations)} inputBytes={source.stat().st_size}")
    print(f"WROTE {source} and {output}")
    print("DEGREE17-MATCHED-FANO-INPUT-BUILT")


if __name__ == "__main__":
    main()
