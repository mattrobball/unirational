#!/usr/bin/env python3
"""Exact nonsplit-node contact audit on B-Z+133=0 inside A=15,Y=12.

The literal normal y-slice has cubic-discriminant order four, although the
two-parameter discriminant is p^2*s in regular base coordinates. After splitting the
generic node, the completed total-incidence model is uv=p^2*s and has class
group Z.  The node is not split over the actual stratum function field:
quadratic Galois acts by -1 on that Z.  Restriction-corestriction therefore
shows that the actual local class group has zero quotient modulo three (and
no 3-primary torsion).

Only t3_disc_plane_nonsplit_contact_* discovery artifacts are written beside this
file.
"""

from __future__ import annotations

import gzip
import hashlib
import importlib.util
import json
from pathlib import Path

from sympy.polys.rings import ring


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
CUSP_SCRIPT = HERE / "t3_disc_plane_cusp_m3.py"
FORMS_PATH = ROOT / "certificates/fixed_frame_arithmetic/five_forms.json"
DELTA_PATH = HERE / "t3_disc_delta_cub_qzeta11.json.gz"
CONTACT_PATH = HERE / "t3_disc_plane_contact_qzeta11.json.gz"
NODE_PATH = HERE / "t3_disc_plane_node_payload.json.gz"
OUTPUT_GZ = HERE / "t3_disc_plane_nonsplit_contact_payload.json.gz"
SUMMARY_PATH = HERE / "t3_disc_plane_nonsplit_contact_summary.json"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


cusp = load_module("t3_disc_cusp_helpers_for_nonsplit", CUSP_SCRIPT)
plane = cusp.plane
disc = cusp.disc
K = cusp.K
BR, B, Z = cusp.BR, cusp.B, cusp.Z
LR, zline = ring("zline", K)


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_hash(value) -> str:
    return hashlib.sha256(
        json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest()


def load_bz(records):
    return cusp.load_bz(records)


def stats(poly):
    return cusp.stats(poly)


def serialize_line(poly):
    return cusp.serialize_line(poly)


def restrict_line(poly):
    answer = LR.zero
    b_value = zline - K(133)
    for (b_exponent, z_exponent), coefficient in poly.terms():
        answer += LR(coefficient) * b_value**b_exponent * zline**z_exponent
    return answer


def line_valuation(poly, line):
    return cusp.line_valuation(poly, line)


def evaluate_mod67(poly, b_value, z_value):
    return cusp.evaluate_mod67(poly, b_value, z_value)


def evaluate_line_mod67(poly, z_value):
    answer = 0
    for (exponent,), coefficient in poly.terms():
        answer += (
            disc.reduce_coefficient(coefficient, 67, 9)
            * pow(z_value, exponent, 67)
        )
    return answer % 67


def coefficient_is_rational(value) -> bool:
    serialized = disc.serialize_k11(value)
    return all(numerator == 0 for numerator, _denominator in serialized[1:])


def main():
    with gzip.open(DELTA_PATH, "rt") as stream:
        delta_terms = json.load(stream)["delta_terms"]
    with gzip.open(CONTACT_PATH, "rt") as stream:
        contact = json.load(stream)
    with gzip.open(NODE_PATH, "rt") as stream:
        node = json.load(stream)

    hessian = load_bz(node["hessian"]["determinant_polynomial_BZ"])
    hessian_line = B + K(8) * Z - K(992)
    hessian_unit = hessian.LC
    assert hessian == BR(hessian_unit) * hessian_line
    direction = load_bz(
        node["singular_scheme"]["affine_direction_resultant"]["polynomial_BZ"]
    )
    direction_cubic = direction / direction.LC
    assert all(coefficient_is_rational(value) for _monomial, value in direction_cubic.terms())
    infinity_obstruction = load_bz(
        node["singular_scheme"]["infinity_restricted_equations"]
        ["obstruction_polynomial_BZ"]
    )

    h_a = plane.restricted_h_derivative(1, 0)
    h_aa = plane.restricted_h_derivative(2, 0)
    h_ay = plane.restricted_h_derivative(1, 1)
    h_ayy = plane.restricted_h_derivative(1, 2)
    h_yy = plane.restricted_h_derivative(0, 2)
    h_yyy = plane.restricted_h_derivative(0, 3)
    h_yyyy = plane.restricted_h_derivative(0, 4)
    d_a = plane.restricted_delta_derivative(delta_terms, 1, 0)
    d_aa = plane.restricted_delta_derivative(delta_terms, 2, 0)
    d_ay = plane.restricted_delta_derivative(delta_terms, 1, 1)
    d_ayy = plane.restricted_delta_derivative(delta_terms, 1, 2)
    d_yy = plane.restricted_delta_derivative(delta_terms, 0, 2)
    d_yyy = plane.restricted_delta_derivative(delta_terms, 0, 3)
    d_yyyy = plane.restricted_delta_derivative(delta_terms, 0, 4)
    n2 = d_yy * h_a - d_a * h_yy
    assert n2 == load_bz(contact["polynomials"]["N"])
    n3 = (
        K(3) * d_a * h_ay * h_yy
        - d_a * h_yyy * h_a
        - K(3) * d_ay * h_yy * h_a
        + d_yyy * h_a**2
    )

    cancellation_line = B - Z + K(133)
    l_valuation_n2, n2_after_l = line_valuation(n2, cancellation_line)
    assert l_valuation_n2 == 1
    assert restrict_line(n2_after_l)
    n3_on_line = restrict_line(n3)
    assert not n3_on_line
    assert restrict_line(h_a)
    assert restrict_line(d_a)
    assert restrict_line(hessian)
    assert restrict_line(direction)
    assert restrict_line(infinity_obstruction)

    # Fourth coefficient on the literal L=0 slice.  If c_i=[y^i](A-15),
    # then [y^4](Delta|H)=N4/(24*H_A^3).  Work after restriction to L to
    # keep the exact certificate compact.
    la = restrict_line(h_a)
    laa = restrict_line(h_aa)
    lay = restrict_line(h_ay)
    layy = restrict_line(h_ayy)
    lyy = restrict_line(h_yy)
    lyyy = restrict_line(h_yyy)
    lyyyy = restrict_line(h_yyyy)
    lda = restrict_line(d_a)
    ldaa = restrict_line(d_aa)
    lday = restrict_line(d_ay)
    ldayy = restrict_line(d_ayy)
    ldyyyy = restrict_line(d_yyyy)
    t4_on_line = (
        K(3) * laa * lyy**2
        + K(12) * lay**2 * lyy
        - K(4) * la * lay * lyyy
        - K(6) * la * layy * lyy
        + la**2 * lyyyy
    )
    n4_on_line = (
        -lda * t4_on_line
        + K(3) * ldaa * lyy**2 * la
        + K(4) * lday * (K(3) * lay * lyy - la * lyyy) * la
        - K(6) * ldayy * lyy * la**2
        + ldyyyy * la**3
    )
    assert n4_on_line

    # The exact H_A-unit quotient of the y^2 coefficient has only the three
    # geometrically relevant factors L, the reducibility cubic, and h^2.
    valid_factor_product = cancellation_line * direction_cubic * hessian_line**2
    h_a_common_part, remainder = divmod(n2, valid_factor_product)
    assert not remainder
    h_a_residual_factor, remainder = divmod(h_a, h_a_common_part)
    assert not remainder
    assert h_a_residual_factor / h_a_residual_factor.LC == (
        B - K(10) * Z + K(1258)
    )
    assert valid_factor_product.gcd(h_a_residual_factor).degree() == 0

    # The tangent discriminant has odd order at Z=125 on the line, so it is
    # not a square in K(Z), independently of the constant square class.
    hessian_on_line = restrict_line(hessian)
    expected_hessian_on_line = LR(hessian_unit * K(9)) * (zline - K(125))
    assert hessian_on_line == expected_hessian_on_line

    # Common good reduction on the line witnesses every required generic unit.
    witness = None
    for z_value in range(67):
        b_value = (z_value - 133) % 67
        values = {
            "H_A": evaluate_mod67(h_a, b_value, z_value),
            "Delta_A": evaluate_mod67(d_a, b_value, z_value),
            "N2_over_L": evaluate_mod67(n2_after_l, b_value, z_value),
            "N4_on_L": evaluate_line_mod67(n4_on_line, z_value),
            "fibre_hessian": evaluate_mod67(hessian, b_value, z_value),
            "direction_resultant": evaluate_mod67(direction, b_value, z_value),
            "infinity_obstruction": evaluate_mod67(
                infinity_obstruction, b_value, z_value
            ),
        }
        if all(values.values()) and (z_value - 125) % 67:
            witness = {
                "prime": 67,
                "zeta11": 9,
                "point_BZ": [b_value, z_value],
                "cancellation_line": (b_value - z_value + 133) % 67,
                "values": values,
            }
            break
    assert witness is not None

    named_restrictions = {
        "H_A_on_L": restrict_line(h_a),
        "Delta_A_on_L": restrict_line(d_a),
        "N2_over_L_on_L": restrict_line(n2_after_l),
        "N3_on_L": n3_on_line,
        "N4_on_L": n4_on_line,
        "hessian_on_L": hessian_on_line,
        "direction_resultant_on_L": restrict_line(direction),
        "infinity_obstruction_on_L": restrict_line(infinity_obstruction),
    }
    serialized_restrictions = {
        name: serialize_line(poly) for name, poly in named_restrictions.items()
    }

    payload = {
        "schema": "klein-cubic-t3-plane-nonsplit-contact-exact-v1",
        "field": "K=QQ(zeta11)",
        "base_stratum": {
            "target_equation": "H=0",
            "plane": ["A-15", "Y-12"],
            "line_L": "B-Z+133",
            "function_field": "k=K(Z), with B=Z-133",
            "H_A_unit": True,
            "normalization_isomorphism": True,
            "normal_parameter": "p=Y-12",
        },
        "exact_valid_factorization": {
            "formula": (
                "N2=G21*(B-Z+133)*C3*(B+8*Z-992)^2, "
                "H_A=G21*unit*(B-10*Z+1258)"
            ),
            "G21_stats": stats(h_a_common_part),
            "H_A_residual_factor_stats": stats(h_a_residual_factor),
            "coprime_valid_product_and_H_A_residual": True,
            "C3_is_direction_resultant_up_to_unit": True,
            "C3_coefficients_rational": True,
        },
        "contact": {
            "Delta_on_H": "p^2*q",
            "q_mod_p": "N2/(2*H_A)",
            "N2_line_L_valuation": l_valuation_n2,
            "N2_over_L_unit": True,
            "p3_coefficient": "N3/(6*H_A^2)",
            "N3_restricts_to_zero_on_L": True,
            "p4_coefficient_on_L": "N4_on_L/(24*H_A_on_L^3)",
            "N4_on_L_nonzero": True,
            "normal_slice_L_zero_contact_order": 4,
            "regular_base_coordinate": (
                "s=q is a parameter transverse to p because dq/dL is a unit; "
                "therefore Delta=p^2*s in completed base coordinates."
            ),
            "height_one_warning": (
                "The unspecialized height-one plane valuation is still two; "
                "m=4 is the p-adic order on the codimension-two slice L=0."
            ),
        },
        "central_cubic": {
            "fibre_hessian_unit": True,
            "direction_resultant_unit": True,
            "infinity_obstruction_unit": True,
            "type_over_kbar": "exactly one ordinary node",
            "hessian_square_class_on_L": "unit_K*9*(Z-125)",
            "nonsquare_reason": (
                "Its valuation at the prime Z-125 of K(Z) is odd."
            ),
            "split_over_actual_function_field": False,
            "quadratic_splitting_field": "k(sqrt(-det(tangent quadratic)))",
        },
        "completed_local_model": {
            "after_quadratic_split": "k'[[u,v,p,s]]/(u*v-p^2*s)",
            "split_height_one_classes": ["W_p=(u,p)", "W_s=(u,s)"],
            "split_relation": "2*W_p+W_s=0",
            "split_class_group": "Z generated by W_p",
            "split_class_group_mod_3": "Z/3",
            "galois_action": (
                "The quadratic involution swaps u and v, hence sends "
                "W_p to (v,p)=-W_p."
            ),
            "actual_field_conclusion": (
                "Restriction lands in the fixed subgroup Z^{sigma=-1}=0; "
                "corestriction after restriction is multiplication by two. "
                "Thus every actual-field class has exponent dividing two."
            ),
            "actual_class_group_mod_3": 0,
            "actual_3_primary_torsion": 0,
        },
        "polynomial_stats": {
            "N2": stats(n2),
            "N2_over_L": stats(n2_after_l),
            "N3": stats(n3),
            "N4_on_L": stats(n4_on_line),
        },
        "line_restriction_sha256": {
            name: canonical_hash(value) for name, value in serialized_restrictions.items()
        },
        "line_restrictions": serialized_restrictions,
        "mod67_witness": witness,
        "verdict": {
            "normal_slice_m_equals": 4,
            "split_model_has_free_mod3_class": True,
            "split_class_descends": False,
            "actual_local_Cl_mod_3": 0,
            "actual_local_Cl_3_primary": 0,
            "dangerous_actual_field_class_found": False,
        },
        "scope": (
            "Exact completed-local and descent audit at the generic point of "
            "L inside the deleted plane.  It does not classify closed "
            "intersections with the cusp/reducibility/infinity loci or prove "
            "the global T3.E ledger exhaustive."
        ),
        "source_sha256": {
            str(FORMS_PATH.relative_to(ROOT)): file_hash(FORMS_PATH),
            str(DELTA_PATH.relative_to(HERE)): file_hash(DELTA_PATH),
            str(CONTACT_PATH.relative_to(HERE)): file_hash(CONTACT_PATH),
            str(NODE_PATH.relative_to(HERE)): file_hash(NODE_PATH),
            str(CUSP_SCRIPT.relative_to(HERE)): file_hash(CUSP_SCRIPT),
        },
    }

    encoded = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
    OUTPUT_GZ.write_bytes(gzip.compress(encoded, compresslevel=9, mtime=0))
    summary = {
        key: payload[key]
        for key in (
            "schema",
            "field",
            "base_stratum",
            "exact_valid_factorization",
            "contact",
            "central_cubic",
            "completed_local_model",
            "polynomial_stats",
            "line_restriction_sha256",
            "mod67_witness",
            "verdict",
            "scope",
            "source_sha256",
        )
    }
    summary.update(
        {
            "payload": OUTPUT_GZ.name,
            "payload_sha256": file_hash(OUTPUT_GZ),
            "payload_uncompressed_bytes": len(encoded),
            "payload_gzip_bytes": OUTPUT_GZ.stat().st_size,
        }
    )
    SUMMARY_PATH.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print(json.dumps(summary, indent=2, sort_keys=True))
    print("T3_DISC_PLANE_NONSPLIT_NORMAL_SLICE_M4_ACTUAL_CL_MOD3_ZERO")


if __name__ == "__main__":
    main()
