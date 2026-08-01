#!/usr/bin/env python3
"""Seal Goal B outputs and their pinned authoritative inputs."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]

ARTIFACTS = [
    "BRANCH_COMPARISON.md",
    "BRIDGE_THEOREM.md",
    "INCIDENCE_DIAGRAM.md",
    "INPUTS.md",
    "OBJECT_DICTIONARY.md",
    "REPLAY.md",
    "REQUIREMENTS.md",
    "STATUS.md",
    "WORKLOG.md",
    "bridge_payload.json",
    "counterexample_payload.json",
    "exact/field_presentation.json",
    "exact/five_forms.json",
    "exact/global_primitive_u_sextic_exact.tsv",
    "produce.py",
    "produce_seal.py",
    "verify.py",
    "verify_counterexample.py",
    "verify_projector_dictionary.py",
]

SOURCE_PATHS = {
    "goal": REPO / "goals_after_35fa8f/GOAL_B_FIXED_FRAME_TO_GENERIC_BRIDGE.md",
    "implementation_audit": REPO / "goals_after_35fa8f/IMPLEMENTATION_AUDIT.md",
    "goal_f_seal": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/SEAL.json",
    "field_presentation": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/field_presentation.json",
    "primitive_sextic": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/payload/global_primitive_u_sextic_exact.tsv",
    "goal_f_infinity": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/infinity_obstruction.json",
    "fixed_five_forms": REPO / "certificates/fixed_frame_arithmetic/five_forms.json",
    "fixed_frame_seal": REPO / "certificates/fixed_frame_arithmetic/SEAL.json",
    "pfaffian_seal": REPO / "certificates/pfaffian_point/SEAL.json",
    "idempotent_dictionary": REPO / "certificates/pfaffian_point/IDEMPOTENT_TO_KLEIN_POINT.md",
    "quaternion_corner": REPO / "certificates/pfaffian_point/quaternion_corner.json",
    "projector_proof_audit": REPO / "tmp/pfaffian_rank2_idempotent_attack/PROOF_AUDIT.md",
    "fold_payload": REPO / "certificates/fold_normalization/payload.json",
    "fold_seal": REPO / "certificates/fold_normalization/SEAL.json",
    "target_H": REPO / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv",
    "target_seal": REPO / "certificates/target_branch_global/SEAL.json",
    "target_mod3_report": REPO / "certificates/TARGET_BRANCH_MOD3_CLASS_GROUP.md",
    "target_mod3_payload": REPO / "certificates/target_branch_mod3/payload.json",
    "target_mod3_seal": REPO / "certificates/target_branch_mod3/SEAL.json",
    "fano_c0_model": REPO / "certificates/fano_interface_c0/C0_MODEL.md",
    "fano_c0_seal": REPO / "certificates/fano_interface_c0/SEAL.json",
}


def digest(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> None:
    payload = json.loads((HERE / "bridge_payload.json").read_text())
    sources = {name: digest(path) for name, path in SOURCE_PATHS.items()}
    if payload["source_sha256"] != sources:
        raise AssertionError("payload/source hash mismatch before sealing")
    commit = subprocess.run(
        ["git", "rev-parse", "HEAD"], cwd=REPO, text=True,
        stdout=subprocess.PIPE, check=True,
    ).stdout.strip()
    seal = {
        "schema": "klein-goal-b-fixed-frame-bridge-seal-v1",
        "exit": "B-UNDECIDED",
        "headline": "OPEN",
        "pinned_goal_commit": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "repository_commit_at_seal": commit,
        "artifact_sha256": {name: digest(HERE / name) for name in ARTIFACTS},
        "source_sha256": sources,
        "proved": [
            "exact five-object and arrow dictionary",
            "auxiliary fixed slice is nonexhaustive only on the auxiliary projector space",
            "Goal F infinity valuation and BR-T-NEG target valuation are distinct",
            "the two installed promotion arguments fail",
        ],
        "not_proved": payload["not_proved"],
        "terminal_marker": "B_UNDECIDED_FIXED_FRAME_BRIDGE_AUDIT_SEALED",
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print("B_UNDECIDED_FIXED_FRAME_BRIDGE_AUDIT_SEALED")


if __name__ == "__main__":
    main()
