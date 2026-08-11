"""Import path bootstrap: sealed STAGE1_TIGHTEN / STAGE1_COMPLEX_MAPS / ODDZERO scripts.

All sealed trees are read-only.  This packet only adds its own modules.
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
BASE = os.path.dirname(PACKET)  # goal_runs_20260811
EROOT = os.path.dirname(BASE)   # problems/E-klein-cubic

TIGHTEN = os.path.join(BASE, "STAGE1_TIGHTEN", "scripts")
COMPLEX = os.path.join(os.path.dirname(BASE), "goal_runs_20260810",
                       "STAGE1_COMPLEX_MAPS", "scripts")
ODDZERO = os.path.join(BASE, "ODDZERO_AUDIT", "scripts")

for p in (HERE, TIGHTEN):
    if p not in sys.path:
        sys.path.insert(0, p)
