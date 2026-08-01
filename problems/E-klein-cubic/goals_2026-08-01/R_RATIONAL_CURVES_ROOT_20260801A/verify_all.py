#!/usr/bin/env python3
"""Independent top-level verifier for the Goal R structural packet."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import subprocess
import sys


HERE = Path(__file__).resolve().parent
PROBLEM_ROOT = HERE.parents[1]
PYTHON = Path("/opt/homebrew/bin/python3")
if not PYTHON.exists():
    PYTHON = Path(sys.executable)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def run(script: Path, required_marker: str) -> None:
    completed = subprocess.run(
        [str(PYTHON), str(script)],
        cwd=script.parent,
        text=True,
        capture_output=True,
        check=True,
    )
    output = completed.stdout + completed.stderr
    if required_marker not in output:
        raise AssertionError(f"missing marker {required_marker!r} from {script}:\n{output}")
    print(required_marker)


def verify_static_payloads() -> None:
    status = (HERE / "STATUS.md").read_text(encoding="utf-8")
    theorem = (HERE / "THEOREM.md").read_text(encoding="utf-8")
    inventory_markdown = (HERE / "HILBERT_INVENTORY.md").read_text(encoding="utf-8")
    assert status.splitlines()[0] == "R-HILBERT-COMPONENT-STRUCTURAL"
    assert "headline remains **OPEN**" in status
    assert "H^1(G,J[3])=0" in status
    assert "Theorem R.5 -- elliptic normal quintics" in theorem
    assert "operatorname{ind}(A_{\\rm proj})=2" in theorem
    assert "generic cubic" in theorem and "Neither hypothesis is available" in theorem
    assert "A degree cutoff is not promoted to an all-degree theorem" in inventory_markdown

    inventory = json.loads((HERE / "component_inventory.json").read_text(encoding="utf-8"))
    assert inventory["schema"] == "klein-rational-curve-inventory-v2"
    assert inventory["cutoff"] == 5
    assert inventory["exit"] == status.splitlines()[0]
    assert inventory["headline"] == "OPEN"
    rows = {(row["degree"], row["locus"]): row for row in inventory["degrees"]}
    assert rows[(2, "geometrically integral conics")]["status"] == "empty"
    assert rows[(4, "rational normal quartics")]["status"] == "open"
    quintic = rows[(5, "elliptic normal quintics")]
    assert quintic["status"] == "empty"
    assert "index two" in quintic["reason"]

    structural = json.loads((HERE / "structural_payload.json").read_text(encoding="utf-8"))
    assert structural["schema"] == "klein-rational-curve-structural-v2"
    assert structural["exit"] == "R-HILBERT-COMPONENT-STRUCTURAL"
    assert structural["headline"] == "OPEN"
    assert structural["pinned_baseline"] == "715faf441289e2589b9325311b6613ea0331bf88"
    for name, expected in structural["source_hashes"].items():
        assert sha256(HERE / name) == expected, name

    fixed = json.loads((HERE / "fixed_jacobian_payload.json").read_text(encoding="utf-8"))
    assert fixed["deduction"]["fixed_subgroup"] == "trivial"
    assert fixed["checks"]["common_fixed_equations_rank_mod_5"] == 10
    assert fixed["checks"]["common_fixed_equations_rank_mod_11"] == 10

    cohomology = json.loads((HERE / "group_cohomology_payload.json").read_text(encoding="utf-8"))
    assert cohomology["group_order"] == 660
    assert cohomology["checks"]["Z1_dimension_mod_3"] == 10
    assert cohomology["checks"]["B1_dimension_mod_3"] == 10
    assert cohomology["checks"]["H1_dimension_mod_3"] == 0
    print("STATIC_STRUCTURAL_PAYLOADS_OK")


def verify_local_certificates() -> None:
    run(HERE / "produce_fixed_jacobian.py", "KLEIN_JACOBIAN_COMMON_FIXED_SUBGROUP_TRIVIAL")
    run(HERE / "verify_fixed_jacobian.py", "KLEIN_JACOBIAN_COMMON_FIXED_SUBGROUP_TRIVIAL")
    run(HERE / "probe_full_group_h1_mod3.py", "KLEIN_JACOBIAN_H1_MOD_3_TRIVIAL")
    run(HERE / "verify_group_cohomology.py", "KLEIN_JACOBIAN_H1_MOD_3_TRIVIAL")
    print("LOCAL_EXACT_CERTIFICATES_OK")


def verify_repository_dependencies() -> None:
    structural = json.loads((HERE / "structural_payload.json").read_text(encoding="utf-8"))
    for relative, expected in structural["repository_dependencies"].items():
        path = PROBLEM_ROOT / relative
        assert path.is_file(), path
        assert sha256(path) == expected, path

    schur_certificate = json.loads(
        (PROBLEM_ROOT / "tmp/pfaffian_generic_schur_audit/certificate.json").read_text(encoding="utf-8")
    )
    assert schur_certificate["format"] == "pfaffian-generic-schur-gate-v1"
    assert schur_certificate["generic_index"] == 2
    assert schur_certificate["generic_schur_class"] == "nonzero of index two"

    run(
        PROBLEM_ROOT / "tmp/pfaffian_generic_schur_audit/verify.py",
        "PFAFFIAN_GENERIC_SCHUR_GATE_SEALED",
    )
    run(
        PROBLEM_ROOT / "tmp/pfaffian_representation_alignment_audit/verify.py",
        "PFAFFIAN_REPRESENTATION_ALIGNMENT_AUDIT_ACCEPT",
    )
    print("PINNED_REPOSITORY_DEPENDENCIES_OK")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--with-repository-dependencies",
        action="store_true",
        help="also hash and replay the pinned Pfaffian/Schur repository dependencies",
    )
    arguments = parser.parse_args()
    verify_local_certificates()
    verify_static_payloads()
    if arguments.with_repository_dependencies:
        verify_repository_dependencies()
    print("R_RATIONAL_CURVES_STRUCTURAL_PACKET_VERIFIED")


if __name__ == "__main__":
    main()
