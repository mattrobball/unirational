#!/usr/bin/env python3
"""Exact Klein-arrangement basepoint and local-line audit.

This certifies the finite group/line data used to show that the mandatory
basepoint multiplicities recover d >= 24 but leave positive Noether/Hodge
slack in every higher even degree.  It is a route audit, not an
all-degree obstruction.
"""

from __future__ import annotations

import wp1_fixed_loci as base


def involution_line_intersection(first: int, second: int):
    rows = []
    for element in (first, second):
        rows.extend([
            [
                base.kadd(
                    base.MATRICES[element][row][column],
                    base.K1 if row == column else base.K0,
                )
                for column in range(3)
            ]
            for row in range(3)
        ])
    nullspace = base.nullspace(rows, base.KOPS)
    return nullspace[0] if len(nullspace) == 1 else None


def incident_involutions(point) -> list[int]:
    answer = []
    for element, order in enumerate(base.ORDERS):
        if order != 2:
            continue
        image = base.matvec(base.MATRICES[element], point)
        if all(
            base.kadd(image[index], point[index]) == base.K0
            for index in range(3)
        ):
            answer.append(element)
    return answer


def projective_stabilizer(point) -> list[int]:
    return [
        element
        for element, matrix in enumerate(base.MATRICES)
        if base.proportional(base.matvec(matrix, point), point)
    ]


def plus_eigenline(involution: int):
    eigenspace = base.eigenspace_base(base.MATRICES[involution], base.K1)
    assert len(eigenspace) == 1
    return eigenspace[0]


def polynomial_proportional(left, right) -> bool:
    if len(left) != len(right):
        return False
    pivot = next(
        (index for index, value in enumerate(left) if value != base.K0),
        None,
    )
    if pivot is None:
        return all(value == base.K0 for value in right)
    return all(
        base.kmul(left[index], right[pivot])
        == base.kmul(right[index], left[pivot])
        for index in range(len(left))
    )


def verify_arrangement() -> None:
    involutions = [
        element
        for element, order in enumerate(base.ORDERS)
        if order == 2
    ]
    assert len(involutions) == 21

    points = []
    for index, first in enumerate(involutions):
        for second in involutions[index + 1:]:
            point = involution_line_intersection(first, second)
            if point is None:
                continue
            if not any(base.proportional(point, old) for old in points):
                points.append(point)
    assert len(points) == 49

    census: dict[tuple[int, int], int] = {}
    for point in points:
        incident = incident_involutions(point)
        stabilizer = projective_stabilizer(point)
        kind = (len(incident), len(stabilizer))
        census[kind] = census.get(kind, 0) + 1

        targets = [plus_eigenline(element) for element in incident]
        assert all(
            not base.proportional(left, right)
            for index, left in enumerate(targets)
            for right in targets[index + 1:]
        )
        assert not base.proportional(targets[0], targets[1])
        assert all(
            base.det3((targets[0], targets[1], target)) == base.K0
            for target in targets[2:]
        )

        restriction = base.binary_line_restriction(targets[0], targets[1])
        derivative = [
            base.kscale(restriction[index], base.Q(index))
            for index in range(1, 5)
        ]
        common = base.unipoly_gcd(restriction, derivative)

        if kind == (3, 6):
            # The target line is a bitangent: the binary quartic is a
            # nonzero scalar times the square of a separable quadratic.
            assert len(common) == 3
            quotient, remainder = base.unipoly_divmod(restriction, common)
            assert not remainder
            assert polynomial_proportional(common, quotient)
            assert sorted(base.ORDERS[element] for element in stabilizer) == [
                1, 2, 2, 2, 3, 3
            ]
        elif kind == (4, 8):
            # The target line meets the Klein quartic in four distinct
            # points, so it cannot support a degree-one landing.
            assert len(common) == 1
            assert sorted(base.ORDERS[element] for element in stabilizer) == [
                1, 2, 2, 2, 2, 2, 4, 4
            ]
            central_involutions = [
                element
                for element in stabilizer
                if base.ORDERS[element] == 2
                and all(
                    base.MULT[element][other]
                    == base.MULT[other][element]
                    for other in stabilizer
                )
            ]
            assert len(central_involutions) == 1
            central = central_involutions[0]
            assert base.matvec(base.MATRICES[central], point) == point
            assert central not in incident
        else:
            raise AssertionError(kind)

    assert census == {(3, 6): 28, (4, 8): 21}
    print("EXACT arrangement: 21 quadruple and 28 triple points")
    print("EXACT target lines: triple=bitangent, quadruple=squarefree")


def verify_numerical_slack() -> None:
    # Local stabilizer analysis in the proof note gives the mandatory
    # cluster:
    #   21 quadruple proper points of multiplicity 4,
    #   84 first-near incident directions of multiplicity 1,
    #   28 triple proper points of multiplicity 1.
    mandatory_line_sum = 4 * (4 + 1) + 4
    mandatory_square_sum = 21 * 4**2 + 84 + 28
    assert mandatory_line_sum == 24
    assert mandatory_square_sum == 448
    assert 24**2 - mandatory_square_sum == 128

    # Every even d >= 24 has the form 24+4q+2e, e in {0,1}.
    # A generic orbit on the line union has size 84 and contributes four
    # simple points to each line.  The order-four eigenline orbit has size
    # 42 and contributes two.  The resulting self-intersections are
    #
    # e=0: 16q^2+108q+128,
    # e=1: 16q^2+124q+186,
    #
    # both positive and even for q >= 0.
    for epsilon, expected_coefficients in (
        (0, (128, 108, 16)),
        (1, (186, 124, 16)),
    ):
        constant_degree = 24 + 2 * epsilon
        # Coefficients, low to high, of
        # (constant_degree+4q)^2-(448+42e+84q).
        coefficients = (
            constant_degree**2 - mandatory_square_sum - 42 * epsilon,
            8 * constant_degree - 84,
            16,
        )
        assert coefficients == expected_coefficients
        assert all(coefficient > 0 and coefficient % 2 == 0
                   for coefficient in coefficients)
    print("EXACT basepoint bound: d>=24")
    print("EXACT Noether/Hodge audit: positive even slack for all d>=24")


def main() -> None:
    verify_arrangement()
    verify_numerical_slack()
    print("KLEIN_ARRANGEMENT_BASEPOINT_AUDIT_OK")


if __name__ == "__main__":
    main()
