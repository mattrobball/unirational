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

    # ---------------------------------------------------------------
    # Exact symbolic checks on the actual defining equation Phi.
    # ---------------------------------------------------------------
    S, T, U, V, X, Y = sp.symbols("S T U V X Y")
    c0 = sp.symbols("c0_0 c0_1 c0_2 c0_3")
    c1 = sp.symbols("c1_0 c1_1 c1_2 c1_3")

    A0 = S ** (2 * n) + T ** (2 * n)
    A1 = (S * T) ** n
    F0 = sum(c0[k] * X ** (3 - k) * Y ** k for k in range(4))
    F1 = sum(c1[k] * X ** (3 - k) * Y ** k for k in range(4))

    Phi = sp.expand(
        A0 * (U ** 3 + V ** 3)
        + U * V * (A0 * X + A1 * Y)
        + A0 * F0
        + A1 * F1
    )

    # (1.5) is homogeneous of bidegree (2n,3).
    assert sp.Poly(Phi, S, T).is_homogeneous
    assert sp.total_degree(sp.Poly(Phi, S, T)) == 2 * n
    assert sp.Poly(Phi, U, V, X, Y).is_homogeneous
    assert sp.total_degree(sp.Poly(Phi, U, V, X, Y)) == 3

    # Invariance under the rotation r[S:T]=[eS:e^{-1}T], modulo e^n-1.
    e = sp.symbols("e")
    rotated = sp.expand(Phi.subs({S: e * S, T: e ** (n - 1) * T}, simultaneous=True))
    assert sp.rem(sp.expand(rotated - Phi), e ** n - 1, e) == 0

    # Invariance under the reflection s[S:T]=[T:S].
    reflected = sp.expand(Phi.subs({S: T, T: S}, simultaneous=True))
    assert sp.expand(reflected - Phi) == 0

    # Invariance under the central z[U:V:X:Y]=[wU:w^2V:X:Y], modulo w^3-1.
    w = sp.symbols("w")
    twisted = sp.expand(Phi.subs({U: w * U, V: w ** 2 * V}, simultaneous=True))
    assert sp.rem(sp.expand(twisted - Phi), w ** 3 - 1, w) == 0

    # Restriction of Phi to the three components of the z-fixed locus.
    on_line = sp.expand(Phi.subs({U: 0, V: 0}))
    assert sp.expand(on_line - (A0 * F0 + A1 * F1)) == 0
    assert sp.expand(Phi.subs({V: 0, X: 0, Y: 0}) - A0 * U ** 3) == 0
    assert sp.expand(Phi.subs({U: 0, X: 0, Y: 0}) - A0 * V ** 3) == 0

    # The base-locus derivative identities of Section 3, on Z={X=Y=0}.
    def on_base_locus(expression):
        return sp.expand(expression.subs({X: 0, Y: 0}))

    assert on_base_locus(sp.diff(Phi, X)) == sp.expand(U * V * A0)
    assert on_base_locus(sp.diff(Phi, Y)) == sp.expand(U * V * A1)
    assert on_base_locus(sp.diff(Phi, U)) == sp.expand(3 * A0 * U ** 2)
    assert on_base_locus(sp.diff(Phi, V)) == sp.expand(3 * A0 * V ** 2)
    assert on_base_locus(sp.diff(Phi, S)) == sp.expand(
        sp.diff(A0, S) * (U ** 3 + V ** 3)
    )
    assert sp.expand(Phi.subs({X: 0, Y: 0}) - A0 * (U ** 3 + V ** 3)) == 0

    # A0 and A1 have no common zero: resultant in the affine chart T=1.
    assert sp.resultant(A0.subs(T, 1), A1.subs(T, 1), S) != 0

    # The three displayed sections lie on Phi=0, modulo rho^3-1.
    rho = sp.symbols("rho")
    section_value = sp.expand(Phi.subs({U: 1, V: -rho, X: 0, Y: 0}))
    assert sp.rem(section_value, rho ** 3 - 1, rho) == 0
    assert len(sp.roots(sp.Poly(rho ** 3 - 1, rho))) == 3


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--n", type=int, default=5)
    args = parser.parse_args()
    verify(args.n)
    print(f"CUBIC_SURFACE_BUNDLE_FAMILY_VERIFY_OK n={args.n}")


if __name__ == "__main__":
    main()
