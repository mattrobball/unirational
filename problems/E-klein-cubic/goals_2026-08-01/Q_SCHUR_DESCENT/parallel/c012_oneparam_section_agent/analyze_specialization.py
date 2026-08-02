#!/usr/bin/env python3
"""Exploratory exact arithmetic for the C_012 slice (U2,U3,U4)=(3,5,7)."""

from __future__ import annotations

import importlib.util
import json
import subprocess
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
TORSOR_DIR = HERE.parent / "h_trace_plane_012_torsor_next"
TRIPLE_DIR = HERE.parent / "h_trace_three_kummer_planes"
JACOBIAN_DIR = HERE.parent / "h_trace_plane_012_jacobian"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


TORSOR = load_module("c012_torsor_verify", TORSOR_DIR / "verify.py")


def deserialize_invariant(rows, traces):
    answer = 0
    for row in rows:
        exponent = row["exp"]
        coefficient = sum(
            sp.Rational(row["coeff"][degree]) * TORSOR.e**degree
            for degree in range(4)
        )
        monomial = TORSOR.s ** exponent[0]
        for index in range(5):
            monomial *= traces[index] ** exponent[index + 1]
        answer += coefficient * monomial
    return TORSOR.reduce_e_polynomial(sp.expand(answer), (TORSOR.s,))


def valuation(poly):
    return min(monomial[0] for monomial in sp.Poly(poly, TORSOR.s).as_dict())


def singular_expression(expression):
    return str(sp.expand(expression)).replace("**", "^")


def main():
    triple = json.loads((TRIPLE_DIR / "payload.json").read_text())
    jacobian = json.loads((JACOBIAN_DIR / "payload.json").read_text())
    u2, u3, u4 = sp.symbols("U2 U3 U4")
    traces = [
        TORSOR.reduce_e_polynomial(
            TORSOR.actual_trace(
                triple["trace_coefficients"], index, u2, u3, u4
            ).subs({u2: 3, u3: 5, u4: 7}),
            (TORSOR.s,),
        )
        for index in range(5)
    ]
    c4 = deserialize_invariant(jacobian["c4"]["terms"], traces)
    c6 = deserialize_invariant(jacobian["c6"]["terms"], traces)
    delta_reduced = TORSOR.reduce_e_polynomial(
        sp.expand(c4**3 - c6**2), (TORSOR.s,)
    )
    print("TRACE_DEGREES", *(sp.degree(value, TORSOR.s) for value in traces))
    print("C4_DEG_VAL", sp.degree(c4, TORSOR.s), valuation(c4))
    print("C6_DEG_VAL", sp.degree(c6, TORSOR.s), valuation(c6))
    print(
        "DELTA_DEG_VAL",
        sp.degree(delta_reduced, TORSOR.s),
        valuation(delta_reduced),
    )

    program = [
        "ring r=(0,e),(s),dp;",
        "minpoly=e^4+e^3+e^2+e+1;",
    ]
    for name, value in (("c4", c4), ("c6", c6), ("delta", delta_reduced)):
        program.append(f"poly {name}={singular_expression(value)};")
        program.append(f'"FACTOR_{name.upper()}";')
        program.append(f"factorize({name});")
    completed = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q"],
        input="\n".join(program) + "\n",
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
        timeout=60,
    )
    print(completed.stdout)


if __name__ == "__main__":
    main()
