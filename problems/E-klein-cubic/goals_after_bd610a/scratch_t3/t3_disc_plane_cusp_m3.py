#!/usr/bin/env python3
"""Exact m=3 cusp-line audit inside the plane A=15, Y=12.

The plane is a height-one discriminant contact on the smooth target branch.
Its generic contact is two.  This script specializes further to the Hessian
line B+8*Z+992=0, computes the third normal coefficient exactly, and audits
the transverse Hessian of the *total* cubic incidence.  The latter separates
the slice contact order from the actual codimension-three local class group.

Only t3_disc_plane_cusp_m3_* discovery artifacts are written beside this file.
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
FORMS_PATH = ROOT / "certificates/fixed_frame_arithmetic/five_forms.json"
DELTA_PATH = HERE / "t3_disc_delta_cub_qzeta11.json.gz"
CONTACT_PATH = HERE / "t3_disc_plane_contact_qzeta11.json.gz"
NODE_PATH = HERE / "t3_disc_plane_node_payload.json.gz"
CONTACT_SCRIPT = HERE / "t3_disc_plane_contact.py"
OUTPUT_GZ = HERE / "t3_disc_plane_cusp_m3_payload.json.gz"
SUMMARY_PATH = HERE / "t3_disc_plane_cusp_m3_summary.json"


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


plane = load_module("t3_disc_plane_contact_for_cusp", CONTACT_SCRIPT)
disc = plane.disc
K = disc.K
BR, B, Z = plane.BR, plane.B, plane.Z
LR, zline = ring("zline", K)


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_hash(value) -> str:
    return hashlib.sha256(
        json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest()


def load_bz(records):
    return sum(
        (
            BR(disc.deserialize_k11(record["coefficient_qzeta11"]))
            * B ** record["exponents_BZ"][0]
            * Z ** record["exponents_BZ"][1]
            for record in records
        ),
        BR.zero,
    )


def serialize_bz(poly):
    return [
        {
            "exponents_BZ": list(monomial),
            "coefficient_qzeta11": disc.serialize_k11(coefficient),
        }
        for monomial, coefficient in poly.terms()
    ]


def serialize_line(poly):
    return [
        {
            "exponent_Z": monomial[0],
            "coefficient_qzeta11": disc.serialize_k11(coefficient),
        }
        for monomial, coefficient in poly.terms()
    ]


def stats(poly):
    terms = poly.terms()
    return {
        "terms": len(terms),
        "total_degree": max((sum(monomial) for monomial, _ in terms), default=-1),
        "degrees": [
            max((monomial[index] for monomial, _ in terms), default=-1)
            for index in range(poly.ring.ngens)
        ],
    }


def restrict_hessian_line(poly):
    answer = LR.zero
    b_value = -K(8) * zline + K(992)
    for (b_exponent, z_exponent), coefficient in poly.terms():
        answer += LR(coefficient) * b_value**b_exponent * zline**z_exponent
    return answer


def line_valuation(poly, line):
    exponent = 0
    quotient = poly
    while True:
        next_quotient, remainder = divmod(quotient, line)
        if remainder:
            return exponent, quotient
        quotient = next_quotient
        exponent += 1


def eval_unary(coefficients, value):
    answer = K.zero
    degree = len(coefficients) - 1
    for index, coefficient in enumerate(coefficients):
        answer += coefficient * value ** (degree - index)
    return answer


def eval_unary_derivative(coefficients, value):
    answer = K.zero
    degree = len(coefficients) - 1
    for index, coefficient in enumerate(coefficients):
        exponent = degree - index
        if exponent:
            answer += K(exponent) * coefficient * value ** (exponent - 1)
    return answer


def evaluate_mod67(poly, b_value, z_value):
    answer = 0
    for (b_exponent, z_exponent), coefficient in poly.terms():
        answer += (
            disc.reduce_coefficient(coefficient, 67, 9)
            * pow(b_value, b_exponent, 67)
            * pow(z_value, z_exponent, 67)
        )
    return answer % 67


def main():
    with gzip.open(DELTA_PATH, "rt") as stream:
        delta_terms = json.load(stream)["delta_terms"]
    with gzip.open(CONTACT_PATH, "rt") as stream:
        contact = json.load(stream)
    with gzip.open(NODE_PATH, "rt") as stream:
        node = json.load(stream)
    forms = json.loads(FORMS_PATH.read_text())
    slots = {
        name: [disc.deserialize_k11(value) for value in values]
        for name, values in forms["binary_slots"].items()
    }

    # Exact line and exceptional-cubic equations from the node packet.
    hessian = load_bz(node["hessian"]["determinant_polynomial_BZ"])
    hessian_line = B + K(8) * Z - K(992)
    assert hessian / hessian.LC == hessian_line
    direction_resultant = load_bz(
        node["singular_scheme"]["affine_direction_resultant"]["polynomial_BZ"]
    )
    infinity_obstruction = load_bz(
        node["singular_scheme"]["infinity_restricted_equations"]
        ["obstruction_polynomial_BZ"]
    )

    # Taylor data for H and Delta at A=15,Y=12.
    h_a = plane.restricted_h_derivative(1, 0)
    h_ay = plane.restricted_h_derivative(1, 1)
    h_yy = plane.restricted_h_derivative(0, 2)
    h_yyy = plane.restricted_h_derivative(0, 3)
    d_a = plane.restricted_delta_derivative(delta_terms, 1, 0)
    d_ay = plane.restricted_delta_derivative(delta_terms, 1, 1)
    d_yy = plane.restricted_delta_derivative(delta_terms, 0, 2)
    d_yyy = plane.restricted_delta_derivative(delta_terms, 0, 3)

    n2 = d_yy * h_a - d_a * h_yy
    assert n2 == load_bz(contact["polynomials"]["N"])
    n3 = (
        K(3) * d_a * h_ay * h_yy
        - d_a * h_yyy * h_a
        - K(3) * d_ay * h_yy * h_a
        + d_yyy * h_a**2
    )
    # If A=15+c2*y^2+c3*y^3+..., these are precisely
    # [y^2] Delta|H=N2/(2*H_A), [y^3] Delta|H=N3/(6*H_A^2).
    h_valuation_n2, n2_after_h = line_valuation(n2, hessian_line)
    assert h_valuation_n2 == 2
    assert restrict_hessian_line(n2_after_h)
    assert restrict_hessian_line(h_a)
    assert restrict_hessian_line(n3)
    assert restrict_hessian_line(direction_resultant)

    # Fixed singular point and fibre derivatives.
    x0 = disc.deserialize_k11(node["singular_point"]["projective_coordinates"][0])
    t0 = disc.deserialize_k11(node["singular_point"]["projective_coordinates"][1])
    f_xx = disc.deserialize_k11(node["hessian"]["entries"]["F_XX_at_point"])
    f_xt = disc.deserialize_k11(node["hessian"]["entries"]["F_Xt_at_point"])
    f_tt = load_bz(node["hessian"]["entries"]["F_tt_at_point_polynomial_BZ"])
    assert f_xx == K(6) * x0
    assert f_xx != K.zero
    assert f_xx * f_tt - BR(f_xt) ** 2 == hessian

    q_y_at = eval_unary(slots["qY"], t0)
    q_y_prime_at = eval_unary_derivative(slots["qY"], t0)
    r_y_at = eval_unary(slots["rY"], t0)
    r_y_prime_at = eval_unary_derivative(slots["rY"], t0)
    f_y = x0 * q_y_at + r_y_at
    f_xy = q_y_at
    f_ty = x0 * q_y_prime_at + r_y_prime_at
    assert f_y == K.zero

    # F_A includes d/dA of (Z-11*A^2/18)rZ at A=15.
    f_a = (
        x0 * eval_unary(slots["qA"], t0)
        + eval_unary(slots["rA"], t0)
        - K(55) / K(3) * eval_unary(slots["rZ"], t0)
    )
    # On H, A'(0)=0 and A''(0)=-H_YY/H_A.  Multiplying the determinant
    # of Hess_{X,t,y}(F|H) by H_A clears its sole denominator.
    total_hessian_numerator = (
        -BR(f_a) * h_yy * hessian
        + h_a
        * (
            K(2) * BR(f_xt * f_xy * f_ty)
            - BR(f_xx * f_ty**2)
            - f_tt * BR(f_xy**2)
        )
    )
    assert restrict_hessian_line(total_hessian_numerator)

    # A common split reduction witnesses all generic units simultaneously.
    witness = None
    n2_cofactor = n2_after_h
    for z_value in range(67):
        b_value = (-8 * z_value + 992) % 67
        values = {
            "H_A": evaluate_mod67(h_a, b_value, z_value),
            "N2_over_hessian_line_squared": evaluate_mod67(
                n2_cofactor, b_value, z_value
            ),
            "N3": evaluate_mod67(n3, b_value, z_value),
            "direction_resultant": evaluate_mod67(
                direction_resultant, b_value, z_value
            ),
            "infinity_obstruction": evaluate_mod67(
                infinity_obstruction, b_value, z_value
            ),
            "total_hessian_numerator": evaluate_mod67(
                total_hessian_numerator, b_value, z_value
            ),
        }
        if all(values.values()):
            witness = {
                "prime": 67,
                "zeta11": 9,
                "point_BZ": [b_value, z_value],
                "hessian_line": (b_value + 8 * z_value - 992) % 67,
                "values": values,
            }
            break
    assert witness is not None

    named_line_remainders = {
        "H_A_on_hessian_line": restrict_hessian_line(h_a),
        "N2_over_hessian_line_squared_on_hessian_line": restrict_hessian_line(
            n2_cofactor
        ),
        "N3_on_hessian_line": restrict_hessian_line(n3),
        "direction_resultant_on_hessian_line": restrict_hessian_line(
            direction_resultant
        ),
        "total_hessian_numerator_on_hessian_line": restrict_hessian_line(
            total_hessian_numerator
        ),
    }
    serialized_remainders = {
        name: serialize_line(poly) for name, poly in named_line_remainders.items()
    }

    payload = {
        "schema": "klein-cubic-t3-plane-cusp-m3-exact-v1",
        "field": "QQ(zeta11)",
        "base_stratum": {
            "target_equation": "H=0",
            "plane": ["A-15", "Y-12"],
            "hessian_line": "B+8*Z-992",
            "hessian_equals_unit_times_line": True,
            "H_A_unit_at_generic_line_point": True,
            "normal_parameter_on_H": "y=Y-12",
            "normalization": (
                "H_A is a unit at the generic line point, so H is smooth and "
                "its normalization is an isomorphism there."
            ),
        },
        "contact": {
            "A_series": {
                "y2": "-H_YY/(2*H_A)",
                "y3": "H_AY*H_YY/(2*H_A^2)-H_YYY/(6*H_A)",
            },
            "Delta_on_H_y2": "N2/(2*H_A)",
            "N2": "Delta_YY*H_A-Delta_A*H_YY",
            "N2_hessian_line_valuation": h_valuation_n2,
            "N2_cofactor_unit_at_generic_line_point": True,
            "Delta_on_H_y3": "N3/(6*H_A^2)",
            "N3": (
                "3*Delta_A*H_AY*H_YY-Delta_A*H_YYY*H_A"
                "-3*Delta_AY*H_YY*H_A+Delta_YYY*H_A^2"
            ),
            "N3_unit_at_generic_line_point": True,
            "normal_slice_contact_order": 3,
            "height_one_warning": (
                "This is the y-adic order after the codimension-two base "
                "specialization hessian_line=0.  The height-one plane valuation "
                "in the unspecialized normalized base remains two."
            ),
        },
        "central_cubic": {
            "fibre_hessian_rank": 1,
            "F_XX_nonzero": True,
            "direction_resultant_unit_at_generic_line_point": True,
            "type": "irreducible ordinary cusp A2",
            "not_nodal": True,
        },
        "total_incidence": {
            "transverse_variables": ["X-x0", "t-t0", "y=Y-12"],
            "singular_locus_parameter": "hessian_line inside the plane",
            "cleared_transverse_hessian_determinant": (
                "H_A*det(Hess_{X,t,y}(F restricted to H))"
            ),
            "cleared_determinant_unit_at_generic_line_point": True,
            "transverse_hessian_rank": 3,
            "formal_type_after_finite_2_power_separable_extension": (
                "ordinary A1 surface crossing times a smooth parameter, "
                "k[[s,u,v,w]]/(u*v-w^2)"
            ),
            "not_xy_equals_pi3_reason": (
                "xy=pi^3 has transverse quadratic rank two, whereas the exact "
                "total-incidence transverse Hessian here has rank three."
            ),
            "geometric_local_class_group": "Z/2",
            "three_primary_local_class_group": 0,
            "descent": (
                "A split form is reached after an extension of 2-power degree; "
                "restriction-corestriction therefore excludes odd-primary, "
                "in particular 3-primary, torsion before splitting."
            ),
        },
        "exact_polynomial_stats": {
            "N2": stats(n2),
            "N2_after_hessian_line_squared": stats(n2_cofactor),
            "N3": stats(n3),
            "total_hessian_numerator": stats(total_hessian_numerator),
        },
        "line_remainders": serialized_remainders,
        "line_remainder_sha256": {
            name: canonical_hash(value) for name, value in serialized_remainders.items()
        },
        "mod67_witness": witness,
        "verdict": {
            "normal_slice_m_equals": 3,
            "nodal_xy_equals_pi_m_template_applies": False,
            "actual_local_Cl_3": 0,
            "dangerous_three_primary_class_found": False,
        },
        "scope": (
            "Exact at the generic point of the Hessian line inside the deleted "
            "plane.  Intersections with the reducibility and infinity-failure "
            "loci, and the rest of the global T3.E ledger, are not classified here."
        ),
        "source_sha256": {
            str(FORMS_PATH.relative_to(ROOT)): file_hash(FORMS_PATH),
            str(DELTA_PATH.relative_to(HERE)): file_hash(DELTA_PATH),
            str(CONTACT_PATH.relative_to(HERE)): file_hash(CONTACT_PATH),
            str(NODE_PATH.relative_to(HERE)): file_hash(NODE_PATH),
            str(CONTACT_SCRIPT.relative_to(HERE)): file_hash(CONTACT_SCRIPT),
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
            "contact",
            "central_cubic",
            "total_incidence",
            "exact_polynomial_stats",
            "line_remainder_sha256",
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
    print("T3_DISC_PLANE_CUSP_NORMAL_SLICE_M3_BUT_CL3_ZERO")


if __name__ == "__main__":
    main()
