#!/usr/bin/env python3
"""Independent audit of ``canonical_a5_pencil.py``.

The production script finds an intertwiner as the nullspace of a 150 by 25
linear system over Q(zeta_11).  This verifier deliberately uses a different
construction: it applies the Reynolds projector to matrix units,

    T_E = sum_h rho(h) E U(h)^(-1).

It also identifies the ambient outer automorphism explicitly and checks its
compatibility with cyclotomic complex conjugation on all 660 group elements.
"""

from __future__ import annotations

import importlib.util
import itertools
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
GOAL = HERE.parent
PACKET = GOAL.parent / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10"
sys.path.insert(0, str(PACKET))


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


base = load("canonical_audit_base", PACKET / "produce.py")
canonical = load("canonical_audit_model", GOAL / "canonical_a5_pencil.py")
ew = base.ew


def integer_poly_add(left, right):
    out = dict(left)
    for exponent, coefficient in right.items():
        out[exponent] = out.get(exponent, 0) + coefficient
        if not out[exponent]:
            del out[exponent]
    return out


def integer_poly_mul(left, right):
    out = {}
    for a, ca in left.items():
        for b, cb in right.items():
            exponent = tuple(x + y for x, y in zip(a, b))
            out[exponent] = out.get(exponent, 0) + ca * cb
    return {exponent: coefficient for exponent, coefficient in out.items() if coefficient}


def orbit_cubic_basis():
    """Construct the pencil from the two A5-orbits of 3-subsets of six letters."""
    remaining = set(itertools.combinations(range(6), 3))
    orbits = []
    while remaining:
        seed = min(remaining)
        orbit = {
            tuple(sorted(canonical.six_permutation(g)[i] for i in seed))
            for g in base.PERMS
        }
        orbits.append(tuple(sorted(orbit)))
        remaining -= orbit
    assert [len(orbit) for orbit in orbits] == [10, 10]

    forms = [
        {tuple(int(i == variable) for i in range(5)): 1}
        for variable in range(5)
    ]
    forms.append({tuple(int(i == variable) for i in range(5)): -1 for variable in range(5)})
    cubics = []
    for orbit in orbits:
        polynomial = {}
        for i, j, k in orbit:
            polynomial = integer_poly_add(
                polynomial, integer_poly_mul(integer_poly_mul(forms[i], forms[j]), forms[k])
            )
        cubics.append(polynomial)
    return cubics


def zero_matrix():
    return [[ew.C(0) for _ in range(5)] for _ in range(5)]


def matrix_add(left, right):
    return [[left[i][j] + right[i][j] for j in range(5)] for i in range(5)]


def matrix_mul(left, right):
    return [
        [sum((left[i][k] * right[k][j] for k in range(5)), ew.C(0))
         for j in range(5)]
        for i in range(5)
    ]


def determinant(matrix):
    total = ew.C(0)
    for permutation in itertools.permutations(range(5)):
        inversions = sum(
            permutation[i] > permutation[j]
            for i in range(5) for j in range(i + 1, 5)
        )
        term = ew.C(-1 if inversions % 2 else 1)
        for i in range(5):
            term *= matrix[i][permutation[i]]
        total += term
    return total


def reynolds_intertwiner(H, mapping, seed_row, seed_column):
    seed = zero_matrix()
    seed[seed_row][seed_column] = ew.C(1)
    out = zero_matrix()
    for h in H:
        abstract_inverse = canonical.U[mapping[base.ginv(h)]]
        out = matrix_add(
            out,
            matrix_mul(matrix_mul(ew.rho[h], seed), abstract_inverse),
        )
    return out


def klein_pullback(matrix):
    out = {}
    for i in range(5):
        for a, b, c in itertools.product(range(5), repeat=3):
            exponent = tuple(
                int(j == a) + int(j == b) + int(j == c) for j in range(5)
            )
            coefficient = matrix[i][a] * matrix[i][b] * matrix[(i + 1) % 5][c]
            out[exponent] = out.get(exponent, ew.C(0)) + coefficient
    return {exponent: value for exponent, value in out.items() if value != 0}


def pencil_coordinates(poly):
    rows = [
        [basis.get(exponent, 0) for basis in canonical.CUBIC_BASIS]
        for exponent in canonical.MONS3
    ]
    i, j = next(
        (i, j)
        for i in range(len(rows))
        for j in range(i + 1, len(rows))
        if rows[i][0] * rows[j][1] - rows[i][1] * rows[j][0]
    )
    determinant_2 = rows[i][0] * rows[j][1] - rows[i][1] * rows[j][0]
    value_i = poly.get(canonical.MONS3[i], ew.C(0))
    value_j = poly.get(canonical.MONS3[j], ew.C(0))
    first = (value_i * rows[j][1] - value_j * rows[i][1]) / determinant_2
    second = (rows[i][0] * value_j - rows[j][0] * value_i) / determinant_2
    assert all(
        ew.C(row[0]) * first + ew.C(row[1]) * second
        == poly.get(exponent, ew.C(0))
        for exponent, row in zip(canonical.MONS3, rows)
    )
    return first, second


def galois_inverse(value):
    return sum(
        (coefficient * ew.zp[(-i) % 11] for i, coefficient in enumerate(value.a)),
        ew.C(0),
    )


def matrix_galois_inverse(matrix):
    return [[galois_inverse(value) for value in row] for row in matrix]


def outer(g):
    """Conjugation by diag(1,-1) in PGL_2(F_11)."""
    a, b, c, d = g
    return ew.fcanon((a, -b, -c, d))


def main():
    first, second = base.two_a5_classes()
    a1, b1, H1 = first
    a2, b2, H2 = second
    mapping1 = base.iso(a1, b1, H1)
    mapping2 = base.iso(a2, b2, H2)

    assert pow(10, 5, 11) == 10  # det diag(1,-1) is a nonsquare.
    assert outer(a1) == a2 and outer(b1) == b2
    assert frozenset(outer(h) for h in H1) == H2
    assert all(mapping2[outer(h)] == mapping1[h] for h in H1)

    # Complex conjugation zeta -> zeta^-1 realizes the same outer action on rho.
    assert all(matrix_galois_inverse(ew.rho[g]) == ew.rho[outer(g)] for g in base.GROUP)

    # This bypasses the production nullspace calculation for the cubic pencil:
    # the two 10-element orbits of 3-subsets give its two rational generators.
    orbit_basis = orbit_cubic_basis()
    assert orbit_basis == [
        {exponent: -coefficient for exponent, coefficient in basis.items()}
        for basis in canonical.CUBIC_BASIS
    ]
    character_dimension = sum(
        (
            trace ** 3
            + 3 * trace * sum(canonical.U[base.pc(g, g)][i][i] for i in range(5))
            + 2 * sum(canonical.U[base.pc(base.pc(g, g), g)][i][i] for i in range(5))
        ) // 6
        for g in base.PERMS
        for trace in [sum(canonical.U[g][i][i] for i in range(5))]
    ) // 60
    assert character_dimension == 2

    chosen = None
    for row, column in itertools.product(range(5), repeat=2):
        candidate = reynolds_intertwiner(H1, mapping1, row, column)
        if determinant(candidate) != 0:
            chosen = row, column, candidate
            break
    assert chosen is not None
    seed_row, seed_column, T1 = chosen
    T2 = reynolds_intertwiner(H2, mapping2, seed_row, seed_column)
    assert determinant(T2) != 0
    assert T2 == matrix_galois_inverse(T1)

    for h in (a1, b1):
        assert matrix_mul(ew.rho[h], T1) == matrix_mul(T1, canonical.U[mapping1[h]])
    for h in (a2, b2):
        assert matrix_mul(ew.rho[h], T2) == matrix_mul(T2, canonical.U[mapping2[h]])

    poly1 = klein_pullback(T1)
    poly2 = klein_pullback(T2)
    assert poly2 == {exponent: galois_inverse(value) for exponent, value in poly1.items()}
    first1, second1 = pencil_coordinates(poly1)
    first2, second2 = pencil_coordinates(poly2)

    q = sum((ew.zp[i] for i in (1, 3, 4, 5, 9)), ew.C(0))
    assert q * q + q + 3 == 0
    assert 9 * second1 == (6 - q) * first1
    assert 9 * second2 == (7 + q) * first2
    assert galois_inverse(q) == -1 - q

    # r1+r2=13/9 and r1*r2=5/9 without requiring inversion in ew.C.
    assert (6 - q) + (7 + q) == 13
    assert (6 - q) * (7 + q) == 45

    print(f"PASS Reynolds matrix-unit seed=({seed_row},{seed_column})")
    print("PASS diag(1,-1) swaps the exact chosen A5 embeddings and source maps")
    print("PASS rho(outer(g))=conjugate(rho(g)) for all 660 elements")
    print("PASS independent two-orbit construction of the rational cubic pencil")
    print("PASS parameters are (6-q)/9 and (7+q)/9, q^2+q+3=0")
    print("PASS common minimal polynomial 9*t^2-13*t+5")
    print("CANONICAL_A5_PENCIL_REYNOLDS_VERIFY_OK")


if __name__ == "__main__":
    main()
