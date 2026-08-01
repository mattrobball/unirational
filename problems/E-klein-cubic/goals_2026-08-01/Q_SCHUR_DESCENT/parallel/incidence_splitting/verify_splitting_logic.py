#!/usr/bin/env python3
"""Arithmetic and scope replay for the incidence splitting-field report."""

from pathlib import Path


report = Path(__file__).with_name("REPORT.md").read_text()

hilbert_dimension = 6
marked_dimension = hilbert_dimension + 3
target_dimension = 3 * 3
generic_degree = 8

assert marked_dimension == target_dimension == 9
assert generic_degree % 3 == 2
assert generic_degree == 2 + 6
for phrase in (
    "one field extension of degree eight",
    "does not split",
    "new Schur-specific theorem",
    "No such theorem is present",
):
    assert phrase in report

print("Q_SCHUR_INCIDENCE_SPLITTING_BOUNDARY_EXACT")
