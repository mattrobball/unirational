#!/usr/bin/env python3
"""Verify hashes, theorem scopes, and unlaunched heavy-job state."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def load(name: str) -> dict:
    return json.loads((HERE / name).read_text())


def main() -> None:
    seal = load("SEAL.json")
    if seal["status"] != "P25-UNDECIDED":
        raise AssertionError("seal exit mismatch")
    for name, expected in seal["files"].items():
        path = HERE / name
        if not path.is_file() or sha256(path) != expected:
            raise AssertionError(f"hash mismatch: {name}")

    augmented = load("verify_augmented_coordinate_lines_result.json")
    if augmented["status"] != "PASS_INDEPENDENT_AUGMENTED_COORDINATE_LINE_REPLAY":
        raise AssertionError("augmented replay missing")
    if "no global emptiness" not in augmented["scope"].lower():
        raise AssertionError("augmented scope was promoted")
    single = load("verify_single_b_support_result.json")
    if single["status"] != "PASS_INDEPENDENT_SINGLE_B_SUPPORT_REPLAY":
        raise AssertionError("single-b replay missing")
    common = load("b_pencil_common_profile.json")
    if common["component_ranks"] != [9139] * 6 or "preflight only" not in common["scope"].lower():
        raise AssertionError("common-profile scope/ranks mismatch")
    pencil = load("b_star_line_job.json")
    if pencil["status"] != "PREPARED_NO_COMPLETED_CERTIFICATE" or not pencil["no_sampling"]:
        raise AssertionError("b-pencil launch/sampling state mismatch")

    for stem, replay_status in [
        ("direct_690_all_222_degree5", "PASS_IMMUTABLE_ALL_222_JOB_REPLAY"),
        ("direct_full690_all28_degree8", "PASS_IMMUTABLE_FULL28_DEGREE8_JOB_REPLAY"),
    ]:
        manifest = load(stem + ".json")
        replay = load("verify_" + ("all_pure_power_job" if "222" in stem else "full28_degree8_job") + "_result.json")
        if manifest["status"] != "PREPARED_NOT_RUN" or manifest["launched"] is not False:
            raise AssertionError(f"heavy job launch state mismatch: {stem}")
        if replay["status"] != replay_status or replay["launched"] is not False:
            raise AssertionError(f"heavy job preparation replay mismatch: {stem}")
        forbidden = [
            HERE / (stem + ".result"),
            HERE / (stem + ".log"),
            HERE / (stem + ".run.json"),
        ]
        if any(path.exists() for path in forbidden):
            raise AssertionError(f"unexpected heavy run artifact: {stem}")

    report = (HERE / "REPORT.md").read_text()
    required = [
        "P25-UNDECIDED",
        "not launched",
        "not `P^5`",
        "Not proved here",
    ]
    if any(text.lower() not in report.lower() for text in required):
        raise AssertionError("report theorem boundary is incomplete")
    print("PASS_GLOBAL_COMPATIBILITY_SEAL")


if __name__ == "__main__":
    main()
