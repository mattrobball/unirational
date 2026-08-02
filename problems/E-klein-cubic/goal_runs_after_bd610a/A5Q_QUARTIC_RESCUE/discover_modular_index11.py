#!/usr/bin/env python3
"""Finite-field discovery/replay for the A5Q index-eleven descent interface.

This is deliberately a modular discovery certificate, not a characteristic-zero
descent theorem.  At two split primes it reconstructs, rather than loading,

* PSL_2(F_11) and its five-dimensional Weil action W5;
* the projective six-dimensional Schur action V6;
* both inner-conjugacy classes of maximal A5 subgroups;
* the faithful icosahedral source action and the rational augmentation target;
* the quartic H-Reynolds matrix B_i(v), the canonical-to-installed
  intertwiner J_i, and the full degree-eight Schur Reynolds frame Q(v).

It reads only the sealed exact degree-eleven covariant basis and the two exact
``point.json`` parameter packets.  All arithmetic after parsing their rational
coefficients is performed directly in F_p.
"""

from __future__ import annotations

from collections import deque
from fractions import Fraction
from hashlib import sha256
from itertools import combinations, permutations, product
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
POINT_ROOT = PROBLEM / "goal_runs_after_35fa" / "H_A5_TWISTS"
COVARIANT_PATH = POINT_ROOT / "common" / "degree11_covariants_raw_exact.json"
POINT_PATHS = {
    1: POINT_ROOT / "A5_class_1" / "point.json",
    2: POINT_ROOT / "A5_class_2" / "point.json",
}
OUTPUT = HERE / "modular_index11_discovery.json"

PRIME_SPECS = (
    {
        "role": "discovery_certificate",
        "prime": 89,
        "zeta11": 2,
        "sqrt5": 19,
        # This is the quadratic Gauss sum induced by zeta11=2.  The other
        # square root, 16, would exchange the two conjugate class packets.
        "sqrt_minus11": 73,
        "preferred_alpha": {1: 80, 2: 49},
    },
    {
        "role": "unused_holdout",
        "prime": 199,
        "zeta11": 18,
        "sqrt5": 76,
        # Likewise zeta11=18 induces 136 rather than its negative 63.
        "sqrt_minus11": 136,
        "preferred_alpha": {1: 76, 2: 120},
    },
)


# ---------------------------------------------------------------------------
# Small finite-field linear algebra.


def ident(n: int) -> list[list[int]]:
    return [[int(i == j) for j in range(n)] for i in range(n)]


def mat_mul(left, right, p):
    return [
        [
            sum(left[i][k] * right[k][j] for k in range(len(right))) % p
            for j in range(len(right[0]))
        ]
        for i in range(len(left))
    ]


def mat_vec(matrix, vector, p):
    return [sum(a * b for a, b in zip(row, vector)) % p for row in matrix]


def mat_add(left, right, p):
    return [
        [(a + b) % p for a, b in zip(left_row, right_row)]
        for left_row, right_row in zip(left, right)
    ]


def mat_scale(scalar, matrix, p):
    return [[scalar * value % p for value in row] for row in matrix]


def mat_pow(matrix, exponent, p):
    out = ident(len(matrix))
    while exponent:
        if exponent & 1:
            out = mat_mul(out, matrix, p)
        matrix = mat_mul(matrix, matrix, p)
        exponent //= 2
    return out


def mat_word(word, generators, size, p):
    out = ident(size)
    for letter in word:
        out = mat_mul(out, generators[letter], p)
    return out


def rref(matrix, p):
    work = [[value % p for value in row] for row in matrix]
    if not work:
        return work, []
    pivot_row = 0
    pivots = []
    for column in range(len(work[0])):
        pivot = next(
            (row for row in range(pivot_row, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            continue
        work[pivot_row], work[pivot] = work[pivot], work[pivot_row]
        inverse = pow(work[pivot_row][column], -1, p)
        work[pivot_row] = [inverse * value % p for value in work[pivot_row]]
        for row in range(len(work)):
            if row == pivot_row:
                continue
            scalar = work[row][column]
            if scalar:
                work[row] = [
                    (left - scalar * right) % p
                    for left, right in zip(work[row], work[pivot_row])
                ]
        pivots.append(column)
        pivot_row += 1
        if pivot_row == len(work):
            break
    return work, pivots


def rank(matrix, p):
    return len(rref(matrix, p)[1])


def determinant(matrix, p):
    assert matrix and len(matrix) == len(matrix[0])
    work = [[value % p for value in row] for row in matrix]
    out = 1
    for column in range(len(work)):
        pivot = next(
            (row for row in range(column, len(work)) if work[row][column]),
            None,
        )
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            out = -out
        value = work[column][column]
        out = out * value % p
        inverse = pow(value, -1, p)
        for row in range(column + 1, len(work)):
            scalar = work[row][column] * inverse % p
            if scalar:
                work[row] = [
                    (left - scalar * right) % p
                    for left, right in zip(work[row], work[column])
                ]
    return out % p


def mat_inverse(matrix, p):
    size = len(matrix)
    work = [
        [value % p for value in row] + [int(i == j) for j in range(size)]
        for i, row in enumerate(matrix)
    ]
    for column in range(size):
        pivot = next(
            (row for row in range(column, size) if work[row][column]),
            None,
        )
        if pivot is None:
            raise ZeroDivisionError("singular matrix")
        work[column], work[pivot] = work[pivot], work[column]
        inverse = pow(work[column][column], -1, p)
        work[column] = [inverse * value % p for value in work[column]]
        for row in range(size):
            if row == column:
                continue
            scalar = work[row][column]
            if scalar:
                work[row] = [
                    (left - scalar * right) % p
                    for left, right in zip(work[row], work[column])
                ]
    assert all(work[i][j] == int(i == j) for i in range(size) for j in range(size))
    return [row[size:] for row in work]


def independent_rows(matrix, target_rank, p):
    selected = []
    old_rank = 0
    for index, row in enumerate(matrix):
        candidate = selected + [index]
        new_rank = rank([matrix[i] for i in candidate], p)
        if new_rank > old_rank:
            selected.append(index)
            old_rank = new_rank
            if old_rank == target_rank:
                return selected
    raise AssertionError("requested independent rows do not exist")


def matrix_up_to_sign(left, right, p):
    return left == right or left == mat_scale(-1, right, p)


# ---------------------------------------------------------------------------
# Abstract PSL_2(F_11) and the two maximal-A5 classes.


FONE = (1, 0, 0, 1)


def fmul(left, right):
    return tuple(
        sum(left[2 * i + k] * right[2 * k + j] for k in range(2)) % 11
        for i in range(2)
        for j in range(2)
    )


def fcanon(matrix):
    positive = tuple(value % 11 for value in matrix)
    negative = tuple(-value % 11 for value in positive)
    return min(positive, negative)


def finv(matrix):
    return fcanon((matrix[3], -matrix[1], -matrix[2], matrix[0]))


FONE = fcanon(FONE)
FS = fcanon((0, 2, 5, 0))
FT = fcanon((1, 2, 0, 1))


def abstract_group():
    words = {FONE: ""}
    queue = deque([FONE])
    while queue:
        current = queue.popleft()
        for generator, letter in ((FS, "S"), (FT, "T")):
            candidate = fcanon(fmul(current, generator))
            if candidate not in words:
                words[candidate] = words[current] + letter
                queue.append(candidate)
    assert len(words) == 660
    return tuple(sorted(words)), words


GROUP, WORDS = abstract_group()


def gmul(left, right):
    return fcanon(fmul(left, right))


def gpow(element, exponent):
    out = FONE
    while exponent:
        if exponent & 1:
            out = gmul(out, element)
        element = gmul(element, element)
        exponent //= 2
    return out


def gorder(element):
    out = FONE
    for exponent in range(1, 100):
        out = gmul(out, element)
        if out == FONE:
            return exponent
    raise AssertionError("group order exceeded bound")


ORDERS = {element: gorder(element) for element in GROUP}


def subgroup_closure(generators):
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
    return {
        frozenset(conjugate(g, h) for h in subgroup)
        for g in GROUP
    }


def two_a5_classes():
    first = None
    first_orbit = None
    for a in (element for element in GROUP if ORDERS[element] == 2):
        for b in (element for element in GROUP if ORDERS[element] == 3):
            if ORDERS[gmul(a, b)] != 5:
                continue
            subgroup = subgroup_closure((a, b))
            if len(subgroup) != 60:
                continue
            if first is None:
                first = (a, b, subgroup)
                first_orbit = subgroup_orbit(subgroup)
            elif subgroup not in first_orbit:
                second = (a, b, subgroup)
                assert len(first_orbit) == len(subgroup_orbit(subgroup)) == 11
                assert first_orbit.isdisjoint(subgroup_orbit(subgroup))
                return first, second
    raise AssertionError("failed to find both A5 classes")


A5_CLASSES = two_a5_classes()


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


# ---------------------------------------------------------------------------
# Abstract A5, its icosahedral source, and augmentation target.


PID = tuple(range(5))


def pcompose(left, right):
    return tuple(left[right[i]] for i in range(5))


def pinverse(perm):
    return tuple(perm.index(i) for i in range(len(perm)))


def peven(perm):
    inversions = sum(
        perm[i] > perm[j]
        for i in range(len(perm))
        for j in range(i + 1, len(perm))
    )
    return inversions % 2 == 0


PERMS = tuple(perm for perm in permutations(range(5)) if peven(perm))


def porder(perm):
    out = PID
    for exponent in range(1, 61):
        out = pcompose(out, perm)
        if out == PID:
            return exponent
    raise AssertionError("permutation order exceeded bound")


PA, PB = next(
    (a, b)
    for a in PERMS
    if porder(a) == 2
    for b in PERMS
    if porder(b) == 3 and porder(pcompose(a, b)) == 5
)


def subgroup_iso(a, b, subgroup):
    mapping = {FONE: PID}
    queue = deque([FONE])
    while queue:
        current = queue.popleft()
        for generator, permutation in ((a, PA), (b, PB)):
            candidate = gmul(current, generator)
            candidate_perm = pcompose(mapping[current], permutation)
            if candidate in mapping:
                assert mapping[candidate] == candidate_perm
            else:
                mapping[candidate] = candidate_perm
                queue.append(candidate)
    assert set(mapping) == set(subgroup) and set(mapping.values()) == set(PERMS)
    return mapping


def pperm_power(perm, exponent):
    out = PID
    for _ in range(exponent):
        out = pcompose(out, perm)
    return out


def pclosure(generators):
    found = {PID}
    queue = deque([PID])
    while queue:
        current = queue.popleft()
        for generator in generators:
            candidate = pcompose(current, generator)
            if candidate not in found:
                found.add(candidate)
                queue.append(candidate)
    return frozenset(found)


def augmentation_representation():
    sylow = set()
    for element in PERMS:
        if porder(element) == 5:
            sylow.add(frozenset(pperm_power(element, n) for n in range(5)))
    sylow = tuple(sorted(sylow, key=lambda item: tuple(sorted(item))))
    assert len(sylow) == 6
    sylow_index = {subgroup: index for index, subgroup in enumerate(sylow)}

    def action_six(element):
        inverse = pinverse(element)
        return tuple(
            sylow_index[
                frozenset(
                    pcompose(pcompose(element, h), inverse)
                    for h in subgroup
                )
            ]
            for subgroup in sylow
        )

    representation = {}
    for element in PERMS:
        perm = action_six(element)
        matrix = [[0] * 5 for _ in range(5)]
        for column in range(5):
            if perm[column] < 5:
                matrix[perm[column]][column] += 1
            if perm[5] < 5:
                matrix[perm[5]][column] -= 1
        representation[element] = matrix
    return representation, sylow, action_six


AUGMENTATION, SYLOW5, ACTION_SIX = augmentation_representation()


def source_representation(p, sqrt5):
    alpha = -(1 + sqrt5) * pow(2, -1, p) % p
    g5 = (1, 2, 3, 4, 0)
    g3 = (0, 1, 3, 4, 2)
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
    representation = {PID: ident(3)}
    queue = deque([PID])
    while queue:
        current = queue.popleft()
        for generator, matrix in ((g5, m5), (g3, m3)):
            candidate = pcompose(current, generator)
            candidate_matrix = mat_mul(representation[current], matrix, p)
            if candidate in representation:
                assert representation[candidate] == candidate_matrix
            else:
                representation[candidate] = candidate_matrix
                queue.append(candidate)
    assert set(representation) == set(PERMS)
    return representation, (g5, g3), (m5, m3)


# ---------------------------------------------------------------------------
# W5 and projective V6 at a split prime.


WEIL_TO_SCHUR_WORDS = {"S": "BABAB", "T": "AABABAB"}


def representation_context(spec):
    p = spec["prime"]
    zeta = spec["zeta11"]
    sqrt5 = spec["sqrt5"]
    sqrt_minus11 = spec["sqrt_minus11"]
    assert pow(zeta, 11, p) == 1 and zeta != 1
    assert sqrt5 * sqrt5 % p == 5 % p
    assert sqrt_minus11 * sqrt_minus11 % p == -11 % p

    quadratic_residues = {1, 3, 4, 5, 9}
    gauss = sum(
        (1 if exponent in quadratic_residues else -1) * pow(zeta, exponent, p)
        for exponent in range(1, 11)
    ) % p
    assert gauss == sqrt_minus11 and gauss * gauss % p == -11 % p

    indices = [1, 3, 2, 5, 4]
    signs = [1, 1, -1, 1, 1]
    weil_s = [
        [
            signs[column]
            * pow(signs[row] % p, -1, p)
            * (pow(zeta, 9 * left * right, p) - pow(zeta, -9 * left * right, p))
            * (-gauss)
            * pow(11, -1, p)
            % p
            for column, right in enumerate(indices)
        ]
        for row, left in enumerate(indices)
    ]
    weil_t = [
        [pow(zeta, indices[row] ** 2, p) if row == column else 0 for column in range(5)]
        for row in range(5)
    ]
    assert mat_pow(weil_s, 2, p) == ident(5)
    assert mat_pow(weil_t, 11, p) == ident(5)
    assert mat_pow(mat_mul(weil_s, weil_t, p), 3, p) == ident(5)
    assert transformed_klein(weil_s, p) == klein_polynomial()
    assert transformed_klein(weil_t, p) == klein_polynomial()

    c = sum(pow(zeta, exponent, p) for exponent in (9, 5, 4, 3, 1)) % p
    schur_a = [
        [0, c, -1, 1, 0, 0],
        [0, c + 1, 0, -c, -1, 0],
        [0, c - 1, 0, 1, 0, 1],
        [0, c + 2, 0, -c - 1, 0, 0],
        [0, 1, 0, -1, 0, 0],
        [-1, 2, 0, -1, 0, 0],
    ]
    schur_b = [
        [1, -1, 0, 0, 0, 0],
        [1, 0, 0, -1, 0, 0],
        [c + 1, 0, -1, 0, 0, 0],
        [1, 0, 0, 0, -1, 0],
        [1, 0, 0, 0, 0, 0],
        [-c, 0, 0, 0, 0, -1],
    ]
    schur_a = [[value % p for value in row] for row in schur_a]
    schur_b = [[value % p for value in row] for row in schur_b]
    minus_i6 = mat_scale(-1, ident(6), p)
    assert mat_pow(schur_a, 3, p) == ident(6)
    assert mat_pow(schur_b, 5, p) == minus_i6
    assert mat_pow(mat_mul(schur_a, schur_b, p), 11, p) == minus_i6
    schur_s = mat_word(WEIL_TO_SCHUR_WORDS["S"], {"A": schur_a, "B": schur_b}, 6, p)
    schur_t = mat_word(WEIL_TO_SCHUR_WORDS["T"], {"A": schur_a, "B": schur_b}, 6, p)
    assert mat_pow(schur_s, 2, p) == minus_i6
    assert mat_pow(schur_t, 11, p) == ident(6)
    assert mat_pow(mat_mul(schur_s, schur_t, p), 3, p) == minus_i6

    weil_generators = {"S": weil_s, "T": weil_t}
    schur_generators = {"S": schur_s, "T": schur_t}
    weil = {
        element: mat_word(WORDS[element], weil_generators, 5, p)
        for element in GROUP
    }
    schur = {
        element: mat_word(WORDS[element], schur_generators, 6, p)
        for element in GROUP
    }
    for element in GROUP:
        for generator in (FS, FT):
            candidate = gmul(element, generator)
            assert mat_mul(weil[element], weil[generator], p) == weil[candidate]
            assert matrix_up_to_sign(
                mat_mul(schur[element], schur[generator], p), schur[candidate], p
            )

    source, source_generators, source_generator_matrices = source_representation(p, sqrt5)
    augmentation = {
        element: [[value % p for value in row] for row in matrix]
        for element, matrix in AUGMENTATION.items()
    }
    classes = []
    for class_index, (a, b, subgroup) in enumerate(A5_CLASSES, 1):
        mapping = subgroup_iso(a, b, subgroup)
        sigma = {h: source[mapping[h]] for h in subgroup}
        sigma_inverse = {h: source[pinverse(mapping[h])] for h in subgroup}
        intertwiner = [[0] * 5 for _ in range(5)]
        for h in subgroup:
            term = mat_mul(weil[h], augmentation[pinverse(mapping[h])], p)
            intertwiner = mat_add(intertwiner, term, p)
        intertwiner_det = determinant(intertwiner, p)
        assert intertwiner_det
        for h in subgroup:
            assert mat_mul(weil[h], intertwiner, p) == mat_mul(
                intertwiner, augmentation[mapping[h]], p
            )
        classes.append(
            {
                "class_index": class_index,
                "generators": (a, b),
                "subgroup": subgroup,
                "mapping": mapping,
                "sigma": sigma,
                "sigma_inverse": sigma_inverse,
                "intertwiner": intertwiner,
                "intertwiner_determinant": intertwiner_det,
                "coset_representatives": left_coset_representatives(subgroup),
            }
        )

    return {
        "spec": spec,
        "p": p,
        "gauss": gauss,
        "weil_generators": weil_generators,
        "schur_ab": {"A": schur_a, "B": schur_b},
        "schur_generators": schur_generators,
        "weil": weil,
        "schur": schur,
        "source": source,
        "source_generators": source_generators,
        "source_generator_matrices": source_generator_matrices,
        "augmentation": augmentation,
        "classes": classes,
    }


# ---------------------------------------------------------------------------
# Polynomial helpers and exact-input reduction.


def poly_mul_mod(left, right, p):
    out = {}
    for left_exp, left_coefficient in left.items():
        for right_exp, right_coefficient in right.items():
            exponent = tuple(a + b for a, b in zip(left_exp, right_exp))
            out[exponent] = (
                out.get(exponent, 0) + left_coefficient * right_coefficient
            ) % p
    return {exponent: coefficient for exponent, coefficient in out.items() if coefficient}


def klein_polynomial():
    return {
        tuple(2 if j == i else 1 if j == (i + 1) % 5 else 0 for j in range(5)): 1
        for i in range(5)
    }


def transformed_klein(matrix, p):
    variables = [
        {
            tuple(int(i == variable) for i in range(5)): coefficient % p
            for variable, coefficient in enumerate(row)
            if coefficient % p
        }
        for row in matrix
    ]
    out = {}
    for i in range(5):
        term = poly_mul_mod(poly_mul_mod(variables[i], variables[i], p), variables[(i + 1) % 5], p)
        for exponent, coefficient in term.items():
            out[exponent] = (out.get(exponent, 0) + coefficient) % p
    return {exponent: coefficient for exponent, coefficient in out.items() if coefficient}


def klein_value(vector, p):
    return sum(vector[i] * vector[i] * vector[(i + 1) % 5] for i in range(5)) % p


O0_TRIPLES = (
    (0, 1, 2), (0, 1, 3), (0, 2, 4), (0, 3, 5), (0, 4, 5),
    (1, 2, 5), (1, 3, 4), (1, 4, 5), (2, 3, 4), (2, 3, 5),
)
O1_TRIPLES = (
    (0, 1, 4), (0, 1, 5), (0, 2, 3), (0, 2, 5), (0, 3, 4),
    (1, 2, 3), (1, 2, 4), (1, 3, 5), (2, 4, 5), (3, 4, 5),
)


def canonical_cubic_value(vector, parameter, p):
    six = list(vector) + [-sum(vector) % p]
    first = sum(six[i] * six[j] * six[k] for i, j, k in O0_TRIPLES) % p
    second = sum(six[i] * six[j] * six[k] for i, j, k in O1_TRIPLES) % p
    return (first + parameter * second) % p


class DenominatorTracker:
    def __init__(self, p):
        self.p = p
        self.count = 0
        self.product = 1

    def reduce(self, value):
        fraction = Fraction(value)
        denominator = fraction.denominator % self.p
        assert denominator
        self.count += 1
        self.product = self.product * denominator % self.p
        return fraction.numerator * pow(denominator, -1, self.p) % self.p

    def record(self):
        return {"count": self.count, "product_mod_p": self.product, "all_nonzero": True}


RAW_COVARIANTS = json.loads(COVARIANT_PATH.read_text())
POINT_PAYLOADS = {index: json.loads(path.read_text()) for index, path in POINT_PATHS.items()}
assert RAW_COVARIANTS["format"] == "a5-degree11-raw-reynolds-covariants-v1"
assert len(RAW_COVARIANTS["covariants"]) == 5


def reduce_covariants(p):
    tracker = DenominatorTracker(p)
    result = []
    for covariant in RAW_COVARIANTS["covariants"]:
        components = []
        for component in covariant:
            polynomial = {}
            for exponent_text, coefficient in component.items():
                rational = tracker.reduce(Fraction(*coefficient["rational"]))
                radical = tracker.reduce(Fraction(*coefficient["sqrt5"]))
                value = (rational + radical * next(spec["sqrt5"] for spec in PRIME_SPECS if spec["prime"] == p)) % p
                if value:
                    polynomial[tuple(map(int, exponent_text.split(",")))] = value
            components.append(polynomial)
        result.append(components)
    return result, tracker.record()


def polynomial_evaluate(polynomial, point, p):
    total = 0
    for exponent, coefficient in polynomial.items():
        value = coefficient
        for coordinate, power in zip(point, exponent):
            value = value * pow(coordinate, power, p) % p
        total = (total + value) % p
    return total


def covariant_basis_evaluate(covariants, point, p):
    return [
        [polynomial_evaluate(component, point, p) for component in covariant]
        for covariant in covariants
    ]


def reduce_field4(entries, tracker, sqrt5, sqrt_minus11, p):
    assert len(entries) == 4
    coefficients = [tracker.reduce(value) for value in entries]
    return (
        coefficients[0]
        + coefficients[1] * sqrt5
        + coefficients[2] * sqrt_minus11
        + coefficients[3] * sqrt5 * sqrt_minus11
    ) % p


def point_options(ctx, class_data, covariants, preferred_alpha=None):
    p = ctx["p"]
    spec = ctx["spec"]
    index = class_data["class_index"]
    payload = POINT_PAYLOADS[index]
    assert payload["class"] == f"A5_class_{index}"
    relations = payload["closed_point_relations"]
    tracker = DenominatorTracker(p)
    reduced = {
        key: reduce_field4(
            values,
            tracker,
            spec["sqrt5"],
            spec["sqrt_minus11"],
            p,
        )
        for key, values in relations.items()
    }
    roots = [
        alpha
        for alpha in range(p)
        if (
            alpha ** 3
            + reduced["p2"] * alpha ** 2
            + reduced["p1"] * alpha
            + reduced["p0"]
        ) % p == 0
    ]
    assert roots
    if preferred_alpha is not None:
        assert preferred_alpha in roots
        roots = [preferred_alpha]

    parameter = (
        (13 - spec["sqrt_minus11"]) if index == 1
        else (13 + spec["sqrt_minus11"])
    ) * pow(18, -1, p) % p
    valid = []
    for alpha in roots:
        parameters = [1]
        for name in ("a1", "a2", "a3"):
            parameters.append(
                sum(reduced[f"{name}_{power}"] * pow(alpha, power, p) for power in range(3)) % p
            )
        parameters.append(alpha)

        # Two points guard against accepting a vacuous zero evaluation.
        nonzero_seen = False
        for test_point in ((1, 2, 3), (1, 2, 4)):
            values = covariant_basis_evaluate(covariants, test_point, p)
            image = [
                sum(parameters[basis] * values[basis][coordinate] for basis in range(5)) % p
                for coordinate in range(5)
            ]
            nonzero_seen |= any(image)
            assert canonical_cubic_value(image, parameter, p) == 0
            assert klein_value(mat_vec(class_data["intertwiner"], image, p), p) == 0
        assert nonzero_seen
        valid.append(
            {
                "alpha": alpha,
                "all_alpha_roots": roots,
                "parameter_vector": parameters,
                "canonical_cubic_parameter": parameter,
                "point_denominators": tracker.record(),
            }
        )
    return valid


def phi_evaluate(covariants, option, point, p):
    values = covariant_basis_evaluate(covariants, point, p)
    parameters = option["parameter_vector"]
    return [
        sum(parameters[basis] * values[basis][coordinate] for basis in range(5)) % p
        for coordinate in range(5)
    ]


# ---------------------------------------------------------------------------
# Reynolds constructions and certificate checks.


def schur_reynolds_frame(ctx, vector):
    p = ctx["p"]
    frame = [[0] * 5 for _ in range(5)]
    scalar_invariant = 0
    for element in GROUP:
        linear = sum(ctx["schur"][element][5][j] * vector[j] for j in range(6)) % p
        value = pow(linear, 8, p)
        scalar_invariant = (scalar_invariant + value) % p
        inverse = mat_inverse(ctx["weil"][element], p)
        frame = mat_add(frame, mat_scale(value, inverse, p), p)
    return frame, scalar_invariant


def subgroup_quartic_frame(ctx, class_data, vector):
    p = ctx["p"]
    frame = [[0] * 3 for _ in range(3)]
    resolvent = 0
    for h in class_data["subgroup"]:
        linear = sum(ctx["schur"][h][5][j] * vector[j] for j in range(6)) % p
        value = pow(linear, 4, p)
        resolvent = (resolvent + value) % p
        frame = mat_add(frame, mat_scale(value, class_data["sigma_inverse"][h], p), p)
    return frame, resolvent


def first_projective_minor(left, right, p):
    assert any(left) and any(right)
    for i, j in combinations(range(len(left)), 2):
        value = (left[i] * right[j] - left[j] * right[i]) % p
        if value:
            return [i, j, value]
    return None


def projective_normalize(vector, p):
    pivot = next(value for value in vector if value)
    inverse = pow(pivot, -1, p)
    return [value * inverse % p for value in vector]


def stabilizer_certificate(class_data, vector, p):
    witnesses = []
    stabilizer = []
    for h in sorted(class_data["subgroup"]):
        moved = mat_vec(class_data["sigma"][h], vector, p)
        minor = first_projective_minor(vector, moved, p)
        if minor is None:
            stabilizer.append(h)
        else:
            witnesses.append({"h": list(h), "minor": minor})
    assert stabilizer == [FONE]
    product_value = 1
    for row in witnesses:
        product_value = product_value * row["minor"][2] % p
    assert product_value
    return {
        "projective_stabilizer": [list(h) for h in stabilizer],
        "projective_stabilizer_order": 1,
        "nonidentity_minor_product": product_value,
        "nonidentity_checks": len(witnesses),
    }


def conjugate_noncollision_certificate(rows, p):
    witnesses = []
    product_value = 1
    for left_index, right_index in combinations(range(len(rows)), 2):
        minor = first_projective_minor(rows[left_index], rows[right_index], p)
        assert minor is not None
        product_value = product_value * minor[2] % p
        witnesses.append(
            {"rows": [left_index, right_index], "minor": minor}
        )
    assert len(witnesses) == 55 and product_value
    return {
        "pair_count": len(witnesses),
        "all_projectively_distinct": True,
        "minor_product_mod_p": product_value,
        "first_nonzero_minor_for_each_pair": witnesses,
    }


def vandermonde_certificate(values, p):
    product_value = 1
    for i, j in combinations(range(len(values)), 2):
        difference = (values[j] - values[i]) % p
        assert difference
        product_value = product_value * difference % p
    polynomial = [1]
    for root in values:
        result = [0] * (len(polynomial) + 1)
        for degree, coefficient in enumerate(polynomial):
            result[degree] = (result[degree] - root * coefficient) % p
            result[degree + 1] = (result[degree + 1] + coefficient) % p
        polynomial = result
    assert len(polynomial) == 12 and polynomial[-1] == 1
    return {
        "values": values,
        "all_distinct": True,
        "vandermonde_product_mod_p": product_value,
        "degree11_separator_polynomial_coefficients_ascending": polynomial,
    }


PAIR_COLUMNS = tuple(combinations(range(5), 2)) + tuple((i, i) for i in range(5))
PAIR_COLUMNS = tuple(sorted(PAIR_COLUMNS))
assert len(PAIR_COLUMNS) == 15


def rank_certificates(rows, p):
    coordinate_rank = rank(rows, p)
    assert coordinate_rank == 5
    independent = independent_rows(rows, 5, p)
    coordinate_minor = determinant([rows[index] for index in independent], p)
    assert coordinate_minor

    products = [
        [row[i] * row[j] % p for i, j in PAIR_COLUMNS]
        for row in rows
    ]
    product_rank = rank(products, p)
    assert product_rank == 11
    _, pivot_columns = rref(products, p)
    assert len(pivot_columns) == 11
    product_minor = determinant(
        [[row[column] for column in pivot_columns] for row in products], p
    )
    assert product_minor
    return {
        "coordinate_matrix": rows,
        "coordinate_rank": coordinate_rank,
        "coordinate_rank_minor": {
            "rows": independent,
            "columns": list(range(5)),
            "determinant_mod_p": coordinate_minor,
        },
        "pairwise_product_column_pairs": [list(pair) for pair in PAIR_COLUMNS],
        "pairwise_product_matrix": products,
        "pairwise_product_rank": product_rank,
        "pairwise_product_rank_minor": {
            "rows": list(range(11)),
            "columns": pivot_columns,
            "determinant_mod_p": product_minor,
        },
    }


class CandidateFailure(Exception):
    pass


def require(condition, message):
    if not condition:
        raise CandidateFailure(message)


def evaluate_class(ctx, class_data, covariants, options, vector, q_frame, q_inverse):
    p = ctx["p"]
    base_b, base_resolvent = subgroup_quartic_frame(ctx, class_data, vector)
    require(determinant(base_b, p) != 0, "singular base quartic frame")
    base_y = [base_b[row][0] for row in range(3)]
    require(any(base_y), "zero source point")
    try:
        free_locus = stabilizer_certificate(class_data, base_y, p)
    except AssertionError as error:
        raise CandidateFailure("source point has nontrivial projective stabilizer") from error

    last_error = None
    for option in options:
        try:
            conjugates = []
            resolvents = []
            b_determinants = []
            for representative in class_data["coset_representatives"]:
                moved_vector = mat_vec(ctx["schur"][representative], vector, p)
                b_frame, resolvent = subgroup_quartic_frame(ctx, class_data, moved_vector)
                b_determinant = determinant(b_frame, p)
                require(b_determinant != 0, "singular conjugate quartic frame")
                y = [b_frame[row][0] for row in range(3)]
                require(any(y), "zero conjugate source point")
                canonical_point = phi_evaluate(covariants, option, y, p)
                require(any(canonical_point), "zero landing covariant")
                require(
                    canonical_cubic_value(
                        canonical_point, option["canonical_cubic_parameter"], p
                    ) == 0,
                    "canonical cubic landing failed",
                )
                installed_point = mat_vec(class_data["intertwiner"], canonical_point, p)
                require(any(installed_point), "zero installed point")
                require(klein_value(installed_point, p) == 0, "Klein landing failed")

                q_moved = mat_mul(ctx["weil"][representative], q_frame, p)
                q_moved_inverse = mat_mul(
                    q_inverse, mat_inverse(ctx["weil"][representative], p), p
                )
                assert mat_mul(q_moved_inverse, q_moved, p) == ident(5)
                descended_point = mat_vec(q_moved_inverse, installed_point, p)
                assert mat_vec(q_moved, descended_point, p) == installed_point
                require(any(descended_point), "zero descended point")
                require(
                    klein_value(mat_vec(q_moved, descended_point, p), p) == 0,
                    "full-twist cubic substitution failed",
                )
                conjugates.append(descended_point)
                resolvents.append(resolvent)
                b_determinants.append(b_determinant)

            try:
                resolvent_certificate = vandermonde_certificate(resolvents, p)
                noncollision = conjugate_noncollision_certificate(conjugates, p)
                ranks = rank_certificates(conjugates, p)
            except AssertionError as error:
                raise CandidateFailure("orbit distinctness/rank gate failed") from error

            base_phi = phi_evaluate(covariants, option, base_y, p)
            base_installed = mat_vec(class_data["intertwiner"], base_phi, p)
            base_descended = mat_vec(q_inverse, base_installed, p)
            assert conjugates[0] == base_descended

            return {
                "option": option,
                "base_quartic_frame": base_b,
                "base_quartic_frame_determinant": determinant(base_b, p),
                "base_source_point_y": base_y,
                "base_source_free_locus": free_locus,
                "base_resolvent_value": base_resolvent,
                "base_canonical_landing_point": base_phi,
                "base_installed_landing_point": base_installed,
                "base_full_twist_point": base_descended,
                "conjugate_quartic_frame_determinants": b_determinants,
                "conjugate_coset_representatives": [
                    list(g) for g in class_data["coset_representatives"]
                ],
                "resolvent": resolvent_certificate,
                "projective_noncollision": noncollision,
                "rank_certificates": ranks,
            }
        except CandidateFailure as error:
            last_error = error
    raise last_error or CandidateFailure("no landing option")


def evaluate_context(ctx, vector, certify=False, only_class=None):
    p = ctx["p"]
    vector = [value % p for value in vector]
    require(any(vector), "zero Schur witness")
    covariants, covariant_denominators = reduce_covariants(p)
    q_frame, scalar_invariant = schur_reynolds_frame(ctx, vector)
    q_determinant = determinant(q_frame, p)
    require(scalar_invariant != 0, "zero degree-eight scalar invariant")
    require(q_determinant != 0, "singular full Schur frame")
    q_inverse = mat_inverse(q_frame, p)

    class_results = []
    selected_classes = [
        class_data
        for class_data in ctx["classes"]
        if only_class is None or class_data["class_index"] == only_class
    ]
    assert selected_classes
    for class_data in selected_classes:
        class_index = class_data["class_index"]
        preferred = ctx["spec"]["preferred_alpha"].get(class_index)
        options = point_options(ctx, class_data, covariants, preferred)
        class_result = evaluate_class(
            ctx, class_data, covariants, options, vector, q_frame, q_inverse
        )
        class_results.append((class_data, class_result))

    if certify:
        # Directly replay the two generator covariance identities for Q.
        for generator in (FS, FT):
            moved = mat_vec(ctx["schur"][generator], vector, p)
            moved_frame, moved_scalar = schur_reynolds_frame(ctx, moved)
            assert moved_frame == mat_mul(ctx["weil"][generator], q_frame, p)
            assert moved_scalar == scalar_invariant

        # Check H-invariance of the descended point at all 60 elements, not
        # merely at the presentation generators.
        for class_data, result in class_results:
            option = result["option"]
            base_point = result["base_full_twist_point"]
            base_b = result["base_quartic_frame"]
            base_resolvent = result["base_resolvent_value"]
            for h in class_data["subgroup"]:
                moved = mat_vec(ctx["schur"][h], vector, p)
                moved_b, moved_resolvent = subgroup_quartic_frame(ctx, class_data, moved)
                assert moved_b == mat_mul(class_data["sigma"][h], base_b, p)
                assert moved_resolvent == base_resolvent
                moved_y = [moved_b[row][0] for row in range(3)]
                moved_phi = phi_evaluate(covariants, option, moved_y, p)
                moved_installed = mat_vec(class_data["intertwiner"], moved_phi, p)
                moved_q = mat_mul(ctx["weil"][h], q_frame, p)
                moved_descended = mat_vec(mat_inverse(moved_q, p), moved_installed, p)
                assert moved_descended == base_point

    records = []
    for class_data, result in class_results:
        option = result["option"]
        records.append(
            {
                "class": f"A5_class_{class_data['class_index']}",
                "subgroup_order": len(class_data["subgroup"]),
                "subgroup_index": len(GROUP) // len(class_data["subgroup"]),
                "subgroup_generators": [list(g) for g in class_data["generators"]],
                "source_map_presentation_images": [list(PA), list(PB)],
                "canonical_to_installed_intertwiner_J": class_data["intertwiner"],
                "intertwiner_determinant": class_data["intertwiner_determinant"],
                "selected_alpha": option["alpha"],
                "available_alpha_roots_considered": option["all_alpha_roots"],
                "landing_parameter_vector": option["parameter_vector"],
                "canonical_cubic_parameter": option["canonical_cubic_parameter"],
                "point_input_denominators": option["point_denominators"],
                "quartic_reynolds_formula": "B_i(v)=sum_{h in H_i} sigma_i(h)^(-1)*((rho6(h)v)_5)^4",
                "point_orbit_separator_formula": "r_i(v)=sum_{h in H_i} ((rho6(h)v)_5)^4",
                "base_quartic_frame_B": result["base_quartic_frame"],
                "base_quartic_frame_determinant": result["base_quartic_frame_determinant"],
                "base_source_point_y_equals_Be0": result["base_source_point_y"],
                "base_source_free_locus": result["base_source_free_locus"],
                "base_canonical_landing_point": result["base_canonical_landing_point"],
                "base_installed_landing_point": result["base_installed_landing_point"],
                "base_full_twist_point": result["base_full_twist_point"],
                "conjugate_coset_representatives": result["conjugate_coset_representatives"],
                "conjugate_quartic_frame_determinants": result["conjugate_quartic_frame_determinants"],
                "point_orbit_separator": result["resolvent"],
                "projective_noncollision": result["projective_noncollision"],
                **result["rank_certificates"],
                "all_60_H_invariance_checks": bool(certify),
                "all_11_canonical_and_installed_cubic_landings": True,
            }
        )

    return {
        "role": ctx["spec"]["role"],
        "prime": p,
        "zeta11": ctx["spec"]["zeta11"],
        "sqrt5": ctx["spec"]["sqrt5"],
        "sqrt_minus11": ctx["spec"]["sqrt_minus11"],
        "gauss_sum": ctx["gauss"],
        "integer_witness_reduced": vector,
        "group_order": len(GROUP),
        "weil_W5_generators_ST": [
            ctx["weil_generators"]["S"], ctx["weil_generators"]["T"]
        ],
        "schur_V6_supporting_generators_AB": [
            ctx["schur_ab"]["A"], ctx["schur_ab"]["B"]
        ],
        "schur_V6_generators_ST": [
            ctx["schur_generators"]["S"], ctx["schur_generators"]["T"]
        ],
        "icosahedral_source_presentation_permutations": [
            list(ctx["source_generators"][0]), list(ctx["source_generators"][1])
        ],
        "icosahedral_source_generator_matrices": list(ctx["source_generator_matrices"]),
        "degree11_covariant_input_denominators": covariant_denominators,
        "full_schur_reynolds_formula": "Q_rj(v)=sum_{g in G}(rho5(g)^(-1))_rj*((rho6(g)v)_5)^8",
        "full_schur_frame_Q": q_frame,
        "full_schur_scalar_I8": scalar_invariant,
        "full_schur_frame_determinant": q_determinant,
        "direct_Q_covariance_checks_for_ST": bool(certify),
        "classes": records,
    }


def candidate_stream():
    initial = (
        (1, 2, 3, 4, 5, 6),
        (1, 1, 2, 3, 5, 8),
        (1, 3, 4, 7, 11, 18),
        (2, 5, 7, 11, 13, 17),
    )
    yield from initial
    state = 20260801
    for _ in range(500):
        values = []
        for _ in range(6):
            state = (1103515245 * state + 12345) % (2 ** 31)
            values.append(1 + state % 97)
        yield tuple(values)


def file_record(path):
    return {
        "path_relative_to_problem": str(path.relative_to(PROBLEM)),
        "sha256": sha256(path.read_bytes()).hexdigest(),
    }


def main():
    contexts = [representation_context(spec) for spec in PRIME_SPECS]
    # The p=89 witnesses were independently found before this consolidated
    # replay.  Each class is allowed its own specialization of the generic
    # Schur source; the finite-field rank statement does not require a common
    # specialization for the two unrelated A5 classes.
    preferred_witnesses = {
        1: (22, 2, 13, 21, 22, 4),
        2: (71, 10, 17, 18, 13, 44),
    }
    prime_records = []
    search_records = []
    for ctx in contexts:
        class_runs = []
        for class_index in (1, 2):
            failures = []
            attempts = 0
            witness = None
            # Try the p=89 certificate witness first at the unused holdout.
            candidates = [preferred_witnesses[class_index]] + list(candidate_stream())
            seen = set()
            for candidate in candidates:
                if candidate in seen:
                    continue
                seen.add(candidate)
                attempts += 1
                try:
                    evaluate_context(
                        ctx, candidate, certify=False, only_class=class_index
                    )
                    witness = candidate
                    break
                except (CandidateFailure, AssertionError, ZeroDivisionError) as error:
                    if len(failures) < 12:
                        failures.append({"witness": list(candidate), "reason": str(error)})
            assert witness is not None
            run = evaluate_context(
                ctx, witness, certify=True, only_class=class_index
            )
            assert len(run["classes"]) == 1
            class_runs.append(run)
            search_records.append(
                {
                    "prime": ctx["p"],
                    "class": f"A5_class_{class_index}",
                    "integer_witness": list(witness),
                    "attempts": attempts,
                    "used_p89_preferred_witness": witness == preferred_witnesses[class_index],
                    "recorded_early_failures": failures,
                }
            )
        prime_records.append(
            {
                "role": ctx["spec"]["role"],
                "prime": ctx["p"],
                "class_witness_runs": class_runs,
            }
        )

    payload = {
        "format": "a5q-modular-index11-discovery-v1",
        "scope": (
            "finite-field discovery and replay only; this does not construct the "
            "characteristic-zero fixed fields or prove the A5Q headline"
        ),
        "input_files": {
            "degree11_covariants": file_record(COVARIANT_PATH),
            "point_class_1": file_record(POINT_PATHS[1]),
            "point_class_2": file_record(POINT_PATHS[2]),
        },
        "abstract_group": {
            "model": "SL2(F11)/{+I,-I} with lexicographic sign canonicalization",
            "order": len(GROUP),
            "generators_ST": [list(FS), list(FT)],
            "relations_in_W5": ["S^2=1", "T^11=1", "(ST)^3=1"],
            "projective_relations_in_V6": ["S^2=-1", "T^11=1", "(ST)^3=-1"],
            "maximal_A5_class_count": 2,
            "A5_class_orbit_sizes": [11, 11],
        },
        "deterministic_search": {
            "class_specific_witnesses": True,
            "initial_candidates_then_lcg": True,
            "records": search_records,
            "p89_certificate_witnesses_tried_first_at_p199": True,
        },
        "required_gates": {
            "all_rational_input_denominators_nonzero": True,
            "all_J_B_Q_determinants_nonzero": True,
            "all_selected_alpha_relations": True,
            "all_source_points_in_free_projective_A5_locus": True,
            "all_11_point_orbit_separator_values_distinct": True,
            "separator_is_not_the_audited_primitive_tau_resolvent": True,
            "all_11_full_twist_points_projectively_distinct": True,
            "all_11_cubic_landings": True,
            "coordinate_matrix_rank": 5,
            "pairwise_product_matrix_rank": 11,
            "p89_discovery_and_p199_holdout": True,
        },
        "primes": prime_records,
        "terminal_marker": "A5Q_MODULAR_INDEX11_DISCOVERY_REPLAY_OK",
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    for prime_record in prime_records:
        for run in prime_record["class_witness_runs"]:
            row = run["classes"][0]
            print(
                f"p={run['prime']} class={row['class']} "
                f"witness={tuple(run['integer_witness_reduced'])} "
                f"detQ={run['full_schur_frame_determinant']} "
                f"alpha={row['selected_alpha']},detJ={row['intertwiner_determinant']},"
                f"rank={row['coordinate_rank']},sym2={row['pairwise_product_rank']}"
            )
    print("A5Q_MODULAR_INDEX11_DISCOVERY_REPLAY_OK")


if __name__ == "__main__":
    main()
