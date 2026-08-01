#!/usr/bin/env python3
"""Hash every regular file in the isolated packet except the seal itself."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


files = {
    path.name: digest(path)
    for path in sorted(HERE.iterdir())
    if path.is_file() and path.name != "SEAL.json"
}
payload = {
    "format": "Q-SCHUR-ISOLATED-SEAL-v1",
    "status": "Q-UNDECIDED",
    "files": files,
}
(HERE / "SEAL.json").write_text(json.dumps(payload, indent=2) + "\n")
print(f"sealedFiles={len(files)}")
