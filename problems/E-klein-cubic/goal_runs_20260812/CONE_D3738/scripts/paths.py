#!/usr/bin/env python3
"""Path bootstrap for CONE_D3738. Our paths.py wins sys.path[0]."""
from __future__ import annotations

import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
LOGS = os.path.join(PACKET, "logs")
ROOT = os.path.abspath(os.path.join(PACKET, "..", ".."))

D34 = os.path.join(ROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
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
DEGREES = (37, 38)

# LANDING_SWEEP pre-cut Layer-0 cells; QR_POINT_CUTS post-C11 dims.
SEALED_PRECUT = {37: 121, 38: 151}
SEALED_POSTCUT = {37: 120, 38: 150}

# LANDING_INVARIANT_SIDE P3 is on the post-flip cell (119 at d=37; flip
# skipped at even d so 151 at d=38).
SEALED_P3_K = {37: 119, 38: 151}
SEALED_P3 = {37: 2642, 38: 3285}

# Molien ceilings I(3d) from director_probes_20260812/README.md
I_3D = {37: 10614, 38: 11776}

# Hard resource cap for this lane (director 16-thread job is live).
THREADS = 2
RSS_CAP_KB = 8_000_000
