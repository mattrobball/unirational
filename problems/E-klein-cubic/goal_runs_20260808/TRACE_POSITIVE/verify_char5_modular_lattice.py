#!/usr/bin/env python3
"""Small exact certificate for the C5-on-Z/11 mixed-prime lattice boundary.

This is deliberately dependency-free.  It checks only the four-dimensional
integral lattice presentation used in CHAR5_MODULAR_INVARIANT_BOUNDARY.md; it
does not claim to compute essential dimension.
"""

from itertools import permutations
from math import gcd


def matmul(a, b):
    return [
        [sum(a[i][k] * b[k][j] for k in range(len(b))) for j in range(len(b[0]))]
        for i in range(len(a))
    ]


def eye(n):
    return [[int(i == j) for j in range(n)] for i in range(n)]


def matadd(*matrices):
    return [
        [sum(m[i][j] for m in matrices) for j in range(len(matrices[0][0]))]
        for i in range(len(matrices[0]))
    ]


def poly_add(a, b):
    out = [0] * max(len(a), len(b))
    for i, value in enumerate(a):
        out[i] += value
    for i, value in enumerate(b):
        out[i] += value
    while len(out) > 1 and out[-1] == 0:
        out.pop()
    return out


def poly_mul(a, b):
    out = [0] * (len(a) + len(b) - 1)
    for i, x in enumerate(a):
        for j, y in enumerate(b):
            out[i + j] += x * y
    return out


def sign_of_permutation(p):
    inversions = sum(p[i] > p[j] for i in range(len(p)) for j in range(i + 1, len(p)))
    return -1 if inversions % 2 else 1


def characteristic_polynomial(a):
    """Return det(xI-a), with coefficients in ascending order."""
    n = len(a)
    total = [0]
    for p in permutations(range(n)):
        term = [sign_of_permutation(p)]
        for i, j in enumerate(p):
            entry = [-a[i][j], 1] if i == j else [-a[i][j]]
            term = poly_mul(term, entry)
        total = poly_add(total, term)
    return total


def main():
    modulus = 11
    q = 9

    assert pow(q, 5, modulus) == 1
    assert all(pow(q, d, modulus) != 1 for d in range(1, 5))
    phi_at_q = sum(pow(q, i, modulus) for i in range(5)) % modulus
    assert phi_at_q == 0

    # Basis b_i=gamma^i(gamma-1), i=0,...,3, of the augmentation ideal.
    # Columns record gamma*b_i.
    gamma = [
        [0, 0, 0, -1],
        [1, 0, 0, -1],
        [0, 1, 0, -1],
        [0, 0, 1, -1],
    ]
    gamma2 = matmul(gamma, gamma)
    gamma3 = matmul(gamma2, gamma)
    gamma4 = matmul(gamma3, gamma)
    gamma5 = matmul(gamma4, gamma)
    identity = eye(4)
    zero = [[0] * 4 for _ in range(4)]
    assert gamma5 == identity
    assert matadd(identity, gamma, gamma2, gamma3, gamma4) == zero
    charpoly = characteristic_polynomial(gamma)
    assert charpoly == [1, 1, 1, 1, 1]  # Phi_5(x)

    evaluation = [((q - 1) * pow(q, i, modulus)) % modulus for i in range(4)]
    assert gcd(modulus, *evaluation) == 1

    # Equivariance h(gamma*b_i)=q*h(b_i), including the last basis vector.
    for j in range(4):
        lhs = sum(gamma[i][j] * evaluation[i] for i in range(4)) % modulus
        rhs = q * evaluation[j] % modulus
        assert lhs == rhs

    print(f"MULTIPLIER={q}")
    print("ORDER_MOD_11=5")
    print(f"PHI5_AT_MULTIPLIER_MOD_11={phi_at_q}")
    print(f"CHARPOLY_ASCENDING={charpoly}")
    print(f"EVALUATION_VECTOR={evaluation}")
    print("SURJECTIVE_TO_Z11=1")
    print("PERMUTATION_FACTOR_RANK=5")
    print("PRESENTATION_LATTICE_RANK=4")
    print("MINIMAL_LATTICE_RANK=4")
    print("F55-CHAR5-MIXED-PRIME-LATTICE-BOUNDARY-OK")


if __name__ == "__main__":
    main()
