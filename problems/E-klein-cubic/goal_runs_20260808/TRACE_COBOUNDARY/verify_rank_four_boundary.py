#!/usr/bin/env python3
"""Exact regressions for the rank-four Fourier boundary.

This checks only finite Fourier matrices, the divisor lattice, the two
formal incidence orbits, and the explicit local polynomial models.  It does
not enumerate Laurent supports or degrees and is not a global trace solver.
"""

from itertools import combinations, product

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form
from sympy.polys.domains import ZZ


MOD = 11
MU = (1, 5, 3, 4, 9)
T = sp.symbols("t")


def valuation_at_zero(poly):
    p = sp.Poly(sp.expand(poly), T)
    return min(monomial[0] for monomial, coeff in p.terms() if coeff)


def wronskian(functions):
    return sp.expand(sp.det(sp.Matrix(
        [[sp.diff(f, T, r) for f in functions] for r in range(len(functions))]
    )))


def coefficient_rank(functions):
    degree = max(sp.Poly(f, T).degree() for f in functions)
    matrix = sp.Matrix([
        [sp.Poly(f, T).coeff_monomial(T**d) for f in functions]
        for d in range(degree + 1)
    ])
    return matrix.rank()


def main():
    # The full four-character Fourier matrix is full spark.
    root = 3
    assert pow(root, 5, MOD) == 1
    assert all(pow(root, d, MOD) != 1 for d in range(1, 5))
    rows = [[pow(root, j * q, MOD) for q in range(1, 5)] for j in range(5)]
    for selected in combinations(range(5), 4):
        matrix = sp.Matrix([rows[j] for j in selected])
        assert int(matrix.det()) % MOD != 0, selected

    # Exact cokernel of w_j=2*x_j+x_(j+1).
    A = sp.Matrix([
        [2 if i == j else 1 if j == (i + 1) % 5 else 0 for j in range(5)]
        for i in range(5)
    ])
    assert A.det() == 33
    assert list(smith_normal_form(A, domain=ZZ).diagonal()) == [1, 1, 1, 1, 33]
    assert sum(MU) % MOD == 0
    for j in range(5):
        assert (2 * MU[j] + MU[(j - 1) % 5]) % MOD == 0

    # The five incidence rows and their least positive representatives.
    cases = (
        ((0,), (11,)),
        ((0, 1), (1, 2)),
        ((0, 2), (2, 3)),
        ((0, 1, 2), (3, 1, 1)),
        ((0, 1, 3), (2, 1, 1)),
    )
    for support, expected in cases:
        assert sum(MU[i] * s for i, s in zip(support, expected)) % MOD == 0
        candidates = []
        for values in product(range(1, MOD + 1), repeat=len(support)):
            if sum(MU[i] * s for i, s in zip(support, values)) % MOD == 0:
                candidates.append((sum(values), values))
        assert min(candidates) == (sum(expected), expected), support

    consecutive_s = sp.Matrix([3, 1, 1, 0, 0])
    consecutive_w = consecutive_s + 2 * sp.ones(5, 1)
    consecutive_x = sp.Matrix([2, 1, 1, 1, 0])
    assert consecutive_w == A * consecutive_x

    gapped_s = sp.Matrix([2, 1, 0, 1, 0])
    gapped_w = gapped_s + sp.ones(5, 1)
    gapped_x = sp.Matrix([1, 1, 0, 1, 0])
    assert gapped_w == A * gapped_x

    # Ten cyclic formal primes.  Each term has projective degree nine.
    factors = []
    for i in range(5):
        consecutive = [0] * 5
        consecutive[i] = 3
        consecutive[(i + 1) % 5] = 1
        consecutive[(i + 2) % 5] = 1
        factors.append(tuple(consecutive))

        gapped = [0] * 5
        gapped[i] = 2
        gapped[(i + 1) % 5] = 1
        gapped[(i + 3) % 5] = 1
        factors.append(tuple(gapped))

    assert [sum(f[j] for f in factors) for j in range(5)] == [9] * 5
    assert all(sum(s > 0 for s in f) == 3 for f in factors)
    refined_weights = [6 - ((2 - 1) * (2 - 2)) // 2 for _ in factors]
    assert -6 + sum(refined_weights) == 54
    cartan_truncated = sum(sum(min(s, 3) for s in f) for f in factors)
    assert cartan_truncated == 45

    local_models = (
        (
            (T**3, T, T + T**2, sp.Integer(1), -(1 + 2*T + T**2 + T**3)),
            (3, 1, 1, 0, 0),
            (sp.Integer(1), T, T + T**2, T**3),
            2,
            consecutive_w,
        ),
        (
            (T**2, T, sp.Integer(1), T + T**3, -(1 + 2*T + T**2 + T**3)),
            (2, 1, 0, 1, 0),
            (sp.Integer(1), T, T**2, T + T**3),
            1,
            gapped_w,
        ),
    )

    for terms, expected_vals, basis, common_offset, expected_w in local_models:
        assert sp.expand(sum(terms)) == 0
        assert tuple(valuation_at_zero(f) for f in terms) == expected_vals
        assert coefficient_rank(terms) == 4
        assert coefficient_rank(basis) == 4
        assert wronskian(basis) == 12

        # Exactly one constant relation implies no proper zero subsum.
        for size in range(1, 5):
            for selected in combinations(range(5), size):
                assert sp.expand(sum(terms[j] for j in selected)) != 0

        adjusted = sp.Matrix([v + common_offset for v in expected_vals])
        assert adjusted == expected_w

        # The four nontrivial Fourier components are independent over F_11.
        components = []
        for q in range(1, 5):
            component = sum(
                pow(root, (-j * q) % 5, MOD) * terms[j] for j in range(5)
            )
            components.append(sp.Poly(component, T, modulus=MOD).as_expr())
        coeffs = sp.Matrix([
            [sp.Poly(f, T, modulus=MOD).coeff_monomial(T**d) for f in components]
            for d in range(4)
        ])
        assert int(coeffs.det()) % MOD != 0

    note = __file__.replace("verify_rank_four_boundary.py", "RANK_FOUR_BOUNDARY.md")
    text = open(note, encoding="utf-8").read()
    for marker in (
        "RANK4-FOURIER-PRIME-INCIDENCE-AT-MOST-THREE",
        "RANK4-MOD11-MULTIPLICITY-CLASSIFICATION-EXACT",
        "RANK4-GLOBAL-CASE-OPEN",
        "F55-GLOBAL-QUESTION-OPEN",
    ):
        assert marker in text

    print("FOURIER_5X4_FULL_SPARK_OK")
    print("DIVISOR_LATTICE_SNF", list(smith_normal_form(A, domain=ZZ).diagonal()))
    print("FORMAL_PROJECTIVE_DEGREE", 9)
    print("REFINED_WRONSKIAN_BUDGET", 54)
    print("CARTAN_LEVEL3_BUDGET", 45)
    print("RANK4-FOURIER-BOUNDARY-OK")


if __name__ == "__main__":
    main()
