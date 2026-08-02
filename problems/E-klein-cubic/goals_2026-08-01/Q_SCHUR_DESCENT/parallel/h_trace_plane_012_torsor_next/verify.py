#!/usr/bin/env python3
"""Exact replay for the C_012 Fisher cover and its U1-adic point.

Fisher's theorem identifying the covariant recipe with the canonical
3-covering is imported.  This verifier checks the recipe, normalization,
C_012 coefficient substitution, and Hensel hypotheses exactly; it does not
decide the global torsor class.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import sympy as sp


PACKET = Path(__file__).resolve().parent
JACOBIAN_PACKET = PACKET.parent / "h_trace_plane_012_jacobian"
TRIPLE_PACKET = PACKET.parent / "h_trace_three_kummer_planes"
MARKER = "H_TRACE_PLANE_012_FISHER_COVER_AND_U1_LOCAL_POINT_OK"

X, Y, Z = sp.symbols("X Y Z")
XYZ = (X, Y, Z)
e, s, t0, t1, t2, t3, t4 = sp.symbols("e s t0 t1 t2 t3 t4")
T_SYMBOLS = (t0, t1, t2, t3, t4)
PHI5 = sp.Poly(e**4 + e**3 + e**2 + e + 1, e, domain=sp.QQ)

# Fisher's standard ten coefficients.
a, b, c, a2, a3, b1, b3, c1, c2, m = sp.symbols(
    "a b c a2 a3 b1 b3 c1 c2 m"
)
COEFFICIENTS = (a, b, c, a2, a3, b1, b3, c1, c2, m)
GENERIC_VARIABLES = XYZ + COEFFICIENTS
GENERIC_CUBIC = (
    a * X**3
    + b * Y**3
    + c * Z**3
    + a2 * X**2 * Y
    + a3 * X**2 * Z
    + b1 * X * Y**2
    + b3 * Y**2 * Z
    + c1 * X * Z**2
    + c2 * Y * Z**2
    + m * X * Y * Z
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def hessian(cubic):
    matrix = sp.Matrix(
        [[sp.diff(cubic, left, right) for right in XYZ] for left in XYZ]
    )
    return sp.expand(-matrix.det() / 2)


def adjugate(matrix):
    # This explicit cofactor formula avoids expensive generic simplification.
    return sp.Matrix(
        3,
        3,
        lambda row, col: (-1) ** (row + col)
        * matrix.minor_submatrix(col, row).det(),
    )


def mixed_adjugate(left_quadric, right_quadric):
    """Coefficient of q in adj(A+qB), where Q=(1/2)x^T A x."""
    q = sp.symbols("q")
    left = sp.hessian(left_quadric, XYZ)
    right = sp.hessian(right_quadric, XYZ)
    return adjugate(left + q * right).applyfunc(
        lambda value: sp.expand(value).coeff(q, 1)
    )


def theta_covariant(cubic, hess):
    grad_cubic = sp.Matrix([sp.diff(cubic, variable) for variable in XYZ])
    grad_hess = sp.Matrix([sp.diff(hess, variable) for variable in XYZ])
    matrix = sp.zeros(3, 3)
    for i in range(3):
        for j in range(3):
            matrix += (
                mixed_adjugate(grad_cubic[i], grad_hess[j]) * XYZ[i] * XYZ[j]
            )
    return sp.expand((grad_cubic.T * matrix * grad_hess)[0])


def jacobian_covariant(cubic, hess, theta_value):
    matrix = sp.Matrix(
        [
            [sp.diff(form, variable) for variable in XYZ]
            for form in (cubic, hess, theta_value)
        ]
    )
    return sp.expand(matrix.det() / 3)


def polynomial_digest(expression) -> str:
    polynomial = sp.Poly(expression, *GENERIC_VARIABLES, domain=sp.QQ)
    rows = [(list(monomial), str(coefficient)) for monomial, coefficient in polynomial.terms()]
    raw = json.dumps(rows, separators=(",", ":")).encode()
    return hashlib.sha256(raw).hexdigest()


def reduce_e_polynomial(expression, coefficient_variables):
    domain = sp.QQ.frac_field(*coefficient_variables)
    polynomial = sp.Poly(sp.expand(expression), e, domain=domain)
    return sp.rem(polynomial, PHI5).as_expr()


def reduce_e_rational(expression, coefficient_variables):
    domain = sp.QQ.frac_field(*coefficient_variables)
    numerator, denominator = sp.cancel(expression).as_numer_denom()
    numerator = sp.rem(sp.Poly(numerator, e, domain=domain), PHI5)
    denominator = sp.rem(sp.Poly(denominator, e, domain=domain), PHI5)
    inverse = sp.invert(denominator, PHI5)
    return sp.rem(numerator * inverse, PHI5).as_expr()


def trace_symbol(index):
    return s ** (index // 5) * T_SYMBOLS[index % 5]


def ordered_plane_012():
    """Independent 27-ordered-term reconstruction of C_012."""
    exponents = (0, 1, 2)
    variables = XYZ
    cubic = 0
    for first in range(3):
        for second in range(3):
            for shifted in range(3):
                total = exponents[first] + exponents[second] + exponents[shifted]
                cubic += (
                    variables[first]
                    * variables[second]
                    * variables[shifted]
                    * e ** exponents[shifted]
                    * trace_symbol(total)
                )
    answer = 0
    for monomial, coefficient in sp.Poly(sp.expand(cubic), *XYZ).terms():
        reduced = reduce_e_polynomial(coefficient, (s, *T_SYMBOLS))
        answer += reduced * X ** monomial[0] * Y ** monomial[1] * Z ** monomial[2]
    return sp.expand(answer)


def equal_mod_phi(left, right):
    difference = sp.Poly(sp.expand(left - right), *XYZ)
    return all(
        reduce_e_polynomial(coefficient, (s, *T_SYMBOLS)) == 0
        for _, coefficient in difference.terms()
    )


def qz_expression(coefficients):
    return sum(sp.Rational(value) * e**degree for degree, value in enumerate(coefficients))


def actual_trace(trace_table, index, u2, u3, u4):
    variables = (s, u2, u3, u4)
    answer = 0
    for term in trace_table[str(index)]:
        monomial = sp.prod(variable ** power for variable, power in zip(variables, term["u"]))
        answer += qz_expression(term["c"]) * monomial
    return sp.expand(answer)


def main():
    payload = json.loads((PACKET / "payload.json").read_text())
    assert payload["marker"] == MARKER
    assert payload["scope"]["not_proved"] == [
        "xi=0 or xi!=0 in H^1(K,J_012[3])",
        "the image [C_012]=0 or [C_012]!=0 in H^1(K,J_012)",
        "a K-rational flex on C_012",
        "a K-rational point or K-pointlessness for C_012",
        "a point or obstruction for the ambient twisted cubic threefold",
        "the full expanded Fisher syzygy after the C_012 trace substitution",
    ]

    actual_hashes = {
        "h_trace_plane_012_jacobian/REPORT.md": sha256(JACOBIAN_PACKET / "REPORT.md"),
        "h_trace_plane_012_jacobian/payload.json": sha256(JACOBIAN_PACKET / "payload.json"),
        "h_trace_plane_012_jacobian/verify.py": sha256(JACOBIAN_PACKET / "verify.py"),
        "h_trace_plane_012_jacobian/REPLAY.md": sha256(JACOBIAN_PACKET / "REPLAY.md"),
        "h_trace_three_kummer_planes/payload.json": sha256(TRIPLE_PACKET / "payload.json"),
    }
    assert actual_hashes == payload["source_hashes"]

    jacobian_payload = json.loads((JACOBIAN_PACKET / "payload.json").read_text())
    triple_payload = json.loads((TRIPLE_PACKET / "payload.json").read_text())
    assert jacobian_payload["marker"] == "H_TRACE_PLANE_012_FISHER_JACOBIAN_OK"
    assert triple_payload["marker"] == "H_TRACE_THREE_KUMMER_TEN_GENERIC_SMOOTH_OK"

    coefficient_map = {
        a: t0,
        b: e * t3,
        c: e**2 * s * t1,
        a2: (2 + e) * t1,
        a3: (2 + e**2) * t2,
        b1: (1 + 2 * e) * t2,
        b3: (2 * e + e**2) * t4,
        c1: (1 + 2 * e**2) * t4,
        c2: (e + 2 * e**2) * s * t0,
        m: 2 * (1 + e + e**2) * t3,
    }
    mapped_cubic = sp.expand(GENERIC_CUBIC.subs(coefficient_map))
    assert equal_mod_phi(mapped_cubic, ordered_plane_012())
    assert len(sp.Poly(mapped_cubic, *XYZ).terms()) == 10
    print("C012_COEFFICIENT_SUBSTITUTION_OK")

    # Exact generic covariant tables.  J is retained by its determinant recipe;
    # expanding its 83,744 generic coefficient monomials is intentionally avoided.
    generic_hess = hessian(GENERIC_CUBIC)
    generic_theta = theta_covariant(GENERIC_CUBIC, generic_hess)
    assert len(sp.Poly(generic_hess, *GENERIC_VARIABLES).terms()) == payload["generic_covariants"]["H_terms"] == 73
    assert polynomial_digest(generic_hess) == payload["generic_covariants"]["H_sha256"]
    assert len(sp.Poly(generic_theta, *GENERIC_VARIABLES).terms()) == payload["generic_covariants"]["Theta_terms"] == 6952
    assert polynomial_digest(generic_theta) == payload["generic_covariants"]["Theta_sha256"]
    print("GENERIC_H_THETA_TABLES_OK")

    # Hesse-family calibration of all three covariants and Fisher's syzygy.
    ha, hb = sp.symbols("ha hb")
    hesse_cubic = ha * (X**3 + Y**3 + Z**3) - 3 * hb * X * Y * Z
    hesse_hess = hessian(hesse_cubic)
    hesse_theta = theta_covariant(hesse_cubic, hesse_hess)
    hesse_j = jacobian_covariant(hesse_cubic, hesse_hess, hesse_theta)
    hesse_c4 = 3**4 * (8 * ha**3 + hb**3) * hb
    hesse_c6 = 3**6 * (8 * ha**6 + 20 * ha**3 * hb**3 - hb**6)
    syzygy = sp.expand(
        hesse_j**2
        - hesse_theta**3
        + 27 * hesse_c4 * hesse_theta * hesse_hess**4
        + 54 * hesse_c6 * hesse_hess**6
    )
    residue = sp.Poly(syzygy, X).rem(sp.Poly(hesse_cubic, X))
    assert residue.is_zero
    counts = payload["hesse_calibration"]
    assert len(sp.Poly(hesse_hess, X, Y, Z, ha, hb).terms()) == counts["H_terms"]
    assert len(sp.Poly(hesse_theta, X, Y, Z, ha, hb).terms()) == counts["Theta_terms"]
    assert len(sp.Poly(hesse_j, X, Y, Z, ha, hb).terms()) == counts["J_terms"]
    print("HESSE_FISHER_COVER_CALIBRATION_OK")

    # Exact U1-adic Hensel hypotheses from the sealed trace tables.
    u2, u3, u4 = sp.symbols("U2 U3 U4")
    trace_table = triple_payload["trace_coefficients"]
    traces = [actual_trace(trace_table, index, u2, u3, u4) for index in range(5)]
    assert reduce_e_polynomial(traces[0].subs(s, 0) - 5, (u2, u3, u4)) == 0
    for index in (1, 3, 4):
        assert reduce_e_polynomial(traces[index].subs(s, 0), (u2, u3, u4)) == 0

    local_substitution = {t0: traces[0], t1: traces[1], t2: traces[2], t3: traces[3], t4: traces[4]}
    actual_cubic = sp.expand(mapped_cubic.subs(local_substitution))
    binary = sp.expand(actual_cubic.subs({X: 0, Z: 1}))
    expected_binary = sp.expand(
        e * traces[3] * Y**3
        + (e**2 + 2 * e) * traces[4] * Y**2
        + (2 * e**2 + e) * s * traces[0] * Y
        + e**2 * s * traces[1]
    )
    assert reduce_e_polynomial(binary - expected_binary, (s, u2, u3, u4, Y)) == 0

    quotient = sp.cancel(binary / s)
    quotient_at_zero = sp.expand(quotient.subs(s, 0))
    assert reduce_e_polynomial(quotient_at_zero.subs(Y, 0), (u2, u3, u4)) == 0
    derivative = reduce_e_polynomial(
        sp.diff(quotient_at_zero, Y).subs(Y, 0), (u2, u3, u4)
    )
    expected_derivative = 5 * (2 * e**2 + e)
    assert reduce_e_polynomial(derivative - expected_derivative, (u2, u3, u4)) == 0
    assert sp.gcd(sp.Poly(expected_derivative, e), PHI5).degree() == 0

    a1_residue = sp.expand(sp.cancel(traces[1] / s).subs(s, 0))
    expected_a1 = (
        (10 * e**2 + 5 * e**3) * u4
        + (-10 - 10 * e**3) * u3
        + (5 + 10 * e) * u2
        + (10 + 5 * e**2) * u2**2
    )
    assert reduce_e_polynomial(a1_residue - expected_a1, (u2, u3, u4)) == 0
    first_y_coefficient = -e**2 * a1_residue / expected_derivative
    second_order_residue = sp.diff(binary.subs(Y, s * first_y_coefficient), s, 2).subs(s, 0) / 2
    assert reduce_e_rational(second_order_residue, (u2, u3, u4)) == 0
    print("U1_ADIC_HENSEL_POINT_OK")

    print("COVER (Z:X:Y)=(H^3:Theta*H:J)")
    print(MARKER)


if __name__ == "__main__":
    main()
