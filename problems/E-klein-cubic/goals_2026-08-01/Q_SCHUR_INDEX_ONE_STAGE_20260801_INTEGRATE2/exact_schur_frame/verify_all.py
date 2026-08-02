#!/usr/bin/env python3
"""Verify the recursive seal and replay the independent exact proof."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    seal = json.loads((HERE / "SEAL.json").read_text())
    actual = {
        str(path.relative_to(HERE)): digest(path)
        for path in sorted(HERE.rglob("*"))
        if path.is_file() and path.name != "SEAL.json"
    }
    assert actual == seal["files"]
    assert seal["governing_status"] == "Q-UNDECIDED"
    print(f"PASS recursive packet seal files={len(actual)}")
    subprocess.run(
        [sys.executable, str(HERE / "verify_exact_frame.py")],
        cwd=HERE,
        check=True,
    )
    print("Q_SCHUR_EXACT_FRAME_PACKET_VERIFY_ALL_OK")


if __name__ == "__main__":
    main()
