#!/usr/bin/env python3
"""Producer for Path F restricted étale algebra R_K = R ⊗_F K_proj.

Constructs the structural certificate from accepted five-form / Jacobian /
alpha_R inputs and from exact Q(zeta_11) specializations proving that the
nonzero E[3] factor is a degree-8 field. Does not decide res(xi)=0 and does
not run the divisor-cube or group-cohomology computations.
"""

from __future__ import annotations

import json
import subprocess
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
TMP = ROOT / "tmp/postelo_F"
OUT_JSON = HERE / "restricted_algebra.json"
SPEC_RESULTS = TMP / "R8_specialization_results.json"
JULIA = Path("/opt/homebrew/bin/julia")
ANALYZE = TMP / "analyze_R8.jl"


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def ensure_specializations() -> list:
    TMP.mkdir(parents=True, exist_ok=True)
    if not SPEC_RESULTS.is_file():
        if not ANALYZE.is_file():
            raise SystemExit(f"missing analyzer {ANALYZE}")
        r = subprocess.run(
            [str(JULIA), f"--project=/tmp/nemo_test", str(ANALYZE)],
            cwd=str(ROOT),
            capture_output=True,
            text=True,
            timeout=600,
        )
        if r.returncode != 0:
            sys.stderr.write(r.stdout)
            sys.stderr.write(r.stderr)
            raise SystemExit(f"analyze_R8.jl failed: {r.returncode}")
    data = json.loads(SPEC_RESULTS.read_text())
    assert isinstance(data, list) and data, "empty specialization results"
    for row in data:
        assert row["delta_zero"] is False
        assert row["psi_degree_type"] == [4]
        assert row["primitive8_u"] == 1
        assert row["best_chi_degs"] == [8]
    return data


def main() -> None:
    specs = ensure_specializations()

    sources = {
        "five_forms.json": file_hash(ROOT / "certificates/fixed_frame_arithmetic/five_forms.json"),
        "conic_algebra_inputs.json": file_hash(
            ROOT / "certificates/fixed_frame_arithmetic/conic_algebra_inputs.json"
        ),
        "CFOSS_W1_INPUT.md": file_hash(ROOT / "certificates/pfaffian_point/CFOSS_W1_INPUT.md"),
        "minimal_ternary_certificate.json": file_hash(
            ROOT / "tmp/pfaffian_minimal_ternary_model/certificate.json"
        ),
        "alpha_r_certificate.json": file_hash(
            ROOT / "tmp/pfaffian_depressed_alpha_r/certificate.json"
        ),
        "first_descent_interface.json": file_hash(
            ROOT / "tmp/pfaffian_depressed_alpha_r/first_descent_interface.json"
        ),
        "monogenic_system.json": file_hash(ROOT / "tmp/pathF_existence/monogenic_system.json"),
        "R8_specialization_results.json": file_hash(SPEC_RESULTS),
    }

    payload = {
        "format": "pathF-restricted-etale-algebra-v1",
        "headline": "OPEN",
        "dispatch": "POST-ELO Path F / F1",
        "binary_question": "res_{K_proj/F}(xi)=0 ?",
        "binary_status": "UNDECIDED",
        "base_fields": {
            "F": "C(A,B,Y,Z) with Q(zeta_11) subset C",
            "K_proj": {
                "degree_over_F": 6,
                "monodromy": "S6 arithmetic and geometric (accepted)",
                "proper_intermediate_fields": False,
                "source": "tmp/full_scaled_frame_degree_attack + branch-line hostile audit; monogenic_system.json",
                "rigidity_note": (
                    "No proper intermediate fields of K_proj/F is an accepted "
                    "input, not re-proved in this packet. It is the main "
                    "structural lever for linear disjointness below."
                ),
            },
        },
        "curve_and_jacobian": {
            "C_over_F": (
                "fixed-frame depressed plane cubic: generic member of the "
                "basepoint-free five-form system F0+A*FA+B*FB+Y*FY+(Z+kappa*A^2)*FZ=0"
            ),
            "kappa": "-11/18",
            "jacobian": "E: y^2 = x^3 - 27*c4*x - 54*c6  (Fisher; A_E=-27*c4, B_E=-54*c6)",
            "c4_c6_source": "tmp/pfaffian_minimal_ternary_model/certificate.json#universal_genus_one_interface",
            "accepted": {
                "C_F_empty": True,
                "Pic0_C_F": 0,
                "ind_C_F": 3,
            },
        },
        "R_over_F": {
            "definition": "R = Map_F(E[3], algebraic_closure(F))^{Gal}  (CFOSS etale algebra of E[3])",
            "rank": 9,
            "presentation": {
                "product": "R ≅ F × L",
                "identity_factor": "F · e_O  (evaluation at the identity of E[3])",
                "nonzero_factor": {
                    "symbol": "L",
                    "presentation": "L = F[x,y]/(psi3(x), y^2 - x^3 - A_E*x - B_E)",
                    "psi3": "3*x^4 + 6*A_E*x^2 + 12*B_E*x - A_E^2",
                    "rank_over_F": 8,
                    "is_field": True,
                    "proof_shape": (
                        "finite etale of rank 8 on Delta != 0; at six smooth "
                        "Q(zeta_11)-specializations of (A,B,Y,Z), psi3 is "
                        "irreducible of degree 4 and the primitive element "
                        "x+y has irreducible degree-8 minpoly over Q(zeta_11). "
                        "A product of proper field factors cannot specialize to "
                        "a single degree-8 field, so generically L/F is a field."
                    ),
                },
                "basis_R8": ["1", "x", "x^2", "x^3", "y", "y*x", "y*x^2", "y*x^3"],
                "basis_R_full_alpha_order": [
                    "e_O",
                    "1-e_O",
                    "X",
                    "X^2",
                    "X^3",
                    "Y",
                    "Y*X",
                    "Y*X^2",
                    "Y*X^3",
                ],
            },
            "galois_module": {
                "group_scheme": "E[3] ≅ (Z/3Z)^2 as Gal-modules up to the representation rho: Gal(Fbar/F) -> GL_2(F_3)",
                "orbits": {
                    "identity": "singleton {O}, giving the F-factor",
                    "nonzero": (
                        "single Gal-orbit of size 8 on E[3]\\{O}, giving the "
                        "field L of degree 8 (transitivity from field property)"
                    ),
                },
                "x_coordinate_algebra": (
                    "F[x]/(psi3) is a degree-4 field generically (psi3 irred at "
                    "all tested smooth specializations); Gal acts transitively "
                    "on the four lines {±T} in P^1(F_3)"
                ),
                "image_of_rho": (
                    "contains a transitive subgroup of GL_2(F_3) of order "
                    "divisible by 8; modular Frobenius types of psi3 include "
                    "4, 3+1, 2+2, 2+1+1, consistent with a large image "
                    "(Chebotarev discovery only — not a sealed char-0 image)"
                ),
                "Aut_L_over_F": {
                    "status": "NOT_COMPUTED_IN_CHAR0",
                    "note": (
                        "Unlike Path A degree-55 where Aut(L/F)=1 was established, "
                        "Aut(L/F) is not assumed here. L/F is not claimed Galois. "
                        "If Gal-image is full GL_2(F_3), Aut(L/F) ≅ N_G(H)/H for "
                        "H=stab of a nonzero vector; that normalizer computation "
                        "is part of the F3 plan, not a F1 claim."
                    ),
                },
            },
        },
        "R_K": {
            "definition": "R_K = R ⊗_F K_proj",
            "rank_over_K_proj": 9,
            "rank_over_F": 54,
            "factorization": {
                "product": "R_K ≅ K_proj × L_K",
                "identity_factor": "K_proj · e_O",
                "nonzero_factor": {
                    "symbol": "L_K",
                    "identification": "L_K ≅ L ⊗_F K_proj",
                    "is_field": True,
                    "degree_over_K_proj": 8,
                    "degree_over_F": 48,
                    "linear_disjointness": {
                        "claim": "L and K_proj are linearly disjoint over F",
                        "argument": (
                            "Both are fields over F with [L:F]=8 and "
                            "[K_proj:F]=6. Any intersection L ∩ K_proj inside a "
                            "common closure is a subfield of K_proj, hence equals "
                            "F or K_proj by the accepted no-intermediate-fields "
                            "rigidity of K_proj/F. It cannot be K_proj because "
                            "6 does not divide 8. Therefore L ∩ K_proj = F, so "
                            "L ⊗_F K_proj is a field of degree 8 over K_proj."
                        ),
                        "gcd_note": (
                            "gcd(8,6)=2 would allow a shared quadratic in the "
                            "abstract degree lattice; S6-rigidity of K_proj/F "
                            "forbids any proper subfield, including quadratics, "
                            "so the gcd-2 loophole is closed by monodromy, not "
                            "by coprimeness."
                        ),
                    },
                },
            },
            "galois_module_over_K_proj": {
                "statement": (
                    "As a Gal(K_proj-bar/K_proj)-module algebra, R_K is the "
                    "CFOSS etale algebra of E_{K_proj}[3]. Restriction of "
                    "scalars from F along K_proj/F identifies it with R ⊗_F K_proj."
                ),
                "orbits": "identity singleton + one orbit of size 8 on nonzero 3-torsion over K_proj",
            },
        },
        "alpha_R_image": {
            "definition": "alpha_R = w_1(xi) in R^x / R^{x3}",
            "cfoss_identification": {
                "injectivity": (
                    "CFOSS I, Lemma 3.1 (n prime => w1 injective), n=3; "
                    "PDF sha256:86f5b9a156c9afffdb3434670012b48bbfdb058ca22f4b2fefac493d5d7d1e01; "
                    "pinned at certificates/pfaffian_point/CFOSS_W1_INPUT.md"
                ),
                "class_identification": (
                    "CFOSS I, Corollary 3.12 (n odd): alpha_R = det(M)·(R^x)^3 "
                    "for the Brauer-Severi diagram matrix M of the covering"
                ),
            },
            "explicit_representative": {
                "source": "tmp/pfaffian_depressed_alpha_r/",
                "construction": "M0=L(P2)^{-1}*L(P1); M=M0/ell(M0); alpha_R=det(M)=det(M0)/ell(M0)^3",
                "dag_nodes": 755647,
                "lives_naturally_in": "R_K^x / R_K^{x3}  (coefficients in K_proj)",
                "note": (
                    "The installed DAG presents alpha_R over the depressed model "
                    "with leaves q_i,r_i. On the fixed-frame open those leaves "
                    "lie in F via binary_slots, so alpha_R is the image of a "
                    "class over F; after ⊗_F K_proj it is the restricted class."
                ),
            },
            "components_in_R_K": {
                "identity_component": (
                    "alpha_R(O) is an R-cube (installed gauges: 179^{-3} or "
                    "71^{-3} depending on ell); may be normalized to 1"
                ),
                "nonzero_component": (
                    "alpha_L in L_K^x / L_K^{x3} is the only nontrivial cube-class "
                    "data for the restriction test"
                ),
            },
            "binary_criterion": {
                "equivalence": (
                    "res_{K_proj/F}(xi)=0  <=>  alpha_R is a cube in R_K^x, "
                    "by CFOSS I Lemma 3.1 injectivity of w1 over K_proj "
                    "(char 0, perfect, 3 invertible)"
                ),
                "reduced_test": "alpha_L in (L_K^x)^3  (identity component already a cube)",
            },
        },
        "retired_local_obstructions": {
            "D3": "retired — Hensel point forces local Kummer membership (tmp/pfaffian_alpha_local_kummer)",
            "D5": "retired — residual constant point over F0=C(A,Y,Z) (tmp/pfaffian_d5_constant_point)",
        },
        "specialization_witnesses": {
            "field": "Q(zeta_11)",
            "points": specs,
            "meaning": (
                "exact characteristic-zero specializations of (A,B,Y,Z) with "
                "Delta != 0, psi3 irreducible degree 4, and L specialized to a "
                "degree-8 field (primitive element x+y). Modular factorizations "
                "are discovery only and are not used as char-0 claims."
            ),
        },
        "sources_sha256": sources,
        "not_proved": [
            "res_{K_proj/F}(xi)=0 or !=0",
            "alpha_L is a cube in L_K",
            "Aut(L/F)=1",
            "full image of rho equals GL_2(F_3)",
            "C(K_proj) nonempty or empty",
            "ed_C(G)=3 or 4",
            "conic-algebra scheme existence",
        ],
        "next": {
            "F2": "divisor cube test plan in CUBE_TEST.md (not executed this dispatch)",
            "F3": "group-cohomological restriction plan in group_cohomology.json (not executed)",
            "forbidden_this_dispatch": "large conic elimination",
        },
    }

    OUT_JSON.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"WROTE {OUT_JSON}")
    print(f"sha256 {file_hash(OUT_JSON)}")


if __name__ == "__main__":
    main()
