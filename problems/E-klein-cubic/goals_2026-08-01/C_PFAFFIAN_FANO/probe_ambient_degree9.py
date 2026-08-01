#!/usr/bin/env python3
"""Targeted degree-nine search for the guaranteed ambient Morita projector."""

from __future__ import annotations

import json
import runpy
import argparse
from hashlib import sha256
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--degree", type=int, default=9)
    args = parser.parse_args()
    degree = args.degree
    fw = runpy.run_path(str(ROOT / "tmp" / "pfaffian_rank2_idempotent_attack" / "full_wedge.py"))
    scanner = fw["FullWedgeScanner"]()
    seeds = scanner.covariant_basis(degree)
    print(f"degree{degree} covariant dimension={len(seeds)}", flush=True)
    equations = scanner.landing_equations(seeds, extra_points=180)
    rows = [row for _pivot, row in equations]
    empty, kernel_dimension, minor_rank, all_kernel_quadratics = scanner.small_kernel_empty(equations, len(seeds))
    record = {
        "scope": "degree-nine ambient Grassmannian landing probe only",
        "prime": 23,
        "degree": degree,
        "dimension": len(seeds),
        "seeds": [[int(output), list(exponents)] for output, exponents in seeds],
        "quadratic_rank": len(rows),
        "quadratic_row_sha256": sha256(bytes(np.stack(rows).astype(np.uint8).flat)).hexdigest(),
        "veronese_kernel_dimension": kernel_dimension,
        "rank_one_minor_span": [minor_rank, all_kernel_quadratics],
        "small_kernel_empty": bool(empty),
        "theorem_boundary": "an ambient decomposable covariant is only a Morita projector, not a point of the five-hyperplane Fano section",
    }
    (HERE / f"ambient_degree{degree}.in").write_text(fw["msolve_input"](rows, len(seeds)))
    (HERE / f"ambient_degree{degree}_probe.json").write_text(json.dumps(record, indent=2) + "\n")
    print(json.dumps({key: value for key, value in record.items() if key != "seeds"}, indent=2))


if __name__ == "__main__":
    main()
