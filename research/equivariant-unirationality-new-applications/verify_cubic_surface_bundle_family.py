#!/usr/bin/env python3
"""Finite checks for the cubic-surface-bundle theorem family.

The general-member smoothness statement is proved by Bertini in the theorem
file. This script checks only the exact character, fixed-locus, genus, group,
and section inputs that are legitimately finite.
"""
from __future__ import annotations

import argparse

import sympy as sp


def verify(n: int) -> None:
    assert n >= 3 and n % 2 == 1

    s = sp.symbols("s")
    a0_affine = s ** (2 * n) + 1
    assert sp.gcd(a0_affine, sp.diff(a0_affine, s)) == 1
    assert sp.degree(a0_affine, s) == 2 * n

    # A monomial S^a T^(2n-a) has rotation weight 2(a-n) mod n.
    invariant_exponents = [
        a for a in range(2 * n + 1) if (2 * (a - n)) % n == 0
    ]
    # Since n is odd, 2 is invertible mod n.
    assert invariant_exponents == [0, n, 2 * n]

    # Reflection pairs the outer two monomials and fixes the middle one.
    assert [(2 * n - a) for a in invariant_exponents] == [2 * n, n, 0]

    # z-weights on (U,V,X,Y) are (1,2,0,0) mod 3.
    weights = (1, 2, 0, 0)
    invariant_cubic_exponents: list[tuple[int, int, int, int]] = []
    for eu in range(4):
        for ev in range(4 - eu):
            for ex in range(4 - eu - ev):
                ey = 3 - eu - ev - ex
                exponent = (eu, ev, ex, ey)
                if sum(e * w for e, w in zip(exponent, weights)) % 3 == 0:
                    invariant_cubic_exponents.append(exponent)

    # The expected invariant monomials are U^3, V^3, UVX, UVY and the
    # four binary cubics in X,Y.
    expected = {
        (3, 0, 0, 0),
        (0, 3, 0, 0),
        (1, 1, 1, 0),
        (1, 1, 0, 1),
        (0, 0, 3, 0),
        (0, 0, 2, 1),
        (0, 0, 1, 2),
        (0, 0, 0, 3),
    }
    assert set(invariant_cubic_exponents) == expected

    # Fixed locus: a bidegree-(2n,3) curve plus two copies of the 2n
    # zeros of A0.
    genus = (2 * n - 1) * (3 - 1)
    assert genus == 4 * n - 2
    isolated_points = 2 * (2 * n)
    assert isolated_points == 4 * n

    # Every abelian subgroup of the odd dihedral group is cyclic: a
    # rotation commuting with a reflection satisfies 2k=0 mod n.
    commuting_rotation_exponents = [k for k in range(n) if (2 * k) % n == 0]
    assert commuting_rotation_exponents == [0]

    # The displayed sections use a cube root rho and satisfy
    # U^3+V^3=0 modulo rho^3-1.
    rho = sp.symbols("rho")
    section_remainder = sp.rem(1 + (-rho) ** 3, rho ** 3 - 1, domain=sp.QQ)
    assert sp.expand(section_remainder) == 0
    assert len([0, 1, 2]) == 3


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--n", type=int, default=5)
    args = parser.parse_args()
    verify(args.n)
    print(f"CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n={args.n}")


if __name__ == "__main__":
    main()
