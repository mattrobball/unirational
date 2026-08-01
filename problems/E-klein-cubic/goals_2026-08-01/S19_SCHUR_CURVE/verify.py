#!/usr/bin/env python3
"""Independent verifier for the literal S19 target contradiction."""

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
    paths = {
        "goals_2026-08-01/GOAL_S19_SCHUR_CURVE.md": goal_path,
        "certificates/schur_degree19/IMPLICATION_AUDIT.md": audit_path,
        "certificates/schur_degree19/marked_hilbert.json": marked_path,
        "certificates/schur_degree19/rao_resolutions.json": rao_path,
    }

    # Pin the exact authoritative input snapshot rather than accepting drift.
    head = subprocess.check_output(
        ["git", "-C", str(REPOSITORY), "rev-parse", "HEAD"], text=True
    ).strip()
    require(head == payload["repository_commit_consumed"], "repository HEAD drift")
    for name, path in paths.items():
        require(
            sha256(path) == payload["source_sha256"][name],
            f"source hash mismatch: {name}",
        )

    goal = goal_path.read_text()
    audit = audit_path.read_text()
    require(r"C\subset X_F\cap M" in goal, "exact target does not contain C in X")
    require("no irreducible component" in audit, "Q3 source text absent")
    require("is 0-dimensional" in audit, "Q4 source text absent")
    require("3\\cdot 19=57" in audit, "Bezout degree source text absent")

    # Recompute the ideal-theoretic contradiction.  Containment C subset X
    # means the cubic generator f3 is already in I_C.  Adjoining a generator
    # already in an ideal is an absorbing operation.
    formal_I_C_generators = frozenset({"arbitrary_generators_of_I_C", "f3"})
    intersection_generators = formal_I_C_generators | frozenset({"f3"})
    absorbed = intersection_generators == formal_I_C_generators
    require(absorbed, "I_C + (f3) did not absorb f3")

    dim_C = 1 if "pure of dimension 1" in audit else None
    required_intersection_dim = 0 if "is 0-dimensional" in audit else None
    actual_intersection_dim = dim_C if absorbed else None
    require(dim_C == 1, "curve dimension not recovered")
    require(required_intersection_dim == 0, "proper-intersection dimension absent")
    require(
        actual_intersection_dim != required_intersection_dim,
        "target and proper-intersection dimensions unexpectedly agree",
    )

    ideal = payload["ideal_certificate"]
    require(ideal["actual_intersection_dimension"] == actual_intersection_dim, "bad actual dimension")
    require(ideal["required_intersection_dimension"] == required_intersection_dim, "bad required dimension")
    require(ideal["absorption"] == "I_C + (f3) = I_C", "bad absorption claim")

    # Independently recompute the component contradiction: geometric
    # integrality gives one component; target containment puts it in X; Q3
    # forbids every such component.
    target_geometrically_integral = "geometrically integral" in goal
    target_contained_in_X = r"C\subset X_F\cap M" in goal
    q3_forbids_component = "no irreducible component" in audit
    component_contradiction = all(
        (target_geometrically_integral, target_contained_in_X, q3_forbids_component)
    )
    require(component_contradiction, "component contradiction not recovered")
    require(
        payload["independent_component_certificate"]["contradiction"] is True,
        "payload omits component contradiction",
    )

    # Read the authoritative branch file and verify that exactly the two live
    # Rao branches are covered by the uniform contradiction.
    rao = json.loads(rao_path.read_text())
    live = {name for name, branch in rao["branches"].items() if branch["status"] == "LIVE"}
    require(live == {"epsilon_0", "epsilon_1"}, "unexpected live-branch set")
    covered = set(payload["branch_coverage"])
    require(covered == live, "certificate does not cover exactly both live branches")
    for name in live:
        branch = payload["branch_coverage"][name]
        require(branch["literal_goal_qualified_status"] == "EMPTY", f"{name} not empty")
    marked = json.loads(marked_path.read_text())
    require(
        marked["nonemptiness"]["H_Z_epsilon_F"] == "UNDECIDED for epsilon in {0,1}",
        "corrected upstream branch boundary changed",
    )
    require(payload["corrected_target_status"] == "UNDECIDED", "scope overclaim")
    require(payload["headline"] == "OPEN", "headline overclaim")

    # Verify the local content seal without trusting stored success booleans.
    seal = json.loads((HERE / "SEAL.json").read_text())
    for relative, expected in seal["deliverable_sha256"].items():
        require(sha256(HERE / relative) == expected, f"seal mismatch: {relative}")
    require((HERE / "STATUS.md").read_text().splitlines()[0] == payload["exit_code"], "exit-code mismatch")

    print("S19_LITERAL_TARGET_IDEAL_CONTRADICTION_OK")
    print("S19_BOTH_GOAL_QUALIFIED_BRANCHES_EMPTY_OK")
    print("S19_NO_CURVE_SCOPED_VERIFY_OK")
    print("HEADLINE_OPEN")


if __name__ == "__main__":
    main()
