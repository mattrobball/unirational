#!/usr/bin/env python3
"""Path bootstrap for ALIVE_EXTEND: D34 engine + LANDING instruments + QR C11."""
from __future__ import annotations

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
LOGS = os.path.join(PACKET, "logs")
ROOT = os.path.abspath(os.path.join(PACKET, "..", ".."))  # problems/E-klein-cubic

D34 = os.path.join(ROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
LANDING = os.path.join(ROOT, "goal_runs_20260812", "LANDING_SWEEP", "scripts")
QR = os.path.join(ROOT, "goal_runs_20260812", "QR_POINT_CUTS", "scripts")

# Our paths.py must win over LANDING_SWEEP/scripts/paths.py.
for p in (QR, LANDING, D34, HERE):
    if p not in sys.path:
        sys.path.insert(0, p)

os.makedirs(RES, exist_ok=True)
os.makedirs(LOGS, exist_ok=True)

PRIMES = (331, 661)
DEGREES = list(range(34, 51))
ANCHOR_DEGREES = list(range(34, 43))
EXTEND_DEGREES = list(range(43, 51))
QR_MOD11 = (1, 3, 4, 5, 9)

# Sealed Layer-0 raw cells (LANDING_SWEEP / D34 ladder). Fatal if rebuild misses.
SEALED_RAW = {
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

# Sealed post-C11 window (QR_POINT_CUTS alive table). Fatal if rebuild misses.
SEALED_WINDOW = {
    34: 0,
    35: 39,
    36: 62,
    37: 120,
    38: 150,
    39: 218,
    40: 261,
    41: 343,
    42: 396,
}

# Sealed dim M_d from the D34 Molien path (LANDING_SWEEP artefacts).
SEALED_DIMM = {
    34: 576,
    35: 637,
    36: 706,
    37: 786,
    38: 865,
    39: 950,
    40: 1050,
    41: 1148,
    42: 1255,
}


def is_qr(d):
    return (d % 11) in QR_MOD11
