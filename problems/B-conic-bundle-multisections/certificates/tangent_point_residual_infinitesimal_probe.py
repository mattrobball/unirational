#!/usr/bin/env python3
"""Probe residual-map infinitesimal rigidity in tangent-point normal form.

The base cubic is

    aa U^3 + bb U^2 V + cc U^2 W + dd U V W + V^2 W
      + ff U W^2 + gg V W^2 + hh W^3.

It is what remains after sending an arbitrary smooth point to ``[0:1:0]``, its tangent to
``W=0``, and scaling the ``V^2 W`` coefficient to one.  The script forms the exact linear map from
a projectively normalized tangent cubic to the coefficients of the three residual-map cross
products.  It reports numerical ranks and, with ``--minor``, factors one sparse symbolic minor.
"""

from __future__ import annotations

import argparse

import sympy as sp

from residual_line_pencil_probe import affine_residual_map


def cross_product_coefficients(
    left: dict[tuple[int, int], sp.Expr],
    dleft: dict[tuple[int, int], sp.Expr],
    right: dict[tuple[int, int], sp.Expr],
    dright: dict[tuple[int, int], sp.Expr],
) -> dict[tuple[int, int], sp.Expr]:
    """Coefficient dictionary of ``left*dright - right*dleft``."""

    result: dict[tuple[int, int], sp.Expr] = {}
    for first, first_coefficient in left.items():
        for second, second_coefficient in dright.items():
            monomial = (first[0] + second[0], first[1] + second[1])
            result[monomial] = result.get(monomial, 0) + first_coefficient * second_coefficient
    for first, first_coefficient in right.items():
        for second, second_coefficient in dleft.items():
            monomial = (first[0] + second[0], first[1] + second[1])
            result[monomial] = result.get(monomial, 0) - first_coefficient * second_coefficient
    return {monomial: sp.expand(value) for monomial, value in result.items() if value != 0}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--minor", action="store_true", help="factor one symbolic 9 by 9 minor")
    parser.add_argument("--show-minor", action="store_true", help="print the selected sparse minor")
    parser.add_argument(
        "--nonflex-normal",
        action="store_true",
        help="use U^2 V + V^2 W + P U W^2 + Q V W^2 + R W^3",
    )
    parser.add_argument(
        "--cover-minors",
        action="store_true",
        help="select minors on generic and exceptional nonflex parameter charts",
    )
    args = parser.parse_args()

    coefficients, (s, t), residual = affine_residual_map()
    a, b, c, d, e, f, h, i, j, k = coefficients
    aa, bb, cc, dd, ff, gg, hh = sp.symbols("aa bb cc dd ff gg hh")
    P, Q, RR = sp.symbols("P Q RR")
    if args.nonflex_normal:
        base = {a: 0, b: 1, c: 0, d: 0, e: 0, f: 0, h: 1, i: P, j: Q, k: RR}
        parameter_symbols = (P, Q, RR)
    else:
        base = {a: aa, b: bb, c: 0, d: 0, e: cc, f: dd, h: 1, i: ff, j: gg, k: hh}
        parameter_symbols = (aa, bb, cc, dd, ff, gg, hh)
    universal_coefficients = tuple(sp.Poly(q, s, t).as_dict() for q in residual)
    base_residual = tuple(
        {monomial: sp.expand(value.subs(base, simultaneous=True))
         for monomial, value in component.items()}
        for component in universal_coefficients
    )

    # Remove the scalar tangent direction using the coefficient of V^2 W as pivot.  If ``dh`` is
    # the original variation of that coefficient, the normalized variables below are
    # ``dq - dh*q``.  Scalar variation has zero residual cross-product, so setting ``dh=0`` loses
    # no projective tangent information.
    xa, xb, xc, xd, xe, xf, xi, xj, xk = sp.symbols("xa xb xc xd xe xf xi xj xk")
    tangent_variables = (xa, xb, xc, xd, xe, xf, xi, xj, xk)
    directions = {a: xa, b: xb, c: xc, d: xd, e: xe, f: xf, h: 0,
                  i: xi, j: xj, k: xk}
    slopes = tuple(
        {
            monomial: sp.expand(
                sum(sp.diff(value, variable).subs(base, simultaneous=True) * direction
                    for variable, direction in directions.items())
            )
            for monomial, value in component.items()
        }
        for component in universal_coefficients
    )
    ru, rv, rw = base_residual
    du, dv, dw = slopes
    cross_products = (
        cross_product_coefficients(ru, du, rv, dv),
        cross_product_coefficients(ru, du, rw, dw),
        cross_product_coefficients(rv, dv, rw, dw),
    )
    labelled_rows = [
        ((component, monomial[0], monomial[1]), expression)
        for component, cross_product in enumerate(cross_products)
        for monomial, expression in sorted(cross_product.items(), reverse=True)
    ]
    matrix = sp.Matrix(
        [[sp.diff(expression, variable) for variable in tangent_variables]
         for _, expression in labelled_rows]
    )
    assert all(
        sp.expand(expression - sum(row[index] * tangent_variables[index]
                                   for index in range(len(tangent_variables)))) == 0
        for (_, expression), row in zip(labelled_rows, matrix.tolist())
    )
    print(f"cross coefficient matrix: {matrix.rows} x {matrix.cols}")

    if args.nonflex_normal:
        sample_points = ({P: 1, Q: 2, RR: 3}, {P: 2, Q: 3, RR: 5}, {P: -1, Q: 4, RR: -2})
        u = sp.symbols("u")
        quartic = u**4 + 2 * Q * u**2 - 4 * P * u + Q**2 - 4 * RR
        print("quartic discriminant:", sp.factor(sp.discriminant(quartic, u)))
    else:
        sample_points = (
            # Short Weierstrass point A=B=1.
            {aa: -1, bb: 0, cc: 0, dd: 0, ff: -1, gg: 0, hh: -1},
            {aa: 2, bb: 3, cc: 5, dd: 7, ff: 11, gg: 13, hh: 17},
            {aa: 1, bb: -2, cc: 3, dd: -5, ff: 7, gg: -11, hh: 13},
        )
    for number, point in enumerate(sample_points):
        rank = matrix.subs(point).rank()
        print(f"sample {number} rank: {rank}")
        assert rank == 9

    # Select nine *simple* rows which are independent at a generic integral sample.  Sorting by
    # expression complexity before greedy rank growth gives much smaller symbolic minors than the
    # lexicographically first pivots of the transpose.
    row_complexity = [sum(sp.count_ops(entry) for entry in row) for row in matrix.tolist()]
    selection_points = [("generic", sample_points[1])]
    if args.nonflex_normal and args.cover_minors:
        selection_points.extend(
            (
                ("P_zero", {P: 0, Q: 0, RR: 1}),
                ("first_minor_second_factor_zero", {P: 1, Q: sp.Rational(-4, 3), RR: 1}),
            )
        )

    for selection_name, selection_point in selection_points:
        numeric_matrix = matrix.subs(selection_point)
        selected_rows: list[int] = []
        selected_rank = 0
        for candidate in sorted(range(matrix.rows), key=lambda index: row_complexity[index]):
            candidate_rank = numeric_matrix[selected_rows + [candidate], :].rank()
            if candidate_rank > selected_rank:
                selected_rows.append(candidate)
                selected_rank = candidate_rank
            if selected_rank == 9:
                break
        assert len(selected_rows) == 9
        labels = [labelled_rows[index][0] for index in selected_rows]
        print(f"{selection_name} simple independent row labels:")
        print(labels)
        print("row complexities:", [row_complexity[index] for index in selected_rows])

        selected_matrix = matrix[selected_rows, :]
        if args.show_minor:
            print("selected matrix; columns are xa,xb,xc,xd,xe,xf,xi,xj,xk:")
            for label, row in zip(labels, selected_matrix.tolist()):
                print(label, [sp.factor(entry) for entry in row])

        if args.minor:
            determinant = selected_matrix.det(method="berkowitz")
            determinant = sp.Poly(determinant, *parameter_symbols).factor_list()
            print(f"{selection_name} factored pivot minor:")
            print(determinant)


if __name__ == "__main__":
    main()
