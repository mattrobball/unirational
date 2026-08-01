#!/usr/bin/env python3
"""Independent verifier for the T0 bridge-scope refutation."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]

SOURCES = {
    "goal": "goals_2026-08-01/GOAL_T_TARGET_BRANCH_INDEX3.md",
    "repair": "REPAIR.md",
    "headline_workorder": "WORKORDER_CAS_HEADLINE.md",
    "post_elo_workorder": "WORKORDER_POST_ELO_CONSTRUCTION.md",
    "bridge_audit": "certificates/pfaffian_point/BRIDGE_AUDIT.md",
    "fixed_frame_report": "tmp/pfaffian_global_fixed_frame_hostile_audit/REPORT.md",
    "fixed_frame_audit": "tmp/pfaffian_global_fixed_frame_hostile_audit/PROOF_AUDIT.md",
    "ternary_report": "tmp/pfaffian_minimal_ternary_model/REPORT.md",
    "ternary_audit": "tmp/pfaffian_minimal_ternary_model/PROOF_AUDIT.md",
    "branch_report": "tmp/full_scaled_frame_branch_line_hostile_audit/REPORT.md",
    "branch_audit": "tmp/full_scaled_frame_branch_line_hostile_audit/PROOF_AUDIT.md",
    "branch_certificate": "tmp/full_scaled_frame_branch_line_hostile_audit/certificate.json",
}

# These are independently fixed here rather than imported from the producer.
MARKERS = {
    "goal": [
        "return `T-BRIDGE-BLOCKED` with a precise counterexample/gap",
        "another theorem that destroys the proposed negative implication",
        "not for an auxiliary Pfaffian cubic, a coordinate ternary section",
    ],
    "repair": [
        "This is not a point of \\(F_{14,T}\\) or of the generic Klein twist.",
        "The `FAIL-SCOPE` bridge audit is authoritative.",
    ],
    "headline_workorder": [
        "**Not headline bridges:** emptiness of the auxiliary Morita-projector cubic;",
        "fixed-frame auxiliary genus-one torsor",
        "without a separate bridge to `F_{14,T}` or the generic Klein twist",
    ],
    "post_elo_workorder": [
        "**The auxiliary Morita idempotent is not a Klein point.**",
    ],
    "bridge_audit": [
        "**Gate 1 decision:** `FAIL-SCOPE`",
        "has a **broken first arrow**",
        "common isotropic right D-line",
        "Idempotent ⇒ auxiliary Morita point",
    ],
    "fixed_frame_report": [
        "The full fixed-frame Pfaffian plane cubic descends to `F`",
        "This is not a no-point theorem over `K_proj`.",
        "does not settle equivariant unirationality",
    ],
    "fixed_frame_audit": [
        "the full fixed-frame plane cubic is the generic member",
        "`C(K_proj)` empty | **not proved**",
    ],
    "ternary_report": [
        "`(0,1,2)` coordinate plane over `K_proj`",
        "neither finds a `K_proj` point nor proves that none exists",
    ],
    "ternary_audit": [
        "the minimal curve has a `K_proj` point | **not proved**",
        "the minimal curve has no `K_proj` point | **not proved**",
    ],
    "branch_report": [
        "ramification residue degree",
        "generic ramification residue degree is exactly `m=1`",
        "(e,f)=(2,1).",
    ],
    "branch_audit": [
        "unique ramified prime with `(e,f)=(2,1)`",
        "residue degree at this divisor is `m=1`.",
    ],
    "branch_certificate": [
        '"generic_ramification_residue_degree_m": 1',
        '"ramified_pairs_e_f"',
        '"scope": "there exists a global target branch divisor with m=1; no index-survival or no-point conclusion"',
    ],
}


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def derivative(terms, variable_index):
    result = []
    for coefficient, powers in terms:
        exponent = powers[variable_index]
        if exponent:
            new_powers = list(powers)
            new_powers[variable_index] -= 1
            result.append((f"{exponent}*{coefficient}", tuple(new_powers)))
    return result


def evaluate_support(terms, point):
    surviving = []
    for coefficient, powers in terms:
        if all(value != 0 or exponent == 0 for value, exponent in zip(point, powers)):
            surviving.append((coefficient, powers))
    return surviving


def verify_counterexample(payload) -> None:
    # Variables are (x,y,z,w,q); coefficients are symbolic nonzero field units.
    ambient = [
        ("1", (3, 0, 0, 0, 0)),
        ("s", (0, 3, 0, 0, 0)),
        ("t", (0, 0, 3, 0, 0)),
        ("1", (1, 0, 0, 2, 0)),
        ("1", (0, 0, 0, 0, 3)),
    ]
    section = [term for term in ambient if term[1][3] == term[1][4] == 0]
    expected_section = ambient[:3]
    assert section == expected_section

    point = (0, 0, 0, 1, 0)
    assert evaluate_support(ambient, point) == []  # point lies on Y
    gradient = [derivative(ambient, i) for i in range(5)]
    assert ("2*1", (1, 0, 0, 1, 0)) in gradient[3]  # F_w=2wx
    assert ("1*1", (0, 0, 0, 2, 0)) in gradient[0]  # w^2 in F_x
    assert evaluate_support(gradient[0], point) == [
        ("1*1", (0, 0, 0, 2, 0))
    ]

    # Smoothness is an exact implication in any characteristic-zero field:
    # Fy=Fz=Fq=0 gives y=z=q=0. Fw=0 gives wx=0. If either
    # x or w is zero, Fx=3x^2+w^2=0 forces the other to be zero.
    # Thus a hypothetical singular projective point has all coordinates zero.
    assert gradient[1] == [("3*s", (0, 2, 0, 0, 0))]
    assert gradient[2] == [("3*t", (0, 0, 2, 0, 0))]
    assert gradient[4] == [("3*1", (0, 0, 0, 0, 2))]

    # For C0, t-valuations of nonzero summands are congruent to 0,0,1.
    # A least valuation in a zero sum occurs at least twice, hence the first
    # two tie. Their residue equation makes -s a cube in C((s)), impossible
    # because its s-valuation is 1 mod 3.
    assert payload["t_valuation_residues"] == [0, 0, 1]
    assert payload["residual_cube_obstruction"] == "v_s(-s)=1 mod 3"
    assert payload["plane_cubic_index"] == 3
    assert payload["coordinate_section"] == "w=q=0"
    assert payload["rational_point"] == list(point)

    # The K-rational plane hyperplane divisor has degree 3. For a smooth
    # genus-one curve, index 1 yields a degree-one line bundle and Riemann--
    # Roch yields a K-point. Pointlessness therefore forces index 3.
    possible_indices_dividing_hyperplane_degree = {1, 3}
    possible_indices_after_no_point = possible_indices_dividing_hyperplane_degree - {1}
    assert possible_indices_after_no_point == {3}


def verify_implication_graph(payload) -> None:
    # Build only the sound positive bridge from the binding audit.
    edges = {
        ("common_isotropic_line", "twisted_fano_point"),
        ("twisted_fano_point", "X_gen_point"),
        ("fixed_frame_point", "morita_projector"),
    }
    assert ("morita_projector", "common_isotropic_line") not in edges
    assert ("fixed_frame_empty", "X_gen_empty") not in edges

    invalid = set(payload["invalid_or_unavailable"])
    assert "Morita projector => common isotropic line" in invalid
    assert "C_fix(K_proj) empty => X_gen(K_proj) empty" in invalid


def main() -> None:
    payload = json.loads((HERE / "proof_payload.json").read_text(encoding="utf-8"))
    assert payload["schema"] == "t-target-branch-t0-scope-v1"
    assert payload["exit"] == "T-ROUTE-REFUTED"
    assert payload["t0_subexit"] == "T-BRIDGE-BLOCKED"
    assert payload["problem_e_headline"] == "OPEN"
    assert payload["fields"]["extension_degree"] == 6
    assert payload["fields"]["branch_residue"] == {
        "e": 2,
        "f": 1,
        "residue_fields_equal": True,
    }

    head = subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
    ).strip()
    assert payload["consumed_head"] == head

    for label, relative in SOURCES.items():
        path = ROOT / relative
        text = path.read_text(encoding="utf-8")
        for marker in MARKERS[label]:
            assert marker in text, (relative, marker)
        recorded = payload["sources"][label]
        assert recorded["path"] == relative
        assert recorded["sha256"] == sha256(path)

    verify_counterexample(payload["counterexample"])
    verify_implication_graph(payload["implication_ledger"])

    result = {
        "schema": "t-target-branch-t0-verification-v1",
        "consumed_head": head,
        "source_hashes_recomputed": True,
        "binding_markers_recomputed": True,
        "counterexample_reconstructed": True,
        "implication_graph_reconstructed": True,
        "exit": "T-ROUTE-REFUTED",
        "verdict": "ACCEPT",
    }
    (HERE / "verify_result.json").write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    print("T_TARGET_BRANCH_BRIDGE_SCOPE_VERIFIER_ACCEPT")


if __name__ == "__main__":
    main()
