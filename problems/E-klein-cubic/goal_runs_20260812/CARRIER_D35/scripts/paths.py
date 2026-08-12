"""Import bootstrap for CARRIER_D35. Sealed trees are read-only."""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
GR12 = os.path.dirname(PACKET)
EROOT = os.path.dirname(GR12)
D34 = os.path.join(EROOT, "goal_runs_20260811", "D34_GUIDED_SWEEP")
PAIR = os.path.join(EROOT, "goal_runs_20260811", "PAIR_ATTACK_D35")
PAIR_RES = os.path.join(PAIR, "results")
SIEVE = os.path.join(GR12, "D35_EXTENDED_SIEVE")
SIEVE_RES = os.path.join(SIEVE, "results")
DEPTH = os.path.join(GR12, "DEPTH_TABLE_GENERAL")
DEPTH_RES = os.path.join(DEPTH, "results")
QR = os.path.join(GR12, "QR_POINT_CUTS")
QR_SCR = os.path.join(QR, "scripts")
GATE = os.path.join(EROOT, "goal_runs_after_ac61998", "FIX_VII_GATE")
LAND = os.path.join(EROOT, "goal_runs_after_10804b2", "FIX_VII_LAND")
RES = os.path.join(PACKET, "results")
TMP = os.path.join(PACKET, "tmp")

for p in (HERE, D34, QR_SCR):
    if p not in sys.path:
        sys.path.insert(0, p)

os.makedirs(RES, exist_ok=True)
os.makedirs(TMP, exist_ok=True)

DEG = 35
NSEED = 637
DIM39 = 39
DIM37 = 37
PRIMES = (331, 661)
SURV_IDS = [
    5, 7, 13, 15, 21, 23, 29, 31, 37, 39, 45, 47,
    53, 55, 61, 63, 69, 71, 697, 699, 701, 703,
]
# Character-theoretic W-bar multiplicity of H^0(C, O(d)) — hess_window.py
ONCURVE_WB = {33: 4, 34: 6, 35: 5, 36: 5, 37: 7}
MOLIEN_WB = {33: 511, 34: 576, 35: 637, 36: 706, 37: 786}
