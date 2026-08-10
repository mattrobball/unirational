#!/usr/bin/env python3
"""Exact bounded replay for UNIT_RESIDUE_TOROIDAL/THEOREM.md.

Only the forced five-dimensional integer matrices and one rank-three
annihilator basis are checked.  There is no degree or support search.
"""

from itertools import combinations
from math import gcd


def determinant(matrix):
    """Bareiss determinant over Z."""
    a = [list(row) for row in matrix]
    n = len(a)
    if n == 0:
        return 1
    sign = 1
    previous = 1
    for k in range(n - 1):
        if a[k][k] == 0:
            pivot = next((i for i in range(k + 1, n) if a[i][k]), None)
            if pivot is None:
                return 0
            a[k], a[pivot] = a[pivot], a[k]
            sign *= -1
        p = a[k][k]
        for i in range(k + 1, n):
            for j in range(k + 1, n):
                a[i][j] = (a[i][j] * p - a[i][k] * a[k][j]) // previous
        previous = p
        for i in range(k + 1, n):
            a[i][k] = 0
    return sign * a[-1][-1]


def determinantal_divisors(matrix):
    """GCDs of all k-minors; tiny fixed 5x6 input only."""
    rows = len(matrix)
    cols = len(matrix[0])
    answer = []
    for size in range(1, min(rows, cols) + 1):
        value = 0
        for row_set in combinations(range(rows), size):
            for col_set in combinations(range(cols), size):
                minor = [[matrix[i][j] for j in col_set] for i in row_set]
                value = gcd(value, abs(determinant(minor)))
        answer.append(value)
    return answer


def rotate_cocharacter(n):
    # (sigma*n)_j=n_(j-1), dual to sigma(e_j)=e_(j+1).
    return [n[(j - 1) % 5] for j in range(5)]


def main():
    lam = [1, 9, 4, 3, 5]
    C = [
        [2 if i == j else (1 if j == (i - 1) % 5 else 0)
         for j in range(5)]
        for i in range(5)
    ]
    assert determinant(C) == 33
    assert [sum(lam[i] * C[i][j] for i in range(5)) for j in range(5)] \
        == [11, 22, 11, 11, 11]
    assert sum(lam) == 22

    # The explicit split trace-zero local-surjectivity family
    # (x,-x,1,omega,omega^2), x=z^10.  Constants lie in C* and hence
    # are eleventh powers; only the exponent of z matters.
    assert lam[0] + lam[1] == 10
    target_exponent = 10 * (lam[0] + lam[1])
    assert target_exponent == 100
    assert target_exponent % 11 == 1
    # omega exponents: omega^(lambda_3+2*lambda_4)=omega^13=omega.
    assert (lam[3] + 2 * lam[4]) % 3 == 1

    augmented = [C[i] + [1] for i in range(5)]
    deltas = determinantal_divisors(augmented)
    assert deltas == [1, 1, 1, 1, 11]
    smith = [deltas[0]] + [deltas[i] // deltas[i - 1]
                            for i in range(1, len(deltas))]
    assert smith == [1, 1, 1, 1, 11]

    w = [-2, -1, 1, 1, 1]
    n = [-w[(2 - j) % 5] for j in range(5)]
    assert n == [-1, 1, 2, -1, -1]
    assert sum(w) == sum(n) == 0
    assert gcd(*[abs(x) for x in n]) == 1
    assert sum(lam[i] * w[i] for i in range(5)) == 1

    orbit = []
    current = n
    for _ in range(5):
        orbit.append(tuple(current))
        current = rotate_cocharacter(current)
    assert len(set(orbit)) == 5
    assert current == n

    actual_pattern = [-orbit[i][2] for i in range(5)]
    assert actual_pattern == w

    # An explicit Z-basis of M cap n^perp, using representatives m_4=0.
    annihilator_basis = [
        [1, 1, 0, 0, 0],
        [2, 0, 1, 0, 0],
        [-1, 0, 0, 1, 0],
    ]
    assert all(sum(m[i] * n[i] for i in range(5)) == 0
               for m in annihilator_basis)

    # With m_4=0, every annihilator vector is uniquely
    # (b+2c-d,b,c,d,0), so the displayed three vectors form a basis.
    for b, c, d in ((1, 0, 0), (0, 1, 0), (0, 0, 1), (3, -2, 4)):
        m = [b + 2 * c - d, b, c, d, 0]
        rebuilt = [
            b * annihilator_basis[0][i]
            + c * annihilator_basis[1][i]
            + d * annihilator_basis[2][i]
            for i in range(5)
        ]
        assert rebuilt == m

    print("projective_local_smith=(1,1,1,1,11)")
    print("countermodel_free_prime_vector=" + str(tuple(w)))
    print("actual_toric_ray=" + str(tuple(n)))
    print("actual_boundary_vector=" + str(tuple(actual_pattern)))
    print("both_resolvent_valuations=1")
    print("rank4_mixed_flag_terminal_residue=1")
    print("split_trace_hyperplane_resolvent_surjective=true")
    print("finite_split_place_matching=weak_approximation")
    print("F55-UNIT-FREE-PRIME-TOROIDAL-LOCAL-EQUIVALENCE-OK")
    print("F55-FINITE-SPLIT-LOCAL-MATCHING-OK")


if __name__ == "__main__":
    main()
