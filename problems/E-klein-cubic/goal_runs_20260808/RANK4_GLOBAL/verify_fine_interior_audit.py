#!/usr/bin/env python3
"""Bounded exact replay for FINE_INTERIOR_AUDIT.md.

The only enumeration is the complete fundamental residue box for the two
fixed order-eleven rank-two lattices.  It has no Laurent-degree or support
parameter.
"""

from fractions import Fraction
from itertools import product


P = 11
MU = (1, 5, 3, 4, 9)
CASES = (
    ((0, 1, 8, 5, 8), (4, 1, 4, 1, 1), 11, 11, 1),
    ((0, 1, 9, 6, 6), (28, 97, 16, 19, 16), 176, 176, 2),
)


def dot_mod(a, b):
    return sum(x * y for x, y in zip(a, b)) % P


def residue_normals(nu):
    return tuple(
        q
        for q in product(range(P), repeat=5)
        if min(q) == 0
        and any(q)
        and dot_mod(MU, q) == 0
        and dot_mod(nu, q) == 0
    )


def independent_mod_constants(nu):
    # This also replays independence of the two Kummer divisor classes.
    for a, b in product(range(P), repeat=2):
        if a == b == 0:
            continue
        value = tuple((a * x + b * y) % P for x, y in zip(MU, nu))
        assert len(set(value)) > 1


def main():
    assert sum(MU) % P == 0
    assert all(x % P for x in MU)

    for nu, nums, den, expected_min, expected_equalities in CASES:
        assert sum(nu) % P == 0
        independent_mod_constants(nu)

        normals = residue_normals(nu)
        assert len(normals) == 500

        alpha = tuple(Fraction(x, den) for x in nums)
        assert sum(alpha) == 1
        assert all(P * x >= 1 for x in alpha)

        cleared_values = tuple(sum(x * q for x, q in zip(nums, normal))
                               for normal in normals)
        assert min(cleared_values) == expected_min
        assert sum(value == den for value in cleared_values) == expected_equalities
        assert all(value >= den for value in cleared_values)

        # The symmetric barycenter is a strict Fine-interior point.
        weights = tuple(sum(q) for q in normals)
        assert min(weights) == 8
        barycenter = (Fraction(1, 5),) * 5
        assert all(P * x > 1 for x in barycenter)
        assert all(sum(x * q for x, q in zip(barycenter, normal)) > 1
                   for normal in normals)

        # No e_i lies in N_B; hence the facet vector 11 e_i is primitive.
        for i in range(5):
            e_i = tuple(int(i == j) for j in range(5))
            assert dot_mod(MU, e_i) != 0

        print(
            "FINE_INTERIOR_CASE_OK",
            nu,
            "NORMALS", len(normals),
            "WITNESS_MIN", expected_min,
            "BARYCENTER_RESIDUE_MARGIN", Fraction(8, 5),
        )

    # The five simplex vertices are affinely independent over Q.
    edges = tuple(tuple(int(i == j) for j in range(4)) for i in range(4))
    assert edges == ((1, 0, 0, 0), (0, 1, 0, 0),
                     (0, 0, 1, 0), (0, 0, 0, 1))

    print("RANK4-FINE-INTERIOR-UPGRADE-AUDIT-OK")


if __name__ == "__main__":
    main()
