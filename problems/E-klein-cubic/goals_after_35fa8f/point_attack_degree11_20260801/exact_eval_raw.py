#!/usr/bin/env python3
"""Exact six-evaluation solver with unnormalized Reynolds covariants.

Omitting arbitrary pivot normalization keeps coefficients at their natural
small 2-power denominators.  Each evaluated cubic is then cleared of its
rational content before the characteristic-zero Groebner calculation.
"""

from __future__ import annotations

from fractions import Fraction
from math import gcd, lcm
from pathlib import Path
import subprocess

import exact_eval_singular as evaluated


HERE = Path(__file__).resolve().parent
exact = evaluated.exact


def raw_reynolds_covariant(output_coordinate, seed_exponent, source):
    components = [{} for _ in range(5)]
    for g in exact.modp.base.A5_PERMS:
        transformed = exact.transform_seed_monomial(source[g], seed_exponent)
        inverse_target = exact.EXACT_TARGET[exact.modp.base.pinv(g)]
        for output in range(5):
            scalar = exact.q5(inverse_target[output][output_coordinate])
            if scalar != exact.ZERO:
                components[output] = exact.poly_add(
                    components[output], exact.poly_scale(scalar, transformed)
                )
    assert any(components)
    return components


def primitive_equation(equation):
    denominator = 1
    for coefficient in equation.values():
        for value in coefficient:
            denominator = lcm(denominator, value.denominator)
    integer_coefficients = {
        exponent: tuple(Fraction(value * denominator) for value in coefficient)
        for exponent, coefficient in equation.items()
    }
    content = 0
    for coefficient in integer_coefficients.values():
        for value in coefficient:
            content = gcd(content, abs(value.numerator))
    assert content
    return {
        exponent: tuple(value / content for value in coefficient)
        for exponent, coefficient in integer_coefficients.items()
    }


def write_singular(equations, order):
    path = HERE / f"degree11_exact_six_evaluations_raw_{order}.sing"
    expressions = [evaluated.chart_expression(equation) for equation in equations]
    path.write_text(
        f"ring r=(0,u),(a1,a2,a3,a4),{order};\n"
        "minpoly=u^4+12*u^2+256;\n"
        f"ideal I={','.join(expressions)};\n"
        "ideal J=std(I);\n"
        'if (reduce(1,J)==0) { print("UNIT"); } else { print("NONUNIT"); J; }\n'
        'print("DIM"); dim(J); print("VDIM"); vdim(J);\n'
        "quit;\n"
    )
    return path


def main():
    source = exact.exact_source_representation()
    covariants = [raw_reynolds_covariant(*seed, source) for seed in exact.SEEDS]
    for covariant in covariants:
        exact.verify_covariant(covariant, source)
    # The same five seeds are independently rank-certified modulo 89 by
    # canonical_modp.py/exact_degree11.py; raw versus normalized Reynolds
    # columns differ only by nonzero diagonal scalars.
    equations = [
        primitive_equation(evaluated.one_evaluation_equation(covariants, point))
        for point in evaluated.POINTS
    ]
    for order in ("dp", "lp"):
        input_path = write_singular(equations, order)
        print("input", input_path, "bytes", input_path.stat().st_size, flush=True)
        result = subprocess.run(
            ["/opt/homebrew/bin/Singular", "-q", str(input_path)],
            check=True, capture_output=True, text=True,
        )
        output_path = input_path.with_suffix(".txt")
        output_path.write_text(result.stdout)
        print(result.stdout, end="", flush=True)
    print("H3_EXACT_SIX_EVALUATION_RAW_OK")


if __name__ == "__main__":
    main()
