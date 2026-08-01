#!/usr/bin/env python3
"""Seal every durable artifact in this isolated attack packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def artifact_paths():
    return tuple(
        sorted(
            path
            for path in HERE.rglob("*")
            if path.is_file()
            and path != SEAL
            and "__pycache__" not in path.parts
            and path.suffix != ".pyc"
        )
    )


def main():
    paths = artifact_paths()
    files = {
        str(path.relative_to(HERE)): {
            "sha256": sha256(path),
            "bytes": path.stat().st_size,
        }
        for path in paths
    }
    payload = {
        "schema": "G_TERNARY_KPROJ_V2_SEAL_V1",
        "artifact_count": len(files),
        "pencil_inputs": sum(name.startswith("systems/") and name.endswith(".in") for name in files),
        "pencil_leading_outputs": sum(
            name.startswith("systems/") and name.endswith(".leading.out") for name in files
        ),
        "plane_inputs": sum(
            name.startswith("plane_systems/") and name.endswith(".in") for name in files
        ),
        "plane_leading_outputs": sum(
            name.startswith("plane_systems/") and name.endswith(".leading.out") for name in files
        ),
        "files": files,
    }
    SEAL.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(
        "G_TERNARY_KPROJ_V2_SEALED",
        f"artifacts={len(files)} pencils={payload['pencil_inputs']} planes={payload['plane_inputs']}",
    )


if __name__ == "__main__":
    main()
