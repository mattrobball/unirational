#!/usr/bin/env python3
"""Seal the durable honest-stop packet after verification."""

from __future__ import annotations

import hashlib
import json
import subprocess
from datetime import datetime, timezone
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SEAL = HERE / "SEAL.json"
FINAL = HERE / "FINAL_FILES.txt"


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 22):
            digest.update(chunk)
    return digest.hexdigest()


def payload_paths() -> list[Path]:
    ignored = {"SEAL.json", "FINAL_FILES.txt"}
    paths = []
    for path in HERE.rglob("*"):
        relative = path.relative_to(HERE)
        if (
            not path.is_file()
            or path.name in ignored
            or path.name.startswith(".")
            or "__pycache__" in relative.parts
        ):
            continue
        paths.append(path)
    return sorted(paths, key=lambda path: path.relative_to(HERE).as_posix())


def main() -> int:
    paths = payload_paths()
    final_names = [path.relative_to(HERE).as_posix() for path in paths] + [
        "FINAL_FILES.txt",
        "SEAL.json",
    ]
    FINAL.write_text("\n".join(final_names) + "\n")
    sealed_paths = paths + [FINAL]
    records = [
        {
            "path": path.relative_to(HERE).as_posix(),
            "bytes": path.stat().st_size,
            "sha256": sha256_file(path),
        }
        for path in sealed_paths
    ]
    payload = {
        "schema": "p25-cov-support-honest-stop-seal-v1",
        "generated_utc": datetime.now(timezone.utc).isoformat(),
        "pinned_state": "bd610a032bb9561d2daeb91a2cb60c48c082ca2f",
        "observed_head": subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
        ).strip(),
        "exit": "PC-UNDECIDED",
        "headline": "OPEN",
        "files": records,
        "self_hash_rule": "SEAL.json is listed in FINAL_FILES.txt but does not hash itself.",
        "theorem_boundary": {
            "proved": (
                "PC.0 over F_89; exact coupled transition closure only through "
                "degree four; and Stage-B/Stage-C exclusion only for q-support at "
                "most three."
            ),
            "open": (
                "PC.1 stabilization, global PC.2 support, actual PC.3 factor "
                "incidences and remaining charts, PC.4, and the Problem E headline."
            ),
        },
    }
    SEAL.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"PASS_MAKE_SEAL files={len(records)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
