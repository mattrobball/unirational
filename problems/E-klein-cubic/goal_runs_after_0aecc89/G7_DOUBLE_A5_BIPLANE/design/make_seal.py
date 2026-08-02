#!/usr/bin/env python3
"""Write SEAL.json and SHA256SUMS for the G7A design packet."""
from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]  # .../E-klein-cubic

FILES = [
    "INPUT_MANIFEST.json",
    "design.json",
    "incidence_N.json",
    "cross_intersections.json",
    "projectors.json",
    "DESIGN.md",
    "PERMUTATION_PROJECTORS.md",
    "produce.py",
    "produce_meta.json",
    "verify_design.py",
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
        "format": "g7a-double-a5-biplane-design-seal-v1",
        "exit": "G7-CROSS-CLASS-PROJECTOR-PASS",
        "also": ["G7-PALEY-BIPLANE-IDENTIFIED"],
        "module_correction": "Ind_H^G 1 = 1+10 (not 1+5+5 / not 1+W+W')",
        "headline": "OPEN",
        "stages": ["G7.0", "G7.1"],
        "consumed_commit": commit,
        "files": files,
        "nonclaims": [
            "no G7B induced point coordinates",
            "no G7C geometry",
            "no K_proj-point of X_gen",
            "does not reseal H_A5 or G4",
            "Klein/companion 5s of G are not summands of Ind",
        ],
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")
    # include SEAL in SUMS after writing
    seal_dig = sha256(HERE / "SEAL.json")
    sums_lines.append(f"{seal_dig}  SEAL.json")
    (HERE / "SHA256SUMS").write_text("\n".join(sums_lines) + "\n")
    print("G7A_SEAL_OK")
    print(seal["exit"])


if __name__ == "__main__":
    main()
