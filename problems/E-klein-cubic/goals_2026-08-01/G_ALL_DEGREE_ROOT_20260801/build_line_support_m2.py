#!/usr/bin/env python3
"""Build an exact split-67 projective landing ideal for a line bidegree.

This is a discovery producer, not yet an all-degree certificate.  It
reconstructs the coefficient rows from the authoritative Klein matrices and
writes a Macaulay2 saturation input in this isolated directory.
"""

from __future__ import annotations

import argparse
import importlib.util
import sys
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
SOURCE = PROBLEM / "tmp" / "symbolic_compatibility_complex" / "line_landing_bigraded.py"


def weak_compositions(total: int, variables: int):
    result = []

    def visit(prefix, remaining, slots):
        if slots == 1:
            result.append(prefix + (remaining,))
        else:
            for exponent in range(remaining + 1):
                visit(prefix + (exponent,), remaining - exponent, slots - 1)

    visit((), total, variables)
    return result


def monomial(powers):
    factors = []
    for index, exponent in enumerate(powers):
        if exponent == 1:
            factors.append(f"a_{index}")
        elif exponent:
            factors.append(f"a_{index}^{exponent}")
    return "*".join(factors) if factors else "1"


def polynomial(row, monomials):
    terms = []
    for coefficient, powers in zip(row, monomials):
        coefficient = int(coefficient) % 67
        if not coefficient:
            continue
        term = monomial(powers)
        terms.append(term if coefficient == 1 else f"{coefficient}*{term}")
    return "+".join(terms) if terms else "0"


def reconstruct(order: int, line_degree: int):
    transverse_degree = 3 if order == 1 else 6
    assert order in (1, 3)
    spec = importlib.util.spec_from_file_location("goal_g_line_support_builder", SOURCE)
    assert spec and spec.loader
    source = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = source
    spec.loader.exec_module(source)
    reynolds = source.audit.load(source.audit.REYNOLDS, "goal_g_line_support_reynolds")
    module = reynolds.load_reynolds_module()
    source.base.module_global = module
    _, records = source.line_records(module)
    record, rows = source.compute_case(
        module,
        records,
        order,
        transverse_degree,
        line_degree,
        np.random.default_rng(20260801),
    )
    return record, rows % 67


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--order", type=int, choices=(1, 3), required=True)
    parser.add_argument("--line-degree", type=int, required=True)
    args = parser.parse_args()
    record, rows = reconstruct(args.order, args.line_degree)
    dimension = record["equivariant_parameter_dimension"]
    variables = ",".join(f"a_{index}" for index in range(dimension))
    monomials = weak_compositions(3, dimension)
    equations = ",\n  ".join(polynomial(row, monomials) for row in rows)
    output = HERE / f"m{args.order}_line{args.line_degree}_support.m2"
    output.write_text(
        "kk=GF(67);\n"
        f"R=kk[{variables},MonomialOrder=>GRevLex];\n"
        f"I=ideal(\n  {equations}\n);\n"
        "m=ideal gens R;\n"
        "J=saturate(I,m);\n"
        "print(\"INPUT generators=\"|toString(numgens source gens I));\n"
        "print(\"SATURATED_UNIT=\"|toString(J==ideal(1_R)));\n"
        "print(\"SATURATED_DIM=\"|toString(dim J));\n"
        "if J!=ideal(1_R) then print(\"SATURATED_DEGREE=\"|toString(degree J));\n"
        "exit 0;\n"
    )
    print(output)
    print(f"parameters={dimension} rows={len(rows)} cubic_monomials={len(monomials)}")


if __name__ == "__main__":
    main()
