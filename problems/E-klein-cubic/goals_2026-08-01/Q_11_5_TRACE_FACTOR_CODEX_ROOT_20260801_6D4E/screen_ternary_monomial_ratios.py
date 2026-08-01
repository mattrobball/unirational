#!/usr/bin/env python3
"""Exact support screen for ternary Kummer vectors with Laurent ratios.

For each p<q<r, test b=alpha^p+c*U^u*alpha^q+d*U^v*alpha^r.
Any solution whose collision equations span rank two is among the finite
candidate list reconstructed from two term collisions.
"""

from __future__ import annotations

from fractions import Fraction
from itertools import combinations, product
from math import gcd

from factor_binary_kummer_singular import trace


Param = tuple[int, int]
Exponent = tuple[int, int, int, int]


def add_sparse(target, source):
    for exponent, coefficient in source.items():
        target[exponent] = target.get(exponent, trace.ZERO) + coefficient
        if not target[exponent]:
            del target[exponent]


def components(indices: tuple[int, int, int]):
    output = {(a, b): {} for a in range(4) for b in range(4-a)}
    for first, second, third in product(range(3), repeat=3):
        param = (
            int(first == 1) + int(second == 1) + int(third == 1),
            int(first == 2) + int(second == 2) + int(third == 2),
        )
        shift = indices[first] + indices[second] + indices[third]
        add_sparse(output[param], trace.trace_component(shift, trace.Z**indices[third]))
    return {key: value for key, value in output.items() if value}


def solve_two_equations(first, second):
    # Each equation is (A,B,D), meaning A*u+B*v=D componentwise.
    a, b, d = first
    c, e, f = second
    determinant = a*e-b*c
    if determinant == 0:
        return None
    u = tuple(Fraction(e*x-b*y, determinant) for x, y in zip(d, f))
    v = tuple(Fraction(a*y-c*x, determinant) for x, y in zip(d, f))
    if any(value.denominator != 1 for value in u+v):
        return None
    return tuple(int(value) for value in u), tuple(int(value) for value in v)


def collision_equation(left, right):
    (left_param, left_exp), (right_param, right_exp) = left, right
    return (
        left_param[0]-right_param[0],
        left_param[1]-right_param[1],
        tuple(y-x for x, y in zip(left_exp, right_exp)),
    )


def shifted_key(param: Param, exponent: Exponent, u: Exponent, v: Exponent):
    return tuple(x+param[0]*a+param[1]*b for x, a, b in zip(exponent, u, v))


def support_survives(terms, u, v):
    groups = {}
    for param, exponent in terms:
        groups.setdefault(shifted_key(param, exponent, u, v), []).append((param, exponent))
    return all(len(group) >= 2 for group in groups.values()), groups


def primitive_direction(vector):
    divisor = gcd(abs(vector[0]), abs(vector[1]))
    answer = (vector[0]//divisor, vector[1]//divisor)
    if answer[0] < 0 or (answer[0] == 0 and answer[1] < 0):
        answer = (-answer[0], -answer[1])
    return answer


def verify_rank_one_impossible(parameter_set):
    directions = {
        primitive_direction((left[0]-right[0], left[1]-right[1]))
        for left_index, left in enumerate(parameter_set)
        for right in parameter_set[left_index+1:]
    }
    for direction in directions:
        isolated = []
        for point in parameter_set:
            neighbors = [
                other for other in parameter_set if other != point
                and primitive_direction(
                    (point[0]-other[0], point[1]-other[1])
                ) == direction
            ]
            if not neighbors:
                isolated.append(point)
        assert isolated, (direction, parameter_set)
    return len(directions)


def main() -> None:
    parameter_set = sorted((a, b) for a in range(4) for b in range(4-a))
    direction_count = verify_rank_one_impossible(parameter_set)
    print(
        f"RANK_ONE_COLLISION_SPAN_IMPOSSIBLE directions={direction_count} "
        "reason=each_direction_has_isolated_parameter_vertex"
    )
    total_candidates = 0
    total_survivors = 0
    for indices in combinations(range(5), 3):
        parts = components(indices)
        assert set(parts) == set(parameter_set)
        assert all(len(part) == 7 for part in parts.values())
        terms = [(param, exponent) for param, part in parts.items() for exponent in part]
        anchor = ((0, 0), next(iter(parts[(0, 0)])))
        anchor_equations = [collision_equation(anchor, term) for term in terms if term != anchor]
        all_equations = [collision_equation(left, right)
                         for left_index, left in enumerate(terms)
                         for right in terms[left_index+1:]]
        candidates = set()
        for first in anchor_equations:
            for second in all_equations:
                solution = solve_two_equations(first, second)
                if solution is not None:
                    candidates.add(solution)
        survivors = []
        for u, v in sorted(candidates):
            survives, groups = support_survives(terms, u, v)
            if survives:
                survivors.append((u, v, len(groups)))
        total_candidates += len(candidates)
        total_survivors += len(survivors)
        print(
            f"TRIPLE {indices} CANDIDATES {len(candidates)} "
            f"RANK2_SUPPORT_SURVIVORS {len(survivors)}"
        )
        for survivor in survivors[:20]:
            print(f"SURVIVOR {indices} {survivor}")
    print(f"TOTAL_CANDIDATES {total_candidates}")
    print(f"TOTAL_RANK2_SUPPORT_SURVIVORS {total_survivors}")
    assert total_candidates == 66144 and total_survivors == 0
    print("H_TRACE_FOURIER_TERNARY_LAURENT_EXCLUSION_OK")


if __name__ == "__main__":
    main()
