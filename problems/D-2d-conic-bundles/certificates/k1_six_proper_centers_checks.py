#!/usr/bin/env python3
"""Arithmetic checks for line factors and the six-proper-center exclusion."""


def rank_one_binary_form_dimension(degrees):
    """UFD upper dimension for ac=b^2, including diagonal boundaries."""
    a_degree, b_degree, c_degree = degrees
    assert a_degree + c_degree == 2 * b_degree
    dimensions = [a_degree + 1, c_degree + 1, 0]
    for v_degree in range(c_degree // 2 + 1):
        h_degree = c_degree - 2 * v_degree
        u_degree = b_degree - h_degree - v_degree
        if u_degree < 0 or h_degree + 2 * u_degree != a_degree:
            continue
        dimensions.append(
            (h_degree + 1) + (u_degree + 1) + (v_degree + 1) - 1
        )
    return max(dimensions)


zero_cones = {
    (6, 5, 4): 7,
    (4, 4, 4): 6,
    (10, 10, 10): 12,
    (12, 10, 8): 13,
    (10, 9, 8): 11,
}
for degrees, expected in zero_cones.items():
    assert rank_one_binary_form_dimension(degrees) == expected
print("binary determinant-zero cone dimensions: PASS")

assert 18 - zero_cones[(6, 5, 4)] - 2 == 9 > 8
assert 9 > 7
assert 15 - zero_cones[(4, 4, 4)] - 1 == 8 > 7
print("line-component orbit margins: PASS")

rank_three_bad = 13
rank_two_away_bad = 14
rank_two_through_marked_bad = 12

assert 33 - rank_three_bad - (5 + 5) == 10 > 8
assert 33 - rank_two_away_bad - (5 + 5) == 9 > 7
assert 30 - zero_cones[(10, 9, 8)] - (4 + 5) == 10 > 7
assert 30 - rank_two_through_marked_bad - (4 + 4) == 10 > 7
print("five-point conic restriction margins: PASS")

print("all line-factor and six-proper-center checks: PASS")
