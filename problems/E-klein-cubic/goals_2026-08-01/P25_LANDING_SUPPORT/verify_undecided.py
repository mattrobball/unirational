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

    closed_l8 = json.loads(
        (HERE / "parallel/stageb_stratified_cas/verify_closed_L8_stageC_result.json").read_text()
    )
    require(
        closed_l8["status"] == "PASS_INDEPENDENT_CLOSED_L8_STAGEC_EMPTY"
        and closed_l8["closed_L8_stageC_empty"] is True
        and closed_l8["selected_minor_rank"] == 6435,
        "closed-L8 Stage-C replay failed",
    )
    require(
        closed_l8["artifact_sha256"]
        == "ad64848d98316eff00793814a5e8be09978f61c13057e4256e9a586375093957",
        "closed-L8 Stage-C artifact mismatch",
    )

    mds = json.loads(
        (HERE / "parallel/structural_route/verify_mds_cover_result.json").read_text()
    )
    require(
        mds["status"] == "PASS_INDEPENDENT_STAGEB_H8_MDS_COVER"
        and mds["charts"] == 34
        and mds["q_code"] == [34, 29, 6]
        and mds["b1_code"] == [34, 6, 29]
        and mds["stageB_decided"] is False,
        "Stage-B MDS-cover replay failed",
    )

    pair_split = json.loads(
        (HERE / "parallel/r66_pair_split/verify_prepared_result.json").read_text()
    )
    require(pair_split["status"] == "PREPARED_NOT_RUN",
            "pair-split retry was unexpectedly promoted or run")
    require(pair_split["run_artifacts"] == [],
            "unexpected pair-split run artifacts")
    require(
        pair_split["source"]["sha256"]
        == "9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b",
        "pair-split input hash mismatch",
    )

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
        "smallest_unresolved": (
            "Stage B on D(H8): 34 certified affine cover charts, first chart undecided"
        ),
        "closed_L8_stageB_and_stageC": True,
        "stageB_complement_chart_count": 34,
        "stageC_complement_chart_count": 29,
        "pair_split_retry": "PREPARED_NOT_RUN",
        "no_unit_ideal_promoted": True,
        "headline": "OPEN",
    }
    (HERE / "verify_undecided_result.json").write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n"
    )
    print("P25_UNDECIDED_ACCEPT")


if __name__ == "__main__":
    main()
