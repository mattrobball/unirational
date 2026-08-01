#!/usr/bin/env python3
"""Lightweight consistency audit for the Stage-B strata certificates.

This does not replace the exact rank/determinant replays.  It checks that the
stored heavy-run artifacts consume the same sealed source, that replay hashes
match their producer certificates, and that the reported coordinate strata
are combined without silently enlarging their scope.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
SOURCE = P25 / "syzygy_r256_q0_contracted.npz"
OUTPUT = HERE / "summary_verification_result.json"
EXPECTED_SOURCE_SHA256 = (
    "2e718c491172480e3aa3f055d5806d28a9414db2627e6daf3f0204bdc3b840ea"
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def load(name: str) -> tuple[Path, dict]:
    path = HERE / name
    return path, json.loads(path.read_text())


def main() -> None:
    source_hash = sha256(SOURCE)
    if source_hash != EXPECTED_SOURCE_SHA256:
        raise RuntimeError("sealed r256 source hash changed")

    closed_path, closed = load("closed_L_degree6_certificate.json")
    closed_replay_path, closed_replay = load("verify_closed_L_degree6_result.json")
    if closed["source"]["sha256"] != source_hash:
        raise RuntimeError("closed-L source hash mismatch")
    degree_map = closed["degree_six_map"]
    if (
        degree_map["source_dimension"] != 13680
        or degree_map["target_dimension"] != 10296
        or degree_map["rank_over_F89"] != 10296
        or not degree_map["full_target_rank"]
    ):
        raise RuntimeError("closed-L rank certificate changed")
    if closed_replay["certificate_sha256"] != sha256(closed_path):
        raise RuntimeError("closed-L replay/certificate hash mismatch")
    if (
        closed_replay["status"] != "PASS"
        or not closed_replay["determinant_nonzero"]
        or closed_replay["determinant_mod_89"] != 28
    ):
        raise RuntimeError("closed-L determinant replay changed")

    charts_path, charts = load("one_coordinate_chart_certificates.json")
    charts_replay_path, charts_replay = load("verify_one_coordinate_charts_result.json")
    expected_replayed = [
        0,
        1,
        2,
        3,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36,
    ]
    if charts["source_sha256"] != source_hash:
        raise RuntimeError("one-coordinate source hash mismatch")
    if charts["certified_unit_charts"] != expected_replayed:
        raise RuntimeError("one-coordinate certified chart list changed")
    if charts["not_certified_charts"] != list(range(12, 21)):
        raise RuntimeError("bounded noncertificate chart list changed")
    if charts_replay["certificate_sha256"] != sha256(charts_path):
        raise RuntimeError("one-coordinate replay/certificate hash mismatch")
    if charts_replay["status"] != "PASS":
        raise RuntimeError("one-coordinate independent replay did not pass")
    replayed_coordinates = [
        entry["chart_coordinate"] for entry in charts_replay["replayed_certified_charts"]
    ]
    if replayed_coordinates != expected_replayed:
        raise RuntimeError("independently replayed chart list changed")
    if not all(
        entry["rank_equality"] and entry["verified_unit_module"]
        for entry in charts_replay["replayed_certified_charts"]
    ):
        raise RuntimeError("one-coordinate rank equality changed")

    q12_path, q12 = load("one_coordinate_q12_degree3_certificate.json")
    if q12["source_sha256"] != source_hash:
        raise RuntimeError("q12 degree-three source hash mismatch")
    if q12["certified_unit_charts"] != [12] or q12["not_certified_charts"]:
        raise RuntimeError("q12 degree-three chart status changed")
    q12_entry = q12["chart_results"][0]
    q12_trial = q12_entry["trials"][-1]
    if (
        q12_entry["first_unit_multiplier_degree"] != 3
        or q12_trial["source_rows"] != 21120
        or q12_trial["target_columns"] != 18018
        or q12_trial["augmented_rank"] != 18018
        or q12_trial["selected_appended_unit_components"]
        or not q12_trial["all_six_units_in_source_row_span"]
    ):
        raise RuntimeError("q12 degree-three unit certificate changed")

    combined_certified = sorted(set(expected_replayed) | {12})
    unresolved_single_outside = [
        coordinate for coordinate in range(13, 21) if coordinate not in combined_certified
    ]
    if combined_certified != [0, 1, 2, 3, 12] + list(range(21, 37)):
        raise RuntimeError("combined coordinate chart list changed")
    if unresolved_single_outside != list(range(13, 21)):
        raise RuntimeError("single-outside unresolved list changed")

    artifacts = [
        closed_path,
        closed_replay_path,
        charts_path,
        charts_replay_path,
        q12_path,
    ]
    payload = {
        "status": "PASS",
        "source_sha256": source_hash,
        "artifact_sha256": {path.name: sha256(path) for path in artifacts},
        "closed_L": {
            "degree_six_rank": 10296,
            "target_dimension": 10296,
            "independent_minor_determinant_mod_89": 28,
            "conclusion": "r256 and true Stage B are empty on L",
        },
        "single_outside_coordinate_layer": {
            "certified_coordinates": combined_certified,
            "independently_replayed_coordinates": expected_replayed,
            "producer_only_q12_degree3_coordinate": 12,
            "not_certified_coordinates": unresolved_single_outside,
        },
        "scope_guard": (
            "The single-outside-coordinate slices do not cover points with at "
            "least two nonzero coordinates outside L. No global Stage-B or P25 "
            "verdict is asserted."
        ),
        "audit_kind": (
            "lightweight stored-artifact consistency check; run the producer and "
            "heavy verifier scripts for exact linear-algebra replay"
        ),
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS: closed L and scoped one-coordinate certificates are consistent")
    print(f"wrote {OUTPUT.name}")


if __name__ == "__main__":
    main()
