#!/usr/bin/env python3
"""Exact divisibility checks on special curves inside A=15,Y=12.

This compares the exact contact numerator N with the Hessian determinant and
the translated direction resultant from the independent QQ(zeta_11) packets.
"""
from __future__ import annotations

import gzip
import importlib.util
import json
import hashlib
from pathlib import Path

from sympy.polys.rings import ring

HERE = Path(__file__).resolve().parent
SCRATCH = HERE.parent
BUILD = SCRATCH / "t3_disc_build.py"
CONTACT = SCRATCH / "t3_disc_plane_contact_qzeta11.json.gz"
NODE = SCRATCH / "t3_disc_plane_node_payload.json.gz"
FORMS = HERE.parents[2] / "certificates/fixed_frame_arithmetic/five_forms.json"


def load_build():
    spec = importlib.util.spec_from_file_location("t3_disc_build_codim3", BUILD)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


disc = load_build()
K = disc.K
R, B, Z = ring("B,Z", K)


def decode(records, exponent_key="exponents_BZ"):
    answer = R.zero
    for record in records:
        b, z = record[exponent_key]
        answer += R(disc.deserialize_k11(record["coefficient_qzeta11"])) * B**b * Z**z
    return answer


def stats(poly):
    terms = poly.terms()
    return {
        "terms": len(terms),
        "total_degree": max((sum(monomial) for monomial, _ in terms), default=-1),
        "degrees": [max((m[i] for m, _ in terms), default=-1) for i in range(2)],
    }


def eval_binary(coefficients, value):
    degree = len(coefficients) - 1
    return sum(
        (coefficient * value ** (degree - index) for index, coefficient in enumerate(coefficients)),
        K.zero,
    )


def eval_binary_derivative(coefficients, value):
    degree = len(coefficients) - 1
    return sum(
        (
            coefficient * K(degree - index) * value ** (degree - index - 1)
            for index, coefficient in enumerate(coefficients)
            if degree - index
        ),
        K.zero,
    )


def main():
    with gzip.open(CONTACT, "rt") as stream:
        contact = json.load(stream)
    with gzip.open(NODE, "rt") as stream:
        node = json.load(stream)

    numerator = decode(contact["polynomials"]["N"])
    hessian = decode(node["hessian"]["determinant_polynomial_BZ"])
    direction = decode(node["singular_scheme"]["affine_direction_resultant"]["polynomial_BZ"])

    quotient, remainder = divmod(numerator, hessian**2)
    direction_quotient, direction_remainder = divmod(direction, hessian**2)
    direction_over_hessian, direction_hessian_remainder = divmod(direction, hessian)
    quotient_over_direction_residual = None
    quotient_direction_residual_remainder = None
    if not direction_hessian_remainder:
        quotient_over_direction_residual, quotient_direction_residual_remainder = divmod(
            quotient, direction_over_hessian
        )
    gcd_n_direction = numerator.gcd(direction)
    gcd_n_hessian = numerator.gcd(hessian)
    gcd_direction_hessian = direction.gcd(hessian)

    # Rational factor labels become especially transparent after
    # T=Z-275/2 on this plane.
    half_275 = R(K(275) / K(2))
    hessian_line = B + 8 * Z - 992
    target_jacobian_line_1 = B - 10 * Z + 1258
    cancellation_line = B - Z + 133
    target_jacobian_line_2 = 2 * B + Z - 133
    direction_cubic_rational = (
        B**3
        + 24 * B**2 * (Z - half_275)
        - 324 * B**2
        + 192 * B * (Z - half_275) ** 2
        + 2592 * B * (Z - half_275)
        - 7776 * B
        + 512 * (Z - half_275) ** 3
        + 18144 * (Z - half_275) ** 2
        + 194400 * (Z - half_275)
        + 554040
    )

    def proportional(left, right):
        ratio = left.LC / right.LC
        return left == right * ratio, ratio

    hessian_is_line, _hessian_scale = proportional(hessian, hessian_line)
    direction_is_cubic, _direction_scale = proportional(direction, direction_cubic_rational)
    assert hessian_is_line and direction_is_cubic
    known_product = (
        hessian**2
        * direction
        * target_jacobian_line_1**2
        * cancellation_line
        * target_jacobian_line_2**4
    )
    residual_degree_15, residual_remainder = divmod(numerator, known_product)
    assert not residual_remainder

    # Independent exact reconstruction of the absolute local model at the
    # generic Hessian line.  The cubic is f=Q2+C3 in translated fibre
    # coordinates, and n=(b,-2a) spans the null direction when det(Q2)=0.
    forms_payload = json.loads(FORMS.read_text())
    slots = {
        name: [disc.deserialize_k11(value) for value in values]
        for name, values in forms_payload["binary_slots"].items()
    }
    x0 = disc.deserialize_k11(node["singular_point"]["projective_coordinates"][0])
    t0 = disc.deserialize_k11(node["singular_point"]["projective_coordinates"][1])
    q_plane = [
        slots["q0"][i] + K(15) * slots["qA"][i] + K(12) * slots["qY"][i]
        for i in range(3)
    ]
    a_quad = K(3) * x0
    b_quad = eval_binary_derivative(q_plane, t0)
    q_second_half = q_plane[0]
    assert a_quad and b_quad
    r_leading = (
        R(slots["r0"][0])
        + K(15) * R(slots["rA"][0])
        + B * R(slots["rB"][0])
        + K(12) * R(slots["rY"][0])
        + (Z - half_275) * R(slots["rZ"][0])
    )
    cubic_on_null = (
        R(b_quad**3 + K(4) * a_quad**2 * b_quad * q_second_half)
        - R(K(8) * a_quad**3) * r_leading
    )
    assert cubic_on_null and stats(cubic_on_null)["total_degree"] == 1
    gcd_cubic_null_hessian = cubic_on_null.gcd(hessian)
    assert stats(gcd_cubic_null_hessian)["total_degree"] == 0

    qy_at = eval_binary(slots["qY"], t0)
    qy_prime_at = eval_binary_derivative(slots["qY"], t0)
    ry_at = eval_binary(slots["rY"], t0)
    ry_prime_at = eval_binary_derivative(slots["rY"], t0)
    fy_at_point = x0 * qy_at + ry_at
    transverse_ks = b_quad * qy_at - K(2) * a_quad * (x0 * qy_prime_at + ry_prime_at)
    assert fy_at_point == K.zero and transverse_ks != K.zero
    h_a = decode(contact["polynomials"]["H_A"])
    assert stats(h_a.gcd(hessian))["total_degree"] == 0
    payload = {
        "schema": "t3-plane-codimension-three-divisibility-v1",
        "plane": ["A-15", "Y-12"],
        "N_stats": stats(numerator),
        "hessian_stats": stats(hessian),
        "direction_resultant_stats": stats(direction),
        "N_divisible_by_hessian_squared": not remainder,
        "N_over_hessian_squared_stats": stats(quotient) if not remainder else None,
        "direction_divisible_by_hessian_squared": not direction_remainder,
        "direction_over_hessian_squared_stats": stats(direction_quotient) if not direction_remainder else None,
        "direction_divisible_by_hessian": not direction_hessian_remainder,
        "direction_over_hessian_stats": stats(direction_over_hessian) if not direction_hessian_remainder else None,
        "N_over_hessian_squared_divisible_by_direction_over_hessian": (
            quotient_direction_residual_remainder is not None and not quotient_direction_residual_remainder
        ),
        "N_over_hessian_direction_stats": (
            stats(quotient_over_direction_residual)
            if quotient_direction_residual_remainder is not None and not quotient_direction_residual_remainder
            else None
        ),
        "gcd_N_hessian_stats": stats(gcd_n_hessian),
        "gcd_N_direction_stats": stats(gcd_n_direction),
        "gcd_direction_hessian_stats": stats(gcd_direction_hessian),
        "hessian_proportional_to_rational_line": hessian_is_line,
        "direction_proportional_to_rational_cubic": direction_is_cubic,
        "rational_factor_labels_in_BZ": {
            "hessian_line": "B+8*Z-992",
            "target_jacobian_line_1": "B-10*Z+1258",
            "cancellation_line": "B-Z+133",
            "target_jacobian_line_2": "2*B+Z-133",
            "direction_cubic": str(direction_cubic_rational),
            "factorization": "N=unit*hessian_line^2*direction_cubic*target_jacobian_line_1^2*cancellation_line*target_jacobian_line_2^4*F15",
            "F15_stats": stats(residual_degree_15),
        },
        "hessian_line_local_model": {
            "quadratic_coefficients": "Q2=a*du^2+b*du*ds+c*ds^2 with a=3*x0 and b=q'(t0)",
            "null_direction": "n=(b,-2*a)",
            "a_nonzero": True,
            "b_nonzero": True,
            "C3_on_null_nonzero": True,
            "C3_on_null_stats": stats(cubic_on_null),
            "gcd_C3_on_null_hessian_stats": stats(gcd_cubic_null_hessian),
            "F_Y_at_marked_point_zero": True,
            "transverse_Kodaira_Spencer_nonzero": True,
            "transverse_Kodaira_Spencer_qzeta11": disc.serialize_k11(transverse_ks),
            "gcd_H_A_hessian_stats": stats(h_a.gcd(hessian)),
            "conclusion": "At the generic Hessian line the fibre has a cusp, but the transverse Y direction supplies a unit cross-term. The absolute completed total-incidence hypersurface has nondegenerate rank-three quadratic part and is formally A1 times a regular parameter; its local class group is killed by 2.",
        },
        "source_sha256": {
            str(FORMS.relative_to(HERE.parents[2])): hashlib.sha256(FORMS.read_bytes()).hexdigest(),
            str(CONTACT.relative_to(SCRATCH)): hashlib.sha256(CONTACT.read_bytes()).hexdigest(),
            str(NODE.relative_to(SCRATCH)): hashlib.sha256(NODE.read_bytes()).hexdigest(),
        },
        "N_over_hessian_squared": (
            [
                {
                    "exponents_BZ": list(monomial),
                    "coefficient_qzeta11": disc.serialize_k11(coefficient),
                }
                for monomial, coefficient in quotient.terms()
            ]
            if not remainder
            else None
        ),
    }
    (HERE / "plane_codim3_payload.json").write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps({key: value for key, value in payload.items() if key != "N_over_hessian_squared"}, indent=2, sort_keys=True))
    print("T3_PLANE_CODIM3_CHECK_DONE")


if __name__ == "__main__":
    main()
