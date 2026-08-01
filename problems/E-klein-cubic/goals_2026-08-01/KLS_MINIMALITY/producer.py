#!/usr/bin/env python3
"""Produce deterministic source and artifact manifests for this goal run."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
GOALS = HERE.parent
PROBLEM = GOALS.parent

SOURCE_PATHS = [
    GOALS / "GOAL_KLS_MINIMALITY_CONDUCTOR.md",
    PROBLEM / "SPEC.md",
    PROBLEM / "REPAIR.md",
    PROBLEM / "CURRENT_PATHS.md",
    PROBLEM / "tmp/kls_structural_successor/REPORT.md",
    PROBLEM / "tmp/kls_global_foliation_theorem/REPORT.md",
    PROBLEM / "tmp/kls_minimal_contraction_attack/REPORT.md",
    PROBLEM / "tmp/kls_actual_conductor_geometry/REPORT.md",
    PROBLEM / "tmp/kls_actual_conductor_geometry_audit/REPORT.md",
    PROBLEM / "tmp/kls_proper_multiple_structure/REPORT.md",
    PROBLEM / "tmp/kls_proper_multiple_structure_audit/REPORT.md",
    PROBLEM / "tmp/kls_discrepancy_next_gate/REPORT.md",
    PROBLEM / "tmp/kls_discrepancy_next_gate_audit/REPORT.md",
    PROBLEM / "tmp/kls_a5_linearized_pencil_obstruction/REPORT.md",
    PROBLEM / "tmp/kls_a5_conductor_surface_feasibility/REPORT.md",
    PROBLEM / "tmp/kls_a5_logarithmic_divisor/REPORT.md",
]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def rel(path: Path) -> str:
    return str(path.relative_to(PROBLEM))


def git_head() -> str:
    return subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=PROBLEM, text=True
    ).strip()


def main() -> None:
    missing = [str(path) for path in SOURCE_PATHS if not path.is_file()]
    if missing:
        raise SystemExit(f"missing sources: {missing}")

    source_manifest = {
        "schema": "kls-source-manifest-v1",
        "as_of": "2026-08-01",
        "pinned_mathematical_baseline": "715faf441289e2589b9325311b6613ea0331bf88",
        "live_commit": git_head(),
        "sources": [
            {"path": rel(path), "sha256": sha256(path)} for path in SOURCE_PATHS
        ],
    }
    (HERE / "SOURCE_MANIFEST.json").write_text(
        json.dumps(source_manifest, indent=2, sort_keys=True) + "\n"
    )

    artifacts = []
    for path in sorted(HERE.rglob("*"), key=lambda item: str(item.relative_to(HERE))):
        if not path.is_file() or path == HERE / "SEAL.json" or "__pycache__" in path.parts:
            continue
        artifact_path = str(path.relative_to(HERE))
        artifacts.append(
            {"path": artifact_path, "sha256": sha256(path), "bytes": path.stat().st_size}
        )
    seal = {
        "schema": "kls-goal-seal-v1",
        "exit": "KLS-NO-THEOREM",
        "headline": "OPEN",
        "artifacts": artifacts,
        "self_hash_included": False,
    }
    (HERE / "SEAL.json").write_text(
        json.dumps(seal, indent=2, sort_keys=True) + "\n"
    )
    print(f"WROTE SOURCE_MANIFEST.json sources={len(SOURCE_PATHS)}")
    print(f"WROTE SEAL.json artifacts={len(artifacts)}")


if __name__ == "__main__":
    main()
