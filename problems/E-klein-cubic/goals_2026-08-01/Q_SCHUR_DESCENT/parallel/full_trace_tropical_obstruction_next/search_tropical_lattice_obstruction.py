#!/usr/bin/env python3
"""Discovery search for a monomial valuation with no integral tropical point.

This is reconnaissance.  Any candidate must receive an exact polyhedral
infeasibility certificate before it can support a theorem.
"""

from __future__ import annotations

from itertools import combinations_with_replacement, product
import json
from math import gcd
from pathlib import Path

import numpy as np
from scipy.optimize import Bounds, LinearConstraint, milp


HERE = Path(__file__).resolve().parent
PAYLOAD = HERE.parent / "h_trace_three_kummer_planes" / "payload.json"


def primitive(vector: tuple[int, ...]) -> bool:
    common = 0
    for entry in vector:
        common = gcd(common, abs(entry))
    return common == 1


def trace_support(payload: dict, degree: int) -> list[tuple[int, int, int, int]]:
    quotient, residue = divmod(degree, 5)
    answer = []
    for term in payload["trace_coefficients"][str(residue)]:
        exponents = list(map(int, term["u"]))
        exponents[0] += quotient
        answer.append(tuple(exponents))
    assert len(answer) == 7 and len(set(answer)) == 7
    return answer


def coefficient_terms(payload: dict):
    answer = []
    for triple in combinations_with_replacement(range(5), 3):
        monomial = tuple(triple.count(index) for index in range(5))
        answer.append((monomial, trace_support(payload, sum(triple))))
    assert len(answer) == 35
    return answer


def coefficient_valuations(terms, weight):
    return [min(sum(a * b for a, b in zip(weight, exponent)) for exponent in support)
            for _, support in terms]


def feasible_tie(terms, valuations, left: int, right: int):
    # Homogeneity permits x_0=0.  Variables are x_1,...,x_4 in Z.
    left_monomial = terms[left][0]
    right_monomial = terms[right][0]
    equality = np.array(
        [left_monomial[index] - right_monomial[index] for index in range(1, 5)],
        dtype=float,
    )
    equality_rhs = float(valuations[right] - valuations[left])
    rows = [equality]
    lower = [equality_rhs]
    upper = [equality_rhs]
    for index, (monomial, _) in enumerate(terms):
        row = np.array(
            [left_monomial[position] - monomial[position] for position in range(1, 5)],
            dtype=float,
        )
        rows.append(row)
        lower.append(-np.inf)
        upper.append(float(valuations[index] - valuations[left]))
    result = milp(
        c=np.zeros(4),
        integrality=np.ones(4),
        bounds=Bounds(lb=np.full(4, -np.inf), ub=np.full(4, np.inf)),
        constraints=LinearConstraint(np.vstack(rows), np.array(lower), np.array(upper)),
        options={"time_limit": 0.5, "presolve": True},
    )
    if result.status == 0:
        point = tuple(int(round(value)) for value in result.x)
        values = [
            valuation + sum(monomial[index] * point[index - 1] for index in range(1, 5))
            for (monomial, _), valuation in zip(terms, valuations)
        ]
        minimum = min(values)
        assert sum(value == minimum for value in values) >= 2
        return point
    if result.status == 2:
        return None
    # A timeout is not evidence of infeasibility; flag the weight as unresolved.
    raise RuntimeError(f"MILP status {result.status}: {result.message}")


def weight_has_integral_tropical_point(terms, weight):
    valuations = coefficient_valuations(terms, weight)
    for left in range(len(terms)):
        for right in range(left + 1, len(terms)):
            point = feasible_tie(terms, valuations, left, right)
            if point is not None:
                return point, valuations
    return None, valuations


def main() -> None:
    payload = json.loads(PAYLOAD.read_text())
    terms = coefficient_terms(payload)
    checked = 0
    for radius in range(1, 7):
        for weight in product(range(-radius, radius + 1), repeat=4):
            if max(map(abs, weight)) != radius or not primitive(weight):
                continue
            checked += 1
            point, valuations = weight_has_integral_tropical_point(terms, weight)
            if point is None:
                print(f"CANDIDATE_WEIGHT={weight}")
                print(f"COEFFICIENT_VALUATIONS={valuations}")
                print(f"WEIGHTS_CHECKED={checked}")
                print("TROPICAL_LATTICE_OBSTRUCTION_CANDIDATE_FOUND")
                return
        print(f"RADIUS_DONE={radius} WEIGHTS_CHECKED={checked}", flush=True)
    print(f"NO_CANDIDATE_WEIGHTS_CHECKED={checked}")
    print("TROPICAL_LATTICE_OBSTRUCTION_DISCOVERY_DONE")


if __name__ == "__main__":
    main()
