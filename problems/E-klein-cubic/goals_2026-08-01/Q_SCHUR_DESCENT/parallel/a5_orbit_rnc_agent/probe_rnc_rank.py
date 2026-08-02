#!/usr/bin/env python3
"""Good-prime RNC incidence probe for degree-11 A5 landing points.

The transfer from the full five-dimensional Schur source to the faithful
icosahedral A5 source is made explicit by a degree-zero Hilbert--90 frame.
For each resulting E^A5-point, the eleven G/A5 conjugates are evaluated and
their quadratic Hilbert-function rank is computed over F_89.
"""

from __future__ import annotations

from fractions import Fraction
import importlib.util
import itertools
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
WORKSPACE = HERE.parents[2]
SUBGROUP = WORKSPACE / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
POINT = (
    WORKSPACE.parent
    / "goals_after_35fa8f"
    / "point_attack_degree11_20260801"
)
P = 89
SQRT5 = 19
SQRT_MINUS11 = 73


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


PRODUCE = load_module("authoritative_subgroup_produce", SUBGROUP / "produce.py")
sys.path.insert(0, str(POINT))
import exact_reynolds as EXACT  # noqa: E402


def inv(value):
    return pow(value % P, -1, P)


def fraction_mod(value):
    value = Fraction(value)
    return value.numerator * inv(value.denominator) % P


def mat_vec(matrix, vector):
    return [
        sum(entry * value for entry, value in zip(row, vector)) % P
        for row in matrix
    ]


def mat_mul(left, right):
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right))) % P
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def mat_add(left, right):
    return [
        [(a + b) % P for a, b in zip(left_row, right_row)]
        for left_row, right_row in zip(left, right)
    ]


def mat_scale(scalar, matrix):
    return [[scalar * entry % P for entry in row] for row in matrix]


def determinant(matrix):
    work = [[entry % P for entry in row] for row in matrix]
    answer = 1
    for column in range(len(work)):
        pivot = next(
            (row for row in range(column, len(work)) if work[row][column]), None
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            answer = -answer
        unit = work[column][column] % P
        answer = answer * unit % P
        inverse = inv(unit)
        for row in range(column + 1, len(work)):
            scalar = work[row][column] * inverse % P
            work[row] = [
                (a - scalar * b) % P for a, b in zip(work[row], work[column])
            ]
    return answer % P


def nullspace(rows):
    work = [[entry % P for entry in row] for row in rows]
    row_count = len(work)
    column_count = len(work[0])
    pivots = []
    pivot_row = 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(pivot_row, row_count) if work[row][column]), None
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = inv(work[pivot_row][column])
        work[pivot_row] = [inverse * value % P for value in work[pivot_row]]
        for row in range(row_count):
            if row == pivot_row or not work[row][column]:
                continue
            scalar = work[row][column]
            work[row] = [
                (a - scalar * b) % P
                for a, b in zip(work[row], work[pivot_row])
            ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == row_count:
            break
    free = [column for column in range(column_count) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * column_count
        vector[free_column] = 1
        for row, pivot in reversed(list(enumerate(pivots))):
            vector[pivot] = -sum(
                work[row][column] * vector[column] for column in free
            ) % P
        basis.append(vector)
    return basis


def matrix_rank(rows):
    return len(rows[0]) - len(nullspace(rows)) if rows else 0


def ambient_intertwiner(generators, abstract_map):
    equations = []
    for h in generators:
        rho = PRODUCE.RHO[h]
        abstract = EXACT.EXACT_TARGET[abstract_map[h]]
        for i in range(5):
            for j in range(5):
                equation = [0] * 25
                for k in range(5):
                    equation[5 * k + j] += rho[i][k]
                    equation[5 * i + k] -= abstract[k][j]
                equations.append(equation)
    kernel = nullspace(equations)
    assert len(kernel) == 1
    vector = kernel[0]
    matrix = [vector[5 * row : 5 * row + 5] for row in range(5)]
    assert determinant(matrix)
    return matrix


def transfer_frame(vector, subgroup, abstract_map):
    """Frame B with B(rho(h)v)=sigma(h)B(v), sigma the 3-space."""
    answer = [[0] * 3 for _ in range(3)]
    ell = (1, 2, 3, 4, 5)
    for h in subgroup:
        moved = mat_vec(PRODUCE.RHO[PRODUCE.ginv(h)], vector)
        denominator = sum(a * b for a, b in zip(ell, moved)) % P
        if not denominator:
            return None
        scalar = moved[0] * inv(denominator) % P
        source_matrix = PRODUCE.SOURCE_A5[abstract_map[h]]
        answer = mat_add(answer, mat_scale(scalar, source_matrix))
    return answer


def field_constant(components, radical_sign):
    c0, cs, cg, csg = (fraction_mod(value) for value in components)
    g = radical_sign * SQRT_MINUS11 % P
    return (c0 + cs * SQRT5 + cg * g + csg * SQRT5 * g) % P


def point_parameters(radical_sign):
    relations = json.loads((POINT / "degree11_reconstructed_relations.json").read_text())[
        "relations"
    ]
    p2, p1, p0 = (
        field_constant(relations[name], radical_sign)
        for name in ("p2", "p1", "p0")
    )
    roots = [
        alpha
        for alpha in range(P)
        if (alpha**3 + p2 * alpha**2 + p1 * alpha + p0) % P == 0
    ]
    answer = []
    for alpha in roots:
        coordinates = [1]
        for index in (1, 2, 3):
            value = 0
            for degree in range(3):
                coefficient = field_constant(
                    relations[f"a{index}_{degree}"], radical_sign
                )
                value = (value + coefficient * alpha**degree) % P
            coordinates.append(value)
        coordinates.append(alpha)
        answer.append(tuple(coordinates))
    return (p2, p1, p0), answer


def load_covariants():
    payload = json.loads((POINT / "degree11_covariants_raw_exact.json").read_text())
    answer = []
    for covariant in payload["covariants"]:
        components = []
        for component in covariant:
            polynomial = {}
            for exponent_text, coefficient in component.items():
                exponent = tuple(map(int, exponent_text.split(",")))
                rational = Fraction(*coefficient["rational"])
                sqrt_part = Fraction(*coefficient["sqrt5"])
                polynomial[exponent] = (
                    fraction_mod(rational) + SQRT5 * fraction_mod(sqrt_part)
                ) % P
            components.append(polynomial)
        answer.append(components)
    assert len(answer) == 5 and all(len(value) == 5 for value in answer)
    return answer


def evaluate_polynomial(polynomial, point):
    answer = 0
    for exponent, coefficient in polynomial.items():
        monomial = coefficient
        for coordinate, power in zip(point, exponent):
            monomial = monomial * pow(coordinate, power, P) % P
        answer = (answer + monomial) % P
    return answer


def canonical_point(source_point, parameters, covariants):
    answer = [0] * 5
    for scalar, covariant in zip(parameters, covariants):
        for output, polynomial in enumerate(covariant):
            answer[output] = (
                answer[output] + scalar * evaluate_polynomial(polynomial, source_point)
            ) % P
    return answer


def klein(point):
    return sum(point[i] ** 2 * point[(i + 1) % 5] for i in range(5)) % P


def projective_normalize(point):
    pivot = next(value for value in point if value)
    inverse = inv(pivot)
    return tuple(value * inverse % P for value in point)


QUADRICS = tuple(
    tuple(int(k == i) + int(k == j) for k in range(5))
    for i in range(5)
    for j in range(i, 5)
)


def quadric_row(point):
    answer = []
    for exponent in QUADRICS:
        value = 1
        for coordinate, power in zip(point, exponent):
            value = value * pow(coordinate, power, P) % P
        answer.append(value)
    return answer


def right_coset_representatives(subgroup):
    unused = set(PRODUCE.GROUP)
    representatives = []
    while unused:
        representative = min(unused)
        coset = {PRODUCE.gmul(representative, h) for h in subgroup}
        assert len(coset) == 60
        representatives.append(representative)
        unused.difference_update(coset)
    assert len(representatives) == 11
    return representatives


def verify_transfer(frame, vector, generators, abstract_map):
    for h in generators:
        moved = mat_vec(PRODUCE.RHO[h], vector)
        moved_frame = transfer_frame(moved, tuple(abstract_map), abstract_map)
        expected = mat_mul(PRODUCE.SOURCE_A5[abstract_map[h]], frame)
        assert moved_frame == expected


def run_class(record, radical_sign, covariants):
    subgroup = tuple(tuple(value) for value in record["subgroup_elements"])
    generators = tuple(tuple(value) for value in record["generators"])
    abstract_map = {
        tuple(row["h"]): tuple(row["permutation"]) for row in record["source_map"]
    }
    assert set(subgroup) == set(abstract_map)
    intertwiner = ambient_intertwiner(generators, abstract_map)
    coefficients, parameter_vectors = point_parameters(radical_sign)
    print(record["label"], "ALPHA_CUBIC", coefficients, "ROOTS", len(parameter_vectors))
    assert parameter_vectors
    representatives = right_coset_representatives(subgroup)

    chosen = None
    for vector in itertools.product(range(1, 9), repeat=5):
        frame = transfer_frame(vector, subgroup, abstract_map)
        conjugate_frames = []
        for representative in representatives:
            moved = mat_vec(PRODUCE.RHO[PRODUCE.ginv(representative)], vector)
            conjugate_frames.append(transfer_frame(moved, subgroup, abstract_map))
        if (
            frame is not None
            and determinant(frame)
            and all(value is not None and determinant(value) for value in conjugate_frames)
        ):
            chosen = tuple(vector), frame
            break
    assert chosen is not None
    vector, frame = chosen
    verify_transfer(frame, vector, generators, abstract_map)
    print(record["label"], "FULL_SOURCE_POINT", vector, "TRANSFER_DET", determinant(frame))

    for root_index, parameters in enumerate(parameter_vectors):
        def q_at(full_source_point):
            local_frame = transfer_frame(full_source_point, subgroup, abstract_map)
            assert local_frame is not None and determinant(local_frame)
            source_point = [local_frame[row][0] for row in range(3)]
            canonical = canonical_point(source_point, parameters, covariants)
            return mat_vec(intertwiner, canonical)

        # Exact H-covariance guard at the chosen full-source point.
        base_q = q_at(vector)
        assert any(base_q) and klein(base_q) == 0
        for h in generators:
            assert q_at(mat_vec(PRODUCE.RHO[h], vector)) == mat_vec(PRODUCE.RHO[h], base_q)

        conjugates = []
        for representative in representatives:
            moved_source = mat_vec(PRODUCE.RHO[PRODUCE.ginv(representative)], vector)
            raw = q_at(moved_source)
            conjugates.append(mat_vec(PRODUCE.RHO[representative], raw))
        assert all(any(point) and klein(point) == 0 for point in conjugates)
        normalized = [projective_normalize(point) for point in conjugates]
        distinct = len(set(normalized))
        rank = matrix_rank([quadric_row(point) for point in conjugates])
        kernel = 15 - rank
        print(
            record["label"],
            "ROOT_INDEX", root_index,
            "PARAMETERS", parameters,
            "DISTINCT", distinct,
            "QUADRIC_EVAL_RANK", rank,
            "QUADRICS_THROUGH", kernel,
        )
        if rank >= 10:
            print(record["label"], "ROOT_INDEX", root_index, "RNC_QUADRIC_NECESSARY_CONDITION_FAILS")


def main():
    assert pow(2, 11, P) == 1 and pow(2, 1, P) != 1
    assert SQRT5**2 % P == 5 and SQRT_MINUS11**2 % P == -11 % P
    twists = json.loads((SUBGROUP / "twists.json").read_text())
    covariants = load_covariants()
    for record, radical_sign in zip(twists["records"][:2], (-1, 1)):
        run_class(record, radical_sign, covariants)
    print("A5_ORBIT_RNC_GOOD_PRIME_PROBE_OK")


if __name__ == "__main__":
    main()
