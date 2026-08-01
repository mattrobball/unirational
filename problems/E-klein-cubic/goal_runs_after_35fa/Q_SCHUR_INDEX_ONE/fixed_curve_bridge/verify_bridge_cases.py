#!/usr/bin/env python3
"""Independent scope check for the fixed-curve implication ledger."""

import json
from pathlib import Path
import subprocess
import sys


payload = json.loads(Path(__file__).with_name("bridge_cases.json").read_text())

assert payload["status"] == "Q-UNDECIDED"
assert "actual_degree_three_genus_zero_stable_map_over_K" in payload["decisive_outputs"]
assert "actual_generalized_twisted_cubic_hilbert_point_over_K" in payload["decisive_outputs"]
assert "coarse_stable_map_point_without_verified_lift" in payload["nondecisive_outputs"]
assert "virtual_gromov_witten_count" in payload["nondecisive_outputs"]

gate = payload["conditional_c3_gate"]
assert gate["parameter_space"] == "fine_hilbert_scheme"
assert gate["finite_scheme_length"] == 8
assert gate["splitting_group"] == "C3"
assert gate["finite_scheme_length"] % 3 != 0
assert gate["currently_verified"] is False

fixed_replay = subprocess.run(
    [sys.executable, "-u", str(Path(__file__).with_name("verify_fixed_jacobian.py"))],
    check=True,
    text=True,
    stdout=subprocess.PIPE,
    stderr=subprocess.STDOUT,
)
assert "KLEIN_JACOBIAN_COMMON_FIXED_SUBGROUP_TRIVIAL" in fixed_replay.stdout
print(fixed_replay.stdout, end="")

assert payload["marker"] == "Q_SCHUR_FIXED_CURVE_BRIDGE_EXACT"
print(payload["marker"])
