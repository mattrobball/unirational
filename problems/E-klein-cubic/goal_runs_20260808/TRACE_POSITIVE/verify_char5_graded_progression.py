#!/usr/bin/env python3
"""Fixed exact replay for CHAR5_GRADED_PROGRESSION.md.

This checks sixteen residue pairs, degree at most three in the finite weight
lemma, and sixteen stored coordinate-valuation profiles.  It does not scan
covariant degrees, polynomial supports, coefficients, or finite fields.
"""

from collections import defaultdict
from itertools import combinations_with_replacement


P = 5
W = (1, 9, 4, 3, 5)
TERMS = (
    ("HHH", (2, 0, 1, 0)),
    ("HHK", (2, 0, 0, 1)),
    ("HKH", (1, 1, 1, 0)),
    ("HKK", (1, 1, 0, 1)),
    ("KKH", (0, 2, 1, 0)),
    ("KKK", (0, 2, 0, 1)),
)

EXPECTED = {
    (1, 1): ("01234", "12340", 2, 10, 2, 7, 1),
    (1, 2): ("01234", "23401", 2, 6, 2, 10, 2),
    (1, 3): ("01234", "34012", 2, 8, 2, 3, 3),
    (1, 4): ("01234", "40123", 2, 7, 2, 1, 4),
    (2, 1): ("02413", "13024", 8, 10, 3, 7, 3),
    (2, 2): ("02413", "24130", 8, 7, 3, 1, 1),
    (2, 3): ("02413", "30241", 8, 6, 3, 10, 4),
    (2, 4): ("02413", "41302", 8, 2, 3, 2, 2),
    (3, 1): ("03142", "14203", 9, 5, 5, 8, 2),
    (3, 2): ("03142", "20314", 9, 4, 5, 6, 4),
    (3, 3): ("03142", "31420", 9, 1, 5, 0, 1),
    (3, 4): ("03142", "42031", 9, 3, 5, 4, 3),
    (4, 1): ("04321", "10432", 4, 3, 6, 4, 4),
    (4, 2): ("04321", "21043", 4, 5, 6, 8, 3),
    (4, 3): ("04321", "32104", 4, 1, 6, 0, 2),
    (4, 4): ("04321", "43210", 4, 9, 6, 5, 1),
}

PROFILES = {
    (1, 1): ("01000", "00001"),
    (1, 2): ("00000", "00001"),
    (1, 3): ("00002", "00110"),
    (1, 4): ("01001", "01011"),
    (2, 1): ("00000", "00000"),
    (2, 2): ("00000", "00001"),
    (2, 3): ("00001", "01001"),
    (2, 4): ("00000", "00000"),
    (3, 1): ("00100", "00000"),
    (3, 2): ("01001", "01011"),
    (3, 3): ("01012", "01001"),
    (3, 4): ("00000", "00001"),
    (4, 1): ("00002", "01001"),
    (4, 2): ("00001", "01001"),
    (4, 3): ("00001", "00110"),
    (4, 4): ("00001", "00012"),
}


def rho(vector, power=1):
    power %= 5
    return tuple(vector[(j - power) % 5] for j in range(5))


def weight(vector):
    return sum(x * w for x, w in zip(vector, W)) % 11


def parse(digits):
    return tuple(int(x) for x in digits)


def weight_set(degree, allowed=range(5)):
    return {
        sum(W[i] for i in indices) % 11
        for indices in combinations_with_replacement(tuple(allowed), degree)
    }


def buckets(a, b):
    result = defaultdict(list)
    for i in range(5):
        ai, bi = rho(a, i), rho(b, i)
        a1, b1 = rho(a, i + 1), rho(b, i + 1)
        for name, multiplicities in TERMS:
            hi, ki, h1, k1 = multiplicities
            exponent = tuple(
                hi * ai[j] + ki * bi[j] + h1 * a1[j] + k1 * b1[j]
                for j in range(5)
            )
            residue = tuple(x % 5 for x in exponent)
            carry = tuple(x // 5 for x in exponent)
            result[residue].append((i, name, multiplicities, carry))
    assert sorted(len(value) for value in result.values()) == [6] * 5
    return tuple(result.values())


def valuation_profile_ok(a, b, p, q):
    for bucket in buckets(a, b):
        for j in range(5):
            values = []
            for i, _, (hi, ki, h1, k1), carry in bucket:
                values.append(
                    carry[j]
                    + hi * p[(j - i) % 5]
                    + ki * q[(j - i) % 5]
                    + h1 * p[(j - i - 1) % 5]
                    + k1 * q[(j - i - 1) % 5]
                )
            assert values.count(min(values)) >= 2

    # The common coordinate gcd of all five cyclic coordinates is zero.
    common_at_x0 = min(
        min(
            rho(a, i)[0] + 5 * p[(-i) % 5],
            rho(b, i)[0] + 5 * q[(-i) % 5],
        )
        for i in range(5)
    )
    assert common_at_x0 == 0


def main():
    assert pow(5, -1, 11) == 9

    for d in range(1, 5):
        a = tuple((d * j) % 5 for j in range(5))
        assert sorted(a) == list(range(5))
        assert sum(a) == 10
        for r in range(1, 5):
            b = tuple((entry + r) % 5 for entry in a)
            assert sorted(b) == list(range(5))
            assert sum(b) == 10
            A, B = weight(a), weight(b)
            wh = 9 * (1 - A) % 11
            wk = 9 * (1 - B) % 11
            delta = r * pow(d, -1, 5) % 5
            expected = (
                "".join(map(str, a)),
                "".join(map(str, b)),
                A,
                B,
                wh,
                wk,
                delta,
            )
            assert expected == EXPECTED[d, r]

            epsilon = tuple((a[j] + r - b[j]) // 5 for j in range(5))
            assert set(epsilon) <= {0, 1}
            assert sum(epsilon) == r
            assert all(b[j] - a[j] == r - 5 * epsilon[j]
                       for j in range(5))
            # x^(-epsilon) K/H has weight zero, so the Kummer congruence
            # lives in the C11 quotient field itself.
            assert (-weight(epsilon) + wk - wh) % 11 == 0

            p, q = map(parse, PROFILES[d, r])
            valuation_profile_ok(a, b, p, q)

    assert weight_set(0) == {0}
    assert weight_set(1) == {1, 3, 4, 5, 9}
    assert weight_set(2) == set(range(1, 11))
    assert weight_set(3) == set(range(11))

    # Degree-three polynomials of every weight can avoid each coordinate.
    for omitted in range(5):
        allowed = [j for j in range(5) if j != omitted]
        assert weight_set(3, allowed) == set(range(11))

    # Exactly two pairs exist in root degree one.
    degree_one = weight_set(1)
    degree_one_pairs = {
        pair for pair, row in EXPECTED.items()
        if row[4] in degree_one and row[5] in degree_one
    }
    assert degree_one_pairs == {(2, 2), (3, 4)}

    # The adjacent boundary factor alternatives for (2,2) cannot occur in
    # root degree two: the residual degree-one weights would be 2 or 7.
    assert 2 not in degree_one
    assert 7 not in degree_one

    root_degree_at_least_three = {(2, 2), (3, 3), (4, 3)}
    assert root_degree_at_least_three == {
        (2, 2),
        *(pair for pair, row in EXPECTED.items() if row[5] == 0),
    }

    print("FAMILY_COUNT=16")
    print("ALL_PROGRESSION_LANDINGS_DEGREE_AT_LEAST=20")
    print("FAMILIES_DEGREE_AT_LEAST_25=(2,2),(3,3),(4,3)")
    print("COORDINATE_VALUATION_COUNTERPROFILES=16")
    print("F55-CHAR5-GRADED-PROGRESSION-BOUNDARY-OK")
    print("F55-CHAR5-PROGRESSION-ALL-DEGREE-OPEN")
    print("F55-QUESTION-OPEN")


if __name__ == "__main__":
    main()
