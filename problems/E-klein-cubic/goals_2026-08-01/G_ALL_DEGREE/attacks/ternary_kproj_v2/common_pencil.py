#!/usr/bin/env python3
"""Exact common-pencil ansatz over the certified K_proj/P0 basis.

For a frame triple T and a normalized secondary beta_s, put

    a_i = u_{i,0} + u_{i,1} beta_s  (i in T).

This module expands Phi(a) in the certified 12-element K_proj basis and in
the four independent parameters t3,t6,t8,t11.  Consequently its returned
homogeneous cubic equations cut out the characteristic-zero constant-field
ansatz exactly.  Reduction modulo a good prime is performed only after the
rational equations have been reconstructed.
"""

from __future__ import annotations

from collections import defaultdict
from fractions import Fraction
from functools import lru_cache
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
GOALS = HERE.parents[2]
PROBLEM = HERE.parents[3]
GENERIC_PATH = GOALS / "G_ALL_DEGREE/generic_cubic.json"
TABLE_PATH = PROBLEM / "tmp/kproj_arithmetic/normalized_kproj_table.json"

FRAME_NAMES = ("x", "C", "D", "E", "K")
TRIPLES = tuple(
    (i, j, k)
    for i in range(5)
    for j in range(i + 1, 5)
    for k in range(j + 1, 5)
)
T_ZERO = (0, 0, 0, 0)


def add_poly(left, right):
    answer = defaultdict(Fraction)
    answer.update(left)
    for monomial, coefficient in right.items():
        answer[monomial] += coefficient
    return {m: c for m, c in answer.items() if c}


def scale_poly(scalar, value):
    if not scalar:
        return {}
    return {m: scalar * c for m, c in value.items() if scalar * c}


def multiply_poly(left, right):
    answer = defaultdict(Fraction)
    for a, ca in left.items():
        for b, cb in right.items():
            answer[tuple(x + y for x, y in zip(a, b))] += ca * cb
    return {m: c for m, c in answer.items() if c}


def monomial_poly(exponents, coefficient=Fraction(1)):
    return {tuple(exponents): Fraction(coefficient)} if coefficient else {}


def load_products():
    payload = json.loads(TABLE_PATH.read_text())
    assert payload["parameter_order"] == ["t3", "t6", "t8", "t11"]
    products = {}
    for row in payload["products"]:
        value = [{} for _ in range(12)]
        for entry in row["entries"]:
            polynomial = defaultdict(Fraction)
            for term in entry["coefficient"]:
                polynomial[tuple(term["exponents"])] += Fraction(
                    term["numerator"], term["denominator"]
                )
            value[entry["basis"]] = dict(polynomial)
        products[(row["left"], row["right"])] = tuple(value)
    assert len(products) == 78
    return products


PRODUCTS = load_products()


def field_add(left, right):
    return tuple(add_poly(a, b) for a, b in zip(left, right))


def field_scale_poly(scalar_poly, value):
    return tuple(multiply_poly(scalar_poly, item) for item in value)


def field_multiply(left, right):
    answer = tuple({} for _ in range(12))
    for i, left_coefficient in enumerate(left):
        if not left_coefficient:
            continue
        for j, right_coefficient in enumerate(right):
            if not right_coefficient:
                continue
            scalar = multiply_poly(left_coefficient, right_coefficient)
            product = PRODUCTS[tuple(sorted((i, j)))]
            answer = field_add(answer, field_scale_poly(scalar, product))
    return answer


def field_basis(index):
    value = [{} for _ in range(12)]
    value[index] = {T_ZERO: Fraction(1)}
    return tuple(value)


@lru_cache(None)
def basis_product(indices):
    value = field_basis(0)
    for index in indices:
        value = field_multiply(value, field_basis(index))
    return value


def load_generic_coefficients():
    payload = json.loads(GENERIC_PATH.read_text())
    assert payload["schema"] == "G_GENERIC_KLEIN_CUBIC_V1"
    assert tuple(payload["frame_names"]) == FRAME_NAMES
    coefficients = {}
    for row in payload["coefficients"]:
        value = [{} for _ in range(12)]
        for term in row["normalized_entries"]:
            basis = term["secondary"]
            exponents = tuple(term["projective_exponents"])
            coefficient = Fraction(term["numerator"], term["denominator"])
            value[basis] = add_poly(
                value[basis], monomial_poly(exponents, coefficient)
            )
        coefficients[tuple(row["triple"])] = tuple(value)
    assert len(coefficients) == 35
    return coefficients


GENERIC = load_generic_coefficients()


@lru_cache(None)
def polar_basis_contribution(cubic_triple, basis_indices):
    return field_multiply(GENERIC[cubic_triple], basis_product(basis_indices))


def variable_monomial(position, variable_count):
    exponents = [0] * variable_count
    exponents[position] = 1
    return tuple(exponents)


def coordinate_terms(slot, support):
    """Terms (coefficient-variable monomial, K_proj basis index)."""

    width = len(support)
    return tuple(
        (variable_monomial(width * slot + offset, 3 * width), basis_index)
        for offset, basis_index in enumerate(support)
    )


def ansatz_equations_support(frame_triple, support):
    """Return exact equations indexed by (field basis, t monomial)."""

    assert tuple(sorted(frame_triple)) == tuple(frame_triple)
    assert len(set(frame_triple)) == 3
    assert tuple(sorted(support)) == tuple(support)
    assert len(set(support)) == len(support)
    assert support and all(0 <= index < 12 for index in support)
    active = set(frame_triple)
    slot_of = {frame: slot for slot, frame in enumerate(frame_triple)}
    equations = defaultdict(lambda: defaultdict(Fraction))

    for cubic_triple, cubic_coefficient in GENERIC.items():
        if not set(cubic_triple).issubset(active):
            continue
        choices = [coordinate_terms(slot_of[frame], support) for frame in cubic_triple]
        for first in choices[0]:
            for second in choices[1]:
                for third in choices[2]:
                    variable_exponents = tuple(
                        a + b + c for a, b, c in zip(first[0], second[0], third[0])
                    )
                    contribution = polar_basis_contribution(
                        cubic_triple, (first[1], second[1], third[1])
                    )
                    for basis, coefficient_poly in enumerate(contribution):
                        for t_exponents, coefficient in coefficient_poly.items():
                            equations[(basis, t_exponents)][variable_exponents] += coefficient

    cleaned = []
    for key in sorted(equations):
        polynomial = {m: c for m, c in equations[key].items() if c}
        if polynomial:
            assert {sum(m) for m in polynomial} == {3}
            cleaned.append((key, polynomial))
    return tuple(cleaned)


def ansatz_equations(frame_triple, secondary):
    return ansatz_equations_support(frame_triple, (0, secondary))


def coefficient_mod(value, prime):
    return value.numerator * pow(value.denominator, -1, prime) % prime


def polynomial_mod(polynomial, prime):
    answer = {}
    for monomial, coefficient in polynomial.items():
        reduced = coefficient_mod(coefficient, prime)
        if reduced:
            answer[monomial] = reduced
    return answer


def format_monomial(exponents, variables):
    factors = []
    for variable, exponent in zip(variables, exponents):
        if exponent == 1:
            factors.append(variable)
        elif exponent:
            factors.append(f"{variable}^{exponent}")
    return "*".join(factors) or "1"


def format_polynomial_mod(polynomial, prime, variables):
    terms = []
    for monomial in sorted(polynomial, reverse=True):
        coefficient = polynomial[monomial] % prime
        if not coefficient:
            continue
        body = format_monomial(monomial, variables)
        if coefficient == 1:
            terms.append(body)
        else:
            terms.append(f"{coefficient}*{body}")
    return "+".join(terms) or "0"


def row_basis_mod(polynomials, prime):
    """Sparse echelon basis for the linear span of homogeneous cubics."""

    basis = {}
    for source in polynomials:
        row = {m: c % prime for m, c in source.items() if c % prime}
        while row:
            pivot = max(row)
            if pivot not in basis:
                inverse = pow(row[pivot], -1, prime)
                row = {m: c * inverse % prime for m, c in row.items() if c % prime}
                basis[pivot] = row
                break
            scalar = row[pivot]
            reducer = basis[pivot]
            for monomial, coefficient in reducer.items():
                value = (row.get(monomial, 0) - scalar * coefficient) % prime
                if value:
                    row[monomial] = value
                else:
                    row.pop(monomial, None)
    return tuple(basis[pivot] for pivot in sorted(basis, reverse=True))


def msolve_input(frame_triple, secondary, prime=101):
    return msolve_input_support(frame_triple, (0, secondary), prime)


def msolve_input_support(frame_triple, support, prime=101):
    variables = tuple(f"a{i}" for i in range(3 * len(support)))
    equations = ansatz_equations_support(frame_triple, support)
    reduced = [polynomial_mod(polynomial, prime) for _, polynomial in equations]
    reduced = [polynomial for polynomial in reduced if polynomial]
    # Linear row reduction preserves the generated ideal and makes the solver
    # input independent of redundant coefficient equations.
    rows = row_basis_mod(reduced, prime)
    text = ",".join(variables) + "\n" + str(prime) + "\n"
    text += ",\n".join(format_polynomial_mod(row, prime, variables) for row in rows)
    text += "\n"
    return text, equations, tuple(rows)


def triple_name(frame_triple):
    return "".join(FRAME_NAMES[index] for index in frame_triple)


if __name__ == "__main__":
    equations = ansatz_equations((0, 1, 2), 1)
    print(
        "COMMON_PENCIL_EXPANSION_OK",
        f"triple=xCD secondary=1 exact_equations={len(equations)}",
    )
