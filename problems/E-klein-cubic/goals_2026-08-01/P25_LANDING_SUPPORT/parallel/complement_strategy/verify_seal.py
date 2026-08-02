#!/usr/bin/env python3
"""Independently verify hashes and theorem-boundary fields in SEAL.json."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    seal = json.loads((ROOT / "SEAL.json").read_text())
    assert seal["schema"] == "P25_COMPLEMENT_STRATEGY_SEAL_V1"
    assert seal["status"] == "P25_COMPLEMENT_STRATEGY_UNDECIDED_EXACT_AUDIT"
    assert seal["global_theorem_status"] == "P25-UNDECIDED"

    old = seal["exact_conclusions"]["old_r48_retired_on_H8_complement"]
    assert old["point"] == "q=e12"
    assert [old["P3_rank"], old["P3_target_rank"]] == [4, 6]
    assert [old["augmented_rank"], old["augmented_target_rank"]] == [4, 7]
    assert old["stageB_witness_b1"] == [54, 14, 19, 35, 1, 0]
    assert old["normalized_stageC_witness_b1"] == [74, 51, 64, 74, 0, 0]

    exact = seal["exact_conclusions"]
    assert exact["closed_L8_stageB_empty"] is True
    assert exact["closed_L8_stageC_empty"] is True
    assert exact["r64_viable_cover"]["chart_count"] == 29
    assert exact["r64_viable_cover"]["completed_unit_charts_in_this_packet"] == 0
    assert exact["faithful_stageA_plus_B_free_block"] == {
        "all_free_minor_rank": 6_734_578,
        "all_free_quotient_dimension": 2_534_087,
    }
    obstruction = exact["quadratic_full_span_refuted"]
    assert obstruction["stageA_plus_B_degree_two_lower_bound"] == 24_252
    assert obstruction["all_stages_degree_two_lower_bound"] == 5_379_706

    for name, recorded in seal["artifact_manifest"].items():
        path = ROOT / name
        assert path.is_file(), name
        assert path.stat().st_size == recorded["bytes"], name
        assert sha256(path) == recorded["sha256"], name

    # Cross-check the decisive fields against producer JSON, not only the seal.
    audit = json.loads((ROOT / "audit_result.json").read_text())
    dimensions = json.loads(
        (ROOT / "faithful_segre_dimension_result.json").read_text()
    )
    assert audit["status"] == "PASS_EXACT_INPUT_AUDIT_NONVERDICT"
    assert audit["exact_checks"]["old_r48_has_forced_H8_complement_defect_at_e12"]
    assert dimensions["status"] == (
        "PASS_QUADRATIC_FULL_SPAN_REFUTED_BY_EXACT_DIMENSIONS"
    )
    assert dimensions["scope_guard"].startswith(
        "Failure of quadratic full span is not a point"
    )

    print("PASS_COMPLEMENT_STRATEGY_SEAL")


if __name__ == "__main__":
    main()
