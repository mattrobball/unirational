#!/usr/bin/env python3
"""Reconstruct the two finite first-layer systems and print their rows.

This producer reads the authoritative Klein matrices and performs Reynolds
projection afresh.  It does not read the retained npz row cache.
"""

from __future__ import annotations

import importlib.util
import json
import sys
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
SOURCE = PROBLEM / "tmp" / "symbolic_compatibility_complex" / "line_landing_bigraded.py"


def load_source():
    spec = importlib.util.spec_from_file_location("goal_g_line_producer", SOURCE)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


def produce() -> dict:
    source = load_source()
    reynolds = source.audit.load(
        source.audit.REYNOLDS, "goal_g_line_producer_reynolds"
    )
    module = reynolds.load_reynolds_module()
    source.base.module_global = module
    _, records = source.line_records(module)
    rng = np.random.default_rng(20260801)
    cases = []
    for order, transverse_degree in ((1, 3), (3, 6)):
        record, rows = source.compute_case(
            module, records, order, transverse_degree, 0, rng
        )
        cases.append(
            {
                "symbolic_order": order,
                "transverse_degree": transverse_degree,
                "parameter_dimension": record["equivariant_parameter_dimension"],
                "coefficient_rows_mod_67": rows.tolist(),
            }
        )
    return {"prime": 67, "line_degree": 0, "cases": cases}


if __name__ == "__main__":
    print(json.dumps(produce(), indent=2, sort_keys=True))
