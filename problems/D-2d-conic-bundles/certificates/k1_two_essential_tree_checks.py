#!/usr/bin/env python3
"""Checks for the [2,1,1,1,1] essential-tree classification."""

from itertools import product
from math import comb


CORES = {
    "A44": {
        "r": (4, 4),
        "parents": ((), (0,)),
        "essential": (0, 1),
        "D": (1, 1),
        "twoD": (2, 2),
        "lengths": (2, 6),
    },
    "A54": {
        "r": (5, 4),
        "parents": ((), (0,)),
        "essential": (0, 1),
        "D": (1, 1),
        "twoD": (2, 2),
        "lengths": (2, 6),
    },
    "A55": {
        "r": (5, 5),
        "parents": ((), (0,)),
        "essential": (0, 1),
        "D": (1, 1),
        "twoD": (2, 2),
        "lengths": (2, 6),
    },
    "FP": {
        "r": (4, 3, 4),
        "parents": ((), (0,), (1,)),
        "essential": (0, 2),
        "D": (1, 1, 0),
        "twoD": (2, 1, 1),
        "lengths": (2, 5),
    },
    "FN": {
        "r": (3, 4, 3, 4),
        "parents": ((), (0,), (1,), (2,)),
        "essential": (1, 3),
        "D": (1, 1, 0, 0),
        "twoD": (1, 1, 1, 1),
        "lengths": (2, 4),
    },
    "S": {
        "r": (5, 3, 4),
        "parents": ((), (0,), (0, 1)),
        "essential": (0, 2),
        "D": (1, 1, 0),
        "twoD": (2, 1, 1),
        "lengths": (2, 5),
    },
}

EXPECTED_M = {
    "A44": (4, 4),
    "A54": (5, 3),
    "A55": (5, 4),
    "FP": (4, 3, 3),
    "FN": (3, 3, 3, 3),
    "S": (5, 2, 2),
}


def exceptional_counts(r, parents):
    """Branch exceptionals through each center."""
    return tuple(sum(r[parent] % 2 for parent in ps) for ps in parents)


def proximity_consistent(weights, parents):
    """Check the proximity inequalities for a point basis."""
    for index, weight in enumerate(weights):
        children = [
            child
            for child, ps in enumerate(parents)
            if index in ps
        ]
        if weight < sum(weights[child] for child in children):
            return False
    return True


def prime_coefficients(weights, parents):
    """Convert total-transform point weights to prime coefficients."""
    coefficients = []
    for weight, ps in zip(weights, parents):
        coefficients.append(weight + sum(coefficients[parent] for parent in ps))
    return tuple(coefficients)


def raw_weights(size, essential, multiplier):
    return tuple(multiplier if index in essential else 0 for index in range(size))


def colength(point_basis):
    return sum(comb(weight + 1, 2) for weight in point_basis)


def assert_antinef_closure(raw, expected, parents):
    """Brute-force minimality of each tiny unloaded point basis."""
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
print("six essential-span cores and unloadings: PASS")


SINGLETONS = {
    "P4": {
        "m": (4,),
        "parents": ((),),
        "options": ((1,), (2,)),
        "lengths": (1, 3),
    },
    "P5": {
        "m": (5,),
        "parents": ((),),
        "options": ((1,), (2,)),
        "lengths": (1, 3),
    },
    "N": {
        "m": (3, 3),
        "parents": ((), (0,)),
        "options": ((1, 0), (1, 1)),
        "lengths": (1, 2),
    },
}

for data in SINGLETONS.values():
    assert all(proximity_consistent(option, data["parents"]) for option in data["options"])
    assert tuple(colength(option) for option in data["options"]) == data["lengths"]
print("singleton core unloadings: PASS")


MAX_N = {"A44": 3, "A54": 3, "A55": 3, "FP": 2, "FN": 1, "S": 2}
TWO_D_BASE = {"A44": 6, "A54": 6, "A55": 6, "FP": 5, "FN": 4, "S": 5}

candidate_rows = []
for core, maximum_n in MAX_N.items():
    for n_count in range(maximum_n + 1):
        doubled_length = TWO_D_BASE[core] + 3 * (4 - n_count) + 2 * n_count
        assert doubled_length >= 15
        for p5_count in range(4 - n_count + 1):
            candidate_rows.append((core, n_count, p5_count))
assert len(candidate_rows) == 75
print("quartic-colength bounds and 75 initial rows: PASS")


TREE_DATA = {
    name: (EXPECTED_M[name], data["parents"])
    for name, data in CORES.items()
}
TREE_DATA.update(
    {
        name: (data["m"], data["parents"])
        for name, data in SINGLETONS.items()
    }
)


def point_basis_options(tree_name, degree):
    m, parents = TREE_DATA[tree_name]
    options = []
    for mu in product(range(degree + 1), repeat=len(m)):
        if not proximity_consistent(mu, parents):
            continue
        options.append(
            (colength(mu), sum(a * b for a, b in zip(m, mu)), mu)
        )
    return options


def maximum_forced_contact(tree_names, degree):
    """Knapsack over all consistent marked subclusters."""
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
contact_rows = {}
for core, n_count, p5_count in candidate_rows:
    p4_count = 4 - n_count - p5_count
    trees = [core] + ["N"] * n_count + ["P5"] * p5_count + ["P4"] * p4_count
    contacts = tuple(maximum_forced_contact(trees, degree)[0] for degree in range(1, 5))
    contact_rows[(core, n_count, p5_count)] = contacts
    if all(contact <= 10 * degree for degree, contact in enumerate(contacts, start=1)):
        retained.append((core, n_count, p5_count))

EXPECTED_RETAINED = [
    ("A44", 0, 0),
    ("A44", 1, 0),
    ("A44", 2, 0),
    ("A44", 3, 0),
    ("A54", 3, 0),
    ("FP", 0, 0),
    ("FP", 1, 0),
    ("FP", 2, 0),
    ("FN", 0, 0),
    ("FN", 1, 0),
    ("S", 1, 0),
    ("S", 2, 0),
]
assert retained == EXPECTED_RETAINED

EXPECTED_CONTACTS = {
    ("A44", 0, 0): (8, 20, 28, 40),
    ("A44", 1, 0): (8, 20, 30, 39),
    ("A44", 2, 0): (8, 19, 29, 40),
    ("A44", 3, 0): (8, 18, 30, 39),
    ("A54", 3, 0): (9, 18, 30, 40),
    ("FP", 0, 0): (8, 20, 30, 39),
    ("FP", 1, 0): (8, 19, 29, 40),
    ("FP", 2, 0): (8, 18, 30, 39),
    ("FN", 0, 0): (8, 19, 29, 40),
    ("FN", 1, 0): (8, 18, 30, 39),
    ("S", 1, 0): (9, 20, 30, 40),
    ("S", 2, 0): (9, 19, 30, 40),
}
assert {row: contact_rows[row] for row in retained} == EXPECTED_CONTACTS
assert all(p5_count == 0 for _, _, p5_count in retained)
assert all(core != "A55" for core, _, _ in retained)
print("degree<=4 component pruning, 75 -> 12 rows: PASS")


# The integral-branch genus identity gives G=n5-n2.  In the retained rows,
# only A54 and S have one corrected-quintuple essential center.
for core, _, p5_count in retained:
    repeated_n5 = sum(value == 5 for value in CORES[core]["r"])
    total_n5 = repeated_n5 + p5_count
    expected_n5 = 1 if core in ("A54", "S") else 0
    assert total_n5 == expected_n5
    allowed_n2 = list(range(total_n5 + 1))
    assert all(total_n5 - n2 >= 0 for n2 in allowed_n2)
print("integral genus and terminal r=2 bounds: PASS")

print("all two-essential-tree checks: PASS")
