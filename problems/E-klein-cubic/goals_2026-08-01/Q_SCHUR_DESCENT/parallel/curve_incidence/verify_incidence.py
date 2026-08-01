#!/usr/bin/env python3
"""Independent arithmetic and logical-scope verifier for the incidence audit."""

import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
DATA = json.loads((HERE / "incidence_certificate.json").read_text())

# Invariants without the extra divisor insertion.  On journal page 1058,
# Zinger displays the degree-2 and degree-3 values through the chains
# <H3,H3>=(1/2)<H3,H3,H>=108/2 and
# <H3,H3,H3>=(1/3)<H3,H3,H3,H>=648/3.
SOURCE_RAW = {1: 18, 2: 54, 3: 216, 4: 15552}
SOURCE_WITH_EXTRA_H = {2: 108, 3: 648}
SOURCE_ENUMERATIVE = {1: True, 2: True, 3: True, 4: False}

assert DATA["geometry"]["integral_H_cubed"] == 3
rows = {row["degree"]: row for row in DATA["point_counts"]}
assert set(rows) == set(SOURCE_RAW)

for degree, raw in SOURCE_RAW.items():
    row = rows[degree]
    assert row["number_of_point_insertions"] == degree
    divisor = 3 ** degree
    assert row["raw_H3_invariant"] == raw
    assert row["normalization_divisor"] == divisor
    assert raw % divisor == 0
    assert row["point_normalized_invariant"] == raw // divisor
    assert row["enumerative_in_source"] is SOURCE_ENUMERATIVE[degree]
    # vdim = 2d+n and d point insertions have total codimension 3d.
    assert 2 * degree + degree - 3 * degree == 0

for degree, augmented in SOURCE_WITH_EXTRA_H.items():
    row = rows[degree]
    assert row["divisor_equation_factor"] == degree
    assert row["displayed_divisor_augmented_invariant"] == augmented
    assert row["raw_H3_invariant"] * degree == augmented

assert rows[2]["point_normalized_invariant"] == 6
assert rows[3]["point_normalized_invariant"] == 8
assert rows[4]["point_normalized_invariant"] == 192
assert math.gcd(8, 192) == DATA["combined_gcd_of_candidate_counts"] == 8

tests = DATA["descent_tests"]
quartic = next(t for t in tests if t["cycle"] == "primitive quartic point")
resolvent = next(t for t in tests if t["cycle"] == "cubic-resolvent point")

# Divisibility by the full group order exhibits a fixed-point-free action:
# a disjoint union of regular orbits of the stated multiplicity.
assert quartic["candidate_count"] == 192
assert [192 // order for order in quartic["group_orders"]] == [16, 8]
assert all(192 % order == 0 for order in quartic["group_orders"])
assert resolvent["candidate_count"] == 8
# For C3, every nonfixed orbit has size 3; 8 mod 3 forces fixed points.
assert 8 % 3 == 2
assert resolvent["fixed_curve_forced_if_action_factors_through_cycle_galois_group"]["C3"] is True
# For S3, indices 2 and 6 occur and 8=2+6 gives a fixed-point-free model.
assert 8 == 2 + 6
assert resolvent["fixed_curve_forced_if_action_factors_through_cycle_galois_group"]["S3"] is False

assert quartic["fixed_curve_forced_by_count"] is False
assert resolvent["fixed_curve_forced_unconditionally"] is False
assert DATA["conclusions"]["goal_resolved"] is False
assert DATA["headline"] == "Q-UNDECIDED"

print("Q_SCHUR_CURVE_INCIDENCE_ARITHMETIC_REPLAY_OK")
print(DATA["conclusions"]["marker"])
