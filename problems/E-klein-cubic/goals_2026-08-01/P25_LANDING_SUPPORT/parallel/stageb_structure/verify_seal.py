#!/usr/bin/env python3
"""Verify every file bound by the local structural packet seal."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            h.update(chunk)
    return h.hexdigest()


def main() -> None:
    payload = json.loads((HERE / "SEAL.json").read_text())
    for name, expected in payload["files"].items():
        path = HERE / name
        if not path.is_file():
            raise SystemExit(f"FAIL: missing {name}")
        if path.stat().st_size != expected["bytes"]:
            raise SystemExit(f"FAIL: byte count {name}")
        if sha256(path) != expected["sha256"]:
            raise SystemExit(f"FAIL: hash {name}")
    print(f"SEAL PASS: {len(payload['files'])} files")


if __name__ == "__main__":
    main()
