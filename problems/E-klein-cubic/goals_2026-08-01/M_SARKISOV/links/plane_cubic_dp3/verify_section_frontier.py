#!/usr/bin/env python3
"""Independent arithmetic checks for the cubic-surface section frontier."""

from __future__ import annotations

import json
import math
from pathlib import Path

HERE = Path(__file__).resolve().parent
PAYLOAD = json.loads((HERE / "section_payload.json").read_text())


def main():
    assert PAYLOAD["schema"] == "m-sarkisov-dp3-section-frontier-v1"
    group_order = PAYLOAD["group"]["order"]
    stabilizer_order = PAYLOAD["line_orbit"]["stabilizer_order"]
    orbit_degree = PAYLOAD["line_orbit"]["orbit_degree"]
    assert group_order == 660
    assert stabilizer_order == 12
    assert group_order // stabilizer_order == orbit_degree == 55

    surface = PAYLOAD["generic_cubic_surface"]
    assert surface["closed_point_degree"] == 55
    assert surface["hyperplane_zero_cycle_degree"] == 3
    assert math.gcd(55, 3) == surface["index"] == 1

    theorem = PAYLOAD["voisin_2026"]
    assert theorem["source"] == "arXiv:2509.17996v2"
    assert theorem["hypothesis_degree_prime_to_3"] == 55
    assert 55 % 3 != 0
    assert theorem["conclusion"] == "rational section or degree-4 multisection"
    assert PAYLOAD["headline"] == "OPEN"
    assert "not a section" in PAYLOAD["prohibited_inference"]

    print("PASS D12 orbit degree 660/12=55 and generic-fibre index gcd(3,55)=1")
    print("PASS Voisin frontier remains section OR degree-4 multisection")
    print("PASS multisections are not promoted to sections; headline OPEN")


if __name__ == "__main__":
    main()
