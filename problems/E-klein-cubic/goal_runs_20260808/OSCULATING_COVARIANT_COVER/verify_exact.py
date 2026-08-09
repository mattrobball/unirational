#!/usr/bin/env python3
"""Exact support and mixed-volume replay for the covariant Hermite slice.

The replay deliberately does not claim a generic degree.  It verifies the
Newton supports at two exact rational root specializations, forms the exact
Rabinowitsch top-degree saturation, and asks gfan for the mixed volume of
the resulting eleven supports.
"""

from __future__ import annotations

import subprocess
import sys
import tempfile
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
GENERAL_H = HERE.parent / "OSCULATING_GENERAL_H"
sys.path.insert(0, str(GENERAL_H))

from probe_normalized_slice import build_system  # noqa: E402


def saturated_supports(roots):
    T = sp.Symbol("T")
    z = sp.Symbol("z")
    variables, equations, _roots, H, *_ = build_system(
        roots, A_values=roots, f_values=(1,) * 5
    )
    extended_variables = variables + (z,)
    equations = [
        sp.Poly(polynomial.as_expr(), *extended_variables, domain=sp.QQ)
        for polynomial in equations
    ]
    leading_product = sp.prod(
        sp.Poly(polynomial, T).coeff_monomial(T**4) for polynomial in H
    )
    equations.append(sp.Poly(
        z * leading_product - 1, *extended_variables, domain=sp.QQ
    ))
    supports = tuple(
        tuple(monomial for monomial, _coefficient in polynomial.terms())
        for polynomial in equations
    )
    return extended_variables, supports


def gfan_input(variables, supports):
    names = tuple(map(str, variables))
    polynomials = []
    for support in supports:
        terms = []
        for monomial in support:
            factors = []
            for name, exponent in zip(names, monomial):
                if exponent == 1:
                    factors.append(name)
                elif exponent:
                    factors.append(f"{name}^{exponent}")
            terms.append("*".join(factors) if factors else "1")
        polynomials.append("+".join(terms))
    return "Q[" + ",".join(names) + "]\n{" + ",\n".join(polynomials) + "}\n"


def main():
    samples = (
        tuple(map(sp.Rational, (1, 2, 3, 4))) + (sp.Rational(1, 24),),
        tuple(map(sp.Rational, (1, 2, -1, -2))) + (sp.Rational(1, 4),),
    )
    first_variables, first_supports = saturated_supports(samples[0])
    second_variables, second_supports = saturated_supports(samples[1])
    assert tuple(map(str, first_variables)) == tuple(map(str, second_variables))
    assert first_supports == second_supports

    term_counts = tuple(map(len, first_supports))
    assert term_counts == (9, 31, 9, 31, 9, 31, 9, 31, 9, 31, 244)

    with tempfile.TemporaryDirectory(prefix="osculating_gfan_") as temporary:
        completed = subprocess.run(
            ["/opt/homebrew/bin/gfan_mixedvolume", "-j", "8"],
            input=gfan_input(first_variables, first_supports),
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            cwd=temporary,
            check=True,
        )
    mixed_volume = int(completed.stdout.strip())
    assert mixed_volume == 26264

    print("ROOT_SPECIALIZATIONS", samples)
    print("VARIABLES", len(first_variables))
    print("EQUATIONS", len(first_supports))
    print("TERM_COUNTS", term_counts)
    print("TORIC_MIXED_VOLUME", mixed_volume)
    print("TOTAL_DEGREE_BEZOUT_BOUND", 6 * 3**10)
    print("OSCULATING-COVARIANT-COVER-EXACT-SUPPORT-OK")


if __name__ == "__main__":
    main()
