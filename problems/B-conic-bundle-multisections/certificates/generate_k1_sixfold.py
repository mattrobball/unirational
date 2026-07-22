#!/usr/bin/env python3
"""Generate one affine chart of the k=1 proper-sixfold incidence for msolve.

This is only a sub-incidence of the complete frontier in k1_frontier.md.
It uses the same integral witness as k0_no_triple.m2.  For a linear triple
sigma and B_sigma of degree eight, vanishing of all 21 fifth derivatives at
a projective point is equivalent (away from characteristics 2,3,5,7) to
multiplicity at least six.

Example:
  python3 certificates/generate_k1_sixfold.py \
      --sigma-chart 0 --point-chart 0 > /tmp/k1-0-0.in
  msolve -f /tmp/k1-0-0.in
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path
from typing import TextIO

import sympy as sp


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=32003)
    parser.add_argument("--sigma-chart", type=int, choices=range(9), required=True)
    parser.add_argument("--point-chart", type=int, choices=range(3), required=True)
    parser.add_argument("--output", type=Path)
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    prime = args.prime
    if prime in {2, 3, 5, 7} or not sp.isprime(prime):
        raise ValueError(
            "--prime must be a prime not equal to 2, 3, 5, or 7"
        )

    y0, y1, y2 = sp.symbols("y0 y1 y2")
    ys = (y0, y1, y2)
    mvars = sp.symbols(
        "m00 m01 m02 m10 m11 m12 m20 m21 m22"
    )
    matrix_rows = (mvars[0:3], mvars[3:6], mvars[6:9])

    a00 = (
        4944*y0**3 + 3813*y0**2*y1 - 4050*y0*y1**2 - 8072*y1**3
        - 5532*y0**2*y2 - 2152*y0*y1*y2 + 11483*y1**2*y2
        + 7747*y0*y2**2 - 11710*y1*y2**2 + 9862*y2**3
    )
    a01 = (
        -8284*y0**3 - 1498*y0**2*y1 + 9066*y0*y1**2 - 5917*y1**3
        + 7218*y0**2*y2 - 2587*y0*y1*y2 - 8708*y1**2*y2
        - 11836*y0*y2**2 - 6942*y1*y2**2 + 9040*y2**3
    )
    a02 = (
        10971*y0**3 - 7098*y0**2*y1 - 8552*y0*y1**2 + 6909*y1**3
        - 3498*y0**2*y2 - 11382*y0*y1*y2 - 5629*y1**2*y2
        - 13120*y0*y2**2 + 8281*y1*y2**2 - 161*y2**3
    )
    a11 = (
        3575*y0**3 + 11441*y0**2*y1 - 9478*y0*y1**2 + 8779*y1**3
        + 4124*y0**2*y2 - 13583*y0*y1*y2 - 4375*y1**2*y2
        + 5100*y0*y2**2 + 2143*y1*y2**2 - 2135*y2**3
    )
    a12 = (
        14165*y0**3 - 1193*y0**2*y1 + 7287*y0*y1**2 + 7222*y1**3
        - 10531*y0**2*y2 - 11817*y0*y1*y2 - 5113*y1**2*y2
        + 9987*y0*y2**2 - 12883*y1*y2**2 + 90*y2**3
    )
    a22 = (
        -2432*y0**3 - 7679*y0**2*y1 - 11272*y0*y1**2 + 3401*y1**3
        + 9602*y0**2*y2 + 2193*y0*y1*y2 + 15476*y1**2*y2
        + 14405*y0*y2**2 - 9048*y1*y2**2 + 1114*y2**3
    )

    s0 = sum(matrix_rows[0][j] * ys[j] for j in range(3))
    s1 = sum(matrix_rows[1][j] * ys[j] for j in range(3))
    s2 = sum(matrix_rows[2][j] * ys[j] for j in range(3))

    branch = (
        s0**2*(a11*a22-a12**2)
        + 2*s0*s1*(a02*a12-a01*a22)
        + 2*s0*s2*(a01*a12-a02*a11)
        + s1**2*(a00*a22-a02**2)
        + 2*s1*s2*(a01*a02-a00*a12)
        + s2**2*(a00*a11-a01**2)
    )

    pvars = sp.symbols("p0 p1 p2")
    substitutions: dict[sp.Symbol, sp.Expr] = {
        mvars[args.sigma_chart]: sp.Integer(1),
        pvars[args.point_chart]: sp.Integer(1),
    }
    for i, y in enumerate(ys):
        substitutions[y] = substitutions.get(pvars[i], pvars[i])

    remaining = [
        v for i, v in enumerate(mvars) if i != args.sigma_chart
    ] + [
        v for i, v in enumerate(pvars) if i != args.point_chart
    ]

    equations: list[str] = []
    for i in range(6):
        for j in range(6-i):
            k = 5-i-j
            derivative = sp.diff(branch, y0, i, y1, j, y2, k)
            evaluated = sp.expand(derivative.subs(substitutions))
            polynomial = sp.Poly(evaluated, *remaining, modulus=prime)
            # msolve accepts ordinary integer representatives modulo prime.
            text = str(polynomial.as_expr()).replace("**", "^").replace(" ", "")
            equations.append(text)

    if len(equations) != 21:
        raise AssertionError(f"expected 21 equations, got {len(equations)}")

    stream: TextIO
    if args.output is None:
        stream = sys.stdout
    else:
        stream = args.output.open("w", encoding="ascii")
    try:
        print(",".join(str(v) for v in remaining), file=stream)
        print(prime, file=stream)
        for index, equation in enumerate(equations):
            suffix = "," if index + 1 < len(equations) else ""
            print(equation + suffix, file=stream)
    finally:
        if args.output is not None:
            stream.close()


if __name__ == "__main__":
    try:
        main()
    except BrokenPipeError:
        sys.exit(0)
