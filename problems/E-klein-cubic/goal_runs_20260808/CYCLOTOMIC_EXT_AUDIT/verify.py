#!/usr/bin/env python3
"""Forced finite checks for CYCLOTOMIC_EXT_AUDIT/THEOREM.md.

This checks four eigencharacters and the exterior Smith forms.  It is not a
degree, support, coefficient, covariant, or geometric-model search.
"""

from itertools import combinations

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form


P = 11
roots = (3, 4, 5, 9)
assert sorted(x for x in range(P) if (x**4+x**3+x**2+x+1) % P == 0) == list(roots)

# M has character 9, hence M^vee has character 5.  Ext^1 selects target
# character 9 because 9*5=1 mod 11.
assert pow(9, -1, P) == 5

exterior_characters = {}
ext1_dimensions = {}
for q in range(5):
    chars = []
    for inds in combinations(range(4), q):
        value = 1
        for i in inds:
            value = value * roots[i] % P
        chars.append(value)
    exterior_characters[q] = sorted(chars)
    ext1_dimensions[q] = chars.count(9)

assert exterior_characters == {
    0: [1],
    1: [3, 4, 5, 9],
    2: [1, 1, 3, 4, 5, 9],
    3: [3, 4, 5, 9],
    4: [1],
}
assert ext1_dimensions == {0: 0, 1: 1, 2: 1, 3: 1, 4: 0}

# The actual multiplication matrix from TWISTED_KERNEL_CYCLOTOMIC.
A = sp.Matrix(
    [
        [-1, -1, 2, 0],
        [-1, -2, 1, 2],
        [-1, -2, 0, 1],
        [1, -2, 0, 0],
    ]
)
assert A.det() == 11
assert smith_normal_form(A, domain=sp.ZZ) == sp.diag(1, 1, 1, 11)

# Exterior Smith form: wedge^q diag(1,1,1,11).
exterior_smith = {}
for q in range(1, 5):
    diagonal = []
    for inds in combinations(range(4), q):
        diagonal.append(11 if 3 in inds else 1)
    exterior_smith[q] = sorted(diagonal)
assert exterior_smith == {
    1: [1, 1, 1, 11],
    2: [1, 1, 1, 11, 11, 11],
    3: [1, 11, 11, 11],
    4: [11],
}

# Mod 11, alpha vanishes on the root 9.  The cokernel of wedge^q(alpha)
# consists of wedges containing this eigenline.
other = (3, 4, 5)
cokernel_characters = {}
for q in range(1, 5):
    chars = []
    for inds in combinations(range(3), q - 1):
        value = 9
        for i in inds:
            value = value * other[i] % P
        chars.append(value)
    cokernel_characters[q] = sorted(chars)

assert cokernel_characters == {
    1: [9],
    2: [1, 3, 5],
    3: [3, 4, 9],
    4: [1],
}
assert [cokernel_characters[q].count(9) for q in range(1, 5)] == [1, 0, 1, 0]

# On I/(gamma-1)I=Z/5 the element alpha evaluates at zeta=1.
alpha_at_one = 1 - 1 - 1 - 1
assert alpha_at_one % 5 == 3
assert sp.gcd(alpha_at_one, 5) == 1

# H^*(BC11,F11)=F11[v] tensor Exterior(u), with both generators carrying
# an order-five character.  List the first invariant monomial degrees.
invariant_group_cohomology_degrees = []
for a in range(11):
    for epsilon in (0, 1):
        if a == 0 and epsilon == 0:
            continue
        if (a + epsilon) % 5 == 0:
            invariant_group_cohomology_degrees.append(2 * a + epsilon)
assert sorted(set(invariant_group_cohomology_degrees))[:2] == [9, 10]
assert all(d not in invariant_group_cohomology_degrees for d in range(1, 9))

print("EXT1_DIMS", ext1_dimensions)
print("EXTERIOR_COKERNEL_CHARS", cokernel_characters)
print("TOP_EXTERIOR", "F11(1)", "NOT", "F11(9)")
print("TATE_H_ODD_I_MAP", "times", alpha_at_one % 5, "on Z/5")
print("FIRST_MOD11_GROUP_COHOMOLOGY_INVARIANT_DEGREES", 9, 10)
print("CYCLOTOMIC-EXT-EXTERIOR-AUDIT-OK")
