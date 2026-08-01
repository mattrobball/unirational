#!/usr/bin/env python3
"""Hash every durable Goal-H4 artifact except the seal itself."""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def main() -> None:
    field = json.loads((HERE / "field_model.json").read_text())
    decision = json.loads((HERE / "decision.json").read_text())
    files = {
        path.relative_to(HERE).as_posix(): digest(path)
        for path in HERE.rglob("*")
        if path.is_file()
        and path.name != "SEAL.json"
        and path.suffix != ".pyc"
        and "__pycache__" not in path.parts
        and path.name != ".DS_Store"
    }
    seal = {
        "format": "H-11_5-GENERIC-TWIST-SEAL-v1",
        "exit": decision["exit"],
        "headline": decision["headline"],
        "pinned_state": decision["pinned_state"],
        "repository_commit_consumed": decision["repository_commit_consumed"],
        "produced_commit": None,
        "hash_algorithm": "sha256",
        "authoritative_inputs": field["authoritative_input_hashes"],
        "scope": "Exact invariant-field, Kummer/cyclic tower, and norm-trace model for the canonical generic 11:5 twist; no K-point or pointlessness theorem.",
        "proved": decision["proved"],
        "not_proved": decision["not_proved"],
        "replay": ["produce.py", "seal.py", "verify.py"],
        "terminal_markers": [
            "H_11_5_PRODUCE_OK",
            "H_11_5_SEAL_OK",
            "H_11_5_INDEPENDENT_VERIFY_OK",
        ],
        "files": dict(sorted(files.items())),
        "self_hash_excluded": True,
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print("H_11_5_SEAL_OK")


if __name__ == "__main__":
    main()
