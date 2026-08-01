#!/usr/bin/env python3
"""Independent verifier for SEAL.json; does not import the producer."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def main() -> None:
    payload = json.loads((HERE / "SEAL.json").read_text(encoding="utf-8"))
    assert payload["schema"] == "klein-rational-curve-seal-v2"
    assert payload["exit"] == "R-HILBERT-COMPONENT-STRUCTURAL"
    assert payload["headline"] == "OPEN"
    assert payload["hash_algorithm"] == "sha256"
    assert len(payload["files"]) >= 15
    assert "SEAL.json" not in payload["files"]
    for relative, expected in sorted(payload["files"].items()):
        path = HERE / relative
        assert path.is_file(), path
        actual = hashlib.sha256(path.read_bytes()).hexdigest()
        assert actual == expected, (relative, expected, actual)
    print("R_RATIONAL_CURVES_SEAL_VERIFIED")


if __name__ == "__main__":
    main()
