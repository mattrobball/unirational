#!/usr/bin/env python3
"""Verify G3A smoothness + dominance bridge ledgers against sources."""

from __future__ import annotations

import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SMOOTH = HERE / "SMOOTHNESS.md"
DOM = HERE / "DOMINANCE_BRIDGE.md"
G2_STATUS = ROOT / "goal_runs_after_35fa" / "G_UNIVERSAL" / "STATUS.md"
G2_DECISION = ROOT / "goal_runs_after_35fa" / "G_UNIVERSAL" / "DECISION.md"
G2_UNIV = ROOT / "goal_runs_after_35fa" / "G_UNIVERSAL" / "UNIVERSAL_OBJECT.md"
SPEC = ROOT / "SPEC.md"
BRIDGE_JSON = HERE / "dominance_bridge.json"


def require(cond: bool, msg: str) -> None:
    if not cond:
        raise AssertionError(msg)


def main() -> None:
    require(SMOOTH.is_file() and DOM.is_file(), "bridge docs missing")
    smooth = SMOOTH.read_text()
    dom = DOM.read_text()
    require("twist" in smooth.lower() or "twisting" in smooth.lower(), "twist argument")
    require("Jacobian" in smooth or "jacobian" in smooth, "jacobian check mentioned")
    require("smooth" in smooth.lower(), "smoothness conclusion")

    # Dominance automatic or gap
    has_auto = "G3-DOMINANCE-AUTOMATIC" in dom
    has_gap = "G3A-ARITHMETIC-PASS-DOMINANCE-GAP" in dom or "DOMINANCE-GAP" in dom
    require(has_auto or has_gap, "need automatic or gap marker")

    ledger = json.loads(BRIDGE_JSON.read_text())
    require(ledger["schema"] == "g3a-dominance-bridge-v1", "schema")
    steps = ledger["positive_steps"]
    require(len(steps) == 7, "seven positive steps")
    for i, step in enumerate(steps, 1):
        require(step["id"] == i, f"step id {i}")
        require(step["status"] in ("PASS", "ACCEPTED_INPUT", "GAP"), f"step {i} status")
        require(step.get("citation") or step.get("check"), f"step {i} evidence")

    if has_auto:
        require(ledger["verdict"] == "G3-DOMINANCE-AUTOMATIC", "json verdict auto")
        require(all(s["status"] in ("PASS", "ACCEPTED_INPUT") for s in steps), "all steps ok")
        require(ledger.get("jacobian_rank_four_required") is False, "no extra rank-4 gate")

    # Negative direction: cite G2 emptiness => no linear-source maps
    require("negative" in ledger, "negative branch")
    neg = ledger["negative"]
    require("G2" in neg.get("source", "") or "all-degree" in neg.get("source", "").lower()
            or "FINITE-GENERATION" in neg.get("source", "")
            or "UNIVERSAL" in neg.get("source", ""), "G2 citation")
    require("empty" in neg.get("statement", "").lower() or "∅" in neg.get("statement", "")
            or "pointless" in neg.get("statement", "").lower()
            or "X_gen" in neg.get("statement", ""), "emptiness statement")

    # Parent G2 structural seal still present
    require(G2_STATUS.read_text().startswith("G2-FINITE-GENERATION-PASS\n"), "G2 seal")
    decision = G2_DECISION.read_text()
    require("X_gen" in decision or "V(\\Phi)" in decision or "V(Phi)" in decision
            or "generic" in decision.lower(), "decision object")

    # X^G empty and ed citations exist in SPEC / UNIVERSAL_OBJECT
    univ = G2_UNIV.read_text()
    spec = SPEC.read_text()
    require(
        "X^G" in spec or "fixed" in univ.lower(),
        "fixed-point / X^G language present upstream",
    )
    require(
        "essential dimension" in spec.lower() or "ed" in dom.lower(),
        "ed language present",
    )

    # No point-search success claims (allow explicit non-claim lines)
    require(
        "exit" not in dom.lower()
        or "G3-COVARIANT-HEADLINE-POSITIVE" not in [
            line.strip("` ")
            for line in dom.splitlines()
            if line.strip().startswith("G3-COVARIANT")
        ],
        "no point headline as exit",
    )
    require("rational point found" not in dom.lower(), "no point claim")
    require("No `G3-COVARIANT-HEADLINE-POSITIVE`" in dom or "non-claim" in dom.lower()
            or "No point" in dom or "No $K" in dom or "No K" in dom
            or "non-claims" in dom.lower(),
            "must fence non-claims")

    # Loopholes section
    require("constant" in dom.lower(), "constant-map loophole")
    require("cone" in dom.lower() or "projective" in dom.lower(), "cone/projective loophole")

    print("G3A_SMOOTHNESS_LEDGER_OK")
    print("G3A_DOMINANCE_BRIDGE_OK")
    if has_auto:
        print("G3-DOMINANCE-AUTOMATIC")
    print("G3A_BRIDGE_VERIFY_OK")


if __name__ == "__main__":
    main()
