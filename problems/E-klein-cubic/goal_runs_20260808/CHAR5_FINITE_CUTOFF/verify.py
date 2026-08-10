#!/usr/bin/env python3
"""Dependency-free replay for the characteristic-five Frobenius countertower.

The script checks the exact weight/reindexing, monomial-map dominance
certificate, Hasse-binomial boundary, and Klein pullback identity.  The
finite-generation statement in THEOREM.md is formal graded module theory and
does not pretend that an explicit generating set has been computed here.
"""

from __future__ import annotations

from math import prod
from itertools import combinations


P = 5
WEIGHTS = (1, 9, 4, 3, 5)
MODULUS = 11


def binomial_mod_prime_by_lucas(n: int, r: int, p: int) -> int:
    """Return binomial(n,r) modulo p by Lucas' theorem."""

    answer = 1
    while n or r:
        ni, ri = n % p, r % p
        if ri > ni:
            return 0
        numerator = prod(range(ni - ri + 1, ni + 1))
        denominator = prod(range(1, ri + 1))
        answer = answer * numerator * pow(denominator, -1, p) % p
        n //= p
        r //= p
    return answer


def klein_support() -> set[tuple[int, ...]]:
    support: set[tuple[int, ...]] = set()
    for index in range(5):
        exponent = [0] * 5
        exponent[index] += 2
        exponent[(index + 1) % 5] += 1
        support.add(tuple(exponent))
    return support


def pullback_support(n: int) -> set[tuple[int, ...]]:
    degree = P**n
    support: set[tuple[int, ...]] = set()
    for index in range(5):
        exponent = [0] * 5
        exponent[(index + n) % 5] += 2 * degree
        exponent[(index + 1 + n) % 5] += degree
        support.add(tuple(exponent))
    return support


def frobenius_power_support(n: int) -> set[tuple[int, ...]]:
    degree = P**n
    return {tuple(degree * item for item in exponent) for exponent in klein_support()}


def verify_level(n: int) -> None:
    degree = P**n

    # Output coordinate i must have C11 weight w_i.
    for index in range(5):
        source_index = (index + n) % 5
        assert WEIGHTS[source_index] * degree % MODULUS == WEIGHTS[index]

    # The exponent matrix is degree times a permutation matrix.  Its absolute
    # determinant is degree^5, proving algebraic independence over Z even
    # though its ordinary Jacobian is zero in characteristic five.
    exponent_rows = []
    for index in range(5):
        row = [0] * 5
        row[(index + n) % 5] = degree
        exponent_rows.append(row)
    assert all(sum(value != 0 for value in row) == 1 for row in exponent_rows)
    assert {next(i for i, value in enumerate(row) if value) for row in exponent_rows} == set(range(5))
    determinant_absolute_value = prod(next(value for value in row if value) for row in exponent_rows)
    assert determinant_absolute_value == degree**5

    # Distinct coordinate variables give gcd one.
    common_support = set(i for i, value in enumerate(exponent_rows[0]) if value)
    for row in exponent_rows[1:]:
        common_support &= {i for i, value in enumerate(row) if value}
    assert not common_support

    # Ordinary derivatives vanish, and Lucas gives the exact first nonzero
    # one-variable Hasse derivative order.
    assert degree % P == 0
    for order in range(1, degree):
        assert binomial_mod_prime_by_lucas(degree, order, P) == 0
    assert binomial_mod_prime_by_lucas(degree, degree, P) == 1

    # Freshman's dream plus cyclic reindexing.
    assert pullback_support(n) == frobenius_power_support(n)


def elementary(values: tuple[int, ...], degree: int, modulus: int) -> int:
    return sum(prod(values[index] for index in choice) for choice in combinations(range(5), degree)) % modulus


def verify_invariant_recurrence() -> None:
    """Check the common-root recurrence on exact characteristic-five samples."""

    samples = (
        (0, 1, 2, 3, 4),
        (1, 1, 2, 4, 3),
        (2, 0, 4, 1, 3),
        (4, 3, 1, 0, 2),
    )
    for source in samples:
        b = tuple((pow(source[i], 11, P) - pow(source[(i + 1) % 5], 11, P)) % P for i in range(5))
        e = (1,) + tuple(elementary(b, degree, P) for degree in range(1, 6))
        assert e[1] == 0
        for root_index, root in enumerate(b):
            for power in range(5, 21):
                right = sum(
                    (-1) ** (degree + 1) * e[degree] * pow(root, power - degree, P)
                    for degree in range(1, 6)
                ) % P
                assert pow(root, power, P) == right, (source, root_index, power)


def main() -> None:
    assert all(WEIGHTS[(i + 1) % 5] == 9 * WEIGHTS[i] % MODULUS for i in range(5))
    assert 9 * P % MODULUS == 1

    for n in range(1, 7):
        verify_level(n)

    verify_invariant_recurrence()

    # Any bounded generator/jet window is escaped by a theorem-forced level.
    for bound in (1, 4, 5, 26, 100, 1000, 10_000):
        n = 1
        while P**n <= bound:
            n += 1
        assert P**n > bound

    print("F55-CHAR5-FROBENIUS-COUNTERTOWER-EXACT")
    print("F55-CHAR5-NO-FINITE-DIFFERENTIAL-CUTOFF")
    print("F55-CHAR5-LANDING-CUTOFF-OPEN")


if __name__ == "__main__":
    main()
