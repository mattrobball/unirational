#!/usr/bin/env python3
"""Exact bounded polynomial-section search on the (3,5,7) C_012 slice."""

from __future__ import annotations

import importlib.util
import json
import subprocess
import sys
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
TORSOR_DIR = HERE.parent / "h_trace_plane_012_torsor_next"
TRIPLE_DIR = HERE.parent / "h_trace_three_kummer_planes"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


V = load_module("c012_torsor_verify_for_sections", TORSOR_DIR / "verify.py")


def specialized_cubic():
    triple = json.loads((TRIPLE_DIR / "payload.json").read_text())
    u2, u3, u4 = sp.symbols("U2 U3 U4")
    traces = [
        V.reduce_e_polynomial(
            V.actual_trace(triple["trace_coefficients"], index, u2, u3, u4).subs(
                {u2: 3, u3: 5, u4: 7}
            ),
            (V.s,),
        )
        for index in range(5)
    ]
    coefficient_map = {
        V.a: traces[0],
        V.b: V.e * traces[3],
        V.c: V.e**2 * V.s * traces[1],
        V.a2: (2 + V.e) * traces[1],
        V.a3: (2 + V.e**2) * traces[2],
        V.b1: (1 + 2 * V.e) * traces[2],
        V.b3: (2 * V.e + V.e**2) * traces[4],
        V.c1: (1 + 2 * V.e**2) * traces[4],
        V.c2: (V.e + 2 * V.e**2) * V.s * traces[0],
        V.m: 2 * (1 + V.e + V.e**2) * traces[3],
    }
    cubic = sp.expand(V.GENERIC_CUBIC.subs(coefficient_map))
    return V.reduce_e_polynomial(cubic, (V.s, V.X, V.Y, V.Z))


def singular_text(expression):
    return str(sp.expand(expression)).replace("**", "^")


def chart_program(equations, variables, chart, prime=11, root=3):
    substitutions = {variables[index]: 0 for index in range(chart)}
    substitutions[variables[chart]] = 1
    specialized = [sp.expand(equation.subs(substitutions)) for equation in equations]
    remaining = list(variables[chart + 1 :])
    if not remaining:
        remaining = [sp.symbols("dummy")]
    lines = [f"ring r={prime},({','.join(map(str, remaining))}),dp;"]
    rendered = [
        singular_text(value.subs(V.e, root))
        for value in specialized
        if value != 0
    ]
    if not rendered:
        lines.append("ideal I=0;")
    else:
        lines.append("ideal I=" + ",".join(rendered) + ";")
    lines.extend(
        [
            "ideal G=std(I);",
            "poly witness=reduce(1,G);",
            'if (witness==0) { "EMPTY"; } else { "NONEMPTY_OR_UNKNOWN"; }',
        ]
    )
    return "\n".join(lines) + "\n"


def search_degree(cubic, degree):
    xvars = sp.symbols(f"x0:{degree + 1}")
    yvars = sp.symbols(f"y0:{degree + 1}")
    zvars = sp.symbols(f"z0:{degree + 1}")
    variables = xvars + yvars + zvars
    xpoly = sum(value * V.s**index for index, value in enumerate(xvars))
    ypoly = sum(value * V.s**index for index, value in enumerate(yvars))
    zpoly = sum(value * V.s**index for index, value in enumerate(zvars))
    identity = V.reduce_e_polynomial(
        sp.expand(cubic.subs({V.X: xpoly, V.Y: ypoly, V.Z: zpoly})),
        (V.s, *variables),
    )
    equations = [
        coefficient
        for _, coefficient in sorted(sp.Poly(identity, V.s).terms())
    ]
    print("DEGREE", degree, "VARIABLES", len(variables), "EQUATIONS", len(equations))
    outcomes = []
    for chart in range(len(variables)):
        completed = subprocess.run(
            ["/opt/homebrew/bin/Singular", "-q"],
            input=chart_program(equations, variables, chart),
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=300,
            check=True,
        )
        output = completed.stdout.strip()
        outcome = "EMPTY" if output.endswith("EMPTY") else "NONEMPTY_OR_UNKNOWN"
        outcomes.append(outcome)
        print("CHART", chart, variables[chart], outcome)
    if all(outcome == "EMPTY" for outcome in outcomes):
        print("ALL_CHARTS_EMPTY_MOD_11", degree)
    else:
        print("SURVIVING_CHARTS", degree, [i for i, value in enumerate(outcomes) if value != "EMPTY"])


def main():
    maximum = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    cubic = specialized_cubic()
    print("SPECIALIZED_CUBIC_TERMS", len(sp.Poly(cubic, V.s, V.X, V.Y, V.Z).terms()))
    for degree in range(maximum + 1):
        search_degree(cubic, degree)


if __name__ == "__main__":
    main()
