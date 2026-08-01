#!/usr/bin/env python3
"""Create the timing-independent content seal for this isolated packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def main():
    files = sorted(
        path.relative_to(HERE).as_posix()
        for path in HERE.rglob("*")
        if path.is_file()
        and path.name != "SEAL.json"
        and "__pycache__" not in path.parts
    )
    payload = {
        "format": "H-SUBGROUP-TWISTS-SEAL-v1",
        "exit": "H-SWEEP-UNDECIDED",
        "files": {name: hashlib.sha256((HERE / name).read_bytes()).hexdigest() for name in files},
        "replay": ["produce.py", "a4_direct_search.py", "seal.py", "verify.py"],
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"sealed_files={len(files)}")
    print("H_SUBGROUP_TWISTS_SEAL_OK")


if __name__ == "__main__": main()
