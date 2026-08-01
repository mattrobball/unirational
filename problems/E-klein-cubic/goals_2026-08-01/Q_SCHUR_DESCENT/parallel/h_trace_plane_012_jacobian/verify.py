#!/usr/bin/env python3
"""Exact Fisher-invariant extraction for the H=11:5 plane C_012.

This verifier deliberately stops at the Jacobian.  It does not compute the
class of C_012 in H^1(K,J_012), and it does not decide whether C_012(K) is
empty.
"""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path

import sympy as sp


PACKET = Path(__file__).resolve().parent
TRIPLE_PACKET = PACKET.parent / "h_trace_three_kummer_planes"
SOURCE = PACKET.parents[3] / "goal_runs_after_35fa" / "H_11_5_TWIST"
MARKER = "H_TRACE_PLANE_012_FISHER_JACOBIAN_OK"

e, s, t0, t1, t2, t3, t4 = sp.symbols("e s t0 t1 t2 t3 t4")
X, Y, Z = sp.symbols("X Y Z")
T_SYMBOLS = (t0, t1, t2, t3, t4)
BASE_VARIABLES = (s, t0, t1, t2, t3, t4)
CYCLOTOMIC = sp.Poly(e**4 + e**3 + e**2 + e + 1, e)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def reduce_cyclotomic(expression):
    """Canonical representative of a rational expression modulo Phi_5(e)."""
    domain = sp.QQ.frac_field(*BASE_VARIABLES)
    polynomial = sp.Poly(sp.expand(expression), e, domain=domain)
    return sp.cancel(sp.rem(polynomial, CYCLOTOMIC).as_expr())


def epsilon_power(exponent: int):
    return reduce_cyclotomic(e ** (exponent % 5))


def trace_symbol(index: int):
    """T_index from t_0,...,t_4 and T_(m+5)=s*T_m."""
    return s ** (index // 5) * T_SYMBOLS[index % 5]


def compact_plane_012():
    """Independent 27-ordered-term expansion of Tr(H*b^2*sigma(b))."""
    exponents = (0, 1, 2)
    variables = (X, Y, Z)
    cubic = 0
    for first in range(3):
        for second in range(3):
            for shifted in range(3):
                total = exponents[first] + exponents[second] + exponents[shifted]
                cubic += (
                    variables[first]
                    * variables[second]
                    * variables[shifted]
                    * epsilon_power(exponents[shifted])
                    * trace_symbol(total)
                )
    return sp.Poly(sp.expand(cubic), X, Y, Z).as_expr()


def hessian(cubic):
    """Fisher's normalization H(F)=-1/2 det(second derivatives of F)."""
    variables = (X, Y, Z)
    matrix = sp.Matrix(
        [[sp.diff(cubic, left, right) for right in variables] for left in variables]
    )
    return sp.expand(-matrix.det() / 2)


def mixed_hessian(left, right, number_right: int):
    """Coefficient of l^(3-r)m^r in H(l*left+m*right)."""
    variables = (X, Y, Z)
    left_matrix = sp.Matrix(
        [[sp.diff(left, a, b) for b in variables] for a in variables]
    )
    right_matrix = sp.Matrix(
        [[sp.diff(right, a, b) for b in variables] for a in variables]
    )
    answer = 0
    for chosen_tuple in itertools.combinations(range(3), number_right):
        chosen = set(chosen_tuple)
        matrix = sp.Matrix.hstack(
            *[
                right_matrix[:, column] if column in chosen else left_matrix[:, column]
                for column in range(3)
            ]
        )
        answer += matrix.det()
    return sp.expand(-answer / 2)


def fisher_invariants(cubic):
    """Extract c4,c6 from Fisher's Hessian-pencil identity at X^3."""
    hess = hessian(cubic)
    cubic_x3 = sp.Poly(cubic, X, Y, Z).coeff_monomial(X**3)
    hess_x3 = sp.Poly(hess, X, Y, Z).coeff_monomial(X**3)
    if cubic_x3 == 0:
        raise AssertionError("the chosen extraction coefficient vanished")

    lambda2_mu_x3 = sp.Poly(
        mixed_hessian(cubic, hess, 1), X, Y, Z
    ).coeff_monomial(X**3)
    c4 = reduce_cyclotomic(sp.cancel(lambda2_mu_x3 / (3 * cubic_x3)))

    lambda_mu2_x3 = sp.Poly(
        mixed_hessian(cubic, hess, 2), X, Y, Z
    ).coeff_monomial(X**3)
    c6 = reduce_cyclotomic(
        sp.cancel((lambda_mu2_x3 + 3 * c4 * hess_x3) / (6 * cubic_x3))
    )
    return hess, c4, c6


def canonical_terms(expression):
    """Group a polynomial by s,t_i exponent with Q(e) coefficient vectors."""
    polynomial = sp.Poly(sp.expand(expression), *BASE_VARIABLES, e, domain=sp.QQ)
    grouped = {}
    for monomial, coefficient in polynomial.terms():
        exponent = monomial[:6]
        epsilon_degree = monomial[6]
        if epsilon_degree >= 4:
            raise AssertionError("expression was not cyclotomically reduced")
        grouped.setdefault(exponent, [sp.Rational(0)] * 4)[epsilon_degree] += coefficient
    return [
        {
            "exp": list(exponent),
            "coeff": [str(value) for value in grouped[exponent]],
        }
        for exponent in sorted(grouped)
    ]


def digest_terms(terms) -> str:
    raw = json.dumps(terms, sort_keys=True, separators=(",", ":")).encode()
    return hashlib.sha256(raw).hexdigest()


def expanded_term_count(terms) -> int:
    return sum(sum(value != "0" for value in term["coeff"]) for term in terms)


def hesse_calibration():
    """Check the normalization on a(x^3+y^3+z^3)-3bxyz."""
    a, b = sp.symbols("a b")
    cubic = a * (X**3 + Y**3 + Z**3) - 3 * b * X * Y * Z
    hess = hessian(cubic)
    cubic_x3 = sp.Poly(cubic, X, Y, Z).coeff_monomial(X**3)
    hess_x3 = sp.Poly(hess, X, Y, Z).coeff_monomial(X**3)
    lambda2_mu_x3 = sp.Poly(
        mixed_hessian(cubic, hess, 1), X, Y, Z
    ).coeff_monomial(X**3)
    c4 = sp.factor(lambda2_mu_x3 / (3 * cubic_x3))
    lambda_mu2_x3 = sp.Poly(
        mixed_hessian(cubic, hess, 2), X, Y, Z
    ).coeff_monomial(X**3)
    c6 = sp.factor((lambda_mu2_x3 + 3 * c4 * hess_x3) / (6 * cubic_x3))
    assert sp.expand(c4 - 3**4 * (8 * a**3 + b**3) * b) == 0
    assert sp.expand(c6 - 3**6 * (8 * a**6 + 20 * a**3 * b**3 - b**6)) == 0


def main():
    payload = json.loads((PACKET / "payload.json").read_text())
    assert payload["marker"] == MARKER
    assert payload["triple"] == [0, 1, 2]
    assert payload["canonical_variables"] == ["s", "t0", "t1", "t2", "t3", "t4"]

    expected_source_hashes = payload["source_hashes"]
    actual_source_hashes = {
        "h_trace_three_kummer_planes/REPORT.md": sha256(TRIPLE_PACKET / "REPORT.md"),
        "h_trace_three_kummer_planes/payload.json": sha256(TRIPLE_PACKET / "payload.json"),
        "h_trace_three_kummer_planes/verify.py": sha256(TRIPLE_PACKET / "verify.py"),
        "h_trace_three_kummer_planes/REPLAY.md": sha256(TRIPLE_PACKET / "REPLAY.md"),
        "H_11_5_TWIST/FIELD_MODEL.md": sha256(SOURCE / "FIELD_MODEL.md"),
        "H_11_5_TWIST/TWIST_MODEL.md": sha256(SOURCE / "TWIST_MODEL.md"),
    }
    assert actual_source_hashes == expected_source_hashes

    triple_payload = json.loads((TRIPLE_PACKET / "payload.json").read_text())
    assert triple_payload["marker"] == "H_TRACE_THREE_KUMMER_TEN_GENERIC_SMOOTH_OK"
    assert [0, 1, 2] in triple_payload["triples"]
    assert triple_payload["formula"] == payload["imported_compact_formula"]

    hesse_calibration()
    print("HESSE_CALIBRATION_OK")

    cubic = compact_plane_012()
    assert len(sp.Poly(cubic, X, Y, Z).terms()) == payload["counts"]["ternary_terms"] == 10
    hess, c4, c6 = fisher_invariants(cubic)
    c4_terms = canonical_terms(c4)
    c6_terms = canonical_terms(c6)

    assert c4_terms == payload["c4"]["terms"]
    assert c6_terms == payload["c6"]["terms"]
    assert len(c4_terms) == payload["c4"]["grouped_terms"]
    assert len(c6_terms) == payload["c6"]["grouped_terms"]
    assert expanded_term_count(c4_terms) == payload["c4"]["expanded_terms"]
    assert expanded_term_count(c6_terms) == payload["c6"]["expanded_terms"]
    assert digest_terms(c4_terms) == payload["c4"]["sha256"]
    assert digest_terms(c6_terms) == payload["c6"]["sha256"]

    assert len(
        sp.Poly(sp.expand(cubic), X, Y, Z, *BASE_VARIABLES, e).terms()
    ) == payload["counts"]["expanded_cubic_terms"]
    assert len(
        sp.Poly(sp.expand(hess), X, Y, Z, *BASE_VARIABLES, e).terms()
    ) == payload["counts"]["expanded_hessian_terms"]

    print("C4_GROUPED_TERMS", len(c4_terms))
    print("C4_EXPANDED_TERMS", expanded_term_count(c4_terms))
    print("C4_SHA256", digest_terms(c4_terms))
    print("C6_GROUPED_TERMS", len(c6_terms))
    print("C6_EXPANDED_TERMS", expanded_term_count(c6_terms))
    print("C6_SHA256", digest_terms(c6_terms))
    print("JACOBIAN y^2=x^3-27*c4*x-54*c6")
    print(MARKER)


if __name__ == "__main__":
    main()
