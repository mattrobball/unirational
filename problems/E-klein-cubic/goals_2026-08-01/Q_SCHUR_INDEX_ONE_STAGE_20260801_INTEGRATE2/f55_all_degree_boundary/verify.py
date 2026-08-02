#!/usr/bin/env python3
"""Independent exact replay for the H=11:5 Hilbert/module and Newton audit."""

from __future__ import annotations

import hashlib
import json
from collections import defaultdict
from itertools import product
from pathlib import Path

WEIGHTS = (1, 9, 4, 3, 5)
HSOP = (3, 5, 6, 8, 11)
EXPECTED_DIMS = (0, 1, 1, 3, 7, 11, 19, 30, 45, 65, 91, 124, 166, 216, 278, 353, 440, 544, 665, 805)
EXPECTED_NUMERATOR = (1, 1, 3, 6, 10, 15, 21, 30, 36, 44, 50, 56, 58, 59, 59, 54, 50, 43, 37, 28, 22, 16, 10, 6, 3, 2)

# The unique maximal degree-seven support left after singleton propagation.
# These are exponent vectors, so this replay does not depend on the producer's
# basis ordering.
D7_SUPPORT = (
    (0, 0, 0, 6, 1), (0, 0, 2, 5, 0), (0, 1, 1, 2, 3),
    (0, 2, 1, 4, 0), (0, 3, 0, 1, 3), (0, 4, 0, 3, 0),
    (1, 0, 0, 4, 2), (1, 0, 2, 3, 1), (1, 1, 1, 0, 4),
    (1, 2, 1, 2, 1), (1, 4, 0, 1, 1), (2, 0, 0, 2, 3),
    (2, 0, 2, 1, 2), (2, 1, 0, 4, 0), (2, 2, 1, 0, 2),
    (3, 0, 0, 0, 4), (3, 1, 0, 2, 1), (4, 1, 0, 0, 2),
)


def shift(e: tuple[int, ...], amount: int) -> tuple[int, ...]:
    out = [0] * 5
    for i, value in enumerate(e):
        out[(i + amount) % 5] = value
    return tuple(out)


def add(*es: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(sum(e[i] for e in es) for i in range(5))


def covariant_dimensions(bound: int) -> list[int]:
    # Coefficient of residue 1 in prod_j (1-t z^a_j)^(-1), z^11=1.
    dp = [[0] * 11 for _ in range(bound + 1)]
    dp[0][0] = 1
    for weight in WEIGHTS:
        nxt = [[0] * 11 for _ in range(bound + 1)]
        for degree in range(bound + 1):
            for residue, count in enumerate(dp[degree]):
                if not count:
                    continue
                for exponent in range(bound - degree + 1):
                    nxt[degree + exponent][(residue + exponent * weight) % 11] += count
        dp = nxt
    return [row[1] for row in dp]


def hilbert_numerator(dimensions: list[int]) -> list[int]:
    values = list(dimensions)
    for degree in HSOP:
        old = values
        values = [old[d] - (old[d - degree] if d >= degree else 0) for d in range(len(old))]
    return values


def landing_equations(support: tuple[tuple[int, ...], ...]):
    equations: dict[tuple[int, ...], dict[tuple[int, int, int], int]] = defaultdict(lambda: defaultdict(int))
    for orbit in range(5):
        qi = [shift(e, orbit) for e in support]
        qn = [shift(e, orbit + 1) for e in support]
        for a, b, c in product(range(len(support)), repeat=3):
            source = add(qi[a], qi[b], qn[c])
            monomial = tuple(sorted((a, b, c)))
            equations[source][monomial] += 1
    return {source: dict(poly) for source, poly in equations.items()}


def canonical_digest(equations) -> str:
    payload = [
        [list(source), [[list(term), coefficient] for term, coefficient in sorted(poly.items())]]
        for source, poly in sorted(equations.items())
    ]
    return hashlib.sha256(json.dumps(payload, separators=(",", ":")).encode()).hexdigest()


def main() -> None:
    dimensions = covariant_dimensions(70)
    assert tuple(dimensions[:20]) == EXPECTED_DIMS
    numerator = hilbert_numerator(dimensions)
    assert tuple(numerator[1:27]) == EXPECTED_NUMERATOR
    assert numerator[0] == 0 and all(value == 0 for value in numerator[27:])
    assert sum(numerator) == 720
    print("PASS exact weight-residue Molien dimensions through degree 70")
    print("PASS hsop numerator has 720 secondary covariants in degrees 1 through 26")
    print("BOUNDARY hsop existence and module freeness are recorded inputs, not reconstructed")
    # Even S-primitive homogeneous covariants have unbounded degree: if e1,e2
    # are free generators of degrees 1,2, then
    # f3^(2+5k)e1 + f5^(1+3k)e2 has degree 7+15k and coprime S-coefficients.
    for k in range(20):
        assert 3 * (2 + 5 * k) + 1 == 5 * (1 + 3 * k) + 2 == 7 + 15 * k
    print("PASS explicit S-primitive module combinations have unbounded degree 7+15k")

    assert all(sum(e) == 7 for e in D7_SUPPORT)
    assert all(sum(a * b for a, b in zip(e, WEIGHTS)) % 11 == 1 for e in D7_SUPPORT)
    base = landing_equations(D7_SUPPORT)
    active_counts = [len(poly) for poly in base.values()]
    assert 1 not in active_counts
    print("PASS degree-seven 18-support has no singleton landing equation")

    # Locate the two literal incompatible equations.  Exponent vectors refer
    # to the fixed support ordering above: old indices 0,2,3,23 become
    # positions 0,1,2,15 here.
    first_terms = {(0, 0, 1): 1, (0, 15, 15): 1}
    second_terms = {(0, 1, 2): 2, (2, 15, 15): 1}
    first = [source for source, poly in base.items() if poly == first_terms]
    second = [source for source, poly in base.items() if poly == second_terms]
    assert len(first) == 5 and (0, 0, 14, 7, 0) in first
    assert len(second) == 5 and (0, 1, 1, 10, 9) in second
    # On the coefficient torus these say A+B=0 and 2A+B=0.
    print("PASS exact characteristic-zero binomial contradiction A+B=0, 2A+B=0")

    one = (1, 1, 1, 1, 1)
    for k in range(1, 8):
        translated = tuple(add(e, tuple(k * x for x in one)) for e in D7_SUPPORT)
        assert all(sum(e) == 7 + 5 * k for e in translated)
        assert all(sum(a * b for a, b in zip(e, WEIGHTS)) % 11 == 1 for e in translated)
        equations = landing_equations(translated)
        assert 1 not in [len(poly) for poly in equations.values()]
        delta = tuple(3 * k for _ in range(5))
        shifted_back = {
            tuple(source[i] - delta[i] for i in range(5)): poly
            for source, poly in equations.items()
        }
        assert shifted_back == base
    print("PASS invariant-monomial translations preserve the no-singleton pattern in degrees 7+5k")
    print("D7_DIGEST", canonical_digest(base))
    print("H_TRACE_HILBERT_NEWTON_AUDIT_OK")


if __name__ == "__main__":
    main()
