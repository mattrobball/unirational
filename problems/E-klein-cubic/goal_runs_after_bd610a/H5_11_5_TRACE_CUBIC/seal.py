#!/usr/bin/env python3
"""Write SEAL.json for the H5 packet (hashes all durable files except SEAL)."""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def main() -> None:
    files = {}
    for path in sorted(HERE.rglob("*")):
        if not path.is_file():
            continue
        if path.name == "SEAL.json":
            continue
        if path.suffix == ".pyc" or "__pycache__" in path.parts:
            continue
        if path.name == ".DS_Store":
            continue
        rel = path.relative_to(HERE).as_posix()
        files[rel] = digest(path)

    decision = json.loads((HERE / "decision.json").read_text())
    seal = {
        "format": "H5-11_5-TRACE-CUBIC-SEAL-v1",
        "exit": decision["exit"],
        "headline": decision["headline"],
        "hash_algorithm": "sha256",
        "self_hash_excluded": True,
        "pinned_state": decision["pinned_state"],
        "h4_exit_consumed": decision["h4_exit_consumed"],
        "files": files,
        "terminal_markers": [
            "H5_PRODUCE_OK",
            "H5_SEAL_OK",
            "H5_INDEPENDENT_VERIFY_OK",
        ],
        "not_proved": decision["not_proved"],
        "smallest_remaining_theorem": decision["smallest_remaining_theorem"],
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print("H5_SEAL_OK")
    print("files_sealed=", len(files))


if __name__ == "__main__":
    main()
