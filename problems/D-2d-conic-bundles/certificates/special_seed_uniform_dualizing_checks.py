#!/usr/bin/env python3
"""Arithmetic checks for the uniform special-seed dualizing theorem."""


for d in range(4, 20):
    determinant = {
        "H": 6,
        "P": 2 * d - 4,
        "J": 3,
        "R": d - 2,
    }
    ambient_canonical = {"H": -3, "P": -2, "J": -1, "R": -2}
    canonical = {
        key: determinant[key] + ambient_canonical[key]
        for key in determinant
    }
    assert canonical == {
        "H": 3,
        "P": 2 * d - 6,
        "J": 2,
        "R": d - 4,
    }
print("global determinant and adjunction coefficients: PASS")

for d in range(4, 20):
    for e in range(1, 10):
        seed_coefficient = e * (2 * d - 3) - 2
        assert seed_coefficient > 0
print("all tested d>=4,e>=1 seed polarizations are positive: PASS")

for d in range(4, 20):
    critical_degree = 18 * (d - 1) * (3 * d - 5)
    critical_genus = 1 + critical_degree // 2
    assert critical_genus == 1 + 9 * (d - 1) * (3 * d - 5)
    assert 12 * (d - 1) > 0
print("critical-curve degree, genus, and nonconstant projection: PASS")
