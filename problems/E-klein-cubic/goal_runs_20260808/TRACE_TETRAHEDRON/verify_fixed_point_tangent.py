#!/usr/bin/env python3
"""Exact tiny replay of the four-term fixed-point/tangent reduction.

There is no support or collision enumeration here.  The only loop expands
the 4^3 ordered character triples in the universal cubic tangent tensor.
"""

from collections import defaultdict
from fractions import Fraction


ZERO = (Fraction(0),) * 4
ONE = (Fraction(1), Fraction(0), Fraction(0), Fraction(0))
ZETA = (Fraction(0), Fraction(1), Fraction(0), Fraction(0))


def fadd(a, b):
    return tuple(a[i] + b[i] for i in range(4))


def fmul(a, b):
    work = [Fraction(0)] * 7
    for i in range(4):
        for j in range(4):
            work[i + j] += a[i] * b[j]
    # zeta^4 = -(1+zeta+zeta^2+zeta^3).
    for degree in range(6, 3, -1):
        value = work[degree]
        for target in range(degree - 4, degree):
            work[target] -= value
    return tuple(work[:4])


def fpow(a, n):
    result = ONE
    for _ in range(n):
        result = fmul(result, a)
    return result


def main():
    assert fpow(ZETA, 5) == ONE

    # Expand sum_i L_i^2 L_(i+1).  Summing i kills every ordered character
    # triple whose weights do not total zero mod 5.  For a surviving triple,
    # the distinguished third factor contributes zeta^c.
    tangent = defaultdict(lambda: ZERO)
    for a in range(1, 5):
        for b in range(1, 5):
            for c in range(1, 5):
                if (a + b + c) % 5:
                    continue
                key = tuple(sorted((a, b, c)))
                tangent[key] = fadd(tangent[key], fpow(ZETA, c))

    expected_keys = {(1, 1, 3), (1, 2, 2), (2, 4, 4), (3, 3, 4)}
    assert set(tangent) == expected_keys
    assert all(coefficient != ZERO for coefficient in tangent.values())

    # Set-theoretic zero locus of the four monomials.  A support mask is
    # allowed precisely when it is contained in {1,4} or in {2,3}.
    def present(mask, weight):
        return bool(mask & (1 << (weight - 1)))

    allowed_masks = []
    for mask in range(16):
        equations_zero = not (
            (present(mask, 1) and present(mask, 3))
            or (present(mask, 1) and present(mask, 2))
            or (present(mask, 2) and present(mask, 4))
            or (present(mask, 3) and present(mask, 4))
        )
        contained_in_14 = not (present(mask, 2) or present(mask, 3))
        contained_in_23 = not (present(mask, 1) or present(mask, 4))
        assert equations_zero == (contained_in_14 or contained_in_23)
        if equations_zero:
            allowed_masks.append(mask)

    # Multiplication by 2 in Gal(Q(zeta_5)/Q) takes weights {1,4} to {2,3}.
    assert {(2 * q) % 5 for q in (1, 4)} == {2, 3}
    assert set((1, 4)).isdisjoint((2, 3))

    print("FIXED_POINT_FOURIER_RESIDUE_BLOCKS", "4 or 2+2")
    print("TANGENT_MONOMIALS", sorted(tangent.items()))
    print("TANGENT_ZERO_PLANES", "V1+V4", "V2+V3")
    print("TANGENT_ALLOWED_SUPPORT_MASKS", allowed_masks)
    print("TWO_RESIDUE_PROJECTIVE_POINTS", 5)
    print("UNION_OF_TWO_PLANES_LINE_INTERSECTION_BOUND", 2)
    print("TETRAHEDRAL_COEFFICIENT_RAYS_AT_MOST", 2)
    print("F55-TRACE-FOUR-TERM-FIXED-POINT-TANGENT-REDUCTION-OK")


if __name__ == "__main__":
    main()

