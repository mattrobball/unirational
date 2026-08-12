"""Path bootstrap for DOMINANCE_D35. Read-only inputs; write only this packet."""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
REPO_E = os.path.dirname(os.path.dirname(PACKET))  # problems/E-klein-cubic
GR11 = os.path.join(REPO_E, "goal_runs_20260811")
D34 = os.path.join(GR11, "D34_GUIDED_SWEEP")
PAIR = os.path.join(GR11, "PAIR_ATTACK_D35")
PAIR_RES = os.path.join(PAIR, "results")
D35L = os.path.join(GR11, "D35_LANDING")
D35L_RES = os.path.join(D35L, "results")
RES = os.path.join(PACKET, "results")
LOGS = os.path.join(PACKET, "logs")
os.makedirs(RES, exist_ok=True)
os.makedirs(LOGS, exist_ok=True)

for p in (D34, HERE):
    if p not in sys.path:
        sys.path.insert(0, p)

PRIMES = (331, 661)
DEG = 35
K = 37
P3 = 1380
N3 = 9139
N4 = 91390
N5 = 749398
P4_UB = K * P3  # 51060
N2 = K * (K + 1) // 2  # 703
