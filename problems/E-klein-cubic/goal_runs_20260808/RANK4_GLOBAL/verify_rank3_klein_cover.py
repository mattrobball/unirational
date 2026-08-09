#!/usr/bin/env python3
"""Exact 5-by-5 lattice replay for the rank-three Klein-cover boundary."""

from pathlib import Path

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form


P = 11
MU = sp.Matrix([1, 5, 3, 4, 9])
MU_TILDE = sp.Matrix([1, 5, 3, 4, -13])
ONE = sp.Matrix([1, 1, 1, 1, 1])


def rank_mod(rows, prime=P):
    matrix = [[int(x) % prime for x in row] for row in rows]
    rank = 0
    column = 0
    while rank < len(matrix) and column < len(matrix[0]):
        pivot = next(
            (r for r in range(rank, len(matrix)) if matrix[r][column]),
            None,
        )
        if pivot is None:
            column += 1
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        inverse = pow(matrix[rank][column], -1, prime)
        matrix[rank] = [(inverse * x) % prime for x in matrix[rank]]
        for r in range(len(matrix)):
            if r == rank:
                continue
            coefficient = matrix[r][column]
            matrix[r] = [
                (x - coefficient * y) % prime
                for x, y in zip(matrix[r], matrix[rank])
            ]
        rank += 1
        column += 1
    return rank


def main():
    # Pullback of y_j=x_j^2*x_(j+1): (C*n)_k=2*n_k+n_(k-1).
    C = 2 * sp.eye(5)
    for k in range(5):
        C[k, (k - 1) % 5] += 1

    assert C.det() == 33
    assert C * ONE == 3 * ONE

    # Restriction to the augmentation lattice in basis e_i-e_4.
    basis = [sp.eye(5).col(i) - sp.eye(5).col(4) for i in range(4)]
    C_aug = sp.Matrix.hstack(*(C * vector for vector in basis))[:4, :]
    diagonal = smith_normal_form(C_aug, domain=sp.ZZ)
    invariants = sorted(abs(int(diagonal[i, i])) for i in range(4))
    assert invariants == [1, 1, 1, 11]

    target = sp.Matrix([-1, 1, 1, 1, -2])
    assert sum(MU_TILDE) == 0
    assert C * MU_TILDE == 11 * target
    assert all(int(x) % P == 0 for x in C * MU)
    assert rank_mod(C.tolist()) == 4

    # Natural coordinate-boundary incidence on the Klein cover.
    incidence = sp.Matrix([2, 0, 0, 0, 1])
    orbit = []
    current = incidence
    for _ in range(5):
        orbit.append([int(x) for x in current])
        current = sp.Matrix([current[-1], *current[:-1]])
    assert rank_mod(orbit) == 4
    assert rank_mod(orbit + [[1, 1, 1, 1, 1]]) == 4
    assert all(sum(int(MU[i]) * row[i] for i in range(5)) % P == 0 for row in orbit)

    # Exponent identity behind the tautological Kummer root.
    exponent = C * MU_TILDE
    assert exponent == 11 * target

    note = Path(__file__).with_name("RANK3_KLEIN_COVER_BOUNDARY.md").read_text(
        encoding="utf-8"
    )
    for marker in (
        "RANK4-RANK3-KUMMER-COVER-IS-KLEIN-TORUS",
        "RANK4-RANK3-SPECIAL-LIFT-IS-TAUTOLOGICAL",
        "RANK4-RANK3-SEMILINEAR-DESCENT-IS-ORIGINAL-GATE",
        "RANK4-RANK3-BRANCH-OPEN",
        "F55-GLOBAL-QUESTION-OPEN",
    ):
        assert marker in note

    print("PROJECTIVE_SMITH_INVARIANTS", invariants)
    print("MU_TILDE_OVER_11_GENERATES_COVER_LATTICE_OK")
    print("KLEIN_BOUNDARY_INCIDENCE_RANK_THREE_OK")
    print("RANK3-KLEIN-COVER-BOUNDARY-OK")


if __name__ == "__main__":
    main()
