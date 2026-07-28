#!/usr/bin/env python3
"""Exact toric-valuation audit for the universal even quartic.

This is a route-closure certificate, not an obstruction and not a
resolution of Problem F.  Over algebraically closed constants it verifies:

* the syzygy-adapted normal form of the universal tensor;
* square leading values in every open cone of the noncentral Newton fan;
* square leading values on nine of its twelve walls;
* explicit square reductions on the F- and D-coordinate divisors;
* an explicit square leading value on the remaining noncoordinate wall;
* exact descent of the C-coordinate special fiber to C(t).

The only toric direction not simplified by this audit is the central
grading weight (2,3,7).  Its residue equation is the original degree-zero
universal equation, so treating it as a new valuation obstruction would be
circular.
"""

from __future__ import annotations

from math import gcd

import sympy as sp

import even_quartic_tensor as tensor


Q = tensor.load_tensor()
F, D, C = tensor.F, tensor.D, tensor.C
u, v, w = tensor.u, tensor.v, tensor.w


def diagonal(coordinate: sp.Symbol) -> sp.Poly:
    return sp.Poly(
        sp.Poly(Q, u, v, w).coeff_monomial(coordinate**4),
        F,
        D,
        C,
    )


DIAGONALS = (diagonal(u), diagonal(v), diagonal(w))


def convex_hull(points: list[tuple[int, int]]) -> list[tuple[int, int]]:
    """Strict counterclockwise hull, with collinear interior points removed."""
    points = sorted(set(points))

    def cross(
        origin: tuple[int, int],
        left: tuple[int, int],
        right: tuple[int, int],
    ) -> int:
        return (
            (left[0] - origin[0]) * (right[1] - origin[1])
            - (left[1] - origin[1]) * (right[0] - origin[0])
        )

    lower: list[tuple[int, int]] = []
    for point in points:
        while len(lower) >= 2 and cross(lower[-2], lower[-1], point) <= 0:
            lower.pop()
        lower.append(point)

    upper: list[tuple[int, int]] = []
    for point in reversed(points):
        while len(upper) >= 2 and cross(upper[-2], upper[-1], point) <= 0:
            upper.pop()
        upper.append(point)
    return lower[:-1] + upper[:-1]


EXPECTED_HULLS = (
    [(8, 0, 0), (2, 4, 0), (0, 3, 1), (1, 0, 2)],
    [(16, 0, 0), (1, 10, 0), (0, 6, 2), (2, 0, 4)],
    [
        (11, 0, 2),
        (15, 2, 0),
        (0, 12, 0),
        (0, 5, 3),
        (1, 2, 4),
        (4, 0, 4),
    ],
)


def verify_newton_fan() -> None:
    hulls: list[list[tuple[int, int, int]]] = []
    rays: set[tuple[int, int]] = set()

    for polynomial, expected in zip(DIAGONALS, EXPECTED_HULLS):
        exponent_by_projection = {
            (exponent[1], exponent[2]): exponent
            for exponent, _ in polynomial.terms()
        }
        projected_hull = convex_hull(list(exponent_by_projection))
        hull = [exponent_by_projection[point] for point in projected_hull]
        assert hull == expected
        hulls.append(hull)

        for left, right in zip(
            projected_hull,
            projected_hull[1:] + projected_hull[:1],
        ):
            delta_d = right[0] - left[0]
            delta_c = right[1] - left[1]
            ray = (delta_c, -delta_d)
            divisor = gcd(abs(ray[0]), abs(ray[1]))
            ray = (ray[0] // divisor, ray[1] // divisor)
            rays.add(ray)
            rays.add((-ray[0], -ray[1]))

    ordered_rays = [
        (-1, -1),
        (-1, -2),
        (-3, -7),
        (-1, -3),
        (0, -1),
        (1, 0),
        (1, 1),
        (1, 2),
        (3, 7),
        (1, 3),
        (0, 1),
        (-1, 0),
    ]
    assert rays == set(ordered_rays)

    def initial_exponents(
        polynomial: sp.Poly,
        direction: tuple[int, int],
    ) -> list[tuple[int, int, int]]:
        values = [
            direction[0] * exponent[1] + direction[1] * exponent[2]
            for exponent, _ in polynomial.terms()
        ]
        minimum = min(values)
        return [
            exponent
            for (exponent, _), value in zip(polynomial.terms(), values)
            if value == minimum
        ]

    # Adding a multiple of the grading vector (4,6,14) does not change
    # these minima.  In the quotient, every open cone is represented by
    # the sum of its two adjacent primitive rays.
    for index, left in enumerate(ordered_rays):
        right = ordered_rays[(index + 1) % len(ordered_rays)]
        sample = (left[0] + right[0], left[1] + right[1])
        initials = [
            initial_exponents(polynomial, sample)
            for polynomial in DIAGONALS
        ]
        assert any(
            len(exponents) == 1
            and all(power % 2 == 0 for power in exponents[0])
            for exponents in initials
        )

    exceptional_walls = set()
    for ray in ordered_rays:
        initials = [
            initial_exponents(polynomial, ray)
            for polynomial in DIAGONALS
        ]
        if not any(
            len(exponents) == 1
            and all(power % 2 == 0 for power in exponents[0])
            for exponents in initials
        ):
            exceptional_walls.add(ray)
    assert exceptional_walls == {(-1, -3), (1, 0), (0, 1)}
    print("EXACT valuation fan: 12/12 open cones have a square diagonal lead")
    print("EXACT valuation fan: 9/12 walls have a square diagonal lead")


def verify_syzygy_normal_form() -> sp.Expr:
    a, b, c = sp.symbols("a b c")
    delta = (
        C**3
        + 88 * C**2 * D * F**2
        + 1008 * C * D**4 * F
        + 1088 * C * D**2 * F**4
        - 256 * C * F**7
        - 1728 * D**7
        + 60032 * D**5 * F**3
        - 22016 * D**3 * F**6
        + 2048 * D * F**9
    )
    transformed = sp.Poly(
        sp.expand(Q.subs({
            u: a + C * c,
            v: b - sp.Rational(3, 7) * D * c,
            w: sp.Rational(2, 7) * F * c,
        })),
        c,
    )
    assert transformed.degree() == 4
    assert transformed.coeff_monomial(c**3) == 0
    assert sp.factor(transformed.coeff_monomial(c**4)) == F * delta**2
    for power in (1, 2):
        quotient = sp.cancel(transformed.coeff_monomial(c**power) / delta)
        assert quotient.as_numer_denom()[1] == 1
    print("EXACT valuation normal form: c^3=0 and c^4=F*Delta^2")
    return delta


def verify_exceptional_reductions(delta: sp.Expr) -> None:
    q_v4 = DIAGONALS[1].as_expr()
    assert sp.expand(
        q_v4.subs(F, 0) + (2352 * C * D**3) ** 2
    ) == 0
    print("EXACT F-divisor: Q(0,1,0)=-(2352*C*D^3)^2 mod F")

    d_point = sp.factor(Q.subs({
        D: 0,
        u: 48 * F**3 * C,
        v: F * C,
        w: 0,
    }))
    expected_d_point = -(
        196 * C**2 * F**3 * (C**2 - 256 * F**7)
    ) ** 2
    assert sp.expand(d_point - expected_d_point) == 0
    print("EXACT D-divisor: ratio-48 residue is a nonzero square over C")

    # The third exceptional wall has quotient direction (-1,-3).
    # Take the representative valuation val(F,D,C)=(0,-1,-3), put
    # t=C/D^3, and choose val(u,v,w)=(0,1,0).  The leading residue is
    #
    # -5488*w0^3*t^3*(100*F*w0*t + 7*v0*t^2 + 532*w0).
    #
    # With w0=1 and the displayed v0, this is -5488*t^4, a nonzero
    # square over algebraically closed constants.
    t, u0, v0, w0 = sp.symbols("t u0 v0 w0")
    variable_values = (0, 1, 0)
    leading_exponent = None
    leading_residue = sp.S.Zero
    for uvw_exponent, coefficient in sp.Poly(Q, u, v, w).terms():
        for (f_power, d_power, c_power), scalar in sp.Poly(
            coefficient, F, D, C
        ).terms():
            exponent = (
                d_power
                + 3 * c_power
                - sum(
                    power * value
                    for power, value in zip(uvw_exponent, variable_values)
                )
            )
            residue_term = (
                scalar
                * F**f_power
                * t**c_power
                * u0**uvw_exponent[0]
                * v0**uvw_exponent[1]
                * w0**uvw_exponent[2]
            )
            if leading_exponent is None or exponent > leading_exponent:
                leading_exponent = exponent
                leading_residue = residue_term
            elif exponent == leading_exponent:
                leading_residue += residue_term

    assert leading_exponent == 14
    expected_leading = -5488 * w0**3 * t**3 * (
        100 * F * w0 * t + 7 * v0 * t**2 + 532 * w0
    )
    assert sp.expand(leading_residue - expected_leading) == 0
    chosen_v0 = (t - 100 * F * t - 532) / (7 * t**2)
    assert sp.cancel(
        leading_residue.subs({u0: 1, v0: chosen_v0, w0: 1})
        + 5488 * t**4
    ) == 0
    print("EXACT wall (-1,-3): tunable leading residue is -5488*t^4")

    # On C=0 the tensor descends, after a rational change of variables,
    # from C(F,D) to C(t), t=D^2/F^3:
    #
    # Q(F*D*U, (D/F)*V, W)|_{C=0} = F^18 P_t(U,V,W).
    #
    # This identity is the exact algebraic input for the GHS argument in
    # the proof note; the script does not pretend that GHS gives formulas.
    U, V, W = sp.symbols("U V W")
    cleared = sp.Poly(
        sp.expand(
            Q.subs({
                C: 0,
                u: F * D * U,
                v: D * V / F,
                w: W,
            })
            * F**4
        ),
        F,
        D,
    )
    descended = sp.S.Zero
    for (f_power, d_power), coefficient in cleared.terms():
        assert d_power % 2 == 0
        half_d = d_power // 2
        assert f_power + 3 * half_d == 22
        descended += coefficient * t**half_d
    descended = sp.expand(descended)
    assert len(sp.Poly(descended, U, V, W).terms()) == 15
    original_c_fiber = Q.subs({
        C: 0,
        u: F * D * U,
        v: D * V / F,
        w: W,
    })
    assert sp.cancel(
        original_c_fiber
        - F**18 * descended.subs(t, D**2 / F**3)
    ) == 0
    assert delta.subs(C, 0) != 0

    # Check the smoothness input without relying on a name-table
    # convention.  The three even covariants form a change-of-coordinate
    # matrix of determinant 196*X^2, and X^2 is exactly Delta.
    import wp3_covariant_exclusions as base

    jacobian = sp.Matrix([
        [sp.diff(invariant, variable) for variable in base.XYZ]
        for invariant in (base.F, base.D, base.C)
    ]).det()
    assert sp.rem(jacobian, 14) == 0
    X = sp.expand(jacobian / 14)
    delta_xyz = sp.expand(delta.subs({F: base.F, D: base.D, C: base.C}))
    assert sp.expand(X**2 - delta_xyz) == 0
    change_of_coordinates = sp.Matrix.hstack(base.psi, base.phi, base.f18)
    assert sp.expand(change_of_coordinates.det() - 196 * X**2) == 0
    print(
        "EXACT C-divisor: smooth special fiber descends to C(t), "
        "t=D^2/F^3"
    )


def verify_central_grading_ray() -> None:
    # For val(F,D,C)=(2,3,7), every coefficient is entirely initial.
    # Its valuation is determined by the natural generator shifts
    # val(u,v,w)=(4,8,9).  Thus no Newton face is discarded: the residue
    # equation is the full universal quartic over the degree-zero field.
    for uvw_exponent, coefficient in sp.Poly(Q, u, v, w).terms():
        expected = (
            4 * uvw_exponent[0]
            + 8 * uvw_exponent[1]
            + 9 * uvw_exponent[2]
        )
        values = {
            2 * exponent[0] + 3 * exponent[1] + 7 * exponent[2]
            for exponent, _ in sp.Poly(coefficient, F, D, C).terms()
        }
        assert values == {expected}
    print("EXACT central ray: full degree-zero universal equation remains")


def main() -> None:
    delta = verify_syzygy_normal_form()
    verify_newton_fan()
    verify_exceptional_reductions(delta)
    verify_central_grading_ray()
    print("EVEN_QUARTIC_VALUATION_ROUTE_AUDIT_OK")


if __name__ == "__main__":
    main()
