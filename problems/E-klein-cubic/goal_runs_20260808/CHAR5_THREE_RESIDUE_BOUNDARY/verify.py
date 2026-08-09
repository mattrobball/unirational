#!/usr/bin/env python3
"""Dependency-free exact replay for the three-residue characteristic-5 boundary."""

from collections import Counter, defaultdict
from itertools import permutations, product


P = 5
W = (1, 9, 4, 3, 5)


def rho(v, power=1):
    """Cyclic exponent shift: rho(v)_j = v_(j-1)."""
    power %= 5
    if power == 0:
        return tuple(v)
    return tuple(v[-power:] + v[:-power])


def add(*vectors):
    return tuple(sum(v[j] for v in vectors) for j in range(5))


def residue(v):
    return tuple(x % P for x in v)


def weight(v):
    return sum(v[j] * W[j] for j in range(5)) % 11


def param_monomial(j, k, ell):
    out = [0] * 5
    out[j] += 1
    out[k] += 1
    out[ell] += 1
    return tuple(out)


def determinant(matrix):
    total = 0
    for perm in permutations(range(5)):
        inversions = sum(
            1 for i in range(5) for j in range(i + 1, 5) if perm[i] > perm[j]
        )
        term = 1
        for i in range(5):
            term *= matrix[i][perm[i]]
        total += (-1 if inversions % 2 else 1) * term
    return total


def monomial_divides(a, b):
    """Return whether x^a divides x^b."""
    return all(a[j] <= b[j] for j in range(5))


# All three residues have ordinary degree ten and the same Frobenius degree.
A = (
    (4, 0, 4, 1, 1),
    (0, 4, 1, 1, 4),
    (0, 0, 3, 4, 3),
)
assert [sum(a) for a in A] == [10, 10, 10]
assert [sum(a) % 5 for a in A] == [0, 0, 0]

# Count the 5 * Sym^2(3) * 3 = 90 symbolic cubic occurrences by
# Frobenius residue.  A singleton bucket would force non-landing.
buckets = Counter()
for i in range(5):
    left = [rho(a, i) for a in A]
    right = [rho(a, i + 1) for a in A]
    for j in range(3):
        for k in range(j, 3):
            for ell in range(3):
                buckets[residue(add(left[j], left[k], right[ell]))] += 1

distribution = Counter(buckets.values())
assert sum(buckets.values()) == 90
assert len(buckets) == 25
assert distribution == Counter({2: 5, 3: 10, 4: 5, 6: 5})
assert min(buckets.values()) == 2

# The C11 weights of the three residues force fifth-root weights 10,3,10.
residue_weights = [weight(a) for a in A]
root_weights = [(9 * (1 - w)) % 11 for w in residue_weights]
assert residue_weights == [6, 8, 6]
assert root_weights == [10, 3, 10]

degree_two_by_weight = defaultdict(list)
for e in product(range(3), repeat=5):
    if sum(e) == 2:
        degree_two_by_weight[weight(e)].append(e)

weight10 = sorted(degree_two_by_weight[10])
weight3 = sorted(degree_two_by_weight[3])
assert weight10 == [(0, 0, 0, 0, 2), (1, 1, 0, 0, 0)]
assert weight3 == [(0, 1, 0, 0, 1)]

# Hence the complete degree-20 lift with precisely these residue components
# has five coefficient parameters.  These are the exponent vectors of its
# five monomials, in parameter order a,b,c,d,e.
U = (
    add(A[0], tuple(5 * x for x in weight10[0])),
    add(A[0], tuple(5 * x for x in weight10[1])),
    add(A[1], tuple(5 * x for x in weight3[0])),
    add(A[2], tuple(5 * x for x in weight10[0])),
    add(A[2], tuple(5 * x for x in weight10[1])),
)
assert U == (
    (4, 0, 4, 1, 11),
    (9, 5, 4, 1, 1),
    (0, 9, 1, 1, 9),
    (0, 0, 3, 4, 13),
    (5, 5, 3, 4, 3),
)
assert all(sum(u) == 20 for u in U)
assert all(weight(u) == 1 for u in U)
assert [residue(u) for u in U] == [A[0], A[0], A[1], A[2], A[2]]

# Expand K(T_f) exactly.  Each source exponent has a cubic coefficient in
# a,b,c,d,e, represented as {parameter-exponent: coefficient mod 5}.
equations = defaultdict(lambda: defaultdict(int))
for i in range(5):
    left = [rho(u, i) for u in U]
    right = [rho(u, i + 1) for u in U]
    for j in range(5):
        for k in range(j, 5):
            square_coefficient = 1 if j == k else 2
            for ell in range(5):
                source_exp = add(left[j], left[k], right[ell])
                pm = param_monomial(j, k, ell)
                equations[source_exp][pm] = (
                    equations[source_exp][pm] + square_coefficient
                ) % P

# Remove coefficient monomials which cancel modulo five, then zero equations.
clean_equations = {}
for source_exp, polynomial in equations.items():
    clean = {pm: c for pm, c in polynomial.items() if c % P}
    if clean:
        clean_equations[source_exp] = clean

assert len(clean_equations) == 320
distinct_equations = {tuple(sorted(poly.items())) for poly in clean_equations.values()}
assert len(distinct_equations) == 52

# Each pure parameter cube occurs as a coefficient equation by itself.
# Therefore the landing ideal contains (a^3,b^3,c^3,d^3,e^3), and its
# projectivization is empty over every field of characteristic five.
pure_cube_sources = {}
for j in range(5):
    cube = tuple(3 if q == j else 0 for q in range(5))
    matches = [
        source_exp
        for source_exp, poly in clean_equations.items()
        if poly == {cube: 1}
    ]
    assert len(matches) == 5
    pure_cube_sources[j] = sorted(matches)[0]

# All-degree prime-intersection gate.  Modulo (f_i,f_(i+2)), exactly the
# term f_(i+3)^2 f_(i+4) survives from the Klein equation.
for i in range(5):
    surviving_terms = []
    for j in range(5):
        factors = {j, (j + 1) % 5}
        if i not in factors and (i + 2) % 5 not in factors:
            surviving_terms.append(j)
    assert surviving_terms == [(i + 3) % 5]

# The nonprime condition by itself cannot close the proof.  The weight-one
# monomial f=x0^3*x1 has gcd-one cyclic coordinates, all five nonadjacent
# ideals nonprime, and a dominant cyclic monomial map.
counter_u = (3, 1, 0, 0, 0)
counter_rows = [rho(counter_u, i) for i in range(5)]
assert [weight(row) for row in counter_rows] == [1, 9, 4, 3, 5]
assert tuple(min(row[j] for row in counter_rows) for j in range(5)) == (0,) * 5
assert determinant(counter_rows) == 244
counter_klein_exponents = [
    add(counter_rows[i], counter_rows[i], counter_rows[(i + 1) % 5])
    for i in range(5)
]
assert len(set(counter_klein_exponents)) == 5
for i in range(5):
    generators = (counter_rows[i], counter_rows[(i + 2) % 5])
    first = tuple(1 if j == i else 0 for j in range(5))
    second = list(counter_rows[i])
    second[i] -= 1
    second = tuple(second)
    assert not any(monomial_divides(g, first) for g in generators)
    assert not any(monomial_divides(g, second) for g in generators)
    assert any(monomial_divides(g, add(first, second)) for g in generators)

print("THREE_RESIDUE_BUCKET_COUNT", len(buckets))
print("THREE_RESIDUE_BUCKET_DISTRIBUTION", dict(sorted(distribution.items())))
print("DEGREE20_ROOT_WEIGHT_DIMS", len(weight10), len(weight3), len(weight10))
print("DEGREE20_NONZERO_SOURCE_EQUATIONS", len(clean_equations))
print("DEGREE20_DISTINCT_COEFFICIENT_EQUATIONS", len(distinct_equations))
print("PURE_CUBE_WITNESS_SOURCES", pure_cube_sources)
print("F55-CHAR5-THREE-RESIDUE-NO-SINGLETON-EXACT")
print("F55-CHAR5-THREE-RESIDUE-DEGREE20-LIFT-EMPTY")
print("F55-CHAR5-NONADJACENT-PRIME-INTERSECTION-GATE")
print("F55-CHAR5-NONPRIME-GATE-ALONE-REFUTED")
print("F55-CHAR5-ARBITRARY-RESIDUE-SUPPORT-OPEN")
