"""Path bootstrap for POINT_HUNT. Read-only sealed trees; write only here."""
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
LADDER = os.path.join(GR12, "CONE_LADDER_D35")
RES = os.path.join(PACKET, "results")
os.makedirs(RES, exist_ok=True)

for p in (HERE, D34):
    if p not in sys.path:
        sys.path.insert(0, p)

DEG = 35
NSEED = 637
DIM37 = 37
P3_SEALED = 1380
PRIMES = (331, 661)
# First m where a dim-9 cone can meet a generic section in a line.
HUNT_MS = (29,)
CONTROL_MS = (19, 20)
THREADS = 2
RSS_LIMIT_KB = 8 * 1024 * 1024 - 128 * 1024  # 8 GiB minus 128 MiB; stay under 8 GB
