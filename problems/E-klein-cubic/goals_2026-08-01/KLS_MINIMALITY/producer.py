#!/usr/bin/env python3
"""Build deterministic source and artifact manifests for the KLS route exit."""

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
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def relative_source(path: Path) -> str:
    return str(path.relative_to(PROBLEM))


def write_json(path: Path, value: object) -> None:
    path.write_text(json.dumps(value, indent=2, sort_keys=True) + "\n")


def main() -> None:
    missing = [str(path) for path in SOURCE_PATHS if not path.is_file()]
    if missing:
        raise SystemExit(f"missing consumed sources: {missing}")

    commit = subprocess.run(
        ["git", "rev-parse", "HEAD"],
        cwd=PROBLEM,
        check=True,
        text=True,
        capture_output=True,
    ).stdout.strip()

    source_manifest = {
        "schema": "kls-source-manifest-v1",
        "as_of": "2026-08-01",
        "pinned_mathematical_baseline": "715faf441289e2589b9325311b6613ea0331bf88",
        "consumed_live_commit": commit,
        "sources": {
            relative_source(path): sha256(path) for path in SOURCE_PATHS
        },
    }
    write_json(HERE / "SOURCE_MANIFEST.json", source_manifest)

    artifacts = {}
    for path in sorted(HERE.rglob("*")):
        if not path.is_file() or path.name == "SEAL.json":
            continue
        if "__pycache__" in path.parts:
            continue
        artifacts[str(path.relative_to(HERE))] = sha256(path)

    seal = {
        "schema": "kls-seal-v1",
        "as_of": "2026-08-01",
        "exit": "KLS-NO-THEOREM",
        "artifacts": artifacts,
        "self_hash_included": False,
    }
    write_json(HERE / "SEAL.json", seal)
    print(f"WROTE SOURCE_MANIFEST.json sources={len(SOURCE_PATHS)}")
    print(f"WROTE SEAL.json artifacts={len(artifacts)}")


if __name__ == "__main__":
    main()
