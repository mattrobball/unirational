#!/usr/bin/env python3
"""Path bootstrap for QR_POINT_CUTS: D34 ladder engine + local results."""
from __future__ import annotations

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
LOGS = os.path.join(PACKET, "logs")
ROOT = os.path.abspath(os.path.join(PACKET, "..", ".."))  # problems/E-klein-cubic

D34 = os.path.join(ROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
L12 = os.path.join(ROOT, "goal_runs_20260812", "L12_ORDER11")
LANDING = os.path.join(ROOT, "goal_runs_20260812", "LANDING_SWEEP")

# Import the D34 engine (slicelib / p2lib / d34lib / produce_d34 / produce_ladder).
# Do NOT put LANDING_SWEEP/scripts on sys.path: its paths.py would collide.
if D34 not in sys.path:
    sys.path.insert(0, D34)
if HERE not in sys.path:
    sys.path.insert(0, HERE)

os.makedirs(RES, exist_ok=True)
os.makedirs(LOGS, exist_ok=True)

PRIMES = (331, 661)
CUT_DEGREES = (35, 36, 37, 38, 42)
QR_MOD11 = (1, 3, 4, 5, 9)

# Sealed Layer-0 (1,6) cell dims. Fatal if a rebuild misses these.
# Source: D34_GUIDED_SWEEP THEOREM.md §4 / LANDING_SWEEP alive table.
SEALED_CELL = {
    34: 0,
    35: 39,
    36: 63,
    37: 121,
    38: 151,
    39: 218,
    40: 261,
    41: 343,
    42: 397,
}

# NQR rows of the alive table are not recut (C11 already forced there).
NQR_UNCHANGED = (35, 39, 40, 41)


def is_qr(d):
    return (d % 11) in QR_MOD11
