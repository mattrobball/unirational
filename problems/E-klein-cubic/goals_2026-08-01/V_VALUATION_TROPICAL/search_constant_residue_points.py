#!/usr/bin/env python3
"""Exact good-prime screen for constant residue coordinates at f5 and f6.

At a divisor with a unit weight-one gauge q, normalize the five primitive
Hilbert--90 columns x,C,D,E,K by q^(1,4,5,6,7).  A point with constant frame
coordinates [a0:...:a4] would satisfy the resulting cubic at every source
point of the divisor.  We collect independent necessary cubic equations over
F_67 and test every projective chart by Groebner bases.

Projective emptiness of the sampled locus is a rigorous exclusion of this
constant-coordinate ansatz in characteristic zero.  A survivor is discovery
only.  This script does not write files.
"""

from __future__ import annotations

import itertools
import random
import sys
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
sys.path.insert(0, str(PROBLEM / "tmp" / "generic_twist"))
sys.path.insert(0, str(PROBLEM / "tmp" / "kproj_arithmetic"))

from phi_coefficients import all_coefficients, evaluate_vector  # noqa: E402
from core import evaluate_mod, forms  # noqa: E402


PRIME = 67
FRAME_DEGREES = (1, 4, 5, 6, 7)


def compositions(total, length):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for tail in compositions(total - first, length - 1):
            yield (first,) + tail


MONOMIALS = tuple(compositions(3, 5))
MONOMIAL_INDEX = {exponents: index for index, exponents in enumerate(MONOMIALS)}


def cubic_row(vectors):
    row = [0] * len(MONOMIALS)
    for coordinate in range(5):
        following = (coordinate + 1) % 5
        for left, middle, right in itertools.product(range(5), repeat=3):
            coefficient = (
                vectors[left][coordinate]
                * vectors[middle][coordinate]
                * vectors[right][following]
            ) % PRIME
            if not coefficient:
                continue
            exponents = [0] * 5
            exponents[left] += 1
            exponents[middle] += 1
            exponents[right] += 1
            slot = MONOMIAL_INDEX[tuple(exponents)]
            row[slot] = (row[slot] + coefficient) % PRIME
    return row


def add_echelon(basis, row):
    row = [entry % PRIME for entry in row]
    for pivot, old in basis:
        if row[pivot]:
            multiplier = row[pivot]
            row = [(a - multiplier * b) % PRIME for a, b in zip(row, old)]
    try:
        pivot = next(index for index, entry in enumerate(row) if entry)
    except StopIteration:
        return False
    inverse = pow(row[pivot], -1, PRIME)
    row = [entry * inverse % PRIME for entry in row]
    basis.append((pivot, row))
    return True


def normalized_frame(point, frame, target, invariant_forms):
    values = {degree: evaluate_mod(polynomial, point, PRIME) for degree, polynomial in invariant_forms.items()}
    if target == 5:
        if not values[6] or not values[7]:
            return None
        gauge = values[7] * pow(values[6], -1, PRIME) % PRIME
    else:
        if not values[3] or not values[5]:
            return None
        gauge = values[3] ** 2 * pow(values[5], -1, PRIME) % PRIME
    if not gauge:
        return None
    columns = [evaluate_vector(vector, point) for vector in frame]
    return [
        [entry * pow(gauge, -degree, PRIME) % PRIME for entry in column]
        for degree, column in zip(FRAME_DEGREES, columns)
    ]


def row_polynomial(row, variables):
    return sum(
        coefficient
        * sp.prod(variable**exponent for variable, exponent in zip(variables, exponents))
        for coefficient, exponents in zip(row, MONOMIALS)
        if coefficient
    )


def chart_empty(polynomials, variables, chart):
    remaining = tuple(variable for index, variable in enumerate(variables) if index != chart)
    specialized = [sp.expand(polynomial.subs(variables[chart], 1)) for polynomial in polynomials]
    basis = sp.groebner(specialized, *remaining, modulus=PRIME, order="grevlex")
    return basis.contains(sp.Integer(1)), len(basis.polys)


def search(target):
    invariant_forms = forms()
    _, frame, _ = all_coefficients()
    rng = random.Random(2026080100 + target)
    echelon = []
    accepted_points = []
    attempts = 0
    stagnant = 0
    while len(echelon) < len(MONOMIALS) and stagnant < 250:
        attempts += 1
        point = tuple(rng.randrange(PRIME) for _ in range(5))
        if point == (0, 0, 0, 0, 0):
            continue
        if evaluate_mod(invariant_forms[target], point, PRIME):
            continue
        vectors = normalized_frame(point, frame, target, invariant_forms)
        if vectors is None:
            continue
        if add_echelon(echelon, cubic_row(vectors)):
            accepted_points.append(point)
            stagnant = 0
        else:
            stagnant += 1

    variables = sp.symbols("a0:5")
    polynomials = [row_polynomial(row, variables) for _, row in echelon]
    charts = [chart_empty(polynomials, variables, chart) for chart in range(5)]
    print(f"TARGET=f{target}")
    print(f"ATTEMPTS={attempts}")
    print(f"EQUATION_RANK={len(echelon)}")
    print(f"ACCEPTED_POINTS={accepted_points}")
    print(f"CHARTS={charts}")
    print(f"PROJECTIVELY_EMPTY={all(empty for empty, _ in charts)}")
    return all(empty for empty, _ in charts)


def main():
    results = {target: search(target) for target in (5, 6)}
    assert all(results.values())
    print("CONSTANT_RESIDUE_POINT_SCREEN_EXACT")


if __name__ == "__main__":
    main()
