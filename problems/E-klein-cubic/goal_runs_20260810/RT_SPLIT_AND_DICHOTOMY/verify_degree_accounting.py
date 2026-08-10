#!/usr/bin/env python3
"""Exact integer checks for refined-Bezout/orbit-size cells."""
from __future__ import annotations

ORBIT_TYPES = [
    ("A5-index-11-a", 11),
    ("A5-index-11-b", 11),
    ("index-12", 12),
    ("index-55", 55),
    ("index-66", 66),
    ("free", 660),
]
POWERS = {"surface": 2, "curve": 3, "point": 4}


def ceil_root(n: int, power: int) -> int:
    d = 0
    while d**power < n:
        d += 1
    return d


def main() -> None:
    expected = {
        "surface": [4, 4, 4, 8, 9, 26],
        "curve": [3, 3, 3, 4, 5, 9],
        "point": [2, 2, 2, 3, 3, 6],
    }
    for dimension, power in POWERS.items():
        got = [ceil_root(size, power) for _, size in ORBIT_TYPES]
        assert got == expected[dimension], (dimension, got)

    ambient_dead: list[tuple[str, str, int]] = []
    for d in range(22, 80):
        for dimension, power in POWERS.items():
            for orbit, size in ORBIT_TYPES:
                if size > d**power:
                    ambient_dead.append((dimension, orbit, d))
    assert ambient_dead == [
        ("surface", "free", 22),
        ("surface", "free", 23),
        ("surface", "free", 24),
        ("surface", "free", 25),
    ]

    retraction_dead = [cell for cell in ambient_dead if cell[2] >= 24]
    assert retraction_dead == [
        ("surface", "free", 24),
        ("surface", "free", 25),
    ]

    # No upper bound exists in the live ambient window.  At d=26 even the
    # free surface orbit passes; curve and point free orbits pass already at
    # d=9 and d=6 respectively.
    assert 660 <= 26**2
    assert 660 <= 9**3
    assert 660 <= 6**4

    print("REFINED_BEZOUT_ORBIT_THRESHOLDS_OK")
    print("AMBIENT_D22_D25_FREE_SURFACE_CELLS_EXCLUDED_OK")
    print("RETRACTION_D24_D25_FREE_SURFACE_CELLS_EXCLUDED_OK")
    print("FREE_CURVE_AND_POINT_CELLS_SURVIVE_LIVE_WINDOW_OK")
    print("FREE_SURFACE_CELL_SURVIVES_FROM_D26_OK")


if __name__ == "__main__":
    main()
