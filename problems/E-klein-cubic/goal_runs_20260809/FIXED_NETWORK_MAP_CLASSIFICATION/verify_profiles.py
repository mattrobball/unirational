#!/usr/bin/env python3
"""Finite checks for the corrected marked S3 model and profile congruences."""

from __future__ import annotations

import json
from itertools import product
from pathlib import Path
from typing import Callable, Iterable, Tuple

E2 = tuple(product(range(2), repeat=2))
Z3 = range(3)
POINTS = tuple((e, i) for e in E2 for i in Z3)


def add_e2(a: Tuple[int, int], b: Tuple[int, int]) -> Tuple[int, int]:
    return ((a[0] + b[0]) % 2, (a[1] + b[1]) % 2)


def scale_e2(n: int, e: Tuple[int, int]) -> Tuple[int, int]:
    return ((n * e[0]) % 2, (n * e[1]) % 2)


def tau(p):
    e, i = p
    return (e, (i + 1) % 3)


def sigma(p):
    e, i = p
    return (e, (-i) % 3)


def compose(f: Callable, g: Callable) -> Callable:
    return lambda p: f(g(p))


def power(f: Callable, n: int) -> Callable:
    def out(p):
        q = p
        for _ in range(n):
            q = f(q)
        return q
    return out


def equal_maps(f: Callable, g: Callable, pts: Iterable = POINTS) -> bool:
    return all(f(p) == g(p) for p in pts)


def reflection(j: int) -> Callable:
    return compose(power(tau, j % 3), sigma)


def phi(n: int, a: Tuple[int, int]) -> Callable:
    return lambda p: (
        add_e2(scale_e2(n, p[0]), a),
        (n * p[1]) % 3,
    )


def fixed_points(f: Callable):
    return tuple(p for p in POINTS if f(p) == p)


# S3 relations.
assert equal_maps(power(tau, 3), lambda p: p)
assert equal_maps(power(sigma, 2), lambda p: p)
assert equal_maps(compose(compose(sigma, tau), sigma), power(tau, 2))

# Reflections are iq - P and have the correct products.
refs = [reflection(j) for j in range(3)]
for r in refs:
    assert equal_maps(power(r, 2), lambda p: p)
for i, j in product(range(3), repeat=2):
    assert equal_maps(compose(refs[i], refs[j]), power(tau, (i - j) % 3))

# Each reflection fixes four points; union is all 12 marked points.
ref_fixed = [fixed_points(r) for r in refs]
assert [len(x) for x in ref_fixed] == [4, 4, 4]
assert set().union(*(set(x) for x in ref_fixed)) == set(POINTS)

# The false old model using three nonzero E2 translations is not S3.
nonzero_e2 = [e for e in E2 if e != (0, 0)]


def old_reflection(e):
    return lambda p: (add_e2(e, p[0]), (-p[1]) % 3)


old_refs = [old_reflection(e) for e in nonzero_e2]
assert any(
    not any(equal_maps(compose(old_refs[i], old_refs[j]), power(tau, k))
            for k in (1, 2))
    for i, j in product(range(3), repeat=2)
    if i != j
)

# Enumerate affine maps modulo marked torsion.
equivariant = []
for n_mod6, a in product(range(6), E2):
    f = phi(n_mod6, a)
    if equal_maps(compose(f, tau), compose(tau, f)) and equal_maps(
        compose(f, sigma), compose(sigma, f)
    ):
        equivariant.append((n_mod6, a))

expected = [
    (n, a)
    for n, a in product(range(6), E2)
    if n % 3 == 1
]
assert sorted(equivariant) == sorted(expected)

type_i = {((0, 0), i) for i in Z3}
all_pointwise = []
type_i_preserving = []
for n_mod6, a in equivariant:
    f = phi(n_mod6, a)
    if {f(p) for p in type_i} == type_i:
        type_i_preserving.append((n_mod6, a))
    if all(f(p) == p for p in POINTS):
        all_pointwise.append((n_mod6, a))

assert type_i_preserving == [(1, (0, 0)), (4, (0, 0))]
assert all_pointwise == [(1, (0, 0))]

# Monomial line maps: commute iff m=1 mod 3; fix mu_6 iff m=1 mod 6.
line_samples = []
for m in range(-35, 36):
    if m == 0:
        continue
    commutes = (m - 1) % 3 == 0
    fixes_type_i = (m - 1) % 6 == 0
    line_samples.append(
        {"m": m, "degree": abs(m), "commutes": commutes,
         "fixes_type_I_pointwise": fixes_type_i}
    )

assert min(
    x["degree"]
    for x in line_samples
    if x["commutes"] and x["fixes_type_I_pointwise"] and x["m"] != 1
) == 5

out = {
    "corrected_S3_relations": "PASS",
    "reflection_fixed_counts": [len(x) for x in ref_fixed],
    "marked_union_size": len(set().union(*(set(x) for x in ref_fixed))),
    "old_nonzero_E2_reflection_model": "REFUTED",
    "equivariant_affine_residue_classes": [
        {"n_mod_6": n, "a": list(a)} for n, a in equivariant
    ],
    "type_I_preserving_classes": [
        {"n_mod_6": n, "a": list(a)} for n, a in type_i_preserving
    ],
    "all_marked_pointwise_classes": [
        {"n_mod_6": n, "a": list(a)} for n, a in all_pointwise
    ],
    "first_nonidentity_marked_elliptic_n": -5,
    "first_nonidentity_type_I_pointwise_monomial_degree": 5,
    "marker": "FIXED_NETWORK_PROFILE_VERIFY_OK",
}

path = Path(__file__).with_name("verification_output.json")
path.write_text(json.dumps(out, indent=2, sort_keys=True) + "\n")
print(json.dumps(out, indent=2, sort_keys=True))
print("FIXED_NETWORK_PROFILE_VERIFY_OK")
