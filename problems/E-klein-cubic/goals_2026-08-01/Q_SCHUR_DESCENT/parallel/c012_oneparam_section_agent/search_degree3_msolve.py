#!/usr/bin/env python3
"""Exact mod-11 replay for all degree-at-most-three coefficient charts."""

from __future__ import annotations

import subprocess
import tempfile
from pathlib import Path

import sympy as sp

import search_polynomial_sections as S


def equations_for_degree(cubic, degree):
    xvars = sp.symbols(f"x0:{degree + 1}")
    yvars = sp.symbols(f"y0:{degree + 1}")
    zvars = sp.symbols(f"z0:{degree + 1}")
    variables = xvars + yvars + zvars
    polynomials = [
        sum(block[index] * S.V.s**index for index in range(degree + 1))
        for block in (xvars, yvars, zvars)
    ]
    identity = S.V.reduce_e_polynomial(
        sp.expand(
            cubic.subs(
                {S.V.X: polynomials[0], S.V.Y: polynomials[1], S.V.Z: polynomials[2]}
            )
        ),
        (S.V.s, *variables),
    )
    equations = [coefficient for _, coefficient in sorted(sp.Poly(identity, S.V.s).terms())]
    return variables, equations


def solve_chart(variables, equations, chart, *, verbose=True):
    substitutions = {variables[index]: 0 for index in range(chart)}
    substitutions[variables[chart]] = 1
    remaining = variables[chart + 1 :]
    specialized = [
        sp.expand(value.subs(substitutions).subs(S.V.e, 3)) for value in equations
    ]
    specialized = [value for value in specialized if value != 0]
    if remaining:
        specialized = [
            sp.Poly(value, *remaining, modulus=11).as_expr() for value in specialized
        ]
        specialized = [value for value in specialized if value != 0]
        for value in specialized:
            polynomial = sp.Poly(value, *remaining, modulus=11)
            if polynomial.total_degree() == 0:
                if verbose:
                    print("CHART", chart, variables[chart], "CONSTANT_CONTRADICTION")
                return True
    else:
        # There are no remaining variables in the final projective chart.
        # A nonzero equation is already the certificate 1 in the chart ideal.
        reduced = [int(sp.Integer(value)) % 11 for value in specialized]
        empty = any(value != 0 for value in reduced)
        if verbose:
            print(
                "CHART",
                chart,
                variables[chart],
                "CONSTANT_CONTRADICTION" if empty else "SURVIVOR",
            )
        return empty
    with tempfile.TemporaryDirectory(prefix="c012_msolve_") as temporary:
        directory = Path(temporary)
        input_path = directory / "input.in"
        output_path = directory / "output.out"
        input_path.write_text(
            ",".join(map(str, remaining))
            + "\n11\n"
            + ",\n".join(S.singular_text(value) for value in specialized)
            + "\n"
        )
        completed = subprocess.run(
            [
                "/opt/homebrew/bin/msolve",
                "-f",
                str(input_path),
                "-o",
                str(output_path),
                "-t",
                "4",
                "-v",
                "0",
            ],
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=600,
        )
        output = output_path.read_text() if output_path.exists() else ""
        empty = completed.returncode == 0 and output.strip().startswith("[-1]")
        if verbose:
            print(
                "CHART",
                chart,
                variables[chart],
                "EMPTY" if empty else "SURVIVOR_OR_FAILURE",
            )
        return empty


def main():
    cubic = S.specialized_cubic()
    variables, equations = equations_for_degree(cubic, 3)
    print("VARIABLES", len(variables), "EQUATIONS", len(equations))
    outcomes = []
    for chart in range(len(variables)):
        empty = solve_chart(variables, equations, chart)
        outcomes.append(empty)
    if not all(outcomes):
        raise SystemExit("at least one degree-three chart survived or failed")
    print("ALL_12_PROJECTIVE_CHARTS_EMPTY_MOD_11")


if __name__ == "__main__":
    main()
