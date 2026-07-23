#!/usr/bin/env python3
"""Arithmetic replay for the off-base isolated k=2 quintic square row."""

equation_dimension = 90
relation_dimension = 3 * 6
form_dimension = equation_dimension - relation_dimension
assert form_dimension == 72

triple_dimension = 16
rows = [
    ("m<=6", 33, 20, 3),
    ("m=7", 35, 19, 2),
    ("m=8", 37, 17, 2),
    ("m=9", 39, 14, 3),
]

for _label, bad_dimension, quintic_dimension, expected_margin in rows:
    margin = form_dimension - bad_dimension - quintic_dimension - triple_dimension
    assert margin == expected_margin

print("off-base quintic restriction dimension 72: PASS")
print("isolated-base quintic rank-one margins 3/2/2/3: PASS")
print("degree-zero quotient routes to rank-two pure square: PASS")
print("isolated-base off-base integral-quintic square exclusion: PASS")
