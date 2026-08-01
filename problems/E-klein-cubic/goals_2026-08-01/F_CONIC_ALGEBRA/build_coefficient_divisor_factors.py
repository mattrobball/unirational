#!/usr/bin/env python3
"""Build exact/modular factor probes for the u-end coefficients of P.

This is discovery infrastructure for valuation candidates.  A factorization
of c_0 (respectively c_6) gives a divisor with the residue root u=0
(respectively u=infinity); it is not by itself an index obstruction.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PAYLOAD = HERE / "payload/global_primitive_u_sextic_exact.tsv"
A, B, Y, Z, u = sp.symbols("A B Y Z u")


def coefficients() -> dict[int, sp.Poly]:
    expressions = {degree: 0 for degree in range(7)}
    with PAYLOAD.open() as stream:
        next(stream)
        for line in stream:
            eA, eB, eY, eZ, eu, coefficient = map(int, line.split())
            expressions[eu] += coefficient * A**eA * B**eB * Y**eY * Z**eZ
    return {degree: sp.Poly(expression, A, B, Y, Z) for degree, expression in expressions.items()}


def singular(expression: sp.Expr) -> str:
    return str(expression).replace("**", "^")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=67)
    args = parser.parse_args()
    coeffs = coefficients()
    for degree in (0, 6):
        poly = coeffs[degree]
        print(
            f"c{degree}: terms={len(poly.terms())} total_degree={poly.total_degree()} "
            f"degrees={[poly.degree(x) for x in (A, B, Y, Z)]}"
        )
        exact = HERE / f"coefficient_c{degree}_factor_Q.sing"
        modular = HERE / f"coefficient_c{degree}_factor_p{args.prime}.sing"
        body = [
            "poly C=" + singular(poly.as_expr()) + ";",
            "list L=factorize(C,1);",
            "ideal I=L[1];",
            'print("FACTOR_COUNT="+string(size(I)));',
            "int i;",
            "for (i=1; i<=size(I); i=i+1) {",
            '  print("FACTOR_"+string(i)+"_DEG="+string(deg(I[i])));',
            '  print("FACTOR_"+string(i)+"="+string(I[i]));',
            "}",
            f'print("COEFFICIENT_C{degree}_FACTOR_DONE");',
            "quit;",
        ]
        exact.write_text("ring R=0,(A,B,Y,Z),dp;\n" + "\n".join(body) + "\n")
        modular.write_text(
            f"ring R={args.prime},(A,B,Y,Z),dp;\n" + "\n".join(body) + "\n"
        )
        print(exact)
        print(modular)


if __name__ == "__main__":
    main()
