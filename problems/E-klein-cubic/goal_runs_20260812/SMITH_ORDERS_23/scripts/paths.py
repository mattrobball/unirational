"""Packet-local paths. Nothing is written outside SMITH_ORDERS_23/."""
import os

HERE = os.path.dirname(os.path.abspath(__file__))
PKT = os.path.abspath(os.path.join(HERE, ".."))
E = os.path.abspath(os.path.join(PKT, "..", ".."))  # problems/E-klein-cubic
RES = os.path.join(PKT, "results")

SMITH_I3 = os.path.join(E, "goal_runs_20260812", "SMITH_I3")
STEIN = os.path.join(E, "goal_runs_20260812", "STEIN_LERAY")
L12 = os.path.join(E, "goal_runs_20260812", "L12_ORDER11")
STAGE1 = os.path.join(E, "goal_runs_20260810", "STAGE1_COMPLEX_MAPS")
TERMINUS = os.path.join(E, "goal_runs_20260810", "TERMINUS_STRATA_PW")
RECEIVER = os.path.join(E, "goal_runs_20260810", "RECEIVER_LEDGER_X")
SCHEME = os.path.join(E, "theory", "SCHEME_MAP_CONSEQUENCES_20260812.md")
HANDOFF = os.path.join(E, "HANDOFF_2026-08-12.md")
