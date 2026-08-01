#!/usr/bin/env python3
"""Write the external-input manifest and deterministic content seal."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
START_HEAD = "2140419410cfff2f7d7dcca166acef8c16a0d41b"
BASELINE = "715faf441289e2589b9325311b6613ea0331bf88"
INPUT_PATHS = (
    "../GOAL_COV_STRUCTURED_POSITIVE_SEARCH.md",
    "../../tmp/generic_twist/phi_coefficients.py",
    "../../tmp/kproj_arithmetic/core.py",
    "../../tmp/degree13_opt/reconstruct_large_prime.py",
    "../../certificates/modular_covariant_scan.py",
    "../../tmp/higher_compatibility_regularity/seeds/degree_25.json",
    "../../tmp/m1_t1_f3_colon_degree35_audit/ambient_seeds_35.json",
    "/opt/homebrew/lib/libffpack_c.dylib",
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def record(label: str) -> dict:
    path = Path(label) if label.startswith("/") else HERE / label
    path = path.resolve()
    assert path.is_file()
    return {"path": label, "sha256": sha256(path), "size": path.stat().st_size}


def main() -> None:
    verification_head = subprocess.run(
        ["git", "rev-parse", "HEAD"], cwd=HERE, check=True,
        capture_output=True, text=True,
    ).stdout.strip()
    inputs = {
        "schema": "cov-structured-search-input-manifest-v1",
        "pinned_mathematical_baseline": BASELINE,
        "live_head_at_start": START_HEAD,
        "verification_time_head": verification_head,
        "note": "The shared branch advanced concurrently; content hashes, not the moving head alone, bind every consumed input.",
        "runtime": {
            "python": sys.version.split()[0],
            "numpy": np.__version__,
            "ffpack": "/opt/homebrew/lib/libffpack_c.dylib",
        },
        "files": [record(path) for path in INPUT_PATHS],
    }
    (HERE / "INPUTS.json").write_text(json.dumps(inputs, indent=2, sort_keys=True) + "\n")

    files = []
    for path in sorted(HERE.rglob("*")):
        if (
            path.is_file()
            and path.name != "SEAL.json"
            and "__pycache__" not in path.parts
        ):
            files.append(
                {
                    "path": str(path.relative_to(HERE)),
                    "sha256": sha256(path),
                    "size": path.stat().st_size,
                }
            )
    seal = {
        "schema": "cov-structured-search-content-seal-v1",
        "exit": "COV-NEW-ANSATZ-STRUCTURAL",
        "headline": "OPEN",
        "input_manifest_sha256": sha256(HERE / "INPUTS.json"),
        "files": files,
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")
    print("COV_STRUCTURED_SEARCH_SEALED")


if __name__ == "__main__":
    main()
