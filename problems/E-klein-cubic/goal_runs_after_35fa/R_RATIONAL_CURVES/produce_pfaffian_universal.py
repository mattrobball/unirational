#!/opt/homebrew/bin/python3
"""Produce exact universal elliptic-quintic equations on the Klein cubic.

The pinned Pfaffian alignment supplies a five-space B5 inside wedge^2(V6*).
For its skew matrix M(x), the Pfaffian adjugate A(x) has rank two on the
smooth Pfaffian cubic.  A covector lambda cuts the section-zero curve by the
six explicit quadratic equations A(x) lambda = 0.
"""

from __future__ import annotations

import json
from pathlib import Path
import runpy


HERE = Path(__file__).resolve().parent
PROBLEM_ROOT = HERE.parents[1]
CORE_PATH = PROBLEM_ROOT / "tmp/pfaffian_representation_alignment/core.py"
CORE = runpy.run_path(str(CORE_PATH))
K11 = CORE["K11"]
PAIR_INDEX = CORE["PAIR_INDEX"]
ZERO = K11.zero
ONE = K11.one
N_X = 5
N_ALL = 11


def poly_add(left, right):
    result = dict(left)
    for monomial, coefficient in right.items():
        result[monomial] = result.get(monomial, ZERO) + coefficient
        if result[monomial] == ZERO:
            del result[monomial]
    return result


def poly_neg(poly):
    return {monomial: -coefficient for monomial, coefficient in poly.items()}


def poly_sub(left, right):
    return poly_add(left, poly_neg(right))


def poly_mul(left, right):
    result = {}
    for monomial_left, coefficient_left in left.items():
        for monomial_right, coefficient_right in right.items():
            monomial = tuple(a + b for a, b in zip(monomial_left, monomial_right))
            result[monomial] = result.get(monomial, ZERO) + coefficient_left * coefficient_right
            if result[monomial] == ZERO:
                del result[monomial]
    return result


def poly_scale(poly, scalar):
    if scalar == ZERO:
        return {}
    return {monomial: scalar * coefficient for monomial, coefficient in poly.items()}


def constant(value, variables=N_X):
    return {(0,) * variables: K11(value)} if value else {}


def pfaffian(matrix, indices):
    if not indices:
        return constant(1)
    first = indices[0]
    result = {}
    for position in range(1, len(indices)):
        second = indices[position]
        remaining = indices[1:position] + indices[position + 1 :]
        term = poly_mul(matrix[first][second], pfaffian(matrix, remaining))
        result = poly_add(result, term if position % 2 else poly_neg(term))
    return result


def pfaffian_adjugate(matrix):
    size = len(matrix)
    adjugate = [[{} for _ in range(size)] for _ in range(size)]
    full = tuple(range(size))
    for row in range(size):
        for column in range(row + 1, size):
            remaining = tuple(i for i in full if i not in (row, column))
            cofactor = pfaffian(matrix, remaining)
            if (row + column) % 2:
                cofactor = poly_neg(cofactor)
            adjugate[row][column] = cofactor
            adjugate[column][row] = poly_neg(cofactor)
    return adjugate


def matrix_product(left, right):
    return [
        [
            sum_polys(poly_mul(left[i][k], right[k][j]) for k in range(len(right)))
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def sum_polys(polys):
    result = {}
    for poly in polys:
        result = poly_add(result, poly)
    return result


def qzeta_coefficients(element):
    return CORE["coefficients"](element, 10)


def serialize_poly(poly):
    return [
        {
            "exponents": list(monomial),
            "coefficient_qzeta11": qzeta_coefficients(coefficient),
        }
        for monomial, coefficient in sorted(poly.items())
    ]


def lift_x_poly(poly):
    return {monomial + (0,) * 6: coefficient for monomial, coefficient in poly.items()}


def lambda_monomial(index):
    exponents = [0] * N_ALL
    exponents[N_X + index] = 1
    return {tuple(exponents): ONE}


def reduce_coefficient(element, prime=23, zeta=2):
    total = 0
    for exponent, (numerator, denominator) in enumerate(qzeta_coefficients(element)):
        total += numerator * pow(denominator, -1, prime) * pow(zeta, exponent, prime)
    return total % prime


def serialize_mod23_sample(equations, lambda_values):
    specialized = []
    for equation in equations:
        result = {}
        for monomial, coefficient in equation.items():
            scalar = reduce_coefficient(coefficient)
            x_monomial = monomial[:N_X]
            for index, exponent in enumerate(monomial[N_X:]):
                scalar = scalar * pow(lambda_values[index], exponent, 23) % 23
            result[x_monomial] = (result.get(x_monomial, 0) + scalar) % 23
            if result[x_monomial] == 0:
                del result[x_monomial]
        specialized.append(
            [
                {"exponents": list(monomial), "coefficient": coefficient}
                for monomial, coefficient in sorted(result.items())
            ]
        )
    return specialized


def main() -> None:
    embedding, hom_dimension = CORE["normalized_intertwiner"]()
    assert hom_dimension == 1
    rows = embedding.to_list()

    zero_monomial = (0,) * N_X
    matrix = [[{} for _ in range(6)] for _ in range(6)]
    for pair_row, (left, right) in enumerate(PAIR_INDEX):
        linear_form = {}
        for variable in range(N_X):
            exponent = [0] * N_X
            exponent[variable] = 1
            coefficient = rows[pair_row][variable]
            if coefficient != ZERO:
                linear_form[tuple(exponent)] = coefficient
        matrix[left][right] = linear_form
        matrix[right][left] = poly_neg(linear_form)

    pf = pfaffian(matrix, tuple(range(6)))
    klein_monomials = []
    for index in range(N_X):
        exponent = [0] * N_X
        exponent[index] = 2
        exponent[(index + 1) % N_X] = 1
        klein_monomials.append(tuple(exponent))
    assert set(pf) == set(klein_monomials), sorted(pf)
    scalar = pf[klein_monomials[0]]
    assert scalar != ZERO
    assert all(pf[monomial] == scalar for monomial in klein_monomials)

    adjugate = pfaffian_adjugate(matrix)
    product = matrix_product(matrix, adjugate)
    for row in range(6):
        for column in range(6):
            expected = pf if row == column else {}
            assert product[row][column] == expected, (row, column)

    universal_equations = []
    for row in range(6):
        equation = {}
        for column in range(6):
            lifted = lift_x_poly(adjugate[row][column])
            equation = poly_add(equation, poly_mul(lifted, lambda_monomial(column)))
        universal_equations.append(equation)

    # This coordinate section has a smooth geometrically integral good
    # reduction at (p,zeta_11)=(23,2), independently checked by Singular.
    lambda_values = [1, 0, 0, 0, 0, 0]
    payload = {
        "schema": "klein-pfaffian-elliptic-quintic-universal-v1",
        "coefficient_field": "Q(zeta_11), Phi_11(zeta_11)=0",
        "x_variables": [f"x{i + 1}" for i in range(5)],
        "section_variables": [f"lambda{i + 1}" for i in range(6)],
        "matrix_convention": "upper-triangular pairs (12,13,14,15,16,23,...,56)",
        "pfaffian_scalar_qzeta11": qzeta_coefficients(scalar),
        "pfaffian_identity": "Pf(M(x)) = scalar * sum_i x_i^2*x_(i+1)",
        "adjugate_identity": "M(x)*A(x) = Pf(M(x))*I_6",
        "universal_curve_equations": "A(x)*lambda = 0",
        "pfaffian_matrix_upper": [
            {
                "pair": [left + 1, right + 1],
                "linear_form": serialize_poly(matrix[left][right]),
            }
            for left, right in PAIR_INDEX
        ],
        "pfaffian_adjugate_upper": [
            {
                "pair": [left + 1, right + 1],
                "quadratic_form": serialize_poly(adjugate[left][right]),
            }
            for left, right in PAIR_INDEX
        ],
        "equations_bihomogeneous_x2_lambda1": [serialize_poly(eq) for eq in universal_equations],
        "sample_mod_23": {
            "zeta_11": 2,
            "lambda": lambda_values,
            "equations": serialize_mod23_sample(universal_equations, lambda_values),
            "expected": {
                "projective_dimension": 1,
                "degree": 5,
                "hilbert_numerator": [1, 0, -5, 5, 0, -1, 0],
                "singular_affine_cone_dimension": 0,
                "minimal_associated_primes": 1,
                "tangent_dimension_on_cubic": 10,
                "normal_h1": 0,
            },
        },
        "geometric_interpretation": {
            "bundle": "E_0(1)=K^* on the Klein Pfaffian cubic",
            "section_space": "H^0(E_0(1))=V_6^*",
            "curve": "zero locus of the section lambda restricted to K",
            "expected_hilbert_polynomial": "5*t",
            "expected_degree": 5,
            "expected_arithmetic_genus": 1,
        },
        "terminal_marker": "R2_PFAFFIAN_UNIVERSAL_EQUATIONS_CERTIFIED",
    }
    output = HERE / "pfaffian_quintic_universal.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print("pfaffian_scalar_qzeta11", qzeta_coefficients(scalar))
    print("universal_equations", len(universal_equations))
    print("wrote", output.name)
    print(payload["terminal_marker"])


if __name__ == "__main__":
    main()
