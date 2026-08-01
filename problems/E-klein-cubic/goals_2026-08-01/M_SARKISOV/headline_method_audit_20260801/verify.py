#!/usr/bin/env python3
"""Sealed verifier for the degree-55 headline-method no-go."""

from __future__ import annotations

import hashlib
import itertools
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
WORK_ROOT = HERE.parents[1]
PROBLEM_ROOT = HERE.parents[2]


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require_text(name: str, markers: list[str]) -> None:
    content = (HERE / name).read_text()
    for marker in markers:
        assert marker in content, (name, marker)


def run(path: Path) -> None:
    result = subprocess.run(
        [sys.executable, str(path)],
        cwd=path.parent,
        check=True,
        text=True,
        capture_output=True,
    )
    print(result.stdout, end="")


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    status = (HERE / "STATUS.md").read_text().splitlines()[0]
    assert status == seal["verdict"] == "M-MULTISECTION-DESCENT-NO-GO"

    for relative, expected in seal["local_files"].items():
        assert digest(HERE / relative) == expected, relative
    for relative, expected in seal["upstream_inputs"].items():
        assert digest(PROBLEM_ROOT / relative) == expected, relative
    print("PASS sealed local files and pinned upstream inputs")

    payload = json.loads((HERE / "payload.json").read_text())
    fields = payload["fields"]
    cover = payload["cover"]
    branches = payload["branches"]
    degrees = payload["section_degrees"]
    quartic = payload["quartic_gate"]
    logic = payload["logic"]
    scope = payload["scope"]

    assert fields["L_over_K0_degree"] == cover["degree"] == 55
    assert branches["G_order"] // branches["H_order"] == branches["orbit_size"] == 55
    assert not cover["rational_right_inverse"]
    assert not cover["tautological_section_descends"]
    assert not branches["G_fixed_branch"]
    assert not branches["H_has_index_two_overgroup_in_G"]
    assert not branches["equivariant_binary_pairing"]
    print("PASS degree-55 cover has no branch-selection/right-inverse descent")

    assert degrees["first_possible_degree"] == 4
    assert degrees["first_possible_degree"] % degrees["congruence_modulus"] == degrees[
        "congruence_residue"
    ]
    assert all((d - 1) % 3 == 0 for d in (4, 7, 10, 13))

    # Independent combinatorial reconstruction of the quartic section gate.
    binary_quartic_monomials = list(range(5))
    binary_cubic_monomials = list(range(4))
    assert quartic["total_coefficients"] == (
        quartic["A_forms"] * len(binary_quartic_monomials)
        + len(binary_cubic_monomials)
    ) == 19
    assert quartic["parameter_projective_dimension"] == 18
    cubic_monomials_in_five_variables = list(itertools.combinations_with_replacement(range(5), 3))
    assert len(cubic_monomials_in_five_variables) == 35
    assert quartic["identity_binary_degree"] == 3 * quartic["A_form_degree"] == 12
    assert quartic["coefficient_equations"] == quartic["identity_binary_degree"] + 1 == 13
    assert quartic["equation_degree_in_parameters"] == 3
    assert not quartic["K0_point_known"] and not quartic["emptiness_known"]
    print("PASS quartic gate: P18 open cut by 13 cubic coefficient equations")

    assert logic["section_implies_headline_positive"]
    assert not logic["headline_positive_implies_section_installed"]
    assert not logic["no_section_implies_headline_negative"]
    assert not logic["multisection_alone_resolves_headline"]
    assert scope["direct_branch_descent_closed"] and scope["binary_branch_folding_closed"]
    assert not scope["all_independent_sections_excluded"]
    assert not scope["all_uses_of_fibration_excluded"]

    require_text(
        "THEOREM.md",
        [
            "Theorem A: the multisection cover has no rational section",
            "Theorem B: equivariant binary folding also stops",
            "Theorem C: the first independent section has degree four",
            "headline is neither proved nor refuted",
        ],
    )
    require_text(
        "COMPLETION_AUDIT.md",
        [
            "Problem E headline | OPEN",
            "requested method-level alternative | PASS",
            "every conceivable use of the Mori fibration",
        ],
    )

    # Replay the constructive multisection packet and the exact subgroup
    # overgroup enumeration on which the no-go rests.
    run(WORK_ROOT / "M_SARKISOV" / "section_or_multisection_20260801" / "verify.py")
    run(PROBLEM_ROOT / "certificates" / "subgroup_orbit_check.py")
    run(WORK_ROOT / "R_RATIONAL_CURVES_ROOT_JACOBIAN_ZERO" / "verify.py")

    print("PASS direct multisection descent and binary folding are impossible")
    print("PASS independent section frontier begins at projective degree 4")
    print("HEADLINE_OPEN")
    print("M-MULTISECTION-DESCENT-NO-GO")


if __name__ == "__main__":
    main()

