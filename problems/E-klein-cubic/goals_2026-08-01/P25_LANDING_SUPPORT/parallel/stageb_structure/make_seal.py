#!/usr/bin/env python3
"""Hash the complete structural packet, excluding only SEAL.json itself."""

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
    files = [
        path
        for path in sorted(HERE.iterdir())
        if path.is_file() and path.name != "SEAL.json"
    ]
    payload = {
        "scope": "exact Stage-B structural audit; no global emptiness verdict",
        "files": {
            path.name: {"bytes": path.stat().st_size, "sha256": sha256(path)}
            for path in files
        },
    }
    (HERE / "SEAL.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(f"wrote SEAL.json for {len(files)} files")


if __name__ == "__main__":
    main()
