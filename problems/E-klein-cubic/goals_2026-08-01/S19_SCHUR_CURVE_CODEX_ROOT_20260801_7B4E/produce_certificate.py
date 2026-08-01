#!/usr/bin/env python3
"""Deterministically reconstruct the literal S19 emptiness certificate."""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
REPOSITORY = PROBLEM.parents[1]
PAYLOAD = HERE / "emptiness_certificate.json"
CONSUMED = "2140419410cfff2f7d7dcca166acef8c16a0d41b"
GOAL_COMMIT = "67218b64ed1bf727f13bdcd7639c8651cd374897"
SOURCES = (
    "goals_2026-08-01/GOAL_S19_SCHUR_CURVE.md",
    "certificates/schur_degree19/IMPLICATION_AUDIT.md",
    "certificates/schur_degree19/marked_hilbert.json",
    "certificates/schur_degree19/rao_resolutions.json",
)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require_commit(commit: str) -> None:
    subprocess.check_call(
        ["git", "-C", str(REPOSITORY), "cat-file", "-e", commit + "^{commit}"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def build() -> dict:
    require_commit(CONSUMED)
    require_commit(GOAL_COMMIT)
    goal = (PROBLEM / SOURCES[0]).read_text()
    audit = (PROBLEM / SOURCES[1]).read_text()
    marked = json.loads((PROBLEM / SOURCES[2]).read_text())
    rao = json.loads((PROBLEM / SOURCES[3]).read_text())
    if r"C\subset X_F\cap M" not in goal:
        raise RuntimeError("exact containment clause not found")
    if "no irreducible component" not in audit or "is 0-dimensional" not in audit:
        raise RuntimeError("Q3/Q4 bridge clauses not found")
    if marked["nonemptiness"]["H_Z_epsilon_F"] != "UNDECIDED for epsilon in {0,1}":
        raise RuntimeError("corrected marked-branch scope changed")

    branch_coverage = {}
    for name in ("epsilon_0", "epsilon_1"):
        branch = rao["branches"][name]
        branch_coverage[name] = {
            "upstream_status": branch["status"],
            "rao_d0_to_5": branch["rao_d0_to_5"],
            "literal_goal_qualified_status": "EMPTY",
            "reason": "ideal contradiction is independent of Rao data",
        }

    return {
        "schema_version": 1,
        "exit_code": "S19-NO-CURVE-SCOPED",
        "headline": "OPEN",
        "scope": "literal exact target in GOAL_S19_SCHUR_CURVE.md",
        "field": "F = K_Schur",
        "repository_commit_consumed": CONSUMED,
        "goal_file_commit_consumed": GOAL_COMMIT,
        "source_sha256": {name: sha256(PROBLEM / name) for name in SOURCES},
        "source_constraints": {
            "exact_target": "C is a closed subscheme of X_F intersect M",
            "target_ideal_consequence": "f3 belongs to I_C",
            "qualification_Q3": "no irreducible component of C_Fbar lies in X_T",
            "qualification_Q4": "C intersect X_T is zero-dimensional",
            "residual_requirement": "length(C intersect X_T) = 57 and residual after Z_55 has length 2",
        },
        "ideal_certificate": {
            "ambient_ring": "S = F[x0,x1,x2,x3]",
            "cubic_ideal": "I_X = (f3)",
            "curve_ideal": "I_C",
            "containment_rule": "C subset X iff I_X subset I_C",
            "membership": "f3 in I_C",
            "intersection_rule": "I_(C intersect X) = I_C + I_X",
            "absorption": "I_C + (f3) = I_C",
            "scheme_conclusion": "C intersect X = C",
            "actual_intersection_dimension": 1,
            "required_intersection_dimension": 0,
            "contradiction": "1 != 0",
        },
        "independent_component_certificate": {
            "geometrically_integral_implies_component_count": 1,
            "containment_puts_component_in_X": True,
            "Q3_forbids_component_in_X": True,
            "contradiction": True,
        },
        "branch_coverage": branch_coverage,
        "base_change_scope": "all field extensions E/F",
        "corrected_target_status": "UNDECIDED",
        "corrected_target": "B subset M, B not subset X_F, and Z subset B intersect X_F with local multiplicity one",
        "terminal_markers": [
            "S19_LITERAL_TARGET_IDEAL_CONTRADICTION_OK",
            "S19_BOTH_GOAL_QUALIFIED_BRANCHES_EMPTY_OK",
            "S19_NO_CURVE_SCOPED_VERIFY_OK",
            "HEADLINE_OPEN",
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    computed = build()
    if args.check:
        if json.loads(PAYLOAD.read_text()) != computed:
            raise SystemExit("certificate mismatch")
        print("S19_EMPTY_CERTIFICATE_PRODUCER_CHECK_OK")
    else:
        print(json.dumps(computed, indent=2))


if __name__ == "__main__":
    main()
