#!/usr/bin/env python3
"""Verify the honest P25-UNDECIDED packet without promoting nonresults."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def require(condition: bool, message: str) -> None:
    if not condition:
        raise RuntimeError(message)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--full-replay", action="store_true")
    args = parser.parse_args()

    status = (HERE / "STATUS.md").read_text()
    require(status.splitlines()[0] == "P25-UNDECIDED", "wrong STATUS exit")
    payload = json.loads((HERE / "candidate_or_empty.json").read_text())
    attempts = json.loads((HERE / "saturation_attempts.json").read_text())
    require(payload["exit"] == "P25-UNDECIDED", "wrong machine exit")
    require(payload["candidate"] is None and payload["empty"] is None,
            "honest stop must not contain a candidate or emptiness verdict")
    require(payload["special_fibre_empty"] is None,
            "special-fibre emptiness was not decided")
    require(attempts["unit_ideal_certificate_obtained"] is False,
            "attempt ledger falsely claims a unit ideal")
    require(attempts["special_fibre_empty_proved"] is False,
            "attempt ledger falsely claims emptiness")

    expected_scripts = {
        43: "40e51becf684e7694f8f30705a9ca365f4875cf21771c01c601ed1fcb37bb3e9",
        96: "f7024e529a2d463ee91cec02f8c0ad56a5f868c6df3a90e7a5f35a30e22b8ca8",
        256: "03f54fbad6d1a220520a8ecb84e7dc5b37cbbc6c49092ee8dfb2e1ba19f9188e",
    }
    for rows, expected in expected_scripts.items():
        script = HERE / f"syzygy_r{rows}_boundary_saturate.sing"
        require(script.is_file() and sha256(script) == expected,
                f"r{rows} saturation script hash mismatch")
    require(
        sha256(HERE / "syzygy_r256_q0_contracted.npz")
        == "2e718c491172480e3aa3f055d5806d28a9414db2627e6daf3f0204bdc3b840ea",
        "256-row contraction hash mismatch",
    )
    for rows in (43, 48, 96, 256):
        require(not (HERE / f"syzygy_r{rows}_boundary_singular_result.txt").exists(),
                f"unexpected unvalidated r{rows} result file")

    stage_a = json.loads((HERE / "stageA_replay_result.json").read_text())
    rowrank = json.loads((HERE / "rowrank_replay_report.json").read_text())
    require(stage_a["exit"] == "P25W-STAGEA-EMPTY", "Stage A replay failed")
    require(stage_a["quadric_rank"] == stage_a["nquad"] == 3828,
            "Stage A quadratic span mismatch")
    require(rowrank["ok"] is True and rowrank["recomputed_landing_rank"] == 746,
            "rank-746 replay failed")
    require("P25YB_SUPPORT_F4_VERIFIER_ACCEPT" in
            (HERE / "border_replay.log").read_text(), "border replay failed")
    require("VERIFY OK" in (HERE / "dvr_replay.log").read_text(),
            "DVR replay failed")

    if args.full_replay:
        subprocess.run(
            [sys.executable, str(HERE / "verify_syzygy_empty.py"), "--equations-only"],
            cwd=HERE.parent,
            check=True,
        )

    result = {
        "exit": "P25-UNDECIDED",
        "verdict": "PASS",
        "full_replay_requested": args.full_replay,
        "smallest_unresolved": "Stage B: b0=0,b1!=0 double saturation",
        "no_unit_ideal_promoted": True,
        "headline": "OPEN",
    }
    (HERE / "verify_undecided_result.json").write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n"
    )
    print("P25_UNDECIDED_ACCEPT")


if __name__ == "__main__":
    main()
