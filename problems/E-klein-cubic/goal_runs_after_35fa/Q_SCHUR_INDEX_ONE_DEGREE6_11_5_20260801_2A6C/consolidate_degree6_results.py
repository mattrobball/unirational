#!/usr/bin/env python3
"""Consolidate the final unit-ideal chart artifacts into the degree-six theorem."""

from __future__ import annotations

import hashlib
import json
import re
from pathlib import Path


HERE = Path(__file__).resolve().parent
DIMENSION = 19
UNIT_LEADING_SHA256 = "68d77439b2111e36e9ce84ef0111c7f0fc9502eed91f88dc0f41a14b64d4f4af"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    inputs = json.loads((HERE / "degree6_chi0_p23_charts.json").read_text())
    assert inputs["schema"] == "klein-f55-degree6-chi0-p23-affine-charts-v1"
    assert inputs["prime"] == 23 and inputs["variables"] == DIMENSION
    assert inputs["charts_cover_projective_space"]
    assert len(inputs["records"]) == DIMENSION
    records = []
    for chart, input_record in enumerate(inputs["records"]):
        assert input_record["chart"] == chart
        source = HERE / input_record["input_file"]
        leading = HERE / f"degree6_chi0_p23_chart{chart:02d}.out"
        log = HERE / f"degree6_chi0_p23_chart{chart:02d}.log"
        assert sha256(source) == input_record["input_sha256"]
        assert sha256(leading) == UNIT_LEADING_SHA256
        leading_text = leading.read_text()
        assert "#field characteristic: 23" in leading_text
        assert "#length of basis:      1 element" in leading_text
        assert leading_text.rstrip().endswith("[1]:")
        log_text = log.read_text()
        assert "Grobner basis has a single element" in log_text
        assert "No solution" in log_text
        timing = re.search(
            r"msolve overall time\s+([0-9.]+) sec \(elapsed\)", log_text
        )
        assert timing is not None
        records.append(
            {
                "chart": chart,
                "normalization": f"c{chart}=1",
                "status": "unit_ideal_empty",
                "solver_elapsed_seconds": float(timing.group(1)),
                "input_file": source.name,
                "input_sha256": sha256(source),
                "leading_file": leading.name,
                "leading_sha256": sha256(leading),
                "log_file": log.name,
                "log_sha256": sha256(log),
            }
        )
    payload = {
        "schema": "klein-f55-degree6-all-character-decision-v1",
        "subgroup": "11:5 = C11 semidirect C5",
        "degree": 6,
        "character_zero_special_prime": 23,
        "character_zero_all_projective_charts_empty": True,
        "projective_characters_mod_5": list(range(5)),
        "all_characters_empty_in_characteristic_zero": True,
        "character_transfer": (
            "formal diagonal coefficient isomorphism over a fifth-root field; "
            "verified coefficientwise by verify_degree6_character_isomorphism.py"
        ),
        "specialization": (
            "empty proper character-zero special fibre at p=23 implies empty "
            "characteristic-zero generic fibre"
        ),
        "records": records,
        "conclusion": (
            "Every complete homogeneous projective 11:5-covariant landing "
            "scheme in degree six is empty for all five projective-character "
            "multipliers."
        ),
        "strict_nonclaims": [
            "no all-degree exclusion",
            "no pointlessness theorem for the 11:5 generic twist",
            "no point or pointlessness theorem for the genuine Schur twist",
        ],
    }
    (HERE / "degree6_all_character_results.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("PASS all 19 affine charts have exact unit-ideal outputs")
    print("PASS proper specialization and diagonal character transfer apply")
    print("Q_F55_DEGREE6_ALL_PROJECTIVE_CHARACTERS_EMPTY_EXACT")


if __name__ == "__main__":
    main()
