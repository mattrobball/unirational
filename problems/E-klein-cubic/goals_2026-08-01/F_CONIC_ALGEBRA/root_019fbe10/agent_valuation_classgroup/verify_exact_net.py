#!/usr/bin/env python3
"""Adversarial exact verifier for the infinity-valuation/net argument.

This script is intentionally independent of the shared producer.  In
particular, it computes the base ideal over the characteristic-zero field

    Q(zeta_11)(r)

instead of inferring it only from a finite-field fibre.  SymPy's algebraic
number field and rational-function domains are used for the Groebner check.
"""

from __future__ import annotations

from fractions import Fraction
from hashlib import sha256
import json
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
FROOT = HERE.parents[1]
PROBLEM = FROOT.parents[1]
FORMS = PROBLEM / "certificates/fixed_frame_arithmetic/five_forms.json"
CERT = FROOT / "infinity_obstruction.json"
PRIMITIVE = FROOT / "payload/global_primitive_u_sextic_exact.tsv"

EXPECTED_FORMS = "61377d6e464f7c78cf1fa91d13610b76dc4567de7b7214256e04de50066c83a4"
EXPECTED_PRIMITIVE = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def main() -> None:
    require(digest(FORMS) == EXPECTED_FORMS, "five-form input hash")
    require(digest(PRIMITIVE) == EXPECTED_PRIMITIVE, "primitive-sextic input hash")

    payload = json.loads(CERT.read_text())
    raw = json.loads(FORMS.read_text())["binary_slots"]

    z = sp.symbols("z")
    phi11 = sp.Poly(sum(z**i for i in range(11)), z, domain=sp.QQ)
    constant_field = sp.QQ.alg_field_from_poly(phi11)
    zeta = constant_field.ext

    r, X, y, w = sp.symbols("r X y w")
    coefficient_field = constant_field.frac_field(r)

    def cyc(entry: list[list[int]]) -> sp.Expr:
        return sp.Add(
            *(sp.Rational(int(a), int(b)) * zeta**i for i, (a, b) in enumerate(entry))
        )

    def row(name: str) -> list[sp.Expr]:
        return [cyc(entry) for entry in raw[name]]

    def qform(values: list[sp.Expr]) -> sp.Expr:
        return values[0] * y**2 + values[1] * y * w + values[2] * w**2

    def rform(values: list[sp.Expr]) -> sp.Expr:
        return (
            values[0] * y**3
            + values[1] * y**2 * w
            + values[2] * y * w**2
            + values[3] * w**3
        )

    F0 = X**3 + X * qform(row("q0")) + rform(row("r0"))
    FA = X * qform(row("qA")) + rform(row("rA"))
    FB = rform(row("rB"))
    FY = X * qform(row("qY")) + rform(row("rY"))
    FZ = rform(row("rZ"))

    C0 = (
        F0
        + (sp.Rational(33, 2) - 3750 * r**2) * FA
        - 5625 * r**2 * FB
        + (33125 * r**2 - sp.Rational(9, 4)) * FY
    )
    Crho = (r / 4 - sp.Rational(1, 200)) * FB + FY / 600
    CT = -FB / 2 + FZ

    c = cyc(payload["net"]["c_qzeta11"])
    base_coefficients = {
        name: cyc(value)
        for name, value in payload["net"]["base_cubic_coefficients"].items()
    }
    a0 = base_coefficients["a0"]
    a2 = base_coefficients["a2"]
    b0 = base_coefficients["b0"]
    b2 = base_coefficients["b2"]
    line = y - c * w
    G = X**3 + (a0 + a2 * r**2) * X * w**2 + (b0 + b2 * r**2) * w**3

    # First check the claimed exact closed subscheme without Groebner bases.
    substitutions = {y: c * w}
    require(
        sp.Poly(sp.expand(C0.subs(substitutions) - G), X, w, domain=coefficient_field).is_zero,
        "C0 restricts to G on the line",
    )
    require(
        sp.Poly(sp.expand(Crho.subs(substitutions)), X, w, domain=coefficient_field).is_zero,
        "Crho vanishes on the claimed base scheme",
    )
    require(
        sp.Poly(sp.expand(CT.subs(substitutions)), X, w, domain=coefficient_field).is_zero,
        "CT vanishes on the claimed base scheme",
    )

    # Exact characteristic-zero equality of the affine base ideal over
    # Q(zeta_11)(r).  This supersedes the modular-lift step in the shared text.
    net_affine = [sp.expand(value.subs(w, 1)) for value in (C0, Crho, CT)]
    expected_affine = [sp.expand(line.subs(w, 1)), sp.expand(G.subs(w, 1))]
    gb_net = sp.groebner(net_affine, X, y, order="lex", domain=coefficient_field)
    gb_expected = sp.groebner(expected_affine, X, y, order="lex", domain=coefficient_field)
    for index, value in enumerate(expected_affine):
        require(gb_net.reduce(value)[1] == 0, f"expected generator {index} belongs to net ideal")
    for index, value in enumerate(net_affine):
        require(gb_expected.reduce(value)[1] == 0, f"net generator {index} belongs to expected ideal")

    # The two projective charts on w=0 are empty, again in characteristic zero.
    infinity_X = [sp.expand(value.subs({w: 0, X: 1})) for value in (C0, Crho, CT)]
    infinity_y = [sp.expand(value.subs({w: 0, y: 1})) for value in (C0, Crho, CT)]
    require(
        list(sp.groebner(infinity_X, y, order="lex", domain=coefficient_field)) == [1],
        "no base point on w=0, X=1",
    )
    require(
        list(sp.groebner(infinity_y, X, order="lex", domain=coefficient_field)) == [1],
        "no base point on w=0, y=1",
    )

    # G is a separable cubic over Q(zeta_11)(r).  The stronger absolute
    # irreducibility check is the odd-pole argument audited in AUDIT.md.
    G_affine = sp.Poly(sp.expand(G.subs(w, 1)), X, domain=coefficient_field)
    require(G_affine.degree() == 3 and G_affine.LC() == 1, "monic cubic base point")
    require(sp.gcd(G_affine, G_affine.diff()).degree() == 0, "separable cubic base point")

    # At a reduced base point, equality of ideals implies that the three net
    # sections generate I_B/I_B^2.  Since (line,G) is a regular sequence, this
    # is exactly the conormal-rank-two hypothesis in the normality proof.
    require(gb_net.reduce(expected_affine[0])[1] == 0, "line is generated by net sections")
    require(gb_net.reduce(expected_affine[1])[1] == 0, "cubic is generated by net sections")

    print("EXACT_CHAR0_BASE_IDEAL_EQUALITY_ACCEPT")
    print("EXACT_PROJECTIVE_BASE_SCHEME_LENGTH3_ACCEPT")
    print("EXACT_CONORMAL_RANK2_INPUT_ACCEPT")


if __name__ == "__main__":
    main()
