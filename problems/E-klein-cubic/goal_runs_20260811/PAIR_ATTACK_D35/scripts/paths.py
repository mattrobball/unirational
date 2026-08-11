"""Import bootstrap: sealed D34 / STAGE1_STRATIFIED / STAGE2 trees are read-only.

This packet only adds its own modules under PAIR_ATTACK_D35/scripts/.
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
BASE = os.path.dirname(PACKET)  # goal_runs_20260811
EROOT = os.path.dirname(BASE)   # problems/E-klein-cubic

D34 = os.path.join(BASE, "D34_GUIDED_SWEEP")
STRAT = os.path.join(BASE, "STAGE1_STRATIFIED", "scripts")
TIGHTEN = os.path.join(BASE, "STAGE1_TIGHTEN", "scripts")
COMPLEX = os.path.join(os.path.dirname(BASE), "goal_runs_20260810",
                       "STAGE1_COMPLEX_MAPS", "scripts")
ODDZERO = os.path.join(BASE, "ODDZERO_AUDIT", "scripts")
STAGE2 = os.path.join(os.path.dirname(BASE), "goal_runs_20260810",
                      "STAGE2_ODD_ORDER_PINNING", "scripts")
S2SO = os.path.join(BASE, "STAGE2_SECOND_ORDER", "scripts")

for p in (HERE, D34, STRAT, TIGHTEN):
    if p not in sys.path:
        sys.path.insert(0, p)
