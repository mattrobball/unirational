#!/usr/bin/env python3
"""Verify every file named by SEAL.json."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    if seal["status"] != "SEALED_ENLARGED_CLOSURE_PACKET":
        raise AssertionError("seal status mismatch")
    for name, expected in seal["files"].items():
        path = HERE / name
        if path.stat().st_size != expected["bytes"]:
            raise AssertionError(f"size mismatch: {name}")
        if sha256(path) != expected["sha256"]:
            raise AssertionError(f"digest mismatch: {name}")
    print(f"PASS: verified {len(seal['files'])} enlarged-closure packet files")


if __name__ == "__main__":
    main()
