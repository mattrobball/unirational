#!/usr/bin/env python3
"""Verify the immutable prepared-not-run seal without launching a CAS."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    if seal.get("status") != "PREPARED_NOT_RUN" or seal.get("cas_launched") is not False:
        raise AssertionError("seal status is not PREPARED_NOT_RUN")
    for name, expected in seal["files"].items():
        path = HERE / name
        if path.stat().st_size != expected["bytes"] or sha256(path) != expected["sha256"]:
            raise AssertionError(f"sealed file mismatch: {name}")
    manifest = json.loads((HERE / "r66_stageC_q0_1_b0_1.json").read_text())
    replay = json.loads((HERE / "verify_stagec_q0_result.json").read_text())
    jobs = json.loads((HERE / "job_plan.json").read_text())
    if manifest["inputs"]["msolve"]["sha256"] != seal["msolve_input_sha256"]:
        raise AssertionError("msolve binding mismatch")
    if manifest["inputs"]["singular"]["sha256"] != seal["singular_input_sha256"]:
        raise AssertionError("Singular binding mismatch")
    if replay.get("status") != "PASS_INPUT_REPLAY_PREPARED_NOT_RUN":
        raise AssertionError("entrywise replay status mismatch")
    if jobs.get("status") != "PREPARED_NOT_RUN" or jobs.get("cas_launched") is not False:
        raise AssertionError("job plan status mismatch")
    if list(HERE.glob("*.run.json")) or list(HERE.glob("*.result.txt")):
        raise AssertionError("CAS outputs appeared after sealing")
    print("PASS_SEAL_PREPARED_NOT_RUN")


if __name__ == "__main__":
    main()

