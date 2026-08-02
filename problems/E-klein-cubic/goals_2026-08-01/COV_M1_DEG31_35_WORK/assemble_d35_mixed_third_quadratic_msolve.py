#!/usr/bin/env python3
"""Assemble the nine exact unit charts for the d35 mixed-third branch."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

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
    source = HERE / "degree_35/d35_mixed_third_quadratic_span_p463.npz"
    with np.load(source, allow_pickle=False) as frozen:
        assert frozen["tangent_kernel_basis"].shape == (361, 39)
        assert frozen["quadratic_monomials"].shape == (780, 2)
        coefficient_shape = list(map(
            int, frozen["quadratic_coefficient_matrix"].shape
        ))
    charts = []
    for chart in range(9):
        input_path = HERE / (
            "degree_35/d35_mixed_third_quadratic_"
            f"chart{chart}_p463.eliminated.in"
        )
        output = HERE / (
            "degree_35/d35_mixed_third_quadratic_"
            f"chart{chart}_p463.eliminated.msolve.out"
        )
        text = output.read_text()
        assert "#length of basis:      1 element" in text
        assert text.rstrip().endswith("[1]:")
        charts.append({
            "chart": chart,
            "variables": 38,
            "equation_count": 137,
            "input": str(input_path.relative_to(HERE)),
            "input_sha256": sha256(input_path),
            "payload": str(output.relative_to(HERE)),
            "payload_sha256": sha256(output),
            "rebuild_input_command": (
                "/opt/homebrew/bin/python3 -B -u "
                "emit_d35_mixed_third_quadratic_chart.py "
                f"--chart {chart} --format msolve --eliminate-chart-form"
            ),
            "replay_command": (
                "/opt/homebrew/bin/msolve -f "
                f"degree_35/{input_path.name} -o "
                f"degree_35/{output.name} -g 1 -t 8 -v 1"
            ),
            "conclusion": "the exactly eliminated affine quadratic chart has Groebner basis [1]",
        })
    result = {
        "schema": "cov-m1-d35-mixed-third-quadratic-msolve-v1",
        "prime": 463,
        "tangent_gate_dimension": 39,
        "leading_scalar_rank": 9,
        "quadratic_monomial_count": 780,
        "quadratic_span_rank": 137,
        "quadratic_coefficient_matrix_shape": coefficient_shape,
        "compact_semantic_source": payload(source),
        "emitter": payload(HERE / "emit_d35_mixed_third_quadratic_chart.py"),
        "closed_charts": charts,
        "scope": (
            "all nine tangent-reduced degree-35 mixed-third nonbased charts "
            "are empty over F_463"
        ),
        "decision_status": (
            "complete special-fibre nonbased cover closed; combine with the "
            "sealed deep projective-tail certificate for the full continuation"
        ),
    }
    output = HERE / "d35_mixed_third_quadratic_msolve.json"
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(f"wrote {output.name}")


if __name__ == "__main__":
    main()
