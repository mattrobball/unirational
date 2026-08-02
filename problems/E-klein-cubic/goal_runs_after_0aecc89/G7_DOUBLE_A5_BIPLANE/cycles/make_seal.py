#!/usr/bin/env python3
"""Write SEAL.json and SHA256SUMS for the G7B cycles packet."""
from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]

FILES = [
    "INPUT_MANIFEST.json",
    "scaling_interface.json",
    "cycles.json",
    "incidence_correspondence.json",
    "PROJECTIVE_SCALING.md",
    "CYCLES.md",
    "INCIDENCE_CORRESPONDENCE.md",
    "produce.py",
    "produce_meta.json",
    "verify_scaling.py",
    "verify_cycles.py",
    "REPLAY.md",
    "STATUS.md",
    "make_seal.py",
]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> None:
    try:
        commit = subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
        ).strip()
    except Exception:
        commit = "unknown"

    files = {}
    sums_lines = []
    for name in FILES:
        p = HERE / name
        if not p.is_file():
            raise SystemExit(f"missing {name}")
        dig = sha256(p)
        files[name] = dig
        sums_lines.append(f"{dig}  {name}")

    seal = {
        "format": "g7b-double-a5-cycles-seal-v1",
        "exit": "G7-INDUCED-DOUBLE-CYCLE-PASS",
        "also": ["G7-PROJECTIVE-SCALING-PASS"],
        "headline": "OPEN",
        "stages": ["G7.2", "G7.3"],
        "consumed_commit": commit,
        "n_points_explicit": 22,
        "G3_frame_coordinates": True,
        "both_classes": True,
        "files": files,
        "nonclaims": [
            "no K_proj-point of X_gen",
            "no G7C geometry (G7.4+)",
            "does not reseal H_A5, G4, G7A, G3A",
            "split-model coordinates over Q(zeta_11); abstract point over L_H",
        ],
        "residual_gates": [
            "G7C cross-ops / third intersections / residual geometry",
            "Springer path may still need non-split L_H-valued cocycle lifts",
        ],
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")
    seal_dig = sha256(HERE / "SEAL.json")
    sums_lines.append(f"{seal_dig}  SEAL.json")
    (HERE / "SHA256SUMS").write_text("\n".join(sums_lines) + "\n")
    print("G7B_SEAL_OK")
    print(seal["exit"])


if __name__ == "__main__":
    main()
