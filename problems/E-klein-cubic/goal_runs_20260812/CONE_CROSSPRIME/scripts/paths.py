"""Path bootstrap for CONE_CROSSPRIME. Read sealed trees; write only here."""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
GR12 = os.path.dirname(PACKET)
EROOT = os.path.dirname(GR12)
D34 = os.path.join(EROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
PAIR = os.path.join(EROOT, "goal_runs_20260811", "PAIR_ATTACK_D35")
PAIR_RES = os.path.join(PAIR, "results")
DIR_PROBES = os.path.join(EROOT, "director_probes_20260812")
RES = os.path.join(PACKET, "results")
os.makedirs(RES, exist_ok=True)

for pth in (HERE, D34):
    if pth not in sys.path:
        sys.path.insert(0, pth)

DEG = 35
NSEED = 637
DIM37 = 37
P3_SEALED = 1380
PRIME = 661
DIRECTOR_PRIME = 331

# Packet-owned RNG. Distinct from director (20260812 / 777+m)
# and from CONE_LADDER_D35 (777+m / 20260812+p).
POINT_SEED = 661350035
SECTION_SEED_BASE = 661082012
SECTION_SEED_STRIDE = 10007

# Director claims being cross-primed (README table + free-rung text).
MS_FULL = (6, 8, 10, 18, 19)
MS_P3 = (20, 22)
MS_ALL = MS_FULL + MS_P3
THREADS = 2
