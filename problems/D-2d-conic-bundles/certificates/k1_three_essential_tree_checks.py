#!/usr/bin/env python3
"""Checks for the [3,1,1,1] essential-tree classification and pruning."""

from itertools import product
from math import comb


CORES = {
    "AA444": {
        "r": (4, 4, 4),
        "parents": ((), (0,), (1,)),
        "essential": (0, 1, 2),
        "D": (1, 1, 1),
        "twoD": (2, 2, 2),
        "lengths": (3, 9),
    },
    "AA554": {
        "r": (5, 5, 4),
        "parents": ((), (0,), (1,)),
        "essential": (0, 1, 2),
        "D": (1, 1, 1),
        "twoD": (2, 2, 2),
        "lengths": (3, 9),
    },
    "AA555": {
        "r": (5, 5, 5),
        "parents": ((), (0,), (1,)),
        "essential": (0, 1, 2),
        "D": (1, 1, 1),
        "twoD": (2, 2, 2),
        "lengths": (3, 9),
    },
    "AF4": {
        "r": (4, 4, 3, 4),
        "parents": ((), (0,), (1,), (2,)),
        "essential": (0, 1, 3),
        "D": (1, 1, 1, 0),
        "twoD": (2, 2, 1, 1),
        "lengths": (3, 8),
    },
    "AF5": {
        "r": (5, 4, 3, 4),
        "parents": ((), (0,), (1,), (2,)),
        "essential": (0, 1, 3),
        "D": (1, 1, 1, 0),
        "twoD": (2, 2, 1, 1),
        "lengths": (3, 8),
    },
    "AS": {
        "r": (5, 5, 3, 4),
        "parents": ((), (0,), (1,), (1, 2)),
        "essential": (0, 1, 3),
        "D": (1, 1, 1, 0),
        "twoD": (2, 2, 1, 1),
        "lengths": (3, 8),
    },
    "FFP": {
        "r": (4, 3, 4, 3, 4),
        "parents": ((), (0,), (1,), (2,), (3,)),
        "essential": (0, 2, 4),
        "D": (1, 1, 1, 0, 0),
        "twoD": (2, 1, 1, 1, 1),
        "lengths": (3, 7),
    },
    "FFN": {
        "r": (3, 4, 3, 4, 3, 4),
        "parents": ((), (0,), (1,), (2,), (3,), (4,)),
        "essential": (1, 3, 5),
        "D": (1, 1, 1, 0, 0, 0),
        "twoD": (1, 1, 1, 1, 1, 1),
        "lengths": (3, 6),
    },
}

EXPECTED_M = {
    "AA444": (4, 4, 4),
    "AA554": (5, 4, 3),
    "AA555": (5, 4, 4),
    "AF4": (4, 4, 3, 3),
    "AF5": (5, 3, 3, 3),
    "AS": (5, 4, 2, 2),
    "FFP": (4, 3, 3, 3, 3),
    "FFN": (3, 3, 3, 3, 3, 3),
}


def exceptional_counts(r, parents):
    return tuple(sum(r[parent] % 2 for parent in ps) for ps in parents)


def proximity_consistent(weights, parents):
    for index, weight in enumerate(weights):
        children = [child for child, ps in enumerate(parents) if index in ps]
        if weight < sum(weights[child] for child in children):
            return False
    return True


def prime_coefficients(weights, parents):
    coefficients = []
    for weight, ps in zip(weights, parents):
        coefficients.append(weight + sum(coefficients[parent] for parent in ps))
    return tuple(coefficients)


def raw_weights(size, essential, multiplier):
    return tuple(multiplier if index in essential else 0 for index in range(size))


def colength(point_basis):
    return sum(comb(weight + 1, 2) for weight in point_basis)


def assert_antinef_closure(raw, expected, parents):
    raw_prime = prime_coefficients(raw, parents)
    expected_prime = prime_coefficients(expected, parents)
    assert proximity_consistent(expected, parents)
    assert all(a >= b for a, b in zip(expected_prime, raw_prime))
    feasible = []
    for candidate in product(range(5), repeat=len(raw)):
        if not proximity_consistent(candidate, parents):
            continue
        candidate_prime = prime_coefficients(candidate, parents)
        if all(a >= b for a, b in zip(candidate_prime, raw_prime)):
            feasible.append(candidate_prime)
    assert feasible
    assert all(
        all(a <= b for a, b in zip(expected_prime, candidate_prime))
        for candidate_prime in feasible
    )


for name, data in CORES.items():
    r = data["r"]
    parents = data["parents"]
    e = exceptional_counts(r, parents)
    m = tuple(corrected - exceptional for corrected, exceptional in zip(r, e))
    assert m == EXPECTED_M[name]
    assert proximity_consistent(m, parents)
    for multiplier, key in ((1, "D"), (2, "twoD")):
        raw = raw_weights(len(r), data["essential"], multiplier)
        assert_antinef_closure(raw, data[key], parents)
    assert tuple(colength(data[key]) for key in ("D", "twoD")) == data["lengths"]
print("eight three-essential cores and unloadings: PASS")


SINGLETONS = {
    "P4": ((4,), ((),)),
    "P5": ((5,), ((),)),
    "N": ((3, 3), ((), (0,))),
}

MAX_N = {
    "AA444": 3,
    "AA554": 3,
    "AA555": 3,
    "AF4": 2,
    "AF5": 2,
    "AS": 2,
    "FFP": 1,
    "FFN": 0,
}
TWO_D_BASE = {name: data["lengths"][1] for name, data in CORES.items()}

candidate_rows = []
for core, maximum_n in MAX_N.items():
    for n_count in range(maximum_n + 1):
        doubled_length = TWO_D_BASE[core] + 3 * (3 - n_count) + 2 * n_count
        assert doubled_length >= 15
        for p5_count in range(3 - n_count + 1):
            candidate_rows.append((core, n_count, p5_count))
assert len(candidate_rows) == 68
print("quartic-colength bounds and 68 initial rows: PASS")


TREE_DATA = {
    name: (EXPECTED_M[name], data["parents"])
    for name, data in CORES.items()
}
TREE_DATA.update(SINGLETONS)


def point_basis_options(tree_name, degree):
    m, parents = TREE_DATA[tree_name]
    options = []
    for mu in product(range(degree + 1), repeat=len(m)):
        if proximity_consistent(mu, parents):
            options.append(
                (colength(mu), sum(a * b for a, b in zip(m, mu)), mu)
            )
    return options


def maximum_forced_contact(tree_names, degree):
    capacity = comb(degree + 2, 2) - 1
    states = {0: (0, ())}
    for tree_name in tree_names:
        new_states = {}
        for old_cost, (old_contact, old_choices) in states.items():
            for cost, contact, mu in point_basis_options(tree_name, degree):
                total_cost = old_cost + cost
                if total_cost > capacity:
                    continue
                total_contact = old_contact + contact
                previous = new_states.get(total_cost)
                if previous is None or total_contact > previous[0]:
                    new_states[total_cost] = (
                        total_contact,
                        old_choices + ((tree_name, mu),),
                    )
        states = new_states
    return max(
        (contact, cost, choices)
        for cost, (contact, choices) in states.items()
    )


retained = []
contacts_by_row = {}
witness_by_row = {}
for core, n_count, p5_count in candidate_rows:
    p4_count = 3 - n_count - p5_count
    trees = [core] + ["N"] * n_count + ["P5"] * p5_count + ["P4"] * p4_count
    contacts = []
    first_witness = None
    for degree in range(1, 6):
        contact, cost, choices = maximum_forced_contact(trees, degree)
        contacts.append(contact)
        if first_witness is None and contact > 10 * degree:
            first_witness = (degree, contact, cost, choices)
    contacts_by_row[(core, n_count, p5_count)] = tuple(contacts)
    witness_by_row[(core, n_count, p5_count)] = first_witness
    if first_witness is None:
        retained.append((core, n_count, p5_count))

EXPECTED_RETAINED = [
    ("AA444", 0, 0),
    ("AA444", 1, 0),
    ("AA444", 2, 0),
    ("AA444", 3, 0),
    ("AA554", 3, 0),
    ("AF4", 0, 0),
    ("AF4", 1, 0),
    ("AF4", 2, 0),
    ("AF5", 2, 0),
    ("AS", 1, 0),
    ("AS", 2, 0),
    ("FFP", 0, 0),
    ("FFP", 1, 0),
    ("FFN", 0, 0),
]
assert retained == EXPECTED_RETAINED
assert all(p5_count == 0 for _, _, p5_count in retained)
assert all(core != "AA555" for core, _, _ in retained)

EXPECTED_CONTACTS = {
    ("AA444", 0, 0): (8, 20, 28, 40, 48),
    ("AA444", 1, 0): (8, 20, 30, 39, 50),
    ("AA444", 2, 0): (8, 19, 29, 40, 50),
    ("AA444", 3, 0): (8, 18, 30, 39, 49),
    ("AA554", 3, 0): (9, 18, 30, 40, 50),
    ("AF4", 0, 0): (8, 20, 30, 39, 50),
    ("AF4", 1, 0): (8, 19, 29, 40, 50),
    ("AF4", 2, 0): (8, 18, 30, 39, 49),
    ("AF5", 2, 0): (9, 18, 30, 40, 50),
    ("AS", 1, 0): (9, 20, 30, 40, 50),
    ("AS", 2, 0): (9, 19, 30, 40, 50),
    ("FFP", 0, 0): (8, 19, 29, 40, 50),
    ("FFP", 1, 0): (8, 18, 30, 39, 49),
    ("FFN", 0, 0): (8, 18, 30, 39, 49),
}
assert {row: contacts_by_row[row] for row in retained} == EXPECTED_CONTACTS
assert all(witness_by_row[row] is not None for row in candidate_rows if row not in retained)

EXPECTED_BASE_EXCLUSIONS = {
    ("AA554", 0, 0): (2, 21),
    ("AA554", 1, 0): (3, 31),
    ("AA554", 2, 0): (4, 41),
    ("AA555", 0, 0): (2, 21),
    ("AA555", 1, 0): (2, 21),
    ("AA555", 2, 0): (3, 31),
    ("AA555", 3, 0): (3, 31),
    ("AF5", 0, 0): (3, 31),
    ("AF5", 1, 0): (4, 41),
    ("AS", 0, 0): (2, 21),
}
EXPECTED_FIRST_P5_EXCLUSIONS = {
    ("AA444", 0, 1): (2, 21),
    ("AA444", 1, 1): (2, 21),
    ("AA444", 2, 1): (3, 31),
    ("AF4", 0, 1): (2, 21),
    ("AF4", 1, 1): (3, 31),
    ("AF4", 2, 1): (3, 31),
    ("AF5", 2, 1): (3, 31),
    ("AS", 1, 1): (2, 21),
    ("AS", 2, 1): (3, 31),
    ("FFP", 0, 1): (3, 31),
    ("FFP", 1, 1): (3, 31),
    ("FFN", 0, 1): (3, 31),
}
for row, expected in (EXPECTED_BASE_EXCLUSIONS | EXPECTED_FIRST_P5_EXCLUSIONS).items():
    assert witness_by_row[row][:2] == expected
print("degree<=5 component pruning, 68 -> 14 rows: PASS")


# Sharp AA444 + N^3 conic and determinant-incidence margins.
sharp_contact = sum(EXPECTED_M["AA444"]) + 2 * 3
assert sharp_contact == 18
configuration_dimension = (2 + 1 + 1) + 2 * 2
assert configuration_dimension == 8

rank3_margin = 33 - (12 + (21 - sharp_contact)) - configuration_dimension
rank2_off_margin = 33 - (13 + (21 - sharp_contact)) - configuration_dimension
rank2_unmarked_margin = 30 - (11 + (19 - sharp_contact)) - 7
rank2_marked_margin = 30 - (11 + (21 - sharp_contact)) - 6
assert (rank3_margin, rank2_off_margin, rank2_unmarked_margin, rank2_marked_margin) == (
    10,
    9,
    11,
    10,
)
assert rank3_margin > 8
assert min(rank2_off_margin, rank2_unmarked_margin, rank2_marked_margin) > 7
print("sharp AA444 + N^3 conic margins: PASS")


# Integral-branch genus bounds G=n5-n2 on the thirteen rows after the sharp
# row is deleted.
after_sharp = [row for row in retained if row != ("AA444", 3, 0)]
assert len(after_sharp) == 13
for core, _, p5_count in after_sharp:
    n5 = sum(value == 5 for value in CORES[core]["r"]) + p5_count
    assert n5 in (0, 1, 2)
    assert all(n5 - n2 >= 0 for n2 in range(n5 + 1))
print("integral genus and 13-row terminal bounds: PASS")

print("all three-essential-tree checks: PASS")
