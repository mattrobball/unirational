"""Read-only locations. Writes stay inside this packet."""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PKT = os.path.dirname(HERE)
RES = os.path.join(PKT, "results")
SCR = HERE
EROOT = os.path.dirname(os.path.dirname(PKT))  # problems/E-klein-cubic
PAIR_RES = os.path.join(EROOT, "goal_runs_20260811", "PAIR_ATTACK_D35", "results")
DIR_PROBES = os.path.join(EROOT, "director_probes_20260812")

DEG = 35
NSEED = 637
DIM37 = 37
P3_SEALED = 1380
PRIMES = (331, 661)

assert "slicelib" not in sys.modules, "slicelib must not be imported"
