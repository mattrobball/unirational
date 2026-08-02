#!/usr/bin/env python3
"""Reconstruct a generic rational-univariate singular-component algebra.

For a monic square-free eliminant q(Z), direct lex expressions for B and Y
have discriminant-sized denominators.  The trace-dual numerators

    N_B = (B(Z) q'(Z)) mod q,   N_Y = (Y(Z) q'(Z)) mod q

are much simpler.  Exact samples show that multiplying them by
``(u^2-8u-29)^4`` makes every coefficient polynomial of u-degree at most 12.
This script performs that transformation, interpolates first in u and then
in A with independent A holdouts, and emits the common-scale integral RUR

    q = 0,
    B q_Z - N_B = 0,
    Y q_Z - N_Y = 0.

The resulting equations still require direct reduction of all six defining
generators before they become a certificate for the unconstrained singular
ideal.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from functools import reduce
from hashlib import sha256
from math import gcd, lcm
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
A, u, Z = sp.symbols("A u Z")
Q = u**2 - 8 * u - 29


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def qq(text: str) -> sp.Rational:
    value = Fraction(text)
    return sp.Rational(value.numerator, value.denominator)


def newton(points, variable) -> sp.Poly:
    result = sp.Poly(0, variable, domain=sp.QQ)
    basis = sp.Poly(1, variable, domain=sp.QQ)
    for x0, y0 in points:
        correction = sp.cancel((y0 - result.eval(x0)) / basis.eval(x0))
        result += basis.mul_ground(correction)
        basis *= sp.Poly(variable - x0, variable, domain=sp.QQ)
    return result


def primitive_integer(poly: sp.Poly, common_scale: int) -> sp.Poly:
    return sp.Poly(poly.as_expr() * common_scale, A, u, Z, domain=sp.ZZ)


def write_tsv(path: Path, poly: sp.Poly) -> None:
    lines = ["A\tu\tZ\tcoefficient"]
    for monomial, coefficient in poly.terms():
        lines.append("\t".join(map(str, (*monomial, int(coefficient)))))
    path.write_text("\n".join(lines) + "\n")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("payload", type=Path)
    parser.add_argument("--holdout-A", type=int, default=4)
    parser.add_argument(
        "--q-metadata",
        type=Path,
        default=HERE / "singular_Z_eliminant_reconstructed.json",
    )
    parser.add_argument(
        "--q-tsv",
        type=Path,
        default=HERE / "singular_Z_eliminant_reconstructed.tsv",
    )
    parser.add_argument("--prefix", type=Path, default=HERE / "generic_singular_rur")
    args = parser.parse_args()

    rows = [
        row
        for row in json.loads(args.payload.read_text())["rows"]
        if row["dim"] == 0 and row["degree"] == 6
    ]
    by_a: dict[int, list[dict]] = {}
    for row in rows:
        by_a.setdefault(row["A"], []).append(row)

    # First interpolate Q^4*N_B and Q^4*N_Y in u for every fixed A.
    families = {"NB": [[ ] for _ in range(6)], "NY": [[ ] for _ in range(6)]}
    per_a = {}
    for a0, a_rows in sorted(by_a.items()):
        a_rows.sort(key=lambda row: row["u"])
        local = {"NB": [], "NY": []}
        for label, field in (("NB", "B_as_Z"), ("NY", "Y_as_Z")):
            coefficient_values = [[] for _ in range(6)]
            for row in a_rows:
                q = sp.Poly(
                    sum(qq(value) * Z**j for j, value in enumerate(row["monic"])),
                    Z,
                    domain=sp.QQ,
                )
                # The lex generator recorded by the sampler is
                # ``coordinate + r(Z)`` after division by its coordinate
                # coefficient.  Hence the actual coordinate is ``-r(Z)``.
                coordinate = sp.Poly(
                    -sum(qq(value) * Z**j for j, value in enumerate(row[field])),
                    Z,
                    domain=sp.QQ,
                )
                numerator = (coordinate * q.diff()).rem(q)
                q_value = row["u"] ** 2 - 8 * row["u"] - 29
                for j in range(6):
                    coefficient_values[j].append(
                        (row["u"], numerator.nth(j) * q_value**4)
                    )
            for j, points in enumerate(coefficient_values):
                polynomial = newton(points, u)
                if polynomial.degree() > 12 or any(
                    polynomial.eval(x0) != y0 for x0, y0 in points
                ):
                    raise RuntimeError(
                        f"{label}, A={a0}, Z^{j}: u interpolation failed, "
                        f"degree={polynomial.degree()}"
                    )
                families[label][j].append((a0, polynomial))
                local[label].append(polynomial.degree())
        per_a[str(a0)] = local

    # Then interpolate each u coefficient in A and validate on withheld A's.
    reconstructed = {}
    degree_ledger = []
    for label in ("NB", "NY"):
        expression = 0
        for z_power in range(6):
            values = families[label][z_power]
            for u_power in range(13):
                points = [(a0, polynomial.nth(u_power)) for a0, polynomial in values]
                train = points[: -args.holdout_A]
                holdout = points[-args.holdout_A :]
                polynomial_a = newton(train, A)
                valid = all(polynomial_a.eval(x0) == y0 for x0, y0 in holdout)
                if not valid:
                    raise RuntimeError(
                        f"{label}, Z^{z_power}, u^{u_power}: A holdout failed"
                    )
                expression += polynomial_a.as_expr() * u**u_power * Z**z_power
                degree_ledger.append(
                    {
                        "label": label,
                        "Z_power": z_power,
                        "u_power": u_power,
                        "A_degree": (
                            None if polynomial_a.is_zero else int(polynomial_a.degree())
                        ),
                        "holdouts_valid": valid,
                    }
                )
        reconstructed[label] = sp.Poly(expression, A, u, Z, domain=sp.QQ)

    # Recover q0=Q^4*q_monic from the previously emitted primitive scale.
    q_meta = json.loads(args.q_metadata.read_text())
    q_scale = int(q_meta["clearing_denominator_lcm"])
    q_expression = 0
    with args.q_tsv.open() as stream:
        assert next(stream).strip() == "A\tu\tZ\tcoefficient"
        for line in stream:
            a, upow, z_power, coefficient = map(int, line.split())
            q_expression += sp.Rational(coefficient, q_scale) * A**a * u**upow * Z**z_power
    reconstructed["QZ"] = sp.Poly(q_expression, A, u, Z, domain=sp.QQ)

    all_coefficients = []
    for polynomial in reconstructed.values():
        all_coefficients.extend(polynomial.coeffs())
    common_scale = lcm(*(int(value.q) for value in all_coefficients))
    integral = {
        label: primitive_integer(polynomial, common_scale)
        for label, polynomial in reconstructed.items()
    }
    common_content = reduce(
        gcd,
        (
            abs(int(coefficient))
            for polynomial in integral.values()
            for coefficient in polynomial.coeffs()
            if coefficient
        ),
        0,
    )
    if common_content > 1:
        common_scale //= common_content
        integral = {
            label: sp.Poly(
                polynomial.as_expr() / common_content,
                A,
                u,
                Z,
                domain=sp.ZZ,
            )
            for label, polynomial in integral.items()
        }

    paths = {}
    for label, polynomial in integral.items():
        path = args.prefix.with_name(args.prefix.name + f"_{label}.tsv")
        write_tsv(path, polynomial)
        paths[label] = path

    metadata = {
        "schema": "klein-t3-generic-singular-rur-v1",
        "scope": "exact interpolation with A holdouts; direct generator reductions pending",
        "input": str(args.payload),
        "input_sha256": file_hash(args.payload),
        "common_integral_scale": common_scale,
        "equations": [
            "QZ(A,u,Z)=0",
            "B*dQZ/dZ-NB(A,u,Z)=0",
            "Y*dQZ/dZ-NY(A,u,Z)=0",
        ],
        "per_A_u_degrees": per_a,
        "A_degree_ledger": degree_ledger,
        "polynomials": {
            label: {
                "path": str(path),
                "sha256": file_hash(path),
                "terms": len(integral[label].terms()),
                "degrees": {
                    "A": integral[label].degree(A),
                    "u": integral[label].degree(u),
                    "Z": integral[label].degree(Z),
                    "total": integral[label].total_degree(),
                },
            }
            for label, path in paths.items()
        },
    }
    metadata_path = args.prefix.with_name(args.prefix.name + "_metadata.json")
    metadata_path.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps(metadata["polynomials"], indent=2, sort_keys=True))
    print(f"wrote {metadata_path}")


if __name__ == "__main__":
    main()
