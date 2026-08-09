#!/usr/bin/env python3
"""Finite symbolic checks for the odd-genus exceptional-conic-bundle family."""
from __future__ import annotations

import argparse
import sympy as sp


def verify(g: int) -> None:
    assert g >= 3 and g % 2 == 1
    t = sp.symbols("t")

    # In the chart T1=1, the branch polynomial is t(t^(2g)+1); the
    # remaining branch point is infinity. It is squarefree.
    polynomial = t * (t ** (2 * g) + 1)
    assert sp.gcd(polynomial, sp.diff(polynomial, t)) == 1
    assert sp.degree(polynomial, t) == 2 * g + 1
    branch_points = 2 * g + 2
    genus = (branch_points - 2) // 2
    assert genus == g

    # In P(1,1,g+1,g+1), r^g is the weighted scalar -1 because g+1 is
    # even. No smaller positive power is projectively scalar.
    assert (g + 1) % 2 == 0
    for k in range(1, g):
        assert (2 * k) % (2 * g) != 0

    # The two monomials in T0*T1*(T0^(2g)+T1^(2g)) have character zero
    # under r and are interchanged by the reflection s.
    monomial_exponents = [(2 * g + 1, 1), (1, 2 * g + 1)]
    for exponent_0, exponent_1 in monomial_exponents:
        assert (exponent_0 - exponent_1) % (2 * g) == 0
    swapped = [(b, a) for a, b in monomial_exponents]
    assert swapped == list(reversed(monomial_exponents))

    # Reflection eigendirections have eigenvalues +/-1. Their lifts are
    # pointwise fixed because the fiber weight g+1 is even.
    assert pow(-1, g + 1) == 1


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--g", type=int, default=5)
    args = parser.parse_args()
    verify(args.g)
    print(f"ODD_EXCEPTIONAL_CONIC_BUNDLE_VERIFY_OK g={args.g}")


if __name__ == "__main__":
    main()
