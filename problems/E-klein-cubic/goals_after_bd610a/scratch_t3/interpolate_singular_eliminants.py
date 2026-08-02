#!/usr/bin/env python3
"""Interpolate structural formulas from exact T3 singular-locus samples.

The specialized lex data suggest that every coefficient of the monic
``Z``-eliminant has denominator dividing

    (u^2 - 8*u - 29)^4.

This script tests that statement exactly for every sampled ``A`` and then
examines the resulting coefficient functions in ``A``.  Its output remains
discovery evidence until a reconstructed formula is checked directly in the
generic quotient algebra.
"""

from __future__ import annotations

import argparse
import json
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
A, u = sp.symbols("A u")
Q = u**2 - 8 * u - 29


def qq(text: str) -> sp.Rational:
    value = Fraction(text)
    return sp.Rational(value.numerator, value.denominator)


def newton_interpolate(points, variable) -> sp.Poly:
    """Exact interpolation without expanding one huge Lagrange sum."""

    result = sp.Poly(0, variable, domain=sp.QQ)
    basis = sp.Poly(1, variable, domain=sp.QQ)
    for x0, y0 in points:
        correction = sp.cancel((y0 - result.eval(x0)) / basis.eval(x0))
        result += basis.mul_ground(correction)
        basis *= sp.Poly(variable - x0, variable, domain=sp.QQ)
    return result


def polynomial_candidate(points, holdout_count: int):
    """Return the exact polynomial interpolant when holdouts validate it."""

    train = points[:-holdout_count] if holdout_count else points
    holdout = points[-holdout_count:] if holdout_count else []
    value = newton_interpolate(train, A)
    if any(value.eval(x) != y for x, y in holdout):
        return None
    return value


def rational_candidate(points, holdout_count: int):
    """Return a lowest-degree rational interpolant validated on holdouts."""

    if len(points) <= holdout_count + 1:
        return None
    train = points[:-holdout_count] if holdout_count else points
    holdout = points[-holdout_count:] if holdout_count else []
    candidates = []
    for numerator_degree in range(len(train)):
        try:
            value = sp.cancel(sp.rational_interpolate(train, numerator_degree, A))
        except (ValueError, ZeroDivisionError):
            continue
        numerator_expr, denominator_expr = sp.fraction(value)
        numerator = sp.Poly(numerator_expr, A, domain=sp.QQ)
        denominator = sp.Poly(denominator_expr, A, domain=sp.QQ)
        if any(sp.cancel(value.subs(A, x) - y) != 0 for x, y in holdout):
            continue
        complexity = numerator.degree() + denominator.degree()
        candidates.append(
            (complexity, max(numerator.degree(), denominator.degree()), value)
        )
    return min(candidates, default=None, key=lambda item: (item[0], item[1]))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("payload", type=Path, nargs="+")
    parser.add_argument("--holdout-A", type=int, default=3)
    parser.add_argument("--output", type=Path, default=HERE / "interpolation_report.json")
    args = parser.parse_args()

    rows = []
    for payload_path in args.payload:
        payload = json.loads(payload_path.read_text())
        rows.extend(
            row
            for row in payload["rows"]
            if row["dim"] == 0 and row["degree"] == 6
        )
    by_a: dict[int, list[dict]] = {}
    for row in rows:
        by_a.setdefault(row["A"], []).append(row)

    # coeff_polys[i][a0] is q(u)^4 times the i-th monic coefficient.
    coeff_polys: list[dict[int, sp.Poly]] = [dict() for _ in range(6)]
    fibre_report: dict[str, dict] = {}
    for a0, fibre_rows in sorted(by_a.items()):
        fibre_rows.sort(key=lambda row: row["u"])
        entry = {"sample_count": len(fibre_rows), "coefficients": []}
        for i in range(6):
            points = [
                (row["u"], qq(row["monic"][i]) * Q.subs(u, row["u"]) ** 4)
                for row in fibre_rows
            ]
            poly = newton_interpolate(points, u)
            exact = all(poly.eval(x) == y for x, y in points)
            coeff_polys[i][a0] = poly
            entry["coefficients"].append(
                {
                    "index": i,
                    "u_degree": poly.degree(),
                    "exact_on_all_samples": exact,
                    "leading_coefficient": str(poly.LC()),
                }
            )
        fibre_report[str(a0)] = entry

    # For every power of u occurring in a coefficient, try to recover a
    # rational function of A and validate it on the withheld A-values.
    a_report: list[dict] = []
    for i, family in enumerate(coeff_polys):
        max_u_degree = max(poly.degree() for poly in family.values())
        for j in range(max_u_degree + 1):
            points = sorted(
                (a0, poly.nth(j)) for a0, poly in family.items()
            )
            polynomial = polynomial_candidate(points, args.holdout_A)
            item = {
                "coefficient_index": i,
                "u_power": j,
                "A_samples": len(points),
                "holdout_A": args.holdout_A,
                "candidate": None,
            }
            if polynomial is not None:
                item["candidate"] = {
                    "total_degree": polynomial.degree(),
                    "numerator_degree": polynomial.degree(),
                    "denominator_degree": 0,
                    "expression": str(polynomial.as_expr()),
                }
            a_report.append(item)

    report = {
        "schema": "klein-t3-singular-eliminant-interpolation-v1",
        "scope": "discovery, exact specialization interpolation only",
        "input": [str(path) for path in args.payload],
        "denominator_tested": str(Q**4),
        "per_A": fibre_report,
        "A_rational_interpolation": a_report,
    }
    args.output.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    degrees = {
        a0: [coeff_polys[i][a0].degree() for i in range(6)]
        for a0 in sorted(by_a)
    }
    candidates = sum(item["candidate"] is not None for item in a_report)
    print("u-degree patterns:", degrees)
    print(f"A candidates validated: {candidates}/{len(a_report)}")
    print(f"wrote {args.output}")


if __name__ == "__main__":
    main()
