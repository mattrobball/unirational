#!/usr/bin/env python3
"""Exact secant checks for the two easiest subgroup-fixed configurations.

The calculations are over Q for the C11 coordinate frame, and over
Q[a]/(a^4+a^3+a^2+a+1) for the nontrivial C5 eigenpoints.
"""

import itertools
import math
import sympy as sp

s, t, a = sp.symbols("s t a")
phi5 = a**4 + a**3 + a**2 + a + 1


def klein(v):
    return sp.expand(sum(v[i] ** 2 * v[(i + 1) % 5] for i in range(5)))


def mod_phi5(f):
    return sp.rem(sp.Poly(sp.expand(f), a), sp.Poly(phi5, a)).as_expr().expand()


# The five C11 eigenpoints are the coordinate points.  The five sides of
# the cyclic pentagon have a double endpoint as their residual intersection;
# the five diagonals are contained in X.
coordinate = [tuple(int(i == j) for i in range(5)) for j in range(5)]
contained = []
tangent = []
for i, j in itertools.combinations(range(5), 2):
    expression = klein([s * coordinate[i][k] + t * coordinate[j][k]
                        for k in range(5)])
    if expression == 0:
        contained.append((i, j))
    else:
        tangent.append(((i, j), expression))

assert len(contained) == 5 and len(tangent) == 5
assert all(sp.Poly(f, s, t).monoms() in ([(2, 1)], [(1, 2)])
           for _, f in tangent)


# P is cyclic coordinate permutation.  For a primitive fifth root a, its
# nontrivial eigenpoints can be represented by v_a and v_{a^{-1}}.  Each is
# on X, and the chord joining an inverse pair is entirely contained in X.
va = [a**i for i in range(5)]
vainv = [a**((-i) % 5) for i in range(5)]
assert mod_phi5(klein(va)) == 0
assert mod_phi5(klein(vainv)) == 0
inverse_chord = mod_phi5(klein([s * va[i] + t * vainv[i] for i in range(5)]))
assert inverse_chord == 0


# Effective closed-point degrees supplied by the subgroup-fixed points.
degrees = (60, 132, 165, 220)
assert math.gcd(*degrees) == 1
assert min(degrees) > 2

print("PASS C11 frame: 5 contained diagonals and 5 endpoint-tangent sides")
print("contained_pairs=", contained)
print("tangent_pairs=", tangent)
print("PASS each inverse C5-eigenpoint chord is contained in the Klein cubic")
print("PASS gcd(60,132,165,220)=1, while each listed effective degree is >2")
