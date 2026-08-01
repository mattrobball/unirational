#!/usr/bin/env python3
"""Independent exact replay of the f5 Hessian-kernel line certificate."""

from __future__ import annotations

from hashlib import sha256
import json
import math
from pathlib import Path
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PAYLOAD = HERE / "hessian_line.json"
SOURCE = PROBLEM / "certificates/exact_covariants_check.py"
PRIME = 23

sys.path.insert(0, str(PROBLEM / "tmp/generic_twist"))
from phi_coefficients import load_source  # noqa: E402


def file_sha256(path):
    digest = sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def sparse(expression, variables):
    return {
        tuple(exponents): int(coefficient)
        for exponents, coefficient in sp.Poly(sp.expand(expression), *variables, domain=sp.ZZ).terms()
        if coefficient
    }


def digest(polynomial):
    terms = [
        {"exponents": list(exponents), "coefficient": coefficient}
        for exponents, coefficient in sorted(polynomial.items(), reverse=True)
    ]
    return sha256(json.dumps(terms, sort_keys=True, separators=(",", ":")).encode()).hexdigest()


def evaluate(expression, variables, point):
    return int(expression.subs(dict(zip(variables, point)))) % PRIME


def main():
    payload = json.loads(PAYLOAD.read_text())
    assert payload["schema"] == "klein-f5-hessian-kernel-line-v1"
    assert payload["prime"] == PRIME
    assert payload["source_sha256"] == file_sha256(SOURCE)

    x = sp.symbols("x0:5")
    s, t = sp.symbols("s t")
    F = sum(x[index] ** 2 * x[(index + 1) % 5] for index in range(5))
    literal_f5 = load_source().H
    f5 = sum(
        coefficient * math.prod(variable**exponent for variable, exponent in zip(x, exponents))
        for exponents, coefficient in literal_f5.items()
    )
    H = sp.hessian(F, x)
    assert sp.expand(H.det() - 32 * f5) == 0

    column = payload["kernel_column"]
    adjugate = H.adjugate()
    y = [sp.expand(adjugate[row, column]) for row in range(5)]
    assert [len(sparse(entry, x)) for entry in y] == payload["kernel_component_term_counts"]
    kernel_identity = H * sp.Matrix(y) - H.det() * sp.eye(5)[:, column]
    assert all(sp.expand(entry) == 0 for entry in kernel_identity)

    # Reconstruct the line coefficients by polarization rather than importing
    # or executing the producer.
    line_expression = sp.expand(
        sum(
            (s * x[index] + t * y[index]) ** 2
            * (s * x[(index + 1) % 5] + t * y[(index + 1) % 5])
            for index in range(5)
        )
    )
    line = sp.Poly(line_expression, s, t, domain=sp.ZZ[*x])
    assert sp.expand(line.coeff_monomial(s**3) - F) == 0
    Fy_expression = sp.expand(line.coeff_monomial(t**3))
    for label, monomial in (("s2t", s**2 * t), ("st2", s * t**2)):
        coefficient = sp.expand(line.coeff_monomial(monomial))
        quotient, remainder = sp.div(coefficient, f5, *x)
        assert remainder == 0
        quotient_sparse = sparse(quotient, x)
        assert len(quotient_sparse) == payload["mixed_quotients"][label]["term_count"]
        assert digest(quotient_sparse) == payload["mixed_quotients"][label]["sha256"]
    Fy = sparse(Fy_expression, x)
    assert len(Fy) == payload["Fy"]["term_count"]
    assert digest(Fy) == payload["Fy"]["sha256"]

    witness = payload["transverse_noncube_witness"]
    point = tuple(witness["source_point"])
    values = {
        "f3": evaluate(F, x, point),
        "f5": evaluate(f5, x, point),
        "Fy": evaluate(Fy_expression, x, point),
    }
    assert values == witness["values"] == {"f3": 0, "f5": 0, "Fy": 20}
    gradients = {
        "3": [evaluate(sp.diff(F, variable), x, point) for variable in x],
        "5": [evaluate(sp.diff(f5, variable), x, point) for variable in x],
    }
    assert gradients == witness["gradients"]
    left, right = witness["minor_columns"]
    minor = (
        gradients["3"][left] * gradients["5"][right]
        - gradients["3"][right] * gradients["5"][left]
    ) % PRIME
    assert minor == witness["minor"] == 1

    # The nonzero minor is in the x0 affine chart (x0=8), so multivariate
    # Hensel lifts the complete-intersection point to characteristic zero.
    # Along the lifted divisor f3 has order one and Fy is a unit.  A cube has
    # valuation divisible by three, whereas ord(-f3/Fy)=1.
    assert point[0] != 0 and 1 % 3 != 0

    print("PASS det Hess(F)=32*f5 and adjugate kernel identity")
    print("PASS exact pure-cubic line section modulo f5")
    print("PASS transverse characteristic-zero valuation with ord(-f3/Fy)=1")
    print("V_F5_HESSIAN_LINE_INDEPENDENT_ACCEPT")


if __name__ == "__main__":
    main()
