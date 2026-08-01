#!/usr/bin/env python3
"""Produce deterministic source and artifact manifests for KLS2."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]

SOURCE_PATHS = [
    PROBLEM / "goals_after_35fa8f/GOAL_KLS2_MINIMALITY_TO_DISCREPANCY.md",
    PROBLEM / "goals_after_35fa8f/IMPLEMENTATION_AUDIT.md",
    PROBLEM / "SPEC.md",
    PROBLEM / "RESOLUTION.md",
    PROBLEM / "goals_2026-08-01/KLS_MINIMALITY/STATUS.md",
    PROBLEM / "goals_2026-08-01/KLS_MINIMALITY/MINIMALITY_THEOREM.md",
    PROBLEM / "goals_2026-08-01/KLS_MINIMALITY/INTERFACE_AUDIT.md",
    PROBLEM / "tmp/kls_structural_successor/REPORT.md",
    PROBLEM / "tmp/kls_global_foliation_theorem/REPORT.md",
    PROBLEM / "tmp/kls_minimal_contraction_attack/REPORT.md",
    PROBLEM / "tmp/kls_actual_conductor_geometry/REPORT.md",
    PROBLEM / "tmp/kls_actual_conductor_geometry_audit/REPORT.md",
    PROBLEM / "tmp/kls_proper_multiple_structure/REPORT.md",
    PROBLEM / "tmp/kls_proper_multiple_structure_audit/REPORT.md",
    PROBLEM / "tmp/kls_discrepancy_next_gate/REPORT.md",
    PROBLEM / "tmp/kls_discrepancy_next_gate_audit/REPORT.md",
    PROBLEM / "tmp/kls_a5_logarithmic_divisor/REPORT.md",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def git_head() -> str:
    return subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=PROBLEM, text=True
    ).strip()


def main() -> None:
    missing = [str(path) for path in SOURCE_PATHS if not path.is_file()]
    if missing:
        raise SystemExit(f"missing sources: {missing}")

    manifest = {
        "schema": "kls2-source-manifest-v1",
        "as_of": "2026-08-01",
        "pinned_state": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "live_commit": git_head(),
        "sources": [
            {
                "path": str(path.relative_to(PROBLEM)),
                "sha256": sha256(path),
                "bytes": path.stat().st_size,
            }
            for path in SOURCE_PATHS
        ],
    }
    (HERE / "SOURCE_MANIFEST.json").write_text(
        json.dumps(manifest, indent=2, sort_keys=True) + "\n"
    )

    artifacts = []
    for path in sorted(HERE.rglob("*"), key=lambda item: str(item.relative_to(HERE))):
        if not path.is_file() or path == HERE / "SEAL.json" or "__pycache__" in path.parts:
            continue
        artifacts.append(
            {
                "path": str(path.relative_to(HERE)),
                "sha256": sha256(path),
                "bytes": path.stat().st_size,
            }
        )
    seal = {
        "schema": "kls2-seal-v1",
        "exit": "KLS2-NO-FINITE-REDUCTION",
        "headline": "OPEN",
        "self_hash_included": False,
        "artifacts": artifacts,
    }
    (HERE / "SEAL.json").write_text(
        json.dumps(seal, indent=2, sort_keys=True) + "\n"
    )
    print(f"WROTE SOURCE_MANIFEST.json sources={len(SOURCE_PATHS)}")
    print(f"WROTE SEAL.json artifacts={len(artifacts)}")


if __name__ == "__main__":
    main()

