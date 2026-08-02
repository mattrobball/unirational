#!/usr/bin/env python3
"""Build the reconstructed generic Z-eliminant from exact interpolation.

The input report contains the 78 coefficient polynomials obtained after
multiplying the monic specialized eliminant by
``(u^2-8u-29)^4``.  This script serializes their primitive integral
combination.  It does not promote interpolation to an ideal-membership
certificate; that separate verification is deliberately still required.
"""

from __future__ import annotations

import argparse
import json
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


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("report", type=Path)
    parser.add_argument(
        "--tsv", type=Path, default=HERE / "singular_Z_eliminant_reconstructed.tsv"
    )
    parser.add_argument(
        "--metadata",
        type=Path,
        default=HERE / "singular_Z_eliminant_reconstructed.json",
    )
    args = parser.parse_args()

    report = json.loads(args.report.read_text())
    entries = report["A_rational_interpolation"]
    by_key = {
        (item["coefficient_index"], item["u_power"]): sp.Poly(
            sp.sympify(item["candidate"]["expression"], locals={"A": A}),
            A,
            domain=sp.QQ,
        )
        for item in entries
    }
    if len(by_key) != 78:
        raise RuntimeError(f"expected 78 coefficient polynomials, got {len(by_key)}")

    expression = Q**4 * Z**6
    for i in range(6):
        numerator = sum(by_key[i, j].as_expr() * u**j for j in range(13))
        expression += numerator * Z**i
    rational_poly = sp.Poly(expression, A, u, Z, domain=sp.QQ)
    denominator_lcm = lcm(
        *(int(coefficient.q) for coefficient in rational_poly.coeffs())
    )
    integer_coeffs = [int(c * denominator_lcm) for c in rational_poly.coeffs()]
    content = reduce(gcd, (abs(c) for c in integer_coeffs if c), 0)
    primitive = sp.Poly(
        rational_poly.as_expr() * sp.Rational(denominator_lcm, content),
        A,
        u,
        Z,
        domain=sp.ZZ,
    )

    lines = ["A\tu\tZ\tcoefficient"]
    for monomial, coefficient in primitive.terms():
        lines.append("\t".join(map(str, (*monomial, int(coefficient)))))
    args.tsv.write_text("\n".join(lines) + "\n")

    metadata = {
        "schema": "klein-t3-reconstructed-singular-Z-eliminant-v1",
        "scope": "discovery pending direct generic ideal-membership verification",
        "input_report": str(args.report),
        "input_report_sha256": file_hash(args.report),
        "variables": ["A", "u", "Z"],
        "degrees": {
            "A": primitive.degree(A),
            "u": primitive.degree(u),
            "Z": primitive.degree(Z),
            "total": primitive.total_degree(),
        },
        "terms": len(primitive.terms()),
        "interpolation_denominator": str(Q**4),
        "clearing_denominator_lcm": denominator_lcm,
        "removed_integer_content": content,
        "tsv": str(args.tsv),
        "tsv_sha256": file_hash(args.tsv),
    }
    args.metadata.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(json.dumps(metadata, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
