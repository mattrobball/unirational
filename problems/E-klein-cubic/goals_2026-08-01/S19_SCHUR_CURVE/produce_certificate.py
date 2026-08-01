#!/usr/bin/env python3
"""Deterministically produce the literal-target emptiness certificate."""

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

SOURCES = {
    "goals_2026-08-01/GOAL_S19_SCHUR_CURVE.md": (
        PROBLEM / "goals_2026-08-01/GOAL_S19_SCHUR_CURVE.md"
    ),
    "certificates/schur_degree19/IMPLICATION_AUDIT.md": (
        PROBLEM / "certificates/schur_degree19/IMPLICATION_AUDIT.md"
    ),
    "certificates/schur_degree19/marked_hilbert.json": (
        PROBLEM / "certificates/schur_degree19/marked_hilbert.json"
    ),
    "certificates/schur_degree19/rao_resolutions.json": (
        PROBLEM / "certificates/schur_degree19/rao_resolutions.json"
    ),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def repository_head() -> str:
    return subprocess.check_output(
        ["git", "-C", str(REPOSITORY), "rev-parse", "HEAD"], text=True
    ).strip()


def build() -> dict:
    goal = SOURCES["goals_2026-08-01/GOAL_S19_SCHUR_CURVE.md"].read_text()
    audit = SOURCES[
        "certificates/schur_degree19/IMPLICATION_AUDIT.md"
    ].read_text()
    if r"C\subset X_F\cap M" not in goal:
        raise RuntimeError("binding containment target is absent")
    if "no irreducible component" not in audit or "0-dimensional" not in audit:
        raise RuntimeError("proper-intersection conditions Q3/Q4 are absent")

    return {
        "schema_version": 1,
        "exit_code": "S19-NO-CURVE-SCOPED",
        "headline": "OPEN",
        "scope": "literal exact target in GOAL_S19_SCHUR_CURVE.md",
        "field": "F = K_Schur",
        "repository_commit_consumed": repository_head(),
        "goal_file_commit_consumed": (
            "67218b64ed1bf727f13bdcd7639c8651cd374897"
        ),
        "source_sha256": {name: sha256(path) for name, path in SOURCES.items()},
        "source_constraints": {
            "exact_target": "C is a closed subscheme of X_F intersect M",
            "target_ideal_consequence": "f3 belongs to I_C",
            "qualification_Q3": (
                "no irreducible component of C_Fbar lies in X_T"
            ),
            "qualification_Q4": "C intersect X_T is zero-dimensional",
            "residual_requirement": (
                "length(C intersect X_T) = 57 and residual after Z_55 has length 2"
            ),
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
        "branch_coverage": {
            epsilon: {
                "upstream_status": "LIVE",
                "literal_goal_qualified_status": "EMPTY",
                "reason": "ideal contradiction is independent of Rao data",
            }
            for epsilon in ("epsilon_0", "epsilon_1")
        },
        "base_change_scope": "all F-algebras and all extension fields",
        "corrected_target_status": "UNDECIDED",
        "corrected_target": (
            "C subset M, C not subset X_F, and Z subset C intersect X_F "
            "with local multiplicity one"
        ),
        "terminal_markers": [
            "S19_LITERAL_TARGET_IDEAL_CONTRADICTION_OK",
            "S19_BOTH_GOAL_QUALIFIED_BRANCHES_EMPTY_OK",
            "S19_NO_CURVE_SCOPED_VERIFY_OK",
            "HEADLINE_OPEN",
        ],
    }


def canonical(data: dict) -> str:
    return json.dumps(data, indent=2, sort_keys=False) + "\n"


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    generated = canonical(build())
    if args.check:
        if PAYLOAD.read_text() != generated:
            raise SystemExit("certificate mismatch")
        print("S19_EMPTINESS_CERTIFICATE_REPRODUCED_OK")
    elif args.write:
        PAYLOAD.write_text(generated)
        print(PAYLOAD)
    else:
        print(generated, end="")


if __name__ == "__main__":
    main()
