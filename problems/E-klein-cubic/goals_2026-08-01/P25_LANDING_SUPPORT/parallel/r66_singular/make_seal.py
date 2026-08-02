#!/usr/bin/env python3
"""Seal the immutable prepared-not-run r66 Singular packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = [
    "WORK_SCOPE.md",
    "REPORT.md",
    "produce_r66_singular_jobs.py",
    "verify_prepared_jobs.py",
    "verify_prepared_jobs_result.json",
    "produce_preconditioned_module.py",
    "verify_preconditioned_module.py",
    "verify_preconditioned_module_result.json",
    "run_bounded_singular.py",
    "jobs_manifest.json",
    "leading_profiles.json",
    "r66_stageB_q0_1_b10_1_equations.inc",
    "r66_stageB_q0_1_module.inc",
    "r66_stageB_q0_1_b10_1_std_qfirst_notBuckets.sing",
    "r66_stageB_q0_1_b10_1_std_bfirst_notBuckets.sing",
    "r66_stageB_q0_1_b10_1_slimgb_qfirst.sing",
    "r66_stageB_q0_1_all_b_module_std_notBuckets.sing",
    "preconditioned_manifest.json",
    "module_preconditioner.npz",
    "r66_stageB_q0_1_module_preconditioned.inc",
    "r66_stageB_q0_1_all_b_module_preconditioned_std_notBuckets.sing",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    entries = []
    for name in FILES:
        path = HERE / name
        if not path.is_file():
            raise FileNotFoundError(path)
        entries.append({"path": name, "bytes": path.stat().st_size, "sha256": sha256(path)})
    payload = {
        "status": "SEALED_R66_SINGULAR_PREPARED_NOT_RUN",
        "theorem_status": "P25-UNDECIDED",
        "cas_launched": False,
        "scope": "Exact q0=1,b1_0=1 scalar chart and stronger q0=1 Stage-B module jobs; preparation only.",
        "files": entries,
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("SEALED_R66_SINGULAR_PREPARED_NOT_RUN")


if __name__ == "__main__":
    main()
