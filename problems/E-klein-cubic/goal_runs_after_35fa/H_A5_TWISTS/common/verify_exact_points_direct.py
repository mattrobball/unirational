#!/usr/bin/env python3
"""Independent exact verifier for both degree-11 A5 landing points."""

from __future__ import annotations

from fractions import Fraction
import importlib.util
import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(HERE))
import exact_reynolds as exact  # noqa: E402
import exact_eval_singular as evaluations  # noqa: E402


UZERO = (Fraction(0),) * 4
UONE = (Fraction(1), Fraction(0), Fraction(0), Fraction(0))


def uscale(scalar, value):
    scalar = Fraction(scalar)
    return tuple(scalar * item for item in value)


def uneg(value):
    return uscale(-1, value)


S_UPOLY = (Fraction(0), Fraction(1, 8), Fraction(0), Fraction(-1, 32))
R_UPOLY = (Fraction(0), Fraction(7, 8), Fraction(0), Fraction(1, 32))
SR_UPOLY = exact.umul(S_UPOLY, R_UPOLY)
T_PLUS_UPOLY = exact.T_UPOLY
T_MINUS_UPOLY = (
    Fraction(13, 18), Fraction(-7, 144), Fraction(0), Fraction(-1, 576)
)


def field_element(components, radical_sign=1):
    values = [Fraction(item) for item in components]
    values[2] *= radical_sign
    values[3] *= radical_sign
    result = UZERO
    for scalar, basis in zip(values, (UONE, S_UPOLY, R_UPOLY, SR_UPOLY)):
        result = exact.uadd(result, uscale(scalar, basis))
    return result


def alpha_add(left, right):
    return tuple(exact.uadd(a, b) for a, b in zip(left, right))


def alpha_mul(left, right, pcoefficients):
    raw = [UZERO for _ in range(5)]
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            raw[i + j] = exact.uadd(raw[i + j], exact.umul(a, b))
    p2, p1, p0 = pcoefficients
    for degree in (4, 3):
        coefficient = raw[degree]
        if coefficient == UZERO:
            continue
        shift = degree - 3
        raw[shift] = exact.uadd(raw[shift], uneg(exact.umul(coefficient, p0)))
        raw[shift + 1] = exact.uadd(raw[shift + 1], uneg(exact.umul(coefficient, p1)))
        raw[shift + 2] = exact.uadd(raw[shift + 2], uneg(exact.umul(coefficient, p2)))
        raw[degree] = UZERO
    return tuple(raw[:3])


def alpha_pow(value, exponent, pcoefficients):
    out = (UONE, UZERO, UZERO)
    while exponent:
        if exponent & 1:
            out = alpha_mul(out, value, pcoefficients)
        value = alpha_mul(value, value, pcoefficients)
        exponent //= 2
    return out


def load_relations(radical_sign=1):
    payload = json.loads((HERE / "degree11_reconstructed_relations.json").read_text())
    relations = payload["relations"]
    pcoefficients = tuple(
        field_element(relations[name], radical_sign) for name in ("p2", "p1", "p0")
    )
    coordinates = [(UONE, UZERO, UZERO)]
    for coordinate in (1, 2, 3):
        coordinates.append(tuple(
            field_element(relations[f"a{coordinate}_{degree}"], radical_sign)
            for degree in (0, 1, 2)
        ))
    coordinates.append((UZERO, UONE, UZERO))
    return payload, pcoefficients, tuple(coordinates)


def verify_sealed_payloads(relation_payload, covariants):
    """Bind the human-readable point and raw-covariant payloads to replay."""
    raw_payload = json.loads(
        (HERE / "degree11_covariants_raw_exact.json").read_text()
    )
    assert raw_payload["field"] == "Q(s), s^2=5"
    assert raw_payload["format"] == "a5-degree11-raw-reynolds-covariants-v1"
    assert raw_payload["seeds"] == [
        [output, list(exponent)] for output, exponent in exact.SEEDS
    ]
    assert raw_payload["covariants"] == exact.serialize_covariants(covariants)

    common_relations = relation_payload["relations"]
    for class_index, radical_sign in ((1, -1), (2, 1)):
        point_payload = json.loads(
            (ROOT / f"A5_class_{class_index}" / "point.json").read_text()
        )
        assert point_payload["class"] == f"A5_class_{class_index}"
        assert point_payload["exit"] == f"H-A5-CLASS{class_index}-RATIONAL-POINT"
        assert point_payload["scope"]["induced_by_equivariant_map"] is True
        assert point_payload["scope"]["map_degree"] == 11
        sealed_relations = point_payload["closed_point_relations"]
        assert set(sealed_relations) == set(common_relations)
        for name, coefficients in common_relations.items():
            expected = [Fraction(value) for value in coefficients]
            expected[2] *= radical_sign
            expected[3] *= radical_sign
            actual = [Fraction(value) for value in sealed_relations[name]]
            assert actual == expected, (class_index, name)


def verify_six_equations(covariants, pcoefficients, coordinates, t_upoly):
    for point in evaluations.POINTS:
        equation = evaluations.one_evaluation_equation(covariants, point, t_upoly)
        value = (UZERO, UZERO, UZERO)
        for exponent, coefficient in equation.items():
            term = (coefficient, UZERO, UZERO)
            for coordinate, power in zip(coordinates, exponent):
                term = alpha_mul(term, alpha_pow(coordinate, power, pcoefficients), pcoefficients)
            value = alpha_add(value, term)
        assert value == (UZERO, UZERO, UZERO), (point, value)


def reduce_fraction(value, prime):
    return value.numerator * pow(value.denominator, -1, prime) % prime


def q5_mod(value, prime=89, sqrt5=19):
    return (reduce_fraction(value[0], prime) + sqrt5 * reduce_fraction(value[1], prime)) % prime


def rank_columns(columns, prime=89):
    basis = []
    for vector in columns:
        evaluations.modular_rank_add(basis, vector, prime)
    return len(basis)


def verify_covariant_independence(covariants):
    mons = exact.monomials(3, 11)
    columns = []
    for covariant in covariants:
        columns.append([
            q5_mod(component.get(exponent, exact.ZERO))
            for component in covariant
            for exponent in mons
        ])
    assert rank_columns(columns) == 5


def verify_degree11_covariant_dimension():
    degree = 11
    identity_character = (degree + 1) * (degree + 2) // 2
    order_two_character = sum((-1) ** b * (b + 1) for b in range(degree + 1))
    order_three_character = int(degree % 3 == 0)
    # A5 class sizes are 1,15,20,12,12 and the target 5-character is
    # 5,1,-1,0,0.  Thus the order-five source eigenvalues do not enter.
    numerator = 5 * identity_character + 15 * order_two_character - 20 * order_three_character
    assert numerator % 60 == 0
    assert numerator // 60 == 5


def determinant_mod(matrix, prime):
    work = [[entry % prime for entry in row] for row in matrix]
    result = 1
    for column in range(len(work)):
        pivot = next(row for row in range(column, len(work)) if work[row][column])
        if pivot != column:
            work[pivot], work[column] = work[column], work[pivot]
            result = -result
        unit = work[column][column] % prime
        result = result * unit % prime
        inverse = pow(unit, -1, prime)
        for row in range(column + 1, len(work)):
            scalar = work[row][column] * inverse % prime
            work[row] = [
                (a - scalar * b) % prime for a, b in zip(work[row], work[column])
            ]
    return result % prime


def verify_evaluation_injectivity():
    # Molien/invariant-ring coefficient: degree 33 is f15 times the six
    # degree-18 monomials in generators of degrees 2,6,10.
    degree18 = [
        (a, b, c)
        for a in range(10)
        for b in range(4)
        for c in range(2)
        if 2 * a + 6 * b + 10 * c == 18
    ]
    assert len(degree18) == 6
    witnesses = evaluations.evaluation_injectivity_mod89()
    matrix = [
        [witnesses[column][1][row] for column in range(6)]
        for row in range(6)
    ]
    determinant = determinant_mod(matrix, 89)
    assert determinant
    return determinant, witnesses


def rational_cubic(poly):
    return {
        exponent: int(coefficient[0])
        for exponent, coefficient in poly.items()
        if coefficient[0]
    }


def verify_original_klein_comparison():
    spec = importlib.util.spec_from_file_location("canonical_a5_pencil_verify", ROOT / "canonical_a5_pencil.py")
    assert spec and spec.loader
    canonical = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(canonical)
    assert all(canonical.U[g] == exact.EXACT_TARGET[g] for g in canonical.base.PERMS)
    assert canonical.CUBIC_BASIS[0] == {
        exponent: -coefficient for exponent, coefficient in rational_cubic(exact.O0).items()
    }
    assert canonical.CUBIC_BASIS[1] == {
        exponent: -coefficient for exponent, coefficient in rational_cubic(exact.O1).items()
    }
    ratios = []
    for a, b, _subgroup in canonical.base.two_a5_classes():
        matrix = canonical.intertwiner(a, b)
        first, second = canonical.pencil_coordinates(canonical.klein_pullback(matrix))
        ratio = second / first
        assert 9 * ratio * ratio - 13 * ratio + 5 == canonical.K.zero
        ratios.append(ratio)
    assert ratios[0] != ratios[1]
    assert ratios[0] + ratios[1] == canonical.K.convert(Fraction(13, 9))
    assert ratios[0] * ratios[1] == canonical.K.convert(Fraction(5, 9))
    radical = 18 * ratios[1] - 13
    assert radical * radical == canonical.K.convert(-11)
    assert ratios[1] == (13 + radical) / 18
    assert ratios[0] == (13 - radical) / 18
    return ratios


def main():
    payload, pcoefficients_plus, coordinates_plus = load_relations(radical_sign=1)
    _payload_again, pcoefficients_minus, coordinates_minus = load_relations(radical_sign=-1)
    source = exact.exact_source_representation()
    covariants = [exact.reynolds_covariant(*seed, source) for seed in exact.SEEDS]
    for covariant in covariants:
        exact.verify_covariant(covariant, source)
    verify_sealed_payloads(payload, covariants)
    verify_degree11_covariant_dimension()
    verify_covariant_independence(covariants)
    determinant, witnesses = verify_evaluation_injectivity()
    verify_six_equations(covariants, pcoefficients_plus, coordinates_plus, T_PLUS_UPOLY)
    verify_six_equations(covariants, pcoefficients_minus, coordinates_minus, T_MINUS_UPOLY)
    verify_original_klein_comparison()
    print("degree_11_covariant_rank=5")
    print("degree_33_invariant_dimension=6")
    print("evaluation_determinant_mod_89=", determinant)
    print("class_2_all_six_exact_landing_values=0_in_E(alpha_plus)")
    print("class_1_all_six_conjugate_landing_values=0_in_E(alpha_minus)")
    print("alpha_eliminant_degree=3")
    print("installed_class_ratios_are_distinct_roots_of_9t^2-13t+5")
    print("class_1_obtained_by_sqrt_minus11_conjugation=true")
    print("sealed_raw_covariants_and_class_point_payloads_match=true")
    print("H3_EXACT_BOTH_A5_POINTS_VERIFIED")


if __name__ == "__main__":
    main()
