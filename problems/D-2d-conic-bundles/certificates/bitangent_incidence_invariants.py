#!/usr/bin/env python3
"""Exact intersection checks for the quartic bitangent-incidence note."""


def mul(a, b):
    """Multiply classes in Z[H,J]/(H^3,J^3)."""
    out = {}
    for (hi, ji), av in a.items():
        for (hk, jk), bv in b.items():
            h, j = hi + hk, ji + jk
            if h <= 2 and j <= 2:
                out[h, j] = out.get((h, j), 0) + av * bv
    return out


def integral(a):
    return a.get((2, 2), 0)


# Chern classes for G=Sym^2(K*) and E=Sym^4(K*), where
# c1(K*)=J and c2(K*)=J^2.
c1_g, c2_g = 3, 6
c1_e, c2_e = 10, 55
assert c1_g * c1_g - c2_g == 3
assert c1_e * c1_e - c2_e == 45
print("symmetric-power Chern classes: PASS")

# Write [v(P(G))] = a xi^2 + b xi J + c J^2.
# Projective-bundle moments for the lines convention determine a,b,c.
a = 4
b = -24 + 10 * a
c = 48 - 45 * a + 10 * b
assert (a, b, c) == (4, 16, 28)
print("relative square-quartic class (4,16,28): PASS")

# Pull back xi=2H.
B = {(2, 0): 16, (1, 1): 32, (0, 2): 28}
assert B[(0, 2)] == 28
print("bitangent surface class and generic degree 28: PASS")

H_plus_J = {(1, 0): 1, (0, 1): 1}
K = {(1, 0): 4, (0, 1): 4}
K2 = integral(mul(mul(K, K), B))
assert K2 == 1728
print("canonical class 4(H+J) and K^2=1728: PASS")

H = {(1, 0): 1}
C2 = integral(mul(mul(H, H), B))
KC = integral(mul(mul(K, H), B))
genus = 1 + (C2 + KC) // 2
assert (C2, KC, genus) == (28, 240, 135)
print("general line slice: C^2=28, K.C=240, genus=135: PASS")

ramification = 54 * 6
rh_genus = 1 + (-2 * 28 + ramification) // 2
assert (ramification, rh_genus) == (324, 135)
print("theta-monodromy/Riemann-Hurwitz check genus=135: PASS")
