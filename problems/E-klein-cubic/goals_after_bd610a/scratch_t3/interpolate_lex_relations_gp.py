#!/usr/bin/env python3
"""Recover exact rational lex relations using PARI's integer kernel.

SymPy's rational interpolation is prohibitively slow for the large exact
coefficients in the linear ``B(Z)`` and ``Y(Z)`` relations.  For a candidate
degree pair ``(p,q)``, the equations

    denominator(y_i) * P(u_i) - numerator(y_i) * Q(u_i) = 0

form an integer matrix.  PARI/GP computes its one-dimensional integer kernel
quickly.  Independent holdout values decide whether the degree window was
large enough.
"""

from __future__ import annotations

import argparse
import json
import math
import re
import subprocess
from fractions import Fraction
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
GP = "/opt/homebrew/bin/gp"
u = sp.symbols("u")


def gp_kernel(rows: list[list[int]]) -> list[int]:
    matrix = ";".join(",".join(map(str, row)) for row in rows)
    program = f"M=[{matrix}];K=matkerint(M);print(Vec(K[,1]));quit;\n"
    result = subprocess.run(
        [GP, "-fq"],
        input=program,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        check=False,
        timeout=300,
    )
    if result.returncode:
        raise RuntimeError(result.stderr[-2000:])
    match = re.search(r"\[([^\]]+)\]", result.stdout)
    if not match:
        raise RuntimeError(f"cannot parse GP output: {result.stdout!r}")
    vector = [int(item.strip()) for item in match.group(1).split(",")]
    content = math.gcd(*(abs(value) for value in vector if value))
    vector = [value // content for value in vector]
    return vector


def recover(points, holdout_count: int, p_degree: int, q_degree: int):
    train = points[:-holdout_count] if holdout_count else points
    holdout = points[-holdout_count:] if holdout_count else []
    rows = []
    for x0, value in train:
        rows.append(
            [value.denominator * x0**j for j in range(p_degree + 1)]
            + [-value.numerator * x0**j for j in range(q_degree + 1)]
        )
    vector = gp_kernel(rows)
    if len(vector) != p_degree + q_degree + 2:
        raise RuntimeError(f"bad kernel length {len(vector)}")
    p_coeffs = vector[: p_degree + 1]
    q_coeffs = vector[p_degree + 1 :]
    while len(p_coeffs) > 1 and not p_coeffs[-1]:
        p_coeffs.pop()
    while len(q_coeffs) > 1 and not q_coeffs[-1]:
        q_coeffs.pop()
    p_poly = sp.Poly.from_list(list(reversed(p_coeffs)), gens=u, domain=sp.ZZ)
    q_poly = sp.Poly.from_list(list(reversed(q_coeffs)), gens=u, domain=sp.ZZ)
    common = sp.gcd(p_poly, q_poly)
    p_poly = sp.exquo(p_poly, common)
    q_poly = sp.exquo(q_poly, common)
    if q_poly.LC() < 0:
        p_poly = -p_poly
        q_poly = -q_poly
    valid = all(
        Fraction(int(p_poly.eval(x0)), int(q_poly.eval(x0))) == value
        for x0, value in holdout
    )
    return p_poly, q_poly, valid


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("payload", type=Path)
    parser.add_argument("--holdout", type=int, default=5)
    parser.add_argument("--numerator-degree", type=int, default=22)
    parser.add_argument("--denominator-degree", type=int, default=22)
    parser.add_argument(
        "--output", type=Path, default=HERE / "lex_relation_interpolation.json"
    )
    args = parser.parse_args()

    rows = json.loads(args.payload.read_text())["rows"]
    rows.sort(key=lambda row: row["u"])
    report = []
    for field in ("Y_as_Z", "B_as_Z"):
        for coefficient_index in range(6):
            points = [
                (row["u"], Fraction(row[field][coefficient_index])) for row in rows
            ]
            p_poly, q_poly, valid = recover(
                points,
                args.holdout,
                args.numerator_degree,
                args.denominator_degree,
            )
            entry = {
                "field": field,
                "coefficient_index": coefficient_index,
                "numerator_degree": p_poly.degree(),
                "denominator_degree": q_poly.degree(),
                "numerator": str(p_poly.as_expr()),
                "denominator": str(q_poly.as_expr()),
                "denominator_factorization": str(sp.factor(q_poly.as_expr())),
                "holdout_count": args.holdout,
                "holdouts_valid": valid,
            }
            report.append(entry)
            print(
                field,
                coefficient_index,
                f"degrees={p_poly.degree()}/{q_poly.degree()}",
                f"valid={valid}",
                flush=True,
            )
    payload = {
        "schema": "klein-t3-lex-relation-rational-interpolation-v1",
        "scope": "discovery, one fixed A specialization",
        "input": str(args.payload),
        "degree_window": [args.numerator_degree, args.denominator_degree],
        "relations": report,
    }
    args.output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {args.output}")


if __name__ == "__main__":
    main()
