#!/usr/bin/env python3
"""Exact factor probes for the flex scheme of the (3,5,7) C_012 slice."""

from __future__ import annotations

import subprocess

import sympy as sp

import search_polynomial_sections as S


def singular_text(expression):
    return str(sp.expand(expression)).replace("**", "^")


def main():
    cubic = S.specialized_cubic()
    hessian_matrix = sp.Matrix(
        [
            [sp.diff(cubic, left, right) for right in (S.V.X, S.V.Y, S.V.Z)]
            for left in (S.V.X, S.V.Y, S.V.Z)
        ]
    )
    hessian = S.V.reduce_e_polynomial(
        sp.expand(-hessian_matrix.det() / 2),
        (S.V.s, S.V.X, S.V.Y, S.V.Z),
    )
    print("CUBIC_TERMS", len(sp.Poly(cubic, S.V.s, S.V.X, S.V.Y, S.V.Z).terms()))
    print("HESSIAN_TERMS", len(sp.Poly(hessian, S.V.s, S.V.X, S.V.Y, S.V.Z).terms()))
    program = [
        "ring r=(0,e),(X,Y,s),dp;",
        "minpoly=e^4+e^3+e^2+e+1;",
        f"poly F={singular_text(cubic.subs(S.V.Z, 1))};",
        f"poly H={singular_text(hessian.subs(S.V.Z, 1))};",
        "poly R=resultant(F,H,X);",
        '"RESULTANT_DEGREES";',
        "deg(R,Y);",
        "deg(R,s);",
        '"RESULTANT_FACTORS";',
        "factorize(R);",
        '"FLEX_IDEAL_DIM_DEG";',
        "ideal I=F,H;",
        "ideal G=std(I);",
        "dim(G);",
        "vdim(G);",
    ]
    completed = subprocess.run(
        ["/opt/homebrew/bin/Singular", "-q"],
        input="\n".join(program) + "\n",
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
        timeout=300,
    )
    print(completed.stdout)


if __name__ == "__main__":
    main()
