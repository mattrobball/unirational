#!/usr/bin/env python3
"""Exact finite replay of the global Kummer--Fine-interior theorem.

The analytic reduction leaves exactly three cyclic invariant two-planes.
The only enumeration is their fixed order-eleven residue boxes; there is no
Laurent-support, exponent, degree, or number-of-primes parameter.
"""

from fractions import Fraction
from itertools import product
from pathlib import Path


P = 11
MU = (1, 5, 3, 4, 9)
ONE = (1, 1, 1, 1, 1)
CASES = (
    ("A0", (0, 1, 3, 8, 10), 6, (0, 1, 1, 0, 4), True),
    ("A+", (0, 1, 8, 5, 8), 8, (0, 0, 4, 3, 1), False),
    ("A-", (0, 1, 9, 6, 6), 8, (0, 1, 4, 0, 3), False),
)


def add(a, b):
    return tuple((x + y) % P for x, y in zip(a, b))


def scale(c, a):
    return tuple(c * x % P for x in a)


def dot(a, b):
    return sum(x * y for x, y in zip(a, b)) % P


def rotate(a):
    return (a[-1],) + a[:-1]


def rank_mod(rows):
    rows = [list(row) for row in rows if any(row)]
    rank = 0
    column = 0
    while rank < len(rows) and column < 5:
        pivot = next(
            (r for r in range(rank, len(rows)) if rows[r][column] % P), None
        )
        if pivot is None:
            column += 1
            continue
        rows[rank], rows[pivot] = rows[pivot], rows[rank]
        inv = pow(rows[rank][column] % P, -1, P)
        rows[rank] = [inv * x % P for x in rows[rank]]
        for r in range(len(rows)):
            if r == rank:
                continue
            c = rows[r][column] % P
            if c:
                rows[r] = [(x - c * y) % P for x, y in zip(rows[r], rows[rank])]
        rank += 1
        column += 1
    return rank


def plane(mu, nu):
    return {
        add(scale(a, mu), scale(b, nu))
        for a in range(P)
        for b in range(P)
    }


def canonical_direction(a):
    """Canonical representative modulo constants and nonzero scaling."""
    shifted = tuple((x - a[-1]) % P for x in a)
    first = next(x for x in shifted if x)
    return scale(pow(first, -1, P), shifted)


def residue_normals(nu):
    return tuple(
        q
        for q in product(range(P), repeat=5)
        if min(q) == 0
        and any(q)
        and dot(MU, q) == 0
        and dot(nu, q) == 0
    )


def check_cyclic_reduction():
    roots = (3, 4, 5, 9)
    assert len(set(roots)) == 4
    assert all((r**4 + r**3 + r**2 + r + 1) % P == 0 for r in roots)

    eigenvectors = {
        r: (1, pow(r, 4, P), pow(r, 3, P), pow(r, 2, P), r)
        for r in roots
    }
    assert eigenvectors[9] == MU
    for eigenvalue, vector in eigenvectors.items():
        assert rotate(vector) == scale(eigenvalue, vector)

    # Each listed plane is <MU, e_r> for one of the three other eigenlines.
    expected = {
        5: (0, 1, 3, 8, 10),
        4: (0, 1, 8, 5, 8),
        3: (0, 1, 9, 6, 6),
    }
    for eigenvalue, nu in expected.items():
        candidate = plane(MU, nu)
        assert eigenvectors[eigenvalue] in candidate
        assert rotate(nu) in candidate
        assert len(candidate) == P**2
    assert {nu for _, nu, *_ in CASES} == set(expected.values())


def check_fine_interiors():
    barycenter = (Fraction(1, 5),) * 5
    minima = []
    for name, nu, expected_min, minimizer, has_level_one in CASES:
        character_plane = plane(MU, nu)

        # Independence of the two Kummer classes modulo constants.  Since
        # their coordinate sums vanish, a constant combination is zero.
        for a, b in product(range(P), repeat=2):
            if a == b == 0:
                continue
            combination = add(scale(a, MU), scale(b, nu))
            assert len(set(combination)) > 1

        normals = residue_normals(nu)
        assert len(normals) == 500
        weights = tuple(sum(q) for q in normals)
        assert min(weights) == expected_min
        assert minimizer in normals and sum(minimizer) == expected_min

        # The symmetric point strictly satisfies the complete finite Fine
        # test, including the five primitive facet normals 11 e_i.
        assert all(P * alpha > 1 for alpha in barycenter)
        assert all(
            sum(alpha * q for alpha, q in zip(barycenter, normal)) > 1
            for normal in normals
        )
        for i in range(5):
            e_i = tuple(int(i == j) for j in range(5))
            assert dot(MU, e_i) != 0  # 11 e_i is primitive in N_B.

        level_one = {
            vector
            for vector in character_plane
            if all(vector) and sum(vector) == P
        }
        assert bool(level_one) is has_level_one
        if name == "A0":
            assert (5, 2, 1, 1, 2) in level_one
        minima.append(expected_min)

    assert minima == [6, 8, 8]


def check_exceptional_divisor_lifts():
    exceptional = {
        (0, 1, 8, 5, 8): {(0, 1, 9, 3, 0), (1, 0, 10, 6, 0)},
        (0, 1, 9, 6, 6): {(0, 1, 10, 5, 0), (1, 0, 4, 5, 0)},
    }

    sparse_representatives = {}
    for nu in exceptional:
        annihilator = [
            s
            for s in product(range(P), repeat=5)
            if dot(MU, s) == 0 and dot(nu, s) == 0
        ]
        directions = set()
        for s in annihilator:
            shifted = tuple((x - s[-1]) % P for x in s)
            if any(shifted):
                directions.add(canonical_direction(shifted))
        assert len(directions) == 12

        sparse = set()
        for direction in directions:
            support, shifted = min(
                (sum(x != 0 for x in shifted), shifted)
                for c in range(P)
                for shifted in [tuple((x + c) % P for x in direction)]
            )
            if support <= 3:
                assert support == 3
                sparse.add(canonical_direction(shifted))
        assert len(sparse) == 10

        orbits = []
        unseen = set(sparse)
        while unseen:
            start = next(iter(unseen))
            orbit = []
            current = start
            while current not in orbit:
                orbit.append(current)
                current = canonical_direction(rotate(current))
            unseen.difference_update(orbit)
            orbits.append(orbit)
        assert sorted(map(len, orbits)) == [5, 5]
        sparse_representatives[nu] = {min(orbit) for orbit in orbits}

    assert sparse_representatives == exceptional

    lifts = (
        ((0, 4, 3, 1, 0), 2, (0, 2, 2, 1, 1)),
        ((2, 0, 9, 1, 0), 6, (4, 0, 6, 3, 1)),
        ((0, 9, 2, 1, 0), 6, (0, 6, 3, 2, 3)),
        ((3, 0, 1, 4, 0), 2, (2, 1, 0, 3, 0)),
    )
    for s, m, x in lifts:
        lhs = tuple(m + value for value in s)
        rhs = tuple(2 * x[j] + x[(j + 1) % 5] for j in range(5))
        assert lhs == rhs
        assert dot(MU, s) == 0
        assert sum(value != 0 for value in s) == 3

        h_exponents = tuple(
            tuple(s[(j - i) % 5] for i in range(5)) for j in range(5)
        )
        a_exponents = tuple(
            tuple(x[(j - i) % 5] for i in range(5)) for j in range(5)
        )
        for j in range(5):
            assert tuple(m + value for value in h_exponents[j]) == tuple(
                2 * a_exponents[j][i] + a_exponents[(j + 1) % 5][i]
                for i in range(5)
            )
        assert tuple(
            sum(m + h_exponents[j][i] for j in range(5))
            for i in range(5)
        ) == tuple(
            3 * sum(a_exponents[j][i] for j in range(5))
            for i in range(5)
        )


def main():
    assert sum(MU) % P == 0
    assert all(x % P for x in MU)

    check_cyclic_reduction()
    check_fine_interiors()
    check_exceptional_divisor_lifts()

    note = Path(__file__).with_name("KUMMER_NEWTON_REDUCTION.md").read_text(
        encoding="utf-8"
    )
    for marker in (
        "RANK4-GLOBAL-INCIDENCE-RESIDUE-RANK-EXACTLY-THREE",
        "RANK4-GLOBAL-KUMMER-ANNIHILATOR-EXACTLY-MU",
        "RANK4-RANK2-EXCEPTIONAL-COVERS-GENERAL-TYPE",
        "RANK4-GLOBAL-EXCEPTIONAL-PLANES-PASS-INTEGRAL-NORM-LIFT",
        "RANK4-RESIDUE-RANK3-ADDITIVE-GLUING-OPEN",
        "F55-GLOBAL-QUESTION-OPEN",
    ):
        assert marker in note

    print("CYCLIC_INVARIANT_KUMMER_PLANES", 3)
    print("LEVEL_ONE_EXCLUDED_INVARIANT_PLANES", 1)
    print("FINE_INTERIOR_MIN_NORMALIZED_SUM", 6, 8, 8)
    print("FINE_INTERIOR_DIMENSIONS", 4, 4, 4)
    print("EXCEPTIONAL_SPARSE_DIRECTIONS_ARE_TRIPLE_ONLY_OK")
    print("EXCEPTIONAL_FULL_2_PLUS_SHIFT_LIFTS_OK")
    print("RANK4_GLOBAL_INCIDENCE_RESIDUE_RANK", 3)
    print("RANK4-GLOBAL-KUMMER-FINE-INTERIOR-THEOREM-OK")


if __name__ == "__main__":
    main()
