#!/usr/bin/env python3
"""Produce the hash seal for the terminal Goal F emptiness packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
FILES = (
    "STATUS.md",
    "INPUTS.md",
    "CRITERION.md",
    "INFINITY_OBSTRUCTION.md",
    "DISCOVERY.md",
    "FIELD_PRESENTATION.md",
    "REPLAY.md",
    "WORKLOG.md",
    "field_presentation.json",
    "payload/determinant_matrix_cells_exact.tsv",
    "payload/global_parameter_content_exact.tsv",
    "payload/global_primitive_u_sextic_exact.tsv",
    "verify_field_presentation.py",
    "infinity_obstruction.json",
    "produce_infinity_obstruction.py",
    "verify_infinity_obstruction.py",
    "produce_seal.py",
    "build_coefficient_divisor_factors.py",
    "build_infinity_net_basepoint.py",
    "infinity_net_basepoint_p89.json",
    "verify.py",
    "linear_ansatz_p67.json",
    "linear_ansatz_p67.out",
    "line_constant_basis_p67.json",
    "line_constant_basis_p67.out",
)


def digest(path: Path) -> str:
    value = hashlib.sha256()
    value.update(path.read_bytes())
    return value.hexdigest()


def main() -> None:
    payload = {
        "format": "goal-F-conic-algebra-empty-v1",
        "exit": "F-CONIC-CRITERION-EMPTY",
        "headline": "OPEN",
        "proved": [
            "exact degree-six field presentation and selected embedding",
            "exact bidirectional point/conic criterion reduction",
            "a reciprocal-infinity place of K_proj has ramification index one and residue degree one",
            "the residual normalized net has index three by an exact class-group localization argument",
            "C(K_proj) is empty and hence the full conic-intersection criterion is empty",
            "bounded screens only at their recorded scopes",
        ],
        "not_proved": [
            "Klein cubic unirationality or non-unirationality",
            "pointlessness of the genuine generic Klein twist",
        ],
        "scope": "auxiliary fixed-frame plane cubic and its exhaustive conic criterion",
        "sha256": {relative: digest(HERE / relative) for relative in FILES},
    }
    (HERE / "SEAL.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("GOAL_F_SEAL_WRITTEN")


if __name__ == "__main__":
    main()
