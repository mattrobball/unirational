#!/usr/bin/env python3
"""Exact symbolic replay for the representative-V4 simultaneous-normal theorem.

The verifier checks:
  * the degree-six J_3/J_5 character decomposition;
  * the complete m=1, triple-order-three coefficient equations and their
    nondegenerate factorization;
  * the nondegenerate m=3 trisection factorization;
  * the exact cubic trisection identity;
  * a primitive positive line-degree-six diagonal-precomposition family.

It uses exact SymPy algebra only.  The geometric passage from these identities
to the A4-equivariant no-family theorem is written in THEOREM.md.
"""

from itertools import product
import sympy as sp


def coefficients(expression, variables):
    polynomial = sp.Poly(sp.expand(expression), *variables)
    return {monomial: sp.factor(coefficient)
            for monomial, coefficient in polynomial.terms()}


def check_j3_character_classification():
    monomials = []
    groups = {(0, 0): [], (1, 0): [], (0, 1): [], (1, 1): []}
    for a, b, c in product(range(7), repeat=3):
        if a + b + c != 6:
            continue
        if b + c < 3 or a + c < 3 or a + b < 3:
            continue
        character = ((a + c) % 2, (b + c) % 2)
        groups[character].append((a, b, c))
        monomials.append((a, b, c))

    assert len(monomials) == 10
    assert groups[(0, 0)] == [(2, 2, 2)]
    assert set(groups[(1, 0)]) == {(0, 3, 3), (2, 1, 3), (2, 3, 1)}
    assert set(groups[(0, 1)]) == {(1, 2, 3), (3, 0, 3), (3, 2, 1)}
    assert set(groups[(1, 1)]) == {(1, 3, 2), (3, 1, 2), (3, 3, 0)}
    print("PASS J3 degree-six V4 character classification: 1+3+3+3")


def check_m1_order3_classification():
    U, V, W = sp.symbols("U V W")
    a, b, g, d, e, f = sp.symbols("a b g d e f")
    r0, r1, r2, c = sp.symbols("r0 r1 r2 c")

    L0 = a * V + b * W
    L1 = g * U + d * W
    L2 = e * U + f * V
    expression = (
        L0 * L1 * L2
        + r0 * U * L0**2
        + r1 * V * L1**2
        + r2 * W * L2**2
        + c * U * V * W
    )
    found = coefficients(expression, (U, V, W))
    expected = {
        (2, 1, 0): g * (a * e + g * r1),
        (2, 0, 1): e * (b * g + e * r2),
        (1, 2, 0): a * (a * r0 + g * f),
        (1, 0, 2): b * (b * r0 + d * e),
        (0, 2, 1): f * (a * d + f * r2),
        (0, 1, 2): d * (b * f + d * r1),
        (1, 1, 1): (
            2 * a * b * r0 + a * d * e + b * g * f + c
            + 2 * d * g * r1 + 2 * e * f * r2
        ),
    }
    assert found == {key: sp.factor(value) for key, value in expected.items()}

    # Assuming r0*r1*r2 != 0, any nonzero transverse coefficient forces all six.
    implications = {
        "a": {"g", "f"},
        "g": {"a", "e"},
        "e": {"b", "g"},
        "b": {"d", "e"},
        "d": {"b", "f"},
        "f": {"a", "d"},
    }
    all_variables = set(implications)
    for start in all_variables:
        closure = {start}
        changed = True
        while changed:
            changed = False
            for variable in list(closure):
                old_size = len(closure)
                closure |= implications[variable]
                changed |= len(closure) != old_size
        assert closure == all_variables

    # Solve the nondegenerate branch.  Its six noncentral equations vanish,
    # and the remaining coefficient is exactly c+4*r0*r1*r2.
    substitution = {
        b: r1 * r2 / a,
        e: -g * r1 / a,
        f: -a * r0 / g,
        d: r0 * r2 / g,
    }
    for monomial in ((2, 1, 0), (2, 0, 1), (1, 2, 0),
                     (1, 0, 2), (0, 2, 1), (0, 1, 2)):
        assert sp.factor(found[monomial].subs(substitution)) == 0
    assert sp.factor(found[(1, 1, 1)].subs(substitution)) == c + 4 * r0 * r1 * r2

    print("PASS m=1/order-3 simultaneous normal classification")
    print("PASS nondegenerate branch iff c+4*r0*r1*r2=0")


def check_m3_nondegenerate_factorization():
    U, V, W = sp.symbols("U V W")
    A, B, C, D, E, F = sp.symbols("A B C D E F")
    R0, R1, R2, C0 = sp.symbols("R0 R1 R2 C0")

    L0 = U + A * V + B * W
    L1 = C * U + V + D * W
    L2 = E * U + F * V + W
    expression = (
        L0 * L1 * L2
        + R0 * U * L0**2
        + R1 * V * L1**2
        + R2 * W * L2**2
        + C0 * U * V * W
    )
    found = coefficients(expression, (U, V, W))
    assert found[(3, 0, 0)] == C * E + R0
    assert found[(0, 3, 0)] == A * F + R1
    assert found[(0, 0, 3)] == B * D + R2

    cube_substitution = {R0: -C * E, R1: -A * F, R2: -B * D}
    expected_factors = {
        (2, 1, 0): -(A * C - 1) * (C * F + E),
        (1, 2, 0): -(A * C - 1) * (A * E + F),
        (2, 0, 1): -(C + D * E) * (B * E - 1),
        (1, 0, 2): -(B * C + D) * (B * E - 1),
        (0, 2, 1): -(A + B * F) * (D * F - 1),
        (0, 1, 2): -(A * D + B) * (D * F - 1),
    }
    for monomial, expected in expected_factors.items():
        assert sp.factor(found[monomial].subs(cube_substitution) - expected) == 0

    reciprocal_substitution = {C: 1 / A, E: 1 / B, F: 1 / D}
    central = sp.factor(
        found[(1, 1, 1)].subs(cube_substitution).subs(reciprocal_substitution)
    )
    expected_central = (
        A**2 * D**2 + A * B * C0 * D - 2 * A * B * D + B**2
    ) / (A * B * D)
    assert sp.factor(central - expected_central) == 0

    print("PASS m=3 nondegenerate simultaneous-normal factorization")
    print("PASS reciprocal trisection branch and quadratic parameter equation")


def check_projective_trisection_and_positive_line_family():
    x, y, z, B = sp.symbols("x y z B", nonzero=True)
    X, Y, Z = y * z, z * x, x * y
    w = -X * Y * Z
    u0 = X * (X**2 + B * Y**2 + Z**2 / B)
    u1 = Y * (Y**2 + B * Z**2 + X**2 / B)
    u2 = Z * (Z**2 + B * X**2 + Y**2 / B)
    kappa = (B**3 - 1)**2 / B**3
    landing = sp.together(
        kappa * w**3 + w * (u0**2 + u1**2 + u2**2) + u0 * u1 * u2
    )
    assert sp.factor(landing) == 0

    # Any diagonal precomposition preserves the landing identity.  Three
    # pairwise-coprime linears give a primitive line-degree-six family.
    s, t = sp.symbols("s t")
    l0, l1, l2 = s - t, s - 2 * t, s - 3 * t
    scaled = [
        sp.expand(value.subs({x: l0 * x, y: l1 * y, z: l2 * z}, simultaneous=True))
        for value in (w, u0, u1, u2)
    ]
    scaled_landing = sp.together(
        kappa * scaled[0]**3
        + scaled[0] * sum(value**2 for value in scaled[1:])
        + scaled[1] * scaled[2] * scaled[3]
    )
    assert sp.factor(scaled_landing) == 0

    # Coefficients of X^3, Y^3, Z^3 already have gcd one.
    selected_coefficients = [l1**3 * l2**3, l2**3 * l0**3, l0**3 * l1**3]
    gcd = sp.Poly(selected_coefficients[0], s, t)
    for value in selected_coefficients[1:]:
        gcd = sp.gcd(gcd, sp.Poly(value, s, t))
    assert gcd.total_degree() == 0
    assert all(sp.Poly(value, s, t).total_degree() == 6
               for value in selected_coefficients)

    print("PASS exact trisection landing identity")
    print("PASS primitive positive line-degree-six diagonal-precomposition family")


def main():
    check_j3_character_classification()
    check_m1_order3_classification()
    check_m3_nondegenerate_factorization()
    check_projective_trisection_and_positive_line_family()
    print("V4_SIMULTANEOUS_ODD_NORMALS_VERIFY_OK")


if __name__ == "__main__":
    main()
