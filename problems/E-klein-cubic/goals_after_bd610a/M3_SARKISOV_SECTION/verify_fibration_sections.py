#!/usr/bin/env python3
"""Independent replay of the exact M3.0 model and M3.1 modular evidence.

This verifier does not import any M3 producer.  It reduces the serialized
cyclotomic frame, reconstructs the transformed Klein cubic, checks the
generic-fibre Jacobian ideals, rebuilds the degree-one and degree-four
coefficient equations, and verifies both the common-factor controls and the
genuine gcd-free residual-section points at both split primes.
"""

from __future__ import annotations

import hashlib
import json
import subprocess
from collections import defaultdict
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
FRAME_PATH = (
    PROBLEM
    / "goals_2026-08-01"
    / "Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D"
    / "exact_frame.json"
)
MODEL_PATH = HERE / "fibration_model.json"
CLASSES_PATH = HERE / "SECTION_CLASSES.json"
RESOLUTION = PROBLEM / "RESOLUTION.md"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def reduce_k11(value: list[list[int]], prime: int, zeta: int) -> int:
    total = 0
    for exponent, pair in enumerate(value):
        numerator, denominator = map(int, pair)
        total += numerator * pow(denominator, -1, prime) * pow(zeta, exponent, prime)
    return total % prime


def determinant_mod(matrix: list[list[int]], prime: int) -> int:
    data = [[entry % prime for entry in row] for row in matrix]
    result = 1
    for column in range(len(data)):
        pivot = next(row for row in range(column, len(data)) if data[row][column])
        if pivot != column:
            data[pivot], data[column] = data[column], data[pivot]
            result = -result
        value = data[column][column] % prime
        result = result * value % prime
        inverse = pow(value, -1, prime)
        data[column] = [entry * inverse % prime for entry in data[column]]
        for row in range(column + 1, len(data)):
            factor = data[row][column]
            if factor:
                data[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(data[row], data[column])
                ]
    return result % prime


def cubic_terms(frame: list[list[int]], prime: int) -> dict[tuple[int, ...], int]:
    result: dict[tuple[int, ...], int] = defaultdict(int)
    for row in range(5):
        for left in range(5):
            for middle in range(5):
                for right in range(5):
                    exponent = [0] * 5
                    exponent[left] += 1
                    exponent[middle] += 1
                    exponent[right] += 1
                    key = tuple(exponent)
                    result[key] = (
                        result[key]
                        + frame[row][left]
                        * frame[row][middle]
                        * frame[(row + 1) % 5][right]
                    ) % prime
    return {key: value for key, value in result.items() if value}


def fibre_terms(
    cubic: dict[tuple[int, ...], int], prime: int
) -> dict[tuple[int, ...], int]:
    result: dict[tuple[int, ...], int] = defaultdict(int)
    for exponent, coefficient in cubic.items():
        key = (
            exponent[0],
            exponent[1],
            exponent[2],
            exponent[3] + exponent[4],
            exponent[3],
        )
        result[key] = (result[key] + coefficient) % prime
    return {key: value for key, value in result.items() if value}


def deserialize(entries: list[dict], prime: int) -> dict[tuple[int, ...], int]:
    return {
        tuple(map(int, entry["exponents"])): int(entry["coefficient"]) % prime
        for entry in entries
        if int(entry["coefficient"]) % prime
    }


def singular_text(
    terms: dict[tuple[int, ...], int], variables: tuple[str, ...], prime: int
) -> str:
    pieces = []
    for exponent, coefficient in sorted(terms.items(), reverse=True):
        factors = [] if coefficient % prime == 1 else [str(coefficient % prime)]
        for variable, power in zip(variables, exponent):
            if power == 1:
                factors.append(variable)
            elif power:
                factors.append(f"{variable}^{power}")
        pieces.append("*".join(factors) if factors else "1")
    return "+".join(pieces)


def check_smoothness(
    terms: dict[tuple[int, ...], int], prime: int
) -> None:
    variables = ("a0", "a1", "a2", "u", "q")
    polynomial = singular_text(terms, variables, prime)
    lines = [
        f"ring r=({prime},q),(a0,a1,a2,u),dp;",
        f"poly F={polynomial};",
    ]
    for index, variable in enumerate(variables[:4]):
        lines.extend(
            [
                f"ideal I{index}=diff(F,a0),diff(F,a1),diff(F,a2),diff(F,u),{variable}-1;",
                f"ideal G{index}=std(I{index});",
                f'print("UNIT_{index}="+string(reduce(1,G{index})==0));',
            ]
        )
    completed = subprocess.run(
        ["Singular", "-q"],
        input="\n".join(lines),
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=True,
        timeout=180,
    )
    for index in range(4):
        assert f"UNIT_{index}=1" in completed.stdout, completed.stdout


def phi_expression(
    terms: dict[tuple[int, ...], int], variables: tuple[sp.Symbol, ...]
) -> sp.Expr:
    return sum(
        coefficient
        * sp.prod(variable**power for variable, power in zip(variables, exponent))
        for exponent, coefficient in terms.items()
    )


def section_system(
    terms: dict[tuple[int, ...], int], degree: int, prime: int
) -> tuple[list[sp.Symbol], list[sp.Poly], list[sp.Expr]]:
    a = sp.symbols("a0:5")
    s, t = sp.symbols("s t")
    blocks = [tuple(sp.symbols(f"A{i}_0:{degree + 1}")) for i in range(3)]
    rblock = tuple(sp.symbols(f"b_0:{degree}"))
    forms = [
        sum(block[index] * s ** (degree - index) * t**index for index in range(degree + 1))
        for block in blocks
    ]
    r = sum(
        rblock[index] * s ** (degree - 1 - index) * t**index
        for index in range(degree)
    )
    identity = sp.expand(
        phi_expression(terms, a).subs(
            {a[0]: forms[0], a[1]: forms[1], a[2]: forms[2], a[3]: s * r, a[4]: t * r}
        )
    )
    binary = sp.Poly(identity, s, t)
    parameters = [item for block in (*blocks, rblock) for item in block]
    equations = [
        sp.Poly(
            binary.coeff_monomial(s ** (3 * degree - index) * t**index),
            *parameters,
            modulus=prime,
        )
        for index in range(3 * degree + 1)
    ]
    return parameters, equations, [*forms, r]


def evaluate(poly: sp.Poly, parameters: list[sp.Symbol], point: list[int], prime: int) -> int:
    substitution = dict(zip(parameters, point))
    return int(poly.as_expr().subs(substitution)) % prime


def rank_mod(matrix: list[list[int]], prime: int) -> int:
    data = [[entry % prime for entry in row] for row in matrix]
    rank = 0
    for column in range(len(data[0])):
        pivot = next(
            (row for row in range(rank, len(data)) if data[row][column]), None
        )
        if pivot is None:
            continue
        data[rank], data[pivot] = data[pivot], data[rank]
        inverse = pow(data[rank][column], -1, prime)
        data[rank] = [entry * inverse % prime for entry in data[rank]]
        for row in range(len(data)):
            if row != rank and data[row][column]:
                factor = data[row][column]
                data[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(data[row], data[rank])
                ]
        rank += 1
    return rank


def coefficient_vector(poly: sp.Poly, degree: int, prime: int) -> list[int]:
    s, t = poly.gens
    return [
        int(poly.coeff_monomial(s ** (degree - index) * t**index)) % prime
        for index in range(degree + 1)
    ]


def common_gcd(polynomials: list[sp.Poly]) -> sp.Poly:
    nonzero = [poly for poly in polynomials if not poly.is_zero]
    assert nonzero
    result = nonzero[0]
    for poly in nonzero[1:]:
        result = sp.gcd(result, poly)
    return result


def assert_projectively_equal(
    actual: list[int], retained: list[int], prime: int
) -> None:
    assert len(actual) == len(retained)
    pivot = next(index for index, value in enumerate(retained) if value % prime)
    scale = actual[pivot] * pow(retained[pivot] % prime, -1, prime) % prime
    assert scale
    assert all(
        left % prime == scale * right % prime
        for left, right in zip(actual, retained)
    )


def matrix_multiply(
    left: list[list[int]], right: list[list[int]], prime: int
) -> list[list[int]]:
    assert left and right and len(left[0]) == len(right)
    return [
        [
            sum(left[row][middle] * right[middle][column] for middle in range(len(right)))
            % prime
            for column in range(len(right[0]))
        ]
        for row in range(len(left))
    ]


def identity_matrix(size: int) -> list[list[int]]:
    return [[int(row == column) for column in range(size)] for row in range(size)]


def inverse_matrix_mod(matrix: list[list[int]], prime: int) -> list[list[int]]:
    size = len(matrix)
    assert size and all(len(row) == size for row in matrix)
    augmented = [
        [entry % prime for entry in matrix[row]] + identity_matrix(size)[row]
        for row in range(size)
    ]
    for column in range(size):
        pivot = next(
            row for row in range(column, size) if augmented[row][column] % prime
        )
        augmented[column], augmented[pivot] = augmented[pivot], augmented[column]
        inverse = pow(augmented[column][column] % prime, -1, prime)
        augmented[column] = [entry * inverse % prime for entry in augmented[column]]
        for row in range(size):
            if row != column and augmented[row][column] % prime:
                factor = augmented[row][column] % prime
                augmented[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(augmented[row], augmented[column])
                ]
    return [row[size:] for row in augmented]


def nullspace_mod(matrix: list[list[int]], prime: int) -> list[list[int]]:
    """Return the deterministic RREF nullspace basis as column vectors."""

    reduced = [[entry % prime for entry in row] for row in matrix]
    rows = len(reduced)
    columns = len(reduced[0])
    pivots: list[int] = []
    pivot_row = 0
    for column in range(columns):
        pivot = next(
            (
                row
                for row in range(pivot_row, rows)
                if reduced[row][column] % prime
            ),
            None,
        )
        if pivot is None:
            continue
        reduced[pivot_row], reduced[pivot] = reduced[pivot], reduced[pivot_row]
        inverse = pow(reduced[pivot_row][column] % prime, -1, prime)
        reduced[pivot_row] = [
            entry * inverse % prime for entry in reduced[pivot_row]
        ]
        for row in range(rows):
            if row != pivot_row and reduced[row][column] % prime:
                factor = reduced[row][column] % prime
                reduced[row] = [
                    (left - factor * right) % prime
                    for left, right in zip(reduced[row], reduced[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    free = [column for column in range(columns) if column not in pivots]
    basis: list[list[int]] = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row, pivot_column in enumerate(pivots):
            vector[pivot_column] = -reduced[row][free_column] % prime
        basis.append(vector)
    return basis


def inverse_2x2_mod(matrix: list[list[int]], prime: int) -> list[list[int]]:
    assert len(matrix) == 2 and all(len(row) == 2 for row in matrix)
    determinant = (
        matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]
    ) % prime
    assert determinant
    inverse = pow(determinant, -1, prime)
    return [
        [matrix[1][1] * inverse % prime, -matrix[0][1] * inverse % prime],
        [-matrix[1][0] * inverse % prime, matrix[0][0] * inverse % prime],
    ]


def reconstruct_usable_line_sections(
    frame_data: dict, frame: list[list[int]], prime: int, zeta: int
) -> tuple[list[list[list[int]]], int]:
    """Rebuild normalized split-fibre lines from the certified group orbit."""

    serialized_generators = frame_data["target_generators_ST"]
    assert len(serialized_generators) == 2
    generators = {
        name: [
            [reduce_k11(entry, prime, zeta) for entry in row]
            for row in serialized
        ]
        for name, serialized in zip(("S", "T"), serialized_generators)
    }
    identity = identity_matrix(5)
    target_to_a = inverse_matrix_mod(frame, prime)
    seen: set[tuple[int, ...]] = set()
    normalized_sections: set[tuple[int, ...]] = set()
    involutions = 0
    for word in frame_data["projective_words"]:
        matrix = identity
        for letter in word:
            matrix = matrix_multiply(matrix, generators[letter], prime)
        key = tuple(entry for row in matrix for entry in row)
        if key in seen:
            continue
        seen.add(key)
        square = matrix_multiply(matrix, matrix, prime)
        if matrix == identity or square != identity:
            continue
        involutions += 1
        minus_matrix = [
            [
                (matrix[row][column] + int(row == column)) % prime
                for column in range(5)
            ]
            for row in range(5)
        ]
        basis = nullspace_mod(minus_matrix, prime)
        assert len(basis) == 2 and all(len(vector) == 5 for vector in basis)
        basis_matrix = [[basis[column][row] for column in range(2)] for row in range(5)]
        line_a = matrix_multiply(target_to_a, basis_matrix, prime)
        projection = line_a[3:5]
        determinant = (
            projection[0][0] * projection[1][1]
            - projection[0][1] * projection[1][0]
        ) % prime
        if not determinant:
            continue
        normalized = matrix_multiply(line_a, inverse_2x2_mod(projection, prime), prime)
        assert normalized[3:] == [[1, 0], [0, 1]]
        normalized_sections.add(tuple(entry for row in normalized for entry in row))
    assert len(seen) == 660
    assert involutions == 55
    sections = [
        [list(section[2 * row : 2 * row + 2]) for row in range(5)]
        for section in sorted(normalized_sections)
    ]
    return sections, involutions


def msolve_text(poly: sp.Poly, prime: int) -> str:
    terms: list[str] = []
    names = [str(value) for value in poly.gens]
    for exponents, raw in poly.terms():
        coefficient = int(raw) % prime
        if not coefficient:
            continue
        factors = [] if coefficient == 1 else [str(coefficient)]
        for name, exponent in zip(names, exponents):
            if exponent == 1:
                factors.append(name)
            elif exponent:
                factors.append(f"{name}^{exponent}")
        terms.append("*".join(factors) if factors else "1")
    return "+".join(terms) if terms else "0"


def check_quartic_slice(
    cubic: dict[tuple[int, ...], int], prime: int
) -> None:
    """Regenerate the fixed-b modular slice without importing its emitter."""

    parameters, equations, _forms = section_system(cubic, 4, prime)
    boundary = json.loads(
        (HERE / f"modular_section_boundary_p{prime}.json").read_text()
    )
    boundary_point = [int(value) % prime for value in boundary["degree4_boundary_parameters"]]
    assert len(boundary_point) == len(parameters) == 19
    values = dict(zip((str(value) for value in parameters), boundary_point))
    fixed_names = ["A0_0", "A0_1", "b_0", "b_1", "b_2", "b_3"]
    fixed = {sp.Symbol(name): values[name] for name in fixed_names}
    unknown = [parameter for parameter in parameters if str(parameter) not in fixed_names]
    assert len(unknown) == len(equations) == 13
    specialized = [
        sp.Poly(equation.as_expr().subs(fixed), *unknown, modulus=prime)
        for equation in equations
    ]

    lines = [",".join(str(value) for value in unknown), str(prime)]
    lines.extend(
        msolve_text(equation, prime)
        + ("," if index + 1 < len(specialized) else "")
        for index, equation in enumerate(specialized)
    )
    expected_input = "\n".join(lines) + "\n"
    retained_input = (HERE / f"quartic_slice_p{prime}.in").read_text()
    assert retained_input == expected_input

    fixed_coefficients = [int(fixed[sp.Symbol(name)]) % prime for name in fixed_names]
    assert fixed_coefficients[2:] == [
        int(value) % prime for value in boundary["degree4_common_factor"]
    ]
    s, t = sp.symbols("s t")
    fixed_b = sp.Poly(
        sum(
            fixed_coefficients[2 + index] * s ** (3 - index) * t**index
            for index in range(4)
        ),
        s,
        t,
        modulus=prime,
    )
    affine_b = sp.Poly(fixed_b.as_expr().subs(t, 1), s, modulus=prime)
    assert fixed_coefficients[2] and fixed_coefficients[-1]
    assert sp.gcd(affine_b, sp.diff(affine_b, s)).degree() == 0

    unknown_control = [values[str(parameter)] for parameter in unknown]
    control_substitution = dict(zip(unknown, unknown_control))
    assert all(
        int(equation.as_expr().subs(control_substitution)) % prime == 0
        for equation in specialized
    )

    expected_manifest = {
        "schema": "m3-degree4-section-fixed-b-square-slice-v1",
        "scope": "modular discovery only",
        "dimension_status": (
            "unresolved; square equation count does not imply dimension zero"
        ),
        "prime": prime,
        "fixed": {str(key): int(value) for key, value in fixed.items()},
        "unknowns": [str(value) for value in unknown],
        "equation_count": len(specialized),
        "degree_bound": [equation.total_degree() for equation in specialized],
        "contains_control_common_factor_point": True,
        "genuine_section_test": (
            "reconstructed A0,A1,A2,b have gcd one in F_p[s,t]"
        ),
    }
    retained_manifest = json.loads(
        (HERE / f"quartic_slice_p{prime}.json").read_text()
    )
    assert retained_manifest == expected_manifest
    assert retained_manifest["dimension_status"].startswith("unresolved;")
    print(f"P{prime}_QUARTIC_SLICE_EXACT_REPLAY_OK")


def check_genuine_residual_section(
    cubic: dict[tuple[int, ...], int],
    prime: int,
    zeta: int,
    usable: int,
    reconstructed_lines: list[list[list[int]]],
) -> None:
    payload = json.loads(
        (HERE / f"modular_residual_section_p{prime}.json").read_text()
    )
    assert payload["schema"] == "m3-two-prime-gcd-free-residual-section-v1"
    assert payload["scope"] == "split good-reduction component evidence only"
    assert payload["prime"] == prime
    assert payload["zeta11"] == zeta
    assert payload["usable_involution_line_sections"] == usable
    assert payload["pair_indices"] == [0, 1]
    assert len(reconstructed_lines) == usable
    assert payload["line_section_matrices"] == reconstructed_lines[:2]

    parameters, equations, forms = section_system(cubic, 4, prime)
    point = [int(value) % prime for value in payload["residual_parameters"]]
    assert len(point) == len(parameters) == 19
    assert len(equations) == 13
    assert all(evaluate(equation, parameters, point, prime) == 0 for equation in equations)

    substitution = dict(zip(parameters, point))
    s, t = sp.symbols("s t")
    specialized_forms = [
        sp.Poly(form.subs(substitution), s, t, modulus=prime) for form in forms
    ]
    gcd = common_gcd(specialized_forms)
    assert gcd.total_degree() == payload["residual_common_gcd_degree"] == 0
    assert max(form.total_degree() for form in specialized_forms[:3]) == 4
    assert specialized_forms[3].total_degree() == 3
    assert payload["residual_H_degree"] == 4

    jacobian = [
        [
            int(sp.diff(equation.as_expr(), parameter).subs(substitution)) % prime
            for parameter in parameters
        ]
        for equation in equations
    ]
    rank = rank_mod(jacobian, prime)
    assert rank == payload["jacobian_rank_of_13_equations"] == 13
    assert payload["projective_local_dimension_if_smooth"] == 18 - rank == 5

    a = sp.symbols("a0:5")
    phi = phi_expression(cubic, a)
    line_forms: list[list[sp.Poly]] = []
    for matrix in payload["line_section_matrices"]:
        assert len(matrix) == 5 and all(len(row) == 2 for row in matrix)
        reduced = [[int(value) % prime for value in row] for row in matrix]
        assert reduced[3:] == [[1, 0], [0, 1]]
        line = [
            sp.Poly(row[0] * s + row[1] * t, s, t, modulus=prime)
            for row in reduced
        ]
        value = sp.Poly(
            phi.subs({variable: form.as_expr() for variable, form in zip(a, line)}),
            s,
            t,
            modulus=prime,
        )
        assert value.is_zero
        line_forms.append(line)

    left, right = line_forms
    left_substitution = {
        variable: form.as_expr() for variable, form in zip(a, left)
    }
    right_substitution = {
        variable: form.as_expr() for variable, form in zip(a, right)
    }
    alpha = sp.Poly(
        sum(
            sp.diff(phi, variable).subs(left_substitution) * right[index].as_expr()
            for index, variable in enumerate(a)
        ),
        s,
        t,
        modulus=prime,
    )
    beta = sp.Poly(
        sum(
            sp.diff(phi, variable).subs(right_substitution) * left[index].as_expr()
            for index, variable in enumerate(a)
        ),
        s,
        t,
        modulus=prime,
    )
    residual = [
        sp.Poly(
            -beta.as_expr() * left[index].as_expr()
            + alpha.as_expr() * right[index].as_expr(),
            s,
            t,
            modulus=prime,
        )
        for index in range(5)
    ]
    b, remainder = sp.div(
        residual[3], sp.Poly(s, s, t, modulus=prime), domain=sp.GF(prime)
    )
    assert remainder.is_zero
    assert residual[4] == b * sp.Poly(t, s, t, modulus=prime)
    assert sp.Poly(
        residual[3].as_expr() * t - residual[4].as_expr() * s,
        s,
        t,
        modulus=prime,
    ).is_zero
    assert sp.Poly(
        phi.subs(
            {
                variable: residual[index].as_expr()
                for index, variable in enumerate(a)
            }
        ),
        s,
        t,
        modulus=prime,
    ).is_zero

    reconstructed: list[int] = []
    for form in residual[:3]:
        reconstructed.extend(coefficient_vector(form, 4, prime))
    reconstructed.extend(coefficient_vector(b, 3, prime))
    assert_projectively_equal(reconstructed, point, prime)
    print(f"P{prime}_GENUINE_GCDFREE_D4_SPLIT_SECTION_OK")


def check_section_boundary(
    cubic: dict[tuple[int, ...], int],
    prime: int,
    frame_data: dict,
    frame: list[list[int]],
) -> None:
    payload = json.loads((HERE / f"modular_section_boundary_p{prime}.json").read_text())
    assert payload["scope"] == "modular discovery only"
    assert payload["degree4_common_zero_free"] is False

    parameters1, equations1, _ = section_system(cubic, 1, prime)
    line = list(map(int, payload["degree1_section_parameters"]))
    assert len(line) == len(parameters1) == 7
    assert all(evaluate(equation, parameters1, line, prime) == 0 for equation in equations1)

    parameters4, equations4, forms4 = section_system(cubic, 4, prime)
    boundary = list(map(int, payload["degree4_boundary_parameters"]))
    assert len(boundary) == len(parameters4) == 19
    assert len(equations4) == 13
    assert all(
        evaluate(equation, parameters4, boundary, prime) == 0
        for equation in equations4
    )

    substitution = dict(zip(parameters4, boundary))
    s, t = sp.symbols("s t")
    common = sp.Poly(
        sum(
            int(value) * s ** (3 - index) * t**index
            for index, value in enumerate(payload["degree4_common_factor"])
        ),
        s,
        t,
        modulus=prime,
    )
    assert common.total_degree() == 3
    for form in forms4:
        quotient, remainder = sp.div(
            sp.Poly(form.subs(substitution), s, t, modulus=prime),
            common,
            domain=sp.GF(prime),
        )
        assert remainder.is_zero
        assert quotient.total_degree() <= 1

    jacobian = [
        [
            int(sp.diff(equation.as_expr(), parameter).subs(substitution)) % prime
            for parameter in parameters4
        ]
        for equation in equations4
    ]
    rank = rank_mod(jacobian, prime)
    assert rank == payload["degree4_jacobian_rank_at_boundary"] == 7
    print(f"P{prime}_SECTION_LINE_AND_COMMON_FACTOR_BOUNDARY_OK")
    reconstructed_lines, involutions = reconstruct_usable_line_sections(
        frame_data, frame, prime, int(payload["zeta11"])
    )
    assert involutions == payload["involution_line_count"] == 55
    assert len(reconstructed_lines) == payload[
        "involution_lines_disjoint_from_selected_plane"
    ]
    print(f"P{prime}_RESIDUAL_PAIR_FROM_660_WORDS_OK")
    check_genuine_residual_section(
        cubic,
        prime,
        int(payload["zeta11"]),
        int(payload["involution_lines_disjoint_from_selected_plane"]),
        reconstructed_lines,
    )
    check_quartic_slice(cubic, prime)


def main() -> None:
    frame_data = json.loads(FRAME_PATH.read_text())
    model = json.loads(MODEL_PATH.read_text())
    classes = json.loads(CLASSES_PATH.read_text())

    assert model["inputs"][
        "goals_2026-08-01/Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D/exact_frame.json"
    ] == digest(FRAME_PATH)
    assert classes["inputs"]["RESOLUTION.md"] == digest(RESOLUTION)
    assert "has no \\(K_{\\rm Schur}\\)-rational line" in RESOLUTION.read_text()
    assert classes["divisors"]["L"] == "H-D=f^*O_P1(1)"
    assert classes["degree_four_gate"]["projective_parameter_space"] == "P18_K"
    assert classes["degree_four_gate"]["coefficient_equations"] == 13

    reductions_by_prime = {int(item["prime"]): item for item in model["good_reductions"]}
    for prime, zeta in ((23, 2), (67, 9)):
        reduction = reductions_by_prime[prime]
        frame = [
            [reduce_k11(entry, prime, zeta) for entry in row]
            for row in frame_data["frame_at_witness"]
        ]
        assert frame == reduction["frame"]
        invariant = reduce_k11(frame_data["scalar_invariant_at_witness"], prime, zeta)
        determinant = reduce_k11(frame_data["determinant_at_witness"], prime, zeta)
        assert invariant == int(reduction["I8"]) % prime != 0
        assert determinant == int(reduction["frame_determinant"]) % prime != 0
        assert determinant_mod(frame, prime) == determinant

        cubic = cubic_terms(frame, prime)
        fibre = fibre_terms(cubic, prime)
        assert cubic == deserialize(reduction["cubic_terms"], prime)
        assert fibre == deserialize(
            reduction["generic_fibre_terms_a0_a1_a2_u_q"], prime
        )
        check_smoothness(fibre, prime)
        check_section_boundary(cubic, prime, frame_data, frame)
        print(f"P{prime}_EXACT_FRAME_FIBRATION_AND_SMOOTHNESS_OK")

    assert model["generic_fibre"]["index"] == 1
    assert [entry["degree"] for entry in model["generic_fibre"]["zero_cycles"]] == [3, 55]
    assert model["denominator_ledger"]["basis_open"] == "I8*det(Q) != 0"
    assert model["scope"]["rational_section_produced"] is False
    print("M3_MODULAR_RESIDUAL_AND_QUARTIC_SLICE_INDEPENDENT_VERIFY_OK")
    print("M3_FIBRATION_AND_SECTION_BOUNDARY_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
