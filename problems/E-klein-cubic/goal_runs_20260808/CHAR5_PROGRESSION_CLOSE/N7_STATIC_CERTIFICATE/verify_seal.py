#!/usr/bin/env python3
"""Check every path and SHA-256 digest named by SEAL.json."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    seal = json.loads(SEAL.read_text())
    assert seal["schema"] == "char5-progression-n7-static-seal-v1"
    for relative, wanted in seal["files"].items():
        path = HERE / relative
        assert path.is_file(), f"missing sealed file: {relative}"
        actual = digest(path)
        assert actual == wanted, f"hash mismatch: {relative}: {actual}"
    for relative, wanted in seal["upstream_files"].items():
        path = (HERE / relative).resolve()
        assert path.is_file(), f"missing upstream file: {relative}"
        actual = digest(path)
        assert actual == wanted, f"upstream hash mismatch: {relative}: {actual}"
    print("N7-STATIC-CERTIFICATE-SEAL-OK")


if __name__ == "__main__":
    main()

