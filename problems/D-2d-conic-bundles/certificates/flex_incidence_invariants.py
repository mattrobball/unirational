#!/usr/bin/env python3
"""Exact Chow-ring checks for the degree-d flex-incidence note."""


def mul(a, b):
    """Multiply in Z[H,P,J]/(H^3,P^3,J^3)."""
    out = {}
    for (hi, pi, ji), av in a.items():
        for (hk, pk, jk), bv in b.items():
            h, p, j = hi + hk, pi + pk, ji + jk
            if h <= 2 and p <= 2 and j <= 2:
                out[h, p, j] = out.get((h, p, j), 0) + av * bv
    return out


def linear(h=0, p=0, j=0):
    return {(1, 0, 0): h, (0, 1, 0): p, (0, 0, 1): j}


def integral_on_flag_product(a):
    flag_class = linear(p=1, j=1)
    return mul(a, flag_class).get((2, 2, 2), 0)


def surface_for(d):
    l0 = linear(h=2, p=d)
    l1 = linear(h=2, p=d - 2, j=1)
    l2 = linear(h=2, p=d - 4, j=2)
    return mul(mul(l0, l1), l2)


H = linear(h=1)
for d in range(4, 12):
    z = surface_for(d)
    canonical = linear(h=3, p=3 * d - 8, j=1)
    degree_d = integral_on_flag_product(mul(mul(H, H), z))
    k2_d = integral_on_flag_product(mul(mul(canonical, canonical), z))
    kc_d = integral_on_flag_product(mul(mul(canonical, H), z))
    genus_d = 1 + (degree_d + kc_d) // 2
    assert degree_d == 3 * d * (d - 2)
    assert k2_d == 9 * (3 * d - 4) * (17 * d - 42)
    assert kc_d == 3 * (17 * d * d - 54 * d + 32)
    assert genus_d == (3 * d - 7) * (9 * d - 7)
print("all-d degree, canonical-square, and slice-genus formulas: PASS")

surface = surface_for(4)

expected_surface = {
    (2, 1, 0): 24,
    (2, 0, 1): 12,
    (1, 2, 0): 16,
    (1, 1, 1): 32,
    (1, 0, 2): 4,
    (0, 2, 1): 16,
    (0, 1, 2): 8,
}
assert surface == expected_surface
print("length-three jet-bundle top Chern class: PASS")

K = linear(h=3, p=4, j=1)
degree = integral_on_flag_product(mul(mul(H, H), surface))
assert degree == 24
print("generic flex degree 24: PASS")

K2 = integral_on_flag_product(mul(mul(K, K), surface))
assert K2 == 1872
print("canonical class 3H+4P+J and K^2=1872: PASS")

C2 = degree
KC = integral_on_flag_product(mul(mul(K, H), surface))
genus = 1 + (C2 + KC) // 2
assert (C2, KC, genus) == (24, 264, 145)
print("general line slice: C^2=24, K.C=264, genus=145: PASS")
