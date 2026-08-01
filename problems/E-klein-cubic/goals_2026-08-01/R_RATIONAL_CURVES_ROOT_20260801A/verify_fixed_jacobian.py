#!/usr/bin/env python3
"""Independent SymPy verifier for fixed_jacobian_payload.json.

This verifier does not import the producer.  It reconstructs the period-lattice
action by restriction of scalars to Q, derives both integral matrices, and
recomputes the group relations and modular invariant spaces.
"""

from __future__ import annotations

import json
from pathlib import Path

from sympy import Matrix, Rational, eye, zeros


HERE = Path(__file__).resolve().parent


def o_block(a, b) -> Matrix:
    """Multiplication by a+b*nu in basis (1,nu), nu^2+nu+3=0."""
    return Matrix([[a, -3 * b], [b, a - b]])


def o_matrix(entries: list[list[tuple[object, object]]]) -> Matrix:
    n = len(entries)
    result = zeros(2 * n)
    for i in range(n):
        for j in range(n):
            block = o_block(*entries[i][j])
            result[2 * i : 2 * i + 2, 2 * j : 2 * j + 2] = block
    return result


def rank_mod(matrix: Matrix, prime: int) -> int:
    rows = [[int(matrix[i, j]) % prime for j in range(matrix.cols)] for i in range(matrix.rows)]
    rank = 0
    for col in range(matrix.cols):
        pivot = next((r for r in range(rank, matrix.rows) if rows[r][col]), None)
        if pivot is None:
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        inv = pow(rows[rank][col], -1, prime)
        rows[rank] = [(inv * x) % prime for x in rows[rank]]
        for r in range(matrix.rows):
            if r != rank and rows[r][col]:
                scale = rows[r][col]
                rows[r] = [(x - scale * y) % prime for x, y in zip(rows[r], rows[rank])]
        rank += 1
    return rank


def main() -> None:
    payload = json.loads((HERE / "fixed_jacobian_payload.json").read_text(encoding="utf-8"))

    z = (0, 0)
    one = (1, 0)
    nu = (0, 1)
    # Columns describe tau(v0),...,tau(v4); v5 is Roulleau's exact relation.
    tau_entries = [[z for _ in range(5)] for _ in range(5)]
    tau_columns = [
        [z, one, z, z, z],
        [z, z, one, z, z],
        [z, z, z, one, z],
        [z, z, z, z, one],
        [one, (1, 1), (-1, 0), one, nu],
    ]
    for j, column in enumerate(tau_columns):
        for i, value in enumerate(column):
            tau_entries[i][j] = value
    tau_v = o_matrix(tau_entries)

    # Build sigma(v_k)=v_(5k mod 11) directly from powers of tau_v.
    v0 = zeros(10, 1)
    v0[0, 0] = 1
    sigma_v = zeros(10)
    for k in range(5):
        sigma_v[:, 2 * k] = (tau_v ** ((5 * k) % 11)) * v0

    # O-linearity supplies the nu*v_k column, block by block.
    for k in range(5):
        even = sigma_v[:, 2 * k]
        odd = zeros(10, 1)
        for i in range(5):
            a, b = even[2 * i], even[2 * i + 1]
            odd[2 * i], odd[2 * i + 1] = -3 * b, a - b
        sigma_v[:, 2 * k + 1] = odd

    inv_delta = (Rational(-1, 11), Rational(-2, 11))

    def scale_pair(integer: int) -> tuple[object, object]:
        return (integer * inv_delta[0], integer * inv_delta[1])

    basis_entries = [[z for _ in range(5)] for _ in range(5)]
    basis_columns = [
        [scale_pair(1), scale_pair(-3), scale_pair(3), scale_pair(-1), z],
        [z, scale_pair(1), scale_pair(-3), scale_pair(3), scale_pair(-1)],
        [one, z, z, z, z],
        [z, one, z, z, z],
        [z, z, one, z, z],
    ]
    for j, column in enumerate(basis_columns):
        for i, value in enumerate(column):
            basis_entries[i][j] = value
    basis = o_matrix(basis_entries)

    tau = basis.inv() * tau_v * basis
    sigma = basis.inv() * sigma_v * basis
    assert all(entry.q == 1 for entry in tau)
    assert all(entry.q == 1 for entry in sigma)

    tau_expected = Matrix(payload["tau_matrix_Z"])
    sigma_expected = Matrix(payload["sigma_matrix_Z"])
    assert tau == tau_expected
    assert sigma == sigma_expected

    ident = eye(10)
    assert tau ** 11 == ident
    assert sigma ** 5 == ident
    assert sigma * tau * sigma ** 4 == tau ** 5
    assert abs(int((tau - ident).det())) == 11

    stacked = (tau - ident).col_join(sigma - ident)
    checks = payload["checks"]
    for prime in (5, 11):
        common_rank = rank_mod(stacked, prime)
        tau_rank = rank_mod(tau - ident, prime)
        assert common_rank == checks[f"common_fixed_equations_rank_mod_{prime}"] == 10
        assert tau_rank == checks[f"tau_minus_identity_rank_mod_{prime}"]

    assert payload["deduction"]["fixed_points_killed_by"] == 55
    assert payload["deduction"]["primary_checks"] == [5, 11]
    assert payload["deduction"]["fixed_subgroup"] == "trivial"
    print("INDEPENDENT_PERIOD_LATTICE_RECONSTRUCTION_OK")
    print("INDEPENDENT_GROUP_RELATIONS_OK")
    print("INDEPENDENT_PRIMARY_FIXED_SPACE_RANKS_OK")
    print("KLEIN_JACOBIAN_COMMON_FIXED_SUBGROUP_TRIVIAL")


if __name__ == "__main__":
    main()
