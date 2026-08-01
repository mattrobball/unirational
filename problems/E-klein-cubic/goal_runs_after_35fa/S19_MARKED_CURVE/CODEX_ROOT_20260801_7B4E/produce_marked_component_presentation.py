#!/usr/bin/env python3
"""Emit the exact finite presentation of the two surviving marked-map loci.

This script deliberately does not attempt the determinantal elimination.  Its
job is to turn the corrected S19 construction problem into a fixed integral
incidence scheme, including the branch equations and all qualification opens.
"""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
UNIVERSAL = HERE / "universal_marked_family.json"
UPSTREAM = {
    "marked_hilbert": PROBLEM / "certificates/schur_degree19/marked_hilbert.json",
    "rao_resolutions": PROBLEM / "certificates/schur_degree19/rao_resolutions.json",
    "quintic_carriers": PROBLEM / "certificates/schur_degree19/quintic_carriers.json",
}
OUTPUT = HERE / "marked_component_presentation.json"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def monomials(number_of_variables: int, degree: int):
    answer = []

    def visit(prefix, variables_left, degree_left):
        if variables_left == 1:
            answer.append(prefix + [degree_left])
            return
        for exponent in range(degree_left, -1, -1):
            visit(prefix + [exponent], variables_left - 1, degree_left - exponent)

    visit([], number_of_variables, degree)
    return answer


def build_payload():
    universal = json.loads(UNIVERSAL.read_text())
    upstream = {name: json.loads(path.read_text()) for name, path in UPSTREAM.items()}
    assert universal["terminal_marker"] == "S19_CANONICAL_MARKED_55_FAMILY_EXACT"
    assert upstream["marked_hilbert"]["terminal_marker"] == "SCHUR_DEGREE19_MARKED_HILBERT_OVER_F"
    assert upstream["rao_resolutions"]["terminal_marker"] == "SCHUR_DEGREE19_RAO_RESOLUTIONS_ENUMERATED"
    assert upstream["quintic_carriers"]["terminal_marker"] == "SCHUR_DEGREE19_QUINTIC_CARRIERS_CLASSIFIED"

    quintic_monomials = monomials(4, 5)
    quadric_monomials = monomials(4, 2)
    assert len(quintic_monomials) == 56
    assert len(quadric_monomials) == 10

    payload = {
        "schema": "s19-marked-component-presentation-v1",
        "repository_commit_consumed": universal["repository_commit_consumed"],
        "pinned_state": universal["pinned_state"],
        "source_sha256": {
            "universal_marked_family.json": digest(UNIVERSAL),
            **{str(path.relative_to(PROBLEM)): digest(path) for path in UPSTREAM.values()},
        },
        "scope": {
            "split_model": "the cyclotomic splitting cover of the genuine Schur twist",
            "descent": "the PSL(2,11)-equivariant labelled presentation twists to an F-scheme; an F-point, not merely a geometric point, is required",
            "curves_parameterized": "closed immersions P1 -> P3 of degree 19 through the 55 ordered sections",
            "why_complete_for_target": "a geometrically integral curve with Hilbert polynomial 19*t+1 is smooth genus zero; its odd degree-55 point makes the genus-zero curve split over F",
        },
        "base": {
            "ring": universal["base_ring"]["presentation"],
            "extra_localization": "h4 is invertible",
            "marked_point_coordinates": "P_i,j(h), 0<=j<=3, are read from universal_points.coefficient_tensor in universal_marked_family.json",
            "hyperplane_identification": "M_h -> P3 uses [X0:X1:X2:X3] and X4=-(h0*X0+...+h3*X3)/h4",
            "dimension": 4,
        },
        "normalized_map_atlas": {
            "binary_forms": "c_j(s,t)=sum_{k=0}^19 a_jk*s^(19-k)*t^k, 0<=j<=3",
            "coefficient_variables": 80,
            "normalization": [
                "alpha_0=[1:0]",
                "alpha_1=[0:1]",
                "alpha_2=[1:1]",
                "lambda_0=1",
            ],
            "remaining_source_points": "alpha_i=[s_i:t_i] for 3<=i<=54",
            "remaining_source_point_factors": 52,
            "remaining_scale_variables": "lambda_i for 1<=i<=54",
            "reason": "three distinct ordered marks give the unique PGL2 slice; lambda_0 removes the common scalar of the four forms",
        },
        "incidence_ideal": {
            "equation_count": 220,
            "equations": "E_i,j = c_j(s_i,t_i)-lambda_i*P_i,j(h), for 0<=i<=54 and 0<=j<=3, with the four normalizations substituted",
            "coefficient_source": "the exact cyclotomic integer tensor in universal_marked_family.json",
            "ambient_dimension_before_equations": 190,
            "expected_relative_dimension": -30,
            "expected_fixed_h_dimension": -34,
            "dimension_ledger": "80 + 52 + 54 + 4 - 220 = -30",
            "warning": "expected dimension is not an actual dimension or an emptiness proof",
        },
        "qualification_localizations": {
            "marked_source_distinct": "invert product_{0<=i<j<=54}(s_i*t_j-s_j*t_i), after inserting the three normalized pairs",
            "nonzero_image_scales": "invert product_{i=1}^54 lambda_i",
            "basepoint_free": "complement of the projection of V(c0,c1,c2,c3) in coefficient-space x P1; equivalently the open defined by the saturated elimination ideal ((c0,c1,c2,c3):(s,t)^infinity) intersect coefficient-ring",
            "nondegenerate": "invert a 4x4 coefficient minor of the four binary forms (open cover over all such minors)",
            "closed_immersion": "the open where P1 -> P3 is unramified and universally injective, expressed by Fitting ideals of Omega_map and the residual-to-diagonal ideal on P1 x P1",
            "proper_cubic_intersection": "f3 is not in the image ideal",
            "multiplicity_one_at_marks": "invert the 55 values of the pulled-back cubic divided by the simple source factors at the marked parameters",
            "note": "these are exact finite saturation/Fitting constructions; each is an open cover, not an asserted nonempty condition",
        },
        "universal_image_ideal": {
            "graph_ideal": "J_graph=<X_j*c_k(s,t)-X_k*c_j(s,t):0<=j<k<=3>",
            "formula": "I_univ = (J_graph:(s,t)^infinity) intersect R[X0,X1,X2,X3]",
            "validity": "on the basepoint-free closed-immersion open this is flat with Hilbert polynomial 19*t+1 and is the universal embedded image",
            "finite_algorithm": "bihomogeneous saturation followed by elimination in the displayed rings",
        },
        "degree_five_substitution": {
            "columns": quintic_monomials,
            "column_count": 56,
            "rows": [f"s^{95-b}*t^{b}" for b in range(96)],
            "row_count": 96,
            "entry_formula": "Sub5[b,alpha]=coefficient of s^(95-b)t^b in product_j c_j(s,t)^alpha_j",
            "entry_degree_in_a": 5,
            "kernel_identification": "on the closed-immersion open, ker(Sub5)=I_C(5)",
        },
        "degree_five_compressed_point_ideal": {
            "shape": [96, 11],
            "columns": "the ten substitutions of F3_h(X)*X^beta for |beta|=2, followed by F5_h(X)",
            "entry_formula": "binary coefficient extraction after X_j=c_j(s,t)",
            "justification": "incidence gives I_C(5) subset I_Z(5)=F3_h*S2 direct-sum <F5_h>, so this compressed kernel equals the full quintic kernel",
            "epsilon_0": "rank 11",
            "epsilon_1": "rank 10 and the kernel vector has nonzero F5 coordinate",
        },
        "branches": {
            "epsilon_0": {
                "rao_d0_to_5": [0, 16, 29, 38, 42, 40],
                "equations": "incidence ideal",
                "open": "rank(Sub5)=56, i.e. the union of principal opens of its 56x56 minors",
                "compressed_open": "rank of the 96x11 point-ideal matrix is 11",
                "carrier": None,
                "nonemptiness": "UNDECIDED",
            },
            "epsilon_1": {
                "rao_d0_to_5": [0, 16, 29, 38, 42, 41],
                "rank_locus": "I_56(Sub5)=0 and rank(Sub5)=55 (open cover by 55x55 minors)",
                "compressed_rank_locus": "the 96x11 point-ideal matrix has rank 10 and its one-dimensional kernel has nonzero F5 coordinate",
                "carrier_variables": [f"q_{'_'.join(map(str, exponent))}" for exponent in quadric_monomials],
                "carrier_equation": "F5_h(X)+F3_h(X)*Q2(X)=0",
                "restricted_forms": "F3_h=h4^3*f3(X0,X1,X2,X3,-(sum_0^3 h_j*X_j)/h4), similarly F5_h with h4^5",
                "equations_alternative": "the 96 binary coefficients of F5_h(c)+F3_h(c)*Q2(c) vanish, together with incidence and rank(Sub5)=55",
                "carrier_uniqueness": "rank 55 gives a one-dimensional quintic kernel; primality and f3 not in I_C force nonzero F5 coefficient, hence a unique Q2",
                "nonemptiness": "UNDECIDED",
            },
        },
        "vertical_deformation_at_any_geometric_point": {
            "normal_bundle": "N_C/P3=O(19+b1)+O(19+b2), b1,b2>=2, b1+b2=36",
            "marked_twist": "N_C/P3(-Z)=O(b1-36)+O(b2-36)",
            "tangent_dimension_h0": 0,
            "obstruction_space_dimension_h1": 34,
            "calculation": "both summands have degree at most -2; h1=(35-b1)+(35-b2)=34",
            "scope": "vertical tangent/obstruction for the fixed hyperplane and fixed 55-point divisor; nonzero H1 is not proof of actual obstruction",
            "actual_dimension_consequence": "the qualified fixed-h locus is reduced and zero-dimensional at every geometric point; the relative qualified projection is unramified, so each component has the dimension of its image in the 4-dimensional hyperplane base (at most 4, and exactly 4 if dominant)",
            "virtual_dimensions": {"fixed_h": -34, "relative_over_h": -30},
        },
        "carrier_picard_boundary": {
            "epsilon_1_family": "S_q=V(F5_h+F3_h*Q2), q in A10",
            "base_curve": "Y=V(F3_h,F5_h) is 3H on every S_q",
            "smooth_carrier_adjunction": {"C_dot_H": 19, "C_square": -21},
            "rank_one_implication": "Pic(S_q)=Z*H excludes degree 19 because H^2=5",
            "actual_special_carrier_picard": "UNDECIDED",
            "liaison_does_not_close": "negative residual genus for second carrier degrees 6,7 still allows disconnected or nonreduced residuals",
        },
        "smallest_remaining_finite_problem": {
            "question": "does either saturated qualified incidence locus M_0 or M_1 dominate the good hyperplane base, and does its twist have an F-point?",
            "epsilon_0_test": "saturate the 220-equation incidence ideal by the qualification opens and an 11-minor of the compressed point-ideal matrix, then eliminate map/source variables to the h-ring",
            "epsilon_1_test": "use the 220 incidence equations plus rank 10 of the compressed 96x11 matrix (or the 96 carrier coefficients), require nonzero F5 kernel coordinate, saturate, then eliminate to (h,q) and to h",
            "required_positive_certificate": "exact F-rational normalized coefficients, source parameters, scales, and q for epsilon=1, followed by independent universal-ideal and residual checks",
            "required_negative_certificate": "a unit ideal or non-dominance eliminant after every stated saturation; unsaturated or modular-only emptiness is insufficient",
        },
        "strict_nonclaims": [
            "no point of either marked component is constructed",
            "no actual component dimension is computed",
            "neither Rao branch is excluded",
            "the special carrier Picard group is not determined",
            "no residual degree-two cycle or rational point is constructed",
            "the Klein-cubic headline remains open",
        ],
        "terminal_marker": "S19_MARKED_COMPONENTS_FINITE_PRESENTATION_EXACT",
    }
    assert payload["incidence_ideal"]["ambient_dimension_before_equations"] - payload["incidence_ideal"]["equation_count"] == -30
    assert sum(payload["branches"]["epsilon_0"]["rao_d0_to_5"][-1:] + [1]) == 41
    return payload


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    payload = build_payload()
    text = json.dumps(payload, indent=2, sort_keys=True) + "\n"
    if args.write:
        OUTPUT.write_text(text)
        print(f"wrote {OUTPUT} ({len(text)} bytes)")
    if args.check:
        assert OUTPUT.read_text() == text
        print("S19_MARKED_COMPONENT_PRESENTATION_REPRODUCES")
    if not args.write and not args.check:
        print(text, end="")
    print(payload["terminal_marker"])


if __name__ == "__main__":
    main()
