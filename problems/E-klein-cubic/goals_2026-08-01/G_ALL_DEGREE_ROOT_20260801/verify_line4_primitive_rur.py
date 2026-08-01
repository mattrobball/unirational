#!/usr/bin/env python3
"""Reject the unsafe modular primitive line-degree-four RUR.

The default msolve genericity recovery added a random linear form and printed
coordinates in a transformed system.  Direct substitution shows that its
coordinates annihilate the 24 homogeneous Klein rows but fail the required
primitive affine-chart equation.  This file is retained only as an
adversarial solver audit; it is not a nonemptiness certificate.
"""

from __future__ import annotations

import ast
import hashlib
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
INPUT = HERE / "m3_line4_central_landing_primitive_chart1.ms"
RUR = HERE / "m3_line4_central_landing_primitive_chart1.rur"
P = 67


def parse_input() -> tuple[list[str], list[str]]:
    lines = INPUT.read_text().splitlines()
    variables = lines[0].split(",")
    assert lines[1] == str(P)
    equations = "\n".join(lines[2:]).split(",\n")
    assert len(variables) == 11
    assert len(equations) == 25
    return variables, equations


def parse_rur(variable_names: list[str]):
    data = ast.literal_eval(RUR.read_text().strip().rstrip(":"))
    assert data[0] == 0
    prime, nvars, degree, names, _linear_form, tail = data[1]
    assert (prime, nvars, degree) == (P, 12, 48)
    assert names[:-1] == variable_names and names[-1] == "A"
    one, (eliminant, denominator, coordinate_blocks) = tail
    assert one == 1
    assert denominator == [0, [1]]
    assert eliminant[0] == 12 and len(eliminant[1]) == 13
    assert len(coordinate_blocks) == 11
    assert all(len(block) == 1 and block[0][0] == 11 for block in coordinate_blocks)
    return eliminant[1], [block[0][1] for block in coordinate_blocks]


def main() -> None:
    variable_names, equations = parse_input()
    eliminant, numerators = parse_rur(variable_names)
    A = sp.symbols("A")
    variables = sp.symbols(" ".join(variable_names))
    f = sp.Poly.from_list(list(reversed(eliminant)), gens=A, modulus=P)
    assert f.degree() == 12 and f.LC() % P == 1

    # The RUR convention is z_i=-g_i(A)/f'(A).  The serialized lwp slot is
    # not this derivative; msolve's interface reconstructs the denominator
    # directly from the eliminant.
    derivative = f.diff()
    derivative_inverse = sp.Poly(
        sp.invert(derivative.as_expr(), f.as_expr(), domain=sp.GF(P)),
        A,
        modulus=P,
    )
    assert (derivative * derivative_inverse).rem(f) == sp.Poly(1, A, modulus=P)
    coordinate_polys = [
        (
            sp.Poly(
                -sum(int(coefficient) * A**exponent for exponent, coefficient in enumerate(numerator)),
                A,
                modulus=P,
            )
            * derivative_inverse
        ).rem(f)
        for numerator in numerators
    ]
    one_poly = sp.Poly(1, A, modulus=P)
    coordinate_powers = []
    for coordinate in coordinate_polys:
        powers = [one_poly]
        for _ in range(3):
            powers.append((powers[-1] * coordinate).rem(f))
        coordinate_powers.append(powers)
    remainders = []
    for index, equation in enumerate(equations):
        expression = sp.sympify(
            equation,
            locals={name: variable for name, variable in zip(variable_names, variables)},
        )
        source = sp.Poly(expression, *variables, modulus=P)
        remainder = sp.Poly(0, A, modulus=P)
        for exponents, coefficient in source.terms():
            term = sp.Poly(int(coefficient), A, modulus=P)
            for coordinate_index, exponent in enumerate(exponents):
                if exponent:
                    term = (
                        term * coordinate_powers[coordinate_index][exponent]
                    ).rem(f)
            remainder = remainder + term
        remainder = remainder.rem(f)
        remainders.append(remainder)
        if index < 24:
            assert remainder.is_zero, (index, remainder)
        else:
            assert remainder == sp.Poly(-1, A, modulus=P), (index, remainder)

    # The final input equation is the second primitive quotient linear form
    # set to one, so every represented point lies outside the D_L-multiple
    # subspace.
    primitive_linear = (
        66 * coordinate_polys[0]
        + 10 * coordinate_polys[4]
        + coordinate_polys[9]
    ).rem(f)
    assert primitive_linear == sp.Poly(0, A, modulus=P)
    print(f"PASS input variables={len(variable_names)} equations={len(equations)}")
    print("PASS RUR degree=48 eliminantDegree=12")
    print("PASS all 24 homogeneous Klein rows vanish modulo the eliminant")
    print("PASS primitive chart equation has nonzero remainder -1")
    print("PASS proposed primitive quotient coordinate equals zero, not one")
    print(
        "RUR_SHA256="
        + hashlib.sha256(RUR.read_bytes()).hexdigest()
    )
    print("SCOPE rejected default-recovery solver output; no support conclusion")
    print("M3_LINE4_DEFAULT_RUR_REJECTED")


if __name__ == "__main__":
    main()
