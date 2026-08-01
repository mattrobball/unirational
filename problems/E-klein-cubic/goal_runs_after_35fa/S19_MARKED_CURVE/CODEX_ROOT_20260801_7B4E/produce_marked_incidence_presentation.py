#!/usr/bin/env python3
"""Serialize the exact finite marked-map presentation for degree 19.

This is a presentation of the search space, not a point or a nonemptiness
claim.  Its purpose is to replace an infeasible raw Hilbert sweep by one
explicit saturated incidence scheme and two exact rank branches.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
FAMILY = HERE / "universal_marked_family.json"
OUTPUT = HERE / "marked_incidence_presentation.json"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main_payload():
    family = json.loads(FAMILY.read_text())
    assert family["terminal_marker"] == "S19_CANONICAL_MARKED_55_FAMILY_EXACT"
    equations = []
    for point in range(55):
        for coordinate in range(4):
            equations.append({
                "row": 4 * point + coordinate,
                "point": point,
                "coordinate": coordinate,
                "formula": f"sum(k=0..19,a_{coordinate},k*s_{point}^(19-k)*t_{point}^k)-lambda_{point}*p_{point},{coordinate}(h)",
                "map_columns": [20 * coordinate + k for k in range(20)],
                "lambda_column": 80 + point,
                "universal_point_tensor_reference": [point, coordinate],
            })

    gotzmann = 19 * 18 // 2 + 1
    ambient_gotzmann = math.comb(gotzmann + 3, 3)
    polynomial_gotzmann = 19 * gotzmann + 1
    ideal_gotzmann = ambient_gotzmann - polynomial_gotzmann
    ambient_degree18 = math.comb(21, 3)
    polynomial_degree18 = 19 * 18 + 1
    ideal_degree18 = ambient_degree18 - polynomial_degree18

    return {
        "schema": "s19-marked-incidence-presentation-v1",
        "pinned_state": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "source_sha256": {
            "universal_marked_family.json": sha256(FAMILY),
            "goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md": sha256(PROBLEM / "goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md"),
            "tmp/schur_degree19_nonacm_attack_audit/certificate.json": sha256(PROBLEM / "tmp/schur_degree19_nonacm_attack_audit/certificate.json"),
        },
        "base": {
            "scheme": "the Delta-open of P^4_h over Q(zeta_11) from universal_marked_family.json",
            "dimension": 4,
            "P3_chart": "h4 is inverted; X4=-(h0*X0+h1*X1+h2*X2+h3*X3)/h4",
            "marked_sections": 55,
        },
        "variables": {
            "source_markings": {"names": [[f"s_{i}", f"t_{i}"] for i in range(55)], "space": "(P1)^55", "dimension": 55},
            "degree19_map": {"names": [[f"a_{j},{k}" for k in range(20)] for j in range(4)], "space": "P^79", "dimension": 79},
            "linearization_scalars": {"names": [f"lambda_{i}" for i in range(55)], "common_scaling_with_map": True},
        },
        "linearized_matrix": {
            "shape": [220, 135],
            "map_columns": 80,
            "lambda_columns": 55,
            "equations": equations,
            "rank_closure": "all 135 by 135 minors vanish, i.e. rank <= 134",
            "warning": "the rank closure also contains inadmissible kernels; use the saturated incidence scheme below",
        },
        "saturated_incidence": {
            "equations": "the 220 displayed homogeneous equations M(s,h)*(a,lambda)^T=0",
            "irrelevant_ideals": ["(h0,h1,h2,h3,h4)"] + [f"(s_{i},t_{i})" for i in range(55)] + ["all a_j,k and lambda_i under their common scaling"],
            "open_gates": {
                "Delta": "all good-open factors named in universal_marked_family.json",
                "distinct_markings": "product over i<j of (s_i*t_j-t_i*s_j) is nonzero",
                "nonzero_lambdas": "product over i of lambda_i is nonzero",
                "basepoint_free": "the four binary degree-19 forms have unit gcd, equivalently there is no [s:t] where all four vanish",
                "PGL2_rigidification": "quotient by PGL2, or put three ordered markings at [1:0],[0:1],[1:1]",
            },
            "degree_and_birationality": "basepoint freeness gives pullback O(1)=O(19); the 55 target points span P3, so the image is not a line; since 19 is prime, the map is birational onto a nondegenerate integral degree-19 image",
        },
        "dimension_ledger": {
            "base_h": 4,
            "map_mod_PGL2": 76,
            "marked_target_conditions": -110,
            "virtual_relative_total": -30,
            "equivalent_before_PGL2": {"base_plus_markings_plus_projective_kernel_variables": 193, "equations": 220, "virtual_dimension": -27},
            "status": "virtual only; dependence of the special 55 conditions is the unresolved rank question",
        },
        "smooth_fixed_fibre_tangent_obstruction": {
            "normal_splitting": "N_C/P3=O(19+b1)+O(19+b2), b1+b2=36 and b1,b2>=1",
            "proof_of_bounds": "N_C/P3(-1) is globally generated, so b_i>=0; nondegeneracy gives H0(Omega_P3(1)|C)=0, hence H0(N_C/P3^*(1))=0 and b_i cannot be zero",
            "marked_normal_splitting": "N_C/P3(-Z)=O(b1-36)+O(b2-36)",
            "tangent_dimension_h0": 0,
            "obstruction_dimension_h1": 34,
            "relative_hyperplane_formula": "for the rank r of T_h P4 -> H1(N(-Z)), tangent=4-r and obstruction=34-r, with 0<=r<=4",
            "scope": "smooth embedded rational candidates only; it does not cover singular rational images",
        },
        "rao_branch_rank_tests": {
            "full_quintic_substitution_matrix": {
                "shape": [96, 56],
                "columns": "all degree-5 monomials in X0,X1,X2,X3 after substitution by the four binary degree-19 map forms",
                "epsilon0": "rank 56, so I_C(5)=0 and Rao degree-5 dimension is 40",
                "epsilon1": "rank 55, so dim I_C(5)=1 and Rao degree-5 dimension is 41",
            },
            "compressed_point_ideal_matrix": {
                "shape": [96, 11],
                "columns": "restrictions of f3 times the ten quadrics, followed by f5",
                "epsilon0": "rank 11",
                "epsilon1": "rank 10 with one-dimensional kernel whose f5 coordinate is nonzero; normalize it to f5+f3*q",
                "justification": "any quintic containing C also contains its 55 marked points, and I_Z(5)=f3*S2 plus <f5>",
            },
        },
        "special_quintic_carrier": {
            "family": "S_q: f5+f3*q=0, q in H0(P3,O(2)), an affine 10-dimensional family",
            "base_curve": "Y=V(f3,f5) is a smooth (3,5) complete intersection and Y is linearly equivalent to 3H on S_q",
            "smooth_candidate_lattice": {"H2": 5, "H_dot_C": 19, "C2": -21, "gram": [[5, 19], [19, -21]], "determinant": -466},
            "adjunction": "if S_q and C are smooth, K_S=H and -2=C^2+H.C, hence C^2=-21",
            "consequence": "a smooth epsilon1 candidate forces the actual carrier either to be singular or to lie in the Noether-Lefschetz locus carrying the displayed discriminant-466 lattice; a very-general Picard-rank-one carrier cannot contain C",
            "nonconsequence": "this does not exclude the special carrier selected by an unknown curve",
        },
        "resource_preflight": {
            "raw_gotzmann": {"number": gotzmann, "ambient_monomials": ambient_gotzmann, "hilbert_value": polynomial_gotzmann, "ideal_dimension": ideal_gotzmann, "grassmannian_dimension": ideal_gotzmann * polynomial_gotzmann},
            "degree18_regular_curve_proxy": {"ambient_monomials": ambient_degree18, "hilbert_value": polynomial_degree18, "ideal_dimension": ideal_degree18, "grassmannian_dimension": ideal_degree18 * polynomial_degree18},
            "chosen_exact_route": "220 by 135 sparse incidence matrix plus a 96 by 11 branch matrix",
            "decision": "do not launch raw Hilbert elimination; the exact sparse presentation is the feasible handoff",
        },
        "terminal_marker": "S19_MARKED_INCIDENCE_FINITE_PRESENTATION_EXACT",
        "strict_nonclaims": [
            "no admissible kernel of the 220 by 135 matrix is exhibited",
            "no saturated component is proved nonempty or empty",
            "the relative Kodaira-Spencer rank r is not computed without a candidate",
            "neither Rao branch is excluded",
            "no exact residual degree-two cycle or rational point is produced",
        ],
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    encoded = json.dumps(main_payload(), indent=2) + "\n"
    if args.write:
        OUTPUT.write_text(encoded)
        print("S19_MARKED_INCIDENCE_PRESENTATION_WRITTEN")
    elif args.check:
        if OUTPUT.read_text() != encoded:
            raise SystemExit("marked incidence presentation mismatch")
        print("S19_MARKED_INCIDENCE_PRODUCER_CHECK_OK")
    else:
        print(encoded, end="")


if __name__ == "__main__":
    main()
