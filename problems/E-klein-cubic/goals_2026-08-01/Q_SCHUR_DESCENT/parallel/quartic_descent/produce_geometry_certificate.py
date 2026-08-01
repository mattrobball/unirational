#!/usr/bin/env python3
"""Produce arithmetic gates for the primitive-quartic descent audit."""

from __future__ import annotations

import json
import math
from itertools import product
from pathlib import Path


HERE = Path(__file__).resolve().parent


def convolution(left: list[int], right: list[int]) -> list[int]:
    answer = [0] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            answer[i + j] += a * b
    return answer


def trim_mod(poly: list[int], prime: int) -> list[int]:
    result = [value % prime for value in poly]
    while len(result) > 1 and result[-1] == 0:
        result.pop()
    return result


def remainder_mod(dividend: list[int], divisor: list[int], prime: int) -> list[int]:
    result = trim_mod(dividend, prime)
    divisor = trim_mod(divisor, prime)
    inverse_lead = pow(divisor[-1], -1, prime)
    while len(result) >= len(divisor) and result != [0]:
        shift = len(result) - len(divisor)
        scale = result[-1] * inverse_lead % prime
        for index, value in enumerate(divisor):
            result[index + shift] = (result[index + shift] - scale * value) % prime
        result = trim_mod(result, prime)
    return result


def irreducible_mod(poly: list[int], prime: int) -> bool:
    degree = len(trim_mod(poly, prime)) - 1
    for divisor_degree in range(1, degree // 2 + 1):
        for coefficients in product(range(prime), repeat=divisor_degree):
            divisor = list(coefficients) + [1]
            if remainder_mod(poly, divisor, prime) == [0]:
                return False
    return True


def main() -> None:
    # Repository-certified postulation of the hyperplane-selected 55-point.
    hilbert = [1, 4, 10, 19, 31, 45, 55]
    ambient = [math.comb(degree + 3, 3) for degree in range(7)]
    ideal_dimensions = [ambient[d] - hilbert[d] for d in range(7)]
    cubic_multiples = [0 if d < 3 else math.comb(d, 3) for d in range(7)]
    proper_carriers = [ideal_dimensions[d] - cubic_multiples[d] for d in range(7)]
    assert ideal_dimensions == [0, 0, 0, 1, 4, 11, 29]
    assert proper_carriers == [0, 0, 0, 0, 0, 1, 9]

    # Restriction of cubic monomials in x_0,...,x_3 to
    # [s^3:s^2t:st^2:t^3].  A monomial maps to s^(9-w)t^w.
    monomial_weights = []
    for exponents in product(range(4), repeat=4):
        if sum(exponents) == 3:
            monomial_weights.append(sum(index * exponent for index, exponent in enumerate(exponents)))
    weight_multiplicities = {
        str(weight): monomial_weights.count(weight)
        for weight in range(10)
    }
    assert len(monomial_weights) == 20
    assert set(monomial_weights) == set(range(10))

    # An explicit binary quartic times quintic with no rational root.  The
    # finite-field irreducibility tests are exact and imply Q-irreducibility.
    quartic = [1, -1, 0, 0, 1]       # t^4-t+1
    quintic = [-1, -1, 0, 0, 0, 1]  # t^5-t-1
    nonic = convolution(quartic, quintic)
    assert irreducible_mod(quartic, 2)
    assert irreducible_mod(quintic, 3)
    assert nonic == [-1, 0, 1, 0, -1, 0, -1, 0, 0, 1]

    residual_one_contacts = []
    residual_two_contacts = []
    for degree in range(1, 21):
        for multiplicity in range(1, 3 * degree + 1):
            residual = 3 * degree - 4 * multiplicity
            if residual == 1:
                residual_one_contacts.append([degree, multiplicity])
            if residual == 2:
                residual_two_contacts.append([degree, multiplicity])

    certificate = {
        "format": "Q-SCHUR-PRIMITIVE-QUARTIC-GEOMETRY-GATES-v1",
        "balestrieri_3_8": {
            "hypothesis": "simple field extension of degree 4",
            "simple_means_monogenic_not_a_geometric_simplicity_condition": True,
            "applies_to_characteristic_zero_primitive_quartic": True,
            "general_residual_polynomial_degrees": [2, 5],
            "full_span_twisted_cubic_residual_degree": 5,
            "no_point_branch_intersection_partition": [4, 5],
            "quartic_factor_multiplicity": 1,
            "quintic_factor_irreducible": True,
            "same_lift_reverse_link": [5, 4],
            "canonical_iteration": [4, 5, 4],
        },
        "degree_five_successor": {
            "residual_polynomial_degrees": [1, 4, 7],
            "possible_point_degrees_from_factor_extraction": [1, 2, 4, 7],
            "no_point_branch": [4, 7],
            "strict_degree_descent_forced": False,
        },
        "twisted_cubic_restriction": {
            "source_dimension": 20,
            "target_dimension": 10,
            "rank": len(set(monomial_weights)),
            "weight_multiplicities": weight_multiplicities,
            "surjective": True,
            "example_quartic_coefficients_ascending": quartic,
            "example_quintic_coefficients_ascending": quintic,
            "example_product_coefficients_ascending": nonic,
            "quartic_irreducible_mod": 2,
            "quintic_irreducible_mod": 3,
            "mechanism_scope": (
                "Arbitrary binary quartic-quintic products occur as restrictions of cubic forms; "
                "this does not exhibit a pointless smooth cubic surface."
            ),
        },
        "degree_55_postulation": {
            "input_hilbert_function_degrees_0_to_6": hilbert,
            "ambient_dimensions": ambient,
            "ideal_dimensions": ideal_dimensions,
            "proper_carrier_dimensions_on_cubic_surface": proper_carriers,
            "first_proper_carrier_degree": 5,
            "unique_quintic_carrier": True,
            "quintic_carrier_curve_degree": 15,
            "quintic_carrier_curve_genus": 31,
            "canonical_degree_on_carrier": 60,
            "canonical_sections_vanishing_on_Z55": 0,
        },
        "complete_intersection_gate_for_Z55_plus_quartic": {
            "contained_length": 59,
            "minimum_proper_hypersurface_degrees": [5, 5],
            "minimum_complete_intersection_length": 75,
            "minimum_residual_length": 16,
            "residual_one_requires_product_of_degrees": 20,
            "residual_two_integrality_possible": False,
        },
        "high_contact_successor": {
            "formula": "3*d-4*m",
            "residual_one_pairs_d_le_20": residual_one_contacts,
            "residual_two_pairs_d_le_20": residual_two_contacts,
            "degree_2_conic_case_excluded_by_full_span": True,
            "first_unexcluded_residual_one_pair": [3, 2],
            "first_unexcluded_residual_two_pair": [6, 4],
            "existence_proved": False,
        },
        "boundary": (
            "The exact 4+5 link, its 5-to-4 reverse, postulation gates, and contact arithmetic "
            "do not turn the signed degree-one zero-cycle into an effective rational point."
        ),
    }
    (HERE / "geometry_certificate.json").write_text(json.dumps(certificate, indent=2) + "\n")


if __name__ == "__main__":
    main()
