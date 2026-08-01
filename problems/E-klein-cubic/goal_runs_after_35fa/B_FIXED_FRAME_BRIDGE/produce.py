#!/usr/bin/env python3
"""Produce the exact machine-readable Goal B bridge ledger."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import shutil


HERE = Path(__file__).resolve().parent
REPO = HERE.parents[1]

SOURCES = {
    "goal": REPO / "goals_after_35fa8f/GOAL_B_FIXED_FRAME_TO_GENERIC_BRIDGE.md",
    "implementation_audit": REPO / "goals_after_35fa8f/IMPLEMENTATION_AUDIT.md",
    "goal_f_seal": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/SEAL.json",
    "field_presentation": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/field_presentation.json",
    "primitive_sextic": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/payload/global_primitive_u_sextic_exact.tsv",
    "goal_f_infinity": REPO / "goals_2026-08-01/F_CONIC_ALGEBRA/infinity_obstruction.json",
    "fixed_five_forms": REPO / "certificates/fixed_frame_arithmetic/five_forms.json",
    "fixed_frame_seal": REPO / "certificates/fixed_frame_arithmetic/SEAL.json",
    "pfaffian_seal": REPO / "certificates/pfaffian_point/SEAL.json",
    "idempotent_dictionary": REPO / "certificates/pfaffian_point/IDEMPOTENT_TO_KLEIN_POINT.md",
    "quaternion_corner": REPO / "certificates/pfaffian_point/quaternion_corner.json",
    "projector_proof_audit": REPO / "tmp/pfaffian_rank2_idempotent_attack/PROOF_AUDIT.md",
    "fold_payload": REPO / "certificates/fold_normalization/payload.json",
    "fold_seal": REPO / "certificates/fold_normalization/SEAL.json",
    "target_H": REPO / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv",
    "target_seal": REPO / "certificates/target_branch_global/SEAL.json",
    "target_mod3_report": REPO / "certificates/TARGET_BRANCH_MOD3_CLASS_GROUP.md",
    "target_mod3_payload": REPO / "certificates/target_branch_mod3/payload.json",
    "target_mod3_seal": REPO / "certificates/target_branch_mod3/SEAL.json",
    "fano_c0_model": REPO / "certificates/fano_interface_c0/C0_MODEL.md",
    "fano_c0_seal": REPO / "certificates/fano_interface_c0/SEAL.json",
}


def digest(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def load(name: str) -> dict:
    return json.loads(SOURCES[name].read_text())


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def main() -> None:
    goal_f = load("goal_f_seal")
    field_presentation = load("field_presentation")
    fixed_forms = load("fixed_five_forms")
    fixed_frame_seal = load("fixed_frame_seal")
    infinity = load("goal_f_infinity")
    pfaffian = load("pfaffian_seal")
    corner = load("quaternion_corner")
    fold = load("fold_payload")
    target = load("target_seal")
    target_mod3 = load("target_mod3_payload")
    target_mod3_seal = load("target_mod3_seal")
    c0 = load("fano_c0_seal")

    require(goal_f["exit"] == "F-CONIC-CRITERION-EMPTY", "Goal F exit drift")
    require(goal_f["headline"] == "OPEN", "Goal F headline drift")
    require(field_presentation["primitive_equation"] == "P(A,B,Y,Z,u)=0",
            "ordered field presentation drift")
    require(field_presentation["selected_embedding"]["u"] == "class of u modulo P",
            "ordered root drift")
    require(fixed_forms["equation"] ==
            "F0 + A*FA + B*FB + Y*FY + (Z + kappa*A^2)*FZ = 0",
            "fixed-frame equation drift")
    require(fixed_forms["kappa_equals"] == "-11/18", "fixed-frame kappa drift")
    require(fixed_frame_seal["files"]["five_forms.json"] == digest(SOURCES["fixed_five_forms"]),
            "fixed-frame seal mismatch")
    require(field_presentation["payload_sha256"]["global_primitive_u_sextic_exact.tsv"] ==
            digest(SOURCES["primitive_sextic"]), "primitive sextic seal mismatch")
    require(infinity["leading_coefficient"]["factorization"] ==
            "c6=38263752*B^2*(A-15)*D", "infinity factor drift")
    require(pfaffian["gate1_decision"] == "FAIL-SCOPE", "Pfaffian scope drift")
    require(corner["equivalence_with_installed_cubic"]["systems_equivalent"] is False,
            "auxiliary and Fano systems were incorrectly identified")
    require(corner["idempotent_space_classification"]["K_points"] == "nonempty",
            "auxiliary projector nonemptiness drift")
    require("rank two after splitting" in SOURCES["projector_proof_audit"].read_text(),
            "primary projector-rank identity drift")
    require(fold["claims"]["selected_component_is_mult1_simple_fold"] is True,
            "target fold drift")
    require(fold["claims"]["generic_rank"] == 1, "target residue degree drift")
    require(fold["lc_u"]["H_does_not_divide_lc"] is True, "target lc gate drift")
    require(target["H_primitive_sha256"] == digest(SOURCES["target_H"]),
            "target H hash drift")
    require(target_mod3["accepted_theory"]["residue_degree_m"] == 1,
            "BR-T-NEG residue degree drift")
    require(target_mod3["accepted_theory"]["generic_cubic_smooth_on_branch"] is True,
            "BR-T-NEG generic smoothness drift")
    require(target_mod3["verdict"]["three_primary_defect"] == "NOT_DECIDED",
            "BR-T-NEG mod-three boundary drift")
    require(target_mod3_seal["payload_sha256"] == digest(SOURCES["target_mod3_payload"]),
            "target mod-three seal mismatch")
    require(c0["exit"] == "C0-UNDECIDED", "Fano-model boundary drift")

    exact_dir = HERE / "exact"
    exact_dir.mkdir(exist_ok=True)
    exact_copies = {
        "field_presentation.json": SOURCES["field_presentation"],
        "global_primitive_u_sextic_exact.tsv": SOURCES["primitive_sextic"],
        "five_forms.json": SOURCES["fixed_five_forms"],
    }
    for destination, source in exact_copies.items():
        shutil.copyfile(source, exact_dir / destination)

    payload = {
        "schema": "klein-goal-b-fixed-frame-bridge-v1",
        "exit": "B-UNDECIDED",
        "headline": "OPEN",
        "pinned_goal_commit": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "live_commit_at_start": "37d61c19a108781cf74af837e24810a9f7f7c3be",
        "source_sha256": {name: digest(path) for name, path in SOURCES.items()},
        "exact_payloads": {
            name: {
                "local_path": f"exact/{name}",
                "source_sha256": digest(source),
                "local_sha256": digest(exact_dir / name),
            }
            for name, source in exact_copies.items()
        },
        "fields": {
            "base": "F=C(A,B,Y,Z)",
            "extension": "K_proj=Frac(F[u]/(P(A,B,Y,Z,u)))",
            "degree": 6,
            "ordered_embedding": "u maps to the class of u modulo the exact primitive sextic P",
            "primitive_sextic_payload": "exact/global_primitive_u_sextic_exact.tsv",
        },
        "objects": {
            "generic_twist": {
                "scheme": "X_gen=T_proj times^G X, the fppf contracted product",
                "functor": "X_gen(R)=G-equivariant R-morphisms T_proj,R -> X_R; equivalently cocycle-compatible points after a faithfully flat splitting cover",
                "hilbert90_equation": "F_Klein(H^(-1)x)=0",
                "klein_form": "x0^2*x1+x1^2*x2+x2^2*x3+x3^2*x4+x4^2*x0",
                "expanded_K_proj_frame_installed": False,
                "equation_scope": "splitting-frame presentation of the exact contracted-product functor",
            },
            "fano_section": {
                "ambient": "P^2_D=SB_2(A_proj), A_proj=M_3(D)",
                "functor": "locally direct-summand right D_R-submodules L of D_R^3 of D_R-rank one with every h_i restricted to L times L zero",
                "equations": [f"h_{i}(q,q)=0" for i in range(1, 6)],
                "chart": "q=(1,x,y), x,y in D: five scalar equations in eight scalar coordinates",
                "explicit_quaternion_symbol_and_H_i_matrices_installed": False,
            },
            "auxiliary_characteristic_cubic": {
                "affine_ambient": "Sym(A_proj,sigma), dimension 15",
                "full_affine_cone": "Z_aux_aff={a in Sym:c3(a)=0}",
                "full_projective_cubic": "Z_aux={[a] in P(Sym):c3(a)=0}",
                "projective_spectral_open": "P_aux=Z_aux cap D(c2)",
                "projector": "p(a)=(a^2-c1(a)*a+c2(a)*1)/c2(a)",
                "section": "line projector p maps to a=1-p",
                "K_points": True,
            },
            "fixed_ternary_cubic": {
                "frame": "a=X*S0+y*S1+w*S2",
                "equation": "F0+A*FA+B*FB+Y*FY+(Z-11*A^2/18)*FZ=0",
                "field": "F then ordered base change to K_proj",
                "coefficient_payload": "exact/five_forms.json",
                "K_points": False,
            },
        },
        "arrows": [
            {"source": "fixed_ternary_cubic", "target": "Z_aux",
             "class": "closed projective linear slice",
             "field": "K_proj after ordered base change"},
            {"source": "fixed_ternary_open", "target": "auxiliary_characteristic_open",
             "class": "locally closed linear slice; sufficient construction only",
             "field": "K_proj"},
            {"source": "auxiliary_characteristic_open", "target": "structure_projectors",
             "class": "functional-calculus surjection on the spectral open; section p maps to a=1-p",
             "field": "K_proj"},
            {"source": "auxiliary_characteristic_open", "target": "Z_aux",
             "class": "open immersion; full cubic also has the c2=0 boundary",
             "field": "K_proj"},
            {"source": "structure_projectors", "target": "P^2_D",
             "class": "open immersion of h_struct-nondegenerate right lines",
             "field": "K_proj"},
            {"source": "F14_T", "target": "P^2_D",
             "class": "closed five-form incidence locus; not necessarily contained in the projector open",
             "field": "K_proj"},
            {"source": "structure_projector", "target": "F14_T common line",
             "class": "no implication; five additional simultaneous equations",
             "field": "not repaired by a splitting-field Morita gauge"},
            {"source": "F14_T(K_proj) point", "target": "X_gen(K_proj) point",
             "class": "sufficient construction by accepted Pfaffian incidence",
             "field": "K_proj"},
            {"source": "X_gen(K_proj) point", "target": "G-unirationality",
             "class": "accepted versal-compression criterion",
             "field": "K_proj/C"},
        ],
        "gauge": {
            "morita_change_of_basis": "GL_3(D) transports both the line and H_T and is not an action with H_T fixed",
            "distinguished_rational_gauge": "Gamma=PGU(h_struct) cap Stab_{PGL_3(D)}(H_T)",
            "splitting_field_change_sufficient": False,
            "ordered_root_conjugation_discarded": False,
        },
        "B1": {
            "auxiliary_slice_nonexhaustive": True,
            "proof": "I_sigma(K_proj) minus the image of C_K^open(K_proj) on K-points is nonempty",
            "geometric_or_scheme_image_nonexhaustive_proved": False,
            "genuine_F14_missed_K_orbit_proved": False,
            "five_plane_stabilizer_torsor_obstruction_proved": False,
            "exhaustiveness_on_F14": "UNDECIDED",
            "reason": "the known auxiliary projector need not satisfy any h_i(q,q)=0",
        },
        "B2": {
            "infinity": {
                "base_prime": "D_infinity divides lc_u(P)=c6",
                "ordered_root": "s=1/u=0",
                "ramification_index": 1,
                "residue_degree": 1,
                "residual_index": 3,
            },
            "target": {
                "base_prime": "H, irreducible multiplicity-one factor of Res_u(P,P_u)",
                "H_total_degree": 43,
                "lc_u_is_unit_generically": True,
                "ordered_root": "finite simple double root: P=P_u=0, P_uu unit",
                "ramification_index": 2,
                "residue_degree": 1,
                "generic_residual_cubic_smooth": True,
                "residual_index": "OPEN",
                "three_primary_class_group_gate": "OPEN",
            },
            "same_base_valuation": False,
            "same_ordered_residue_embedding": False,
            "compatible_residual_family_proved": False,
            "accepted_common_theorem_open": False,
            "abstract_residue_field_birationality": "not tested and insufficient",
        },
        "formal_section_counterexample": {
            "field": "K0=C((s))((t))",
            "plane": "x^3+s*y^3+t*z^3=0",
            "plane_index": 3,
            "ambient": "x^3+s*y^3+t*z^3+w^2*x+q^3=0 in P^4",
            "ambient_point": [0, 0, 0, 1, 0],
            "ambient_smooth": True,
            "scope": "refutes only the formal plane-section principle, not the actual Klein implication",
        },
        "smallest_live_gate": {
            "positive": "a common isotropic right D-line for H_T outside the selected frame",
            "negative": "a five-plane-preserving exhaustiveness theorem or a direct valuation/class-group proof on F14_T or X_gen",
        },
        "not_proved": [
            "F14_T(K_proj) is empty or nonempty",
            "X_gen(K_proj) is empty or nonempty",
            "the actual fixed-frame implication is true or false",
            "the target-branch Cl/Pic mod 3 gate",
            "a Klein-cubic headline",
        ],
    }

    (HERE / "bridge_payload.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("B_BRIDGE_PAYLOAD_PRODUCED")
    print("B_UNDECIDED")


if __name__ == "__main__":
    main()
