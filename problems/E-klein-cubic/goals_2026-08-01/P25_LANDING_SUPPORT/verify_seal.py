#!/usr/bin/env python3
"""Verify every non-circular file digest in SEAL.json."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    if seal.get("exit") != "P25-DEGREE25-EMPTY":
        raise SystemExit("wrong sealed exit")
    for name, record in seal["files"].items():
        path = HERE / name
        if not path.is_file():
            raise SystemExit(f"missing sealed file {name}")
        if path.stat().st_size != int(record["bytes"]):
            raise SystemExit(f"size mismatch {name}")
        if sha256(path) != record["sha256"]:
            raise SystemExit(f"hash mismatch {name}")
    print(f"SEAL PASS: {len(seal['files'])} files")


if __name__ == "__main__":
    main()
