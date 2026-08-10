#!/usr/bin/env python3
"""Finite exact checks for THEOREM.md; no search is performed."""

from fractions import Fraction


P = 11
Q = 5                 # multiplier on geometric points of A
Q_DUAL = 9            # multiplier on X(A)
E = (1, 9, 4, 3, 5)


def rank_q(matrix):
    a = [[Fraction(x) for x in row] for row in matrix]
    rows = len(a)
    cols = len(a[0]) if rows else 0
    rank = 0
    for col in range(cols):
        pivot = next((r for r in range(rank, rows) if a[r][col]), None)
        if pivot is None:
            continue
        a[rank], a[pivot] = a[pivot], a[rank]
        d = a[rank][col]
        a[rank] = [x / d for x in a[rank]]
        for r in range(rows):
            if r != rank and a[r][col]:
                d = a[r][col]
                a[r] = [x - d * y for x, y in zip(a[r], a[rank])]
        rank += 1
    return rank


assert pow(Q, 5, P) == 1 and Q % P != 1
assert (Q * Q_DUAL) % P == 1
assert all(E[(i + 1) % 5] % P == Q_DUAL * E[i] % P for i in range(5))

# sigma(f_i)=f_{i+1}; coefficient of f_j in sigma(b)/b^5.
diff = tuple(E[(j - 1) % 5] - Q * E[j] for j in range(5))
assert diff == (0, -44, -11, -11, -22)
assert all(d % P == 0 for d in diff)
c_exp = tuple(d // P for d in diff)
assert c_exp == (0, -4, -1, -1, -2)
assert sum(E) == 22 and sum(E) % P == 0
assert sum(c_exp) == -8

# The explicit semilinear lift S*(y)=c*y^5 has order five.
# S^5(y)=D*y^(5^5), with
# D=sigma^4(c)*sigma^3(c)^5*sigma^2(c)^25*sigma(c)^125*c^625.
d_exp = tuple(
    sum((Q ** (4 - k)) * c_exp[(j - k) % 5] for k in range(5))
    for j in range(5)
)
assert d_exp == (-284, -2556, -1136, -852, -1420)
assert pow(Q, 5) == 1 + 284 * P
assert all(d_exp[j] + 284 * E[j] == 0 for j in range(5))

# The augmentation lattice of a five-place permutation orbit has rank four.
cycle_minus_identity = []
for i in range(5):
    row = [0] * 5
    row[i] -= 1
    row[(i + 1) % 5] += 1
    cycle_minus_identity.append(row)
assert rank_q(cycle_minus_identity) == 4

# Special-fiber component permutations a:k|->k+1 and h:k|->5k.
def compose(f, g):
    return tuple(f[g[i]] for i in range(P))


identity = tuple(range(P))
a = tuple((i + 1) % P for i in range(P))
h = tuple((Q * i) % P for i in range(P))

def inverse(f):
    out = [None] * len(f)
    for i, j in enumerate(f):
        out[j] = i
    return tuple(out)


def power(f, n):
    out = identity
    for _ in range(n):
        out = compose(f, out)
    return out


assert power(a, 11) == identity and power(a, 1) != identity
assert power(h, 5) == identity and power(h, 1) != identity
assert compose(compose(h, a), inverse(h)) == power(a, Q)

group = {compose(power(a, i), power(h, j)) for i in range(11) for j in range(5)}
assert len(group) == 55
assert {a[i] for i in range(P)} == set(range(P))  # C11 is transitive on components

# At s=0, y=z*x^2 and c=x^-8 give sigma(z)=z^5.
assert -8 + 2 * Q - 2 == 0

print("KERNEL-VALUATION-COPRIME-AND-BRANCH-AUDIT-OK")
print("character_multiplier=9 point_multiplier=5")
print(f"descent_difference={diff} c_exponents={c_exp}")
print("explicit_semilinear_descent_order=5")
print("branch_support_augmentation_rank=4")
print("special_component_permutation_group_order=55")
