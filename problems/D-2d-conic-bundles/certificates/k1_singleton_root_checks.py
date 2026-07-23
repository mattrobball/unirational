#!/usr/bin/env python3
"""Arithmetic checks for the six-singleton root-partition exclusion."""


def rank_one_binary_form_dimension(degrees):
    """UFD dimension of ac=b^2, including diagonal boundaries."""
    a_degree, b_degree, c_degree = degrees
    assert a_degree + c_degree == 2 * b_degree
    dimensions = [a_degree + 1, c_degree + 1]
    for v_degree in range(c_degree // 2 + 1):
        h_degree = c_degree - 2 * v_degree
        u_degree = b_degree - h_degree - v_degree
        if u_degree < 0 or h_degree + 2 * u_degree != a_degree:
            continue
        dimensions.append(
            (h_degree + 1) + (u_degree + 1) + (v_degree + 1) - 1
        )
    return max(dimensions)


fixed_fibers = {
    (10, 10, 10): 12,
    (12, 10, 8): 13,
    (10, 9, 8): 11,
    (6, 5, 4): 7,
    (4, 4, 4): 6,
}
for degrees, expected in fixed_fibers.items():
    assert rank_one_binary_form_dimension(degrees) == expected
print("fixed binary determinant-fiber bounds: PASS")

cluster_lengths = [(n, 3 * (6 - n) + 2 * n) for n in range(7)]
assert cluster_lengths == [
    (0, 18),
    (1, 17),
    (2, 16),
    (3, 15),
    (4, 14),
    (5, 13),
    (6, 12),
]
assert [n for n, length in cluster_lengths if length >= 15] == [0, 1, 2, 3]
print("singleton doubled-cluster colength bound: PASS")

# n=1
assert 33 - (12 + 1) - 10 == 10 > 8
assert 33 - (13 + 1) - 10 == 9 > 7
assert 30 - 11 - 9 == 10 > 7
assert 30 - (11 + 1) - 8 == 10 > 7
print("one-nonproper conic margins: PASS")

# n=2
n2_rows = [
    (54, 2 * (12 + 2), 14, 8, 12),
    (54, 2 * (13 + 2), 14, 7, 10),
    (51, 11 + (13 + 2), 13, 7, 12),
    (51, (11 + 2) + (13 + 2), 12, 7, 11),
    (50, 2 * (11 + 2), 12, 7, 12),
]
for image, bad, config, orbit, expected in n2_rows:
    assert image - bad - config == expected > orbit
print("two-nonproper two-conic margins: PASS")

# n=3, tangent-conic case
n3_conic_rows = [
    (33, 12 + 3, 9, 8, 9),
    (33, 13 + 3, 9, 7, 8),
    (30, 11 + 1, 8, 7, 10),
    (30, 11 + 3, 7, 7, 9),
]
for image, bad, config, orbit, expected in n3_conic_rows:
    assert image - bad - config == expected > orbit
print("three-nonproper tangent-conic margins: PASS")

# n=3, three-tangent-line case
rank_two_line_images = [45, 42, 41, 41]
rank_two_line_bad = [24, 23, 22, 21]
rank_two_line_configs = [12, 11, 10, 10]
rank_two_line_margins = [
    image - bad - config
    for image, bad, config in zip(
        rank_two_line_images,
        rank_two_line_bad,
        rank_two_line_configs,
    )
]
assert 45 - 3 * (7 + 1) - 12 == 9 > 8
assert rank_two_line_margins == [9, 8, 9, 10]
assert min(rank_two_line_margins) > 7
print("three-nonproper tangent-line margins: PASS")

print("all singleton-root checks: PASS")
