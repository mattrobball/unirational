#!/usr/bin/env python3
"""Write SEAL.json with SHA-256 of G5 packet artifacts."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]

FILES = [
    "INPUT_MANIFEST.json",
    "VALUATION_MODELS.md",
    "valuation_models.json",
    "f5/residue_cubic.json",
    "f6/residue_cubic.json",
    "SMOOTHNESS.md",
    "POINT_SEARCH.md",
    "point_search.json",
    "produce_residues.py",
    "produce_meta.json",
    "verify_models.py",
    "verify_decision.py",
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
    commit = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
    ).strip()
    files = {}
    for name in FILES:
        p = HERE / name
        if not p.is_file():
            raise SystemExit(f"missing {name}")
        files[name] = sha256(p)
    meta = json.loads((HERE / "produce_meta.json").read_text())
    seal = {
        "format": "g5-full-residue-cubics-seal-v1",
        "exit": "G5-F5-CUBIC-MODEL-PASS",
        "also_exits": [
            "G5-F6-CUBIC-MODEL-PASS",
            "G5-RESIDUE-TORSOR-MODEL-PASS",
        ],
        "headline": "OPEN",
        "stages": ["G5.0", "G5.1", "G5.2"],
        "point_decision": "UNDECIDED",
        "consumed_commit": commit,
        "peak_rss_mb_approx": meta.get("peak_rss_mb_approx"),
        "wall_seconds": meta.get("wall_seconds"),
        "files": files,
        "nonclaims": [
            "no G5-F5/F6-POINTLESS-HEADLINE-NEGATIVE",
            "no G5-F5/F6-RESIDUE-POINT",
            "no BRIDGE_RESIDUE_NEG",
            "no promotion of modular specialization points to kappa-points",
            "f5 support-le5 emptiness not used as full residue pointlessness",
            "index one does not supply a residue point",
            "Problem E remains OPEN",
        ],
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")
    print("G5_SEAL_OK")
    print(seal["exit"])


if __name__ == "__main__":
    main()
