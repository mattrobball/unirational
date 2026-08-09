#!/usr/bin/env python3
"""Exact small checks for the all-Sylow-eleven coupling boundary."""

from pathlib import Path

import sympy as sp
from sympy.matrices.normalforms import smith_normal_form


P = 11
WEIGHTS = [1, 9, 4, 3, 5]
MU = [1, 5, 3, 4, 9]


def update(state, chosen):
    assert chosen in state
    return tuple(sorted([chosen] + [(b - chosen) % P for b in state if b != chosen]))


# The Klein weights and invariant monomials.
assert [pow(-2, i, P) for i in range(5)] == WEIGHTS
assert all((2 * WEIGHTS[i] + WEIGHTS[(i + 1) % 5]) % P == 0 for i in range(5))

# Projective lattice index of y_i=x_i^2*x_(i+1).
C = 2 * sp.eye(5)
for k in range(5):
    C[k, (k - 1) % 5] += 1
basis = [sp.eye(5).col(i) - sp.eye(5).col(4) for i in range(4)]
C_aug = sp.Matrix.hstack(*(C * vector for vector in basis))[:4, :]
smith = smith_normal_form(C_aug, domain=sp.ZZ)
assert sorted(abs(int(smith[i, i])) for i in range(4)) == [1, 1, 1, 11]

# The local residue line has nontrivial C5 character.
shift_mu = MU[1:] + MU[:1]
assert shift_mu == [(5 * x) % P for x in MU]
assert 5 != 1 and pow(5, 5, P) == 1

# Sylow and double-coset arithmetic.
order_g = 660
number_sylow = [n for n in range(1, 61) if 60 % n == 0 and n % 11 == 1]
assert number_sylow == [1, 12]
assert order_g // 12 == 55
assert order_g // 132 == 5
assert order_g > 120  # excludes an injective coset action G -> S5

fixed_cosets = 55 // 11
free_cosets = (60 - fixed_cosets) // 11
assert (fixed_cosets, free_cosets) == (5, 5)
assert fixed_cosets + 11 * free_cosets == 60

# Exact infinitely-near entry path and nine-step cycle.
state = (4, 7, 9, 10)
for chosen in (7, 3, 3):
    state = update(state, chosen)
assert state == (1, 2, 3, 7)

cycle_start = state
choices = (2, 2, 2, 2, 4, 4, 4, 1, 1)
expected = [
    (1, 2, 5, 10),
    (2, 3, 8, 10),
    (1, 2, 6, 8),
    (2, 4, 6, 10),
    (2, 4, 6, 9),
    (2, 4, 5, 9),
    (1, 4, 5, 9),
    (1, 3, 4, 8),
    (1, 2, 3, 7),
]
for chosen, target in zip(choices, expected):
    state = update(state, chosen)
    assert state == target
    assert 0 not in state and len(set(state)) == 4
assert state == cycle_start

# Scaling compatibility makes the counterpath coherent on conjugate orbits.
for scalar in range(1, P):
    for state in expected:
        for chosen in state:
            scaled_state = tuple(sorted((scalar * x) % P for x in state))
            left = update(scaled_state, (scalar * chosen) % P)
            right = tuple(sorted((scalar * x) % P for x in update(state, chosen)))
            assert left == right

note = Path(__file__).with_name("THEOREM.md").read_text(encoding="utf-8")
for marker in (
    "FULL-G-SYL11-PAIR-QUOTIENTS-GENERATE-KLEIN-FIELD",
    "FULL-G-ALL-SYL11-COMPATIBLE-COVER-IS-KLEIN",
    "FULL-G-LOCAL-RESIDUE-MODULE-HAS-NO-INVARIANTS",
    "FULL-G-INFINITELY-NEAR-WEIGHT-CYCLE-EXACT",
    "FULL-G-COUPLING-ROUTE-TAUTOLOGICAL-BOUNDARY",
    "PSL-KLEIN-QUESTION-OPEN",
):
    assert marker in note

print("SYL11_QUOTIENT_LATTICE_INDEX_11_OK")
print("SYL11_PAIR_DOUBLE_COSET_PATTERN_5_PLUS_5_OK")
print("FULL_G_LOCAL_RESIDUE_INVARIANTS_ZERO_OK")
print("FULL_G_INFINITELY_NEAR_WEIGHT_CYCLE_OK")
print("FULL-G-COUPLING-BOUNDARY-OK")
