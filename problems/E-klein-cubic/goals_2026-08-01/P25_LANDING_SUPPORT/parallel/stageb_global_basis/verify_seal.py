#!/usr/bin/env python3
"""Verify every file hash recorded in SEAL.json."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    payload = json.loads(SEAL.read_text())
    if payload.get("status") != "SEALED_STAGEB_GLOBAL_BASIS_PACKET":
        raise AssertionError("seal status mismatch")
    for entry in payload["files"]:
        path = HERE / entry["path"]
        if not path.is_file():
            raise FileNotFoundError(path)
        if path.stat().st_size != entry["bytes"]:
            raise AssertionError(f"size mismatch: {path.name}")
        if sha256(path) != entry["sha256"]:
            raise AssertionError(f"hash mismatch: {path.name}")
    if len(payload["files"]) != payload["file_count"]:
        raise AssertionError("seal count mismatch")
    local_checked = 0
    for entry in payload.get("local_rebuildable_artifacts", []):
        path = HERE / entry["path"]
        if not path.exists():
            continue
        if path.stat().st_size != entry["bytes"] or sha256(path) != entry["sha256"]:
            raise AssertionError(f"local artifact mismatch: {path.name}")
        local_checked += 1
    print(
        f"PASS: verified {payload['file_count']} portable files and "
        f"{local_checked} present local artifacts"
    )


if __name__ == "__main__":
    main()
