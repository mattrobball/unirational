#!/usr/bin/env python3
"""Extract an immutable validation-only Singular input from the Stage-B job."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "systematic_stageB_homogenized_all222.sing"
TARGET = HERE / "systematic_stageB_leading_check.sing"
MANIFEST = HERE / "systematic_stageB_leading_check.json"
MARKER = 'print("INPUT_GENS="+string(size(N)));'


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def immutable(path: Path, data: bytes) -> None:
    if path.exists():
        if path.read_bytes() != data:
            raise RuntimeError(f"refusing to overwrite mismatching artifact: {path}")
        return
    path.write_bytes(data)


def main() -> None:
    source = SOURCE.read_text()
    if source.count(MARKER) != 1:
        raise RuntimeError("unique Stage-B validation split marker missing")
    prefix = source.split(MARKER, 1)[0]
    content = (prefix + 'print("LEADING_CHECK_ONLY_COMPLETE");\nquit;\n').encode()
    immutable(TARGET, content)
    payload = {
        "status": "PREPARED_VALIDATION_ONLY",
        "source": {"file": SOURCE.name, "sha256": sha256(SOURCE)},
        "script": {
            "file": TARGET.name,
            "bytes": TARGET.stat().st_size,
            "sha256": sha256(TARGET),
        },
        "criterion": (
            "Exit zero with SYSTEMATIC_LT_CHECK=1 and "
            "LEADING_CHECK_ONLY_COMPLETE, and with no LT_FAIL line."
        ),
        "scope": "Checks input leading terms only; never computes a standard basis.",
    }
    immutable(MANIFEST, (json.dumps(payload, indent=2, sort_keys=True) + "\n").encode())
    print(json.dumps(payload, sort_keys=True))


if __name__ == "__main__":
    main()

