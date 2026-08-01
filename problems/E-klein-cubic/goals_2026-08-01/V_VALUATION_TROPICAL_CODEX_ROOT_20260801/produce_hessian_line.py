#!/usr/bin/env python3
"""Certify the canonical Hessian-kernel line obstruction at f5=0."""

from __future__ import annotations

from hashlib import sha256
import json
import math
from pathlib import Path
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
OUTPUT = HERE / "hessian_line.json"
SOURCE = PROBLEM / "certificates/exact_covariants_check.py"
PRIME = 23
WITNESS = (8, 4, 4, 8, 7)

sys.path.insert(0, str(PROBLEM / "tmp/generic_twist"))
sys.path.insert(0, str(PROBLEM / "tmp/kproj_arithmetic"))
sys.path.insert(0, str(PROBLEM / "tmp/xcd_invariant_field/f10_probe"))
from core import forms, evaluate_mod  # noqa: E402
from reconstruct_generators import derivative  # noqa: E402


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


def sparse_digest(polynomial):
    terms = [
        {"exponents": list(exponents), "coefficient": coefficient}
        for exponents, coefficient in sorted(polynomial.items(), reverse=True)
    ]
    return sha256(json.dumps(terms, sort_keys=True, separators=(",", ":")).encode()).hexdigest()


def evaluate_sparse(polynomial, point, prime=PRIME):
    return sum(
        coefficient * math.prod(pow(value, exponent, prime) for value, exponent in zip(point, exponents))
        for exponents, coefficient in polynomial.items()
    ) % prime


def main():
    x = sp.symbols("x0:5")
    s, t = sp.symbols("s t")
    F = sum(x[index] ** 2 * x[(index + 1) % 5] for index in range(5))
    invariant_forms = forms()
    f3 = sum(coefficient * math.prod(xi**exponent for xi, exponent in zip(x, exponents)) for exponents, coefficient in invariant_forms[3].items())
    f5 = sum(coefficient * math.prod(xi**exponent for xi, exponent in zip(x, exponents)) for exponents, coefficient in invariant_forms[5].items())
    assert sp.expand(F - f3) == 0

    hessian = sp.hessian(F, x)
    determinant = sp.expand(hessian.det())
    assert sp.expand(determinant - 32 * f5) == 0
    adjugate = hessian.adjugate()
    y = [sp.expand(adjugate[row, 0]) for row in range(5)]
    assert any(y)
    adjugate_identity = hessian * sp.Matrix(y) - sp.Matrix([determinant, 0, 0, 0, 0])
    assert all(sp.expand(entry) == 0 for entry in adjugate_identity)

    line = sp.Poly(
        sp.expand(F.subs({x[row]: s * x[row] + t * y[row] for row in range(5)}, simultaneous=True)),
        s,
        t,
        domain=sp.ZZ[*x],
    )
    coefficients = {
        "s3": sp.expand(line.coeff_monomial(s**3)),
        "s2t": sp.expand(line.coeff_monomial(s**2 * t)),
        "st2": sp.expand(line.coeff_monomial(s * t**2)),
        "t3": sp.expand(line.coeff_monomial(t**3)),
    }
    assert sp.expand(coefficients["s3"] - f3) == 0
    quotients = {}
    for label in ("s2t", "st2"):
        quotient, remainder = sp.div(coefficients[label], f5, *x)
        assert remainder == 0
        quotients[label] = sparse(quotient, x)
    Fy = sparse(coefficients["t3"], x)

    values = {
        "f3": evaluate_mod(invariant_forms[3], WITNESS, PRIME),
        "f5": evaluate_mod(invariant_forms[5], WITNESS, PRIME),
        "Fy": evaluate_sparse(Fy, WITNESS),
    }
    assert values == {"f3": 0, "f5": 0, "Fy": 20}
    gradients = {
        str(degree): [
            evaluate_mod(derivative(invariant_forms[degree], variable), WITNESS, PRIME)
            for variable in range(5)
        ]
        for degree in (3, 5)
    }
    assert gradients == {
        "3": [21, 4, 11, 13, 15],
        "5": [12, 10, 22, 14, 21],
    }
    # Columns x1,x2 give determinant 1 mod 23, so the intersection is
    # transverse even after dehomogenizing on the x0 chart.
    minor = (gradients["3"][1] * gradients["5"][2] - gradients["3"][2] * gradients["5"][1]) % PRIME
    assert minor == 1

    payload = {
        "schema": "klein-f5-hessian-kernel-line-v1",
        "prime": PRIME,
        "source": str(SOURCE.relative_to(PROBLEM)),
        "source_sha256": file_sha256(SOURCE),
        "hessian_identity": "det(Hess(F))=32*f5",
        "kernel_column": 0,
        "kernel_component_term_counts": [len(sparse(entry, x)) for entry in y],
        "line_identity_mod_f5": "F(s*x+t*y)=s^3*f3+t^3*F(y) mod f5",
        "mixed_quotients": {
            label: {"term_count": len(value), "sha256": sparse_digest(value)}
            for label, value in quotients.items()
        },
        "Fy": {"degree": 12, "term_count": len(Fy), "sha256": sparse_digest(Fy)},
        "transverse_noncube_witness": {
            "source_point": list(WITNESS),
            "values": values,
            "gradients": gradients,
            "minor_columns": [1, 2],
            "minor": minor,
            "valuation": "ord_Z(-f3/Fy)=1 on a characteristic-zero component Z of (f3=f5=0)",
        },
        "conclusion": (
            "-f3/F(y) is not a cube in C(f5=0); the canonical projective line spanned by x and "
            "ker Hess(F) has no generic rational intersection point with the Klein cubic"
        ),
        "strict_scope": (
            "This excludes one canonical line construction on the genuine f5 residue twist. It does not prove "
            "that the whole residue cubic has no rational point."
        ),
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {OUTPUT}")
    print("V_F5_HESSIAN_LINE_PRODUCED")


if __name__ == "__main__":
    main()
