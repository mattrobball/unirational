#!/usr/bin/env python3
"""Enumerate exact full-rank collision candidates for four Kummer terms."""

from __future__ import annotations

from fractions import Fraction
from itertools import combinations
from math import gcd

from screen_four_modular import contributions, four_components
from screen_four_modular import EXPECTED_MOD3_BASES


def canonical_equation(left, right):
    counts1, exp1 = left
    counts2, exp2 = right
    direction = tuple(counts1[i]-counts2[i] for i in range(1, 4))
    if direction == (0, 0, 0):
        return None
    delta = tuple(y-x for x, y in zip(exp1, exp2))
    first = next(value for value in direction if value)
    if first < 0:
        direction = tuple(-value for value in direction)
        delta = tuple(-value for value in delta)
    return direction, delta


def determinant(rows):
    (a,b,c),(d,e,f),(g,h,i) = rows
    return a*(e*i-f*h)-b*(d*i-f*g)+c*(d*h-e*g)


def solve(rows, deltas):
    det = determinant(rows)
    if det == 0:
        return None
    # Cramer's rule independently in the four exponent coordinates.
    columns = [[], [], []]
    for coordinate in range(4):
        rhs = [delta[coordinate] for delta in deltas]
        for column in range(3):
            matrix = [list(row) for row in rows]
            for row in range(3):
                matrix[row][column] = rhs[row]
            numerator = determinant(tuple(tuple(row) for row in matrix))
            if numerator % det:
                return None
            columns[column].append(numerator//det)
    return tuple(tuple(column) for column in columns)


def exact_survives(items, shifts):
    groups = {}
    for counts, exponent in items:
        target = tuple(
            exponent[k]+sum(counts[j+1]*shifts[j][k] for j in range(3))
            for k in range(4)
        )
        groups[target] = groups.get(target, 0)+1
    return min(groups.values()) >= 2


def filtered_direction_table(items, base, modulus=3):
    equations = {
        equation
        for left, right in combinations(items, 2)
        if (equation := canonical_equation(left, right)) is not None
    }
    table = {}
    for direction, delta in equations:
        predicted = tuple(
            sum(direction[j]*base[j][k] for j in range(3)) % modulus
            for k in range(4)
        )
        if predicted == tuple(value % modulus for value in delta):
            table.setdefault(direction, set()).add(delta)
    return equations, table


def main():
    total_candidates = 0
    total_survivors = 0
    for indices in combinations(range(5), 4):
        items = contributions(four_components(indices))
        equations, table = filtered_direction_table(items, EXPECTED_MOD3_BASES[indices])
        direction_triples = []
        system_count = 0
        directions = sorted(table)
        for rows in combinations(directions, 3):
            if determinant(rows) == 0:
                continue
            direction_triples.append(rows)
            system_count += len(table[rows[0]])*len(table[rows[1]])*len(table[rows[2]])
        print(
            f"QUADRUPLE {indices} EQUATIONS {len(equations)} "
            f"FILTERED {sum(map(len,table.values()))} DIRECTIONS {len(table)} "
            f"INDEPENDENT_DIRECTION_TRIPLES {len(direction_triples)} "
            f"SYSTEMS {system_count}"
        )
        candidates = set()
        for rows in direction_triples:
            for d1 in table[rows[0]]:
                for d2 in table[rows[1]]:
                    for d3 in table[rows[2]]:
                        solution = solve(rows, (d1,d2,d3))
                        if solution is not None:
                            candidates.add(solution)
        survivors = [solution for solution in candidates if exact_survives(items, solution)]
        total_candidates += len(candidates)
        total_survivors += len(survivors)
        print(
            f"QUADRUPLE {indices} INTEGRAL_CANDIDATES {len(candidates)} "
            f"RANK3_SUPPORT_SURVIVORS {len(survivors)}"
        )
        for survivor in survivors[:20]:
            print(f"SURVIVOR {indices} {survivor}")
    print(f"TOTAL_INTEGRAL_CANDIDATES {total_candidates}")
    print(f"TOTAL_RANK3_SUPPORT_SURVIVORS {total_survivors}")
    assert total_candidates == 177365 and total_survivors == 0
    print("H_TRACE_FOUR_KUMMER_RANK3_EXCLUSION_OK")


if __name__ == "__main__":
    main()
