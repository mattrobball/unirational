#!/usr/bin/env python3
"""Write SEAL.json and SHA256SUMS for the G7C geometry packet."""
from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]

FILES = [
    "INPUT_MANIFEST.json",
    "operations.json",
    "residual_cycles.json",
    "effective_cycles.json",
    "CROSS_OPERATIONS.md",
    "THIRD_INTERSECTIONS.md",
    "EFFECTIVE_CYCLES.md",
    "produce_geometry.py",
    "produce_meta.json",
    "verify_geometry.py",
    "verify_point.py",
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

    status = (HERE / "STATUS.md").read_text().splitlines()[0].strip()
    meta = json.loads((HERE / "produce_meta.json").read_text())

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
        "format": "g7c-double-a5-geometry-seal-v1",
        "exit": status,
        "headline": "OPEN",
        "stages": ["G7.4", "G7.5", "G7.6"],
        "consumed_commit": commit,
        "n_operations": meta.get("n_operations"),
        "n_third_pairs": 121,
        "n_lines_on_split_cubic": meta.get("n_lines_on_split_cubic"),
        "n_rational_residuals_Q": meta.get("n_rational_residuals_Q"),
        "peak_rss_mb": meta.get("peak_rss_mb"),
        "wall_s": meta.get("wall_s"),
        "files": files,
        "nonclaims": [
            "no K_proj-point of X_gen",
            "no effective length-two over K_proj",
            "no BRIDGE_DOUBLE_A5_POS",
            "not G7-POINT-HEADLINE-POSITIVE",
            "not G7-EFFECTIVE-DEGREE2-HEADLINE-POSITIVE",
            "does not reseal G7A/G7B/G3A/H_A5/G4",
            "split-model lines on V(F) are not K_proj-lines on X_gen",
            "CH_0 / signed deg-1 is not effective deg-2",
        ],
        "residual_gates": [
            "K_proj-point of X_gen from outside this finite op space",
            "equivariant descent of split-model lines to X_gen",
            "Springer / non-split L_H cocycle lifts",
        ],
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")
    seal_dig = sha256(HERE / "SEAL.json")
    sums_lines.append(f"{seal_dig}  SEAL.json")
    (HERE / "SHA256SUMS").write_text("\n".join(sums_lines) + "\n")
    print("G7C_SEAL_OK")
    print(status)


if __name__ == "__main__":
    main()
