#!/usr/bin/env python3
"""Produce the exact (A-15)-adic infinity valuation certificate.

The degree-six primitive has (A-15)-adic coefficient valuations
  (v(c0),...,v(c6)) = (0,0,0,0,0,0,1).
Hence its Newton polygon has a length-one slope-one segment, giving a
valuation of K_proj above A=15 with residue degree one.

The second layer verifies at a split good prime that the incidence cut out
by F0+15*FA, FB, FY, FZ is smooth in P2 x P3.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
sys.path.insert(0, str(PARENT))

from model import FORMS, _cyclotomic_residue  # noqa: E402


PRIMITIVE = PARENT / "payload/global_primitive_u_sextic_exact.tsv"
PRIME = 67
ZETA = 9
X, y, w = sp.symbols("X y w")
L, Bp, J, T = sp.symbols("L B J T")


def sha256(path: Path) -> str:
    value = hashlib.sha256()
    value.update(path.read_bytes())
    return value.hexdigest()


def a15_valuations() -> tuple[list[int], list[int]]:
    h, AA, BB, YY, ZZ = sp.symbols("h AA BB YY ZZ")
    coefficients = [0] * 7
    with PRIMITIVE.open() as stream:
        next(stream)
        for line in stream:
            eA, eB, eY, eZ, eu, coefficient = map(int, line.split())
            coefficients[eu] += (
                coefficient
                * (15 + h) ** eA
                * BB**eB
                * YY**eY
                * ZZ**eZ
            )
    minima = []
    term_counts = []
    for expression in coefficients:
        polynomial = sp.Poly(sp.expand(expression), h, BB, YY, ZZ)
        minima.append(min(exponents[0] for exponents, _ in polynomial.terms()))
        term_counts.append(len(polynomial.terms()))
    return minima, term_counts


def plane_forms() -> dict[str, sp.Expr]:
    slots = json.loads(FORMS.read_text())["binary_slots"]

    def row(name: str) -> list[int]:
        return [_cyclotomic_residue(item, PRIME, ZETA) for item in slots[name]]

    def ternary(q: list[int], r: list[int], leading: bool = False) -> sp.Expr:
        expression = X**3 if leading else 0
        expression += X * (q[0] * y**2 + q[1] * y * w + q[2] * w**2)
        expression += r[0] * y**3 + r[1] * y**2 * w + r[2] * y * w**2 + r[3] * w**3
        return sp.Poly(expression, X, y, w, modulus=PRIME).as_expr()

    zero_q = [0, 0, 0]
    return {
        "F0": ternary(row("q0"), row("r0"), True),
        "FA": ternary(row("qA"), row("rA")),
        "FB": ternary(zero_q, row("rB")),
        "FY": ternary(row("qY"), row("rY")),
        "FZ": ternary(zero_q, row("rZ")),
    }


def singular(expression: sp.Expr) -> str:
    return str(expression).replace("**", "^")


def chart_script(forms: dict[str, sp.Expr], chart: sp.Symbol) -> str:
    variables = tuple(variable for variable in (X, y, w) if variable != chart)
    equations = [
        sp.Poly(expression.subs(chart, 1), *variables, modulus=PRIME).as_expr()
        for expression in forms.values()
    ]
    return "\n".join(
        [
            f"ring R={PRIME},({','.join(map(str, variables))}),dp;",
            "option(redSB);",
            "ideal I=" + ",".join(singular(equation) for equation in equations) + ";",
            "ideal G=std(I);",
            "poly n=reduce(1,G);",
            'if (n==0) { print("BASEPOINT_EMPTY=1"); } else { print("BASEPOINT_EMPTY=0"); }',
            f'print("B0_FOUR_FORM_BASEPOINT_{chart}_P{PRIME}_DONE");',
            "quit;",
            "",
        ]
    )


def incidence_chart_script(
    forms: dict[str, sp.Expr], parameter_chart: sp.Symbol, plane_chart: sp.Symbol
) -> str:
    expression = (
        L * forms["G0"]
        + Bp * forms["FB"]
        + J * forms["FY"]
        + T * forms["FZ"]
    )
    all_variables = (L, Bp, J, T, X, y, w)
    substitutions = {parameter_chart: 1, plane_chart: 1}
    variables = tuple(
        variable
        for variable in all_variables
        if variable not in (parameter_chart, plane_chart)
    )
    affine = sp.Poly(
        expression.subs(substitutions), *variables, modulus=PRIME
    ).as_expr()
    equations = [affine, *(sp.diff(affine, variable) for variable in variables)]
    marker = f"B0_INCIDENCE_SMOOTH_{parameter_chart}_{plane_chart}_P{PRIME}_DONE"
    return "\n".join(
        [
            f"ring R={PRIME},({','.join(map(str, variables))}),dp;",
            "option(redSB);",
            "ideal I=" + ",".join(singular(equation) for equation in equations) + ";",
            "ideal G=std(I);",
            "poly n=reduce(1,G);",
            'if (n==0) { print("SINGULAR_LOCUS_EMPTY=1"); } else { print("SINGULAR_LOCUS_EMPTY=0"); }',
            f'print("{marker}");',
            "quit;",
            "",
        ]
    )


def main() -> None:
    valuations, term_counts = a15_valuations()
    assert valuations == [0, 0, 0, 0, 0, 0, 1]
    all_forms = plane_forms()
    forms = {
        "G0": sp.Poly(all_forms["F0"] + 15 * all_forms["FA"], X, y, w, modulus=PRIME).as_expr(),
        "FB": all_forms["FB"],
        "FY": all_forms["FY"],
        "FZ": all_forms["FZ"],
    }
    charts = []
    for chart in (X, y, w):
        stem = f"A15_four_form_basepoint_{chart}_p{PRIME}"
        script_path = HERE / f"{stem}.sing"
        output_path = HERE / f"{stem}.out"
        script_path.write_text(chart_script(forms, chart))
        output = subprocess.run(
            ["/opt/homebrew/bin/Singular", str(script_path)],
            cwd=HERE,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            check=True,
            timeout=120,
        ).stdout
        output_path.write_text(output)
        assert "BASEPOINT_EMPTY=1" in output
        assert f"B0_FOUR_FORM_BASEPOINT_{chart}_P{PRIME}_DONE" in output
        charts.append(
            {
                "chart": str(chart),
                "script": script_path.name,
                "output": output_path.name,
                "script_sha256": sha256(script_path),
                "output_sha256": sha256(output_path),
            }
        )

    incidence_charts = []
    for parameter_chart in (L, Bp, J, T):
        for plane_chart in (X, y, w):
            stem = (
                f"A15_incidence_smooth_{parameter_chart}_{plane_chart}_p{PRIME}"
            )
            script_path = HERE / f"{stem}.sing"
            output_path = HERE / f"{stem}.out"
            script_path.write_text(
                incidence_chart_script(forms, parameter_chart, plane_chart)
            )
            output = subprocess.run(
                ["/opt/homebrew/bin/Singular", str(script_path)],
                cwd=HERE,
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                check=True,
                timeout=120,
            ).stdout
            output_path.write_text(output)
            assert "SINGULAR_LOCUS_EMPTY=1" in output
            marker = (
                f"B0_INCIDENCE_SMOOTH_{parameter_chart}_{plane_chart}_P{PRIME}_DONE"
            )
            assert marker in output
            incidence_charts.append(
                {
                    "parameter_chart": str(parameter_chart),
                    "plane_chart": str(plane_chart),
                    "script": script_path.name,
                    "output": output_path.name,
                    "script_sha256": sha256(script_path),
                    "output_sha256": sha256(output_path),
                }
            )

    payload = {
        "format": "goal-F-A15-infinity-valuation-v1",
        "primitive": str(PRIMITIVE.relative_to(PARENT)),
        "primitive_sha256": sha256(PRIMITIVE),
        "forms": str(FORMS),
        "forms_sha256": sha256(FORMS),
        "prime": PRIME,
        "zeta": ZETA,
        "A_minus_15_adic_coefficient_valuations_c0_to_c6": valuations,
        "coefficient_term_counts_c0_to_c6": term_counts,
        "newton_segments": [
            {"start": [0, 0], "end": [5, 0], "slope": 0, "length": 5},
            {"start": [5, 0], "end": [6, 1], "slope": 1, "length": 1},
        ],
        "infinity_segment": {
            "root_valuation": -1,
            "total_degree": 1,
            "ramification_denominator": 1,
            "residue_degree": 1,
        },
        "A15_forms": ["F0+15*FA", "FB", "FY", "FZ"],
        "basepoint_charts": charts,
        "incidence_charts": incidence_charts,
    }
    (HERE / "A15_INFINITY_CERTIFICATE.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("A15_NEWTON_RATIONAL_INFINITY_ACCEPT")
    print("A15_INCIDENCE_SMOOTH_ACCEPT")
    print("A15_INFINITY_CERTIFICATE_WRITTEN")


if __name__ == "__main__":
    main()
