#!/usr/bin/env python3
"""Independent integer checks for ANALYTIC_AUDIT.md.

The mathematical divisor arguments are in the note.  This verifier checks the
only finite arithmetic inputs: the two Smith forms and both mod-11 functionals.
"""
from __future__ import annotations

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form


def diagonal_entries(matrix: sp.Matrix) -> tuple[int, ...]:
    return tuple(abs(int(matrix[i, i])) for i in range(min(matrix.shape)))


def main() -> None:
    # sigma(e_j)=e_(j+1) on a free orbit and on Z^5.
    P = sp.zeros(5)
    for j in range(5):
        P[(j + 1) % 5, j] = 1
    I5 = sp.eye(5)
    A5 = 2 * I5 + P
    assert P**5 == I5
    assert int(A5.det()) == 33
    assert diagonal_entries(smith_normal_form(A5, domain=sp.ZZ)) == (1, 1, 1, 1, 33)

    # The two independent residues on the cyclic order-33 cokernel.
    lam = sp.Matrix([[1, 9, 4, 3, 5]])
    ones = sp.ones(5, 1)
    assert all(int(x) % 11 == 0 for x in lam * A5)
    assert int((lam * ones)[0]) % 11 == 0
    assert int((lam * sp.Matrix([1, 0, 0, 0, 0]))[0]) % 11 == 1
    sum_row = sp.ones(1, 5)
    assert all(int(x) % 3 == 0 for x in sum_row * A5)
    # e0 maps to (1 mod 3, 1 mod 11), hence the displayed residues detect
    # the whole cyclic cokernel of order 33.
    assert (int((sum_row * sp.eye(5)[:, 0])[0]) % 3,
            int((lam * sp.eye(5)[:, 0])[0]) % 11) == (1, 1)

    # Quotient character lattice M=Z^5/Z(1,...,1), in coordinates m4=0.
    S = sp.Matrix([
        [0, 0, 0, -1],
        [1, 0, 0, -1],
        [0, 1, 0, -1],
        [0, 0, 1, -1],
    ])
    I4 = sp.eye(4)
    AM = 2 * I4 + S
    assert S**5 == I4
    assert int(AM.det()) == 11
    assert diagonal_entries(smith_normal_form(AM, domain=sp.ZZ)) == (1, 1, 1, 11)
    lam_M = sp.Matrix([[1, 9, 4, 3]])
    assert all(int(x) % 11 == 0 for x in lam_M * AM)

    # The eigen-cancellation equation would require
    # (2+sigma)m=e3-e2.  Its obstruction is -1 mod 11.
    e3_minus_e2 = sp.Matrix([0, 0, -1, 1])
    assert int((lam_M * e3_minus_e2)[0]) % 11 == 10

    # Projectivizing a free prime orbit adjoins the invariant diagonal.
    # It kills the 3-part and leaves the lambda mod-11 residue untouched.
    assert int((sum_row * ones)[0]) % 3 == 2
    assert int((lam * ones)[0]) % 11 == 0

    # Tiny local compatibility model from the note: the five differences sum
    # to zero, have orders (0,0,2,1,0), and pass lambda mod 11.
    t = sp.symbols("t")
    differences = (1, 1, t**2, t, -2-t-t**2)
    assert sp.expand(sum(differences)) == 0
    local_orders = sp.Matrix([0, 0, 2, 1, 0])
    assert int((lam * local_orders)[0]) % 11 == 0

    print("F55-TRACE-ANALYTIC-LEMMAS-OK")


if __name__ == "__main__":
    main()
