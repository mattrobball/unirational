#!/usr/bin/env python3
"""Exact numerical checks for the quartic residual double cover.

The calculation is conditional on the geometric model used in D2: the
base scheme is the length-36 regular complete intersection described below,
the indicated blowup resolves the residual-quadratic map, and the corrected
branch is smooth.  This script checks the resulting intersection theory,
cohomology dimensions, and double-cover formulas.  It does *not* certify
regularity, reducedness, transversality, or smoothness.
"""

from __future__ import annotations

from dataclasses import dataclass
from fractions import Fraction
from math import comb


NUMBER_OF_BASEPOINTS = 36


@dataclass(frozen=True)
class Divisor:
    """A divisor h*H + f*F + sum(e_i*E_i) on the 36-point blowup of S."""

    h: int
    f: int
    exceptional: tuple[int, ...] = (0,) * NUMBER_OF_BASEPOINTS

    def __post_init__(self) -> None:
        assert len(self.exceptional) == NUMBER_OF_BASEPOINTS

    def __add__(self, other: "Divisor") -> "Divisor":
        return Divisor(
            self.h + other.h,
            self.f + other.f,
            tuple(a + b for a, b in zip(self.exceptional, other.exceptional)),
        )

    def __sub__(self, other: "Divisor") -> "Divisor":
        return self + (-1) * other

    def __rmul__(self, scalar: int) -> "Divisor":
        return Divisor(
            scalar * self.h,
            scalar * self.f,
            tuple(scalar * e for e in self.exceptional),
        )

    def intersection(self, other: "Divisor") -> int:
        # On S=(2,4) in P^2 x P^1: H^2=4, H.F=2, F^2=0.
        # On its blowup: E_i^2=-1 and all other pairings with E_i vanish.
        ambient_part = (
            4 * self.h * other.h
            + 2 * self.h * other.f
            + 2 * self.f * other.h
        )
        exceptional_part = sum(
            a * b for a, b in zip(self.exceptional, other.exceptional)
        )
        return ambient_part - exceptional_part

    def square(self) -> int:
        return self.intersection(self)


def h0_projective_product(a: int, b: int) -> int:
    """h^0(P^2 x P^1, O(a,b))."""

    if a < 0 or b < 0:
        return 0
    return comb(a + 2, 2) * (b + 1)


def h1_projective_product(a: int, b: int) -> int:
    """h^1(P^2 x P^1, O(a,b)), by Kuenneth."""

    h0_p2 = comb(a + 2, 2) if a >= 0 else 0
    h1_p1 = -b - 1 if b <= -2 else 0
    return h0_p2 * h1_p1


def h2_projective_product(a: int, b: int) -> int:
    """h^2(P^2 x P^1, O(a,b)), by Kuenneth."""

    h2_p2 = comb(-a - 1, 2) if a <= -3 else 0
    h0_p1 = b + 1 if b >= 0 else 0
    return h2_p2 * h0_p1


def h0_on_s(a: int, b: int) -> int:
    """h^0(S,O_S(a,b)) in the twists used below.

    This uses 0 -> O(a-2,b-4) -> O(a,b) -> O_S(a,b) -> 0 and explicitly
    verifies the H^1 vanishing needed to take the difference of h^0's.
    """

    assert h1_projective_product(a - 2, b - 4) == 0
    return h0_projective_product(a, b) - h0_projective_product(a - 2, b - 4)


def assert_h1_on_s_vanishes(a: int, b: int) -> None:
    """Verify sufficient ambient vanishings for H^1(S,O_S(a,b))=0."""

    assert h1_projective_product(a, b) == 0
    assert h2_projective_product(a - 2, b - 4) == 0


def main() -> None:
    zero_exceptional = (0,) * NUMBER_OF_BASEPOINTS
    all_exceptional = (1,) * NUMBER_OF_BASEPOINTS

    H = Divisor(1, 0, zero_exceptional)
    F = Divisor(0, 1, zero_exceptional)
    exceptional_0 = Divisor(0, 0, (1,) + (0,) * (NUMBER_OF_BASEPOINTS - 1))
    exceptional_1 = Divisor(0, 0, (0, 1) + (0,) * (NUMBER_OF_BASEPOINTS - 2))
    assert H.square() == 4
    assert H.intersection(F) == 2
    assert F.square() == 0
    assert exceptional_0.square() == -1
    assert exceptional_0.intersection(exceptional_1) == 0
    assert H.intersection(exceptional_0) == 0
    assert F.intersection(exceptional_0) == 0

    canonical_s = -1 * H + 2 * F
    assert canonical_s == Divisor(-1, 2)
    assert canonical_s.square() == -4
    print("intersection ring (including E_i) and K_S=-H+2F: PASS")

    # The two components of the relative gradient along and transverse to L
    # have classes A=2H+2F and C=2H+3F.  A regular intersection has length 36.
    base_generator_a = 2 * H + 2 * F
    base_generator_c = 2 * H + 3 * F
    base_length = base_generator_a.intersection(base_generator_c)
    assert base_length == NUMBER_OF_BASEPOINTS
    print("lci base-scheme intersection length 36: PASS")

    exceptional_sum = Divisor(0, 0, all_exceptional)
    canonical_y = canonical_s + exceptional_sum
    branch_on_s = 16 * H + 14 * F
    corrected_branch = branch_on_s - 6 * exceptional_sum
    half_branch = 8 * H + 7 * F - 3 * exceptional_sum
    canonical_character = canonical_y + half_branch

    assert 2 * half_branch == corrected_branch
    assert canonical_y == Divisor(-1, 2, all_exceptional)
    assert canonical_character == Divisor(7, 9, (-2,) * NUMBER_OF_BASEPOINTS)
    assert branch_on_s.intersection(F) == 32
    print("branch, half-branch, and canonical E-corrections: PASS")

    branch_genus = 1 + Fraction(
        corrected_branch.intersection(corrected_branch + canonical_y), 2
    )
    assert corrected_branch.square() == 624
    assert corrected_branch.intersection(canonical_y) == 188
    assert branch_genus == 407
    print("corrected branch adjunction genus 407: PASS")

    canonical_square = 2 * canonical_character.square()
    chi_y = 1
    chi_double_cover = 2 * chi_y + Fraction(
        half_branch.intersection(half_branch + canonical_y), 2
    )
    assert canonical_character.square() == 304
    assert canonical_square == 608
    assert chi_double_cover == 127
    print("double-cover invariants K^2=608 and chi=127: PASS")

    # If I=(f,g), with div(f)=A and div(g)=C, the Hilbert--Burch resolution
    # of I^2, twisted by D=7H+9R, is
    #
    #   0 -> O(D-2A-C) + O(D-A-2C)
    #     -> O(D-2A) + O(D-A-C) + O(D-2C) -> I^2(D) -> 0.
    d = (7, 9)
    a = (2, 2)
    c = (2, 3)

    def subtract(*classes: tuple[int, int]) -> tuple[int, int]:
        return (
            d[0] - sum(item[0] for item in classes),
            d[1] - sum(item[1] for item in classes),
        )

    left_twists = (subtract(a, a, c), subtract(a, c, c))
    middle_twists = (subtract(a, a), subtract(a, c), subtract(c, c))
    assert left_twists == ((1, 2), (1, 1))
    assert middle_twists == ((3, 5), (3, 4), (3, 3))

    for twist in left_twists + middle_twists:
        assert_h1_on_s_vanishes(*twist)
    left_h0 = [h0_on_s(*twist) for twist in left_twists]
    middle_h0 = [h0_on_s(*twist) for twist in middle_twists]
    assert left_h0 == [9, 6]
    assert middle_h0 == [54, 47, 40]
    pg = sum(middle_h0) - sum(left_h0)

    # Independent colength check: I^2 has colength 3 at each lci point.
    assert h0_on_s(*d) == 234
    assert h0_on_s(*d) - 3 * base_length == pg
    assert pg == 126
    irregularity = 1 + pg - chi_double_cover
    assert irregularity == 0
    print("lci-square resolution gives p_g=126 and q=0: PASS")

    # RR gives chi(2K)=chi(O)+K^2.  Under the stated Kodaira-vanishing
    # hypothesis this Euler characteristic is P_2.
    p2 = chi_double_cover + canonical_square
    assert p2 == 735
    print("RR/Kodaira arithmetic gives P_2=735: PASS")

    print("scope: numerical checks only; geometric regularity/smoothness not certified")


if __name__ == "__main__":
    main()
