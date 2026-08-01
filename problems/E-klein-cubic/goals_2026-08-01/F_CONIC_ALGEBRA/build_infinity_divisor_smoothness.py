#!/usr/bin/env python3
"""Build projective-chart smoothness certificates for the infinity divisor.

The u^6 coefficient of the exact primitive sextic has a factor which becomes
a homogeneous cubic D(L,A,B,Y,T) after the fixed-frame change
Z/L = T/L + 11(A/L)^2/18.  The scripts generated here check, modulo a good
split prime, both D in P^4 and the (3,1) cubic incidence in P^2 x D.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import sympy as sp

from build_coefficient_divisor_factors import coefficients
from model import FORMS, _cyclotomic_residue


HERE = Path(__file__).resolve().parent
L, A, B, Y, T, X, y, w = sp.symbols("L A B Y T X y w")
PARAMETERS = (L, A, B, Y, T)
PLANE = (X, y, w)


def primitive_infinity_divisor() -> sp.Poly:
    c6 = coefficients()[6].as_expr()
    shifted = sp.factor(c6.subs({sp.Symbol("Z"): T + sp.Rational(11, 18) * A**2}))
    factors = sp.factor_list(shifted)[1]
    candidates = []
    for factor, exponent in factors:
        poly = sp.Poly(factor, A, B, Y, T, domain=sp.QQ)
        if exponent == 1 and poly.total_degree() == 3 and T in factor.free_symbols:
            candidates.append(poly)
    assert len(candidates) == 1, [(str(f.as_expr()), e) for f, e in factors]
    affine = candidates[0].primitive()[1]
    homogeneous = sp.Poly(affine.as_expr(), A, B, Y, T).homogenize(L)
    return sp.Poly(homogeneous.as_expr(), *PARAMETERS, domain=sp.QQ).primitive()[1]


def universal_cubic(prime: int, zeta: int) -> sp.Poly:
    payload = json.loads(FORMS.read_text())["binary_slots"]

    def row(name: str) -> list[int]:
        return [_cyclotomic_residue(item, prime, zeta) for item in payload[name]]

    q0, qA, qY = row("q0"), row("qA"), row("qY")
    r0, rA, rB, rY, rT = (row(name) for name in ("r0", "rA", "rB", "rY", "rZ"))

    def quadratic(values: list[int]) -> sp.Expr:
        return values[0] * y**2 + values[1] * y * w + values[2] * w**2

    def cubic(values: list[int]) -> sp.Expr:
        return values[0] * y**3 + values[1] * y**2 * w + values[2] * y * w**2 + values[3] * w**3

    expression = (
        L * (X**3 + X * quadratic(q0) + cubic(r0))
        + A * (X * quadratic(qA) + cubic(rA))
        + B * cubic(rB)
        + Y * (X * quadratic(qY) + cubic(rY))
        + T * cubic(rT)
    )
    return sp.Poly(expression, *(PARAMETERS + PLANE), modulus=prime)


def singular(expression: sp.Expr) -> str:
    return str(sp.expand(expression)).replace("**", "^")


def chart_script(prime: int, variables: tuple[sp.Symbol, ...], expressions: list[sp.Expr], marker: str) -> str:
    return "\n".join(
        [
            f"ring R={prime},({','.join(map(str, variables))}),dp;",
            "option(redSB);",
            "ideal I=" + ",\n".join(singular(item) for item in expressions) + ";",
            "ideal G=std(I);",
            'print("DIM="+string(dim(G)));',
            'if (size(G)<=20) { print("BASIS="); print(G); }',
            "poly n=reduce(1,G);",
            'if (n==0) { print("UNIT=1"); } else { print("UNIT=0"); }',
            f'print("{marker}");',
            "quit;",
            "",
        ]
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=67)
    parser.add_argument("--zeta", type=int)
    args = parser.parse_args()
    prime = args.prime
    if args.zeta is None:
        zeta = next(
            candidate
            for candidate in range(2, prime)
            if pow(candidate, 11, prime) == 1 and candidate % prime != 1
        )
    else:
        zeta = args.zeta % prime
    assert pow(zeta, 11, prime) == 1 and zeta != 1
    Dq = primitive_infinity_divisor()
    D = sp.Poly(Dq.as_expr(), *PARAMETERS, modulus=prime).as_expr()
    H = universal_cubic(prime, zeta).as_expr()
    print(f"D={Dq.as_expr()}")
    print(f"D_terms={len(Dq.terms())} D_degree={Dq.total_degree()}")
    print(f"H_terms={len(sp.Poly(H, *(PARAMETERS + PLANE), modulus=prime).terms())}")

    dD = [sp.diff(D, variable) for variable in PARAMETERS] + [sp.Integer(0)] * 3
    dH = [sp.diff(H, variable) for variable in PARAMETERS + PLANE]
    minors = [
        sp.expand(dD[i] * dH[j] - dD[j] * dH[i])
        for i in range(8)
        for j in range(i + 1, 8)
        if sp.expand(dD[i] * dH[j] - dD[j] * dH[i]) != 0
    ]

    manifest = {
        "prime": prime,
        "zeta": zeta,
        "D": str(Dq.as_expr()),
        "D_terms": len(Dq.terms()),
        "incidence_minor_count": len(minors),
        "D_charts": [],
        "incidence_charts": [],
    }

    for parameter in PARAMETERS:
        substitution = {parameter: 1}
        variables = tuple(item for item in PARAMETERS if item != parameter)
        expressions = [sp.expand(item.subs(substitution)) for item in [D] + [sp.diff(D, q) for q in PARAMETERS]]
        path = HERE / f"infinity_D_smooth_{parameter}_p{prime}.sing"
        marker = f"INFINITY_D_SMOOTH_{parameter}_P{prime}_DONE"
        path.write_text(chart_script(prime, variables, expressions, marker))
        manifest["D_charts"].append(path.name)

    jacobian_expressions = [D, H] + minors
    for parameter in PARAMETERS:
        for plane in PLANE:
            substitution = {parameter: 1, plane: 1}
            variables = tuple(item for item in PARAMETERS + PLANE if item not in (parameter, plane))
            expressions = [sp.expand(item.subs(substitution)) for item in jacobian_expressions]
            path = HERE / f"infinity_incidence_smooth_{parameter}_{plane}_p{prime}.sing"
            marker = f"INFINITY_INCIDENCE_SMOOTH_{parameter}_{plane}_P{prime}_DONE"
            path.write_text(chart_script(prime, variables, expressions, marker))
            manifest["incidence_charts"].append(path.name)

    (HERE / "infinity_divisor_smoothness_manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")
    print("INFINITY_DIVISOR_SMOOTHNESS_SCRIPTS_WRITTEN")


if __name__ == "__main__":
    main()
