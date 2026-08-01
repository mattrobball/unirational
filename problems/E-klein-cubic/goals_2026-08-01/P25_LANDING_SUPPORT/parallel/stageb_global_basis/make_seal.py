#!/usr/bin/env python3
"""Bind every deliverable in this isolated packet by SHA-256."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"
LOCAL_REBUILDABLE = {
    "full_linear_syzygy_basis.npy",
    "full_p3_contractions.npy",
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    files = []
    local_rebuildable = []
    for path in sorted(HERE.iterdir(), key=lambda item: item.name):
        if not path.is_file() or path == SEAL or path.name.startswith("."):
            continue
        entry = (
            {
                "path": path.name,
                "bytes": path.stat().st_size,
                "sha256": sha256(path),
            }
        )
        if path.name in LOCAL_REBUILDABLE:
            local_rebuildable.append(entry)
        else:
            files.append(entry)
    payload = {
        "status": "SEALED_STAGEB_GLOBAL_BASIS_PACKET",
        "files": files,
        "file_count": len(files),
        "local_rebuildable_artifacts": local_rebuildable,
        "scope": (
            "Exact full-basis, P3/P4, LT-obstruction, coordinate-line, and "
            "prepared Stage-B/Stage-C CAS artifacts; no saturation verdict."
        ),
    }
    SEAL.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"sealed {len(files)} files")


if __name__ == "__main__":
    main()
