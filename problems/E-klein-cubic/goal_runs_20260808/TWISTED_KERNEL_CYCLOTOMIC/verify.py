#!/usr/bin/env python3
"""Fixed exact checks for the cyclotomic self-isogeny packet."""

from itertools import combinations
from math import prod

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form


z = sp.symbols("z")
phi5 = z**4 + z**3 + z**2 + z + 1
alpha = z**3 - z**2 - z - 1


def coeff_vector(poly):
    reduced = sp.rem(poly, phi5, domain=sp.ZZ)
    return [int(reduced.coeff(z, i)) for i in range(4)]


columns = [coeff_vector(alpha * z**j) for j in range(4)]
matrix = sp.Matrix(4, 4, lambda i, j: columns[j][i])
expected_matrix = sp.Matrix(
    [
        [-1, -1, 2, 0],
        [-1, -2, 1, 2],
        [-1, -2, 0, 1],
        [1, -2, 0, 0],
    ]
)
assert matrix == expected_matrix
assert matrix.det() == 11
assert smith_normal_form(matrix, domain=sp.ZZ) == sp.diag(1, 1, 1, 11)
assert int(sp.resultant(phi5, alpha, z)) == 11
assert int(alpha.subs(z, 9)) % 11 == 0

weights = (1, 9, 4, 3, 5)
assert set(weights) == {pow(9, i, 11) for i in range(5)}
assert pow(9, 5, 11) == 1
assert all(pow(9, i, 11) != 1 for i in range(1, 5))

elementary = []
for degree in range(1, 6):
    value = sum(prod(term) for term in combinations(weights, degree)) % 11
    elementary.append(value)
assert elementary == [0, 0, 0, 0, 1]

print("TWISTED-C11-CYCLOTOMIC-SELF-ISOGENY-OK")
print("alpha=zeta^3-zeta^2-zeta-1 norm=11 smith=(1,1,1,11)")
print("chow_invariants_codim_1_to_4=0 first_nonzero_codim=5")

