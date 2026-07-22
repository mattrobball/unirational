#!/usr/bin/env python3
"""Exact arithmetic checks for three_singleton_first_near_theorem.md.

The geometric inputs (contact orders, smoothness/no-common-component of the
chosen conics, and restriction-map ranks) are proved in the note.  This file
checks the determinant-bound arithmetic and every final codimension table.
"""

from __future__ import annotations


Pattern = tuple[int, int, int]


def zero_fiber_dimension(pattern: Pattern) -> int:
    """Dimension of ac=b^2, including both one-entry boundaries."""
    a_degree, b_degree, c_degree = pattern
    assert a_degree + c_degree == 2 * b_degree
    strata: list[int] = [a_degree + 1, c_degree + 1]
    for h_degree in range(min(a_degree, c_degree) + 1):
        if (a_degree - h_degree) % 2 or (c_degree - h_degree) % 2:
            continue
        u_degree = (a_degree - h_degree) // 2
        v_degree = (c_degree - h_degree) // 2
        if h_degree + u_degree + v_degree != b_degree:
            continue
        # (h,u,v), modulo the common one-dimensional rescaling.
        strata.append(
            (h_degree + 1) + (u_degree + 1) + (v_degree + 1) - 1
        )
    return max(strata)


def fixed_fiber_dimensions(pattern: Pattern) -> tuple[int, int, int, int]:
    """Ambient, fixed-open, square-boundary, and zero dimensions."""
    a_degree, b_degree, c_degree = pattern
    ambient = a_degree + b_degree + c_degree + 3
    fixed_open = (c_degree + 1) + (b_degree - c_degree + 1)
    square_boundary = a_degree + 1
    zero = zero_fiber_dimension(pattern)
    assert fixed_open == b_degree + 2
    return ambient, fixed_open, square_boundary, zero


def varying_target_bound(pattern: Pattern, target_dim: int, square_dim: int) -> int:
    """Maximum over nonsquare, square-boundary, and zero strata."""
    _, fixed_open, square_boundary, zero = fixed_fiber_dimensions(pattern)
    return max(
        fixed_open + target_dim,
        square_boundary + square_dim,
        zero,
    )


def check_determinants() -> None:
    patterns = {
        (8, 8, 8): (27, 10, 9, 10),
        (10, 8, 6): (27, 10, 11, 11),
        (8, 7, 6): (24, 9, 9, 9),
        (5, 4, 3): (15, 6, 6, 6),
        (3, 3, 3): (12, 5, 4, 5),
    }
    for pattern, expected in patterns.items():
        got = fixed_fiber_dimensions(pattern)
        assert got == expected
        print(f"V{pattern}: ambient/fixed-open/square-boundary/zero = {got}")

    # Rows: NPP contact 14, NNP contact 16, N(non-tangent)P contact
    # 13, and NNN contact 15.  The tuples are (target dim, square dim).
    contact_targets = {
        "NPP-14": (3, 2),
        "NNP-16": (1, 1),
        "NnP-13": (4, 2),
        "NNn-15": (2, 1),
    }
    expected = {
        "NPP-14": (13, 13, 12),
        "NNP-16": (11, 12, 10),
        "NnP-13": (14, 14, 13),
        "NNn-15": (12, 12, 11),
    }
    conic_bounds: dict[str, tuple[int, int, int]] = {}
    for name, (target_dim, square_dim) in contact_targets.items():
        conic_bounds[name] = (
            varying_target_bound((8, 8, 8), target_dim, square_dim),
            varying_target_bound((10, 8, 6), target_dim, square_dim),
            varying_target_bound((8, 7, 6), target_dim, square_dim),
        )
    assert conic_bounds == expected
    print("smooth-conic bad dimensions (rank3/rank2-off/rank2-through):")
    for name, values in conic_bounds.items():
        print(f"  {name}: {values}")

    line_away = tuple(varying_target_bound((5, 4, 3), u, u) for u in (1, 2, 3))
    line_through = tuple(varying_target_bound((3, 3, 3), u, u) for u in (1, 2, 3))
    assert line_away == (7, 8, 9)
    assert line_through == (6, 7, 8)
    assert zero_fiber_dimension((5, 4, 3)) == 6
    assert zero_fiber_dimension((3, 3, 3)) == 5
    print("line bad dimensions U1/U2/U3:", line_away, line_through)


def check_restriction_ranks() -> None:
    quartic_kernel_h0 = {0: (0, 0, 0), 1: (2, 1, 0), 2: (3, 1, 0)}
    quartic_ranks = {
        mu: 42 - sum(values) for mu, values in quartic_kernel_h0.items()
    }
    assert quartic_ranks == {0: 42, 1: 39, 2: 38}

    cubic_kernel_h0 = {0: (3, 2, 1), 1: (5, 3, 1), 2: (6, 3, 1)}
    cubic_ranks = {
        mu: 42 - sum(values) for mu, values in cubic_kernel_h0.items()
    }
    assert cubic_ranks == {0: 36, 1: 33, 2: 32}
    print("rank-two quartic restriction ranks:", quartic_ranks)
    print("rank-two cubic restriction ranks:", cubic_ranks)


def codim(image_rank: int, bad_dimensions: tuple[int, ...], config_dim: int) -> int:
    return image_rank - sum(bad_dimensions) - config_dim


def check_codimensions() -> None:
    one_generic_rank3 = codim(42, (13, 13), 7)
    one_generic_rank2 = [
        codim(42, (13, 13), 7),
        codim(38, (12, 12), 5),
    ]
    one_aligned_rank3 = codim(36, (6, 8, 7), 6)
    one_aligned_rank2 = [
        codim(36, (6, 8, 7), 6),
        codim(33, (5, 8, 7), 5),
        codim(33, (6, 5, 7), 5),
        codim(33, (6, 8, 5), 5),
        codim(32, (5, 7, 7), 4),
        codim(32, (5, 8, 6), 4),
        codim(32, (6, 7, 6), 4),
    ]
    assert one_generic_rank3 == 9
    assert one_generic_rank2 == [9, 9]
    assert one_aligned_rank3 == 9
    assert one_aligned_rank2 == [9, 8, 10, 9, 9, 9, 9]

    two_generic_rank3 = codim(42, (11, 14), 8)
    two_generic_rank2 = [
        codim(42, (12, 14), 8),
        codim(39, (9, 14), 7),
        codim(38, (10, 13), 6),
    ]
    two_one_alignment_rank3 = codim(36, (6, 14), 7)
    two_one_alignment_rank2 = [
        codim(36, (6, 14), 7),
        codim(33, (5, 14), 6),
        codim(32, (5, 13), 5),
        codim(33, (6, 13), 5),
    ]
    two_two_alignments_rank3 = codim(36, (6, 6, 9), 6)
    two_two_alignments_rank2 = [
        codim(36, (6, 6, 9), 6),
        codim(33, (5, 6, 9), 5),
        codim(33, (6, 6, 6), 5),
        codim(32, (5, 5, 9), 4),
        codim(32, (5, 6, 8), 4),
    ]
    assert two_generic_rank3 == 9
    assert two_generic_rank2 == [8, 9, 9]
    assert two_one_alignment_rank3 == 9
    assert two_one_alignment_rank2 == [9, 8, 9, 9]
    assert two_two_alignments_rank3 == 9
    assert two_two_alignments_rank2 == [9, 8, 10, 9, 9]

    three_rank3 = codim(42, (12, 12), 9)
    three_rank2 = [
        codim(42, (12, 12), 9),
        codim(39, (9, 12), 8),
        codim(38, (11, 11), 7),
    ]
    assert three_rank3 == 9
    assert three_rank2 == [9, 10, 9]

    print("one-N rank3:", [one_generic_rank3, one_aligned_rank3])
    print("one-N rank2 generic/aligned:", one_generic_rank2, one_aligned_rank2)
    print(
        "two-N rank3 no/one/two alignments:",
        [two_generic_rank3, two_one_alignment_rank3, two_two_alignments_rank3],
    )
    print(
        "two-N rank2 no/one/two alignments:",
        two_generic_rank2,
        two_one_alignment_rank2,
        two_two_alignments_rank2,
    )
    print("three-N rank3/rank2:", three_rank3, three_rank2)

    rank3_values = [
        one_generic_rank3,
        one_aligned_rank3,
        two_generic_rank3,
        two_one_alignment_rank3,
        two_two_alignments_rank3,
        three_rank3,
    ]
    rank2_values = (
        one_generic_rank2
        + one_aligned_rank2
        + two_generic_rank2
        + two_one_alignment_rank2
        + two_two_alignments_rank2
        + three_rank2
    )
    assert min(rank3_values) == 9 > 8
    assert min(rank2_values) == 8 > 7
    print("global minima: rank3=9>8, rank2=8>7")


def main() -> None:
    check_determinants()
    check_restriction_ranks()
    check_codimensions()
    print("all three-singleton first-near checks passed")


if __name__ == "__main__":
    main()
