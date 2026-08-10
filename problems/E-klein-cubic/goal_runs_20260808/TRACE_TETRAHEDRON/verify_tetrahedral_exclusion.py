#!/usr/bin/env python3
"""Exact small certificate for affine-rank-three four-term exclusion."""

import importlib.util
from pathlib import Path

import sympy as sp


HERE = Path(__file__).resolve().parent
SPEC = importlib.util.spec_from_file_location(
    "quartic_constraints", HERE / "derive_norm_quartic_constraints.py"
)
QC = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(QC)


def reduce_t(expression, t):
    return sp.Poly(sp.expand(expression), t, domain="EX").rem(
        sp.Poly(t**4 - 1, t, domain="EX")
    ).as_expr()


def main():
    S = QC.barycentric_sums()
    assert S[0] == S[1] == S[2] == 0 and S[3] == 1
    assert S[-1] == -1 / QC.e4
    assert sp.factor(S[-2] + QC.e3 / QC.e4**2) == 0
    assert sp.factor(S[-3] - (QC.e2 * QC.e4 - QC.e3**2) / QC.e4**3) == 0

    low_rows = {
        row: sp.expand(QC.cleared_constraint(*row, S).subs(QC.e4, 1))
        for row in ((4, 4), (2, 7), (7, 2))
    }
    basis = sp.groebner(
        [QC.NM.phi5, *low_rows.values()],
        QC.NM.z,
        QC.e1,
        QC.e2,
        QC.e3,
        order="grevlex",
    )
    assert basis.is_zero_dimensional

    square_relations = (
        (QC.e1 - QC.e2 * QC.e3) ** 2,
        (QC.e2 - QC.e3**2) ** 2,
    )
    assert all(basis.reduce(relation)[1] == 0 for relation in square_relations)

    branch_basis_element = (
        3 * QC.e1**2 * QC.NM.z
        + 2 * QC.e1**2
        - 5 * QC.e2 * QC.NM.z
        - 5 * QC.e2
        + 2 * QC.e3**2 * QC.NM.z
        + 3 * QC.e3**2
    )
    assert basis.reduce(branch_basis_element)[1] == 0
    branch_after_relations = sp.factor(
        branch_basis_element.subs({QC.e1: QC.e3**3, QC.e2: QC.e3**2})
    )
    assert sp.expand(
        branch_after_relations - (3 * QC.NM.z + 2) * QC.e3**2 * (QC.e3**4 - 1)
    ) == 0
    assert sp.gcd(sp.Poly(QC.NM.phi5, QC.NM.z), sp.Poly(3 * QC.NM.z + 2, QC.NM.z)) == 1

    # Both normal forms satisfy the first three necessary rows.
    t = sp.symbols("t")
    for value in low_rows.values():
        square = QC.NM.reduce_z(value.subs({QC.e1: 0, QC.e2: 0, QC.e3: 0}))
        assert square == 0
        pentagon = QC.NM.reduce_z(
            value.subs({QC.e1: t**3, QC.e2: t**2, QC.e3: t})
        )
        assert sp.factor(reduce_t(pentagon, t)) == 0

    # Total degree ten kills the square; the four-of-five shape survives this
    # jet and is killed separately by the affine lattice coset.
    degree10 = {
        row: QC.cleared_constraint(*row, S)
        for row in ((0, 10), (5, 5), (10, 0))
    }
    square_010 = sp.factor(
        QC.NM.reduce_z(
            degree10[(0, 10)].subs({QC.e1: 0, QC.e2: 0, QC.e3: 0, QC.e4: 1})
        )
    )
    assert square_010 == 1260 * QC.NM.z * (QC.NM.z**2 + 2)
    assert sp.gcd(
        sp.Poly(QC.NM.phi5, QC.NM.z),
        sp.Poly(QC.NM.z * (QC.NM.z**2 + 2), QC.NM.z),
    ) == 1
    for value in degree10.values():
        pentagon = QC.NM.reduce_z(
            value.subs({QC.e1: t**3, QC.e2: t**2, QC.e3: t, QC.e4: 1})
        )
        assert sp.factor(reduce_t(pentagon, t)) == 0

    W = sp.symbols("W")
    T = sp.symbols("T")
    P = T**4 - t**3 * T**3 + t**2 * T**2 - t * T + 1
    normalized = reduce_t(P.subs(T, t**3 * W), t)
    Q = W**4 - W**3 + W**2 - W + 1
    assert sp.expand(normalized - Q) == 0
    assert sp.expand((W + 1) * Q - (W**5 + 1)) == 0
    assert sp.gcd(sp.Poly(Q, W), sp.Poly(sp.diff(Q, W), W)) == 1

    # Order-eleven affine-coset obstruction to z_j=sigma^m(z_k).
    lambda_values = (1, 9, 4, 3, 5)
    assert all(lambda_values[(i + 1) % 5] % 11 == 9 * lambda_values[i] % 11 for i in range(5))
    lambda_c = (-lambda_values[2]) % 11
    assert lambda_c == 7
    residues = [((pow(9, m, 11) - 1) * lambda_c) % 11 for m in range(1, 5)]
    assert all(residue != 0 for residue in residues)

    print("NORM_CONIC_U_PARAMETERS_DISTINCT", True)
    print("BARYCENTRIC_WEIGHT_FORMULA", "A_j=kappa*u_j/P'(u_j)")
    print("LOWJET_ROWS", sorted(low_rows))
    print("LOWJET_GROEBNER_SIZE", len(basis.polys))
    print("LOWJET_NORMAL_FORMS", "square", "four-of-five")
    print("SQUARE_DEGREE10_OBSTRUCTION", square_010)
    print("FOUR_OF_FIVE_COSET_RESIDUES", residues)
    print("F55-TRACE-FOUR-TERM-AFFINE-RANK-THREE-EXCLUSION-OK")


if __name__ == "__main__":
    main()
