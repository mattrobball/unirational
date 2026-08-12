"""Path bootstrap for TANGENT_C6. Read-only sealed trees; write only here."""
from __future__ import annotations

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
GR12 = os.path.dirname(PACKET)
EROOT = os.path.dirname(GR12)
D34 = os.path.join(EROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
PAIR = os.path.join(EROOT, "goal_runs_20260811", "PAIR_ATTACK_D35")
PAIR_RES = os.path.join(PAIR, "results")
RES = os.path.join(PACKET, "results")
os.makedirs(RES, exist_ok=True)

for pth in (HERE, D34):
    if pth not in sys.path:
        sys.path.insert(0, pth)

DEG = 35
NSEED = 637
DIM39 = 39
DIM37 = 37
P3_SEALED = 1380
PRIMES = (331, 661)
