#!/usr/bin/env python3
"""Independent replay for the transferred A5-orbit RNC exclusion."""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
REPOSITORY = HERE.parents[3]
POINT = REPOSITORY / "goals_after_35fa8f" / "point_attack_degree11_20260801"
MARKER = "A5_DEGREE11_TRANSFERRED_ORBITS_FAIL_RNC_QUADRIC_TEST_OK"


def sha256(path: Path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    payload = json.loads((HERE / "payload.json").read_text())
    manifest = json.loads((HERE / "source_manifest.json").read_text())
    assert payload["marker"] == MARKER
    assert payload["scope"]["status"] == "Q-UNDECIDED"
    assert payload["scope"]["not_proved"] == [
        "no other E^H-rational point has an eleven-point orbit on a rational normal quartic",
        "no other Hilbert-90 transfer column or rational source section succeeds",
        "the eleven points lie on no other useful K-defined curve",
        "a rational point or pointlessness for the full Schur twist",
    ]
    actual = {relative: sha256(REPOSITORY / relative) for relative in manifest}
    assert actual == manifest
    print("SOURCE_HASHES_OK", len(manifest))

    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["marker"] == MARKER
    sealed = {name: sha256(HERE / name) for name in seal["files"]}
    assert sealed == seal["files"]
    print("PACKET_SEAL_OK", len(sealed))

    upstream = subprocess.run(
        [sys.executable, "-u", str(POINT / "verify_exact_point.py")],
        cwd=POINT,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=300,
        check=True,
        env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
    )
    assert "H3_EXACT_BOTH_A5_POINTS_VERIFIED" in upstream.stdout, upstream.stdout
    assert "installed_class_ratios_are_distinct_roots_of_9t^2-13t+5" in upstream.stdout
    assert "class_2_all_six_exact_landing_values=0_in_K(alpha_plus)" in upstream.stdout
    assert "class_1_all_six_conjugate_landing_values=0_in_K(alpha_minus)" in upstream.stdout
    print("UPSTREAM_EXACT_A5_POINTS_OK")

    probe = subprocess.run(
        [sys.executable, "-u", str(HERE / "probe_rnc_rank.py")],
        cwd=HERE,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=300,
        check=True,
        env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
    )
    output = probe.stdout
    assert "A5_ORBIT_RNC_GOOD_PRIME_PROBE_OK" in output, output
    assert "A5_class_1 FULL_SOURCE_POINT (1, 4, 5, 5, 6) TRANSFER_DET 64" in output
    assert "A5_class_2 FULL_SOURCE_POINT (1, 4, 5, 5, 6) TRANSFER_DET 73" in output
    expected_rows = [
        "A5_class_1 ROOT_INDEX 0 PARAMETERS (1, 25, 36, 32, 80) DISTINCT 11 QUADRIC_EVAL_RANK 11 QUADRICS_THROUGH 4",
        "A5_class_2 ROOT_INDEX 0 PARAMETERS (1, 55, 87, 56, 49) DISTINCT 11 QUADRIC_EVAL_RANK 11 QUADRICS_THROUGH 4",
        "A5_class_2 ROOT_INDEX 1 PARAMETERS (1, 61, 10, 37, 51) DISTINCT 11 QUADRIC_EVAL_RANK 11 QUADRICS_THROUGH 4",
        "A5_class_2 ROOT_INDEX 2 PARAMETERS (1, 12, 46, 22, 75) DISTINCT 11 QUADRIC_EVAL_RANK 11 QUADRICS_THROUGH 4",
    ]
    for row in expected_rows:
        assert row in output, row
    assert output.count("RNC_QUADRIC_NECESSARY_CONDITION_FAILS") == 4

    results = payload["results"]
    assert len(results) == 4
    assert all(row["distinct_conjugates"] == 11 for row in results)
    assert all(row["quadric_evaluation_rank"] == 11 for row in results)
    assert all(row["quadrics_through_conjugates"] == 4 for row in results)
    assert all(row["rational_normal_quartic"] is False for row in results)
    print("ELEVEN_CONJUGATES_DISTINCT_AND_ON_KLEIN", len(results))
    print("QUADRIC_EVALUATION_RANK", 11)
    print("RNC_MAXIMUM_ALLOWED_RANK", 9)
    print("TRANSFERRED_A5_ORBITS_ON_RNC", False)
    print("STATUS Q-UNDECIDED")
    print(MARKER)


if __name__ == "__main__":
    main()
