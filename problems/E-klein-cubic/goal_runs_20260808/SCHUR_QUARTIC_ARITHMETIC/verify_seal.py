#!/usr/bin/env python3
"""Verify the immutable packet manifest and its two upstream inputs."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["schema"] == "schur-quartic-arithmetic-seal-v1"
    assert seal["headline"] == "OPEN"
    assert seal["conclusion"] == "EXACT-CIRCULARITY"

    actual_files = {
        path.relative_to(HERE).as_posix(): sha256(path)
        for path in HERE.iterdir()
        if path.is_file() and path.name != "SEAL.json"
    }
    assert actual_files == seal["files"]

    upstream = {
        "tmp/pfaffian_representation_alignment/core.py":
            ROOT / "tmp/pfaffian_representation_alignment/core.py",
        "tmp/pfaffian_representation_alignment/certificate.json":
            ROOT / "tmp/pfaffian_representation_alignment/certificate.json",
    }
    assert {
        relative: sha256(path) for relative, path in upstream.items()
    } == seal["upstream_files"]
    print("SCHUR-QUARTIC-ARITHMETIC-SEAL-OK")


if __name__ == "__main__":
    main()
