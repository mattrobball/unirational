#!/usr/bin/env python3
"""Independently check every content hash in the Goal G seal."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
EXPECTED_SCHEMA = "G_ALL_DEGREE_STRUCTURAL_SEAL_V2"
EXPECTED_BASELINE = "715faf441289e2589b9325311b6613ea0331bf88"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> None:
    payload = json.loads((HERE / "SEAL.json").read_text())
    assert payload["schema"] == EXPECTED_SCHEMA
    assert payload["exit"] == "G-STRUCTURAL-UNDECIDED"
    assert payload["pinned_mathematical_baseline"] == EXPECTED_BASELINE
    assert (HERE / "STATUS.md").read_text().splitlines()[0] == payload["exit"]
    artifacts = payload["artifacts"]
    assert "SEAL.json" not in artifacts
    assert len(artifacts) == 50
    assert "ATTACKS.md" in artifacts
    assert sum(name.startswith("attacks/constructive_point/") for name in artifacts) == 18
    assert sum(name.startswith("attacks/local_infinite_descent/") for name in artifacts) == 3
    assert sum(name.startswith("attacks/valuation_obstruction/") for name in artifacts) == 6
    assert sum(name.startswith("attacks/zero_cycle_containment/") for name in artifacts) == 4
    for relative, expected in sorted(artifacts.items()):
        path = HERE / relative
        assert path.is_file(), relative
        assert sha256(path) == expected, relative
    print(f"G_ALL_DEGREE_SEAL_OK artifacts={len(artifacts)}")


if __name__ == "__main__":
    main()
