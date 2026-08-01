#!/usr/bin/env python3
"""Verify that the blocked audit preserves the binding binary boundary."""

from __future__ import annotations

import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
GOAL = HERE.parent / "GOAL_Q_SCHUR_INDEX_ONE_DESCENT.md"
DATA = json.loads((HERE / "completion_audit.json").read_text())

assert DATA["format"] == "Q-SCHUR-COMPLETION-AUDIT-v1"
assert DATA["requested_binary_resolution"] is True
assert DATA["positive_point_constructed"] is False
assert DATA["positive_original_equation_verified"] is False
assert DATA["negative_full_twist_obstruction_constructed"] is False
assert DATA["negative_exhaustiveness_verified"] is False
assert DATA["binary_goal_complete"] is False
assert DATA["packet_status"] == "Q-UNDECIDED"
assert DATA["goal_status_decision"] == "BLOCKED"
assert DATA["same_blocker_goal_turns_at_least"] >= 3
assert DATA["pending_degree25_boundary_saturation_is_terminal_for_q"] is False
assert DATA["completion_prohibited"] is True

goal = GOAL.read_text()
assert "Q-SCHUR-POINT-HEADLINE-POSITIVE" in goal
assert "Q-SCHUR-POINTLESS-HEADLINE-NEGATIVE" in goal
assert "Index one is not a rational point" in goal
assert (HERE / "STATUS.md").read_text().splitlines()[0] == "Q-UNDECIDED"

audit = (HERE / "COMPLETION_AUDIT.md").read_text()
for phrase in (
    "Construct a `K_Schur`-point",
    "Prove the genuine full twist pointless",
    "No such invariant or obstruction payload exists",
    "Any row marked missing prevents",
):
    assert phrase in audit

print("PASS positive acceptance requirements are explicitly unmet")
print("PASS negative acceptance requirements are explicitly unmet")
print("PASS bounded and structural results are not promoted to completion")
print("PASS same full-twist binary blocker recurred for at least three goal turns")
print("Q_SCHUR_REQUIREMENT_AUDIT_BLOCKED_NOT_COMPLETE")
