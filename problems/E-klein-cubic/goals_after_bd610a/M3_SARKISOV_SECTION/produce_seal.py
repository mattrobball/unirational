#!/usr/bin/env python3
"""Produce the deterministic recursive seal for the durable M3 packet."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
SEAL_PATH = HERE / "SEAL.json"
STATUS_PATH = HERE / "STATUS.md"
MANIFEST_PATH = HERE / "INPUT_MANIFEST.json"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def sealed_files() -> dict[str, str]:
    return {
        str(path.relative_to(HERE)): digest(path)
        for path in sorted(HERE.rglob("*"))
        if path.is_file()
        and path.name != SEAL_PATH.name
        and "__pycache__" not in path.parts
        and path.suffix != ".pyc"
    }


def status_fields() -> tuple[str, dict[str, str]]:
    lines = STATUS_PATH.read_text().splitlines()
    assert lines and lines[0] == "M3-INTEGRAL-DEGREE4-MULTISECTION"
    fields = {
        key.strip(): value.strip()
        for line in lines[1:]
        if ":" in line
        for key, value in [line.split(":", 1)]
    }
    assert fields["section_question"] == "UNDECIDED"
    assert fields["headline"] == "OPEN"
    assert fields["field"] == "K_Schur=C(P(V6))^PSL2(F11)"
    assert "M3-UNDECIDED" not in STATUS_PATH.read_text()
    return lines[0], fields


def build() -> dict:
    terminal_exit, fields = status_fields()
    assert MANIFEST_PATH.is_file()
    assert not (HERE / "POINT.md").exists()
    assert not (HERE / "BRIDGE_SARKISOV_POS.md").exists()
    return {
        "schema": "m3-sarkisov-section-seal-v1",
        "producer": "produce_seal.py",
        "terminal_exit": terminal_exit,
        "section_question": fields["section_question"],
        "headline": fields["headline"],
        "base_field": fields["field"],
        "pinned_state": "bd610a032bb9561d2daeb91a2cb60c48c082ca2f",
        "input_manifest_sha256": digest(MANIFEST_PATH),
        "theorem_ledger": {
            "integral_exact_degree_four_closed_point": True,
            "integral_finite_flat_degree_four_multisection": True,
            "coordinate_free_existence_only": True,
        },
        "strict_boundaries": {
            "explicit_quartic_coordinates": False,
            "rational_section": False,
            "authoritative_twist_point": False,
            "positive_versality_bridge": False,
            "actual_geometric_27_line_monodromy": False,
            "actual_arithmetic_27_line_monodromy": False,
            "algebraic_brauer_group_computed": False,
            "characteristic_zero_pair_residual_descent": False,
        },
        "files": sealed_files(),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    rendered = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if args.write:
        SEAL_PATH.write_text(rendered)
        print(f"WROTE {SEAL_PATH}")
    else:
        print(rendered, end="")


if __name__ == "__main__":
    main()
