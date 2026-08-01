#!/opt/homebrew/bin/python3
"""Top-level requirement and replay audit for Goal R2."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
PROBLEM_ROOT = HERE.parents[1]
PYTHON = "/opt/homebrew/bin/python3"

REQUIRED_FILES = (
    "CLASS_RANKING.md",
    "COMPLETION_AUDIT.md",
    "DESCENDED_HILBERT_COMPONENT.md",
    "POINT_EXTRACTION.md",
    "REPLAY.md",
    "SOURCES.md",
    "STATUS.md",
    "UNIVERSAL_CURVE_EQUATIONS.md",
    "descended_hilbert_payload.json",
    "make_seal.py",
    "pfaffian_quintic_universal.json",
    "produce_descended_component.py",
    "produce_pfaffian_universal.py",
    "source_manifest.json",
    "verify_all.py",
    "verify_descended_component.py",
    "verify_pfaffian_universal.py",
    "verify_seal.py",
)


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def run(script: str, marker: str) -> None:
    completed = subprocess.run(
        [PYTHON, str(HERE / script)],
        cwd=HERE,
        text=True,
        capture_output=True,
        check=True,
    )
    output = completed.stdout + completed.stderr
    assert marker in output, (script, marker, output)
    print(marker)


def verify_contract() -> None:
    for name in REQUIRED_FILES:
        assert (HERE / name).is_file(), name

    status = (HERE / "STATUS.md").read_text(encoding="utf-8")
    assert status.splitlines()[0] == "R2-DESCENT-OBSTRUCTED"
    assert "Problem E headline remains **OPEN**" in status

    ranking = (HERE / "CLASS_RANKING.md").read_text(encoding="utf-8")
    for phrase in (
        "lines",
        "integral conics",
        "generalized twisted cubics",
        "rational normal quartics",
        "rational quintics",
        "free rational curves",
        "degree-55 closed orbit",
    ):
        assert phrase in ranking, phrase

    completion = (HERE / "COMPLETION_AUDIT.md").read_text(encoding="utf-8")
    assert "`R2-DESCENT-OBSTRUCTED`: **achieved**" in completion
    assert "Problem E headline: **OPEN**" in completion
    print("R2_OUTPUT_CONTRACT_OK")


def verify_sources() -> None:
    manifest = load(HERE / "source_manifest.json")
    assert manifest["schema"] == "klein-r2-source-manifest-v1"
    assert manifest["pinned_commit"] == "35fa8f59b6a1423cc89300aeaceefe91552be5ba"
    for entry in manifest["dependencies"]:
        path = PROBLEM_ROOT / entry["path"]
        assert path.is_file(), path
        assert digest(path) == entry["sha256"], path

    inherited_path = PROBLEM_ROOT / (
        "goals_2026-08-01/R_RATIONAL_CURVES_ROOT_JACOBIAN_ZERO/source_manifest.json"
    )
    inherited_manifest = load(inherited_path)
    assert inherited_manifest["format"] == "R-RATIONAL-CURVES-SOURCE-MANIFEST-v1"
    for entry in inherited_manifest["sources"]:
        path = inherited_path.parent / entry["path"]
        assert path.is_file(), path
        assert digest(path) == entry["sha256"], path
    print("R2_PINNED_PRIMARY_SOURCES_OK")


def verify_payload_boundaries() -> None:
    universal = load(HERE / "pfaffian_quintic_universal.json")
    assert universal["schema"] == "klein-pfaffian-elliptic-quintic-universal-v1"
    assert len(universal["pfaffian_matrix_upper"]) == 15
    assert len(universal["pfaffian_adjugate_upper"]) == 15
    assert len(universal["equations_bihomogeneous_x2_lambda1"]) == 6
    assert universal["geometric_interpretation"]["expected_degree"] == 5
    assert universal["geometric_interpretation"]["expected_arithmetic_genus"] == 1
    assert universal["sample_mod_23"]["expected"]["tangent_dimension_on_cubic"] == 10
    assert universal["sample_mod_23"]["expected"]["normal_h1"] == 0

    descended = load(HERE / "descended_hilbert_payload.json")
    assert descended["schema"] == "klein-r2-descended-elliptic-quintic-v1"
    assert descended["exit"] == "R2-DESCENT-OBSTRUCTED"
    assert descended["headline"] == "OPEN"
    assert descended["descent_obstruction"]["index"] == 2
    assert descended["descent_obstruction"]["component_K_points"] == "empty"
    assert descended["universal_curve_on_genuine_twist"]["base_field_member"] is False
    assert descended["point_extraction_boundary"]["result"].startswith("no curve and no point")
    print("R2_PAYLOAD_SCOPE_OK")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--full",
        action="store_true",
        help="replay all independent repository-dependency verifiers",
    )
    args = parser.parse_args()

    verify_contract()
    verify_sources()

    run("produce_pfaffian_universal.py", "R2_PFAFFIAN_UNIVERSAL_EQUATIONS_CERTIFIED")
    run(
        "produce_descended_component.py",
        "R2_DESCENDED_ELLIPTIC_QUINTIC_OBSTRUCTION_CERTIFIED",
    )
    verify_payload_boundaries()

    if args.full:
        run(
            "verify_descended_component.py",
            "R2_DESCENDED_COMPONENT_INDEPENDENT_VERIFY_OK",
        )
        print("R2_PACKET_FULL_VERIFY_OK")
    else:
        run(
            "verify_pfaffian_universal.py",
            "R2_PFAFFIAN_UNIVERSAL_INDEPENDENT_VERIFY_OK",
        )
        print("R2_PACKET_VERIFY_OK")


if __name__ == "__main__":
    main()
