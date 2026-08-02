#!/usr/bin/env python3
"""Independent replay of a genuine common right-D-line on the C2 p=23 fibre.

This verifier reads only the accepted ``c2_morita.json`` packet and its bound
sources.  It does not import a point-producing solver.  It rebuilds the five
scalar equations q^* H_i q=0, the split-coordinate determinantal reduction,
an exhaustive affine 23^4 count, and the displayed smooth residue line.

The result is intentionally scoped: it is a smooth point of one split finite
fibre, not a K_proj-rational line or a characteristic-zero section.
"""

from __future__ import annotations

import hashlib
import itertools
import json
from collections import Counter
from pathlib import Path

import numpy as np
import sympy as sp


P = 23
HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
A7 = ROOT / "goals_2026-08-01" / "C_PFAFFIAN_FANO_CODEX_ROOT_20260801_A7C3"
CROOT = ROOT / "goals_2026-08-01" / "C_PFAFFIAN_FANO_CODEX_ROOT"
C2_PATH = A7 / "c2_morita.json"

EXPECTED_C2_SHA256 = "0201a89f9087250a4313ef2732398adbddcadd3d2f234183736088760aec645f"
EXPECTED_SOURCE_SHA256 = {
    "char0_rur": "54c181762c3c5a263f1dc6522e39d8e690196c7acdc31dfa44f5043481ca3216",
    "global_pluecker": "1a2f8dd96ee9323d3b6c52f0c9559471579168f5626df9931e21832801d73b75",
    "compressed_algebra": "bfc2e6c5afcfac7c9925b916cad29098bc5033f1938dd9f0273febc067a55fbb",
    "distinguished_five_plane": "edee4f7e07e95665044ba4fba85239154f4052f27d99b3cbcdd0f48b60d2378a",
}
SOURCE_PATHS = {
    "char0_rur": A7 / "ambient_degree12_rur_char0.json",
    "global_pluecker": A7 / "ambient_degree12_global_exact.json",
    "compressed_algebra": CROOT / "compressed_algebra.json",
    "distinguished_five_plane": CROOT / "distinguished_five_plane.json",
}

EXPECTED_SPLIT_FROM_ENTRIES = np.array(
    [
        [17, 11, 17, 7],
        [7, 4, 13, 16],
        [18, 3, 10, 5],
        [12, 18, 0, 11],
    ],
    dtype=np.int64,
)
EXPECTED_OLD_Q = [1, 0, 0, 0, 13, 9, 8, 10, 0, 20, 7, 1]
EXPECTED_SPLIT_TAIL = [20, 0, 20, 0, 15, 0, 4, 13]
EXPECTED_COUNTS = {
    "parameter_tuple_count": 279841,
    "determinant_zero_parameter_count": 13476,
    "determinant_singular_parameter_count": 3,
    "rank_counts": {3: 391, 4: 279450},
    "consistent_rank_counts": {3: 3, 4: 13085},
    "normalized_solution_count": 13154,
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def inv_mod(matrix: np.ndarray) -> np.ndarray:
    matrix = np.asarray(matrix, dtype=np.int64) % P
    n = matrix.shape[0]
    work = np.concatenate((matrix.copy(), np.eye(n, dtype=np.int64)), axis=1)
    for column in range(n):
        choices = np.flatnonzero(work[column:, column])
        if not len(choices):
            raise ValueError("singular matrix")
        pivot = column + int(choices[0])
        work[[column, pivot]] = work[[pivot, column]]
        work[column] = work[column] * pow(int(work[column, column]), -1, P) % P
        for row in range(n):
            if row != column and work[row, column]:
                work[row] = (work[row] - work[row, column] * work[column]) % P
    return work[:, n:] % P


def rank_mod(matrix: np.ndarray) -> int:
    work = np.asarray(matrix, dtype=np.int64).copy() % P
    row = 0
    for column in range(work.shape[1]):
        choices = np.flatnonzero(work[row:, column])
        if not len(choices):
            continue
        pivot = row + int(choices[0])
        work[[row, pivot]] = work[[pivot, row]]
        work[row] = work[row] * pow(int(work[row, column]), -1, P) % P
        for other in range(work.shape[0]):
            if other != row and work[other, column]:
                work[other] = (work[other] - work[other, column] * work[row]) % P
        row += 1
        if row == work.shape[0]:
            break
    return row


def corner_multiply(table, left, right):
    answer = np.zeros(4, dtype=np.int64)
    for i, left_coefficient in enumerate(left):
        for j, right_coefficient in enumerate(right):
            if left_coefficient and right_coefficient:
                answer += (
                    int(left_coefficient)
                    * int(right_coefficient)
                    * np.asarray(table[i][j], dtype=np.int64)
                )
    return answer % P


def rebuild_scalar_forms(payload):
    """Return the coefficient rows of the five genuine q^*H_iq quadrics."""
    witness = payload["good_fibre_witness"]
    table = witness["corner_multiplication_left_right_coordinates"]
    star = np.asarray(witness["corner_star_matrix_columns"], dtype=np.int64) % P
    matrices = witness["hermitian_matrices_D_coordinates"]
    units = [np.eye(4, dtype=np.int64)[index] for index in range(4)]

    assert rank_mod(star - np.eye(4, dtype=np.int64)) == 3
    for left in range(4):
        for right in range(4):
            product = corner_multiply(table, units[left], units[right])
            reversed_star_product = corner_multiply(
                table, star @ units[right] % P, star @ units[left] % P
            )
            assert np.array_equal(star @ product % P, reversed_star_product)
    for matrix in matrices:
        for row in range(3):
            for column in range(3):
                assert np.array_equal(
                    star @ np.asarray(matrix[row][column], dtype=np.int64) % P,
                    np.asarray(matrix[column][row], dtype=np.int64) % P,
                )

    pairs = [(left, right) for left in range(12) for right in range(left, 12)]
    forms = []
    for matrix in matrices:
        coefficients = []
        for left, right in pairs:
            left_row, left_basis = divmod(left, 4)
            right_row, right_basis = divmod(right, 4)

            def ordered_term(row, basis, column, other_basis):
                first = corner_multiply(
                    table, star @ units[basis] % P, matrix[row][column]
                )
                return corner_multiply(table, first, units[other_basis])

            value = ordered_term(left_row, left_basis, right_row, right_basis)
            if left != right:
                value = (
                    value
                    + ordered_term(right_row, right_basis, left_row, left_basis)
                ) % P
            # A Hermitian self-pairing is fixed by the canonical quaternion
            # involution, hence has only its scalar d_0 coordinate.
            assert not np.any(value[1:])
            coefficients.append(int(value[0]))
        forms.append(coefficients)
    assert len(forms) == 5
    return pairs, forms


def rebuild_split_change(witness):
    """Identify D with Mat_2(F_23) through its action on im(e)."""
    corner = [np.asarray(value, dtype=np.int64) % P for value in witness["corner_basis_values"]]
    projector = corner[0]
    image_columns = None
    for left, right in itertools.combinations(range(6), 2):
        candidate = projector[:, [left, right]] % P
        if rank_mod(candidate) == 2:
            image_columns = candidate
            break
    assert image_columns is not None
    pivot_rows = None
    for rows in itertools.combinations(range(6), 2):
        if rank_mod(image_columns[list(rows), :]) == 2:
            pivot_rows = rows
            break
    assert pivot_rows is not None
    inverse_minor = inv_mod(image_columns[list(pivot_rows), :])
    representation_columns = []
    for value in corner:
        rho = inverse_minor @ (value @ image_columns % P)[list(pivot_rows), :] % P
        assert np.array_equal(value @ image_columns % P, image_columns @ rho % P)
        representation_columns.append(rho.reshape(-1))
    old_to_entries = np.stack(representation_columns, axis=1) % P
    entries_to_old = inv_mod(old_to_entries)
    assert np.array_equal(entries_to_old, EXPECTED_SPLIT_FROM_ENTRIES)
    return old_to_entries, entries_to_old


def normalized_split_polynomials(pairs, forms, entries_to_old):
    variables = sp.symbols("z4:12")
    coordinate_values = [sp.Integer(1), sp.Integer(0), sp.Integer(0), sp.Integer(0)]
    for block_start in (0, 4):
        coordinate_values.extend(
            sum(
                int(entries_to_old[row, column]) * variables[block_start + column]
                for column in range(4)
            )
            for row in range(4)
        )
    equations = []
    for form in forms:
        expression = sum(
            int(coefficient) * coordinate_values[left] * coordinate_values[right]
            for coefficient, (left, right) in zip(form, pairs)
        )
        equations.append(sp.Poly(expression, *variables, modulus=P))
    return variables, equations


def direct_D_values(payload, old_q):
    witness = payload["good_fibre_witness"]
    table = witness["corner_multiplication_left_right_coordinates"]
    star = np.asarray(witness["corner_star_matrix_columns"], dtype=np.int64) % P
    matrices = witness["hermitian_matrices_D_coordinates"]
    q = [np.asarray(old_q[4 * row : 4 * row + 4], dtype=np.int64) % P for row in range(3)]
    values = []
    for matrix in matrices:
        total = np.zeros(4, dtype=np.int64)
        for row in range(3):
            for column in range(3):
                left = star @ q[row] % P
                total += corner_multiply(
                    table,
                    corner_multiply(table, left, matrix[row][column]),
                    q[column],
                )
        values.append((total % P).tolist())
    return values


def poly_value(poly: sp.Poly, values) -> int:
    answer = 0
    for exponents, coefficient in poly.terms():
        term = int(coefficient)
        for value, exponent in zip(values, exponents):
            term *= pow(int(value), int(exponent), P)
        answer += term
    return answer % P


def vector_poly_value(poly: sp.Poly, values: np.ndarray) -> np.ndarray:
    answer = np.zeros(values.shape[0], dtype=np.int64)
    for exponents, coefficient in poly.terms():
        term = np.full(values.shape[0], int(coefficient) % P, dtype=np.int64)
        for column, exponent in enumerate(exponents):
            if exponent:
                term = term * np.power(values[:, column], int(exponent)) % P
        answer = (answer + term) % P
    return answer


def exhaustive_affine_replay(variables, equations):
    linear_positions = (0, 2, 4, 6)
    parameter_positions = (1, 3, 5, 7)
    linear_variables = tuple(variables[index] for index in linear_positions)
    parameters = tuple(variables[index] for index in parameter_positions)
    kill_linear = {variable: 0 for variable in linear_variables}
    A_expr = []
    c_expr = []
    for equation in equations:
        expression = equation.as_expr()
        row = [
            sp.Poly(sp.diff(expression, variable).subs(kill_linear), *parameters, modulus=P)
            for variable in linear_variables
        ]
        constant = sp.Poly(expression.subs(kill_linear), *parameters, modulus=P)
        reconstructed = constant.as_expr() + sum(
            coefficient.as_expr() * variable
            for coefficient, variable in zip(row, linear_variables)
        )
        assert sp.Poly(expression - reconstructed, *variables, modulus=P).is_zero
        A_expr.append(row)
        c_expr.append(constant)

    augmented = sp.Matrix(
        [[entry.as_expr() for entry in row] + [constant.as_expr()]
         for row, constant in zip(A_expr, c_expr)]
    )
    determinant = sp.Poly(sp.det(augmented), *parameters, modulus=P)
    assert determinant.total_degree() == 4
    assert len(determinant.terms()) == 68
    assert not determinant.is_homogeneous

    grid = np.indices((P, P, P, P), dtype=np.int64).reshape(4, -1).T
    A_values = np.empty((len(grid), 5, 4), dtype=np.int64)
    for row in range(5):
        for column in range(4):
            A_values[:, row, column] = vector_poly_value(A_expr[row][column], grid)
    c_values = np.stack([vector_poly_value(poly, grid) for poly in c_expr], axis=1)
    determinant_values = vector_poly_value(determinant, grid)
    determinant_zero = determinant_values == 0

    row_minors = [
        sp.Poly(
            sp.det(sp.Matrix([[entry.as_expr() for entry in A_expr[row]]
                              for row in range(5) if row != omitted])),
            *parameters,
            modulus=P,
        )
        for omitted in range(5)
    ]
    minor_values = np.stack([vector_poly_value(poly, grid) for poly in row_minors], axis=1)
    rank_four = np.any(minor_values != 0, axis=1)
    rank_counts = Counter({4: int(np.count_nonzero(rank_four))})
    lower_indices = np.flatnonzero(~rank_four)
    for index in lower_indices:
        rank_counts[rank_mod(A_values[index])] += 1

    consistent_rank_counts = Counter(
        {4: int(np.count_nonzero(rank_four & determinant_zero))}
    )
    lower_consistent = []
    for index in lower_indices:
        rank = rank_mod(A_values[index])
        augmented_rank = rank_mod(
            np.column_stack((A_values[index], -c_values[index] % P))
        )
        if augmented_rank == rank:
            consistent_rank_counts[rank] += 1
            lower_consistent.append(index)

    derivative_values = np.stack(
        [vector_poly_value(determinant.diff(parameter), grid) for parameter in parameters],
        axis=1,
    )
    singular = determinant_zero & np.all(derivative_values == 0, axis=1)
    singular_indices = set(map(int, np.flatnonzero(singular)))
    assert singular_indices == set(map(int, lower_consistent))

    counts = {
        "parameter_tuple_count": len(grid),
        "determinant_zero_parameter_count": int(np.count_nonzero(determinant_zero)),
        "determinant_singular_parameter_count": int(np.count_nonzero(singular)),
        "rank_counts": dict(rank_counts),
        "consistent_rank_counts": dict(consistent_rank_counts),
        "normalized_solution_count": sum(
            count * P ** (4 - rank) for rank, count in consistent_rank_counts.items()
        ),
    }
    assert counts == EXPECTED_COUNTS
    singular_parameters = [grid[index].tolist() for index in sorted(singular_indices)]
    return determinant, A_expr, c_expr, counts, singular_parameters


def main() -> None:
    assert sha256(C2_PATH) == EXPECTED_C2_SHA256
    payload = json.loads(C2_PATH.read_text())
    assert payload["format"] == "c2-lazy-exact-morita-v1"
    assert payload["source_sha256"] == EXPECTED_SOURCE_SHA256
    for label, path in SOURCE_PATHS.items():
        assert sha256(path) == EXPECTED_SOURCE_SHA256[label]
    witness = payload["good_fibre_witness"]
    assert witness["prime"] == P
    assert witness["zeta11"] == 2
    assert witness["point"] == [1, 2, 3, 4, 5]
    assert witness["rur_root"] == 1
    assert witness["pairing"] == 3

    pairs, forms = rebuild_scalar_forms(payload)
    old_to_entries, entries_to_old = rebuild_split_change(witness)
    variables, equations = normalized_split_polynomials(pairs, forms, entries_to_old)
    determinant, A_expr, c_expr, counts, singular_parameters = exhaustive_affine_replay(
        variables, equations
    )

    split_tail = []
    for block_start in (4, 8):
        split_tail.extend(
            (old_to_entries @ np.asarray(EXPECTED_OLD_Q[block_start : block_start + 4], dtype=np.int64) % P).tolist()
        )
    assert split_tail == EXPECTED_SPLIT_TAIL
    residuals = [poly_value(equation, split_tail) for equation in equations]
    assert residuals == [0] * 5
    direct_values = direct_D_values(payload, EXPECTED_OLD_Q)
    assert direct_values == [[0, 0, 0, 0]] * 5

    jacobian = np.asarray(
        [
            [poly_value(equation.diff(variable), split_tail) for variable in variables]
            for equation in equations
        ],
        dtype=np.int64,
    )
    assert rank_mod(jacobian) == 5
    jacobian_minor = None
    for columns in itertools.combinations(range(8), 5):
        minor = int(sp.Matrix(jacobian[:, columns].tolist()).det()) % P
        if minor:
            jacobian_minor = ([int(variables[column].name[1:]) for column in columns], minor)
            break
    assert jacobian_minor is not None

    parameter_values = [split_tail[index] for index in (1, 3, 5, 7)]
    linear_values = [split_tail[index] for index in (0, 2, 4, 6)]
    A_at_witness = np.asarray(
        [[poly_value(entry, parameter_values) for entry in row] for row in A_expr],
        dtype=np.int64,
    )
    c_at_witness = np.asarray(
        [poly_value(entry, parameter_values) for entry in c_expr], dtype=np.int64
    )
    assert rank_mod(A_at_witness) == 4
    assert np.array_equal(A_at_witness @ np.asarray(linear_values) % P, -c_at_witness % P)
    assert poly_value(determinant, parameter_values) == 0

    print(f"PASS c2_morita.json sha256={EXPECTED_C2_SHA256}")
    print("PASS four bound C2 source hashes are current")
    print("PASS independently rebuilt the quaternion involution and five scalar q^*H_iq quadrics")
    print(
        "PASS exhaustive affine 23^4 reduction: "
        "det0=13476 ranks={3:391,4:279450} "
        "consistent={3:3,4:13085} normalizedSolutions=13154"
    )
    print(f"PASS affine determinant singular parameters={singular_parameters}")
    print(f"PASS genuine q(old corner coordinates)={EXPECTED_OLD_Q}")
    print(f"PASS five D-valued residuals={direct_values}")
    print(
        "PASS normalized 5x8 Jacobian rank=5 "
        f"minorColumns={jacobian_minor[0]} minor={jacobian_minor[1]}"
    )
    print(
        "SCOPE rank 5 proves a smooth relative-dimension-3 point on this normalized "
        "split p=23 fibre; it is not a K_proj-rational section"
    )
    print("C5-MORITA-SEED-P23-INDEPENDENTLY-VERIFIED")


if __name__ == "__main__":
    main()
