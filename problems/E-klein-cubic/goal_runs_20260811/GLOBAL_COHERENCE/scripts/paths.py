"""Path setup for GLOBAL_COHERENCE: reuse sealed s2pin, no rewrites."""
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.dirname(HERE)
E_ROOT = os.path.dirname(os.path.dirname(PACKET))  # problems/E-klein-cubic

S2PIN_SCRIPTS = os.path.join(
    E_ROOT, "goal_runs_20260810", "STAGE2_ODD_ORDER_PINNING", "scripts"
)
S2_RESULTS = os.path.join(
    E_ROOT, "goal_runs_20260810", "STAGE2_ODD_ORDER_PINNING", "results"
)
S1_STRAT = os.path.join(E_ROOT, "goal_runs_20260811", "STAGE1_STRATIFIED")
S1_STRAT_RESULTS = os.path.join(S1_STRAT, "results")
S2_SECOND = os.path.join(E_ROOT, "goal_runs_20260811", "STAGE2_SECOND_ORDER")

for p in (S2PIN_SCRIPTS, HERE):
    if p not in sys.path:
        sys.path.insert(0, p)

# Corrected sigma-band K table (STAGE1_STRATIFIED residue_table.txt)
K_TABLE = {0: 11068, 1: 1178, 2: 1512, 3: 6216, 4: 1344, 5: 756}

# D10 C2-line branch sizes (STAGE1_TIGHTEN Prop 2.1)
D10_E_BRANCH = 13   # tau-weight even: values on E_tau
D10_L_BRANCH = 10   # tau-weight odd:  values on L_tau
D10_TOTAL = 23      # free product (both branches)

RESULTS = os.path.join(PACKET, "results")
