#!/usr/bin/env python3
"""Write separate exact point payloads for the two installed A5 classes."""

from __future__ import annotations

import json
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import exact_reynolds as exact  # noqa: E402


def conjugated_relations(relations, radical_sign):
    output = {}
    for name, components in relations.items():
        values = list(components)
        if radical_sign == -1:
            values[2] = str(-__import__("fractions").Fraction(values[2]))
            values[3] = str(-__import__("fractions").Fraction(values[3]))
        output[name] = values
    return output


def class_payload(class_index, relations):
    radical_sign = -1 if class_index == 1 else 1
    sign_text = "-" if class_index == 1 else "+"
    return {
        "format": "klein-a5-degree11-exact-point-v1",
        "class": f"A5_class_{class_index}",
        "exit": f"H-A5-CLASS{class_index}-RATIONAL-POINT",
        "constant_field": {
            "description": "Q(s,g,alpha) embedded in C",
            "relations": ["s^2=5", "g^2=-11"],
            "pencil_parameter": f"t=(13{sign_text}g)/18",
            "primitive_element_for_verifier_only": {
                "name": "w",
                "definition": "w=s+g",
                "minimal_polynomial": "w^4+12*w^2+256",
                "s": "(4*w-w^3)/32",
                "g": "(w^3+28*w)/32",
            },
        },
        "canonical_target": {
            "model": "augmentation module for A5 acting on its six Sylow-5 subgroups",
            "coordinates": ["x0", "x1", "x2", "x3", "x4"],
            "sixth_coordinate": "x5=-(x0+x1+x2+x3+x4)",
            "cubic": f"O0+((13{sign_text}g)/18)*O1",
            "orbit_cubics": "O0_TRIPLES and O1_TRIPLES in exact_reynolds.py",
        },
        "degree_11_covariant": {
            "source": "faithful icosahedral three-space over Q(s)",
            "basis_file": "../degree11_covariants_raw_exact.json",
            "basis_symbols": ["C0", "C1", "C2", "C3", "C4"],
            "parameter_vector": [
                "1",
                "a1_0+a1_1*alpha+a1_2*alpha^2",
                "a2_0+a2_1*alpha+a2_2*alpha^2",
                "a3_0+a3_1*alpha+a3_2*alpha^2",
                "alpha",
            ],
            "map": "Phi_i(y)=C0(y)+a1*C1(y)+a2*C2(y)+a3*C3(y)+alpha*C4(y)",
            "nonzero_reason": "the five Cj are independent and the C0 coefficient is 1",
        },
        "closed_point_relations": conjugated_relations(relations, radical_sign),
        "relation_basis": ["1", "s", "g", "s*g"],
        "alpha_equation": "alpha^3+p2*alpha^2+p1*alpha+p0=0",
        "installed_coordinates": {
            "canonical_intertwiner": (
                f"J_{class_index}=canonical_a5_pencil.intertwiner on the separately "
                f"enumerated A5_class_{class_index} generators"
            ),
            "ambient_map": f"Psi_{class_index}(y)=J_{class_index}*Phi_{class_index}(y)",
            "twist_point": f"z_{class_index}(y)=A_{class_index}(y)^(-1)*Psi_{class_index}(y)",
            "invariance_reason": (
                "A_i(sigma(h)y)=rho_i(h)A_i(y) and "
                "Psi_i(sigma(h)y)=rho_i(h)Psi_i(y), so z_i is H_i-invariant"
            ),
            "equation_check": "F(A_i*z_i)=F(Psi_i)=0 exactly",
        },
        "scope": {
            "induced_by_equivariant_map": True,
            "map_degree": 11,
            "consequence": "the installed genuine generic A5 twist has a rational point",
            "full_group_boundary": (
                "this is subgroup-positive for A5 and does not construct a point on the "
                "PSL_2(F_11) generic twist"
            ),
        },
        "verification": {
            "command": "/opt/homebrew/bin/python3 -u ../verify_exact_point.py",
            "terminal_marker": "H3_EXACT_BOTH_A5_POINTS_VERIFIED",
            "exact_checks": [
                "five raw Reynolds covariants are independent and equivariant",
                "dim Inv_33=6 and the six evaluations are injective",
                "all six landing values vanish in the cubic alpha quotient",
                "the installed canonical pullbacks have the two roots of 9*t^2-13*t+5",
                "radical conjugation is checked by a second six-equation substitution",
            ],
        },
        "mod_89_warning": (
            "the earlier smooth/nonempty mod-89 points are NONVERDICT by themselves; "
            "the conclusion uses exact characteristic-zero substitution"
        ),
    }


def main():
    relation_payload = json.loads((HERE / "degree11_reconstructed_relations.json").read_text())
    source = exact.exact_source_representation()
    covariants = [exact.reynolds_covariant(*seed, source) for seed in exact.SEEDS]
    covariant_path = HERE / "degree11_covariants_raw_exact.json"
    covariant_path.write_text(json.dumps({
        "format": "a5-degree11-raw-reynolds-covariants-v1",
        "field": "Q(s), s^2=5",
        "seeds": [[output, list(exponent)] for output, exponent in exact.SEEDS],
        "normalization": "raw Reynolds sums; no column normalization",
        "covariants": exact.serialize_covariants(covariants),
    }, indent=2, sort_keys=True) + "\n")
    for class_index in (1, 2):
        directory = HERE / f"class_{class_index}"
        directory.mkdir(exist_ok=True)
        path = directory / "POINT.json"
        path.write_text(json.dumps(
            class_payload(class_index, relation_payload["relations"]),
            indent=2,
            sort_keys=True,
        ) + "\n")
        print("wrote", path)
    print("H3_POINT_PAYLOADS_OK")


if __name__ == "__main__":
    main()
