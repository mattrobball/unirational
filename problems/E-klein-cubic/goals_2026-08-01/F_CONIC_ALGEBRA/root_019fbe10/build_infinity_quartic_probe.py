#!/usr/bin/env python3
"""Build smoothness charts for the quartic factor of the u^6 coefficient."""

from __future__ import annotations

import importlib.util
import json
from pathlib import Path
import subprocess
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
sys.path.insert(0, str(PARENT))

from build_coefficient_divisor_factors import coefficients  # noqa: E402
from model import FORMS, _cyclotomic_residue  # noqa: E402


PRIME = 89
ZETA = 2
L, A, B, Y, T, X, y, w = sp.symbols("L A B Y T X y w")
PARAMETERS = (L, A, B, Y, T)
PLANE = (X, y, w)


def quartic() -> sp.Poly:
    c6 = coefficients()[6].as_expr()
    Z = sp.Symbol("Z")
    shifted_c6 = sp.factor(
        c6.subs(Z, T + sp.Rational(11, 18) * A**2)
    )
    factors = sp.factor_list(shifted_c6)[1]
    choices = [
        sp.Poly(factor, A, B, Y, T, domain=sp.QQ)
        for factor, exponent in factors
        if exponent == 1
        and sp.Poly(factor, A, B, Y, T, domain=sp.QQ).total_degree() == 3
    ]
    assert len(choices) == 1
    shifted = choices[0].primitive()[1]
    return sp.Poly(shifted.as_expr(), A, B, Y, T).homogenize(L).primitive()[1]


def plane_forms() -> tuple[sp.Expr, ...]:
    slots = json.loads(FORMS.read_text())["binary_slots"]

    def row(name: str) -> list[int]:
        return [_cyclotomic_residue(item, PRIME, ZETA) for item in slots[name]]

    def ternary(q: list[int], r: list[int], leading: bool = False) -> sp.Expr:
        expression = X**3 if leading else 0
        expression += X * (q[0] * y**2 + q[1] * y * w + q[2] * w**2)
        expression += r[0] * y**3 + r[1] * y**2 * w + r[2] * y * w**2 + r[3] * w**3
        return expression

    zero = [0, 0, 0]
    return (
        ternary(row("q0"), row("r0"), True),
        ternary(row("qA"), row("rA")),
        ternary(zero, row("rB")),
        ternary(row("qY"), row("rY")),
        ternary(zero, row("rZ")),
    )


def sing(expression: sp.Expr) -> str:
    return str(sp.expand(expression)).replace("**", "^")


def script(variables: tuple[sp.Symbol, ...], equations: list[sp.Expr], marker: str) -> str:
    return "\n".join(
        [
            f"ring R={PRIME},({','.join(map(str, variables))}),dp;",
            "option(redSB);",
            "ideal I=" + ",\n".join(sing(item) for item in equations) + ";",
            "ideal G=std(I);",
            'print("DIM="+string(dim(G)));',
            "poly n=reduce(1,G);",
            'if (n==0) { print("UNIT=1"); } else { print("UNIT=0"); }',
            f'print("{marker}");',
            "quit;",
            "",
        ]
    )


def run(path: Path) -> str:
    output = subprocess.run(
        ["/opt/homebrew/bin/Singular", str(path)],
        cwd=HERE,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=300,
        check=True,
    ).stdout
    path.with_suffix(".out").write_text(output)
    return output


def main() -> None:
    Dq = quartic()
    D = sp.Poly(Dq.as_expr(), *PARAMETERS, modulus=PRIME).as_expr()
    F0, FA, FB, FY, FZ = plane_forms()
    H = sp.Poly(
        L * F0 + A * FA + B * FB + Y * FY + T * FZ,
        *(PARAMETERS + PLANE),
        modulus=PRIME,
    ).as_expr()
    dD = [sp.diff(D, variable) for variable in PARAMETERS] + [sp.Integer(0)] * 3
    dH = [sp.diff(H, variable) for variable in PARAMETERS + PLANE]
    minors = [
        sp.expand(dD[i] * dH[j] - dD[j] * dH[i])
        for i in range(8)
        for j in range(i + 1, 8)
        if sp.expand(dD[i] * dH[j] - dD[j] * dH[i]) != 0
    ]
    records = []
    for parameter in PARAMETERS:
        substitution = {parameter: 1}
        variables = tuple(item for item in PARAMETERS if item != parameter)
        equations = [
            sp.expand(item.subs(substitution))
            for item in [D] + [sp.diff(D, q) for q in PARAMETERS]
        ]
        path = HERE / f"infinity_Q4_smooth_{parameter}_p{PRIME}.sing"
        marker = f"INFINITY_Q4_SMOOTH_{parameter}_P{PRIME}_DONE"
        path.write_text(script(variables, equations, marker))
        output = run(path)
        records.append({"kind": "base", "chart": str(parameter), "unit": "UNIT=1" in output})
        print(f"{path.name}: {'UNIT' if 'UNIT=1' in output else 'NONUNIT'}")

    for parameter in PARAMETERS:
        for plane in PLANE:
            substitution = {parameter: 1, plane: 1}
            variables = tuple(item for item in PARAMETERS + PLANE if item not in (parameter, plane))
            equations = [sp.expand(item.subs(substitution)) for item in [D, H] + minors]
            path = HERE / f"infinity_Q4_incidence_{parameter}_{plane}_p{PRIME}.sing"
            marker = f"INFINITY_Q4_INCIDENCE_{parameter}_{plane}_P{PRIME}_DONE"
            path.write_text(script(variables, equations, marker))
            output = run(path)
            records.append(
                {
                    "kind": "incidence",
                    "parameter_chart": str(parameter),
                    "plane_chart": str(plane),
                    "unit": "UNIT=1" in output,
                }
            )
            print(f"{path.name}: {'UNIT' if 'UNIT=1' in output else 'NONUNIT'}")

    payload = {
        "prime": PRIME,
        "zeta": ZETA,
        "quartic": str(Dq.as_expr()),
        "quartic_terms": len(Dq.terms()),
        "records": records,
    }
    (HERE / "INFINITY_Q4_PROBE.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("INFINITY_Q4_PROBE_DONE")


if __name__ == "__main__":
    main()
