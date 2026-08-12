"""Path bootstrap for CONE_LADDER_D35. Read-only sealed trees; write only here."""
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

for p in (HERE, D34):
    if p not in sys.path:
        sys.path.insert(0, p)

DEG = 35
NSEED = 637
DIM39 = 39
DIM37 = 37
P3_SEALED = 1380
PRIMES = (331, 661)
# Spec ladder + control. Higher rungs only if the previous one terminates.
RUNGS = (20, 22, 24, 28, 32)
HIGHER = (34, 36, 37)
