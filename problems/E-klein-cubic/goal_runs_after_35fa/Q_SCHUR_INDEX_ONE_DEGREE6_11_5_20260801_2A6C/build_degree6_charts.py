#!/usr/bin/env python3
"""Build the 19 affine coefficient charts of the p=23 homogeneous system."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE / "degree6_chi0_p23.in"
DIMENSION = 19


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    lines = SOURCE.read_text().splitlines()
    assert lines[0].split(",") == [f"c{index}" for index in range(DIMENSION)]
    assert lines[1] == "23" and not lines[-1].endswith(",")
    records = []
    for chart in range(DIMENSION):
        path = HERE / f"degree6_chi0_p23_chart{chart:02d}.in"
        chart_lines = lines[:-1] + [lines[-1] + ",", f"c{chart}-1"]
        path.write_text("\n".join(chart_lines) + "\n")
        records.append(
            {
                "chart": chart,
                "normalization": f"c{chart}=1",
                "input_file": path.name,
                "input_sha256": sha256(path),
                "input_bytes": path.stat().st_size,
            }
        )
    payload = {
        "schema": "klein-f55-degree6-chi0-p23-affine-charts-v1",
        "source_file": SOURCE.name,
        "source_sha256": sha256(SOURCE),
        "prime": 23,
        "variables": DIMENSION,
        "charts_cover_projective_space": True,
        "records": records,
    }
    (HERE / "degree6_chi0_p23_charts.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(f"charts={len(records)} source_sha256={payload['source_sha256']}")
    print("Q_F55_DEGREE6_CHI0_P23_AFFINE_CHART_INPUTS_EXACT")


if __name__ == "__main__":
    main()
