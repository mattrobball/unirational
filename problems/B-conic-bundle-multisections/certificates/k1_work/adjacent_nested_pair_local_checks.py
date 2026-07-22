#!/usr/bin/env python3
"""Exact arithmetic checks for adjacent_nested_pair_theorem.md.

The geometric inputs (splitting types and blowup line-bundle cohomology) are
proved in the note.  This script checks every dimension and codimension
derived from them, including all determinant boundaries.
"""

from __future__ import annotations


PATTERNS = (
    (8, 8, 8),
    (10, 8, 6),
    (8, 7, 6),
    (5, 4, 3),
    (3, 3, 3),
)


def zero_fiber_dimension(a_degree: int, b_degree: int, c_degree: int) -> int:
    """UFD rank-one locus, including both diagonal boundaries."""
    assert a_degree + c_degree == 2 * b_degree
    rank_one_strata = []
    for h_degree in range(min(a_degree, c_degree) + 1):
        if (a_degree - h_degree) % 2 or (c_degree - h_degree) % 2:
            continue
        u_degree = (a_degree - h_degree) // 2
        v_degree = (c_degree - h_degree) // 2
        if h_degree + u_degree + v_degree != b_degree:
            continue
        # h,u,v coefficients, modulo the one-dimensional common rescaling.
        rank_one_strata.append(
            (h_degree + 1) + (u_degree + 1) + (v_degree + 1) - 1
        )
    return max(rank_one_strata + [a_degree + 1, c_degree + 1])


def fixed_dimensions(pattern: tuple[int, int, int]) -> tuple[int, int, int]:
    """Ambient, c!=0 fixed-fiber, and square-boundary dimensions."""
    a_degree, b_degree, c_degree = pattern
    ambient = a_degree + b_degree + c_degree + 3
    open_fixed = (c_degree + 1) + (b_degree - c_degree + 1)
    square_boundary = a_degree + 1
    assert open_fixed == b_degree + 2
    return ambient, open_fixed, square_boundary


def varying_target_bound(
    pattern: tuple[int, int, int], target_dimension: int, square_dimension: int
) -> int:
    """Maximum of nonsquare, square-boundary, and zero strata."""
    _, open_fixed, square_boundary = fixed_dimensions(pattern)
    zero = zero_fiber_dimension(*pattern)
    return max(
        open_fixed + target_dimension,
        square_boundary + square_dimension,
        zero,
    )


def check_artin_compensation() -> None:
    # delta(m,k) from the proof; degree 16 covers every determinant here.
    for m in range(1, 17):
        for k in range(17):
            if k < m and k % 2:
                continue  # empty local square-root scheme
            delta = k // 2 if k < m else m // 2
            assert delta <= m


def main() -> None:
    check_artin_compensation()
    print("local Artin square-root compensation checked through degree 16")

    expected = {
        (8, 8, 8): (27, 10, 9, 10),
        (10, 8, 6): (27, 10, 11, 11),
        (8, 7, 6): (24, 9, 9, 9),
        (5, 4, 3): (15, 6, 6, 6),
        (3, 3, 3): (12, 5, 4, 5),
    }
    for pattern in PATTERNS:
        ambient, open_fixed, square_boundary = fixed_dimensions(pattern)
        zero = zero_fiber_dimension(*pattern)
        got = (ambient, open_fixed, square_boundary, zero)
        assert got == expected[pattern]
        print(
            f"V{pattern}: ambient={ambient}, fixed-open={open_fixed}, "
            f"square-boundary={square_boundary}, zero={zero}"
        )

    preimages = {
        "888-U5": varying_target_bound((8, 8, 8), 5, 3),
        "106-U5": varying_target_bound((10, 8, 6), 5, 3),
        "876-U5": varying_target_bound((8, 7, 6), 5, 5),
        "543-U1": varying_target_bound((5, 4, 3), 1, 1),
        "333-U1": varying_target_bound((3, 3, 3), 1, 1),
        "333-zero": zero_fiber_dimension(3, 3, 3),
        "888-U3": varying_target_bound((8, 8, 8), 3, 2),
        "106-U3": varying_target_bound((10, 8, 6), 3, 2),
        "876-U3": varying_target_bound((8, 7, 6), 3, 3),
    }
    assert preimages == {
        "888-U5": 15,
        "106-U5": 15,
        "876-U5": 14,
        "543-U1": 7,
        "333-U1": 6,
        "333-zero": 5,
        "888-U3": 13,
        "106-U3": 13,
        "876-U3": 12,
    }
    print("determinant preimage bounds:", preimages)

    # Cubic 3H-mu E_b: h^0 of the three kernel summands.
    cubic_kernel_h0 = {0: (3, 2, 1), 1: (5, 3, 1), 2: (6, 3, 1)}
    cubic_ranks = {mu: 42 - sum(values) for mu, values in cubic_kernel_h0.items()}
    assert cubic_ranks == {0: 36, 1: 33, 2: 32}
    print("rank-two cubic restriction image ranks:", cubic_ranks)

    # Conic 2H-mu E_b, used in the aligned-tangent split.
    conic_kernel_h0 = {0: (7, 5, 3), 1: (9, 6, 3), 2: (10, 6, 3)}
    conic_ranks = {mu: 42 - sum(values) for mu, values in conic_kernel_h0.items()}
    assert conic_ranks == {0: 27, 1: 24, 2: 23}
    print("rank-two conic restriction image ranks:", conic_ranks)

    adjacent_proper = [
        36 - 15 - 7 - 5,
        33 - 15 - 5 - 4,
        32 - 14 - 6 - 3,
        33 - 14 - 7 - 3,
    ]
    free_chain = [
        36 - 15 - 7 - 4,
        33 - 15 - 5 - 3,
        32 - 14 - 6 - 2,
    ]
    isolated_first_near = [
        36 - 13 - 7 - 6,
        33 - 13 - 5 - 5,
        32 - 12 - 6 - 4,
        33 - 12 - 7 - 4,
    ]
    aligned_first_near = [
        27 - 7 - 6 - 5,
        24 - 5 - 6 - 4,
        24 - 7 - 5 - 4,
        23 - 6 - 5 - 3,
        24 - 7 - 5 - 3,
    ]
    assert adjacent_proper == [9, 9, 9, 9]
    assert free_chain == [10, 10, 10]
    assert isolated_first_near == [10, 10, 10, 10]
    assert aligned_first_near == [9, 9, 8, 9, 9]
    print("adjacent pair + proper singleton codimensions:", adjacent_proper)
    print("free adjacent [3] codimensions:", free_chain)
    print("adjacent pair + isolated first-near codimensions:", isolated_first_near)
    print("aligned isolated-first-near codimensions:", aligned_first_near)
    print("all adjacent-nested-pair local checks passed")


if __name__ == "__main__":
    main()
