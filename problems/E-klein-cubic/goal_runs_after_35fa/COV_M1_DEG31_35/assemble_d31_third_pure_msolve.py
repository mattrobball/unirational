#!/usr/bin/env python3
"""Assemble the two exact msolve unit-chart records for degree 31."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import struct

import numpy as np


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def payload(path: Path) -> dict:
    return {
        "payload": str(path.relative_to(HERE)),
        "payload_sha256": sha256(path),
    }


def main() -> None:
    source = HERE / "degree_31/d31_third_pure_scalar_cubes_p463.npz"
    profile = HERE / "degree_31/d31_third_pure_scalar_cubes_p463.bin.rows"
    with np.load(source, allow_pickle=False) as frozen:
        coefficients = frozen["landing_cubic_coefficients"]
        monomials = frozen["cubic_monomials"]
        scalars = frozen["independent_scalar_forms"]
    with profile.open("rb") as stream:
        count = struct.unpack("<Q", stream.read(8))[0]
        rows = np.frombuffer(stream.read(), dtype="<u8")
    assert coefficients.shape == (5349, 8436)
    assert monomials.shape == (8436, 3)
    assert scalars.shape == (6, 36)
    assert len(rows) == count == 1198
    chart_records = []
    for chart in (0, 1):
        output = HERE / (
            f"degree_31/d31_third_pure_chart{chart}_p463.msolve.out"
        )
        text = output.read_text()
        assert "#length of basis:      1 element" in text
        assert text.rstrip().endswith("[1]:")
        chart_records.append({
            "chart": chart,
            "normalization": f"scalar_form_{chart}=1",
            **payload(output),
            "rebuild_input_command": (
                "/opt/homebrew/bin/python3 -B -u "
                f"export_d31_third_pure_msolve.py --chart {chart} "
                "--cover original --mode normalize"
            ),
            "replay_command": (
                "/opt/homebrew/bin/msolve -f "
                f"degree_31/d31_third_pure_chart{chart}_p463.in "
                f"-o degree_31/d31_third_pure_chart{chart}_p463.msolve.out "
                "-g 1"
            ),
            "conclusion": "the normalized affine chart has exact Groebner basis [1]",
        })
    result = {
        "schema": "cov-m1-d31-third-pure-msolve-v1",
        "prime": 463,
        "gate_dimension": 36,
        "complete_landing_equation_count": 5349,
        "cubic_monomial_count": 8436,
        "landing_cubic_span_rank": 1198,
        "leading_scalar_rank": 6,
        "compact_source": payload(source),
        "fixed_row_profile": payload(profile),
        "closed_charts": chart_records,
        "remaining_cover": {
            "equations": ["scalar_form_0=0", "scalar_form_1=0"],
            "remaining_scalar_rank": 4,
            "normalization_chart_count": 4,
        },
        "scope": (
            "two of six degree-31 pure-third nonbased charts are empty over "
            "F_463, leaving four charts only in that special fibre; all six "
            "prime-specific affine charts remain open for the characteristic-zero "
            "landing scheme"
        ),
        "decision_status": (
            "two exact special-fibre unit charts; no characteristic-zero affine "
            "closure inferred"
        ),
    }
    output = HERE / "d31_third_pure_msolve.json"
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(f"wrote {output.name}")


if __name__ == "__main__":
    main()
