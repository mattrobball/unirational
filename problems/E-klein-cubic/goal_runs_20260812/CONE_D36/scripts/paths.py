#!/usr/bin/env python3
"""Path bootstrap for CONE_D36. Our paths.py wins sys.path[0]."""
from __future__ import annotations

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
LOGS = os.path.join(PACKET, "logs")
ROOT = os.path.abspath(os.path.join(PACKET, "..", ".."))

D34 = os.path.join(ROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
PAIR = os.path.join(ROOT, "goal_runs_20260811", "PAIR_ATTACK_D35")
SWEEP = os.path.join(ROOT, "goal_runs_20260812", "LANDING_SWEEP")
SWEEP_SCR = os.path.join(SWEEP, "scripts")
QRCUT = os.path.join(ROOT, "goal_runs_20260812", "QR_POINT_CUTS")
QRCUT_SCR = os.path.join(QRCUT, "scripts")
INV = os.path.join(ROOT, "goal_runs_20260812", "LANDING_INVARIANT_SIDE")
PROBE = os.path.join(ROOT, "director_probes_20260812")

for pth in (D34, SWEEP_SCR, QRCUT_SCR, HERE):
    if pth not in sys.path:
        sys.path.insert(0, pth)

os.makedirs(RES, exist_ok=True)
os.makedirs(LOGS, exist_ok=True)

PRIMES = (331, 661)
DEG = 36
SEALED_CELL_63 = 63
SEALED_CUT_62 = 62
SEALED_P3 = 1850
I_108 = 9545
DIM_M_36 = 706
