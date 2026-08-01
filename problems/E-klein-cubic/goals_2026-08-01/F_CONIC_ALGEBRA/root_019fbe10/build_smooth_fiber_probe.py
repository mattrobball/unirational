#!/usr/bin/env python3
"""Build a geometric smoothness test for one finite-field cubic fibre."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import sympy as sp

from build_projective_residue_probe import (
    DEFAULT_PRIME,
    DEFAULT_ZETA,
    POINT,
    A,
    B,
    T,
    Y,
    cubic,
    h,
    primitive_affine,
    singular,
)


HERE = Path(__file__).resolve().parent


def emit(values: tuple[int, int, int, int], prime: int, zeta: int) -> tuple[Path, dict]:
    avalue, bvalue, yvalue, tvalue = values
    D = primitive_affine(1, prime)
    residue = int(D.eval({A: avalue, B: bvalue, Y: yvalue, T: tvalue})) % prime
    if residue != 0:
        raise ValueError(f"point is not on D_1 modulo {prime}: residue={residue}")
    c = cubic(prime, zeta).as_expr().subs(
        {h: 1, A: avalue, B: bvalue, Y: yvalue, T: tvalue}
    )
    c = sp.Poly(c, *POINT, modulus=prime).as_expr()
    derivatives = [sp.diff(c, variable) for variable in POINT]
    rows = [
        f"ring R={prime},(X,y,w),dp;",
        "option(redSB);",
        "short=0;",
        f"poly c={singular(c)};",
        f"poly cX={singular(derivatives[0])};",
        f"poly cy={singular(derivatives[1])};",
        f"poly cw={singular(derivatives[2])};",
    ]
    for index, chart in enumerate(POINT):
        rows.extend(
            [
                f"ideal J{index}=c,cX,cy,cw,{chart}-1;",
                f"ideal G{index}=std(J{index});",
                f'print("SMOOTH_FIBER_CHART_{chart}_NF1="+string(reduce(1,G{index})));',
            ]
        )
    rows.extend(['print("SMOOTH_FIBER_P23_DONE");', "quit;"])
    output = HERE / "smooth_fiber_p23.sing"
    output.write_text("\n".join(rows) + "\n")
    payload = {
        "prime": prime,
        "zeta11_residue": zeta,
        "projective_parameters": [1, *values],
        "affine_parameters": {"A": avalue, "B": bvalue, "Y": yvalue, "T": tvalue},
        "D1_residue": residue,
        "script": output.name,
        "logical_use": "one smooth fibre proves D_1 is not contained in the cubic discriminant",
    }
    (HERE / "smooth_fiber_p23.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    return output, payload


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("A", type=int)
    parser.add_argument("B", type=int)
    parser.add_argument("Y", type=int)
    parser.add_argument("T", type=int)
    parser.add_argument("--prime", type=int, default=DEFAULT_PRIME)
    parser.add_argument("--zeta", type=int, default=DEFAULT_ZETA)
    args = parser.parse_args()
    output, payload = emit((args.A, args.B, args.Y, args.T), args.prime, args.zeta)
    print(json.dumps(payload, indent=2, sort_keys=True))
    print(f"built={output}")


if __name__ == "__main__":
    main()
