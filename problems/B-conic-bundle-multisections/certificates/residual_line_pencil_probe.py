#!/usr/bin/env python3
"""Exact probes for the finite Hesse-certificate route to the pencil lemma.

This is deliberately not a proof of ``Standard.exists_pencil_of_hasCommonResidualLineMap``.
It checks the coordinate identities on which such a proof can be based and records the rank of
the resulting fixed-line equations.  In particular, the rank computation is only a local
certificate; it must not be quoted as a global saturation or Hesse-normal-form theorem.
"""

from __future__ import annotations

import sympy as sp

from tangent_residual_local_checks import universal_covariant


def affine_residual_map():
    """Return the residual map on the affine dual chart ``z = s*x + t*y``."""

    coefficients, residual, _, _ = universal_covariant()
    a, b, c, d, e, f, h, i, j, k = coefficients
    s, t = sp.symbols("s t")
    x, y, z = sp.symbols("x y z")

    cubic = (
        a * x**3
        + b * x**2 * y
        + c * x * y**2
        + d * y**3
        + e * x**2 * z
        + f * x * y * z
        + h * y**2 * z
        + i * x * z**2
        + j * y * z**2
        + k * z**3
    )
    transported = sp.Poly(sp.expand(cubic.subs(z, s * x + t * y + z)), x, y, z)
    monomials = (
        x**3,
        x**2 * y,
        x * y**2,
        y**3,
        x**2 * z,
        x * y * z,
        y**2 * z,
        x * z**2,
        y * z**2,
        z**3,
    )
    transported_coefficients = [transported.coeff_monomial(m) for m in monomials]

    # ``simultaneous=True`` is essential: the transported coefficients themselves contain the
    # old coefficient symbols.  Sequential substitution gives a spurious degree-seven formula.
    normalized = [
        sp.expand(q.subs(dict(zip(coefficients, transported_coefficients)), simultaneous=True))
        for q in residual
    ]
    ambient = (
        sp.expand(normalized[0] - s * normalized[2]),
        sp.expand(normalized[1] - t * normalized[2]),
        sp.expand(normalized[2]),
    )
    return coefficients, (s, t), ambient


def rank_mod_prime(matrix: list[list[int]], prime: int) -> int:
    rows = [[entry % prime for entry in row] for row in matrix]
    rank = 0
    for column in range(len(rows[0])):
        pivot = next(
            (row for row in range(rank, len(rows)) if rows[row][column] % prime), None
        )
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        inverse = pow(rows[rank][column], -1, prime)
        rows[rank] = [(entry * inverse) % prime for entry in rows[rank]]
        for row in range(len(rows)):
            if row == rank:
                continue
            multiple = rows[row][column] % prime
            if multiple:
                rows[row] = [
                    (rows[row][index] - multiple * rows[rank][index]) % prime
                    for index in range(len(rows[row]))
                ]
        rank += 1
    return rank


def main() -> None:
    coefficients, (s, t), residual = affine_residual_map()
    assert [sp.Poly(q, s, t).total_degree() for q in residual] == [4, 4, 4]
    assert [len(sp.Poly(q, s, t).terms()) for q in residual] == [15, 15, 15]
    print("affine residual map: three quartics with 15 terms each: PASS")

    a, b, c, d, e, f, h, i, j, k = coefficients
    lam = sp.symbols("lam")
    hesse = {a: 1, b: 0, c: 0, d: 1, e: 0, f: -3 * lam, h: 0, i: 0, j: 0, k: 1}
    specialized = [sp.expand(q.subs(hesse, simultaneous=True)) for q in residual]
    common = 27 * (lam**3 - 1)
    expected = (
        common * (s**4 - 2 * s * t**3 + 2 * s + 3 * lam * t**2),
        common * (t**4 - 2 * s**3 * t + 2 * t + 3 * lam * s**2),
        common * (1 + 2 * s**3 + 2 * t**3 + 3 * lam * s**2 * t**2),
    )
    assert all(sp.expand(left - right) == 0 for left, right in zip(specialized, expected))
    print("Hesse residual-map quartic formula: PASS")

    omega = sp.symbols("omega")
    cyclotomic = sp.Poly(omega**2 + omega + 1, omega)

    def reduce_omega(expression):
        return sp.rem(sp.Poly(sp.expand(expression), omega), cyclotomic).as_expr()

    # The nine affine Hesse-configuration lines are
    # ``x + omega^u*y + omega^v*z = 0``.  On our chart this is
    # ``z = -omega^(-v)*x - omega^(u-v)*y``.
    for u in range(3):
        for v in range(3):
            sv = -omega ** ((-v) % 3)
            tv = -omega ** ((u - v) % 3)
            values = [q.subs({s: sv, t: tv}) for q in specialized]
            assert reduce_omega(values[0] + sv * values[2]) == 0
            assert reduce_omega(values[1] + tv * values[2]) == 0
    assert specialized[0].subs({s: 0, t: 0}) == 0
    assert specialized[1].subs({s: 0, t: 0}) == 0
    print("ten fixed Hesse-configuration lines on the affine chart: PASS")

    # Local rank check over F_7, where 2 is a primitive cube root of unity.  Lambda=3 is smooth
    # because 3^3 != 1 mod 7.  The twenty fixed-line equations have rank eight in the ten cubic
    # coefficients, exactly the codimension of the Hesse pencil.
    prime = 7
    roots = (1, 2, 4)
    equations = []
    for alpha in roots:
        for beta in roots:
            sv = (-pow(beta, -1, prime)) % prime
            tv = (-alpha * pow(beta, -1, prime)) % prime
            values = [q.subs({s: sv, t: tv}) for q in residual]
            equations.extend((values[0] + sv * values[2], values[1] + tv * values[2]))
    equations.extend((residual[0].subs({s: 0, t: 0}), residual[1].subs({s: 0, t: 0})))
    point = {a: 1, b: 0, c: 0, d: 1, e: 0, f: 5, h: 0, i: 0, j: 0, k: 1}
    jacobian = [
        [int(sp.diff(equation, variable).subs(point)) % prime for variable in coefficients]
        for equation in equations
    ]
    assert rank_mod_prime(jacobian, prime) == 8
    print("fixed-line Jacobian rank over F_7: 8 (local evidence only): PASS")


if __name__ == "__main__":
    main()
