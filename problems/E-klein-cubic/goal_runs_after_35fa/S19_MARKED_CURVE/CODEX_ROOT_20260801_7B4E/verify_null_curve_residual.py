#!/usr/bin/env python3
"""Verify that the curve/residual ledger makes no unsupported positive claim."""

import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def main():
    ledger = json.loads((HERE / "exact_curve_residual_verification.json").read_text())
    components = json.loads((HERE / "marked_component_presentation.json").read_text())
    status = (HERE / "STATUS.md").read_text().splitlines()[0]
    assert status == "S19-UNDECIDED"
    assert ledger["schema"] == "s19-exact-curve-residual-null-ledger-v1"
    assert ledger["status"] == "NOT_AVAILABLE_S19_UNDECIDED"
    assert ledger["curve"] is None
    assert ledger["residual_degree_two_cycle"] is None
    assert ledger["rational_point"] is None
    assert len(ledger["positive_certificate_requirements"]) == 7
    assert ledger["terminal_marker"] == "S19_NO_CURVE_OR_RESIDUAL_TO_VERIFY"
    for branch in ("epsilon_0", "epsilon_1"):
        assert components["branches"][branch]["nonemptiness"] == "UNDECIDED"
    assert "no residual degree-two cycle or rational point is constructed" in components["strict_nonclaims"]
    print("S19_NULL_CURVE_RESIDUAL_LEDGER_CONSISTENT")


if __name__ == "__main__":
    main()
