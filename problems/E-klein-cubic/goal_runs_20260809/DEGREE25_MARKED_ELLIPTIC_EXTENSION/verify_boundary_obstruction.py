#!/usr/bin/env python3
from __future__ import annotations

import json
from collections import deque
from pathlib import Path

HERE = Path(__file__).resolve().parent
DATA = json.loads((HERE / 'obstruction_payload.json').read_text())


def add(P, Q):
    return ((P[0] + Q[0]) % 2, (P[1] + Q[1]) % 2, (P[2] + Q[2]) % 3)


def neg(P):
    return ((-P[0]) % 2, (-P[1]) % 2, (-P[2]) % 3)


def mul(n, P):
    R = (0, 0, 0)
    if n < 0:
        return mul(-n, neg(P))
    for _ in range(n):
        R = add(R, P)
    return R


def mul_with_origin(n, P, b):
    # b + n(P-b)
    return add(b, mul(n, add(P, neg(b))))


M = [(a, b, c) for a in range(2) for b in range(2) for c in range(3)]
q = (0, 0, 1)
type_I = {P for P in M if P[0] == 0 and P[1] == 0}
type_II = set(M) - type_I

assert len(M) == 12
assert len(type_I) == 3 and len(type_II) == 9
assert all(mul(6, P) == (0, 0, 0) for P in M)
assert all(mul(-5, P) == P for P in M)

# Origin independence for every marked shift.
for b in M:
    for P in M:
        assert mul_with_origin(-5, P, b) == mul(-5, P)


def r(P):
    return add(P, q)


def s(a):
    return lambda P: add(a, neg(P))


# Corrected residual reflections have constants a in <q>.
reflections = [s(mul(i, q)) for i in range(3)]
for i, refl in enumerate(reflections):
    fixed = {P for P in M if refl(P) == P}
    assert len(fixed) == 4
    assert len(fixed & type_I) == 1
    assert len(fixed & type_II) == 3
    # [-5] commutes with the reflection.
    assert all(mul(-5, refl(P)) == refl(mul(-5, P)) for P in M)

assert all(mul(-5, r(P)) == r(mul(-5, P)) for P in M)

# Generate the permutation group <r,s_0>; it must have order 6.
index = {P: i for i, P in enumerate(M)}

def perm_of(f):
    return tuple(index[f(P)] for P in M)

def compose(p, qperm):
    return tuple(p[qperm[i]] for i in range(len(M)))

pr = perm_of(r)
ps = perm_of(reflections[0])
idp = tuple(range(len(M)))
seen = {idp}
queue = deque([idp])
while queue:
    g = queue.popleft()
    for h in (pr, ps):
        gh = compose(g, h)
        if gh not in seen:
            seen.add(gh)
            queue.append(gh)
assert len(seen) == 6

# Literal component-polarization obstruction.
assert 25 != 1
for d in range(-10, 101):
    elliptic_trivial = 3 * (d - 25) == 0
    line_trivial = d - 1 == 0
    assert not (elliptic_trivial and line_trivial)

spaces = DATA['degree25_equivariant_spaces']
assert spaces['ambient_source_invariants'] == 189
assert spaces['plus_plane_arrangement_kernel'] == 59
assert spaces['strict_tower_space'] == 43

# Elliptic invariant calculation for residual S3.
# Class sizes: identity, transpositions, 3-cycles.
class_sizes_s3 = (1, 3, 2)
h0_e_char = (75, 1, 0)
wplus_char = (3, 1, 0)
elliptic_inv = sum(s * a * b for s, a, b in zip(class_sizes_s3, h0_e_char, wplus_char)) // 6
assert elliptic_inv == 38 == spaces['elliptic_normalization_invariants']

# Line invariant calculation for D12.
# Class sizes: 1, r^3, {r,r^5}, {r^2,r^4}, even refl., odd refl.
class_sizes_d12 = (1, 1, 2, 2, 3, 3)
sym25_times_rho1_char = (52, 52, 1, 1, 0, 0)
line_inv = sum(s * c for s, c in zip(class_sizes_d12, sym25_times_rho1_char)) // 12
assert line_inv == 9 == spaces['line_normalization_invariants']

assert spaces['type_I_node_quotient_invariants'] == 2
assert spaces['type_II_node_quotient_invariants'] == 4
network = elliptic_inv + line_inv - 2 - 4
assert network == 41 == spaces['network_target_invariants']

assert DATA['boundary_map_exists'] is True
assert DATA['landing_order_zero']['boundary_fiber_intersects_landing_locus'] is False
assert DATA['minimal_obstruction_certificate']['landing_restriction_image_dimension'] == 0
assert DATA['minimal_obstruction_certificate']['class_nonzero'] is True
assert DATA['minimal_obstruction_certificate']['normal_order'] == 0
assert DATA['tower_comparison']['classification'] == 'unrelated'
assert DATA['exit'] == 'DEGREE25-BOUNDARY-EXTENSION-OBSTRUCTED'

print('DEGREE25_MARKED_ELLIPTIC_FINITE_CHECKS_OK')
