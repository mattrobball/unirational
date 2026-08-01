#!/usr/bin/env python3
"""Verify byte hashes and theorem-boundary fields in SEAL.json."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def included_files() -> list[Path]:
    return sorted(
        path
        for path in HERE.rglob("*")
        if path.is_file()
        and path.name != "SEAL.json"
        and "__pycache__" not in path.parts
    )


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["exit"] == "COV-STRUCTURED-DEGREES-EMPTY-SCOPED"
    assert seal["headline"] == "OPEN"
    assert seal["positive_mission_achieved"] is False
    assert [item["dimension"] for item in seal["selected_pairs"]] == [0, 0, 0]
    assert "m=1 branches" in seal["scope_exclusion"]
    actual = {str(path.relative_to(HERE)): sha256(path) for path in included_files()}
    assert actual == seal["files"]
    status = (HERE / "STATUS.md").read_text()
    assert "COV-STRUCTURED-DEGREES-EMPTY-SCOPED" in status
    assert "headline: OPEN" in status
    assert "does **not** exclude degrees 25, 31, or 35" in status
    print(f"verified_sealed_files={len(actual)}")
    print("COV_SEAL_VERIFIED")


if __name__ == "__main__":
    main()
