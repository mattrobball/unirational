#!/usr/bin/env python3
"""Record immutable hashes of the governing and imported parent sources."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
GOALS = HERE.parent
PROBLEM = HERE.parents[1]
SOURCES = (
    GOALS / "GOAL_Q_SCHUR_INDEX_ONE_DESCENT.md",
    PROBLEM / "tmp" / "schur_ternary_planes" / "core.py",
    PROBLEM / "tmp" / "schur_unrestricted_point_attack_audit" / "verify.py",
    PROBLEM / "tmp" / "schur_structural_routes" / "verify.py",
    PROBLEM / "tmp" / "schur_fibration_picard_obstruction" / "verify.py",
    PROBLEM / "certificates" / "subgroup_orbit_check.py",
)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


repository = subprocess.run(
    ["git", "rev-parse", "--show-toplevel"],
    cwd=HERE,
    text=True,
    stdout=subprocess.PIPE,
    check=True,
).stdout.strip()
head = subprocess.run(
    ["git", "rev-parse", "HEAD"],
    cwd=HERE,
    text=True,
    stdout=subprocess.PIPE,
    check=True,
).stdout.strip()
root = Path(repository)
payload = {
    "format": "Q-SCHUR-SOURCE-MANIFEST-v1",
    "isolation_waypoint": "80f24697dd8fcb1ee0e8fff86e3d8e38a9cfc09c",
    "live_head_at_manifest": head,
    "sources": {
        str(path.relative_to(root)): digest(path)
        for path in SOURCES
    },
}
(HERE / "SOURCE_MANIFEST.json").write_text(json.dumps(payload, indent=2) + "\n")
print(json.dumps(payload, indent=2))
