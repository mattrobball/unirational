#!/usr/bin/env python3
"""Emit exact split-F67 normal-rank charts for the inherited line-4 locus.

The central-compatible line-degree-four source has coordinates z_0,...,z_10.
Its D_L H_1 subspace is cut out by three linear forms.  We use those forms
as normal coordinates u_0,u_1,u_2, restrict the 24 Klein cubics to u=0,
and compute the 3-column normal Jacobian.  On each projective chart of the
eight-dimensional inherited subspace, rank < 3 is cut out by its 3 x 3
minors.  The emitted Singular scripts decide that degeneracy locus.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
P = 67
SOURCE = HERE / "m3_line4_central_landing.ms"
OUT = HERE / "line4_normal_rigidity"


def mod_expr(expression: sp.Expr, variables: tuple[sp.Symbol, ...]) -> sp.Expr:
    return sp.Poly(sp.expand(expression), *variables, modulus=P).as_expr()


def render(expression: sp.Expr, variables: tuple[sp.Symbol, ...]) -> str:
    poly = sp.Poly(expression, *variables, modulus=P)
    terms: list[str] = []
    for powers, signed_coefficient in poly.terms():
        coefficient = int(signed_coefficient) % P
        factors = []
        for variable, exponent in zip(variables, powers):
            if exponent == 1:
                factors.append(str(variable))
            elif exponent:
                factors.append(f"{variable}^{exponent}")
        monomial = "*".join(factors)
        if monomial and coefficient == 1:
            terms.append(monomial)
        elif monomial:
            terms.append(f"{coefficient}*{monomial}")
        else:
            terms.append(str(coefficient))
    return "+".join(terms) if terms else "0"


def normalized_key(expression: sp.Expr, variables: tuple[sp.Symbol, ...]):
    poly = sp.Poly(expression, *variables, modulus=P)
    if poly.is_zero:
        return None
    terms = poly.terms()
    lead = int(terms[0][1]) % P
    inverse = pow(lead, -1, P)
    return tuple((powers, int(coefficient) * inverse % P) for powers, coefficient in terms)


def parse_source(z: tuple[sp.Symbol, ...]) -> list[sp.Expr]:
    lines = SOURCE.read_text().splitlines()
    assert lines[0] == ",".join(str(variable) for variable in z)
    assert lines[1] == str(P)
    body = "\n".join(lines[2:]).strip()
    expressions = body.split(",\n")
    local = {str(variable): variable for variable in z}
    result = [sp.sympify(expression.replace("^", "**"), locals=local) for expression in expressions]
    assert len(result) == 24
    return result


def main() -> None:
    OUT.mkdir(exist_ok=True)
    z = sp.symbols("z_0:11")
    u = sp.symbols("u_0:3")
    inherited_indices = (0, 1, 2, 3, 4, 5, 7, 8)
    w = tuple(z[index] for index in inherited_indices)
    all_variables = w + u

    # u_i are exactly the three quotient linear forms recorded in the packet.
    substitution = {
        z[6]: u[0] - 20 * z[1] - 63 * z[5],
        z[9]: u[1] - 66 * z[0] - 10 * z[4],
        z[10]: u[2] - 53 * z[2] - 6 * z[3],
    }
    cubics = [mod_expr(poly.subs(substitution), all_variables) for poly in parse_source(z)]
    inherited = [mod_expr(poly.subs(dict.fromkeys(u, 0)), w) for poly in cubics]
    jacobian = [
        [mod_expr(sp.diff(poly, normal).subs(dict.fromkeys(u, 0)), w) for normal in u]
        for poly in cubics
    ]

    scripts = []
    for chart, chart_variable in enumerate(w):
        remaining = tuple(variable for variable in w if variable != chart_variable)
        chart_substitution = {chart_variable: 1}
        equations = []
        keys = set()
        for equation in inherited:
            specialized = mod_expr(equation.subs(chart_substitution), remaining)
            key = normalized_key(specialized, remaining)
            if key is not None and key not in keys:
                keys.add(key)
                equations.append(specialized)
        path = OUT / f"chart{chart}.sing"
        text = "\n".join(
            [
                "option(redSB);",
                f"ring r={P},({','.join(str(variable) for variable in remaining)}),dp;",
                "ideal I=\n  " + ",\n  ".join(render(eq, remaining) for eq in equations) + ";",
                "matrix J[24][3]=\n  "
                + ",\n  ".join(
                    render(mod_expr(entry.subs(chart_substitution), remaining), remaining)
                    for row in jacobian
                    for entry in row
                )
                + ";",
                "ideal M=minor(J,3);",
                "ideal G=std(I+M);",
                f'print("CHART={chart}");',
                'print("NF1");',
                "print(reduce(1,G));",
                'print("DIM");',
                "print(dim(G));",
                "quit;",
            ]
        ) + "\n"
        path.write_text(text)
        scheme_path = OUT / f"scheme_chart{chart}.sing"
        scheme_variables = remaining + u
        scheme_equations = [
            mod_expr(poly.subs(chart_substitution), scheme_variables)
            for poly in cubics
        ]
        scheme_text = "\n".join(
            [
                "option(redSB);",
                f"ring r={P},({','.join(str(variable) for variable in scheme_variables)}),dp;",
                "ideal I=\n  "
                + ",\n  ".join(render(eq, scheme_variables) for eq in scheme_equations)
                + ";",
                "ideal G=std(I);",
                f'print("SCHEME_CHART={chart}");',
                'print("NORMAL_FORMS");',
                "print(reduce(u_0,G));",
                "print(reduce(u_1,G));",
                "print(reduce(u_2,G));",
                'print("DIM");',
                "print(dim(G));",
                'print("VDIM_IF_ZERO");',
                "if (dim(G)==0) { print(vdim(G)); } else { print(-1); }",
                "quit;",
            ]
        ) + "\n"
        scheme_path.write_text(scheme_text)
        scripts.append(
            {
                "chart": chart,
                "chart_variable": str(chart_variable),
                "equation_count": len(equations),
                "path": path.name,
                "sha256": hashlib.sha256(text.encode()).hexdigest(),
                "scheme_path": scheme_path.name,
                "scheme_sha256": hashlib.sha256(scheme_text.encode()).hexdigest(),
            }
        )

    payload = {
        "prime": P,
        "source": SOURCE.name,
        "source_sha256": hashlib.sha256(SOURCE.read_bytes()).hexdigest(),
        "landing_cubic_count": len(cubics),
        "inherited_coordinate_count": len(w),
        "normal_coordinate_count": len(u),
        "normal_minor_count": 2024,
        "normal_coordinate_change": [
            "u_0=20*z_1+63*z_5+z_6",
            "u_1=66*z_0+10*z_4+z_9",
            "u_2=53*z_2+6*z_3+z_10",
        ],
        "charts": scripts,
        "scope": (
            "The chart ideals are the inherited line-degree-one landing equations "
            "plus all 3x3 minors of the normal Jacobian of the line-degree-four "
            "landing equations. Unit ideals prove full normal rank at every "
            "geometric point of the inherited split-F67 support."
        ),
    }
    (OUT / "certificate.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("NORMAL_MINORS=2024")
    print("LINE4_NORMAL_RIGIDITY_INPUTS_OK")


if __name__ == "__main__":
    main()
