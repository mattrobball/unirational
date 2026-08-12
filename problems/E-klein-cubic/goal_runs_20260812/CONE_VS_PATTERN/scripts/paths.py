"""Import bootstrap for CONE_VS_PATTERN. Sealed trees are read-only."""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
BASE12 = os.path.dirname(PACKET)
EROOT = os.path.dirname(BASE12)
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
D35L = os.path.join(BASE11, "D35_LANDING")
D35L_RES = os.path.join(D35L, "results")
LADDER = os.path.join(BASE12, "CONE_LADDER_D35")
LADDER_RES = os.path.join(LADDER, "results")
LADDER_SCR = os.path.join(LADDER, "scripts")
DEPTH = os.path.join(BASE12, "DEPTH_TABLE_GENERAL")
DEPTH_RES = os.path.join(DEPTH, "results")

RES = os.path.join(PACKET, "results")
os.makedirs(RES, exist_ok=True)

for p in (HERE, D34, PAIR_SCR, STRAT, TIGHTEN, COMPLEX, AUDIT_SCR, LADDER_SCR):
    if p not in sys.path:
        sys.path.insert(0, p)

DEG = 35
NSEED = 637
DIM39 = 39
DIM37 = 37
P3 = 1380
N3 = 9139
PRIMES = (331, 661)
SURV_IDS = [5, 7, 13, 15, 21, 23, 29, 31, 37, 39, 45, 47,
            53, 55, 61, 63, 69, 71, 697, 699, 701, 703]
