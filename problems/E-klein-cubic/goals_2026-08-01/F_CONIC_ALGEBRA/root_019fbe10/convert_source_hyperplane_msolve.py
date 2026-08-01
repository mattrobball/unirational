#!/usr/bin/env python3
"""Convert generated source-hyperplane Singular charts to msolve inputs."""

from __future__ import annotations

import re
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PARENT = HERE.parent


def convert(path: Path) -> Path:
    text = path.read_text()
    ring_match = re.search(r"ring R=(\d+),\(([^)]+)\),dp;", text)
    poly_match = re.search(r"poly F=(.*);\n", text)
    assert ring_match and poly_match
    prime = int(ring_match.group(1))
    names = ring_match.group(2).split(",")
    variables = sp.symbols(" ".join(names))
    namespace = dict(zip(names, variables))
    expression = sp.sympify(poly_match.group(1).replace("^", "**"), locals=namespace)
    polynomials = [sp.Poly(expression, *variables, modulus=prime)]
    polynomials.extend(sp.Poly(sp.diff(expression, variable), *variables, modulus=prime) for variable in variables)
    output = HERE / (path.stem + ".ms")
    rows = [",".join(names), str(prime)]
    for index, polynomial in enumerate(polynomials):
        value = str(polynomial.as_expr()).replace("**", "^")
        rows.append(value + ("," if index + 1 < len(polynomials) else ""))
    output.write_text("\n".join(rows) + "\n")
    return output


def main() -> None:
    for path in sorted(PARENT.glob("source_hyperplane_*_p23.sing")):
        output = convert(path)
        print(f"built={output.name} bytes={output.stat().st_size}")
    print("SOURCE_HYPERPLANE_MSOLVE_INPUTS_BUILT")


if __name__ == "__main__":
    main()
