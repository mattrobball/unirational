#!/usr/bin/env python3
"""Arithmetic checks for the integral-quintic factor exclusion."""

from math import comb


def rank_one_bound(bundle_degree, twist_degree):
    """The genus-free rank-one-cone bound R(f,n)."""
    lower = -(twist_degree // 2)
    values = []
    for line_degree in range(lower, bundle_degree + 1):
        quotient_tangent = max(bundle_degree - 2 * line_degree + 1, 0)
        scalar_section = max(2 * line_degree + twist_degree + 1, 0)
        values.append(quotient_tangent + scalar_section)
    return max(values)


def blowup_h0(plane_degree, exceptional_coefficient):
    """h0(aH+bE) for the small divisors appearing in the proof."""
    if plane_degree < 0:
        return 0
    if exceptional_coefficient >= 0:
        return comb(plane_degree + 2, 2)
    multiplicity = -exceptional_coefficient
    return max(
        comb(plane_degree + 2, 2) - comb(multiplicity + 1, 2),
        0,
    )


rank_one_values = [rank_one_bound(f, 20) for f in range(5, 0, -1)]
assert rank_one_values == [31, 29, 27, 25, 23]
print("quintic rank-one cone bounds: PASS")

rank_three_margin = 60 - rank_one_bound(5, 20) - 20
assert rank_three_margin == 9 > 8
print("rank-three quintic-factor margin: PASS")

# A quintic away from the rank-two base point has zero restriction kernel.
away_kernel = (
    blowup_h0(1, -2)
    + blowup_h0(0, -1)
    + blowup_h0(-1, 0)
)
assert away_kernel == 0
assert 60 - rank_one_bound(5, 20) - 20 == 9 > 7
print("rank-two off-base quintic-factor margin: PASS")

expected_rows = {
    1: ((2, 1, 0), 57, 19, 9),
    2: ((3, 1, 0), 56, 17, 12),
    3: ((3, 1, 0), 56, 14, 17),
    4: ((3, 1, 0), 56, 10, 23),
}
for multiplicity, expected in expected_rows.items():
    kernels = (
        blowup_h0(1, multiplicity - 2),
        blowup_h0(0, multiplicity - 1),
        blowup_h0(-1, multiplicity),
    )
    image_rank = 60 - sum(kernels)
    quintic_dimension = 20 - comb(multiplicity + 1, 2)
    margin = (
        image_rank
        - rank_one_bound(5 - multiplicity, 20)
        - quintic_dimension
    )
    assert (kernels, image_rank, quintic_dimension, margin) == expected
    assert margin > 7
print("rank-two through-base quintic-factor margins: PASS")


def partitions(total, maximum=None):
    """Integer partitions in nonincreasing order."""
    if total == 0:
        yield ()
        return
    if maximum is None or maximum > total:
        maximum = total
    for first in range(maximum, 0, -1):
        for tail in partitions(total - first, first):
            yield (first,) + tail


large_component_partitions = [
    part for part in partitions(10) if all(degree >= 5 for degree in part)
]
assert large_component_partitions == [(10,), (5, 5)]
print("reduced-decic integrality consequence: PASS")

print("all integral-quintic factor checks: PASS")
