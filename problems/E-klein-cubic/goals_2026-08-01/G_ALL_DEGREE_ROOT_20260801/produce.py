#!/usr/bin/env python3
"""Reconstruct the two line-constant coefficient systems as JSON."""

from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
SOURCE = PROBLEM / "tmp" / "symbolic_compatibility_complex" / "line_landing_bigraded.py"


def main() -> None:
    spec = importlib.util.spec_from_file_location("goal_g_root_producer", SOURCE)
    assert spec and spec.loader
    source = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = source
    spec.loader.exec_module(source)
    reynolds = source.audit.load(source.audit.REYNOLDS, "goal_g_root_prod_reynolds")
    module = reynolds.load_reynolds_module()
    source.base.module_global = module
    _, records = source.line_records(module)
    rng = np.random.default_rng(20260801)
    cases = []
    for order, degree in ((1, 3), (3, 6)):
        record, rows = source.compute_case(module, records, order, degree, 0, rng)
        cases.append(
            {
                "symbolic_order": order,
                "transverse_degree": degree,
                "parameter_dimension": record["equivariant_parameter_dimension"],
                "coefficient_rows_mod_67": rows.tolist(),
            }
        )
    print(json.dumps({"prime": 67, "line_degree": 0, "cases": cases}, indent=2))


if __name__ == "__main__":
    main()
