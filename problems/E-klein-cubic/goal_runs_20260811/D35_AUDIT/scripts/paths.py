"""Import bootstrap for D35_AUDIT. Read-only sealed packets; no edits there."""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
BASE = os.path.dirname(PACKET)  # goal_runs_20260811
EROOT = os.path.dirname(BASE)

D34 = os.path.join(BASE, "D34_GUIDED_SWEEP")
PAIR = os.path.join(BASE, "PAIR_ATTACK_D35")
PAIR_SCR = os.path.join(PAIR, "scripts")
PAIR_RES = os.path.join(PAIR, "results")
STRAT = os.path.join(BASE, "STAGE1_STRATIFIED", "scripts")
TIGHTEN = os.path.join(BASE, "STAGE1_TIGHTEN", "scripts")
COMPLEX = os.path.join(os.path.dirname(BASE), "goal_runs_20260810",
                       "STAGE1_COMPLEX_MAPS", "scripts")
ODDZERO = os.path.join(BASE, "ODDZERO_AUDIT", "scripts")
S2SO = os.path.join(BASE, "STAGE2_SECOND_ORDER", "scripts")
AUDIT_RES = os.path.join(PACKET, "results")

for p in (HERE, D34, PAIR_SCR, STRAT, TIGHTEN, COMPLEX):
    if p not in sys.path:
        sys.path.insert(0, p)
