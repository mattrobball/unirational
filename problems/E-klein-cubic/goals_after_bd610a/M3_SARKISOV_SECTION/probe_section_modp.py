#!/usr/bin/env python3
"""Build exact good-reduction models for the projective Schur M3 fibration.

This is a discovery producer, not a characteristic-zero section certificate.
It reads the exact 660-term Reynolds-frame certificate, reduces its frozen
characteristic-zero witness at split primes, and emits:

* the cubic-surface generic fibre on the chart ``t=1``;
* the coefficient ideals for nonexceptional sections of H-degree 1 and 4;
* Singular inputs for generic-fibre smoothness and section-scheme dimension.

The independent verifier rebuilds the same data without importing this file.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
FRAME = (
    PROBLEM
    / "goals_2026-08-01"
    / "Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D"
    / "exact_frame.json"
)


def split_root(prime: int) -> int:
    roots = [
        value
        for value in range(2, prime)
        if pow(value, 11, prime) == 1 and value != 1
    ]
    if not roots:
        raise ValueError(f"prime {prime} has no nontrivial 11th root")
    return min(roots)


def reduce_k11(data: list[list[int]], prime: int, zeta: int) -> int:
    value = 0
    for exponent, (numerator, denominator) in enumerate(data):
        value += numerator * pow(denominator, -1, prime) * pow(zeta, exponent, prime)
    return value % prime


def frame_mod_prime(certificate: dict, prime: int) -> tuple[int, list[list[int]]]:
    zeta = split_root(prime)
    frame = [
        [reduce_k11(entry, prime, zeta) for entry in row]
        for row in certificate["frame_at_witness"]
    ]
    return zeta, frame


def transformed_klein(frame: list[list[int]], prime: int) -> sp.Poly:
    a = sp.symbols("a0:5")
    linear = [
        sum(frame[row][column] * a[column] for column in range(5))
        for row in range(5)
    ]
    expression = sum(linear[row] ** 2 * linear[(row + 1) % 5] for row in range(5))
    return sp.Poly(expression, *a, modulus=prime)


def centered(coefficient: int, prime: int) -> int:
    value = coefficient % prime
    return value if value <= prime // 2 else value - prime


def singular_text(poly: sp.Poly, prime: int) -> str:
    names = tuple(str(variable) for variable in poly.gens)
    terms: list[str] = []
    for exponents, raw in poly.terms():
        coefficient = int(raw) % prime
        if not coefficient:
            continue
        factors = [] if coefficient == 1 else [str(coefficient)]
        for name, exponent in zip(names, exponents):
            if exponent == 1:
                factors.append(name)
            elif exponent:
                factors.append(f"{name}^{exponent}")
        terms.append("*".join(factors) if factors else "1")
    return "+".join(terms) if terms else "0"


def generic_fibre(phi: sp.Poly, prime: int) -> sp.Poly:
    a0, a1, a2, u, q = sp.symbols("a0 a1 a2 u q")
    old = phi.gens
    expression = phi.as_expr().subs(
        {old[0]: a0, old[1]: a1, old[2]: a2, old[3]: q * u, old[4]: u}
    )
    return sp.Poly(expression, a0, a1, a2, u, q, modulus=prime)


def section_equations(phi: sp.Poly, degree: int, prime: int) -> dict:
    if degree < 1:
        raise ValueError("this producer handles nonexceptional degree >= 1")
    s, t = sp.symbols("s t")
    a_coefficients = [
        sp.symbols(" ".join(f"A{i}_{j}" for j in range(degree + 1)))
        for i in range(3)
    ]
    b_coefficients = sp.symbols(" ".join(f"b_{j}" for j in range(degree)))
    # SymPy returns a single Symbol rather than a tuple for a one-name request.
    if degree == 1:
        b_coefficients = (b_coefficients,)
    forms = [
        sum(coefficients[j] * s ** (degree - j) * t**j for j in range(degree + 1))
        for coefficients in a_coefficients
    ]
    b = sum(b_coefficients[j] * s ** (degree - 1 - j) * t**j for j in range(degree))
    old = phi.gens
    identity = sp.expand(
        phi.as_expr().subs(
            {
                old[0]: forms[0],
                old[1]: forms[1],
                old[2]: forms[2],
                old[3]: s * b,
                old[4]: t * b,
            }
        )
    )
    parameters = tuple(
        symbol
        for block in (*a_coefficients, b_coefficients)
        for symbol in block
    )
    # Keep the section parameters in the coefficient ring while extracting
    # the binary coefficients.  Treating them as additional monomial
    # variables here would make ``coeff_monomial`` select only their constant
    # terms.
    binary = sp.Poly(identity, s, t)
    equations = []
    for k in range(3 * degree + 1):
        coefficient = sp.Poly(
            binary.coeff_monomial(s ** (3 * degree - k) * t**k),
            *parameters,
            modulus=prime,
        )
        equations.append(coefficient)
    return {
        "degree": degree,
        "parameter_names": [str(value) for value in parameters],
        "parameter_count": len(parameters),
        "projective_parameter_dimension": len(parameters) - 1,
        "equation_count": len(equations),
        "expected_projective_dimension": len(parameters) - 1 - len(equations),
        "equations": [singular_text(equation, prime) for equation in equations],
    }


def smoothness_script(fibre: sp.Poly, prime: int) -> str:
    # q is a transcendental coefficient; the remaining variables are the
    # four homogeneous coordinates on P3.
    variables = [str(value) for value in fibre.gens[:4]]
    q = fibre.gens[4]
    expression = singular_text(fibre, prime)
    lines = [
        f"ring r=({prime},q),({','.join(variables)}),dp;",
        f"poly F={expression};",
        "ideal J=jacob(F);",
    ]
    for chart, variable in enumerate(variables):
        lines.extend(
            [
                f"ideal J{chart}=subst(J,{variable},1);",
                f"ideal G{chart}=std(J{chart});",
                f'print("CHART_{chart}_DIM="+string(dim(G{chart})));',
                f'print("CHART_{chart}_UNIT="+string(reduce(1,G{chart})==0));',
            ]
        )
    lines.append('print("M3_GENERIC_FIBRE_SMOOTHNESS_DONE");')
    return "\n".join(lines) + "\n"


def discriminant_script(fibre: sp.Poly, prime: int) -> str:
    variables = [str(value) for value in fibre.gens[:4]]
    expression = singular_text(fibre, prime)
    lines = [
        f"ring r={prime},({','.join(variables)},q),(dp(4),dp(1));",
        f"poly F={expression};",
        "ideal J=diff(F,a0),diff(F,a1),diff(F,a2),diff(F,u);",
    ]
    for chart, variable in enumerate(variables):
        lines.extend(
            [
                f"ideal J{chart}=subst(J,{variable},1);",
                f"ideal G{chart}=std(J{chart});",
                f"ideal E{chart}=eliminate(G{chart},a0*a1*a2*u);",
                f'print("CHART_{chart}_ELIM_SIZE="+string(size(E{chart})));',
                f"E{chart};",
            ]
        )
    lines.append('print("M3_FIBRE_DISCRIMINANT_CHARTS_DONE");')
    return "\n".join(lines) + "\n"


def section_script(section: dict, prime: int) -> str:
    names = section["parameter_names"]
    equations = section["equations"]
    lines = [
        f"ring r={prime},({','.join(names)}),dp;",
        "ideal I=" + ",\n".join(equations) + ";",
        "ideal G=std(I);",
        'print("SECTION_DEGREE=' + str(section["degree"]) + '");',
        'print("IDEAL_DIM="+string(dim(G)));',
        'print("IDEAL_VDIM="+string(vdim(G)));',
        'print("GB_SIZE="+string(size(G)));',
        'print("M3_SECTION_SCHEME_GB_DONE");',
    ]
    return "\n".join(lines) + "\n"


def build(prime: int) -> dict:
    certificate = json.loads(FRAME.read_text())
    zeta, frame = frame_mod_prime(certificate, prime)
    phi = transformed_klein(frame, prime)
    fibre = generic_fibre(phi, prime)
    sections = [section_equations(phi, degree, prime) for degree in (1, 4)]
    return {
        "schema": "m3-projective-schur-good-reduction-v1",
        "scope": "discovery only; no characteristic-zero K-section inference",
        "prime": prime,
        "zeta11": zeta,
        "witness": certificate["witness"],
        "frame_mod_prime": frame,
        "frame_determinant_nonzero": int(sp.Matrix(frame).det()) % prime != 0,
        "phi_terms": [
            {"exponents": list(exponents), "coefficient": centered(int(value), prime)}
            for exponents, value in phi.terms()
        ],
        "generic_fibre_chart_t1": {
            "substitution": ["a3=q*u", "a4=u"],
            "variables": [str(value) for value in fibre.gens],
            "polynomial": singular_text(fibre, prime),
        },
        "section_schemes": sections,
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=23)
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    payload = build(args.prime)
    if args.write:
        tag = f"p{args.prime}"
        (HERE / f"good_reduction_{tag}.json").write_text(
            json.dumps(payload, indent=2, sort_keys=True) + "\n"
        )
        fibre_data = payload["generic_fibre_chart_t1"]
        # Reconstruct a Poly solely to keep script creation deterministic.
        symbols = sp.symbols(" ".join(fibre_data["variables"]))
        fibre = sp.Poly(
            sp.sympify(fibre_data["polynomial"], locals={str(x): x for x in symbols}),
            *symbols,
            modulus=args.prime,
        )
        (HERE / f"verify_generic_fibre_{tag}.sing").write_text(
            smoothness_script(fibre, args.prime)
        )
        (HERE / f"fibre_discriminant_{tag}.sing").write_text(
            discriminant_script(fibre, args.prime)
        )
        for section in payload["section_schemes"]:
            (HERE / f"section_d{section['degree']}_{tag}.sing").write_text(
                section_script(section, args.prime)
            )
    else:
        print(json.dumps(payload, indent=2, sort_keys=True))


if __name__ == "__main__":
    main()
