#!/usr/bin/env python3
"""Independent exact compression of the two maximal-A5 Klein twists.

The script consumes the authoritative exact Weil model and subgroup packet,
but constructs its rational five-dimensional A5 model independently.  It
proves the two restricted Klein cubics are the conjugate members

    S + ((4 +/- sqrt(-11))/9) D

of a rational A5-invariant pencil.  It also verifies the classical
icosahedral invariant-field presentation and compares the canonical model
with each installed Hilbert--90 frame at the packet's good reduction.
"""

from __future__ import annotations

import contextlib
from fractions import Fraction
import importlib.util
import io
import itertools
import json
from pathlib import Path
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
PACKET = PROBLEM / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
CERT = PROBLEM / "certificates"
sys.path.insert(0, str(CERT))

# The authoritative producer imports the exact Weil certificate, which prints
# its own exact self-checks on import.
with contextlib.redirect_stdout(io.StringIO()):
    packet_spec = importlib.util.spec_from_file_location(
        "authoritative_h_subgroup_twists", PACKET / "produce.py"
    )
    assert packet_spec and packet_spec.loader
    installed = importlib.util.module_from_spec(packet_spec)
    packet_spec.loader.exec_module(installed)
    weil = installed.ew

AUTHORITATIVE_TWISTS = json.loads((PACKET / "twists.json").read_text())
assert AUTHORITATIVE_TWISTS["format"] == "H-SUBGROUP-GENERIC-TWISTS-v1"


Q = Fraction
P = installed.P
ZERO5 = (0, 0, 0, 0, 0)


def pcompose(left, right):
    return tuple(left[right[i]] for i in range(5))


PID = tuple(range(5))


def pinverse(perm):
    return tuple(perm.index(i) for i in range(5))


def porder(perm):
    value = PID
    for n in range(1, 61):
        value = pcompose(value, perm)
        if value == PID:
            return n
    raise AssertionError("permutation order exceeded 60")


def pclosure(generators):
    found = {PID}
    queue = [PID]
    while queue:
        left = queue.pop()
        for right in generators:
            value = pcompose(left, right)
            if value not in found:
                found.add(value)
                queue.append(value)
    return frozenset(found)


PA, PB = installed.PA, installed.PB
A5 = pclosure((PA, PB))
assert len(A5) == 60


def sylow_five_subgroups():
    subgroups = set()
    for element in A5:
        if porder(element) == 5:
            subgroups.add(pclosure((element,)))
    return tuple(sorted(subgroups, key=lambda subgroup: tuple(sorted(subgroup))))


SYLOW5 = sylow_five_subgroups()
assert len(SYLOW5) == 6
SYLOW5_INDEX = {subgroup: i for i, subgroup in enumerate(SYLOW5)}


def action_six(group_element):
    inverse = pinverse(group_element)
    return tuple(
        SYLOW5_INDEX[frozenset(
            pcompose(pcompose(group_element, h), inverse) for h in subgroup
        )]
        for subgroup in SYLOW5
    )


def rational_five_matrix(group_element):
    """Augmentation representation of the six-point Sylow-5 action.

    The basis is e_0-e_5,...,e_4-e_5.  Matrices act on column vectors.
    """
    permutation = action_six(group_element)
    matrix = [[0] * 5 for _ in range(5)]
    for column in range(5):
        if permutation[column] < 5:
            matrix[permutation[column]][column] += 1
        if permutation[5] < 5:
            matrix[permutation[5]][column] -= 1
    return matrix


RATIONAL_REP = {g: rational_five_matrix(g) for g in A5}


def integer_matmul(left, right):
    return [
        [sum(left[i][k] * right[k][j] for k in range(5)) for j in range(5)]
        for i in range(5)
    ]


I5 = [[int(i == j) for j in range(5)] for i in range(5)]
assert all(
    integer_matmul(RATIONAL_REP[g], RATIONAL_REP[pinverse(g)]) == I5
    for g in A5
)
assert all(
    integer_matmul(RATIONAL_REP[g], RATIONAL_REP[h])
    == RATIONAL_REP[pcompose(g, h)]
    for g in (PA, PB)
    for h in A5
)


def trace(matrix):
    return sum(matrix[i][i] for i in range(len(matrix)))


character_norm = sum(trace(RATIONAL_REP[g]) ** 2 for g in A5) // 60
assert character_norm == 1


def ppadd(left, right, scale=Q(1)):
    out = dict(left)
    for exponent, coefficient in right.items():
        out[exponent] = out.get(exponent, Q(0)) + scale * coefficient
        if not out[exponent]:
            del out[exponent]
    return out


def ppmul(left, right):
    out = {}
    for left_exp, left_coeff in left.items():
        for right_exp, right_coeff in right.items():
            exponent = tuple(a + b for a, b in zip(left_exp, right_exp))
            out[exponent] = out.get(exponent, Q(0)) + left_coeff * right_coeff
    return {exponent: coefficient for exponent, coefficient in out.items() if coefficient}


def pppow(polynomial, exponent):
    out = {ZERO5: Q(1)}
    for _ in range(exponent):
        out = ppmul(out, polynomial)
    return out


VARIABLES5 = [
    {tuple(int(i == j) for i in range(5)): Q(1)}
    for j in range(5)
]
SIX_VARIABLES = VARIABLES5 + [{}]
for variable in VARIABLES5:
    SIX_VARIABLES[5] = ppadd(SIX_VARIABLES[5], variable, -1)


def triple_orbits():
    unseen = set(itertools.combinations(range(6), 3))
    orbits = []
    while unseen:
        representative = min(unseen)
        orbit = {
            tuple(sorted(action_six(g)[i] for i in representative))
            for g in A5
        }
        orbits.append(tuple(sorted(orbit)))
        unseen -= orbit
    return tuple(orbits)


TRIPLE_ORBITS = triple_orbits()
assert tuple(map(len, TRIPLE_ORBITS)) == (10, 10)


SEGRE = {}
for variable in SIX_VARIABLES:
    SEGRE = ppadd(SEGRE, pppow(variable, 3))


def orbit_cubic(orbit):
    out = {}
    for triple in orbit:
        term = {ZERO5: Q(1)}
        for index in triple:
            term = ppmul(term, SIX_VARIABLES[index])
        out = ppadd(out, term)
    return out


ORBIT_CUBICS = tuple(orbit_cubic(orbit) for orbit in TRIPLE_ORBITS)
ICOSAHEDRAL = ppadd(ORBIT_CUBICS[0], ORBIT_CUBICS[1], -1)
assert ppadd(ppadd(ORBIT_CUBICS[0], ORBIT_CUBICS[1]), SEGRE, -Q(1, 3)) == {}
assert SEGRE and ICOSAHEDRAL


def substitute_rational(polynomial, matrix):
    forms = []
    for row in matrix:
        form = {}
        for index, coefficient in enumerate(row):
            if coefficient:
                form[tuple(int(i == index) for i in range(5))] = Q(coefficient)
        forms.append(form)
    out = {}
    for exponent, coefficient in polynomial.items():
        term = {ZERO5: coefficient}
        for form, power in zip(forms, exponent):
            term = ppmul(term, pppow(form, power))
        out = ppadd(out, term)
    return out


assert all(
    substitute_rational(polynomial, RATIONAL_REP[g]) == polynomial
    for polynomial in (SEGRE, ICOSAHEDRAL)
    for g in (PA, PB)
)


def perm_power(g, exponent):
    value = PID
    for _ in range(exponent):
        value = pcompose(value, g)
    return value


def symmetric_cube_character(g):
    chi = trace(RATIONAL_REP[g])
    chi2 = trace(RATIONAL_REP[perm_power(g, 2)])
    chi3 = trace(RATIONAL_REP[perm_power(g, 3)])
    return (chi ** 3 + 3 * chi * chi2 + 2 * chi3) // 6


cubic_invariant_dimension = sum(symmetric_cube_character(g) for g in A5) // 60
assert cubic_invariant_dimension == 2


def mod_poly_add(left, right, scale=1):
    out = dict(left)
    for exponent, coefficient in right.items():
        out[exponent] = (out.get(exponent, 0) + scale * coefficient) % P
        if not out[exponent]:
            del out[exponent]
    return out


def mod_poly_mul(left, right):
    out = {}
    for left_exp, left_coeff in left.items():
        for right_exp, right_coeff in right.items():
            exponent = tuple(a + b for a, b in zip(left_exp, right_exp))
            out[exponent] = (out.get(exponent, 0) + left_coeff * right_coeff) % P
    return {exponent: coefficient for exponent, coefficient in out.items() if coefficient}


def mod_poly_pow(polynomial, exponent, dimension=3):
    out = {(0,) * dimension: 1}
    for _ in range(exponent):
        out = mod_poly_mul(out, polynomial)
    return out


def reynolds_coordinate_power(degree, source_representation):
    """Reduction of sum_g ((sigma(g)y)_2)^degree."""
    out = {}
    for matrix in source_representation.values():
        linear = {
            tuple(int(i == j) for i in range(3)): coefficient % P
            for j, coefficient in enumerate(matrix[2])
            if coefficient % P
        }
        out = mod_poly_add(out, mod_poly_pow(linear, degree))
    return out


def mod_derivative(polynomial, coordinate):
    out = {}
    for exponent, coefficient in polynomial.items():
        if exponent[coordinate]:
            target = list(exponent)
            target[coordinate] -= 1
            out[tuple(target)] = coefficient * exponent[coordinate] % P
    return out


def mod_evaluate(polynomial, point):
    return sum(
        coefficient
        * __import__("math").prod(value ** power for value, power in zip(point, exponent))
        for exponent, coefficient in polynomial.items()
    ) % P


def determinant_three(matrix):
    return (
        matrix[0][0] * (matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1])
        - matrix[0][1] * (matrix[1][0] * matrix[2][2] - matrix[1][2] * matrix[2][0])
        + matrix[0][2] * (matrix[1][0] * matrix[2][1] - matrix[1][1] * matrix[2][0])
    ) % P


source_mod = installed.SOURCE_A5
F2_MOD, F6_MOD, F10_MOD = (
    reynolds_coordinate_power(degree, source_mod) for degree in (2, 6, 10)
)
jacobian_at_123 = [
    [mod_evaluate(mod_derivative(polynomial, coordinate), (1, 2, 3)) for coordinate in range(3)]
    for polynomial in (F2_MOD, F6_MOD, F10_MOD)
]
F15_JACOBIAN_WITNESS = determinant_three(jacobian_at_123)
assert F15_JACOBIAN_WITNESS == 88


# Exact Molien identity for either faithful icosahedral three-space.
t = sp.symbols("t")
sqrt5 = sp.sqrt(5)
phi = (1 + sqrt5) / 2
phi_conjugate = (1 - sqrt5) / 2
molien = sp.Rational(1, 60) * (
    1 / (1 - t) ** 3
    + 15 / ((1 - t) * (1 + t) ** 2)
    + 20 / (1 - t ** 3)
    + 12 / ((1 - t) * (1 - (phi - 1) * t + t ** 2))
    + 12 / ((1 - t) * (1 - (phi_conjugate - 1) * t + t ** 2))
)
molien_target = (1 + t ** 15) / ((1 - t ** 2) * (1 - t ** 6) * (1 - t ** 10))
assert sp.cancel(molien - molien_target) == 0


def field_matmul(left, right):
    return [
        [
            sum((left[i][k] * right[k][j] for k in range(5)), weil.C(0))
            for j in range(5)
        ]
        for i in range(5)
    ]


def field_matrix_add(left, right):
    return [[left[i][j] + right[i][j] for j in range(5)] for i in range(5)]


def build_intertwiner(subgroup, abstract_map):
    out = [[weil.C(0) for _ in range(5)] for _ in range(5)]
    for h in subgroup:
        canonical_inverse = RATIONAL_REP[pinverse(abstract_map[h])]
        out = field_matrix_add(out, field_matmul(weil.rho[h], canonical_inverse))
    return out


def solve_pencil_coordinates(polynomial):
    exponents = sorted(set(polynomial) | set(SEGRE) | set(ICOSAHEDRAL))
    pair = next(
        (left, right)
        for left, right in itertools.combinations(exponents, 2)
        if SEGRE.get(left, 0) * ICOSAHEDRAL.get(right, 0)
        - SEGRE.get(right, 0) * ICOSAHEDRAL.get(left, 0)
    )
    left, right = pair
    determinant = (
        SEGRE.get(left, 0) * ICOSAHEDRAL.get(right, 0)
        - SEGRE.get(right, 0) * ICOSAHEDRAL.get(left, 0)
    )
    left_value = polynomial.get(left, weil.C(0))
    right_value = polynomial.get(right, weil.C(0))
    lam = (
        left_value * ICOSAHEDRAL.get(right, 0)
        - right_value * ICOSAHEDRAL.get(left, 0)
    ) / determinant
    mu = (
        SEGRE.get(left, 0) * right_value
        - SEGRE.get(right, 0) * left_value
    ) / determinant
    assert all(
        polynomial.get(exponent, weil.C(0))
        == lam * SEGRE.get(exponent, 0) + mu * ICOSAHEDRAL.get(exponent, 0)
        for exponent in exponents
    )
    return lam, mu, pair


def galois(value, exponent):
    out = weil.C(0)
    for power, coefficient in enumerate(value.a):
        out += coefficient * weil.z ** (power * exponent)
    return out


T_PLUS = (4 + weil.g) / 9
T_MINUS = (4 - weil.g) / 9
LAMBDA_MINUS = (13 - weil.g) / 18
LAMBDA_PLUS = (13 + weil.g) / 18
assert weil.g * weil.g == -11
assert galois(weil.g, 2) == -weil.g
assert galois(T_PLUS, 2) == T_MINUS
assert 3 * (1 - LAMBDA_MINUS) == T_PLUS * (1 + LAMBDA_MINUS)
assert 3 * (1 - LAMBDA_PLUS) == T_MINUS * (1 + LAMBDA_PLUS)
assert 9 * LAMBDA_MINUS * LAMBDA_MINUS - 13 * LAMBDA_MINUS + 5 == 0
assert 9 * LAMBDA_PLUS * LAMBDA_PLUS - 13 * LAMBDA_PLUS + 5 == 0


def fraction_mod(value):
    value = Q(value)
    return value.numerator * pow(value.denominator, -1, P) % P


def canonical_mod_polynomial(parameter):
    out = {}
    parameter_mod = installed.reduce_c(parameter)
    for exponent in set(SEGRE) | set(ICOSAHEDRAL):
        coefficient = (
            fraction_mod(SEGRE.get(exponent, 0))
            + parameter_mod * fraction_mod(ICOSAHEDRAL.get(exponent, 0))
        ) % P
        if coefficient:
            out[exponent] = coefficient
    return out


def transform_mod_polynomial(polynomial, matrix):
    forms = []
    for row in matrix:
        form = {
            tuple(int(i == j) for i in range(5)): coefficient % P
            for j, coefficient in enumerate(row)
            if coefficient % P
        }
        forms.append(form)
    out = {}
    for exponent, coefficient in polynomial.items():
        term = {ZERO5: coefficient % P}
        for form, power in zip(forms, exponent):
            term = mod_poly_mul(term, mod_poly_pow(form, power, dimension=5))
        out = mod_poly_add(out, term)
    return out


def scaled_mod(polynomial, scalar):
    return {
        exponent: scalar * coefficient % P
        for exponent, coefficient in polynomial.items()
        if scalar * coefficient % P
    }


def mod_inverse(matrix):
    size = len(matrix)
    work = [
        [value % P for value in row]
        + [int(i == j) for j in range(size)]
        for i, row in enumerate(matrix)
    ]
    for column in range(size):
        pivot = next(row for row in range(column, size) if work[row][column])
        work[column], work[pivot] = work[pivot], work[column]
        inverse = pow(work[column][column], -1, P)
        work[column] = [inverse * value % P for value in work[column]]
        for row in range(size):
            if row == column or not work[row][column]:
                continue
            scalar = work[row][column]
            work[row] = [
                (left - scalar * right) % P
                for left, right in zip(work[row], work[column])
            ]
    assert all(
        work[i][j] == int(i == j)
        for i in range(size)
        for j in range(size)
    )
    return [row[size:] for row in work]


class_data = installed.two_a5_classes()
authoritative_a5_records = {
    record["label"]: record
    for record in AUTHORITATIVE_TWISTS["records"]
    if record["label"].startswith("A5_class_")
}
assert set(authoritative_a5_records) == {"A5_class_1", "A5_class_2"}
class_records = []
intertwiners = []
for class_index, (a, b, subgroup) in enumerate(class_data, 1):
    label = f"A5_class_{class_index}"
    authoritative_record = authoritative_a5_records[label]
    assert frozenset(map(tuple, authoritative_record["subgroup_elements"])) == subgroup
    recorded_map = {
        tuple(row["h"]): tuple(row["permutation"])
        for row in authoritative_record["source_map"]
    }
    abstract_map = installed.iso(a, b, subgroup)
    assert abstract_map == recorded_map
    intertwiner = build_intertwiner(subgroup, abstract_map)
    intertwiners.append(intertwiner)
    for generator in (a, b):
        assert field_matmul(weil.rho[generator], intertwiner) == field_matmul(
            intertwiner, RATIONAL_REP[abstract_map[generator]]
        )
    intertwiner_mod = [
        [installed.reduce_c(entry) for entry in row]
        for row in intertwiner
    ]
    determinant_mod = installed.det(intertwiner_mod)
    assert determinant_mod != 0

    pulled_back = weil.transformed_F(intertwiner)
    lam, mu, coefficient_pair = solve_pencil_coordinates(pulled_back)
    expected_parameter = T_PLUS if class_index == 1 else T_MINUS
    assert mu == lam * expected_parameter
    assert lam != weil.C(0)

    # Concrete equivalence with the installed frame at its good-reduction
    # witness.  If B=J^{-1}A, then F(Az)=lambda(S+tD)(Bz).
    source_point = tuple(authoritative_record["good_reduction"]["source_point"])
    ell = tuple(authoritative_record["ell"])
    subgroup_source = {h: source_mod[abstract_map[h]] for h in subgroup}
    installed_frame, denominators = installed.frame(
        subgroup, subgroup_source, source_point, ell
    )
    assert installed_frame is not None and all(denominators)
    assert installed_frame == authoritative_record["good_reduction"]["frame"]
    assert installed.det(installed_frame) == authoritative_record["good_reduction"]["frame_determinant"]
    assert __import__("math").prod(denominators) % P == authoritative_record["good_reduction"]["denominator_product"]
    canonical_frame = installed.mm(mod_inverse(intertwiner_mod), installed_frame)
    assert installed.mm(intertwiner_mod, canonical_frame) == installed_frame
    recorded_twist_coefficients = installed.twist_coefficients(installed_frame)
    assert authoritative_record["good_reduction"]["specialized_twist_coefficients"] == recorded_twist_coefficients
    original_specialization = {
        tuple(map(int, key.split(","))): value
        for key, value in recorded_twist_coefficients.items()
        if value
    }
    canonical_specialization = transform_mod_polynomial(
        canonical_mod_polynomial(expected_parameter), canonical_frame
    )
    assert original_specialization == scaled_mod(
        canonical_specialization, installed.reduce_c(lam)
    )

    class_records.append({
        "label": label,
        "subgroup_generators": [list(a), list(b)],
        "intertwiner_determinant_mod_89": determinant_mod,
        "pencil_parameter": (
            "(4+sqrt(-11))/9" if class_index == 1 else "(4-sqrt(-11))/9"
        ),
        "orbit_pencil_parameter": (
            "(13-sqrt(-11))/18" if class_index == 1 else "(13+sqrt(-11))/18"
        ),
        "pencil_parameter_cyclotomic_coefficients": [str(value) for value in expected_parameter.a],
        "pencil_scalar_cyclotomic_coefficients": [str(value) for value in lam.a],
        "pencil_coordinate_witness_monomials": [list(exponent) for exponent in coefficient_pair],
        "installed_frame_point_mod_89": list(source_point),
        "installed_frame_seed": "y0/(y0+2*y1+3*y2)",
        "authoritative_frame_determinant_mod_89": installed.det(installed_frame),
        "installed_frame_equivalence_mod_89": True,
    })


# The two subgroup classes are exchanged by the determinant-nonsquare outer
# automorphism of PSL_2(F_11), but are disjoint under inner conjugacy.
def raw_two_by_two_mul(left, right):
    return tuple(
        sum(left[2 * i + k] * right[2 * k + j] for k in range(2)) % 11
        for i in range(2)
        for j in range(2)
    )


def raw_two_by_two_inverse(matrix):
    a, b, c, d = matrix
    inverse_determinant = pow((a * d - b * c) % 11, -1, 11)
    return (
        d * inverse_determinant % 11,
        -b * inverse_determinant % 11,
        -c * inverse_determinant % 11,
        a * inverse_determinant % 11,
    )


outer_matrix = (2, 0, 0, 1)  # determinant 2 is a nonsquare modulo 11
outer_inverse = raw_two_by_two_inverse(outer_matrix)


def outer_automorphism(group_element):
    return weil.fcanon(raw_two_by_two_mul(
        raw_two_by_two_mul(outer_matrix, group_element), outer_inverse
    ))


first_subgroup = class_data[0][2]
second_subgroup = class_data[1][2]
outer_first = frozenset(outer_automorphism(h) for h in first_subgroup)
assert outer_first not in installed.orbit(first_subgroup)
assert outer_first in installed.orbit(second_subgroup)


payload = {
    "format": "klein-h3-two-a5-canonical-model-v1",
    "base_field_reduction": {
        "target_model": "Q-rational augmentation representation on six Sylow-5 subgroups",
        "source_model": "Q(sqrt(5)) faithful icosahedral three-space",
        "cubic_parameter_field": "Q(sqrt(-11))",
        "no_Q_zeta11_needed_after_intertwining": True,
    },
    "rational_representation": {
        "basis": ["e0-e5", "e1-e5", "e2-e5", "e3-e5", "e4-e5"],
        "presentation_generators_on_five_letters": [list(PA), list(PB)],
        "presentation_generators_on_six_sylow_subgroups": [
            list(action_six(PA)), list(action_six(PB))
        ],
        "generator_matrices": [RATIONAL_REP[PA], RATIONAL_REP[PB]],
        "character_norm": character_norm,
    },
    "invariant_cubic_pencil": {
        "coordinates": "X0,...,X5 with sum Xi=0",
        "S": "sum_i Xi^3",
        "D": "sum_{I in O_plus} prod_{i in I}Xi - sum_{I in O_minus} prod_{i in I}Xi",
        "orbit_basis": [
            "O_plus=(S+3D)/6",
            "O_minus=(S-3D)/6",
        ],
        "nullspace_basis_used_by_degree11_solver": [
            "C0=-O_plus",
            "C1=-O_minus",
        ],
        "parameter_conversion": "S+tD is proportional to C0+lambda*C1 with lambda=(3-t)/(3+t)",
        "triple_orbits": [[list(triple) for triple in orbit] for orbit in TRIPLE_ORBITS],
        "dimension": cubic_invariant_dimension,
    },
    "icosahedral_invariant_field": {
        "ring": "C[f2,f6,f10,f15]/(f15^2-R30(f2,f6,f10))",
        "degrees": [2, 6, 10, 15],
        "molien_series": "(1+t^15)/((1-t^2)(1-t^6)(1-t^10))",
        "reynolds_seeds": ["y2^2", "y2^6", "y2^10"],
        "f15_definition": "det(d(f2,f6,f10)/d(y0,y1,y2))",
        "f15_nonzero_witness_mod_89_at_1_2_3": F15_JACOBIAN_WITNESS,
        "projective_transcendence_basis": ["u=f6/f2^3", "v=f10/f2^5"],
        "function_field": "C(u,v)",
    },
    "classes": class_records,
    "class_relation": {
        "inner_conjugacy_orbits_disjoint": True,
        "PGL2_F11_outer_automorphism_swaps_classes": True,
        "outer_matrix": list(outer_matrix),
        "zeta11_to_zeta11_squared_sends_sqrt_minus_11_to_negative": True,
        "galois_swaps_pencil_parameters": True,
        "common_parameter_polynomial": "9*T^2-8*T+3",
        "common_orbit_parameter_polynomial": "9*L^2-13*L+5",
    },
    "equivalence_statement": (
        "For installed A_i(y), put B_i(y)=J_i^{-1}A_i(y). Then exactly "
        "F_Klein(A_i(y)z)=lambda_i*(S+t_i*D)(B_i(y)z); the script proves "
        "the polynomial identity before specialization and rechecks it at p=89."
    ),
}

(HERE / "canonical_model_payload.json").write_text(
    json.dumps(payload, indent=2, sort_keys=True) + "\n"
)

print("PASS rational 5D augmentation representation and two-dimensional cubic pencil")
print("PASS exact Molien identity and C(P2)^A5=C(f6/f2^3,f10/f2^5)")
print("PASS class 1 parameter (4+sqrt(-11))/9")
print("PASS class 2 parameter (4-sqrt(-11))/9")
print("PASS outer automorphism and quadratic Galois conjugation exchange the class data")
print("PASS exact canonical-to-installed-frame equivalence, with independent p=89 specialization")
print("H3_A5_CANONICAL_MODEL_OK")
