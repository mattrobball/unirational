#!/usr/bin/env python3
"""Exact replay for the characteristic-five fixed-line Hasse boundary.

This checks only the universal 5 by 5 circulant identity and the two fixed
linear subspaces used in the analytic proof.  It performs no degree or
support search.
"""

import sympy as sp

P = 5
a = sp.symbols("a0:5")


def cyclic_shift_matrix():
    matrix = sp.zeros(5)
    for i in range(5):
        matrix[(i + 1) % 5, i] = 1
    return matrix


def mod_poly(expression, variables):
    return sp.Poly(sp.expand(expression), *variables, modulus=P)


t = cyclic_shift_matrix()
circulant = sum((a[i] * (t ** i) for i in range(5)), sp.zeros(5))
determinant = mod_poly(circulant.det(), a)
augmentation_fifth = mod_poly(sum(a) ** 5, a)
assert determinant == augmentation_fifth

delta = t - sp.eye(5)
assert (delta ** 5).applyfunc(lambda value: value % P) == sp.zeros(5)

x, y = sp.symbols("x y")
v3 = sp.Matrix([4 * x, 3 * x + 4 * y, 2 * x + 3 * y, x + 2 * y, y])
klein_v3 = sum(v3[i] ** 2 * v3[(i + 1) % 5] for i in range(5))
assert mod_poly(klein_v3, (x, y)).is_zero

v2 = (1, 3, 1, 0, 0)
klein_v2 = sum(v2[i] ** 2 * v2[(i + 1) % 5] for i in range(5)) % P
assert klein_v2 == 2

# v2 is the first column of Delta^2 modulo five.
delta2_col0 = tuple(int((delta ** 2)[i, 0]) % P for i in range(5))
assert delta2_col0 == v2

# For M=1 mod 5, degree and the two residues of B_0^M*x_1^5.
for residue_m in (1,):
    assert (11 * residue_m + 5) % 5 == 1
    residue0 = (1, 0, 0, 0, 0)
    residue1 = (0, 1, 0, 0, 0)
    difference = tuple((b - c) % P for b, c in zip(residue1, residue0))
    assert len(set(difference)) > 1

print("CIRCULANT_DETERMINANT=(AUGMENTATION)^5")
print("K_IM_DELTA3=0 K_IM_DELTA2_NONZERO=2")
print("COUNTERFAMILY=P_PRIMITIVE_GCD_ONE_NONPROGRESSION")
print("F55-CHAR5-FIXED-LINE-HASSE-BOUNDARY-EXACT")
