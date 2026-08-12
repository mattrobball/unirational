#!/usr/bin/env python3
"""Import bootstrap for CROSSBAND_GLUING (read-only sealed trees)."""
from __future__ import annotations

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
ROOT = os.path.abspath(os.path.join(PACKET, "..", ".."))  # problems/E-klein-cubic

D34 = os.path.join(ROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
PAIR = os.path.join(ROOT, "goal_runs_20260811", "PAIR_ATTACK_D35")
PAIR_RES = os.path.join(PAIR, "results")
D35_EXT = os.path.join(ROOT, "goal_runs_20260812", "D35_EXTENDED_SIEVE")
D35_EXT_RES = os.path.join(D35_EXT, "results")
LAND_INV = os.path.join(ROOT, "goal_runs_20260812", "LANDING_INVARIANT_SIDE")
LAND_INV_RES = os.path.join(LAND_INV, "results")
LAND_SWEEP = os.path.join(ROOT, "goal_runs_20260812", "LANDING_SWEEP")

for p in (HERE, D34):
    if p not in sys.path:
        sys.path.insert(0, p)

os.makedirs(RES, exist_ok=True)

PRIMES = (331, 661)
SURV_IDS = [
    5, 7, 13, 15, 21, 23, 29, 31, 37, 39, 45, 47,
    53, 55, 61, 63, 69, 71, 697, 699, 701, 703,
]
