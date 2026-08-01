#!/usr/bin/env python3
"""Factor the primitive field polynomial on coefficient hyperplanes."""

from __future__ import annotations

import argparse
from pathlib import Path

import sympy as sp

from build_projective_residue_probe import A, B, PRIMITIVE, T, Y, singular


HERE = Path(__file__).resolve().parent
u = sp.symbols("u")
VARIABLES = (A, B, Y, T, u)


def primitive(prime: int) -> sp.Poly:
    inv18 = pow(18, -1, prime)
    shift = (11 * inv18) % prime
    expression = 0
    with PRIMITIVE.open() as stream:
        next(stream)
        for line in stream:
            eA, eB, eY, eZ, eu, coefficient = map(int, line.split())
            expression += (
                (coefficient % prime)
                * A**eA
                * B**eB
                * Y**eY
                * (T + shift * A**2) ** eZ
                * u**eu
            )
    return sp.Poly(expression, *VARIABLES, modulus=prime)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("hyperplane", choices=["A", "B", "Y", "T"])
    parser.add_argument("--prime", type=int, default=67)
    args = parser.parse_args()
    chosen = {"A": A, "B": B, "Y": Y, "T": T}[args.hyperplane]
    remaining = [item for item in VARIABLES if item != chosen]
    expression = primitive(args.prime).as_expr().subs({chosen: 0})
    poly = sp.Poly(expression, *remaining, modulus=args.prime)
    output = HERE / f"hyperplane_{args.hyperplane}0_field_factor_p{args.prime}.sing"
    rows = [
        f"ring R={args.prime},({','.join(map(str, remaining))}),dp;",
        f"poly P={singular(poly.as_expr())};",
        "list L=factorize(P,1);",
        "ideal I=L[1];",
        'print("FACTOR_COUNT="+string(size(I)));',
        "int i;",
        "for (i=1; i<=size(I); i=i+1) {",
        '  print("FACTOR_"+string(i)+"_TOTAL_DEG="+string(deg(I[i])));',
        '  print("FACTOR_"+string(i)+"="+string(I[i]));',
        "}",
        f'print("HYPERPLANE_{args.hyperplane}0_FIELD_FACTOR_P={args.prime}_DONE");',
        "quit;",
    ]
    output.write_text("\n".join(rows) + "\n")
    print(f"terms={len(poly.terms())} total_degree={poly.total_degree()} u_degree={poly.degree(u)}")
    print(output)


if __name__ == "__main__":
    main()
