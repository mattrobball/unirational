#!/usr/bin/env python3
"""Regenerate the packet's recursive SHA-256 seal."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def main():
    files = {
        str(path.relative_to(HERE)): hashlib.sha256(path.read_bytes()).hexdigest()
        for path in sorted(HERE.rglob("*"))
        if path.is_file() and path.name != "SEAL.json"
    }
    payload = {
        "schema": "klein-q-schur-exact-frame-seal-v1",
        "governing_status": "Q-UNDECIDED",
        "bounded_theorem": (
            "exact characteristic-zero Hilbert--90 frame and full "
            "35-coefficient model of the genuine Schur twist"
        ),
        "strict_scope": (
            "No K_Schur-point and no pointlessness obstruction is proved."
        ),
        "files": files,
    }
    (HERE / "SEAL.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(f"WROTE SEAL.json files={len(files)}")


if __name__ == "__main__":
    main()
