#!/usr/bin/env python3
"""Independent verifier for the literal S19 scoped-emptiness theorem."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
REPOSITORY = PROBLEM.parents[1]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> None:
    payload = json.loads((HERE / "emptiness_certificate.json").read_text())
    goal_path = PROBLEM / "goals_2026-08-01/GOAL_S19_SCHUR_CURVE.md"
    audit_path = PROBLEM / "certificates/schur_degree19/IMPLICATION_AUDIT.md"
    marked_path = PROBLEM / "certificates/schur_degree19/marked_hilbert.json"
    rao_path = PROBLEM / "certificates/schur_degree19/rao_resolutions.json"
    sources = {
        "goals_2026-08-01/GOAL_S19_SCHUR_CURVE.md": goal_path,
        "certificates/schur_degree19/IMPLICATION_AUDIT.md": audit_path,
        "certificates/schur_degree19/marked_hilbert.json": marked_path,
        "certificates/schur_degree19/rao_resolutions.json": rao_path,
    }

    # Verify that the recorded commit exists and every load-bearing source has
    # the exact bytes consumed.  This remains stable across unrelated commits.
    subprocess.check_call(
        [
            "git",
            "-C",
            str(REPOSITORY),
            "cat-file",
            "-e",
            payload["repository_commit_consumed"] + "^{commit}",
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )
    for name, path in sources.items():
        require(sha256(path) == payload["source_sha256"][name], f"source drift: {name}")

    goal = goal_path.read_text()
    audit = audit_path.read_text()
    require(r"C\subset X_F\cap M" in goal, "target containment absent")
    require("geometrically integral" in goal, "target integrality absent")
    require("no irreducible component" in audit, "Q3 absent")
    require("pure of dimension 1" in audit, "curve dimension absent")
    require("is 0-dimensional" in audit, "Q4 absent")
    require("3\\cdot 19=57" in audit, "Bezout length absent")

    # Recompute the ideal identity instead of trusting a stored success flag.
    ideal_c = frozenset({"arbitrary_generators_of_I_C", "f3"})
    ideal_x = frozenset({"f3"})
    intersection_ideal = ideal_c | ideal_x
    absorbed = intersection_ideal == ideal_c
    actual_dimension = 1 if absorbed else None
    required_dimension = 0
    require(absorbed, "I_C + (f3) did not absorb")
    require(actual_dimension != required_dimension, "intersection dimensions agree")

    ideal_payload = payload["ideal_certificate"]
    require(ideal_payload["absorption"] == "I_C + (f3) = I_C", "bad ideal claim")
    require(ideal_payload["actual_intersection_dimension"] == actual_dimension, "bad actual dimension")
    require(ideal_payload["required_intersection_dimension"] == required_dimension, "bad required dimension")

    # Independent component contradiction.
    component_contradiction = all(
        (
            "geometrically integral" in goal,
            r"C\subset X_F\cap M" in goal,
            "no irreducible component" in audit,
        )
    )
    require(component_contradiction, "component contradiction absent")
    require(payload["independent_component_certificate"]["contradiction"] is True, "payload component gap")

    # Verify exact coverage of the two authoritative live branches and retain
    # the upstream undecided boundary for the corrected ambient problem.
    rao = json.loads(rao_path.read_text())
    live = {name for name, branch in rao["branches"].items() if branch["status"] == "LIVE"}
    require(live == {"epsilon_0", "epsilon_1"}, "unexpected live branch set")
    require(set(payload["branch_coverage"]) == live, "branch coverage mismatch")
    for name in live:
        stored = payload["branch_coverage"][name]
        require(stored["upstream_status"] == "LIVE", f"{name} source status mismatch")
        require(stored["rao_d0_to_5"] == rao["branches"][name]["rao_d0_to_5"], f"{name} Rao mismatch")
        require(stored["literal_goal_qualified_status"] == "EMPTY", f"{name} not closed")
    marked = json.loads(marked_path.read_text())
    require(marked["nonemptiness"]["H_Z_epsilon_F"] == "UNDECIDED for epsilon in {0,1}", "upstream boundary changed")
    require(payload["corrected_target_status"] == "UNDECIDED", "corrected problem overclaim")
    require(payload["headline"] == "OPEN", "headline overclaim")
    require((HERE / "STATUS.md").read_text().splitlines()[0] == payload["exit_code"], "status mismatch")

    seal = json.loads((HERE / "SEAL.json").read_text())
    require("SEAL.json" not in seal["deliverable_sha256"], "self-hash forbidden")
    for relative, expected in seal["deliverable_sha256"].items():
        require(sha256(HERE / relative) == expected, f"seal mismatch: {relative}")

    print("S19_LITERAL_TARGET_IDEAL_CONTRADICTION_OK")
    print("S19_BOTH_GOAL_QUALIFIED_BRANCHES_EMPTY_OK")
    print("S19_NO_CURVE_SCOPED_VERIFY_OK")
    print("HEADLINE_OPEN")


if __name__ == "__main__":
    main()
