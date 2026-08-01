#!/opt/homebrew/bin/python3
"""Assemble the exact descended elliptic-quintic Hilbert-component payload."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM_ROOT = HERE.parents[1]
OLD_R = PROBLEM_ROOT / "goals_2026-08-01/R_RATIONAL_CURVES_ROOT_20260801A"


def load(path: Path):
    return json.loads(path.read_text(encoding="utf-8"))


def digest(path: Path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    fixed_path = OLD_R / "fixed_jacobian_payload.json"
    cohomology_path = OLD_R / "group_cohomology_payload.json"
    schur_path = PROBLEM_ROOT / "tmp/pfaffian_generic_schur_audit/certificate.json"
    alignment_path = PROBLEM_ROOT / "tmp/pfaffian_representation_alignment/certificate.json"
    universal_path = HERE / "pfaffian_quintic_universal.json"

    fixed = load(fixed_path)
    cohomology = load(cohomology_path)
    schur = load(schur_path)
    alignment = load(alignment_path)
    universal = load(universal_path)

    assert fixed["deduction"]["fixed_subgroup"] == "trivial"
    assert cohomology["checks"]["H1_dimension_mod_3"] == 0
    assert schur["generic_index"] == 2
    assert schur["generic_schur_class"] == "nonzero of index two"
    assert alignment["exact_intertwiner"]["rank"] == 5
    assert universal["geometric_interpretation"]["expected_degree"] == 5

    dependencies = {
        str(fixed_path.relative_to(PROBLEM_ROOT)): digest(fixed_path),
        str(cohomology_path.relative_to(PROBLEM_ROOT)): digest(cohomology_path),
        str(schur_path.relative_to(PROBLEM_ROOT)): digest(schur_path),
        str(alignment_path.relative_to(PROBLEM_ROOT)): digest(alignment_path),
        universal_path.name: digest(universal_path),
    }
    payload = {
        "schema": "klein-r2-descended-elliptic-quintic-v1",
        "field": "K_proj = C(P(W))^PSL_2(F_11)",
        "generic_torsor": "Spec C(P(W)) -> Spec K_proj",
        "selected_component": {
            "name": "smooth elliptic normal quintics on the Klein cubic",
            "hilbert_polynomial": "5*t",
            "geometric_dimension": 10,
            "bundle_moduli_dimension": 5,
            "geometric_fibre": "P^5 = P(H^0(E(1)))",
            "tangent_dimension": 10,
            "obstruction_h1_normal": 0,
            "geometric_integrality_witness": "smooth prime degree-five genus-one good reduction at (23,zeta_11=2), lambda=(1,0,0,0,0,0)",
        },
        "abel_jacobi_descent": {
            "fixed_group": "J(C)^G = 0",
            "torsion_module": "H^1(G,J[3]) = 0",
            "degree_torsor_consequence": "the degree-two cycle torsor J_2 has one G-fixed point q_2",
            "moduli_consequence": "the only K_proj-point of the twisted bundle-moduli open is the Pfaffian bundle E_0 over q_2",
        },
        "pfaffian_model": {
            "module_embedding": "B_5 -> wedge^2(V_6^*)",
            "bundle": "E_0(1)=K^*",
            "section_space": "H^0(E_0(1))=V_6^*",
            "universal_equations": "A(x)*lambda=0, where M(x)*A(x)=Pf(M(x))*I_6",
            "payload": universal_path.name,
        },
        "descent_obstruction": {
            "twisted_fibre": "SB(A_proj^op)",
            "brauer_class": "-alpha_proj = alpha_proj != 0",
            "index": 2,
            "rational_points": "empty",
            "zero_cycle_index": 2,
            "component_K_points": "empty",
            "proof_chain": [
                "every Hilbert K-point maps to the unique q_2",
                "the unique bundle over q_2 is E_0",
                "its section fibre twists to SB(A_proj^op)",
                "index(A_proj^op)=2, so that fibre has no K_proj-point",
            ],
        },
        "point_extraction_boundary": {
            "result": "no curve and no point are extracted because the selected Hilbert fibre is nonsplit",
            "scroll_gate": "a cubic-scroll residual quartic requires Pic^2(E)(K)",
            "torsor_classes": "the degree-five embedding gives 5*alpha=0; Pic^2(E)(K) gives 2*alpha=0; together they force alpha=0",
            "meaning": "the scroll construction cannot bypass the missing point on the elliptic curve",
        },
        "universal_curve_on_genuine_twist": {
            "verified_over_split_torsor": True,
            "descent": "the G-equivariant incidence descends over SB(A_proj^op)",
            "base_field_member": False,
            "reason": "SB(A_proj^op)(K_proj) is empty",
        },
        "dependencies_sha256": dependencies,
        "exit": "R2-DESCENT-OBSTRUCTED",
        "headline": "OPEN",
        "terminal_marker": "R2_DESCENDED_ELLIPTIC_QUINTIC_OBSTRUCTION_CERTIFIED",
    }
    output = HERE / "descended_hilbert_payload.json"
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8")
    print("wrote", output.name)
    print(payload["terminal_marker"])


if __name__ == "__main__":
    main()
