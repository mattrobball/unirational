"""Sealed-input paths.  This packet writes only under CELL_SYNTHESIS/."""

import os

HERE = os.path.dirname(os.path.abspath(__file__))
PACKET = os.path.abspath(os.path.join(HERE, ".."))
RESULTS = os.path.join(PACKET, "results")
E = os.path.abspath(os.path.join(PACKET, "..", ".."))
G12 = os.path.join(E, "goal_runs_20260812")
G11 = os.path.join(E, "goal_runs_20260811")

SMITH = os.path.join(G12, "SMITH_I3", "results", "f2f3_congruences.json")
SMITH_THM = os.path.join(G12, "SMITH_I3", "THEOREM.md")
STEIN_LEDGER = os.path.join(G12, "STEIN_LERAY", "results", "dichotomy_ledger.json")
STEIN_MENUS = os.path.join(G12, "STEIN_LERAY", "results", "menus.json")
STEIN_THM = os.path.join(G12, "STEIN_LERAY", "THEOREM.md")
L12 = os.path.join(G12, "L12_ORDER11", "results", "l12_order11.json")
L12_THM = os.path.join(G12, "L12_ORDER11", "THEOREM.md")
DEPTH_SUM = os.path.join(G12, "DEPTH_TABLE_GENERAL", "results", "summary.json")
KEEP_331 = os.path.join(G12, "DEPTH_TABLE_GENERAL", "results", "keep_pass_22_p331.json")
KEEP_661 = os.path.join(G12, "DEPTH_TABLE_GENERAL", "results", "keep_pass_22_p661.json")
VECTORS = os.path.join(G11, "GLOBAL_COHERENCE", "results", "vectors_d35.json")
AUDIT = os.path.join(G11, "D35_AUDIT", "results", "patterns_r5_content_p331.json")
