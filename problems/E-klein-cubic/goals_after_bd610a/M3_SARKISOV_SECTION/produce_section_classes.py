#!/usr/bin/env python3
"""Serialize the exact numerical classes and the first honest section gate."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
FRAME = (
    PROBLEM
    / "goals_2026-08-01"
    / "Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D"
    / "exact_frame.json"
)
M2_MORI = (
    PROBLEM
    / "goal_runs_after_35fa"
    / "M_SARKISOV"
    / "payload"
    / "mori_cox.json"
)
RESOLUTION = PROBLEM / "RESOLUTION.md"
OUT = HERE / "SECTION_CLASSES.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build() -> dict:
    frame = json.loads(FRAME.read_text())
    mori = json.loads(M2_MORI.read_text())
    resolution = RESOLUTION.read_text()
    assert mori["classes"]["L"] == [1, -1]
    assert mori["classes"]["minus_K"] == [2, -1]
    assert len(frame["cubic_coefficient_table"]) == 35
    assert sum(
        len(entry["products"]) for entry in frame["cubic_coefficient_table"]
    ) == 625
    assert "has no \\(K_{\\rm Schur}\\)-rational line" in resolution

    degree_four_variables = [
        f"A{i}_{j}" for i in range(3) for j in range(5)
    ] + [f"r_{j}" for j in range(4)]
    assert len(degree_four_variables) == 19
    return {
        "schema": "m3-section-classes-and-degree4-gate-v1",
        "field": "K=C(P(V6))^PSL2(F11)",
        "divisors": {
            "H": "pullback of O_X(1)",
            "D": "exceptional divisor",
            "L": "H-D=f^*O_P1(1)",
            "minus_K_Y": "2H-D=H+L",
            "minus_K_Y_over_P1": "D=H-L",
        },
        "section_curve_classes": {
            "exceptional": {
                "pair_H_D": [0, -1],
                "exists_iff": "C_012(K) is nonempty",
                "proof": (
                    "D=P_C(O_C(1)+O_C(1))=C_012 x P1 and any P1-to-C_012 "
                    "morphism is constant"
                ),
            },
            "nonexceptional": {
                "parameter": "d=H.R >= 1",
                "pair_H_D": ["d", "d-1"],
                "proof": "L.R=(H-D).R=1 and D.R is effective",
                "image": (
                    "a geometrically rational degree-d curve on X meeting C_012 in "
                    "scheme length d-1"
                ),
            },
        },
        "increasing_degree_audit": [
            {
                "d": 0,
                "class": [0, -1],
                "verdict": "equivalent to a K-point of C_012 and hence already headline-positive",
            },
            {
                "d": 1,
                "class": [1, 0],
                "verdict": "excluded by the binding no-K-line theorem for the genuine Schur twist",
            },
            {
                "d": 2,
                "class": [2, 1],
                "verdict": "excluded conditional on no section, because ind(C_012)=3",
            },
            {
                "d": 3,
                "class": [3, 2],
                "verdict": "excluded conditional on no section, because ind(C_012)=3",
            },
            {
                "d": 4,
                "class": [4, 3],
                "verdict": "first unresolved nonexceptional section class",
            },
        ],
        "conditional_congruence": {
            "assumption": "there is no rational section",
            "center_index": 3,
            "reason": (
                "a plane line gives a degree-3 divisor on C_012; index 1 on a smooth "
                "genus-one curve gives a degree-1 line bundle and hence a K-point by "
                "Riemann-Roch, which would give an exceptional section"
            ),
            "conclusion": "every nonexceptional section has d congruent to 1 modulo 3",
            "admissible_degrees": [4, 7, 10, 13],
            "list_is_prefix": True,
        },
        "degree_four_gate": {
            "variables": degree_four_variables,
            "projective_parameter_space": "P18_K",
            "forms": {
                "A_i": "A_i(s,t)=sum_(j=0)^4 A_i_j*s^(4-j)*t^j, i=0,1,2",
                "r": "r(s,t)=sum_(j=0)^3 r_j*s^(3-j)*t^j",
                "map": "[A_0:A_1:A_2:s*r:t*r]",
            },
            "equation": "Phi(A_0,A_1,A_2,s*r,t*r)=0",
            "binary_degree": 12,
            "coefficient_equations": 13,
            "equation_parameter_degree": 3,
            "coefficient_oracle": {
                "phi_coefficients": (
                    "the 35 exact straight-line coefficients in exact_frame.json, "
                    "each a sum of products of three Reynolds entries"
                ),
                "substitution": (
                    "expand the 35 monomials after the displayed binary-form substitution "
                    "and equate s^(12-k)t^k for k=0,...,12"
                ),
            },
            "required_open": {
                "common_factor": "gcd(A_0,A_1,A_2,r)=1",
                "basepoint_free": (
                    "there is no [s:t] with A_0=A_1=A_2=r=0; equivalently remove "
                    "the projection of that incidence locus"
                ),
                "degree_one_to_base": "automatic from [a3:a4]=[s*r:t*r] on r != 0",
                "nonvertical": True,
                "nonexceptional": "r is not the zero form",
            },
            "source_automorphisms": (
                "only common scalar is quotiented: a section is tied to the identity map "
                "of the fixed pencil base, so an arbitrary PGL2 reparametrization is not "
                "an automorphism of this section problem"
            ),
            "K_point_known": False,
            "geometric_emptiness_known": False,
        },
        "geometric_component_interface": {
            "raw_locus": "13 cubic coefficient equations in P18_K",
            "section_condition": (
                "projection from Pi_012 has degree one, equivalently intersection length "
                "three with C_012, together with the graph/basepoint open"
            ),
            "component_count_and_irreducibility": "UNRESOLVED",
            "smallest_unresolved_twisted_piece": (
                "the saturated common-zero-free d=4 open over K; a K-point is exactly "
                "an H-degree-4 section and hence headline-positive"
            ),
        },
        "strict_boundaries": {
            "split_good_fibre_lines_are_not_K_sections": True,
            "bounded_constant_coefficient_search_cannot_exclude_K_rational_functions": True,
            "a_degree4_multisection_is_not_a_degree4_section": True,
            "no_section_is_not_a_negative_headline_without_a_converse_bridge": True,
        },
        "inputs": {
            str(FRAME.relative_to(PROBLEM)): sha256(FRAME),
            str(M2_MORI.relative_to(PROBLEM)): sha256(M2_MORI),
            str(RESOLUTION.relative_to(PROBLEM)): sha256(RESOLUTION),
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    payload = build()
    text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUT.write_text(text)
        print(f"WROTE {OUT}")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
