#!/usr/bin/env python3
"""Seal the prepared-not-run Stage-C chart artifacts."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = [
    "WORK_SCOPE.md",
    "REPORT.md",
    "produce_stagec_q0.py",
    "verify_stagec_q0.py",
    "run_guarded.py",
    "make_job_plan.py",
    "make_seal.py",
    "verify_seal.py",
    "r66_stageC_q0_1_b0_1.ms",
    "r66_stageC_q0_1_b0_1.sing",
    "r66_stageC_q0_1_b0_1.json",
    "verify_stagec_q0_result.json",
    "job_plan.json",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    manifest = json.loads((HERE / "r66_stageC_q0_1_b0_1.json").read_text())
    replay = json.loads((HERE / "verify_stagec_q0_result.json").read_text())
    jobs = json.loads((HERE / "job_plan.json").read_text())
    if manifest.get("status") != "PREPARED_NOT_RUN" or manifest.get("cas_launched") is not False:
        raise AssertionError("input manifest scope changed")
    if replay.get("status") != "PASS_INPUT_REPLAY_PREPARED_NOT_RUN" or replay.get("cas_launched") is not False:
        raise AssertionError("input replay status changed")
    if jobs.get("status") != "PREPARED_NOT_RUN" or jobs.get("cas_launched") is not False:
        raise AssertionError("job plan scope changed")
    forbidden = list(HERE.glob("*.run.json")) + list(HERE.glob("*.result.txt"))
    if forbidden:
        raise AssertionError(f"CAS output exists in prepared-not-run seal: {forbidden}")
    entries = {}
    for name in FILES:
        path = HERE / name
        if not path.is_file():
            raise FileNotFoundError(path)
        entries[name] = {"bytes": path.stat().st_size, "sha256": sha256(path)}
    payload = {
        "status": "PREPARED_NOT_RUN",
        "cas_launched": False,
        "scope": "one selected normalized Stage-C affine chart D(q0), b0=1",
        "files": entries,
        "packet_sha256": manifest["packet_sha256"],
        "msolve_input_sha256": manifest["inputs"]["msolve"]["sha256"],
        "singular_input_sha256": manifest["inputs"]["singular"]["sha256"],
        "decision_rule": (
            "Only a future completed exact unit result proves this one chart empty; "
            "all other outcomes are nonverdicts. No global Stage-C/P25 claim."
        ),
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("SEALED_PREPARED_NOT_RUN")


if __name__ == "__main__":
    main()

