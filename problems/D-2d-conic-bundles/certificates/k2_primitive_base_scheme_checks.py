#!/usr/bin/env python3
"""Arithmetic checks for primitive quadratic triples with isolated bases."""

from math import comb
from fractions import Fraction


def rank_one_bound(bundle_degree, twist_degree):
    return max(
        max(bundle_degree - 2 * a + 1, 0)
        + max(2 * a + twist_degree + 1, 0)
        for a in range(-(twist_degree // 2), bundle_degree + 1)
    )


def matrix_rank(rows):
    matrix = [[Fraction(value) for value in row] for row in rows]
    if not matrix:
        return 0
    rank = 0
    for column in range(len(matrix[0])):
        pivot = next(
            (i for i in range(rank, len(matrix)) if matrix[i][column]),
            None,
        )
        if pivot is None:
            continue
        matrix[rank], matrix[pivot] = matrix[pivot], matrix[rank]
        scale = matrix[rank][column]
        matrix[rank] = [entry / scale for entry in matrix[rank]]
        for i, row in enumerate(matrix):
            if i == rank or not row[column]:
                continue
            factor = row[column]
            matrix[i] = [a - factor * b for a, b in zip(row, matrix[rank])]
        rank += 1
    return rank


def symmetric_euler_h1_rank(source_twist, first_jet_rank=2):
    """Rank of symmetric multiplication for (u,v,0) or (u,0,0)."""
    source_dim = max(source_twist - 1, 0)
    target_dim = max(source_twist - 2, 0)
    rows = [[0] * (3 * source_dim) for _ in range(6 * target_dim)]

    def add(output_entry, source_entry, multiplication, coefficient=1):
        for k in range(target_dim):
            source_index = k if multiplication == "u" else k + 1
            row = output_entry * target_dim + k
            column = source_entry * source_dim + source_index
            rows[row][column] += coefficient

    add(0, 0, "u", 2)
    add(1, 1, "u")
    add(2, 2, "u")
    if first_jet_rank == 2:
        add(1, 0, "v")
        add(3, 1, "v", 2)
        add(4, 2, "v")
    else:
        assert first_jet_rank == 1
    return matrix_rank(rows)


# Rank-three strata: base-family dimension + Grassmannian dimension + frames.
rank3_rows = [
    ("one point", 2, 3 * (5 - 3), 8, 16),
    ("two distinct", 4, 3 * (4 - 3), 8, 15),
    ("tangent vector", 3, 3 * (4 - 3), 8, 14),
    ("three distinct", 6, 0, 8, 14),
    ("double plus point", 5, 0, 8, 13),
    ("curvilinear triple", 4, 0, 8, 12),
    ("m_p^2", 2, 0, 8, 10),
]
assert all(base + grass + frames == total for _, base, grass, frames, total in rank3_rows)
assert max(row[-1] for row in rank3_rows) == 16

# Rank two: Gr(2,6) plus projective spanning frames; m^2 is Gr(2,3).
assert 2 * (6 - 2) + (2 * 3 - 1) == 13
assert 2 + 2 * (3 - 2) + (2 * 3 - 1) == 9

# On the rank-three m^2 stratum, a symmetric form on
# (u^2,uv,v^2) maps onto binary quartics with one-dimensional kernel.
quartic_map = [
    [1, 0, 0, 0, 0, 0],
    [0, 2, 0, 0, 0, 0],
    [0, 0, 2, 1, 0, 0],
    [0, 0, 0, 0, 2, 0],
    [0, 0, 0, 0, 0, 1],
]
assert matrix_rank(quartic_map) == 5
quintic_map = [[0] * 12 for _ in range(6)]
for degree, row in enumerate(quartic_map):
    for column, value in enumerate(row):
        quintic_map[degree][column] += value
        quintic_map[degree + 1][6 + column] += value
assert matrix_rank(quintic_map) == 6

# R^2=4-sum(m_i^2)=0 has precisely the two positive multiplicity patterns.
patterns = []
for m1 in range(1, 3):
    for m2 in range(0, 3):
        for m3 in range(0, 3):
            for m4 in range(0, 3):
                row = tuple(m for m in (m1, m2, m3, m4) if m)
                if tuple(sorted(row, reverse=True)) != row:
                    continue
                if sum(m * m for m in row) == 4:
                    patterns.append(row)
assert patterns == [(1, 1, 1, 1), (2,)]
assert [4 - length for length in (1, 2, 3)] == [3, 2, 1]
assert 4 - 2**2 == 0
print("base-stratum dimensions and multiplicity dichotomy: PASS")


def invariants(multiplicities):
    k_square = 2 * (9 - sum((m - 1) ** 2 for m in multiplicities))
    chi = 11 - sum(comb(m, 2) for m in multiplicities)
    if all(m == 1 for m in multiplicities):
        pg = 10
        p2_invariant = comb(8, 2)
    elif multiplicities == (2,):
        pg = 10 - 1
        p2_invariant = comb(8, 2) - comb(3, 2)
    else:
        raise AssertionError("unexpected base multiplicity pattern")
    q = 1 + pg - chi
    p2 = p2_invariant + 1
    return k_square, chi, pg, q, p2


assert invariants((1,)) == (18, 11, 10, 0, 29)
assert invariants((1, 1, 1, 1)) == (18, 11, 10, 0, 29)
assert invariants((2,)) == (16, 10, 9, 0, 26)
print("base-blowup branch classes and invariants: PASS")

# Integral-conic incidence.  V(d)=3d+27 and the conic family through a
# simple length-h cluster has dimension 5-h.
assert [rank_one_bound(d, 8) for d in range(4, -1, -1)] == [17, 15, 13, 11, 10]
simple_rows = []
for h in range(5):
    d = 4 - h
    target = 6 * 9 - 3 * (9 - d)
    assert target == 3 * d + 27
    cone = rank_one_bound(d, 8)
    conics = 5 - h
    simple_rows.append((h, d, target, cone, conics, target - cone - conics))
assert simple_rows == [
    (0, 4, 39, 17, 5, 17),
    (1, 3, 36, 15, 4, 17),
    (2, 2, 33, 13, 3, 17),
    (3, 1, 30, 11, 2, 17),
    (4, 0, 27, 10, 1, 16),
]
m2_through = 3 * 2 + 27 - rank_one_bound(2, 8) - 4
assert m2_through == 16
assert 17 > 16
assert 16 > 10
assert 16 > 13
assert 16 > 9
print("integral-conic incidence margins: PASS")

# A uniform t=2 root removes only [5] from the retained squarefree list.
profiles = [
    (5,),
    (4, 3, 2),
    (4, 2, 2, 2, 2),
    (3, 3, 3, 2),
    (3, 3, 2, 2, 2, 2),
    (3, 2, 2, 2, 2, 2, 2, 2),
]
assert [profile for profile in profiles if 2 in profile] == profiles[1:]
print("multiplicity-two squarefree profile reduction: PASS")

# Three-line margins for a [5] point off the base scheme.
off_base_rows = []
for rho in (10, 11):
    balanced_fixed = 54 - 3 * (21 - rho)
    unbalanced_fixed = 54 - 3 * (22 - rho)
    off_base_rows.append(
        (rho, balanced_fixed, balanced_fixed - 18,
         unbalanced_fixed, unbalanced_fixed - 15)
    )
assert off_base_rows == [
    (10, 21, 3, 18, 3),
    (11, 24, 6, 21, 6),
]
assert 2 + 2 + 3 + 8 == 15
assert 2 + 2 * (3 - 2) + 3 + 8 == 15
print("off-base [5] three-line margins: PASS")

# Proper simple base: stratify by first-jet rank.  The exceptional
# filtration has graded kernel at most four for rank two and nine for rank
# one, giving restriction-image lower bounds 50 and 45.
def chi_blowup_line_bundle(h_coefficient, e_coefficient):
    intersection = (
        h_coefficient * (h_coefficient + 3)
        - e_coefficient * (e_coefficient - 1)
    )
    return 1 + intersection // 2


assert chi_blowup_line_bundle(-1, 4) == -6  # h0=h2=0, hence h1=6
assert chi_blowup_line_bundle(1, 3) == 0    # h0=3,h2=0, hence h1=3
assert sum((1, 2, 3)) == 6
assert sum((1, 2)) == 3
assert [symmetric_euler_h1_rank(j) for j in (2, 3, 4)] == [0, 5, 9]
assert (3 + 6 + 9) - sum((0, 5, 9)) == 4
assert [symmetric_euler_h1_rank(j, 1) for j in (2, 3, 4)] == [0, 3, 6]
assert (3 + 6 + 9) - sum((0, 3, 6)) == 9
proper_images = [(2, 72 - (6 * 3 + 4), 16),
                 (1, 72 - (6 * 3 + 9), 14)]
assert proper_images == [(2, 50, 16), (1, 45, 14)]
proper_rows = []
for first_jet_rank, proper_image, stratum_dimension in proper_images:
    for rho in (10, 11):
        line_bad = 7 + (11 - (rho - 2))
        fixed = proper_image - 3 * line_bad
        proper_rows.append(
            (first_jet_rank, rho, line_bad, fixed,
             fixed - stratum_dimension)
        )
assert proper_rows == [
    (2, 10, 10, 20, 4),
    (2, 11, 9, 23, 7),
    (1, 10, 10, 15, 1),
    (1, 11, 9, 18, 4),
]
print("proper-base [5] exceptional-filtration margins: PASS")
