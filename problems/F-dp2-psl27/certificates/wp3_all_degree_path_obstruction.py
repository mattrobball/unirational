#!/usr/bin/env python3
"""Exact finite inputs for the all-degree exceptional-path obstruction.

The global argument is in WP3_ALL_DEGREE_PATH_OBSTRUCTION.md.  This
checker verifies, over the exact Klein representation, every finite
group and branch-curve assertion used there.  The resolution-of-surfaces
and dual-tree lemmas are proved in the note rather than delegated to a
computer calculation.
"""

from __future__ import annotations

import klein_arrangement_basepoint_audit as arrangement
import wp1_fixed_loci as base


def polynomial_is_squarefree_on_line(first, second) -> bool:
    restriction = base.binary_line_restriction(first, second)
    derivative = [
        base.kscale(restriction[index], base.Q(index))
        for index in range(1, 5)
    ]
    return len(base.unipoly_gcd(restriction, derivative)) == 1


def commutator(first: int, second: int) -> int:
    return base.MULT[
        base.MULT[
            base.MULT[first][second]
        ][base.INVERSES[first]]
    ][base.INVERSES[second]]


def all_arrangement_points():
    involutions = [
        element
        for element, order in enumerate(base.ORDERS)
        if order == 2
    ]
    points = []
    for index, first in enumerate(involutions):
        for second in involutions[index + 1:]:
            point = arrangement.involution_line_intersection(first, second)
            if point is None:
                continue
            if not any(base.proportional(point, old) for old in points):
                points.append(point)
    assert len(points) == 49
    return points


def verify_all_involution_fixed_loci() -> None:
    involutions = [
        element
        for element, order in enumerate(base.ORDERS)
        if order == 2
    ]
    assert len(involutions) == 21

    for involution in involutions:
        matrix = base.MATRICES[involution]
        plus = base.eigenspace_base(matrix, base.K1)
        minus = base.eigenspace_base(matrix, base.kneg(base.K1))
        assert len(plus) == 1 and len(minus) == 2

        # The isolated fixed eigenline is off the branch curve, and the
        # double cover of the fixed projective line is a smooth genus-one
        # curve because the binary branch quartic is squarefree.
        assert base.qeval(plus[0]) != base.K0
        assert polynomial_is_squarefree_on_line(minus[0], minus[1])

    print("EXACT fixed loci: every involution has elliptic curve plus two points")


def verify_quadruple_flags() -> None:
    quadruple_count = 0
    flag_count = 0

    for point in all_arrangement_points():
        incident = arrangement.incident_involutions(point)
        stabilizer = arrangement.projective_stabilizer(point)
        if len(incident) != 4:
            assert len(incident) == 3 and len(stabilizer) == 6
            continue

        quadruple_count += 1
        assert len(stabilizer) == 8
        assert sorted(base.ORDERS[element] for element in stabilizer) == [
            1, 2, 2, 2, 2, 2, 4, 4
        ]

        central = [
            element
            for element in stabilizer
            if base.ORDERS[element] == 2
            and all(
                base.MULT[element][other] == base.MULT[other][element]
                for other in stabilizer
            )
        ]
        assert len(central) == 1
        central = central[0]

        # The stabilizer is D8 with commutator {1,z}.  Since z is +1 on
        # the point and -1 on its complementary plane, that plane cannot
        # contain a stabilizer-invariant line: a one-dimensional
        # character kills the commutator, whereas z acts there by -1.
        assert {
            commutator(first, second)
            for first in stabilizer
            for second in stabilizer
        } == {base.IDENTITY, central}

        plus_central = arrangement.plus_eigenline(central)
        minus_central = base.eigenspace_base(
            base.MATRICES[central], base.kneg(base.K1)
        )
        assert len(minus_central) == 2
        assert base.proportional(plus_central, point)
        assert base.qeval(point) != base.K0

        # Every element of the D8 stabilizer fixes the source point
        # projectively.  The preceding commutator calculation proves that
        # this is its unique invariant projective line.
        assert all(
            base.proportional(base.matvec(base.MATRICES[element], point), point)
            for element in stabilizer
        )

        incident_targets = [
            arrangement.plus_eigenline(reflection)
            for reflection in incident
        ]
        assert all(
            not base.proportional(first, second)
            for index, first in enumerate(incident_targets)
            for second in incident_targets[index + 1:]
        )

        for reflection in incident:
            flag_count += 1
            assert base.MULT[central][reflection] == base.MULT[reflection][central]
            opposite = base.MULT[central][reflection]
            klein_four = {
                base.IDENTITY, central, reflection, opposite
            }
            assert len(klein_four) == 4
            assert sorted(base.ORDERS[element] for element in klein_four) == [
                1, 2, 2, 2
            ]
            assert klein_four.issubset(set(stabilizer))

            # The incident reflection acts by -1 on q, while its +1
            # eigenline is the forced target of an even-degree map.
            image = base.matvec(base.MATRICES[reflection], point)
            assert all(
                base.kadd(image[index], point[index]) == base.K0
                for index in range(3)
            )
            plus_reflection = arrangement.plus_eigenline(reflection)
            assert not base.proportional(point, plus_reflection)

            # This is a useful local corroboration: a degree-one first
            # exceptional would project to this line, whose inverse image
            # in S is again elliptic rather than rational.
            assert polynomial_is_squarefree_on_line(
                plus_central, plus_reflection
            )

    assert quadruple_count == 21
    assert flag_count == 84
    print("EXACT flags: 21 D8 quadruple points and 84 incident V4 flags")
    print("EXACT endpoints: central and incident plus-eigenlines are distinct")
    print("EXACT near lines: all 84 central-incident lines are squarefree")


def main() -> None:
    verify_all_involution_fixed_loci()
    verify_quadruple_flags()
    print("WP3_ALL_DEGREE_PATH_OBSTRUCTION_OK")


if __name__ == "__main__":
    main()
