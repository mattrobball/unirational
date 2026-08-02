#!/usr/bin/env python3
"""Independent read-only verifier for the A5Q quartic-rescue packet.

The verifier never imports ``discover_modular_index11.py`` and never accepts
its boolean gates.  It rebuilds the group actions from the authoritative exact
Q(zeta_11) representation core, reduces the exact A5 landing inputs itself,
and compares only recomputed raw matrices, coordinates, minors, and ranks with
the modular result.  Its default mode also replays the upstream exact
characteristic-zero A5 landing verifier.

No file is written in either the default or ``--skip-upstream-exact`` mode.
"""

from __future__ import annotations

import argparse
from collections import deque
from fractions import Fraction
from hashlib import sha256
from itertools import combinations, permutations
import json
from pathlib import Path
import runpy
import subprocess
import sys
import time


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
CORE_PATH = (
    PROBLEM
    / "goal_runs_after_35fa"
    / "Q_SCHUR_INDEX_ONE"
    / "exact_schur_frame"
    / "exact_representation_core.py"
)
TWISTS_PATH = (
    PROBLEM
    / "goals_2026-08-01"
    / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
    / "twists.json"
)
POINT_ROOT = PROBLEM / "goal_runs_after_35fa" / "H_A5_TWISTS"
COVARIANT_PATH = POINT_ROOT / "common" / "degree11_covariants_raw_exact.json"
POINT_PATHS = {
    1: POINT_ROOT / "A5_class_1" / "point.json",
    2: POINT_ROOT / "A5_class_2" / "point.json",
}
UPSTREAM_EXACT_VERIFY = POINT_ROOT / "common" / "verify_exact_points_direct.py"
FIELD_PATHS = {1: HERE / "FIELD_L1.json", 2: HERE / "FIELD_L2.json"}
MODULAR_RESULT_PATH = HERE / "modular_index11_discovery.json"
MANIFEST_PATH = HERE / "INPUT_MANIFEST.json"


def load_json(path):
    return json.loads(path.read_text())


CORE = runpy.run_path(str(CORE_PATH))
TWISTS = load_json(TWISTS_PATH)
RAW_COVARIANTS = load_json(COVARIANT_PATH)
POINT_PAYLOADS = {index: load_json(path) for index, path in POINT_PATHS.items()}
FIELD_PAYLOADS = {index: load_json(path) for index, path in FIELD_PATHS.items()}
MODULAR_RESULT = load_json(MODULAR_RESULT_PATH)
INPUT_MANIFEST = load_json(MANIFEST_PATH)


def verify_input_manifest():
    assert INPUT_MANIFEST["format"] == "a5q-input-manifest-v1"
    assert (
        INPUT_MANIFEST["pinned_state"]
        == "bd610a032bb9561d2daeb91a2cb60c48c082ca2f"
    )
    entries = INPUT_MANIFEST["inputs"]
    assert len(entries) == 14
    for name, record in entries.items():
        path = PROBLEM / record["path_relative_to_problem"]
        assert path.is_file(), (name, path)
        assert path.stat().st_size == record["bytes"], name
        assert sha256(path.read_bytes()).hexdigest() == record["sha256"], name
    core_record = entries["schur_representation_core"]
    assert CORE_PATH == PROBLEM / core_record["path_relative_to_problem"]
    print(f"PASS input manifest hashes files={len(entries)}")


# ---------------------------------------------------------------------------
# Finite-field linear algebra, implemented separately from the producer.


def identity(size):
    return [[int(i == j) for j in range(size)] for i in range(size)]


def mm(left, right, p):
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right))) % p
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def mv(matrix, vector, p):
    return [sum(a * b for a, b in zip(row, vector)) % p for row in matrix]


def ma(left, right, p):
    return [
        [(a + b) % p for a, b in zip(left_row, right_row)]
        for left_row, right_row in zip(left, right)
    ]


def ms(scalar, matrix, p):
    return [[scalar * value % p for value in row] for row in matrix]


def mpow(matrix, exponent, p):
    out = identity(len(matrix))
    while exponent:
        if exponent & 1:
            out = mm(out, matrix, p)
        matrix = mm(matrix, matrix, p)
        exponent //= 2
    return out


def mword(word, generators, size, p):
    out = identity(size)
    for letter in word:
        out = mm(out, generators[letter], p)
    return out


def inverse(matrix, p):
    size = len(matrix)
    work = [
        [value % p for value in row] + [int(i == j) for j in range(size)]
        for i, row in enumerate(matrix)
    ]
    for column in range(size):
        pivot = next(row for row in range(column, size) if work[row][column])
        work[column], work[pivot] = work[pivot], work[column]
        scale = pow(work[column][column], -1, p)
        work[column] = [scale * value % p for value in work[column]]
        for row in range(size):
            if row == column or not work[row][column]:
                continue
            scalar = work[row][column]
            work[row] = [
                (a - scalar * b) % p
                for a, b in zip(work[row], work[column])
            ]
    assert all(work[i][j] == int(i == j) for i in range(size) for j in range(size))
    return [row[size:] for row in work]


def det(matrix, p):
    assert matrix and len(matrix) == len(matrix[0])
    work = [[value % p for value in row] for row in matrix]
    result = 1
    for column in range(len(work)):
        pivot = next(
            (row for row in range(column, len(work)) if work[row][column]), None
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            result = -result
        value = work[column][column]
        result = result * value % p
        scale = pow(value, -1, p)
        for row in range(column + 1, len(work)):
            scalar = work[row][column] * scale % p
            if scalar:
                work[row] = [
                    (a - scalar * b) % p
                    for a, b in zip(work[row], work[column])
                ]
    return result % p


def row_reduce(matrix, p):
    work = [[value % p for value in row] for row in matrix]
    pivots = []
    row_index = 0
    for column in range(len(work[0]) if work else 0):
        pivot = next(
            (row for row in range(row_index, len(work)) if work[row][column]), None
        )
        if pivot is None:
            continue
        work[row_index], work[pivot] = work[pivot], work[row_index]
        scale = pow(work[row_index][column], -1, p)
        work[row_index] = [scale * value % p for value in work[row_index]]
        for row in range(len(work)):
            if row == row_index or not work[row][column]:
                continue
            scalar = work[row][column]
            work[row] = [
                (a - scalar * b) % p
                for a, b in zip(work[row], work[row_index])
            ]
        pivots.append(column)
        row_index += 1
        if row_index == len(work):
            break
    return work, pivots


def matrix_rank(matrix, p):
    return len(row_reduce(matrix, p)[1])


def independent_row_indices(matrix, requested_rank, p):
    chosen = []
    current_rank = 0
    for index in range(len(matrix)):
        trial = chosen + [index]
        trial_rank = matrix_rank([matrix[row] for row in trial], p)
        if trial_rank > current_rank:
            chosen.append(index)
            current_rank = trial_rank
        if current_rank == requested_rank:
            return chosen
    raise AssertionError("not enough independent rows")


def projectively_equal(left, right, p):
    assert any(left) and any(right)
    return all(
        (left[i] * right[j] - left[j] * right[i]) % p == 0
        for i, j in combinations(range(len(left)), 2)
    )


def first_nonzero_projective_minor(left, right, p):
    for i, j in combinations(range(len(left)), 2):
        value = (left[i] * right[j] - left[j] * right[i]) % p
        if value:
            return [i, j, value]
    return None


# ---------------------------------------------------------------------------
# Abstract group and A5 models.


FONE = CORE["FONE"]
FS = CORE["FS"]
FT = CORE["FT"]
fmul = CORE["fmul"]
fcanon = CORE["fcanon"]
finv = CORE["finv"]
GROUP_UNSORTED, WORDS = CORE["abstract_group"]()
GROUP = tuple(sorted(GROUP_UNSORTED))
assert len(GROUP) == 660


def gmul(left, right):
    return fcanon(fmul(left, right))


def gorder(element):
    value = FONE
    for exponent in range(1, 100):
        value = gmul(value, element)
        if value == FONE:
            return exponent
    raise AssertionError("order bound")


ORDERS = {element: gorder(element) for element in GROUP}


def closure(generators):
    found = {FONE}
    queue = deque([FONE])
    while queue:
        current = queue.popleft()
        for generator in generators:
            candidate = gmul(current, generator)
            if candidate not in found:
                found.add(candidate)
                queue.append(candidate)
    return frozenset(found)


def conjugate(g, h):
    return gmul(gmul(g, h), finv(g))


def subgroup_orbit(subgroup):
    return {frozenset(conjugate(g, h) for h in subgroup) for g in GROUP}


def reconstruct_a5_classes():
    first = None
    first_orbit = None
    for a in (g for g in GROUP if ORDERS[g] == 2):
        for b in (g for g in GROUP if ORDERS[g] == 3):
            if ORDERS[gmul(a, b)] != 5:
                continue
            subgroup = closure((a, b))
            if len(subgroup) != 60:
                continue
            if first is None:
                first = (a, b, subgroup)
                first_orbit = subgroup_orbit(subgroup)
            elif subgroup not in first_orbit:
                second = (a, b, subgroup)
                second_orbit = subgroup_orbit(subgroup)
                assert len(first_orbit) == len(second_orbit) == 11
                assert first_orbit.isdisjoint(second_orbit)
                return first, second
    raise AssertionError("two A5 classes not found")


A5_CLASSES = reconstruct_a5_classes()


def left_coset_representatives(subgroup):
    covered = set()
    representatives = []
    for representative in GROUP:
        if representative in covered:
            continue
        coset = {gmul(h, representative) for h in subgroup}
        assert len(coset) == 60
        representatives.append(representative)
        covered.update(coset)
    assert len(representatives) == 11 and len(covered) == 660
    return tuple(representatives)


PID = tuple(range(5))


def pc(left, right):
    return tuple(left[right[i]] for i in range(5))


def pi(perm):
    return tuple(perm.index(i) for i in range(len(perm)))


def permutation_order(perm):
    value = PID
    for exponent in range(1, 61):
        value = pc(value, perm)
        if value == PID:
            return exponent
    raise AssertionError("permutation order bound")


def is_even(perm):
    return sum(
        perm[i] > perm[j]
        for i in range(len(perm))
        for j in range(i + 1, len(perm))
    ) % 2 == 0


A5_PERMS = tuple(perm for perm in permutations(range(5)) if is_even(perm))
PA, PB = next(
    (a, b)
    for a in A5_PERMS
    if permutation_order(a) == 2
    for b in A5_PERMS
    if permutation_order(b) == 3 and permutation_order(pc(a, b)) == 5
)


def subgroup_isomorphism(a, b, subgroup):
    mapping = {FONE: PID}
    queue = deque([FONE])
    while queue:
        current = queue.popleft()
        for generator, image in ((a, PA), (b, PB)):
            candidate = gmul(current, generator)
            candidate_image = pc(mapping[current], image)
            if candidate in mapping:
                assert mapping[candidate] == candidate_image
            else:
                mapping[candidate] = candidate_image
                queue.append(candidate)
    assert set(mapping) == set(subgroup) and set(mapping.values()) == set(A5_PERMS)
    return mapping


def perm_power(perm, exponent):
    value = PID
    for _ in range(exponent):
        value = pc(value, perm)
    return value


def augmentation_representation():
    sylow = set()
    for element in A5_PERMS:
        if permutation_order(element) == 5:
            sylow.add(frozenset(perm_power(element, n) for n in range(5)))
    sylow = tuple(sorted(sylow, key=lambda subgroup: tuple(sorted(subgroup))))
    assert len(sylow) == 6
    indices = {subgroup: index for index, subgroup in enumerate(sylow)}
    representation = {}
    for element in A5_PERMS:
        inverse_element = pi(element)
        action = tuple(
            indices[
                frozenset(pc(pc(element, h), inverse_element) for h in subgroup)
            ]
            for subgroup in sylow
        )
        matrix = [[0] * 5 for _ in range(5)]
        for column in range(5):
            if action[column] < 5:
                matrix[action[column]][column] += 1
            if action[5] < 5:
                matrix[action[5]][column] -= 1
        representation[element] = matrix
    return representation


AUGMENTATION = augmentation_representation()


def source_representation(p, sqrt5):
    alpha = -(1 + sqrt5) * pow(2, -1, p) % p
    g5, g3 = (1, 2, 3, 4, 0), (0, 1, 3, 4, 2)
    m5 = [
        [alpha, -alpha % p, -1 % p],
        [alpha, 1, 0],
        [alpha, -alpha % p, 0],
    ]
    m3 = [
        [0, -1 % p, -alpha % p],
        [0, 0, 1],
        [-1 % p, -alpha % p, 0],
    ]
    representation = {PID: identity(3)}
    queue = deque([PID])
    while queue:
        current = queue.popleft()
        for generator, matrix in ((g5, m5), (g3, m3)):
            candidate = pc(current, generator)
            candidate_matrix = mm(representation[current], matrix, p)
            if candidate in representation:
                assert representation[candidate] == candidate_matrix
            else:
                representation[candidate] = candidate_matrix
                queue.append(candidate)
    assert set(representation) == set(A5_PERMS)
    return representation


# Bind the reconstructed class labels and source maps to the authoritative
# subgroup packet rather than trusting the modular producer's class labels.
TWIST_RECORDS = {
    record["label"]: record
    for record in TWISTS["records"]
    if record["label"].startswith("A5_class_")
}
CLASS_DATA = []
for class_index, (a, b, subgroup) in enumerate(A5_CLASSES, 1):
    label = f"A5_class_{class_index}"
    record = TWIST_RECORDS[label]
    assert frozenset(map(tuple, record["subgroup_elements"])) == subgroup
    mapping = subgroup_isomorphism(a, b, subgroup)
    recorded_mapping = {
        tuple(row["h"]): tuple(row["permutation"])
        for row in record["source_map"]
    }
    assert mapping == recorded_mapping
    CLASS_DATA.append(
        {
            "index": class_index,
            "label": label,
            "generators": (a, b),
            "subgroup": subgroup,
            "mapping": mapping,
            "cosets": left_coset_representatives(subgroup),
        }
    )


# ---------------------------------------------------------------------------
# Exact representation core reduced at a caller-selected split prime.


WEIL_S_EXACT, WEIL_T_EXACT = CORE["weil_generators"]()
SCHUR_A_EXACT, SCHUR_B_EXACT = CORE["schur_generators"]()
SCHUR_S_EXACT = CORE["matrix_word"](
    CORE["WEIL_TO_PFAFFIAN"]["S"],
    {"A": SCHUR_A_EXACT, "B": SCHUR_B_EXACT},
    6,
)
SCHUR_T_EXACT = CORE["matrix_word"](
    CORE["WEIL_TO_PFAFFIAN"]["T"],
    {"A": SCHUR_A_EXACT, "B": SCHUR_B_EXACT},
    6,
)


def reduce_exact_matrix(matrix, p, zeta):
    return [
        [CORE["reduce_k11"](entry, zeta, p) for entry in row]
        for row in matrix.to_list()
    ]


def representation_context(p, zeta):
    assert pow(zeta, 11, p) == 1 and zeta != 1
    weil_generators = {
        "S": reduce_exact_matrix(WEIL_S_EXACT, p, zeta),
        "T": reduce_exact_matrix(WEIL_T_EXACT, p, zeta),
    }
    schur_generators = {
        "S": reduce_exact_matrix(SCHUR_S_EXACT, p, zeta),
        "T": reduce_exact_matrix(SCHUR_T_EXACT, p, zeta),
    }
    weil = {
        element: mword(WORDS[element], weil_generators, 5, p)
        for element in GROUP
    }
    schur = {
        element: mword(WORDS[element], schur_generators, 6, p)
        for element in GROUP
    }
    assert mpow(weil_generators["S"], 2, p) == identity(5)
    assert mpow(weil_generators["T"], 11, p) == identity(5)
    assert mpow(mm(weil_generators["S"], weil_generators["T"], p), 3, p) == identity(5)
    minus_i6 = ms(-1, identity(6), p)
    assert mpow(schur_generators["S"], 2, p) == minus_i6
    assert mpow(schur_generators["T"], 11, p) == identity(6)
    assert mpow(mm(schur_generators["S"], schur_generators["T"], p), 3, p) == minus_i6
    for element in GROUP:
        for generator in (FS, FT):
            candidate = gmul(element, generator)
            assert mm(weil[element], weil[generator], p) == weil[candidate]
            product_matrix = mm(schur[element], schur[generator], p)
            assert product_matrix == schur[candidate] or product_matrix == ms(-1, schur[candidate], p)
    return {
        "p": p,
        "zeta": zeta,
        "weil_generators": weil_generators,
        "schur_generators": schur_generators,
        "weil": weil,
        "schur": schur,
    }


# ---------------------------------------------------------------------------
# Primitive fixed-field resolvents at p=23.


def polynomial_from_roots_high(roots, p):
    coefficients = [1]  # ascending order
    for root in roots:
        new = [0] * (len(coefficients) + 1)
        for degree, coefficient in enumerate(coefficients):
            new[degree] = (new[degree] - root * coefficient) % p
            new[degree + 1] = (new[degree + 1] + coefficient) % p
        coefficients = new
    return list(reversed(coefficients))


def discriminant_from_roots(roots, p):
    value = 1
    for i, j in combinations(range(len(roots)), 2):
        value = value * pow((roots[i] - roots[j]) % p, 2, p) % p
    return value


def orbit_sum(ctx, elements, linear_form, exponent, vector):
    p = ctx["p"]
    total = 0
    for element in elements:
        moved = mv(ctx["schur"][element], vector, p)
        linear = sum(a * b for a, b in zip(linear_form, moved)) % p
        total = (total + pow(linear, exponent, p)) % p
    return total


def companion_from_high_coefficients(coefficients, p):
    assert len(coefficients) == 12 and coefficients[0] == 1
    low = list(reversed(coefficients[1:]))
    matrix = [[0] * 11 for _ in range(11)]
    for column in range(10):
        matrix[column + 1][column] = 1
    for row in range(11):
        matrix[row][10] = -low[row] % p
    return matrix


def verify_primitive_resolvents():
    ctx = representation_context(23, 2)
    for class_data in CLASS_DATA:
        index = class_data["index"]
        payload = FIELD_PAYLOADS[index]
        assert payload["format"] == "a5q-fixed-field-formula-certificate-v1"
        assert payload["class"] == class_data["label"]
        assert payload["galois_object"]["group_order"] == len(GROUP) == 660
        assert payload["galois_object"]["subgroup_order"] == len(class_data["subgroup"]) == 60
        assert payload["galois_object"]["subgroup_index"] == 11
        certificate = payload["good_reduction_certificate"]
        primitive = payload["primitive_element"]
        assert certificate["prime"] == 23 and certificate["zeta_11_residue"] == 2
        vector = certificate["schur_vector_v0_through_v5"]
        linear_form = primitive["linear_form_coefficients_v0_through_v5"]
        exponent = primitive["exponent"]
        assert exponent % 2 == 0
        denominator = orbit_sum(ctx, GROUP, linear_form, exponent, vector)
        assert denominator == certificate["denominator_value"] != 0
        numerator_values = [
            orbit_sum(
                ctx,
                class_data["subgroup"],
                linear_form,
                exponent,
                mv(ctx["schur"][representative], vector, 23),
            )
            for representative in class_data["cosets"]
        ]
        assert sorted(numerator_values) == certificate["numerator_coset_values"]
        roots = sorted(value * pow(denominator, -1, 23) % 23 for value in numerator_values)
        assert roots == certificate["normalized_resolvent_roots_sorted"]
        assert len(set(roots)) == 11
        coefficients = polynomial_from_roots_high(roots, 23)
        assert coefficients == certificate["monic_resolvent_coefficients_high_to_low"]
        discriminant = discriminant_from_roots(roots, 23)
        assert discriminant == certificate["discriminant_mod_23"] != 0
        vandermonde = [[pow(root, power, 23) for power in range(11)] for root in roots]
        assert det(vandermonde, 23) != 0
        companion = companion_from_high_coefficients(coefficients, 23)
        assert companion == payload["power_basis_interface"]["companion_matrix_mod_23_rows"]
        base_numerator = numerator_values[0]
        for h in class_data["subgroup"]:
            moved = mv(ctx["schur"][h], vector, 23)
            assert orbit_sum(ctx, class_data["subgroup"], linear_form, exponent, moved) == base_numerator
        print(
            f"PASS primitive {class_data['label']} p23 denominator={denominator} "
            f"discriminant={discriminant} degree=11"
        )


# ---------------------------------------------------------------------------
# Reduction of the exact degree-eleven A5 point packet.


class Denominators:
    def __init__(self, p):
        self.p = p
        self.count = 0
        self.product = 1

    def reduce(self, value):
        value = Fraction(value)
        denominator = value.denominator % self.p
        assert denominator
        self.count += 1
        self.product = self.product * denominator % self.p
        return value.numerator * pow(denominator, -1, self.p) % self.p

    def raw(self):
        return {"count": self.count, "product_mod_p": self.product, "all_nonzero": True}


def reduce_covariants(p, sqrt5):
    tracker = Denominators(p)
    output = []
    for covariant in RAW_COVARIANTS["covariants"]:
        components = []
        for component in covariant:
            polynomial = {}
            for exponent_text, coefficient in component.items():
                rational = tracker.reduce(Fraction(*coefficient["rational"]))
                radical = tracker.reduce(Fraction(*coefficient["sqrt5"]))
                value = (rational + sqrt5 * radical) % p
                if value:
                    polynomial[tuple(map(int, exponent_text.split(",")))] = value
            components.append(polynomial)
        output.append(components)
    return output, tracker.raw()


def evaluate_polynomial(polynomial, point, p):
    total = 0
    for exponent, coefficient in polynomial.items():
        term = coefficient
        for coordinate, power in zip(point, exponent):
            term = term * pow(coordinate, power, p) % p
        total = (total + term) % p
    return total


def evaluate_covariant_basis(covariants, point, p):
    return [
        [evaluate_polynomial(component, point, p) for component in covariant]
        for covariant in covariants
    ]


def reduce_field4(entries, tracker, sqrt5, sqrt_minus11, p):
    coefficients = [tracker.reduce(value) for value in entries]
    assert len(coefficients) == 4
    return (
        coefficients[0]
        + sqrt5 * coefficients[1]
        + sqrt_minus11 * coefficients[2]
        + sqrt5 * sqrt_minus11 * coefficients[3]
    ) % p


def landing_option(class_index, p, sqrt5, sqrt_minus11, selected_alpha):
    payload = POINT_PAYLOADS[class_index]
    relations = payload["closed_point_relations"]
    tracker = Denominators(p)
    reduced = {
        name: reduce_field4(values, tracker, sqrt5, sqrt_minus11, p)
        for name, values in relations.items()
    }
    alpha = selected_alpha
    assert (
        alpha ** 3
        + reduced["p2"] * alpha ** 2
        + reduced["p1"] * alpha
        + reduced["p0"]
    ) % p == 0
    parameters = [1]
    for name in ("a1", "a2", "a3"):
        parameters.append(
            sum(reduced[f"{name}_{power}"] * pow(alpha, power, p) for power in range(3)) % p
        )
    parameters.append(alpha)
    cubic_parameter = (
        13 - sqrt_minus11 if class_index == 1 else 13 + sqrt_minus11
    ) * pow(18, -1, p) % p
    return {
        "alpha": alpha,
        "parameters": parameters,
        "cubic_parameter": cubic_parameter,
        "denominators": tracker.raw(),
    }


def phi(covariants, option, point, p):
    basis_values = evaluate_covariant_basis(covariants, point, p)
    return [
        sum(
            option["parameters"][basis] * basis_values[basis][coordinate]
            for basis in range(5)
        ) % p
        for coordinate in range(5)
    ]


O0 = (
    (0, 1, 2), (0, 1, 3), (0, 2, 4), (0, 3, 5), (0, 4, 5),
    (1, 2, 5), (1, 3, 4), (1, 4, 5), (2, 3, 4), (2, 3, 5),
)
O1 = (
    (0, 1, 4), (0, 1, 5), (0, 2, 3), (0, 2, 5), (0, 3, 4),
    (1, 2, 3), (1, 2, 4), (1, 3, 5), (2, 4, 5), (3, 4, 5),
)


def canonical_cubic(vector, parameter, p):
    six = list(vector) + [-sum(vector) % p]
    first = sum(six[i] * six[j] * six[k] for i, j, k in O0) % p
    second = sum(six[i] * six[j] * six[k] for i, j, k in O1) % p
    return (first + parameter * second) % p


def klein(vector, p):
    return sum(vector[i] ** 2 * vector[(i + 1) % 5] for i in range(5)) % p


# ---------------------------------------------------------------------------
# Independent modular transport replay.


def schur_frame(ctx, vector):
    p = ctx["p"]
    output = [[0] * 5 for _ in range(5)]
    scalar = 0
    for g in GROUP:
        linear = sum(ctx["schur"][g][5][j] * vector[j] for j in range(6)) % p
        value = pow(linear, 8, p)
        scalar = (scalar + value) % p
        output = ma(output, ms(value, inverse(ctx["weil"][g], p), p), p)
    return output, scalar


def quartic_frame(ctx, class_runtime, vector):
    p = ctx["p"]
    output = [[0] * 3 for _ in range(3)]
    separator = 0
    for h in class_runtime["subgroup"]:
        linear = sum(ctx["schur"][h][5][j] * vector[j] for j in range(6)) % p
        value = pow(linear, 4, p)
        separator = (separator + value) % p
        output = ma(output, ms(value, class_runtime["sigma_inverse"][h], p), p)
    return output, separator


PAIR_COLUMNS = tuple((i, j) for i in range(5) for j in range(i, 5))


def verify_raw_noncollision(rows, recorded, p):
    witnesses = []
    product_value = 1
    for left_index, right_index in combinations(range(11), 2):
        minor = first_nonzero_projective_minor(rows[left_index], rows[right_index], p)
        assert minor is not None
        product_value = product_value * minor[2] % p
        witnesses.append({"rows": [left_index, right_index], "minor": minor})
    assert len(witnesses) == recorded["pair_count"] == 55
    assert witnesses == recorded["first_nonzero_minor_for_each_pair"]
    assert product_value == recorded["minor_product_mod_p"] != 0


def verify_ranks(rows, recorded, p):
    assert rows == recorded["coordinate_matrix"]
    rank_coordinates = matrix_rank(rows, p)
    assert rank_coordinates == recorded["coordinate_rank"] == 5
    chosen_rows = independent_row_indices(rows, 5, p)
    coordinate_minor = det([rows[index] for index in chosen_rows], p)
    assert recorded["coordinate_rank_minor"] == {
        "rows": chosen_rows,
        "columns": list(range(5)),
        "determinant_mod_p": coordinate_minor,
    }
    assert coordinate_minor
    products = [[row[i] * row[j] % p for i, j in PAIR_COLUMNS] for row in rows]
    assert products == recorded["pairwise_product_matrix"]
    assert [list(pair) for pair in PAIR_COLUMNS] == recorded["pairwise_product_column_pairs"]
    rank_products = matrix_rank(products, p)
    assert rank_products == recorded["pairwise_product_rank"] == 11
    pivot_columns = row_reduce(products, p)[1]
    product_minor = det(
        [[row[column] for column in pivot_columns] for row in products], p
    )
    assert recorded["pairwise_product_rank_minor"] == {
        "rows": list(range(11)),
        "columns": pivot_columns,
        "determinant_mod_p": product_minor,
    }
    assert product_minor
    return {
        "coordinate_rank": rank_coordinates,
        "product_rank": rank_products,
        "coordinate_minor": coordinate_minor,
        "product_minor": product_minor,
    }


def verify_separator(values, recorded, p):
    assert values == recorded["values"]
    assert len(set(values)) == 11
    vandermonde = 1
    for i, j in combinations(range(11), 2):
        vandermonde = vandermonde * (values[j] - values[i]) % p
    assert vandermonde == recorded["vandermonde_product_mod_p"] != 0
    high = polynomial_from_roots_high(values, p)
    ascending = list(reversed(high))
    assert ascending == recorded["degree11_separator_polynomial_coefficients_ascending"]


def verify_modular_transport():
    input_files = MODULAR_RESULT["input_files"]
    for key, path in (
        ("degree11_covariants", COVARIANT_PATH),
        ("point_class_1", POINT_PATHS[1]),
        ("point_class_2", POINT_PATHS[2]),
    ):
        assert sha256(path.read_bytes()).hexdigest() == input_files[key]["sha256"]

    exact_rank_records = {}
    for prime_record in MODULAR_RESULT["primes"]:
        p = prime_record["prime"]
        for run in prime_record["class_witness_runs"]:
            assert run["prime"] == p
            zeta = run["zeta11"]
            sqrt5 = run["sqrt5"]
            sqrt_minus11 = run["sqrt_minus11"]
            assert sqrt5 * sqrt5 % p == 5 % p
            assert sqrt_minus11 * sqrt_minus11 % p == -11 % p
            gauss = sum(
                (1 if exponent in {1, 3, 4, 5, 9} else -1) * pow(zeta, exponent, p)
                for exponent in range(1, 11)
            ) % p
            assert gauss == sqrt_minus11 == run["gauss_sum"]
            ctx = representation_context(p, zeta)
            vector = run["integer_witness_reduced"]
            record = run["classes"][0]
            class_index = int(record["class"].rsplit("_", 1)[1])
            class_data = CLASS_DATA[class_index - 1]
            assert record["class"] == class_data["label"]
            assert record["subgroup_order"] == 60 and record["subgroup_index"] == 11
            assert record["subgroup_generators"] == [list(g) for g in class_data["generators"]]
            assert record["conjugate_coset_representatives"] == [list(g) for g in class_data["cosets"]]

            source = source_representation(p, sqrt5)
            augmentation = {
                perm: [[value % p for value in row] for row in matrix]
                for perm, matrix in AUGMENTATION.items()
            }
            sigma = {h: source[class_data["mapping"][h]] for h in class_data["subgroup"]}
            sigma_inverse = {
                h: source[pi(class_data["mapping"][h])]
                for h in class_data["subgroup"]
            }
            intertwiner = [[0] * 5 for _ in range(5)]
            for h in class_data["subgroup"]:
                term = mm(ctx["weil"][h], augmentation[pi(class_data["mapping"][h])], p)
                intertwiner = ma(intertwiner, term, p)
            assert intertwiner == record["canonical_to_installed_intertwiner_J"]
            assert det(intertwiner, p) == record["intertwiner_determinant"] != 0
            for h in class_data["subgroup"]:
                assert mm(ctx["weil"][h], intertwiner, p) == mm(
                    intertwiner, augmentation[class_data["mapping"][h]], p
                )

            covariants, covariant_denominators = reduce_covariants(p, sqrt5)
            assert covariant_denominators == run["degree11_covariant_input_denominators"]
            option = landing_option(
                class_index, p, sqrt5, sqrt_minus11, record["selected_alpha"]
            )
            assert option["parameters"] == record["landing_parameter_vector"]
            assert option["cubic_parameter"] == record["canonical_cubic_parameter"]
            assert option["denominators"] == record["point_input_denominators"]

            q_frame, scalar_i8 = schur_frame(ctx, vector)
            assert q_frame == run["full_schur_frame_Q"]
            assert scalar_i8 == run["full_schur_scalar_I8"] != 0
            assert det(q_frame, p) == run["full_schur_frame_determinant"] != 0
            q_inverse = inverse(q_frame, p)
            for generator in (FS, FT):
                moved_frame, moved_scalar = schur_frame(
                    ctx, mv(ctx["schur"][generator], vector, p)
                )
                assert moved_frame == mm(ctx["weil"][generator], q_frame, p)
                assert moved_scalar == scalar_i8

            runtime = {
                **class_data,
                "sigma": sigma,
                "sigma_inverse": sigma_inverse,
            }
            base_b, base_separator = quartic_frame(ctx, runtime, vector)
            assert base_b == record["base_quartic_frame_B"]
            assert det(base_b, p) == record["base_quartic_frame_determinant"] != 0
            base_y = [row[0] for row in base_b]
            assert base_y == record["base_source_point_y_equals_Be0"] and any(base_y)
            stabilizer = []
            stabilizer_minor_product = 1
            nonidentity_checks = 0
            for h in class_data["subgroup"]:
                moved_y = mv(sigma[h], base_y, p)
                minor = first_nonzero_projective_minor(base_y, moved_y, p)
                if minor is None:
                    stabilizer.append(h)
                else:
                    nonidentity_checks += 1
                    stabilizer_minor_product = stabilizer_minor_product * minor[2] % p
            assert stabilizer == [FONE]
            free_record = record["base_source_free_locus"]
            assert free_record["projective_stabilizer"] == [list(FONE)]
            assert free_record["projective_stabilizer_order"] == 1
            assert free_record["nonidentity_checks"] == nonidentity_checks == 59
            assert free_record["nonidentity_minor_product"] == stabilizer_minor_product != 0

            descended_rows = []
            separators = []
            b_determinants = []
            for representative in class_data["cosets"]:
                moved_vector = mv(ctx["schur"][representative], vector, p)
                b_frame, separator = quartic_frame(ctx, runtime, moved_vector)
                b_determinants.append(det(b_frame, p))
                assert b_determinants[-1] != 0
                y = [row[0] for row in b_frame]
                canonical_point = phi(covariants, option, y, p)
                assert any(canonical_point)
                assert canonical_cubic(canonical_point, option["cubic_parameter"], p) == 0
                installed_point = mv(intertwiner, canonical_point, p)
                assert any(installed_point) and klein(installed_point, p) == 0
                common_descended = mv(
                    mm(q_inverse, inverse(ctx["weil"][representative], p), p),
                    installed_point,
                    p,
                )
                assert any(common_descended)
                common_upstairs = mv(q_frame, common_descended, p)
                expected_upstairs = mv(inverse(ctx["weil"][representative], p), installed_point, p)
                assert common_upstairs == expected_upstairs
                assert klein(common_upstairs, p) == 0
                descended_rows.append(common_descended)
                separators.append(separator)

            assert b_determinants == record["conjugate_quartic_frame_determinants"]
            assert descended_rows[0] == record["base_full_twist_point"]
            assert phi(covariants, option, base_y, p) == record["base_canonical_landing_point"]
            assert mv(intertwiner, record["base_canonical_landing_point"], p) == record["base_installed_landing_point"]

            # Recompute all 60 H-invariance identities for the descended base point.
            for h in class_data["subgroup"]:
                moved_vector = mv(ctx["schur"][h], vector, p)
                moved_b, moved_separator = quartic_frame(ctx, runtime, moved_vector)
                assert moved_b == mm(sigma[h], base_b, p)
                assert moved_separator == base_separator
                moved_y = [row[0] for row in moved_b]
                moved_installed = mv(intertwiner, phi(covariants, option, moved_y, p), p)
                moved_q = mm(ctx["weil"][h], q_frame, p)
                moved_descended = mv(inverse(moved_q, p), moved_installed, p)
                assert moved_descended == descended_rows[0]

            verify_raw_noncollision(descended_rows, record["projective_noncollision"], p)
            rank_data = verify_ranks(descended_rows, record, p)
            verify_separator(separators, record["point_orbit_separator"], p)
            exact_rank_records.setdefault(class_index, []).append((p, rank_data))
            print(
                f"PASS transport p={p} {record['class']} alpha={option['alpha']} "
                f"detQ={det(q_frame,p)} rank={rank_data['coordinate_rank']} "
                f"product_rank={rank_data['product_rank']}"
            )

    assert set(exact_rank_records) == {1, 2}
    assert all({p for p, _ in records} == {89, 199} for records in exact_rank_records.values())
    return exact_rank_records


def verify_characteristic_zero_obstruction(rank_records):
    # Each matrix entry is the reduction of the displayed exact straight-line
    # expression.  The verifier has checked every rational input denominator,
    # det(J), det(B), and det(Q) at the relevant prime.  A nonzero modular minor
    # is therefore a nonzero characteristic-zero minor.  Row/column counts give
    # the reverse upper bounds.
    for class_index, records in rank_records.items():
        p89 = next(data for p, data in records if p == 89)
        assert p89["coordinate_rank"] == 5
        assert p89["coordinate_minor"] != 0
        assert p89["product_rank"] == 11
        assert p89["product_minor"] != 0
        characteristic_zero_coordinate_rank = 5
        characteristic_zero_product_rank = 11
        # If W=lambda<1,x,...,x^4> with deg(x)=11, then W^2 is exactly the
        # nine-dimensional span of 1,x,...,x^8.  Rank 11 contradicts this.
        quartic_required_product_rank = 9
        assert characteristic_zero_product_rank > quartic_required_product_rank
        print(
            f"PASS scoped characteristic-zero obstruction A5_class_{class_index}: "
            f"rank(C)=5 rank(Sym2 rows)=11 != 9"
        )
    print("PASS degree-12 division inapplicable: the degree-four phi incidence is empty")
    print("PASS scope: A5Q-DEGREE4-RESCUE-EMPTY-SCOPED only; no Problem E headline")


def run_upstream_exact_verifier():
    command = [sys.executable, "-u", str(UPSTREAM_EXACT_VERIFY)]
    environment = dict(__import__("os").environ)
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    start = time.perf_counter()
    process = subprocess.Popen(
        command,
        cwd=str(HERE),
        env=environment,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        bufsize=1,
    )
    assert process.stdout is not None
    lines = []
    for line in process.stdout:
        line = line.rstrip("\n")
        lines.append(line)
        print(f"[upstream-exact] {line}")
    return_code = process.wait()
    runtime = time.perf_counter() - start
    assert return_code == 0
    assert "H3_EXACT_BOTH_A5_POINTS_VERIFIED" in lines
    print(f"PASS upstream exact landing replay runtime_seconds={runtime:.2f}")


def parse_args():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--skip-upstream-exact",
        action="store_true",
        help="skip the slow upstream characteristic-zero landing replay",
    )
    return parser.parse_args()


def main():
    args = parse_args()
    start = time.perf_counter()
    verify_input_manifest()
    assert RAW_COVARIANTS["format"] == "a5-degree11-raw-reynolds-covariants-v1"
    assert MODULAR_RESULT["format"] == "a5q-modular-index11-discovery-v1"
    verify_primitive_resolvents()
    rank_records = verify_modular_transport()
    verify_characteristic_zero_obstruction(rank_records)
    if args.skip_upstream_exact:
        print("SKIP upstream exact landing replay by explicit command-line request")
        terminal_marker = "A5Q_PARTIAL_FIELD_AND_TRANSPORT_VERIFY_OK"
    else:
        run_upstream_exact_verifier()
        terminal_marker = "A5Q_INDEPENDENT_VERIFY_OK"
    runtime = time.perf_counter() - start
    print(f"total_runtime_seconds={runtime:.2f}")
    print(terminal_marker)


if __name__ == "__main__":
    main()
