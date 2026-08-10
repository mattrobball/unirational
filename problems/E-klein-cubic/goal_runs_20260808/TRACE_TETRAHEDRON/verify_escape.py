#!/usr/bin/env python3
"""Tiny exact replay for the four-term deletion/polarization escape.

This is not a four-term search.  It checks one analytically constructed
parallelogram support, the four mandatory deletion bridges that it supplies,
and its complete 40-by-5 trace expansion over the Laurent lattice M.
"""

from collections import defaultdict
from itertools import combinations_with_replacement


def normalize(v):
    """Canonical coordinates for Z^5 / Z(1,1,1,1,1)."""
    last = v[4]
    return tuple(x - last for x in v)


def add(*vectors):
    return normalize(tuple(sum(v[i] for v in vectors) for i in range(5)))


def scale(n, v):
    return normalize(tuple(n * x for x in v))


def sigma(v):
    # sigma(e_i)=e_(i+1), so the coefficient in slot j comes from j-1.
    return normalize((v[4], v[0], v[1], v[2], v[3]))


def sigma_power(v, n):
    for _ in range(n % 5):
        v = sigma(v)
    return v


def orbit_representative(v):
    return min(sigma_power(v, k) for k in range(5))


ZERO = (0, 0, 0, 0, 0)
E = tuple(tuple(1 if i == j else 0 for i in range(5)) for j in range(5))
C = scale(-1, E[2])

# s=(0,e0,e1,e0+e1), A=(1,2,3,-6).
SUPPORT = (ZERO, E[0], E[1], add(E[0], E[1]))
COEFFICIENTS = (1, 2, 3, -6)


def base_form(p, q, r):
    """Exponent -e2+s_p+s_q+sigma(s_r), before taking trace."""
    return add(C, SUPPORT[p], SUPPORT[q], sigma(SUPPORT[r]))


def main():
    assert len(set(SUPPORT)) == 4
    assert sum(COEFFICIENTS) == 0
    assert COEFFICIENTS[0] * COEFFICIENTS[3] + COEFFICIENTS[1] * COEFFICIENTS[2] == 0

    # The same rank-one relation s0+s3=s1+s2 gives two collision classes.
    bridges = []
    for r in (1, 2):
        left = base_form(0, 3, r)
        right = base_form(1, 2, r)
        assert left == right
        left_coeff = 2 * COEFFICIENTS[0] * COEFFICIENTS[3] * COEFFICIENTS[r]
        right_coeff = 2 * COEFFICIENTS[1] * COEFFICIENTS[2] * COEFFICIENTS[r]
        assert left_coeff + right_coeff == 0
        bridges.append((r, left, left_coeff, right_coeff))

    # r=1 bridges deletions 0 and 2; r=2 bridges deletions 1 and 3.
    deletion_pairs = {
        0: ((1, 2, 1), (0, 3, 1)),
        2: ((0, 3, 1), (1, 2, 1)),
        1: ((0, 3, 2), (1, 2, 2)),
        3: ((1, 2, 2), (0, 3, 2)),
    }
    for deleted, (internal, external) in deletion_pairs.items():
        assert deleted not in internal
        assert deleted in external
        assert base_form(*internal) == base_form(*external)

    # Complete exact expansion: 40 symmetric base terms and their five trace
    # conjugates.  Multiplicity is 1 on p=q and 2 on p<q.
    trace = defaultdict(int)
    contributors = defaultdict(list)
    base_classes = defaultdict(int)
    base_class_contributors = defaultdict(list)
    base_count = 0
    for p, q in combinations_with_replacement(range(4), 2):
        multiplicity = 1 if p == q else 2
        for r in range(4):
            base_count += 1
            exponent = base_form(p, q, r)
            coefficient = (
                multiplicity
                * COEFFICIENTS[p]
                * COEFFICIENTS[q]
                * COEFFICIENTS[r]
            )
            representative = orbit_representative(exponent)
            base_classes[representative] += coefficient
            base_class_contributors[representative].append((p, q, r, coefficient))
            for k in range(5):
                traced_exponent = sigma_power(exponent, k)
                trace[traced_exponent] += coefficient
                contributors[traced_exponent].append((p, q, r, k, coefficient))

    assert base_count == 40
    expected_bridge_class_totals = {1: -36, 2: -24}
    for r, exponent, _, _ in bridges:
        representative = orbit_representative(exponent)
        assert base_classes[representative] == expected_bridge_class_totals[r]
        print("BRIDGE_CLASS", r, base_classes[representative], base_class_contributors[representative])
    trace = {exponent: coefficient for exponent, coefficient in trace.items() if coefficient}
    assert trace

    # Select a deterministic surviving Laurent coefficient as a certificate.
    witness_exponent = min(trace)
    witness_coefficient = trace[witness_exponent]
    witness_contributors = contributors[witness_exponent]
    assert sum(item[4] for item in witness_contributors) == witness_coefficient

    print("FOUR_TERM_BASE_CONTRIBUTIONS", base_count)
    print("FOUR_TERM_TRACE_CONTRIBUTIONS", 5 * base_count)
    print("PARALLELOGRAM_COLLISION_ROW_RANK", 1)
    print("DELETION_BRIDGES", len(deletion_pairs))
    print("BRIDGE_COEFFICIENTS", [(item[2], item[3]) for item in bridges])
    print("NONZERO_TRACE_CLASSES", len(trace))
    print("SURVIVING_CLASS_EXPONENT", witness_exponent)
    print("SURVIVING_CLASS_COEFFICIENT", witness_coefficient)
    print("SURVIVING_CLASS_CONTRIBUTORS", witness_contributors)
    print("FOUR-TERM-DELETION-POLARIZATION-ESCAPE-NOT-SOLUTION-OK")


if __name__ == "__main__":
    main()
