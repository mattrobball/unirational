#!/usr/bin/env python3
"""Verify every file record in SEAL.json."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 22):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> int:
    payload = json.loads((HERE / "SEAL.json").read_text())
    for record in payload["files"]:
        path = HERE / record["path"]
        if not path.is_file():
            raise AssertionError(f"missing sealed file: {record['path']}")
        if path.stat().st_size != record["bytes"]:
            raise AssertionError(f"sealed size mismatch: {record['path']}")
        if sha256_file(path) != record["sha256"]:
            raise AssertionError(f"sealed hash mismatch: {record['path']}")
    print(f"PASS_VERIFY_SEAL files={len(payload['files'])}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
