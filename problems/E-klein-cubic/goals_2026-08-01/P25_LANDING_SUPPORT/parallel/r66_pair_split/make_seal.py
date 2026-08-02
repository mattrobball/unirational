#!/usr/bin/env python3
"""Seal the immutable PREPARED_NOT_RUN r66 pair-split package."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"
FILES = (
    ".gitignore",
    "REPORT.md",
    "WORK_SCOPE.md",
    "input_manifest.json",
    "prepare_chart.py",
    "r66_stageB_q0_1_b1_0_1_m100.ms",
    "run_pair_split.py",
    "verify_prepared.py",
    "verify_prepared_result.json",
    "make_seal.py",
    "verify_seal.py",
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    missing = [name for name in FILES if not (HERE / name).is_file()]
    if missing:
        raise FileNotFoundError(f"missing seal inputs: {missing}")
    verification = json.loads((HERE / "verify_prepared_result.json").read_text())
    if verification.get("status") != "PREPARED_NOT_RUN":
        raise AssertionError("prepared verification is not a no-run result")
    run_artifacts = [
        path.name
        for path in HERE.iterdir()
        if path.suffix in {".leading", ".log"}
        or path.name.endswith(".run.json")
        or path.name.endswith(".prelaunch.json")
    ]
    if run_artifacts:
        raise AssertionError(f"unexpected run artifacts: {sorted(run_artifacts)}")
    payload = {
        "status": "SEALED_PREPARED_NOT_RUN",
        "scope": "r66 Stage-B affine chart q0=1,b1_0=1 pair-split retry only",
        "source_sha256": "9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b",
        "r66_packet_sha256": "b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84",
        "msolve_binary_sha256": "b2008fb403f38f6a2ae230d12e3023776ae0196761c49966d97fe10747131c60",
        "proposed_unsandboxed_command": [
            "/opt/homebrew/bin/python3",
            "-u",
            str(HERE / "run_pair_split.py"),
            "--confirm-parent-notified",
            "--rss-gib",
            "16",
            "--timeout-seconds",
            "1200",
        ],
        "resource_fence": {
            "rss_gib_default": 16,
            "rss_gib_range": [8, 32],
            "timeout_seconds_default": 1200,
            "timeout_seconds_range": [60, 3600],
            "retired_theater_rss_gib": 4.5,
            "census_backend": "libproc+sysctl_no_ps",
        },
        "run_artifacts": [],
        "files": {
            name: {"bytes": (HERE / name).stat().st_size, "sha256": sha256(HERE / name)}
            for name in FILES
        },
        "scope_guard": (
            "No CAS retry was launched. A future completed exact unit ideal would prove "
            "only this chart empty; every other result is a nonverdict."
        ),
    }
    SEAL.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(payload["status"])


if __name__ == "__main__":
    main()
