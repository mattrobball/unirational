"""Import bootstrap for DEPTH_TABLE_GENERAL. Sealed packets are read-only."""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)                 # .../DEPTH_TABLE_GENERAL
BASE12 = os.path.dirname(PACKET)               # .../goal_runs_20260812
EROOT = os.path.dirname(BASE12)                # .../problems/E-klein-cubic
BASE11 = os.path.join(EROOT, "goal_runs_20260811")

D34 = os.path.join(BASE11, "D34_GUIDED_SWEEP")
PAIR = os.path.join(BASE11, "PAIR_ATTACK_D35")
PAIR_SCR = os.path.join(PAIR, "scripts")
PAIR_RES = os.path.join(PAIR, "results")
AUDIT = os.path.join(BASE11, "D35_AUDIT")
AUDIT_RES = os.path.join(AUDIT, "results")
AUDIT_SCR = os.path.join(AUDIT, "scripts")
STRAT = os.path.join(BASE11, "STAGE1_STRATIFIED", "scripts")
TIGHTEN = os.path.join(BASE11, "STAGE1_TIGHTEN", "scripts")
COMPLEX = os.path.join(EROOT, "goal_runs_20260810",
                       "STAGE1_COMPLEX_MAPS", "scripts")

RES = os.path.join(PACKET, "results")

for p in (HERE, D34, PAIR_SCR, STRAT, TIGHTEN, COMPLEX, AUDIT_SCR):
    if p not in sys.path:
        sys.path.insert(0, p)
