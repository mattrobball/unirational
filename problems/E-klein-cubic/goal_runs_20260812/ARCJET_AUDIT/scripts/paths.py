"""Import bootstrap for ARCJET_AUDIT. Sealed packets read-only; write only here."""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
BASE12 = os.path.dirname(PACKET)
EROOT = os.path.dirname(BASE12)
BASE11 = os.path.join(EROOT, "goal_runs_20260811")
BASE10 = os.path.join(EROOT, "goal_runs_20260810")

D34 = os.path.join(BASE11, "D34_GUIDED_SWEEP")
PAIR = os.path.join(BASE11, "PAIR_ATTACK_D35")
PAIR_SCR = os.path.join(PAIR, "scripts")
PAIR_RES = os.path.join(PAIR, "results")
AUDIT = os.path.join(BASE11, "D35_AUDIT")
AUDIT_RES = os.path.join(AUDIT, "results")
AUDIT_SCR = os.path.join(AUDIT, "scripts")
STRAT = os.path.join(BASE11, "STAGE1_STRATIFIED", "scripts")
TIGHTEN = os.path.join(BASE11, "STAGE1_TIGHTEN", "scripts")
COMPLEX = os.path.join(BASE10, "STAGE1_COMPLEX_MAPS", "scripts")
DEPTH = os.path.join(BASE12, "DEPTH_TABLE_GENERAL")
DEPTH_RES = os.path.join(DEPTH, "results")
DEPTH_SCR = os.path.join(DEPTH, "scripts")
TUPLE = os.path.join(BASE12, "TUPLE_JOINT_RESIDUE")
TUPLE_SCR = os.path.join(TUPLE, "scripts")
TUPLE_RES = os.path.join(TUPLE, "results")
EXT = os.path.join(BASE12, "D35_EXTENDED_SIEVE")
EXT_RES = os.path.join(EXT, "results")
EXT_SCR = os.path.join(EXT, "scripts")

RES = os.path.join(PACKET, "results")

SURV_IDS = [5, 7, 13, 15, 21, 23, 29, 31, 37, 39, 45, 47,
            53, 55, 61, 63, 69, 71, 697, 699, 701, 703]
PRIMES = (331, 661, 991)
J_R5 = 1264
K_R5 = 756
N_EXT = 508

for p in (HERE, D34, PAIR_SCR, STRAT, TIGHTEN, COMPLEX, DEPTH_SCR, TUPLE_SCR):
    if p not in sys.path:
        sys.path.insert(0, p)

os.makedirs(RES, exist_ok=True)
