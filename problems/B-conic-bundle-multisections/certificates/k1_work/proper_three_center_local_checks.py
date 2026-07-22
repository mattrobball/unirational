#!/usr/bin/env python3
"""Exact finite checks for proper_three_center_theorem.md."""


def delta(m, k):
    return min(m // 2, k // 2)


def fixed_f_bound(a_degree, endpoint_orders, same_degree_b):
    values = []
    for m0 in range(a_degree + 1):
        for mi in range(a_degree + 1 - m0):
            d = m0 + mi
            a_stratum = a_degree + 1 - d
            kernel = 1 if same_degree_b else 0
            dim = a_stratum + kernel + delta(m0, endpoint_orders[0]) + delta(mi, endpoint_orders[1])
            values.append((m0, mi, dim))
    return max(dim for _, _, dim in values), values


def main():
    bound543, strata543 = fixed_f_bound(5, (4, 4), False)
    bound333, strata333 = fixed_f_bound(3, (2, 4), True)
    assert bound543 == 6, strata543
    assert bound333 == 5, strata333

    # UFD rank-one parameter dimensions, including the common rescaling.
    zero543 = max(2 + 3 + 2 - 1, 4 + 2 + 1 - 1, 6, 4)
    zero333 = max(2 + 2 + 2 - 1, 4 + 1 + 1 - 1, 4)
    assert (zero543, zero333) == (6, 5)

    edge543 = max(bound543 + 1, zero543)
    edge333_weighted = max(bound333 + 1, zero333)
    assert (edge543, edge333_weighted) == (7, 6)

    # Target dimensions and incidence margins.
    rank3_fixed = 36 - 3 * edge543
    rank2_outside = rank3_fixed
    rank2_edge = 33 - (zero333 + 2 * edge543)
    rank2_vertex = 32 - (2 * edge333_weighted + edge543)
    assert (rank3_fixed, rank2_outside, rank2_edge, rank2_vertex) == (15, 15, 14, 13)

    after_motion = (
        rank3_fixed - 6,
        rank2_outside - 6,
        rank2_edge - 5,
        rank2_vertex - 4,
    )
    assert after_motion == (9, 9, 9, 9)
    assert after_motion[0] > 8
    assert all(value > 7 for value in after_motion[1:])

    print(f"V_(5,4,3) fixed nonzero determinant fiber bound: {bound543}")
    print(f"V_(5,4,3) zero fiber / weighted edge bounds: {zero543}/{edge543}")
    print(f"V_(3,3,3) fixed nonzero determinant fiber bound: {bound333}")
    print(f"V_(3,3,3) zero fiber / weighted edge bounds: {zero333}/{edge333_weighted}")
    print(f"fixed-triangle codimensions: {rank3_fixed}, {rank2_outside}, {rank2_edge}, {rank2_vertex}")
    print(f"after center motion: {after_motion}")
    print("all proper-three-center local checks passed")


if __name__ == "__main__":
    main()

