#!/usr/bin/env python3
"""Hash-bound replay for the all-six A5 degree-11 secant audit."""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent


def project_root() -> Path:
    for candidate in (HERE, *HERE.parents):
        if (candidate / "goals_2026-08-01").is_dir() and (
            candidate / "goals_after_35fa8f"
        ).is_dir():
            return candidate
    raise AssertionError("E-klein-cubic project root not found")


REPOSITORY = project_root()
MARKER = "A5_DEGREE11_ALL_SIX_SECANT_DESCENT_AUDIT_OK"


def sha256(path: Path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def validate_payload(payload):
    assert payload["format"] == "A5-DEGREE11-SECANT-DESCENT-v1"
    assert payload["prime"] == 89
    assert payload["quadratic_extension"] == "F_89[u]/(u^2-65)"
    rows = payload["records"]
    assert len(rows) == 6
    assert [(row["class"], row["root_index"]) for row in rows] == [
        ("A5_class_1", 0),
        ("A5_class_1", 1),
        ("A5_class_1", 2),
        ("A5_class_2", 0),
        ("A5_class_2", 1),
        ("A5_class_2", 2),
    ]
    assert [row["alpha"] for row in rows] == [
        [80, 0], [21, 45], [21, 44], [49, 0], [51, 0], [75, 0]
    ]
    assert all(row["point_count"] == 11 for row in rows)
    assert all(row["point_linear_rank"] == 5 for row in rows)
    assert all(row["point_quadric_rank"] == 11 for row in rows)
    assert all(row["quadrics_through_points"] == 4 for row in rows)
    assert all(row["proper_pair_secants"] == 55 for row in rows)
    assert all(row["distinct_third_intersections"] == 55 for row in rows)
    assert all(row["pair_stabilizer_order"] == 12 for row in rows)
    assert all(
        row["pair_stabilizer_order_distribution"]
        == {"1": 1, "2": 7, "3": 2, "6": 2}
        for row in rows
    )
    assert all(row["third_intersection_linear_rank"] == 5 for row in rows)
    assert all(row["third_intersection_quadric_rank"] == 15 for row in rows)
    assert all(
        row["third_intersections_on_corresponding_d12_line"] == 0
        for row in rows
    )
    assert [
        row["third_intersection_d12_line_union_incidences"] for row in rows
    ] == [0, 0, 0, 1, 0, 1]
    expected_jacobians = [[4] * 11 for _ in rows]
    expected_jacobians[3][5] = 3
    for index, row in enumerate(rows):
        base = row["four_quadric_base"]
        assert base["quadric_kernel_dimension"] == 4
        assert base["quadric_base_affine_cone_dimension"] == 1
        assert base["quadric_base_h_vector"] == [1, 4, 6, 4, 1, 0]
        assert base["quadric_base_projective_degree"] == 16
        assert base["quadric_base_intersect_klein_affine_cone_dimension"] == 1
        assert base["quadric_base_intersect_klein_h_vector"] == [1, 4, 6, 3, -3, 0]
        assert base["quadric_base_intersect_klein_projective_degree"] == 11
        assert base["orbit_point_quadric_jacobian_ranks"] == expected_jacobians[index]
        assert base["linked_residual_affine_cone_dimension"] == 1
        assert base["linked_residual_h_vector"] == [1, 4, 0]
        assert base["linked_residual_projective_degree"] == 5
        assert base["linked_residual_linear_span_dimension"] == 4
        assert base["klein_vanishes_identically_on_linked_residual"] is False
    assert [
        row["four_quadric_base"]["linked_residual_plus_klein_affine_dimension"]
        for row in rows
    ] == [0, 0, 0, 1, 0, 0]
    assert [
        row["four_quadric_base"][
            "linked_residual_intersect_klein_degree_if_projective_nonempty"
        ]
        for row in rows
    ] == [0, 0, 0, 1, 0, 0]


def main():
    manifest = json.loads((HERE / "source_manifest.json").read_text())
    actual = {relative: sha256(REPOSITORY / relative) for relative in manifest}
    assert actual == manifest
    print("SOURCE_HASHES_OK", len(manifest))

    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["marker"] == MARKER
    sealed = {name: sha256(HERE / name) for name in seal["files"]}
    assert sealed == seal["files"]
    print("PACKET_SEAL_OK", len(sealed))

    upstream = HERE.parent / "a5_orbit_rnc_agent" / "verify.py"
    replay = subprocess.run(
        [sys.executable, "-u", str(upstream)],
        cwd=upstream.parent,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=360,
        check=True,
        env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
    )
    assert "A5_DEGREE11_TRANSFERRED_ORBITS_FAIL_RNC_QUADRIC_TEST_OK" in replay.stdout
    print("UPSTREAM_A5_RNC_PACKET_OK")

    analyzer = subprocess.run(
        [sys.executable, "-u", str(HERE / "analyze.py")],
        cwd=HERE,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=360,
        check=True,
        env={**os.environ, "PYTHONDONTWRITEBYTECODE": "1"},
    )
    assert "A5_ALL_SIX_DEGREE11_ORBITS_SECANT_AUDIT_OK" in analyzer.stdout
    payload = json.loads((HERE / "computed.json").read_text())
    validate_payload(payload)
    print("ALL_SIX_PARAMETER_ROOTS_OK")
    print("ALL_SIX_LINEAR_AND_QUADRIC_RANKS_OK")
    print("ALL_330_SECANTS_PROPER_AND_RESIDUALS_DISTINCT")
    print("ALL_PAIR_STABILIZERS_D12")
    print("CORRESPONDING_D12_LINE_INCIDENCES_ZERO")
    print("FOUR_QUADRIC_BASE_16_AND_KLEIN_INTERSECTION_11")
    print("LINKED_RESIDUAL_DEGREE5_FULL_SPAN_NOT_CONTAINED_IN_KLEIN")

    assert 11 * 10 + 55 == 55 * 3 == 165
    assert 11 * 10 // 2 == 55
    print("SECANT_CH0_RELATION_DEGREES_OK")
    print("STATUS Q-UNDECIDED")
    print(MARKER)


if __name__ == "__main__":
    main()
