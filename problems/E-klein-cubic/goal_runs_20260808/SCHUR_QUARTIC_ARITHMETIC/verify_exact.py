#!/usr/bin/env python3
"""Exact finite audit of the canonical Schur-quartic chart.

This is deliberately a small calculation.  It consumes the already certified
15 x 5 Pfaffian intertwiner over Q(zeta_11), forms one 6 x 6 skew matrix and
one 4 x 6 contraction matrix, and checks their forced minors.  It does not
search over degrees, supports, or coefficient boxes.
"""

from __future__ import annotations

from itertools import combinations
import json
from pathlib import Path
import runpy


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
ALIGNMENT = ROOT / "tmp/pfaffian_representation_alignment"


def pfaffian_polynomial(forms, field):
    """Return the Pfaffian as an exponent-dictionary in five variables."""

    zero_exp = (0, 0, 0, 0, 0)

    def add(left, right):
        answer = dict(left)
        for exponent, coefficient in right.items():
            answer[exponent] = answer.get(exponent, field.zero) + coefficient
        return {exponent: coefficient for exponent, coefficient in answer.items() if coefficient}

    def multiply(left, right):
        answer = {}
        for exponent_left, coefficient_left in left.items():
            for exponent_right, coefficient_right in right.items():
                exponent = tuple(
                    exponent_left[index] + exponent_right[index]
                    for index in range(5)
                )
                answer[exponent] = (
                    answer.get(exponent, field.zero)
                    + coefficient_left * coefficient_right
                )
        return {exponent: coefficient for exponent, coefficient in answer.items() if coefficient}

    def linear_entry(row, column):
        return {
            tuple(1 if index == form_index else 0 for index in range(5)):
            forms[form_index][row][column]
            for form_index in range(5)
            if forms[form_index][row][column]
        }

    def pfaffian(indices):
        if not indices:
            return {zero_exp: field.one}
        first = indices[0]
        answer = {}
        for position in range(1, len(indices)):
            second = indices[position]
            rest = indices[1:position] + indices[position + 1 :]
            term = multiply(linear_entry(first, second), pfaffian(rest))
            if position % 2 == 0:
                term = {exponent: -coefficient for exponent, coefficient in term.items()}
            answer = add(answer, term)
        return answer

    return pfaffian(list(range(6)))


def determinant(matrix, ring):
    if not matrix:
        return ring.one
    return sum(
        (ring.one if column % 2 == 0 else -ring.one)
        * matrix[0][column]
        * determinant(
            [row[:column] + row[column + 1 :] for row in matrix[1:]],
            ring,
        )
        for column in range(len(matrix))
    )


def matrix_vector(matrix, vector, field):
    return [
        sum((matrix[row][column] * vector[column] for column in range(6)), field.zero)
        for row in range(6)
    ]


def load_forms():
    core = runpy.run_path(str(ALIGNMENT / "core.py"))
    certificate = json.loads((ALIGNMENT / "certificate.json").read_text())
    serialized = certificate["exact_intertwiner"]["embedding_15x5"]
    embedding = core["deserialize_matrix"](serialized).to_list()
    field = core["K11"]
    pairs = core["PAIR_INDEX"]
    forms = []
    for form_index in range(5):
        matrix = [[field.zero for _ in range(6)] for _ in range(6)]
        for row, (left, right) in enumerate(pairs):
            matrix[left][right] = embedding[row][form_index]
            matrix[right][left] = -embedding[row][form_index]
        forms.append(matrix)
    return core, field, pairs, forms


def contraction_matrix(forms, vector, form_indices, ring):
    def coerce(entry):
        # AlgebraicField.__call__ interprets an existing ANP as a coefficient
        # list, whereas PolynomialRing.__call__ is the desired constant
        # embedding.  The vector already tells us which case we are in.
        return entry if type(vector[0]) is type(entry) else ring(entry)

    return [
        [
            sum(
                (vector[row] * coerce(forms[form_index][row][column]) for row in range(6)),
                ring.zero,
            )
            for column in range(6)
        ]
        for form_index in form_indices
    ]


def normal_direction(core, field, forms, y, ay, kernel_basis, s, t):
    """One fibrewise vertical direction, expressed in the y0=1 tangent chart."""

    vector = [
        field(s) * kernel_basis[0][index] + field(t) * kernel_basis[1][index]
        for index in range(6)
    ]
    contraction = contraction_matrix(forms, vector, range(1, 5), field)
    contraction_dm = core["dm"](contraction)
    assert contraction_dm.rank() == 4
    plane_basis = contraction_dm.nullspace().to_list()
    companion = next(
        candidate
        for candidate in plane_basis
        if core["dm"]([vector, candidate]).rank() == 2
    )

    columns = [matrix_vector(forms[index], vector, field) for index in range(1, 5)]
    right_hand_side = [-entry for entry in matrix_vector(ay, companion, field)]
    augmented = core["dm"](
        [
            [columns[column][row] for column in range(4)] + [right_hand_side[row]]
            for row in range(6)
        ]
    )
    reduced, pivots = augmented.rref()
    assert pivots == (0, 1, 2, 3)
    solution = [reduced.to_list()[index][4] for index in range(4)]
    assert all(
        sum((columns[column][row] * solution[column] for column in range(4)), field.zero)
        == right_hand_side[row]
        for row in range(6)
    )
    return solution


def independent_block(core, entries, rank):
    """Choose a nonsingular rank x rank block of an exact matrix."""

    matrix = core["dm"](entries)
    _, pivot_columns = matrix.rref()
    columns = list(pivot_columns[:rank])
    restricted = [[row[column] for column in columns] for row in entries]
    _, pivot_rows = core["dm"](restricted).transpose().rref()
    rows = list(pivot_rows[:rank])
    block = core["dm"]([[entries[row][column] for column in columns] for row in rows])
    assert block.shape == (rank, rank)
    assert block.det()
    return rows, columns


def schur_jacobian(core, field, base, derivatives, rank):
    """Jacobian of the localized rank <= rank determinantal equations."""

    row_count = len(base)
    column_count = len(base[0])
    rows, columns = independent_block(core, base, rank)
    remaining_rows = [index for index in range(row_count) if index not in rows]
    remaining_columns = [index for index in range(column_count) if index not in columns]
    assert len(remaining_columns) == 1

    def block(entries, selected_rows, selected_columns):
        return core["dm"](
            [[entries[row][column] for column in selected_columns] for row in selected_rows]
        )

    a = block(base, rows, columns)
    b = block(base, rows, remaining_columns)
    c = block(base, remaining_rows, columns)
    inverse = a.inv()
    d = block(base, remaining_rows, remaining_columns)
    assert d - c.matmul(inverse).matmul(b) == core["dm"](
        [[field.zero] for _ in remaining_rows]
    )

    columns_of_jacobian = []
    for derivative in derivatives:
        da = block(derivative, rows, columns)
        db = block(derivative, rows, remaining_columns)
        dc = block(derivative, remaining_rows, columns)
        dd = block(derivative, remaining_rows, remaining_columns)
        differential = (
            dd
            - dc.matmul(inverse).matmul(b)
            - c.matmul(inverse).matmul(db)
            + c.matmul(inverse).matmul(da).matmul(inverse).matmul(b)
        )
        columns_of_jacobian.append([row[0] for row in differential.to_list()])
    jacobian = [
        [columns_of_jacobian[column][row] for column in range(len(derivatives))]
        for row in range(len(remaining_rows))
    ]
    return jacobian, a.det()


def exact_rank_chart(core, field, forms, kernel_basis):
    """Compare the gauge-fixed 25 x 21 chart with the 12 x 5 kernel chart."""

    # Put the selected kernel line in the standard chart <e0,e1>.
    columns = [list(kernel_basis[0]), list(kernel_basis[1])]
    standard = [
        [field.one if row == column else field.zero for row in range(6)]
        for column in range(6)
    ]
    for candidate in standard:
        if len(columns) == 6:
            break
        if core["dm"](columns + [candidate]).rank() > len(columns):
            columns.append(candidate)
    assert len(columns) == 6
    change = core["dm"](
        [[columns[column][row] for column in range(6)] for row in range(6)]
    )
    assert change.det()
    transformed = [
        change.transpose().matmul(core["dm"](form)).matmul(change).to_list()
        for form in forms
    ]

    e = standard
    a0, b0 = e[0], e[1]
    da = e[2:6] + [[field.zero] * 6 for _ in range(4)]
    db = [[field.zero] * 6 for _ in range(4)] + e[2:6]

    # Gauge slice for c=sum c_k s^(3-k)t^k.  At <e0,e1> the three killed
    # coordinates are exactly q0,q1,q2 in c -> c+q(s,t)(sa+tb).
    killed = {(0, 0), (1, 0), (3, 1)}
    c_columns = [
        (coefficient, coordinate)
        for coefficient in range(4)
        for coordinate in range(6)
        if (coefficient, coordinate) not in killed
    ]
    assert len(c_columns) == 21

    def b_matrix(a, b):
        rows = []
        for form in transformed:
            for monomial in range(5):
                row = []
                for coefficient, coordinate in c_columns:
                    value = field.zero
                    if monomial == coefficient:
                        value += sum(
                            (a[index] * form[index][coordinate] for index in range(6)),
                            field.zero,
                        )
                    if monomial == coefficient + 1:
                        value += sum(
                            (b[index] * form[index][coordinate] for index in range(6)),
                            field.zero,
                        )
                    row.append(value)
                rows.append(row)
        return rows

    def c_matrix(a, b):
        rows = []
        for vector in (a, b):
            for coordinate in range(6):
                rows.append(
                    [
                        sum(
                            (form[coordinate][index] * vector[index] for index in range(6)),
                            field.zero,
                        )
                        for form in transformed
                    ]
                )
        return rows

    base_b = b_matrix(a0, b0)
    base_c = c_matrix(a0, b0)
    assert core["dm"](base_b).rank() == 20
    assert core["dm"](base_c).rank() == 4

    derivatives_b = []
    derivatives_c = []
    for parameter in range(8):
        if parameter < 4:
            varied_a, varied_b = da[parameter], [field.zero] * 6
        else:
            varied_a, varied_b = [field.zero] * 6, db[parameter]
        derivatives_b.append(b_matrix(varied_a, varied_b))
        derivatives_c.append(c_matrix(varied_a, varied_b))

    jacobian_b, pivot_b = schur_jacobian(core, field, base_b, derivatives_b, 20)
    jacobian_c, pivot_c = schur_jacobian(core, field, base_c, derivatives_c, 4)
    assert pivot_b and pivot_c
    assert core["dm"](jacobian_b).rank() == 5
    assert core["dm"](jacobian_c).rank() == 5
    # Universal containment plus equality of these exact conormal spaces gives
    # equality of the two smooth codimension-five germs on this pivot chart.
    assert core["dm"](jacobian_b + jacobian_c).rank() == 5
    return 20, 4, 5


def main() -> None:
    core, field, pairs, forms = load_forms()

    # The 6 x 6 Pfaffian is exactly a nonzero scalar times the standard Klein
    # cubic in the certified Weil basis.
    pfaffian = pfaffian_polynomial(forms, field)
    klein_support = {
        (2, 1, 0, 0, 0),
        (0, 2, 1, 0, 0),
        (0, 0, 2, 1, 0),
        (0, 0, 0, 2, 1),
        (1, 0, 0, 0, 2),
    }
    assert set(pfaffian) == klein_support
    pfaffian_scalars = set(pfaffian.values())
    assert len(pfaffian_scalars) == 1
    pfaffian_scalar = next(iter(pfaffian_scalars))
    assert pfaffian_scalar

    # A rational smooth point chosen analytically on the Klein cubic.
    y = [1, 1, 1, -2, 0]
    assert sum(
        (
            field(y[0]) ** 2 * field(y[1]),
            field(y[1]) ** 2 * field(y[2]),
            field(y[2]) ** 2 * field(y[3]),
            field(y[3]) ** 2 * field(y[4]),
            field(y[4]) ** 2 * field(y[0]),
        ),
        field.zero,
    ) == field.zero
    ay = [
        [
            sum((field(y[index]) * forms[index][row][column] for index in range(5)), field.zero)
            for column in range(6)
        ]
        for row in range(6)
    ]
    ay_dm = core["dm"](ay)
    assert ay_dm.rank() == 4
    kernel_basis = ay_dm.nullspace().to_list()
    assert len(kernel_basis) == 2

    # Use z=t/s.  The four forms e1,...,e4 are a complement to Ky because
    # y0=1.  Every maximal minor is a quartic; gcd 1 is exactly the forced
    # saturation/basepoint-free condition on this fibre.
    polynomial_ring = field.poly_ring("z")
    z = polynomial_ring.gens[0]
    vector = [
        polynomial_ring(kernel_basis[0][index])
        + z * polynomial_ring(kernel_basis[1][index])
        for index in range(6)
    ]
    contraction = contraction_matrix(forms, vector, range(1, 5), polynomial_ring)
    plucker = {}
    for left, right in pairs:
        columns = [index for index in range(6) if index not in (left, right)]
        minor = determinant(
            [[contraction[row][column] for column in columns] for row in range(4)],
            polynomial_ring,
        )
        plucker[left, right] = (-1 if (left + right + 1) % 2 else 1) * minor

    assert {value.degree() for value in plucker.values() if value} == {4}
    common_factor = None
    for value in plucker.values():
        if value:
            common_factor = value.monic() if common_factor is None else common_factor.gcd(value).monic()
    assert common_factor == polynomial_ring.one

    # The complementary minors satisfy all Pluecker quadrics and all five
    # linear equations cutting X out of Gr(2,6).
    for i, j, k, ell in combinations(range(6), 4):
        assert (
            plucker[i, j] * plucker[k, ell]
            - plucker[i, k] * plucker[j, ell]
            + plucker[i, ell] * plucker[j, k]
        ) == polynomial_ring.zero
    for form in forms:
        assert sum(
            (polynomial_ring(form[left][right]) * plucker[left, right] for left, right in pairs),
            polynomial_ring.zero,
        ) == polynomial_ring.zero

    # Elimination/inverse on the kernel-line chart: the 12 x 5 contraction
    # matrix of the two line generators has rank four and its one-dimensional
    # kernel recovers [1:1:1:-2:0].  Changing the source basis changes neither
    # this line nor the recovered projective point.
    inverse_matrix = []
    for generator in kernel_basis:
        for row in range(6):
            inverse_matrix.append(
                [
                    sum((forms[index][row][column] * generator[column] for column in range(6)), field.zero)
                    for index in range(5)
                ]
            )
    inverse_dm = core["dm"](inverse_matrix)
    assert inverse_dm.rank() == 4
    recovered = inverse_dm.nullspace().to_list()[0]
    scale = recovered[0]
    assert scale
    assert [entry / scale for entry in recovered] == [field(entry) for entry in y]

    b_rank, c_rank, chart_codimension = exact_rank_chart(
        core, field, forms, kernel_basis
    )

    # The normal sequence is 0 -> O(-2) -> O^3 -> N -> 0.  At this exact
    # point three fibrewise vertical directions span T_yY, so the injection
    # is the complete quadratic series and N = O(1) + O(1).
    directions = [
        normal_direction(core, field, forms, y, ay, kernel_basis, s, t)
        for s, t in ((1, 0), (0, 1), (1, 1), (1, 2), (2, 1))
    ]
    assert core["dm"](directions).rank() == 3
    gradient = [2, 3, -3, 1, 4]
    for direction in directions:
        # direction records dy1,...,dy4 with dy0=0
        assert sum(
            (field(gradient[index + 1]) * direction[index] for index in range(4)),
            field.zero,
        ) == field.zero

    print("PFaffian support: Klein cyclic five-term cubic")
    print("selected point: [1:1:1:-2:0]")
    print("4x6 maximal-minor degrees: 4; gcd: 1")
    print("12x5 inverse contraction rank: 4; projective fibre: 1")
    print(
        f"gauge chart ranks: B={b_rank}, contraction={c_rank}; "
        f"common exact codimension={chart_codimension}"
    )
    print("normal vertical-series rank: 3; N = O(1) + O(1)")
    print("SCHUR-QUARTIC-KERNEL-COMPONENT-EXACT-OK")


if __name__ == "__main__":
    main()
