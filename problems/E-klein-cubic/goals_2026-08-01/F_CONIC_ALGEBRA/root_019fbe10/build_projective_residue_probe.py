#!/usr/bin/env python3
"""Build projective smoothness tests for residue divisors ``u = g``.

The exact primitive sextic is expressed on the affine coefficient chart

    (lambda_0, lambda_A, lambda_B, lambda_Y, lambda_Z) = (1,A,B,Y,T),

where the payload variable is ``Z = T + 11*A^2/18``.  After substituting a
constant ``g`` for ``u``, we homogenize in the five coefficient coordinates.

For each projective base chart this producer tests smoothness of the resulting
hypersurface D_g.  For every base/plane chart pair it also builds the exact
Jacobian-rank test for

    T_g = {(parameter, point) : D_g(parameter)=c(parameter,point)=0}
          subset P^4 x P^2.

A successful finite-field run is only a characteristic-zero smoothness
certificate (by lifting a nonzero Jacobian ideal); it is not a rational-point
or point-count argument.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import sympy as sp

from sys import path as sys_path


HERE = Path(__file__).resolve().parent
PARENT = HERE.parent
sys_path.insert(0, str(PARENT))

from model import FORMS, _cyclotomic_residue  # noqa: E402


PRIMITIVE = PARENT / "payload/global_primitive_u_sextic_exact.tsv"
DEFAULT_PRIME = 23
DEFAULT_ZETA = 2

h, A, B, Y, T, X, y, w, lam = sp.symbols("h A B Y T X y w lambda")
BASE = (h, A, B, Y, T)
POINT = (X, y, w)


def primitive_affine(g: int, prime: int) -> sp.Poly:
    """Return P(A,B,Y,T+11*A^2/18,g) over GF(prime)."""

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
                * pow(g, eu, prime)
            )
    return sp.Poly(expression, A, B, Y, T, modulus=prime)


def homogenize(poly: sp.Poly, prime: int) -> tuple[sp.Poly, int]:
    degree = poly.total_degree()
    expression = 0
    for powers, coefficient in poly.terms():
        total = sum(powers)
        expression += int(coefficient) * h ** (degree - total) * (
            A ** powers[0] * B ** powers[1] * Y ** powers[2] * T ** powers[3]
        )
    return sp.Poly(expression, *BASE, modulus=prime), degree


def cubic(prime: int, zeta: int) -> sp.Poly:
    """The projectively linear five-form cubic over GF(prime)."""

    slots = json.loads(FORMS.read_text())["binary_slots"]

    def row(name: str) -> list[int]:
        return [_cyclotomic_residue(item, prime, zeta) for item in slots[name]]

    q0, qA, qY = row("q0"), row("qA"), row("qY")
    r0, rA, rB, rY, rZ = (
        row("r0"),
        row("rA"),
        row("rB"),
        row("rY"),
        row("rZ"),
    )
    q = [h * q0[i] + A * qA[i] + Y * qY[i] for i in range(3)]
    r = [
        h * r0[i] + A * rA[i] + B * rB[i] + Y * rY[i] + T * rZ[i]
        for i in range(4)
    ]
    value = h * X**3
    value += X * (q[0] * y**2 + q[1] * y * w + q[2] * w**2)
    value += r[0] * y**3 + r[1] * y**2 * w + r[2] * y * w**2 + r[3] * w**3
    # X^3 belongs to F0, so its projective parameter coefficient is h.
    return sp.Poly(value, *BASE, *POINT, modulus=prime)


def singular(expression: sp.Expr) -> str:
    return str(expression).replace("**", "^")


def emit(g: int, prime: int, zeta: int, d_only: bool = False) -> tuple[Path, dict]:
    affine = primitive_affine(g, prime)
    D, degree = homogenize(affine, prime)
    c = cubic(prime, zeta)
    Dexpr = D.as_expr()
    cexpr = c.as_expr()
    dD = [sp.diff(Dexpr, variable) for variable in BASE]
    dc_base = [sp.diff(cexpr, variable) for variable in BASE]
    dc_point = [sp.diff(cexpr, variable) for variable in POINT]

    rows = [
        f"ring R={prime},(h,A,B,Y,T,X,y,w,lambda),dp;",
        "option(redSB);",
        "short=0;",
        f"poly D={singular(Dexpr)};",
        f"poly c={singular(cexpr)};",
    ]
    for variable, derivative in zip(BASE, dD):
        rows.append(f"poly D_{variable}={singular(derivative)};")
    for index, chart in enumerate(BASE):
        generators = ["D"] + [f"D_{variable}" for variable in BASE] + [f"{chart}-1"]
        rows.extend(
            [
                f"ideal JD{index}={','.join(generators)};",
                f"ideal GD{index}=std(JD{index});",
                f'print("D_CHART_{chart}_NF1="+string(reduce(1,GD{index})));',
                f'print("D_CHART_{chart}_DIM="+string(dim(GD{index})-4));',
                f"kill JD{index}; kill GD{index};",
            ]
        )

    if not d_only:
        rank_generators = ["D", "c"]
        rank_generators.extend(singular(value) for value in dc_point)
        rank_generators.extend(
            singular(dc_base[index] - lam * dD[index]) for index in range(len(BASE))
        )
        for base_index, base_chart in enumerate(BASE):
            for point_index, point_chart in enumerate(POINT):
                label = f"{base_chart}_{point_chart}"
                generators = rank_generators + [f"{base_chart}-1", f"{point_chart}-1"]
                rows.extend(
                    [
                        f"ideal JT{base_index}_{point_index}={','.join(generators)};",
                        f"ideal GT{base_index}_{point_index}=std(JT{base_index}_{point_index});",
                        f'print("T_CHART_{label}_NF1="+string(reduce(1,GT{base_index}_{point_index})));',
                        f"kill JT{base_index}_{point_index}; kill GT{base_index}_{point_index};",
                    ]
                )
    marker = "PROJECTIVE_D" if d_only else "PROJECTIVE_RESIDUE"
    rows.extend([f'print("{marker}_G={g}_P={prime}_DONE");', "quit;"])
    stem = "projective_D" if d_only else "projective_residue"
    output = HERE / f"{stem}_g{g}_p{prime}.sing"
    output.write_text("\n".join(rows) + "\n")
    payload = {
        "scope": "smoothness lifting probe; not point evidence",
        "prime": prime,
        "zeta11_residue": zeta,
        "g": g,
        "affine_degree": affine.total_degree(),
        "projective_degree": degree,
        "affine_terms": len(affine.terms()),
        "projective_terms": len(D.terms()),
        "cubic_terms": len(c.terms()),
        "base_charts": [str(item) for item in BASE],
        "point_charts": [str(item) for item in POINT],
        "script": output.name,
        "d_only": d_only,
    }
    (HERE / f"{stem}_g{g}_p{prime}.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    return output, payload


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--g", type=int, default=1)
    parser.add_argument("--prime", type=int, default=DEFAULT_PRIME)
    parser.add_argument("--zeta", type=int, default=DEFAULT_ZETA)
    parser.add_argument("--d-only", action="store_true")
    args = parser.parse_args()
    output, payload = emit(args.g, args.prime, args.zeta, d_only=args.d_only)
    print(json.dumps(payload, indent=2, sort_keys=True))
    print(f"built={output}")


if __name__ == "__main__":
    main()
