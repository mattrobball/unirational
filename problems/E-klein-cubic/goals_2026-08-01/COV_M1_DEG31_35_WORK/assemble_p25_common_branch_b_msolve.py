#!/usr/bin/env python3
"""Assemble the seven unit-chart certificates closing common P25 branch B."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    common = HERE / "p25_common_nonbased_branches.json"
    boundary = HERE / "p25_d31_pure_second_cubic_span.json"
    records = []
    for chart in range(7):
        path = HERE / f"p25_common_branch_b_chart{chart}_p463.msolve.out"
        text = path.read_text()
        assert "#length of basis:      1 element" in text
        assert text.rstrip().endswith("[1]:")
        records.append({
            "chart": chart,
            "normalization": f"branch_B_scalar_form_{chart}=1",
            "payload": path.name,
            "payload_sha256": sha256(path),
            "rebuild_input_command": (
                "/opt/homebrew/bin/python3 -B "
                f"export_p25_common_branch_b_msolve.py --chart {chart}"
            ),
            "replay_command": (
                f"/opt/homebrew/bin/msolve -f p25_common_branch_b_chart{chart}_p463.in "
                f"-o p25_common_branch_b_chart{chart}_p463.msolve.out -g 1 -t 8"
            ),
        })
    output = HERE / "p25_common_branch_b_msolve.json"
    output.write_text(json.dumps({
        "schema": "cov-m1-p25-common-branch-b-msolve-v1",
        "prime": 463,
        "branch_dimension": 20,
        "scalar_cover_rank": 7,
        "complete_cubic_span_rank": 574,
        "complete_cubic_monomial_count": 1540,
        "common_branch_record": common.name,
        "common_branch_record_sha256": sha256(common),
        "scalar_zero_boundary_record": boundary.name,
        "scalar_zero_boundary_record_sha256": sha256(boundary),
        "closed_charts": records,
        "conclusion": (
            "all seven nonzero-scalar charts have exact unit Groebner bases; "
            "the common scalar-zero boundary is contained in the separately "
            "empty degree-31 pure-second tree, so common branch B is "
            "projectively empty over F_463 and in characteristic zero by "
            "proper specialization"
        ),
        "scope": (
            "the intrinsic 20-dimensional P25 branch realized as degree-31 "
            "first-normal nonbased and degree-35 mixed-second nonbased; common "
            "branch A and P25.2 remain undecided"
        ),
    }, indent=2, sort_keys=True) + "\n")
    print("P25_COMMON_BRANCH_B_7_UNIT_CHARTS_ASSEMBLED")


if __name__ == "__main__":
    main()
