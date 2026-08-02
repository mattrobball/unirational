#!/usr/bin/env python3
"""Serialize the exact logical status of the degree-four branch.

This producer deliberately separates three assertions which are easy to
conflate:

* existence of an integral degree-four multisection;
* an explicit quartic field/point certificate;
* existence of a degree-four *section curve* on the cubic threefold.

Only the first is proved here.  It does not decide whether the generic cubic
surface has a rational point.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
M2 = PROBLEM / "goal_runs_after_35fa" / "M_SARKISOV"
THEOREM = M2 / "THEOREM.md"
REFERENCES = M2 / "REFERENCES.md"
FIBRATION = HERE / "fibration_model.json"
OUT = HERE / "quartic_branch.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build() -> dict:
    fibration = json.loads(FIBRATION.read_text())
    degrees = [entry["degree"] for entry in fibration["generic_fibre"]["zero_cycles"]]
    assert degrees == [3, 55]
    assert 55 - 18 * 3 == 1
    assert fibration["generic_fibre"]["smooth"] is True

    coordinate_blocks = {
        "quartic_polynomial": ["c2", "c1", "c0"],
        "three_unfixed_projective_coordinates": [
            f"x{i}_{j}" for i in range(3) for j in range(4)
        ],
    }
    assert sum(len(block) for block in coordinate_blocks.values()) == 15

    return {
        "schema": "m3-integral-quartic-branch-v1",
        "field": "F=K(q), K=C(P(V6))^PSL2(F11)",
        "hypothesis_certificate": {
            "smooth_cubic_surface": True,
            "effective_zero_cycle_degrees": degrees,
            "bezout_zero_cycle": "z_55-18*z_3 has degree 1",
            "index": 1,
        },
        "theorem_ledger": {
            "source": "https://arxiv.org/html/2509.17996v2",
            "source_version": "v2",
            "coray_result": "Theorem 1.4",
            "point_or_quartic": "Theorem 1.5",
            "quadratic_residual": "Remark 1.6",
            "effective_degree_four": "Remark 1.7",
            "upstream_numbering_correction": (
                "M2 REFERENCES.md calls the v2 point-or-quartic theorem 1.4; "
                "the statement used in M2 is correct but its v2 number is 1.5"
            ),
            "unirationality_source": "https://arxiv.org/abs/math/0005146",
            "unirationality_result": (
                "Kollar: a smooth cubic hypersurface over any field is unirational "
                "if it has a rational point"
            ),
        },
        "no_section_branch": {
            "argument": [
                "Theorem 1.5 supplies an L-point for some extension L/F of degree 4.",
                "The residue field degree divides 4.",
                "Degree 1 is excluded by the no-section assumption.",
                "Degree 2 is excluded by the conjugate-pair secant residual construction of Remark 1.6.",
                "Therefore the underlying closed point has residue degree exactly 4.",
            ],
            "exact_residue_degree": 4,
        },
        "section_branch": {
            "extension": "L=F(theta), theta^4=q",
            "irreducibility": (
                "T^4-q is Eisenstein at the q-adic valuation of K(q); because i is in K, "
                "L/F is cyclic of degree 4 with unique quadratic subfield F(theta^2)"
            ),
            "argument": [
                "A smooth cubic surface with an F-point is F-unirational in characteristic zero.",
                "Weil restriction of a dominant unirational parametrization gives a dominant rational map to Res_(L/F)(S_L).",
                "The locus fixed by the order-two subgroup is proper; after algebraic closure it is the pairwise diagonal in S^4.",
                "Delete the indeterminacy locus and the inverse image of the fixed locus; the remaining nonempty affine open has an F-point because F is infinite.",
                "Its image is an L-point not fixed by the order-two subgroup and hence has residue field exactly L.",
            ],
            "exact_residue_degree": 4,
            "uses_hilbert_irreducibility": False,
        },
        "normalization_to_multisection": {
            "construction": (
                "Normalize B=P1_K in the quartic residue field M/F.  The normalization "
                "is finite because B is excellent.  Properness of Y/B extends the "
                "generic M-point to C->Y.  The map C->B is finite flat of degree 4 "
                "because its module is finite torsion-free over the regular curve B."
            ),
            "integral_means": "K(C) is a field and [K(C):K(B)]=4",
            "does_not_mean": [
                "geometrically integral over K",
                "rational over K",
                "a constant-field extension",
                "a section curve of projective H-degree 4",
            ],
        },
        "primitive_quartic_incidence": {
            "charts": 4,
            "chart_normalization": "set one of x0,x1,x2,u equal to 1",
            "quartic_algebra": "g(T)=T^4+c2*T^2+c1*T+c0",
            "primitive_element_reason": (
                "translate a separable primitive element by one quarter of its trace"
            ),
            "variables": coordinate_blocks,
            "variable_count_per_chart": 15,
            "coordinate_forms": "each of the three remaining coordinates is cubic in T",
            "equations": (
                "reduce phi_q(X0(T),X1(T),X2(T),U(T)) modulo g and set its four "
                "remainder coefficients equal to zero"
            ),
            "equation_count": 4,
            "required_arithmetic_checks": [
                "g irreducible over K(q)",
                "disc(g) nonzero",
                "all four cubic remainders vanish",
                "all Schur-frame denominators are nonzero",
                "the 4 by 4 coordinate-coefficient determinant is nonzero (full P3 span)",
                "the cubic resolvent is irreducible (primitive action)",
                "disc(g) square/non-square distinguishes A4 from S4 after the preceding checks",
            ],
            "important_boundary": (
                "field irreducibility is arithmetic, not a geometric component obtained "
                "by deleting a reducible locus from Sym^4(S); over an algebraic closure "
                "every etale quartic cycle splits"
            ),
            "smallest_explicit_unresolved_problem": (
                "in the no-section branch, produce one exact K(q)-coefficient tuple in "
                "these four charts satisfying the equations, full-span determinant, and "
                "A4/S4 arithmetic checks"
            ),
        },
        "decomposition_group_reduction": {
            "scope": "only in the no-section branch",
            "transitive_subgroups_of_S4": ["C4", "V4", "D4", "A4", "S4"],
            "excluded": ["C4", "V4", "D4"],
            "reason": (
                "each excluded group preserves a 2+2 block system.  One conjugate pair "
                "then defines a degree-two cycle over the quadratic block field; its "
                "secant residual gives a point over that quadratic field, hence a closed "
                "point of degree at most 2 and therefore an F-point by Remark 1.6"
            ),
            "remaining": ["A4", "S4"],
            "line_action_caveat": (
                "a quartic point need not lie on any of the 27 lines, so line monodromy "
                "alone does not remove A4 or S4"
            ),
        },
        "verdict": {
            "integral_degree_four_multisection_exists": True,
            "quartic_locus_empty": False,
            "explicit_field_and_point_coordinates_produced": False,
            "selects_section_alternative": False,
            "terminal_exit": "M3-INTEGRAL-DEGREE4-MULTISECTION",
            "section_question": "UNDECIDED",
            "headline": "OPEN",
        },
        "inputs": {
            str(THEOREM.relative_to(PROBLEM)): sha256(THEOREM),
            str(REFERENCES.relative_to(PROBLEM)): sha256(REFERENCES),
            str(FIBRATION.relative_to(HERE)): sha256(FIBRATION),
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
