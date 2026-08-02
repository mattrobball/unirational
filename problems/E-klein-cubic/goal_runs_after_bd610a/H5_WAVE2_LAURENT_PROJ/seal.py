#!/usr/bin/env python3
"""Write SEAL.json for H5 WAVE2 durable files."""

from __future__ import annotations

from hashlib import sha256
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def main() -> None:
    durable = {
        path.relative_to(HERE).as_posix(): digest(path)
        for path in sorted(HERE.rglob("*"))
        if path.is_file()
        and path.name != "SEAL.json"
        and path.suffix != ".pyc"
        and "__pycache__" not in path.parts
        and path.name != ".DS_Store"
    }
    decision = json.loads((HERE / "decision.json").read_text())
    seal = {
        "format": "H5-WAVE2-SEAL-v1",
        "exit": decision["exit"],
        "headline": decision["headline"],
        "pinned_state": decision["pinned_state"],
        "files": durable,
        "file_count": len(durable),
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print("H5_WAVE2_SEAL_OK", len(durable), "files")


if __name__ == "__main__":
    main()
