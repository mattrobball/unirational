#!/usr/bin/env python3
"""Exact dominance audit for all homogeneous F55 covariants of degree < 5.

For each d=1,2,3,4, a self-covariant is determined by the general C11
weight-one degree-d polynomial f; its five coordinates are the cyclic shifts
of f.  We form its Jacobian determinant symbolically over F_5.  The
coefficients in the source variables generate a homogeneous ideal in the
parameters of f.  Singular proves that this coefficient ideal has affine
dimension zero in every degree, so its only geometric point is the origin.
Thus every nonzero covariant below the Frobenius degree has nonzero Jacobian
and is separably dominant.
"""

from __future__ import annotations

import hashlib
import re
import subprocess
import tempfile
from itertools import combinations_with_replacement
from pathlib import Path

import sympy as sp


WEIGHTS = (1, 9, 4, 3, 5)
PRIME = 5
SINGULAR = "/opt/homebrew/bin/Singular"


def exponent_vectors(degree: int):
    result = []
    for indices in combinations_with_replacement(range(5), degree):
        if sum(WEIGHTS[i] for i in indices) % 11 != WEIGHTS[0]:
            continue
        result.append(tuple(indices.count(i) for i in range(5)))
    return tuple(result)


def shifted_monomial(source, exponents, amount):
    value = 1
    for j, exponent in enumerate(exponents):
        value *= source[(j + amount) % 5] ** exponent
    return value


def jacobian_coefficient_ideal(degree: int):
    source = sp.symbols("x0:5")
    basis = exponent_vectors(degree)
    parameters = sp.symbols(f"a0:{len(basis)}")
    coordinates = [
        sum(
            parameters[k] * shifted_monomial(source, exponents, i)
            for k, exponents in enumerate(basis)
        )
        for i in range(5)
    ]
    jacobian = sp.Matrix(
        [[sp.diff(coordinates[i], source[j]) for j in range(5)] for i in range(5)]
    )
    determinant = sp.expand(jacobian.det(method="berkowitz"))
    as_source_polynomial = sp.Poly(determinant, *source, domain="EX")
    coefficients = []
    seen = set()
    for coefficient in as_source_polynomial.coeffs():
        reduced = sp.Poly(coefficient, *parameters, modulus=PRIME).as_expr()
        key = str(reduced)
        if reduced != 0 and key not in seen:
            seen.add(key)
            coefficients.append(reduced)
    return basis, parameters, len(as_source_polynomial.terms()), coefficients


def singular_polynomial(expression) -> str:
    return str(expression).replace("**", "^")


def singular_replay(parameters, coefficients):
    variables = ",".join(map(str, parameters))
    generators = ",".join(singular_polynomial(c) for c in coefficients)
    source = (
        f"ring r={PRIME},({variables}),dp;\n"
        f"ideal I={generators};\n"
        "option(redSB);\n"
        "ideal G=std(I);\n"
        'print(\"GB_SIZE=\"+string(size(G)));\n'
        'print(\"DIM=\"+string(dim(G)));\n'
        'print(\"VDIM=\"+string(vdim(G)));\n'
        "quit;\n"
    )
    with tempfile.TemporaryDirectory(prefix="f55_char5_jacobian_") as temp:
        path = Path(temp) / "jacobian.sing"
        path.write_text(source)
        output = subprocess.run(
            [SINGULAR, "-q", str(path)],
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        ).stdout

    def value(label: str) -> int:
        match = re.search(rf"^{label}=(-?\d+)$", output, re.MULTILINE)
        if not match:
            raise RuntimeError(f"missing {label}:\n{output}")
        return int(match.group(1))

    return {
        "input_sha256": hashlib.sha256(source.encode()).hexdigest(),
        "gb_size": value("GB_SIZE"),
        "dimension": value("DIM"),
        "vector_space_dimension": value("VDIM"),
    }


def main() -> None:
    expected_basis_sizes = {1: 1, 2: 1, 3: 3, 4: 7}
    for degree in range(1, PRIME):
        basis, parameters, source_terms, coefficients = jacobian_coefficient_ideal(
            degree
        )
        assert len(basis) == expected_basis_sizes[degree]
        replay = singular_replay(parameters, coefficients)
        assert replay["dimension"] == 0
        print(
            f"DEGREE={degree} BASIS={len(basis)} "
            f"SOURCE_TERMS={source_terms} COEFFICIENTS={len(coefficients)} "
            f"GB_SIZE={replay['gb_size']} DIM={replay['dimension']} "
            f"VDIM={replay['vector_space_dimension']} "
            f"SHA256={replay['input_sha256']}"
        )
    print("F55-CHAR5-ALL-DEGREE-LT5-COVARIANTS-DOMINANT")


if __name__ == "__main__":
    main()
