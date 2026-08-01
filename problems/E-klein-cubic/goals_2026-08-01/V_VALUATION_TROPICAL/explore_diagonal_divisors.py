#!/usr/bin/env python3
"""Explore exact divisibility of diagonal Hilbert--90 coefficients.

This is a discovery script.  It reconstructs all source polynomials from the
authoritative generic-twist code and tests whether a named primitive invariant
divides F(V) for V in the primitive frame x,C,D,E,K.  Arithmetic is sparse
over ZZ; no finite-field inference is used.
"""

from __future__ import annotations

import sys
from fractions import Fraction
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
sys.path.insert(0, str(PROBLEM / "tmp" / "generic_twist"))
sys.path.insert(0, str(PROBLEM / "tmp" / "kproj_arithmetic"))

from phi_coefficients import all_coefficients  # noqa: E402
from core import forms  # noqa: E402


ZERO = (0, 0, 0, 0, 0)


def monomial_divides(left, right):
    """Return whether x^left divides x^right."""

    return all(a <= b for a, b in zip(left, right))


def sub_exponents(left, right):
    return tuple(a - b for a, b in zip(left, right))


def add_exponents(left, right):
    return tuple(a + b for a, b in zip(left, right))


def primitive(polynomial):
    from math import gcd

    content = 0
    for coefficient in polynomial.values():
        content = gcd(content, abs(coefficient))
    if not polynomial:
        return {}, 0
    leading = max(polynomial)
    sign = -1 if polynomial[leading] < 0 else 1
    divisor = content * sign
    return {term: coefficient // divisor for term, coefficient in polynomial.items()}, divisor


def divide_exact(dividend, divisor):
    """Sparse lexicographic division by one integral primitive polynomial."""

    divisor, divisor_content = primitive(divisor)
    assert divisor and divisor_content
    work = {term: Fraction(coefficient) for term, coefficient in dividend.items()}
    quotient = {}
    remainder = {}
    lead_divisor = max(divisor)
    lead_coefficient = divisor[lead_divisor]
    while work:
        lead = max(work)
        coefficient = work[lead]
        if not monomial_divides(lead_divisor, lead):
            remainder[lead] = coefficient
            del work[lead]
            continue
        quotient_term = sub_exponents(lead, lead_divisor)
        quotient_coefficient = coefficient / lead_coefficient
        quotient[quotient_term] = quotient.get(quotient_term, 0) + quotient_coefficient
        if quotient[quotient_term] == 0:
            del quotient[quotient_term]
        for term, divisor_coefficient in divisor.items():
            target = add_exponents(quotient_term, term)
            work[target] = work.get(target, 0) - quotient_coefficient * divisor_coefficient
            if work[target] == 0:
                del work[target]
    return quotient, remainder, divisor_content


def main():
    names, _, coefficients = all_coefficients()
    invariant_forms = forms()
    diagonal = {names[index]: coefficients[(index, index, index)] for index in range(5)}
    for vector_name, polynomial in diagonal.items():
        print(f"DIAGONAL {vector_name} degree={sum(next(iter(polynomial)))} terms={len(polynomial)}")
        for degree in (3, 5, 6, 8, 11, 12):
            quotient, remainder, content = divide_exact(polynomial, invariant_forms[degree])
            print(
                f"  f{degree}: divides={not remainder} "
                f"quotient_terms={len(quotient)} remainder_terms={len(remainder)} "
                f"divisor_content={content}"
            )
    print("DIAGONAL_DIVISOR_EXPLORATION_COMPLETE")


if __name__ == "__main__":
    main()
