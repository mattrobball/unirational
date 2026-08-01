#!/usr/bin/env python3
"""Independently verify the directory-wide S19 packet seal and boundary."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    seal = json.loads(SEAL.read_text())
    assert seal["schema"] == "s19-marked-curve-continuation-seal-v1"
    assert seal["decision_exit"] == "S19-UNDECIDED"
    assert seal["pinned_state"] == "35fa8f59b6a1423cc89300aeaceefe91552be5ba"
    assert seal["terminal_marker"] == "S19_MARKED_CURVE_CONTINUATION_SEALED_UNDECIDED"
    files = sorted(
        path for path in HERE.iterdir()
        if path.is_file() and path.name != "SEAL.json" and not path.name.startswith(".")
    )
    assert set(seal["artifact_sha256"]) == {path.name for path in files}
    for path in files:
        assert seal["artifact_sha256"][path.name] == digest(path), path.name

    problem = HERE.parents[2]
    for name, expected in seal["consumed_source_sha256"].items():
        assert digest(problem / name) == expected, name

    assert (HERE / "STATUS.md").read_text().splitlines()[0] == "S19-UNDECIDED"
    family = json.loads((HERE / "universal_marked_family.json").read_text())
    components = json.loads((HERE / "marked_component_presentation.json").read_text())
    incidence = json.loads((HERE / "marked_incidence_presentation.json").read_text())
    residual = json.loads((HERE / "exact_curve_residual_verification.json").read_text())
    assert family["terminal_marker"] == "S19_CANONICAL_MARKED_55_FAMILY_EXACT"
    assert components["terminal_marker"] == "S19_MARKED_COMPONENTS_FINITE_PRESENTATION_EXACT"
    assert incidence["terminal_marker"] == "S19_MARKED_INCIDENCE_FINITE_PRESENTATION_EXACT"
    assert residual["terminal_marker"] == "S19_NO_CURVE_OR_RESIDUAL_TO_VERIFY"
    assert all(components["branches"][name]["nonemptiness"] == "UNDECIDED" for name in ("epsilon_0", "epsilon_1"))
    assert residual["curve"] is residual["residual_degree_two_cycle"] is residual["rational_point"] is None
    assert "neither Rao branch is excluded" in components["strict_nonclaims"]
    assert "the Klein-cubic headline remains open" in components["strict_nonclaims"]
    print("PASS every non-SEAL file and consumed source matches the hash manifest")
    print("PASS S19-UNDECIDED curve, branch, residual, and headline boundary")
    print("S19_SEAL_VERIFIED")


if __name__ == "__main__":
    main()
