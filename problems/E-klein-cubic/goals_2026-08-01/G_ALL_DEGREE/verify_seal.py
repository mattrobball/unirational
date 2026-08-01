#!/usr/bin/env python3
"""Independently check every content hash in the Goal G seal."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
EXPECTED_SCHEMA = "G_ALL_DEGREE_STRUCTURAL_SEAL_V3"
EXPECTED_BASELINE = "715faf441289e2589b9325311b6613ea0331bf88"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def expected_names() -> set[str]:
    return {
        str(path.relative_to(HERE))
        for path in HERE.rglob("*")
        if path.is_file()
        and path != HERE / "SEAL.json"
        and "__pycache__" not in path.parts
        and path.suffix != ".pyc"
    }


def main() -> None:
    caches = [
        path
        for path in HERE.rglob("*")
        if "__pycache__" in path.parts or path.suffix == ".pyc"
    ]
    assert not caches, caches
    payload = json.loads((HERE / "SEAL.json").read_text())
    assert payload["schema"] == EXPECTED_SCHEMA
    assert payload["exit"] == "G-STRUCTURAL-UNDECIDED"
    assert payload["pinned_mathematical_baseline"] == EXPECTED_BASELINE
    assert (HERE / "STATUS.md").read_text().splitlines()[0] == payload["exit"]
    artifacts = payload["artifacts"]
    assert "SEAL.json" not in artifacts
    expected = expected_names()
    assert set(artifacts) == expected
    for required in (
        "ATTACKS.md",
        "LITERATURE_FRONTIER.md",
        "verify_literature_frontier.py",
        "attacks/low_rank_valuations_v2/RESULT.md",
        "attacks/primitive_quartic_v2/RESULT.md",
        "attacks/ternary_kproj_v2/RESULT.md",
        "attacks/ternary_kproj_v2/SEAL.json",
        "attacks/ternary_kproj_v2/.gitignore",
    ):
        assert required in artifacts
    assert sum(name.startswith("attacks/constructive_point/") for name in artifacts) == 18
    assert sum(name.startswith("attacks/local_infinite_descent/") for name in artifacts) == 3
    assert sum(name.startswith("attacks/valuation_obstruction/") for name in artifacts) == 6
    assert sum(name.startswith("attacks/zero_cycle_containment/") for name in artifacts) == 4
    assert sum(name.startswith("attacks/low_rank_valuations_v2/") for name in artifacts) == 8
    assert sum(name.startswith("attacks/primitive_quartic_v2/") for name in artifacts) == 2
    ternary_seal = json.loads(
        (HERE / "attacks/ternary_kproj_v2/SEAL.json").read_text()
    )
    assert ternary_seal["artifact_count"] == 251
    assert sum(name.startswith("attacks/ternary_kproj_v2/") for name in artifacts) == 252
    for relative, expected in sorted(artifacts.items()):
        path = HERE / relative
        assert path.is_file(), relative
        assert sha256(path) == expected, relative
    print(f"G_ALL_DEGREE_SEAL_OK artifacts={len(artifacts)}")


if __name__ == "__main__":
    main()
