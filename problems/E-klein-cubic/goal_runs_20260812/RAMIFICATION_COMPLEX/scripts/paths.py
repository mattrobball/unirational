"""Import path bootstrap for RAMIFICATION_COMPLEX.

Read-only sealed trees: STAGE1_COMPLEX_MAPS, STAGE2_ODD_ORDER_PINNING,
TUPLE_JOINT_RESIDUE, D35_EXTENDED_SIEVE, RECEIVER_LEDGER_X, TERMINUS_STRATA_PW.
"""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
BASE12 = os.path.dirname(PACKET)          # goal_runs_20260812
EROOT = os.path.dirname(BASE12)           # problems/E-klein-cubic
BASE11 = os.path.join(EROOT, "goal_runs_20260811")
BASE10 = os.path.join(EROOT, "goal_runs_20260810")

COMPLEX = os.path.join(BASE10, "STAGE1_COMPLEX_MAPS")
COMPLEX_SCR = os.path.join(COMPLEX, "scripts")
COMPLEX_RES = os.path.join(COMPLEX, "results")
STAGE2 = os.path.join(BASE10, "STAGE2_ODD_ORDER_PINNING")
STAGE2_SCR = os.path.join(STAGE2, "scripts")
TUPLE = os.path.join(BASE12, "TUPLE_JOINT_RESIDUE")
TUPLE_RES = os.path.join(TUPLE, "results")
D35 = os.path.join(BASE12, "D35_EXTENDED_SIEVE")
D35_RES = os.path.join(D35, "results")
RECEIVER = os.path.join(BASE10, "RECEIVER_LEDGER_X")
TERMINUS = os.path.join(BASE10, "TERMINUS_STRATA_PW", "results")
PAIR = os.path.join(BASE11, "PAIR_ATTACK_D35", "results")
RESULTS = os.path.join(PACKET, "results")

# Sealed joint table (TUPLE_JOINT_RESIDUE)
J_TABLE = [11594, 1408, 2018, 10752, 1596, 1264]
K_TABLE = [11068, 1178, 1512, 6216, 1344, 756]
IMM1 = 6 ** 8 * 4 ** 10 * 5 ** 4
D10_FREE = 23

# STAGE1 sweep-capable and coherence-immune row ids (layer1 sealed)
SWEEP_ROWS = [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13, 14, 15, 16]
IMMUNE_ROWS = [21, 22, 29, 30, 31, 32, 33, 34, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 76, 77, 78, 79]
# all rows this packet tabulates
TABULATED = sorted(set(SWEEP_ROWS + IMMUNE_ROWS))

PRIMES = (331, 661)

for p in (HERE, STAGE2_SCR, COMPLEX_SCR):
    if p not in sys.path:
        sys.path.insert(0, p)

os.makedirs(RESULTS, exist_ok=True)
