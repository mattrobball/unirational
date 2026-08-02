#!/usr/bin/env python3
"""Seal the small structural-route packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = [
    "WORK_SCOPE.md",
    "REPORT.md",
    "produce_mds_cover.py",
    "verify_mds_cover.py",
    "audit_structure.py",
    "stageB_H8_mds_cover.npz",
    "stageB_H8_mds_cover.json",
    "verify_mds_cover_result.json",
    "structural_audit.json",
    "make_seal.py",
    "verify_seal.py",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    entries = []
    for name in FILES:
        path = HERE / name
        if not path.is_file():
            raise FileNotFoundError(path)
        entries.append({"file": name, "bytes": path.stat().st_size, "sha256": sha256(path)})
    payload = {
        "status": "SEALED_STRUCTURAL_ROUTE_EXACT_COVER_REDUCTION_NONVERDICT",
        "files": entries,
        "binding_source_sha256": "6aeeeb0b1bdc81dafec9872f7543468f426336ccc3ed11087bfa56e9dddaa4fb",
        "stageB_H8_mds_charts": 34,
        "stageB_decided": False,
        "stageC_decided": False,
        "p25_decided": False,
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()

