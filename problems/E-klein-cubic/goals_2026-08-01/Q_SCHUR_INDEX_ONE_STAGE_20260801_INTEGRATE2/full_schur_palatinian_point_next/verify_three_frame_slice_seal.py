#!/usr/bin/env python3
"""Verify the retained canonical three-frame discovery seal."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

import make_three_frame_slice_seal as maker


HERE = Path(__file__).resolve().parent
SEAL = HERE / "THREE_FRAME_SLICE_SEAL.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    payload = json.loads(SEAL.read_text())
    assert payload["schema"] == "full-schur-canonical-three-frame-slice-seal-v1"
    assert payload["governing_status"] == "Q-UNDECIDED"
    assert set(payload["files"]) == set(maker.FILES)
    for name in maker.FILES:
        path = HERE / name
        record = payload["files"][name]
        assert path.stat().st_size == record["bytes"], name
        assert sha256(path) == record["sha256"], name
    print(f"PASS canonical three-frame slice seal files={len(maker.FILES)}")
    print("FULL_SCHUR_CANONICAL_THREE_FRAME_SLICE_SEAL_OK")


if __name__ == "__main__":
    main()
