"""Path bootstrap for D35_LANDING: expose D34 slicelib and PAIR_ATTACK inputs."""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
REPO_E = os.path.dirname(os.path.dirname(PACKET))  # problems/E-klein-cubic
D34 = os.path.join(os.path.dirname(PACKET), "D34_GUIDED_SWEEP")
PAIR = os.path.join(os.path.dirname(PACKET), "PAIR_ATTACK_D35")
PAIR_RES = os.path.join(PAIR, "results")
RES = os.path.join(PACKET, "results")
os.makedirs(RES, exist_ok=True)

for p in (D34, HERE):
    if p not in sys.path:
        sys.path.insert(0, p)
