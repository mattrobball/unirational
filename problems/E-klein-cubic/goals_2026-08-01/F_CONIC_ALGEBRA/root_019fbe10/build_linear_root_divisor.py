#!/usr/bin/env python3
"""Build a projective smoothness test for ``P(g(A,B,Y,T))=0``.

Here ``g`` is an affine-linear function.  The corresponding factor
``u-g`` in the reduced primitive sextic still gives a residue-degree-one
place of ``K_proj``.  Allowing a nonconstant ``g`` avoids the structurally
nonnormal compactifications observed for constant roots.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import sympy as sp

from build_projective_residue_probe import (
    A,
    B,
    BASE,
    PRIMITIVE,
    T,
    Y,
    h,
    homogenize,
    singular,
)


HERE = Path(__file__).resolve().parent


def linear_root_affine(coefficients: tuple[int, int, int, int, int], prime: int) -> sp.Poly:
    c0, cA, cB, cY, cT = coefficients
    root = c0 + cA * A + cB * B + cY * Y + cT * T
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
                * root**eu
            )
    return sp.Poly(expression, A, B, Y, T, modulus=prime)


def tag(coefficients: tuple[int, int, int, int, int]) -> str:
    return "_".join(str(value).replace("-", "m") for value in coefficients)


def emit(coefficients: tuple[int, int, int, int, int], prime: int) -> tuple[Path, dict]:
    affine = linear_root_affine(coefficients, prime)
    D, degree = homogenize(affine, prime)
    Dexpr = D.as_expr()
    derivatives = [sp.diff(Dexpr, variable) for variable in BASE]
    root_tag = tag(coefficients)
    output = HERE / f"linear_root_D_{root_tag}_p{prime}.sing"
    rows = [
        f"ring R={prime},(h,A,B,Y,T),dp;",
        "option(redSB);",
        "short=0;",
        f"poly D={singular(Dexpr)};",
    ]
    for variable, derivative in zip(BASE, derivatives):
        rows.append(f"poly D_{variable}={singular(derivative)};")
    for index, chart in enumerate(BASE):
        generators = ["D"] + [f"D_{variable}" for variable in BASE] + [f"{chart}-1"]
        rows.extend(
            [
                f"ideal J{index}={','.join(generators)};",
                f"ideal G{index}=std(J{index});",
                f'print("LINEAR_ROOT_D_CHART_{chart}_NF1="+string(reduce(1,G{index})));',
                f'print("LINEAR_ROOT_D_CHART_{chart}_DIM="+string(dim(G{index})));',
                f"kill J{index}; kill G{index};",
            ]
        )
    rows.extend([f'print("LINEAR_ROOT_D_{root_tag}_P={prime}_DONE");', "quit;"])
    output.write_text("\n".join(rows) + "\n")
    payload = {
        "prime": prime,
        "linear_root_coefficients_c0_cA_cB_cY_cT": list(coefficients),
        "affine_degree": affine.total_degree(),
        "projective_degree": degree,
        "affine_terms": len(affine.terms()),
        "projective_terms": len(D.terms()),
        "script": output.name,
        "smoothness_marker_convention": "NF1=0 means the chart singular ideal is the unit ideal",
    }
    (HERE / f"linear_root_D_{root_tag}_p{prime}.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    return output, payload


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("c0", type=int)
    parser.add_argument("cA", type=int)
    parser.add_argument("cB", type=int)
    parser.add_argument("cY", type=int)
    parser.add_argument("cT", type=int)
    parser.add_argument("--prime", type=int, default=67)
    args = parser.parse_args()
    coefficients = (args.c0, args.cA, args.cB, args.cY, args.cT)
    output, payload = emit(coefficients, args.prime)
    print(json.dumps(payload, indent=2, sort_keys=True))
    print(f"built={output}")


if __name__ == "__main__":
    main()
