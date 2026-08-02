#!/usr/bin/env python3
"""Verify the prepared-not-run seal without invoking a CAS."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    if seal["status"] != "SEALED_R66_SINGULAR_PREPARED_NOT_RUN" or seal["cas_launched"] is not False:
        raise AssertionError("seal status mismatch")
    for entry in seal["files"]:
        path = HERE / entry["path"]
        if not path.is_file() or path.stat().st_size != entry["bytes"] or sha256(path) != entry["sha256"]:
            raise AssertionError(f"sealed artifact mismatch: {path}")
    if list(HERE.glob("*.run.json")) or list(HERE.glob("*.log")) or list(HERE.glob("*.result.txt")):
        raise AssertionError("unexpected CAS run artifacts")
    print("PASS_R66_SINGULAR_PREPARED_NOT_RUN_SEAL")


if __name__ == "__main__":
    main()

