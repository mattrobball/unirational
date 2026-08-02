#!/usr/bin/env python3
"""Seal the determinantal-cover phase without upgrading its theorem scope."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL = HERE / "SEAL.json"
FILES = [
    "REPORT.md",
    "audit_phase.py",
    "certify_mds_stageB_cover.py",
    "manual_stop_provenance.json",
    "phase_audit_result.json",
    "produce_affine_incidence.py",
    "r66_stageB_qflag00_bflag0.json",
    "r66_stageB_qflag00_bflag0.leading",
    "r66_stageB_qflag00_bflag0.log",
    "r66_stageB_qflag00_bflag0.ms",
    "r66_stageB_qflag00_bflag0.run.json",
    "r66_stageB_qflag00_bflag0.sig1.log",
    "r66_stageB_qflag00_bflag0.sig1_guarded.leading",
    "r66_stageB_qflag00_bflag0.sig1_guarded.log",
    "r66_stageB_qflag00_bflag0.sig1_guarded.run.json",
    "run_bounded_msolve.py",
    "stageB_mds34_cover.npz",
    "stageB_mds34_cover_certificate.json",
    "verify_mds_stageB_cover.py",
    "verify_mds_stageB_cover_result.json",
]


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    missing = [name for name in FILES if not (HERE / name).is_file()]
    if missing:
        raise FileNotFoundError(missing)
    audit = json.loads((HERE / "phase_audit_result.json").read_text())
    replay = json.loads((HERE / "verify_mds_stageB_cover_result.json").read_text())
    if audit["status"] != "PASS_DETERMINANTAL_COVER_PHASE_AUDIT_NONVERDICT":
        raise AssertionError("phase audit is not bound")
    if replay["status"] != "PASS_INDEPENDENT_STAGEB_MDS34_COVER_REPLAY":
        raise AssertionError("MDS replay is not bound")
    payload = {
        "status": "SEALED_MDS34_COVER_ALL_CHARTS_UNSOLVED",
        "headline": "P25-UNDECIDED",
        "files": {
            name: {
                "bytes": (HERE / name).stat().st_size,
                "sha256": sha256(HERE / name),
            }
            for name in FILES
        },
        "binding_input": {
            "r66_packet": "parallel/global_compatibility/support_augmented_r66_stageBC.npz",
            "sha256": audit["r66_packet_sha256"],
        },
        "exact_conclusions": {
            "stageB_mds34_cover": True,
            "covered_locus": "D(H8) x P5_b1",
            "ordinary_run_strict_nonverdict": True,
            "manual_resource_stop_bound": True,
            "signature_run_strict_nonverdict": True,
            "live_rss_guard_verified_on_signature_run": True,
            "all_stageB_chart_emptiness_results": 0,
            "all_stageC_chart_emptiness_results": 0,
        },
        "not_proved": (
            "any affine chart empty; Stage B or Stage C empty on D(H8); "
            "any H8-power minor identity or polynomial left inverse; "
            "P25 degree-25 emptiness; positive covariant"
        ),
    }
    SEAL.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(payload["status"])


if __name__ == "__main__":
    main()
