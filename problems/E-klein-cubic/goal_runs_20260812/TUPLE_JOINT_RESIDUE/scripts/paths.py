"""Import path bootstrap for TUPLE_JOINT_RESIDUE.

Read-only sealed trees: STAGE1_STRATIFIED, STAGE1_TIGHTEN, STAGE1_COMPLEX_MAPS,
DEPTH_TABLE_GENERAL, CONE_ORDER_AUDIT, GLOBAL_COHERENCE.
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
BASE12 = os.path.dirname(PACKET)          # goal_runs_20260812
EROOT = os.path.dirname(BASE12)           # problems/E-klein-cubic
BASE11 = os.path.join(EROOT, "goal_runs_20260811")
BASE10 = os.path.join(EROOT, "goal_runs_20260810")

STRAT = os.path.join(BASE11, "STAGE1_STRATIFIED", "scripts")
TIGHTEN = os.path.join(BASE11, "STAGE1_TIGHTEN", "scripts")
COMPLEX = os.path.join(BASE10, "STAGE1_COMPLEX_MAPS", "scripts")
DEPTH = os.path.join(BASE12, "DEPTH_TABLE_GENERAL")
DEPTH_RES = os.path.join(DEPTH, "results")
RESULTS = os.path.join(PACKET, "results")

# Corrected K table (STAGE1_STRATIFIED, both primes)
K_TABLE = [11068, 1178, 1512, 6216, 1344, 756]

# Stage-1 immune factor in the K normalisation
IMM1 = 6 ** 8 * 4 ** 10 * 5 ** 4  # 1_100_753_141_760_000
D10_FREE = 23

for p in (HERE, STRAT, TIGHTEN, COMPLEX):
    if p not in sys.path:
        sys.path.insert(0, p)

os.makedirs(RESULTS, exist_ok=True)
