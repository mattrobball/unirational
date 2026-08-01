#!/opt/homebrew/bin/python3
"""Independent verifier for the R2 descended-component obstruction."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import subprocess


HERE = Path(__file__).resolve().parent
PROBLEM_ROOT = HERE.parents[1]


def digest(path: Path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(path: Path, marker: str):
    completed = subprocess.run(
        ["/opt/homebrew/bin/python3", str(path)],
        cwd=path.parent,
        text=True,
        capture_output=True,
        check=True,
    )
    output = completed.stdout + completed.stderr
    assert marker in output, (path, marker, output)
    print(marker)


def main() -> None:
    payload = json.loads((HERE / "descended_hilbert_payload.json").read_text(encoding="utf-8"))
    assert payload["schema"] == "klein-r2-descended-elliptic-quintic-v1"
    assert payload["exit"] == "R2-DESCENT-OBSTRUCTED"
    assert payload["headline"] == "OPEN"
    assert payload["selected_component"]["hilbert_polynomial"] == "5*t"
    assert payload["selected_component"]["tangent_dimension"] == 10
    assert payload["selected_component"]["obstruction_h1_normal"] == 0
    assert payload["descent_obstruction"]["index"] == 2
    assert payload["descent_obstruction"]["rational_points"] == "empty"
    assert payload["universal_curve_on_genuine_twist"]["base_field_member"] is False

    for relative, expected in payload["dependencies_sha256"].items():
        path = HERE / relative if "/" not in relative else PROBLEM_ROOT / relative
        assert path.is_file(), path
        assert digest(path) == expected, path

    old_r = PROBLEM_ROOT / "goals_2026-08-01/R_RATIONAL_CURVES_ROOT_20260801A"
    fixed = json.loads((old_r / "fixed_jacobian_payload.json").read_text(encoding="utf-8"))
    cohomology = json.loads((old_r / "group_cohomology_payload.json").read_text(encoding="utf-8"))
    schur = json.loads(
        (PROBLEM_ROOT / "tmp/pfaffian_generic_schur_audit/certificate.json").read_text(encoding="utf-8")
    )
    alignment = json.loads(
        (PROBLEM_ROOT / "tmp/pfaffian_representation_alignment/certificate.json").read_text(encoding="utf-8")
    )
    assert fixed["deduction"]["fixed_subgroup"] == "trivial"
    assert cohomology["checks"]["Z1_dimension_mod_3"] == 10
    assert cohomology["checks"]["B1_dimension_mod_3"] == 10
    assert cohomology["checks"]["H1_dimension_mod_3"] == 0
    assert schur["generic_index"] == 2
    assert schur["generic_schur_class"] == "nonzero of index two"
    assert alignment["exact_intertwiner"]["hom_dimension"] == 1
    assert alignment["exact_intertwiner"]["rank"] == 5

    run(old_r / "verify_fixed_jacobian.py", "KLEIN_JACOBIAN_COMMON_FIXED_SUBGROUP_TRIVIAL")
    run(old_r / "verify_group_cohomology.py", "KLEIN_JACOBIAN_H1_MOD_3_TRIVIAL")
    run(HERE / "verify_pfaffian_universal.py", "R2_PFAFFIAN_UNIVERSAL_INDEPENDENT_VERIFY_OK")
    run(
        PROBLEM_ROOT / "tmp/pfaffian_generic_schur_audit/verify.py",
        "PFAFFIAN_GENERIC_SCHUR_GATE_SEALED",
    )
    run(
        PROBLEM_ROOT / "tmp/pfaffian_representation_alignment_audit/verify.py",
        "PFAFFIAN_REPRESENTATION_ALIGNMENT_AUDIT_ACCEPT",
    )
    print("R2_DESCENDED_COMPONENT_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
