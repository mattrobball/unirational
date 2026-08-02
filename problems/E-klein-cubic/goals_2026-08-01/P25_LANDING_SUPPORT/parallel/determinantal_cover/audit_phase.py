#!/usr/bin/env python3
"""Audit every exact conclusion and every nonverdict in this phase."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
PACKET = P25 / "parallel" / "global_compatibility" / "support_augmented_r66_stageBC.npz"
RESULT = HERE / "phase_audit_result.json"
EXPECTED_PACKET_HASH = "b2d09782beb0bc6a3727f3abae582f8b9b09a78c5d424c73ba38c307f4945d84"
EXPECTED_INPUT_HASH = "9fc5d17aeb9c2bf1341c0871ffd1e0fce07682701a1490a12b2f64ed3378f34b"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def load(name: str) -> dict:
    return json.loads((HERE / name).read_text())


def main() -> None:
    if sha256(PACKET) != EXPECTED_PACKET_HASH:
        raise AssertionError("r66 packet hash changed")
    manifest = load("r66_stageB_qflag00_bflag0.json")
    if manifest["stage"] != "B" or manifest["q_unit_coordinate"] != 0:
        raise AssertionError("wrong affine chart")
    if manifest["b_flag_index"] != 0 or manifest["input_sha256"] != EXPECTED_INPUT_HASH:
        raise AssertionError("wrong b chart or input hash")
    if sha256(HERE / manifest["input"]) != EXPECTED_INPUT_HASH:
        raise AssertionError("affine input changed")

    ordinary = load("r66_stageB_qflag00_bflag0.run.json")
    ordinary_log = (HERE / ordinary["log"]).read_text()
    if ordinary["returncode"] != -15 or ordinary["complete"] or ordinary["unit_ideal"]:
        raise AssertionError("ordinary run is not the preserved strict nonverdict")
    if ordinary["peak_rss_bytes_polled"] != 0 or ordinary["stop_reason"] is not None:
        raise AssertionError("sandbox-blind runner provenance changed")
    for marker in (
        "2752 x 685405",
        "108.09 | 53.00",
        "6    1708    1708",
    ):
        if marker not in ordinary_log:
            raise AssertionError(f"ordinary F4 trace missing {marker}")
    manual = load("manual_stop_provenance.json")
    if manual["returncode"] != -15 or manual["signal"] != "SIGTERM":
        raise AssertionError("manual-stop provenance changed")
    if manual["last_observed_rss_kib_from_escalated_ps"] != 4482960:
        raise AssertionError("manual observed RSS changed")
    if manual["last_observed_rss_bytes"] <= manual["declared_limit_bytes"]:
        raise AssertionError("manual stop no longer records the fence crossing")

    signature = load("r66_stageB_qflag00_bflag0.sig1_guarded.run.json")
    signature_log = (HERE / signature["log"]).read_text()
    if signature["binding_resource_guard"] != "live_ps_rss_poll_fail_closed":
        raise AssertionError("signature guard changed")
    if signature["peak_rss_bytes_polled"] <= 0:
        raise AssertionError("signature live RSS poll was not verified")
    if signature["peak_rss_bytes_polled"] >= signature["rss_limit_bytes"]:
        raise AssertionError("signature run exceeded its fence")
    if signature["returncode"] != 1 or signature["complete"] or signature["unit_ideal"]:
        raise AssertionError("signature run is not the preserved strict nonverdict")
    for marker in (
        "field characteristic    1073741827",
        "signature-based computation      1",
        "Input system must be homogeneous.",
    ):
        if marker not in signature_log:
            raise AssertionError(f"signature rejection trace missing {marker}")

    mds = load("verify_mds_stageB_cover_result.json")
    if mds["status"] != "PASS_INDEPENDENT_STAGEB_MDS34_COVER_REPLAY":
        raise AssertionError("MDS cover replay failed")
    if mds["systematic_chart_census"]["total"] != 34:
        raise AssertionError("MDS chart count changed")
    if mds["support_intersection_lower_bound"] != 1:
        raise AssertionError("MDS support intersection changed")
    ms_inputs = sorted(path.name for path in HERE.glob("*.ms"))
    if ms_inputs != ["r66_stageB_qflag00_bflag0.ms"]:
        raise AssertionError(f"unexpected chart inputs: {ms_inputs}")

    payload = {
        "status": "PASS_DETERMINANTAL_COVER_PHASE_AUDIT_NONVERDICT",
        "r66_packet_sha256": sha256(PACKET),
        "affine_input_sha256": EXPECTED_INPUT_HASH,
        "ordinary_run": {
            "strict_nonverdict": True,
            "returncode": -15,
            "manual_last_observed_rss_bytes": manual["last_observed_rss_bytes"],
            "f4_completed_degree5": True,
            "degree6_incomplete": True,
        },
        "signature_run": {
            "strict_nonverdict": True,
            "live_rss_guard_verified": True,
            "peak_rss_bytes": signature["peak_rss_bytes_polled"],
            "rejected_nonhomogeneous_input": True,
            "reported_wrong_characteristic": 1073741827,
        },
        "exact_theorem": {
            "stageB_mds_opens": 34,
            "covered_locus": "D(H8) x P5_b1",
            "all_chart_emptiness_results": 0,
        },
        "not_proved": [
            "any affine chart empty",
            "Stage B empty on D(H8)",
            "Stage C empty on D(H8)",
            "any H8-power minor identity or polynomial left inverse",
            "P25 degree-25 emptiness"
        ],
    }
    RESULT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(payload["status"])


if __name__ == "__main__":
    main()
