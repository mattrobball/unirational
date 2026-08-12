#!/usr/bin/env python3
"""Path bootstrap for LANDING_SWEEP: D34 engine + local results."""
from __future__ import annotations

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
LOGS = os.path.join(PACKET, "logs")
ROOT = os.path.abspath(os.path.join(PACKET, "..", ".."))  # problems/E-klein-cubic

D34 = os.path.join(ROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
PAIR = os.path.join(ROOT, "goal_runs_20260811", "PAIR_ATTACK_D35")
D35L = os.path.join(ROOT, "goal_runs_20260811", "D35_LANDING")

for p in (D34, HERE):
    if p not in sys.path:
        sys.path.insert(0, p)

os.makedirs(RES, exist_ok=True)
os.makedirs(LOGS, exist_ok=True)

PRIMES = (331, 661)
DEGREES = list(range(34, 43))
ANCHOR_CELL = {  # D34_GUIDED_SWEEP ladder structure+(1,r0) upper bounds at p=331
    34: 0, 35: 39, 36: 63, 37: 121, 38: 151, 39: 218, 40: 261, 41: 343, 42: 397,
}
