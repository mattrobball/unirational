#!/usr/bin/env python3
"""Exact good-reduction exclusion of low-degree A5 landing covariants.

For each nonconjugate maximal A5 class, compute the complete spaces
Hom_H(Sym^d(V3), W5), d <= 4, over F_89.  In degree 4 the space is a
projective line; geometric emptiness of its landing equations is certified
by a unit gcd in F_89[t].
"""

from __future__ import annotations

from functools import reduce
import json
from pathlib import Path

import sympy as sp

import build_a5_twists as base


P = base.PRIME
HERE = Path(__file__).resolve().parent


def monomials(degree):
    return tuple(
        (a, b, degree - a - b)
        for a in range(degree + 1)
        for b in range(degree - a + 1)
    )


def padd(left, right):
    out = dict(left)
    for exponent, coefficient in right.items():
        out[exponent] = (out.get(exponent, 0) + coefficient) % P
        if not out[exponent]:
            del out[exponent]
    return out


def pmul(left, right):
    out = {}
    for a, ca in left.items():
        for b, cb in right.items():
            exponent = tuple(x + y for x, y in zip(a, b))
            out[exponent] = (out.get(exponent, 0) + ca * cb) % P
    return {e: c for e, c in out.items() if c}


def pscale(scalar, polynomial):
    return {e: scalar * c % P for e, c in polynomial.items() if scalar * c % P}


def ppow(polynomial, exponent):
    out = {(0, 0, 0): 1}
    for _ in range(exponent):
        out = pmul(out, polynomial)
    return out


def monomial_transform(matrix, degree):
    basis = monomials(degree)
    index = {exponent: i for i, exponent in enumerate(basis)}
    forms = []
    for row in matrix:
        form = {}
        for variable, coefficient in enumerate(row):
            if coefficient % P:
                exponent = tuple(int(i == variable) for i in range(3))
                form[exponent] = coefficient % P
        forms.append(form)
    transform = [[0] * len(basis) for _ in basis]
    for source_index, exponent in enumerate(basis):
        polynomial = {(0, 0, 0): 1}
        for form, power in zip(forms, exponent):
            polynomial = pmul(polynomial, ppow(form, power))
        for output_exponent, coefficient in polynomial.items():
            transform[source_index][index[output_exponent]] = coefficient
    return transform


def nullspace_mod(matrix):
    if not matrix:
        return []
    work = [[entry % P for entry in row] for row in matrix]
    rows, columns = len(work), len(work[0])
    pivots = []
    pivot_row = 0
    for column in range(columns):
        pivot = next(
            (row for row in range(pivot_row, rows) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, P)
        work[pivot_row] = [inverse * x % P for x in work[pivot_row]]
        for row in range(rows):
            if row == pivot_row:
                continue
            scale = work[row][column]
            if scale:
                work[row] = [
                    (x - scale * y) % P
                    for x, y in zip(work[row], work[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == rows:
            break
    free = [column for column in range(columns) if column not in pivots]
    basis = []
    for free_column in free:
        vector = [0] * columns
        vector[free_column] = 1
        for row, pivot in reversed(list(enumerate(pivots))):
            vector[pivot] = -sum(
                work[row][column] * vector[column]
                for column in free
            ) % P
        basis.append(vector)
    assert all(
        sum(a * b for a, b in zip(row, vector)) % P == 0
        for row in matrix
        for vector in basis
    )
    return basis


def covariant_basis(degree, generators, abstract_map, source_rep):
    mons = monomials(degree)
    count = len(mons)
    equations = []
    for generator in generators:
        sigma = source_rep[abstract_map[generator]]
        rho = base.rho_mod(generator)
        transform = monomial_transform(sigma, degree)
        for output in range(5):
            for monomial in range(count):
                row = [0] * (5 * count)
                for source_monomial in range(count):
                    row[output * count + source_monomial] = (
                        row[output * count + source_monomial]
                        + transform[source_monomial][monomial]
                    ) % P
                for source_output in range(5):
                    row[source_output * count + monomial] = (
                        row[source_output * count + monomial]
                        - rho[output][source_output]
                    ) % P
                equations.append(row)
    vectors = nullspace_mod(equations)
    return [
        [vector[row * count:(row + 1) * count] for row in range(5)]
        for vector in vectors
    ]


def output_polynomials(covariant, degree):
    mons = monomials(degree)
    return [
        {exponent: coefficient for exponent, coefficient in zip(mons, row) if coefficient}
        for row in covariant
    ]


def klein_composition(covariant, degree):
    outputs = output_polynomials(covariant, degree)
    result = {}
    for i in range(5):
        result = padd(result, pmul(pmul(outputs[i], outputs[i]), outputs[(i + 1) % 5]))
    return result


def combine(first, second, scalar):
    return [
        [(a + scalar * b) % P for a, b in zip(row_a, row_b)]
        for row_a, row_b in zip(first, second)
    ]


def interpolate_cubic(values):
    # Values at t=0,1,2,3; invert the fixed Vandermonde matrix modulo P.
    vandermonde = [[pow(t, power, P) for power in range(4)] for t in range(4)]
    inverse = base.minverse(vandermonde)
    return [sum(inverse[i][j] * values[j] for j in range(4)) % P for i in range(4)]


def degree_four_landing_gcd(first, second):
    compositions = [klein_composition(combine(first, second, t), 4) for t in range(4)]
    exponents = sorted(set().union(*(composition.keys() for composition in compositions)))
    t = sp.symbols("t")
    coefficient_polynomials = []
    serialized = []
    for exponent in exponents:
        values = [composition.get(exponent, 0) for composition in compositions]
        coefficients = interpolate_cubic(values)
        polynomial = sp.Poly(
            sum(value * t**power for power, value in enumerate(coefficients)),
            t,
            modulus=P,
        )
        if not polynomial.is_zero:
            coefficient_polynomials.append(polynomial)
            serialized.append({
                "source_exponent": list(exponent),
                "parameter_coefficients_low_to_high": coefficients,
            })
    gcd = reduce(sp.gcd, coefficient_polynomials).monic()
    infinity_nonzero = bool(klein_composition(second, 4))
    return gcd, infinity_nonzero, serialized


def class_record(label, a, b, subgroup):
    abstract_map = base.abstract_isomorphism(a, b)
    source_rep = base.source_representation()
    dimensions = {}
    spaces = {}
    for degree in range(5):
        spaces[degree] = covariant_basis(degree, (a, b), abstract_map, source_rep)
        dimensions[str(degree)] = len(spaces[degree])
    assert dimensions == {"0": 0, "1": 0, "2": 1, "3": 0, "4": 2}
    degree_two_lands = not bool(klein_composition(spaces[2][0], 2))
    gcd, infinity_nonzero, polynomials = degree_four_landing_gcd(*spaces[4])
    assert not degree_two_lands
    assert gcd.degree() == 0 and infinity_nonzero
    return {
        "label": label,
        "covariant_dimensions_degrees_0_to_4": dimensions,
        "degree_2_lands_on_X": degree_two_lands,
        "degree_4_parameter_space": "P1",
        "degree_4_affine_landing_gcd_mod_89": [int(c) % P for c in gcd.all_coeffs()],
        "degree_4_point_at_infinity_lands": not infinity_nonzero,
        "degree_4_geometric_landing_scheme_empty_mod_89": True,
        "degree_4_coefficient_polynomials": polynomials,
    }


def main():
    records = [
        class_record(f"A5_class_{i}", *data)
        for i, data in enumerate(base.two_a5_classes(), 1)
    ]
    payload = {
        "format": "klein-a5-low-degree-landing-v1",
        "prime": P,
        "scope": "complete homogeneous A5-covariants from the faithful 3-space through degree 4",
        "characteristic_zero_transfer": (
            "Maschke exactness at p=89 identifies the reduced full covariant spaces; "
            "properness of the projective parameter scheme makes geometric emptiness "
            "of the good fibre imply emptiness in characteristic zero"
        ),
        "records": records,
    }
    output = HERE / "a5_low_degree_search.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {output}")
    for record in records:
        print(record["label"], record["covariant_dimensions_degrees_0_to_4"])
    print("A5_LOW_DEGREE_SEARCH_OK")


if __name__ == "__main__":
    main()
