#!/usr/bin/env python3
"""Arithmetic checks for root_two_one_separator_theorem.md.

The theorem supplies the geometry: component contacts, configuration
dimensions, and the positions of the rank-two base point.  This script
checks every determinant bound and every final codimension in the tables.
"""

from __future__ import annotations


def codim(rank: int, bad: tuple[int, ...], config: int) -> int:
    return rank - sum(bad) - config


def check_component_bounds() -> None:
    # Affine determinant target dimension for a degree-16 restriction.
    target = {contact: 17 - contact for contact in (11, 13, 14, 15, 16)}
    assert target == {11: 6, 13: 4, 14: 3, 15: 2, 16: 1}

    # V_(8,8,8): fixed-fiber dimension 10.
    conic_rank3 = {c: 10 + d for c, d in target.items()}
    assert conic_rank3 == {11: 16, 13: 14, 14: 13, 15: 12, 16: 11}

    # V_(10,8,6): open fixed fibers have dimension 10, the square
    # diagonal boundary has dimension 11.  The square-target dimensions
    # in the five rows are respectively 3,2,2,1,1.
    square_dim = {11: 3, 13: 2, 14: 2, 15: 1, 16: 1}
    conic_rank2_off = {
        c: max(10 + target[c], 11 + square_dim[c], 11) for c in target
    }
    assert conic_rank2_off == {11: 16, 13: 14, 14: 13, 15: 12, 16: 12}

    # If b is a marked point, divide its forced square and use V_(8,7,6),
    # whose fixed and zero fibers have dimension 9.  At an unmarked point
    # of the conic, divisibility by b^2 removes two dimensions from the
    # moving determinant target (or leaves only the zero determinant).
    conic_rank2_marked = {c: 9 + target[c] for c in target}
    conic_rank2_unmarked = {
        c: 9 + max(target[c] - 2, 0) for c in target
    }
    assert conic_rank2_marked == {11: 15, 13: 13, 14: 12, 15: 11, 16: 10}
    assert conic_rank2_unmarked == {11: 13, 13: 11, 14: 10, 15: 9, 16: 9}

    # Lines: V_(5,4,3) has fixed/zero fiber dimension 6 and V_(3,3,3)
    # has fixed/zero fiber dimension 5.
    line_target = {c: 9 - c for c in (6, 7, 8)}
    line_off = {c: 6 + d for c, d in line_target.items()}
    line_marked = {c: 5 + d for c, d in line_target.items()}
    line_unmarked = {c: 5 + max(d - 2, 0) for c, d in line_target.items()}
    assert line_off == {6: 9, 7: 8, 8: 7}
    assert line_marked == {6: 8, 7: 7, 8: 6}
    assert line_unmarked == {6: 6, 7: 5, 8: 5}

    print("conic rank3 bounds c=11,13,14,15,16:", conic_rank3)
    print("conic rank2 off/marked/unmarked:")
    print(" ", conic_rank2_off)
    print(" ", conic_rank2_marked)
    print(" ", conic_rank2_unmarked)
    print("line off/marked/unmarked c=6,7,8:")
    print(" ", line_off, line_marked, line_unmarked)


def check_rank3() -> None:
    values = {
        "F-P noncontinuation, P singleton": codim(36, (8, 13), 6),
        "F-P noncontinuation, N generic": codim(36, (8, 11), 7),
        "F-P noncontinuation, N side": codim(36, (6, 14), 6),
        "F-P continuation, P singleton": codim(27, (6, 7), 5),
        "F-P continuation, N side": codim(27, (6, 6), 5),
        "F-P continuation, N generic": codim(36, (6, 14), 6),
        "F-N noncontinuation, P singleton": codim(36, (9, 11), 7),
        "F-N noncontinuation, N generic": codim(42, (12, 12), 8),
        "F-N noncontinuation, N side": codim(36, (6, 12), 7),
        "S, P singleton": codim(36, (6, 16), 5),
        "S, N off-root-line": codim(36, (7, 14), 6),
        "S, N root-on-tangent": codim(36, (6, 16), 5),
    }
    assert min(values.values()) == 9 > 8
    print("rank3 codimensions:")
    for name, value in values.items():
        print(f"  {name}: {value}")


def check_rank2() -> None:
    tables: dict[str, list[int]] = {
        "F-P noncontinuation, P singleton": [
            codim(36, (13, 8), 6),
            codim(33, (10, 8), 5),
            codim(33, (13, 5), 5),
            codim(32, (12, 7), 4),
            codim(33, (12, 8), 4),
        ],
        "F-P noncontinuation, N generic": [
            codim(36, (12, 8), 7),
            codim(33, (9, 8), 6),
            codim(33, (12, 5), 6),
            codim(32, (10, 7), 5),
            codim(33, (10, 8), 5),
        ],
        "F-P noncontinuation, N side": [
            codim(36, (6, 14), 6),
            codim(33, (5, 14), 5),
            codim(33, (6, 11), 5),
            codim(32, (5, 13), 4),
        ],
        "F-P continuation, P singleton": [
            codim(27, (6, 7), 5),
            codim(24, (5, 7), 4),
            codim(24, (6, 5), 4),
            codim(23, (5, 6), 3),
            codim(24, (6, 6), 3),
        ],
        "F-P continuation, N side": [
            codim(27, (6, 6), 5),
            codim(24, (5, 6), 4),
            codim(24, (6, 5), 4),
            codim(23, (5, 5), 3),
            codim(24, (6, 5), 3),
        ],
        "F-P continuation, N generic": [
            codim(36, (6, 14), 6),
            codim(33, (5, 14), 5),
            codim(33, (6, 11), 5),
            codim(32, (5, 13), 4),
            codim(33, (6, 13), 4),
        ],
        "F-N noncontinuation, P singleton": [
            codim(36, (12, 9), 7),
            codim(33, (9, 9), 6),
            codim(33, (12, 6), 6),
            codim(32, (10, 8), 5),
            codim(33, (10, 9), 5),
        ],
        "F-N noncontinuation, N generic": [
            codim(42, (12, 12), 8),
            codim(39, (9, 12), 7),
            codim(38, (11, 11), 6),
        ],
        "F-N noncontinuation, N side": [
            codim(36, (6, 12), 7),
            codim(33, (5, 12), 6),
            codim(33, (6, 9), 6),
            codim(32, (5, 11), 5),
        ],
        "S, P singleton": [
            codim(36, (6, 16), 5),
            codim(33, (5, 16), 4),
            codim(33, (6, 13), 4),
            codim(32, (5, 15), 3),
        ],
        "S, N off-root-line": [
            codim(36, (7, 14), 6),
            codim(33, (5, 14), 5),
            codim(33, (7, 11), 5),
            codim(32, (6, 13), 4),
        ],
        "S, N root-on-tangent": [
            codim(36, (6, 16), 5),
            codim(33, (5, 16), 4),
            codim(33, (6, 13), 4),
            codim(32, (5, 15), 3),
        ],
    }
    assert min(min(values) for values in tables.values()) == 8 > 7
    print("rank2 codimension tables:")
    for name, values in tables.items():
        print(f"  {name}: {values}")


def main() -> None:
    check_component_bounds()
    check_rank3()
    check_rank2()
    print("all root-[2,1] one-separator arithmetic checks passed")


if __name__ == "__main__":
    main()
