#!/usr/bin/env python3
"""Verify the stratified packet seal and theorem-scope guards."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
ROOT = HERE.parents[3]
SEAL = HERE / "SEAL.json"
OUTPUT = HERE / "verify_seal_result.json"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def resolve_dependency(name: str) -> Path:
    prefix, relative = name.split(":", 1)
    if prefix == "P25":
        return P25 / relative
    if prefix == "ROOT":
        return ROOT / relative
    raise AssertionError(f"unknown dependency prefix {prefix}")


def main() -> None:
    with SEAL.open() as handle:
        seal = json.load(handle)
    if seal.get("status") != "SEALED_CLOSED_L8_B_AND_C_EMPTY_COMPLEMENT_OPEN":
        raise AssertionError("seal status changed")
    for name, record in seal["files"].items():
        path = HERE / name
        if path.stat().st_size != record["bytes"] or sha256(path) != record["sha256"]:
            raise AssertionError(f"sealed file changed: {name}")
    for name, record in seal["dependencies"].items():
        path = resolve_dependency(name)
        if path.stat().st_size != record["bytes"] or sha256(path) != record["sha256"]:
            raise AssertionError(f"sealed dependency changed: {name}")

    with (HERE / "closed_L8_stageC_certificate.json").open() as handle:
        closed_c = json.load(handle)
    with (HERE / "verify_closed_L8_stageC_result.json").open() as handle:
        closed_v = json.load(handle)
    if closed_c.get("status") != "PASS_CLOSED_L8_STAGEC_EMPTY":
        raise AssertionError("closed-L8 Stage-C producer status changed")
    if closed_c["degree8_map"].get("rank") != 6435:
        raise AssertionError("closed-L8 degree-eight rank changed")
    if closed_v.get("status") != "PASS_INDEPENDENT_CLOSED_L8_STAGEC_EMPTY":
        raise AssertionError("closed-L8 Stage-C verifier status changed")
    if closed_v.get("selected_minor_rank") != 6435:
        raise AssertionError("closed-L8 selected minor rank changed")

    with (HERE / "stratified_jobs.json").open() as handle:
        ledger = json.load(handle)
    with (HERE / "verify_stratified_inputs_result.json").open() as handle:
        ledger_v = json.load(handle)
    if ledger.get("status") != "JOBS_GENERATED_NOT_LAUNCHED" or not ledger.get(
        "not_launched"
    ):
        raise AssertionError("complement ledger no longer says unlaunched")
    if ledger_v.get("status") != "PASS_STRATIFIED_INPUT_REPLAY" or ledger_v.get(
        "jobs_launched"
    ):
        raise AssertionError("complement replay status changed")
    if len(ledger["jobs"]) != 6:
        raise AssertionError("expected six complement jobs")
    if "overwritten pathname with a different hash is provenance-invalid" not in seal[
        "open_complement"
    ].get("provenance_guard", ""):
        raise AssertionError("seal omits overwritten-script provenance guard")
    for job in ledger["jobs"].values():
        if (HERE / job["result"]).exists():
            raise AssertionError(f"unexpected complement result exists: {job['result']}")
    for label in ("degrevlex", "deglex"):
        if (HERE / f"closed_L8_augmented_module_{label}.result").exists():
            raise AssertionError("optional augmented-module route unexpectedly has a result")

    payload = {
        "status": "PASS_STRATIFIED_PACKET_SEAL",
        "seal_sha256": sha256(SEAL),
        "sealed_files": len(seal["files"]),
        "sealed_dependencies": len(seal["dependencies"]),
        "closed_L8_stageB_empty": True,
        "closed_L8_stageC_empty": True,
        "closed_L8_stageC_degree8_rank": 6435,
        "prepared_complement_jobs": len(ledger["jobs"]),
        "complement_jobs_launched": False,
        "global_stageB_or_stageC_verdict": "UNDECIDED",
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS: stratified packet seal verified")


if __name__ == "__main__":
    main()
