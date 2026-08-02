#!/usr/bin/env python3
"""Fail-closed verifier for SEAL.json and the no-run boundary."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"
EXPECTED_FILES = {
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
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    payload = json.loads(SEAL.read_text())
    if payload.get("status") != "SEALED_PREPARED_NOT_RUN":
        raise AssertionError("wrong seal status")
    if set(payload.get("files", {})) != EXPECTED_FILES:
        raise AssertionError("seal file census mismatch")
    for name, record in payload["files"].items():
        path = HERE / name
        if not path.is_file():
            raise FileNotFoundError(name)
        if path.stat().st_size != record["bytes"] or sha256(path) != record["sha256"]:
            raise AssertionError(f"sealed file mismatch: {name}")
    if sha256(HERE / "r66_stageB_q0_1_b1_0_1_m100.ms") != payload["source_sha256"]:
        raise AssertionError("sealed source binding mismatch")
    no_run = json.loads((HERE / "verify_prepared_result.json").read_text())
    if no_run.get("status") != "PREPARED_NOT_RUN" or no_run.get("run_artifacts") != []:
        raise AssertionError("no-run verifier boundary changed")
    unexpected = [
        path.name
        for path in HERE.iterdir()
        if path.suffix in {".leading", ".log"}
        or path.name.endswith(".run.json")
        or path.name.endswith(".prelaunch.json")
    ]
    if unexpected:
        raise AssertionError(f"unexpected CAS run artifacts: {sorted(unexpected)}")
    command = payload.get("proposed_unsandboxed_command")
    if command != [
        "/opt/homebrew/bin/python3",
        "-u",
        str(HERE / "run_pair_split.py"),
        "--confirm-parent-notified",
    ]:
        raise AssertionError("sealed launch command mismatch")
    print("PASS_SEALED_PREPARED_NOT_RUN")


if __name__ == "__main__":
    main()
