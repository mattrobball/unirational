#!/usr/bin/env python3
"""Arithmetic checks for root_three_free_separator_theorem.md.

The geometric restriction ranks and binary determinant bounds are proved in
the cited certificates.  This checks their codimension arithmetic and the
total-transform coefficient comparisons used on the aligned locus.
"""


def prefix_sums(values: tuple[int, ...]) -> tuple[int, ...]:
    """Prime-exceptional coefficients on a successive free chain."""
    result: list[int] = []
    total = 0
    for value in values:
        total += value
        result.append(total)
    return tuple(result)


def main() -> None:
    adjacent_free_rank3 = 36 - 13 - 7 - 5
    adjacent_free_rank2 = [
        36 - 13 - 7 - 5,
        33 - 13 - 5 - 4,
        32 - 12 - 6 - 3,
    ]
    assert adjacent_free_rank3 == 11
    assert adjacent_free_rank2 == [11, 11, 11]
    print("A-F rank-three codimension:", adjacent_free_rank3)
    print("A-F rank-two codimensions:", adjacent_free_rank2)

    double_free_rank3 = 36 - 11 - 8 - 6
    double_free_rank2 = [
        36 - 12 - 8 - 6,
        33 - 9 - 8 - 5,
        33 - 12 - 5 - 5,
        32 - 10 - 7 - 4,
    ]
    assert double_free_rank3 == 11
    assert double_free_rank2 == [10, 11, 11, 11]
    print("proper-minimal F-F rank-three codimension:", double_free_rank3)
    print("proper-minimal F-F rank-two codimensions:", double_free_rank2)

    adjacent_free_cluster = prefix_sums((1, 1, 0, 1))
    adjacent_free_line = prefix_sums((1, 1, 1, 0))
    proper_double_free_cluster = prefix_sums((1, 0, 1, 0, 1))
    proper_double_free_line = prefix_sums((1, 1, 1, 0, 0))
    # Include the preceding proper point, then discard its exceptional entry.
    nonproper_double_free_line = prefix_sums((1, 1, 1, 0, 0, 0))[1:]
    adjacent_satellite_cluster = (1, 2, 2, 5)
    adjacent_satellite_line = (1, 2, 3, 5)
    assert adjacent_free_cluster == (1, 2, 2, 3)
    assert adjacent_free_line == (1, 2, 3, 3)
    assert proper_double_free_cluster == (1, 1, 2, 2, 3)
    assert proper_double_free_line == (1, 2, 3, 3, 3)
    assert nonproper_double_free_line == (2, 3, 3, 3, 3)
    assert all(
        line >= cluster
        for line, cluster in zip(adjacent_free_line, adjacent_free_cluster)
    )
    assert all(
        line >= cluster
        for line, cluster in zip(
            proper_double_free_line, proper_double_free_cluster
        )
    )
    assert all(
        line >= cluster
        for line, cluster in zip(
            nonproper_double_free_line, proper_double_free_cluster
        )
    )
    assert all(
        line >= cluster
        for line, cluster in zip(
            adjacent_satellite_line, adjacent_satellite_cluster
        )
    )
    print(
        "aligned cluster/line vectors:",
        adjacent_free_cluster,
        adjacent_free_line,
        proper_double_free_cluster,
        proper_double_free_line,
        nonproper_double_free_line,
        adjacent_satellite_cluster,
        adjacent_satellite_line,
    )
    print("all root-three free-separator arithmetic checks passed")


if __name__ == "__main__":
    main()
