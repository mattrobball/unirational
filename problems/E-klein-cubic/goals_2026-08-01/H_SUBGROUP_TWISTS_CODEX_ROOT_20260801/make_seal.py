#!/usr/bin/env python3
"""Write deterministic hashes for the subgroup-twist packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def main():
    files = {}
    for path in sorted(HERE.rglob("*")):
        if not path.is_file() or path.name == "SEAL.json" or "__pycache__" in path.parts:
            continue
        files[str(path.relative_to(HERE))] = hashlib.sha256(path.read_bytes()).hexdigest()
    seal = {
        "format": "klein-h-subgroup-twists-seal-v1",
        "exit": "H-SWEEP-UNDECIDED",
        "pinned_baseline": "715faf441289e2589b9325311b6613ea0331bf88",
        "worker_start_commit": "2140419",
        "live_commit_final_audit": "53e267a",
        "produced_commit": None,
        "files": files,
        "self_hash_excluded": True,
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print(f"sealed {len(files)} files")
    print("H_SUBGROUP_TWISTS_SEAL_OK")


if __name__ == "__main__":
    main()
