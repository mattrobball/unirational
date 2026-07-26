#!/usr/bin/env python3
"""Verify that the characteristic-23 ATLAS model has an exact 660-element lift.

The coefficient ``c`` satisfies ``c^2+c+3=0``.  Elements of ``Z[c]`` are
represented by pairs ``(a,b)=a+b*c``.  We traverse the Cayley graph using the
reductions of the two exact matrices at ``(23,c-4)`` and verify every modular
collision as an exact matrix equality.  Thus the modular Reynolds model in
``modular_covariant_scan.py`` is the reduction of the intended
characteristic-zero representation, rather than an accidental modular
quotient.
"""

from __future__ import annotations

import itertools
from collections import deque


P = 23
C_MOD = 4
ZERO = (0, 0)
ONE = (1, 0)


def add(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    return left[0] + right[0], left[1] + right[1]


def multiply(left: tuple[int, int], right: tuple[int, int]) -> tuple[int, int]:
    """Multiply in Z[c]/(c^2+c+3)."""

    a, b = left
    d, e = right
    return a * d - 3 * b * e, a * e + b * d - b * e


def scalar(value: int | tuple[int, int]) -> tuple[int, int]:
    return value if isinstance(value, tuple) else (value, 0)


def matrix(rows):
    return tuple(tuple(scalar(value) for value in row) for row in rows)


IDENTITY = matrix([[int(i == j) for j in range(5)] for i in range(5)])
A = matrix(
    [
        [0, 1, 0, 0, 0],
        [1, 0, 0, 0, 0],
        [0, 0, 0, 0, 1],
        [1, -1, (0, 1), 1, (0, -1)],
        [0, 0, 1, 0, 0],
    ]
)
B = matrix(
    [
        [0, 0, 0, 1, 0],
        [0, 0, 1, 0, 0],
        [0, -1, -1, 0, 0],
        [(1, 1), 0, 0, -1, (2, 1)],
        [1, 0, 0, -1, 1],
    ]
)


def sum_pairs(values) -> tuple[int, int]:
    result = ZERO
    for value in values:
        result = add(result, value)
    return result


def matrix_multiply(left, right):
    return tuple(
        tuple(
            sum_pairs(multiply(left[i][k], right[k][j]) for k in range(5))
            for j in range(5)
        )
        for i in range(5)
    )


def reduce_scalar(value: tuple[int, int]) -> int:
    return (value[0] + C_MOD * value[1]) % P


def matrix_key(exact_matrix) -> bytes:
    return bytes(reduce_scalar(value) for row in exact_matrix for value in row)


def determinant(source) -> tuple[int, int]:
    result = ZERO
    for permutation in itertools.permutations(range(5)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(5)
            for j in range(i + 1, 5)
        )
        term = ONE
        for i, j in enumerate(permutation):
            term = multiply(term, source[i][j])
        if inversions % 2:
            term = (-term[0], -term[1])
        result = add(result, term)
    return result


def main() -> None:
    assert reduce_scalar(multiply((0, 1), (0, 1))) == C_MOD**2 % P
    assert determinant(A) == ONE and determinant(B) == ONE

    seen = {matrix_key(IDENTITY): IDENTITY}
    queue = deque([IDENTITY])
    exact_collisions = 0
    while queue:
        current = queue.popleft()
        for generator in (A, B):
            candidate = matrix_multiply(current, generator)
            candidate_key = matrix_key(candidate)
            if candidate_key in seen:
                assert seen[candidate_key] == candidate
                exact_collisions += 1
            else:
                seen[candidate_key] = candidate
                queue.append(candidate)

    assert len(seen) == 660
    print(f"det(A)={determinant(A)} det(B)={determinant(B)}")
    print(f"exact_group_order={len(seen)} verified_collisions={exact_collisions}")
    print("PASS every F_23 Cayley collision lifts exactly over Z[c]/(c^2+c+3)")


if __name__ == "__main__":
    main()
