#!/usr/bin/env python3
"""Exact arithmetic replay for the base-point-free k=2 quintic theorem."""


def rank_one_stratum(m: int) -> int:
    """Quot tangent bound plus the line-of-values section bound."""
    return max(11 - 2 * m, 0) + max(2 * m + 21, 0)


assert max(rank_one_stratum(m) for m in range(-10, 7)) == 33
assert [rank_one_stratum(m) for m in range(7, 11)] == [35, 37, 39, 41]
assert [10 - m for m in range(7, 11)] == [3, 2, 1, 0]
print("quintic rank-one strata and quotient degrees: PASS")

# The standard equigeneric bound for integral plane quintics is
# dim <= 20 - delta = 14 + geometric_genus.
assert [14 + genus for genus in (5, 3, 0)] == [19, 17, 14]
print("quintic equigeneric dimensions: PASS")

quadratic_form_dimension = 72
triple_dimension = 17
rows = [
    ("m<=6", 33, 20, 2),
    ("m=7", 35, 19, 1),
    ("m=8", 37, 17, 1),
    ("m=9", 39, 14, 2),
]
for _label, bad_dimension, quintic_dimension, expected_margin in rows:
    margin = (
        quadratic_form_dimension
        - bad_dimension
        - quintic_dimension
        - triple_dimension
    )
    assert margin == expected_margin

print("all four moving-incidence margins are strict: PASS")
print("base-point-free k=2 integral-quintic component exclusion: PASS")
