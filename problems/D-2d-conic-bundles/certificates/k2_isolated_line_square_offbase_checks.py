#!/usr/bin/env python3
"""Replay for squared lines disjoint from an isolated quadratic base."""

target_dimension = 6 * (15 - 6) - 3 * (6 - 1)
assert target_dimension == 39

balanced_pair_dimension = 16 + 2
assert target_dimension - 20 - balanced_pair_dimension == 1
assert target_dimension - 18 - balanced_pair_dimension == 3
print("isolated-base balanced off-base-line margins are strict: PASS")

unbalanced_pair_dimension = max(16 + 1, 13 + 2)
assert unbalanced_pair_dimension == 17
rows = [
    ("nonboundary", 18, 4),
    ("low diagonal", 15, 7),
    ("high diagonal", 23, -1),
    ("zero leading", 18, 4),
]
for _label, bad_dimension, expected_margin in rows:
    assert target_dimension - bad_dimension - unbalanced_pair_dimension == expected_margin

print("only the unbalanced high-diagonal off-base-line boundary remains: PASS")
print("isolated-base off-base squared-line sharp reduction: PASS")
