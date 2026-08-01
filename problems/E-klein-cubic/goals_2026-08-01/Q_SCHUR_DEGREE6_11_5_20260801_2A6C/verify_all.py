#!/usr/bin/env python3
"""Verify the seal and the independent degree-six replay."""

from __future__ import annotations

import hashlib
import json
import os
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["schema"] == "klein-q-schur-degree6-f55-seal-v1"
    assert seal["governing_status"] == "Q-UNDECIDED"
    assert "No all-degree exclusion" in seal["strict_scope"]
    actual = {
        path.name for path in HERE.iterdir() if path.is_file() and path.name != "SEAL.json"
    }
    assert actual == set(seal["files"])
    for name, expected in seal["files"].items():
        assert sha256(HERE / name) == expected
    environment = dict(os.environ)
    environment["PYTHONDONTWRITEBYTECODE"] = "1"
    completed = subprocess.run(
        ["/opt/homebrew/bin/python3", "-u", "verify_degree6_all.py"],
        cwd=HERE,
        env=environment,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    print(completed.stdout, end="")
    assert completed.returncode == 0
    assert "Q_F55_DEGREE6_ALL_PROJECTIVE_CHARACTERS_INDEPENDENT_REPLAY_OK" in completed.stdout
    print(f"PASS seal hashes for {len(seal['files'])} curated artifacts")
    print("Q_SCHUR_DEGREE6_F55_PACKET_VERIFY_ALL_OK")


if __name__ == "__main__":
    main()
