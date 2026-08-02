#!/usr/bin/env python3
"""Write the portable enlarged-closure packet seal."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = [
    "WORK_SCOPE.md",
    "REPORT.md",
    "produce_projection_closure.py",
    "verify_projection_closure.py",
    "projection_closure_certificate.npz",
    "projection_closure_result.json",
    "verify_projection_closure_result.json",
    "produce_augmented_module_jobs.py",
    "verify_augmented_module_jobs.py",
    "support_balanced_r64_stageBC.npz",
    "support_balanced_r64_stageBC.json",
    "augmented_r43_p4_p3_module.sing",
    "augmented_r64_p4_p3_module.sing",
    "augmented_module_jobs.json",
    "verify_augmented_module_jobs_result.json",
    "make_seal.py",
    "verify_seal.py",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    entries = {}
    for name in FILES:
        path = HERE / name
        if not path.is_file():
            raise FileNotFoundError(path)
        entries[name] = {"bytes": path.stat().st_size, "sha256": sha256(path)}
    payload = {
        "status": "SEALED_ENLARGED_CLOSURE_PACKET",
        "prime": 89,
        "files": entries,
        "scope": (
            "Exact 690+56 cubic projection split, 2,072-dimensional formal "
            "first closure, and prepared unlaunched r43/r64 augmented P4|P3 "
            "module jobs. No full T-stable presentation or support verdict."
        ),
        "singular_launched": False,
        "pid_13036_left_untouched": True,
    }
    (HERE / "SEAL.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()
