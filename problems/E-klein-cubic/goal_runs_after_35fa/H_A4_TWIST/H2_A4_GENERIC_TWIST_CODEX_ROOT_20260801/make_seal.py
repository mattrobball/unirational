#!/usr/bin/env python3
"""Create the deterministic H2 content manifest."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROJECT = next(
    parent for parent in HERE.parents
    if (parent / "certificates" / "exact_weil_check.py").is_file()
    and (parent / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json").is_file()
)
FILES = [
    "ACCEPTANCE_AUDIT.md",
    "BUG_AUDIT.md",
    "COMPLETION_AUDIT.md",
    "FIELD_MODEL.md",
    "FIBRATION_OR_VALUATION.md",
    "POINT_CERTIFICATE.json",
    "POINT_CERTIFICATE.md",
    "README.md",
    "REPLAY.md",
    "SOURCES.md",
    "STATUS.md",
    "TWIST_MODEL.md",
    "WORK_SCOPE.md",
    "audit_upstream_transpose.py",
    "canonical_model.json",
    "canonical_model.py",
    "degree3_character1_exact_chart0.sing",
    "degree3_character1_exact_chart0.txt",
    "exact_degree3_map.json",
    "exact_degree3_map.py",
    "make_seal.py",
    "reduce_twist_uv.py",
    "source_intertwiner.json",
    "source_intertwiner.py",
    "transpose_audit.json",
    "transpose_audit.py",
    "twist_over_Cuv.json",
    "upstream_transpose_audit.json",
    "upstream_transpose_audit.log",
    "verification.log",
    "verify.py",
    "verify_exact_point.py",
    "verify_seal.py",
]

INPUTS = {
    "GOAL_H2_A4_GENERIC_TWIST.md": PROJECT / "goals_after_35fa8f" / "GOAL_H2_A4_GENERIC_TWIST.md",
    "H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json": PROJECT / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json",
    "H_SUBGROUP_TWISTS_ROOT_019FBE10/produce.py": PROJECT / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "produce.py",
    "H_SUBGROUP_TWISTS_ROOT_019FBE10/a4_direct_search.py": PROJECT / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "a4_direct_search.py",
    "certificates/exact_weil_check.py": PROJECT / "certificates" / "exact_weil_check.py",
}


def main():
    records = {}
    for relative in FILES:
        path = HERE / relative
        assert path.is_file(), relative
        data = path.read_bytes()
        records[relative] = {
            "bytes": len(data),
            "sha256": hashlib.sha256(data).hexdigest(),
        }
    payload = {
        "format": "H2-A4-GENERIC-TWIST-SEAL-v1",
        "decision": ["H-A4-RATIONAL-POINT", "H-A4-STRUCTURAL-MODEL-PASS"],
        "pinned_state": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "installed_input": "H_SUBGROUP_TWISTS_ROOT_019FBE10/twists.json:A4",
        "scope_warning": "closes the A4 subgroup obstruction only; no full PSL_2(F_11) conclusion",
        "files": records,
        "inputs": {
            name: {
                "bytes": path.stat().st_size,
                "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            }
            for name, path in INPUTS.items()
        },
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"SEALED {len(records)} files")
    print("H2_A4_SEAL_CREATED")


if __name__ == "__main__":
    main()
