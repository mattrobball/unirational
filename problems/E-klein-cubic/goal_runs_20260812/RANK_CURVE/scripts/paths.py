#!/usr/bin/env python3
"""Path bootstrap for RANK_CURVE. Keep names that invlib / instruments expect."""
from __future__ import annotations

import os
import sys

# Cap BLAS before any numpy import by a consumer of this module.
os.environ.setdefault("OMP_NUM_THREADS", "2")
os.environ.setdefault("OPENBLAS_NUM_THREADS", "2")
os.environ.setdefault("MKL_NUM_THREADS", "2")
os.environ.setdefault("NUMEXPR_NUM_THREADS", "2")
os.environ.setdefault("VECLIB_MAXIMUM_THREADS", "2")

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
RES = os.path.join(PACKET, "results")
LOGS = os.path.join(PACKET, "logs")
ROOT = os.path.abspath(os.path.join(PACKET, "..", ".."))  # problems/E-klein-cubic

D34 = os.path.join(ROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
PAIR = os.path.join(ROOT, "goal_runs_20260811", "PAIR_ATTACK_D35")
PAIR_RES = os.path.join(PAIR, "results")
D35L = os.path.join(ROOT, "goal_runs_20260811", "D35_LANDING")
D35L_RES = os.path.join(D35L, "results")
SWEEP = os.path.join(ROOT, "goal_runs_20260812", "LANDING_SWEEP")
SWEEP_SCR = os.path.join(SWEEP, "scripts")
INV = os.path.join(ROOT, "goal_runs_20260812", "LANDING_INVARIANT_SIDE")
INV_SCR = os.path.join(INV, "scripts")
QR = os.path.join(ROOT, "goal_runs_20260812", "QR_POINT_CUTS")
QR_SCR = os.path.join(QR, "scripts")
PROBE = os.path.join(ROOT, "director_probes_20260812")

# HERE last so this packet's paths.py wins. D34 and SWEEP_SCR provide engines.
for p in (D34, SWEEP_SCR, HERE):
    if p not in sys.path:
        sys.path.insert(0, p)

os.makedirs(RES, exist_ok=True)
os.makedirs(LOGS, exist_ok=True)

PRIMES = (331, 661)

# Molien ceilings I(3d) from director_probes_20260812/README.md
I_3D = {
    35: 8555,
    36: 9545,
    37: 10614,
    38: 11776,
    39: 13026,
    40: 14379,
    41: 15828,
    42: 17391,
}

# Sealed exact P3 on post-flip Layer-0 cells (LANDING_INVARIANT_SIDE).
SEALED_P3 = {35: 1380, 36: 1850, 37: 2642, 38: 3285}

# Post-flip cell dims from LANDING_SWEEP (six-flip on odd d).
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

# Layer-0 cell dims (pre-flip) / QR_POINT_CUTS sealed anchors.
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

# Alive table after the C11 QR cut (QR_POINT_CUTS). NQR rows unchanged.
QR_ALIVE = {
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

QR_MOD11 = (1, 3, 4, 5, 9)


def is_qr(d: int) -> bool:
    return (d % 11) in QR_MOD11
