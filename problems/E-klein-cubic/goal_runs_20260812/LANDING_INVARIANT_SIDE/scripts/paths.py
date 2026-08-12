#!/usr/bin/env python3
"""Path bootstrap for LANDING_INVARIANT_SIDE."""
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
D35L = os.path.join(ROOT, "goal_runs_20260811", "D35_LANDING")
D35L_RES = os.path.join(D35L, "results")
SWEEP = os.path.join(ROOT, "goal_runs_20260812", "LANDING_SWEEP")
SWEEP_SCR = os.path.join(SWEEP, "scripts")
PROBE = os.path.join(ROOT, "director_probes_20260812")

for p in (D34, SWEEP_SCR, HERE):
    if p not in sys.path:
        sys.path.insert(0, p)

os.makedirs(RES, exist_ok=True)

PRIMES = (331, 661)

# Molien ceilings I(3d) from director_probes_20260812/README.md
I_3D = {
    35: 8555,   # I(105)
    36: 9545,   # I(108)
    37: 10614,  # I(111)
    38: 11776,  # I(114)
    39: 13026,  # I(117)
    40: 14379,  # I(120)
    41: 15828,  # I(123)
    42: 17391,  # I(126)
}

# Sealed post-flip cell dims from LANDING_SWEEP
POST_FLIP_K = {
    34: 0,
    35: 37,
    36: 63,
    37: 119,
    38: 151,
    39: 216,
    40: 261,
    41: 341,
    42: 397,
}

# dim M_d from D34 alive table / sweep
DIM_M = {
    34: 576,
    35: 637,
    36: 706,
    37: 784,
    38: 867,
    39: 957,
    40: 1054,
    41: 1159,
    42: 1271,
}
