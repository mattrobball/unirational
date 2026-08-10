#!/usr/bin/env python3
"""Independent replay of every decisive check of the DUNCAN_CORNER_F2 packet.

Runs, in order:

    scripts/w1_corner_global.py            W1 (global)   -- two primes
    scripts/w1_corner_charts.m2            W1 (charts)   -- Macaulay2, exact QQ
    scripts/toric_corner.py                corner stabilizer via Duncan's own
                                           toric formula (prime-independent)
    scripts/w2_orbit_disjointness.py       W2            -- two primes
    scripts/w3_corner_inventory.py         W3            -- two primes + BFS
    scripts/w5_w6_line_graph_and_stabs.py  W5, W6        -- two primes
    scripts/w7_f2_vs_e33_trisection.py     W7            -- two primes

Every group/geometry computation is done at BOTH split primes 331 and 661
(11 | p-1 and 5 | p-1, so all element orders 1,2,3,5,6,11 split); the Macaulay2
part is exact over QQ; the toric part is exact integer arithmetic.

Terminal marker on success:  DUNCAN_CORNER_F2_VERIFY_OK
"""
import os
import subprocess
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PY = sys.executable or "/opt/homebrew/bin/python3"
M2 = "/opt/homebrew/bin/M2"

STEPS = [
    ("W1 global   (module inputs, both primes)", [PY, "scripts/w1_corner_global.py"],
     "W1_CORNER_GLOBAL_OK"),
    ("W1 charts   (Macaulay2, exact over QQ)", [M2, "--script", "scripts/w1_corner_charts.m2"],
     "W1_CORNER_CHARTS_OK"),
    ("corner via Duncan's toric formula", [PY, "scripts/toric_corner.py"],
     "TORIC_CORNER_OK"),
    ("W2 orbit disjointness (both primes)", [PY, "scripts/w2_orbit_disjointness.py"],
     "W2_ORBIT_DISJOINTNESS_OK"),
    ("W3 corner inventory (both primes)", [PY, "scripts/w3_corner_inventory.py"],
     "W3_CORNER_INVENTORY_OK"),
    ("W5/W6 line graph and stabilizers", [PY, "scripts/w5_w6_line_graph_and_stabs.py"],
     "W5_W6_OK"),
    ("W7 (F2) vs the [E33] trisection family", [PY, "scripts/w7_f2_vs_e33_trisection.py"],
     "W7_F2_VS_E33_SURVIVES"),
]


def main():
    if not os.path.exists(M2):
        print("FAIL: Macaulay2 not found at " + M2)
        return 1
    failures = []
    for name, cmd, marker in STEPS:
        print("-" * 72)
        print("RUN  " + name)
        try:
            r = subprocess.run(cmd, cwd=HERE, capture_output=True, text=True, timeout=3600)
        except Exception as exc:                                  # noqa: BLE001
            print(f"FAIL {name}: {exc}")
            failures.append(name)
            continue
        text = r.stdout + r.stderr
        if marker in text and "FAIL" not in text.replace("FAIL COUNT", ""):
            print(f"OK   {name}  [{marker}]")
        else:
            print(f"FAIL {name}  (marker {marker} not found, or a check failed)")
            print(text[-3000:])
            failures.append(name)
    print("=" * 72)
    if failures:
        print("FAILURES: " + ", ".join(failures))
        print("DUNCAN_CORNER_F2_VERIFY_FAIL")
        return 1
    print("all steps passed at primes 331 and 661 (plus exact QQ and exact Z parts)")
    print("DUNCAN_CORNER_F2_VERIFY_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
