#!/usr/bin/env python3
"""Exact generic singularity audit on the plane A=15, Y=12.

The generic coefficient field is Q(zeta_11)(B,Z).  The script derives the
fixed singular point from the common repeated root of r_B and r_Z, solves
the full singular scheme using the exact quadratic/cubic homogeneous
decomposition about that point, excludes a singularity at infinity, and
evaluates the affine Hessian.

Only t3_disc_plane_node_* discovery artifacts are written beside this file.
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
FORMS_SEAL = ROOT / "certificates/fixed_frame_arithmetic/SEAL.json"
BUILD_PATH = HERE / "t3_disc_build.py"
CONTACT_PATH = HERE / "t3_disc_plane_contact_qzeta11.json.gz"
OUTPUT_GZ = HERE / "t3_disc_plane_node_payload.json.gz"
SUMMARY_PATH = HERE / "t3_disc_plane_node_summary.json"
A0 = 15
Y0 = 12


def load_build_module():
    spec = importlib.util.spec_from_file_location("t3_disc_build_for_node", BUILD_PATH)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


disc = load_build_module()
K = disc.K


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_hash(value) -> str:
    return hashlib.sha256(
        json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest()


def slots_from_payload(payload):
    return {
        name: [disc.deserialize_k11(value) for value in values]
        for name, values in payload["binary_slots"].items()
    }


def affine_unary(coefficients, unary_ring, variable):
    """Binary coefficients v^d,...,w^d in the chart w=1, t=v/w."""
    degree = len(coefficients) - 1
    return sum(
        (unary_ring(coefficient) * variable ** (degree - index)
         for index, coefficient in enumerate(coefficients)),
        unary_ring.zero,
    )


def eval_unary(poly, value):
    answer = poly.ring.domain.zero
    for (exponent,), coefficient in poly.terms():
        answer += coefficient * value**exponent
    return answer


def coefficient_at(poly, exponent):
    return poly.get((exponent,), poly.ring.domain.zero)


def serialize_bz_poly(poly):
    return [
        {
            "exponents_BZ": list(monomial),
            "coefficient_qzeta11": disc.serialize_k11(coefficient),
        }
        for monomial, coefficient in poly.terms()
    ]


def bz_stats(poly):
    terms = poly.terms()
    return {
        "terms": len(terms),
        "total_degree_BZ": max((sum(monomial) for monomial, _ in terms), default=-1),
        "degrees_BZ": [
            max((monomial[index] for monomial, _ in terms), default=-1)
            for index in range(2)
        ],
    }


def evaluate_mod67(poly, b_value, z_value):
    answer = 0
    for (b_exponent, z_exponent), coefficient in poly.terms():
        reduced = disc.reduce_coefficient(coefficient, 67, 9)
        answer += (
            reduced
            * pow(b_value, b_exponent, 67)
            * pow(z_value, z_exponent, 67)
        )
    return answer % 67


def lift_bz(poly, target_ring, target_b, target_z):
    answer = target_ring.zero
    for (b_exponent, z_exponent), coefficient in poly.terms():
        answer += (
            target_ring(coefficient)
            * target_b**b_exponent
            * target_z**z_exponent
        )
    return answer


def drop_first_variable(poly, target_ring, target_b, target_z):
    answer = target_ring.zero
    for monomial, coefficient in poly.terms():
        if len(monomial) == 3:
            first_exponent, b_exponent, z_exponent = monomial
            assert first_exponent == 0
        else:
            assert len(monomial) == 2
            b_exponent, z_exponent = monomial
        answer += (
            target_ring(coefficient)
            * target_b**b_exponent
            * target_z**z_exponent
        )
    return answer


def main():
    forms_payload = json.loads(FORMS_PATH.read_text())
    slots = slots_from_payload(forms_payload)

    # The plane specialization, with Z-11*A^2/18 = Z-275/2.
    q = [
        slots["q0"][index]
        + K(A0) * slots["qA"][index]
        + K(Y0) * slots["qY"][index]
        for index in range(3)
    ]
    r_base = [
        slots["r0"][index]
        + K(A0) * slots["rA"][index]
        + K(Y0) * slots["rY"][index]
        - K(275) / K(2) * slots["rZ"][index]
        for index in range(4)
    ]

    UR, u = ring("u", K)
    rb_u = affine_unary(slots["rB"], UR, u)
    rz_u = affine_unary(slots["rZ"], UR, u)
    common = rb_u.gcd(rz_u)
    common = common / common.LC
    assert common.degree() == 2
    common_discriminant = coefficient_at(common, 1) ** 2 - K(4) * coefficient_at(common, 0)
    assert common_discriminant == K.zero
    t0 = -coefficient_at(common, 1) / K(2)
    assert common == (u - UR(t0)) ** 2
    assert eval_unary(rb_u, t0) == K.zero
    assert eval_unary(rb_u.diff(u), t0) == K.zero
    assert eval_unary(rz_u, t0) == K.zero
    assert eval_unary(rz_u.diff(u), t0) == K.zero

    q_u = affine_unary(q, UR, u)
    rbase_u = affine_unary(r_base, UR, u)
    q_at = eval_unary(q_u, t0)
    q_prime_at = eval_unary(q_u.diff(u), t0)
    q_second_at = eval_unary(q_u.diff(u).diff(u), t0)
    rbase_at = eval_unary(rbase_u, t0)
    rbase_prime_at = eval_unary(rbase_u.diff(u), t0)
    assert q_prime_at != K.zero
    x0 = -rbase_prime_at / q_prime_at
    assert x0 * q_prime_at + rbase_prime_at == K.zero
    assert K(3) * x0**2 + q_at == K.zero
    assert x0**3 + x0 * q_at + rbase_at == K.zero

    # The affine Hessian determinant at (x0,t0), as a polynomial in B,Z.
    BR, b, z = ring("B,Z", K)
    r_bz = [
        BR(r_base[index])
        + b * BR(slots["rB"][index])
        + z * BR(slots["rZ"][index])
        for index in range(4)
    ]
    r_second_at = BR.zero
    for index, exponent in enumerate((3, 2, 1, 0)):
        if exponent < 2:
            continue
        r_second_at += (
            r_bz[index]
            * K(exponent * (exponent - 1))
            * BR(t0) ** (exponent - 2)
        )
    h_xx = BR(K(6) * x0)
    h_xt = BR(q_prime_at)
    h_tt = BR(x0 * q_second_at) + r_second_at
    hessian_determinant = h_xx * h_tt - h_xt**2
    assert hessian_determinant

    # Translate x=x0+du, t=t0+ds.  Exact expansion gives f=Q2+C3,
    # with Q2 and C3 homogeneous of degrees 2 and 3 in (du,ds).
    TR, du, ds, tb, tz = ring("du,ds,B,Z", K)
    tr_bz = [
        TR(r_base[index])
        + tb * TR(slots["rB"][index])
        + tz * TR(slots["rZ"][index])
        for index in range(4)
    ]
    translated_t = TR(t0) + ds
    translated_x = TR(x0) + du
    translated_q = (
        TR(q[0]) * translated_t**2
        + TR(q[1]) * translated_t
        + TR(q[2])
    )
    translated_r = sum(
        (
            tr_bz[index] * translated_t**exponent
            for index, exponent in enumerate((3, 2, 1, 0))
        ),
        TR.zero,
    )
    translated_f = translated_x**3 + translated_x * translated_q + translated_r
    tangent_quadratic = (
        TR(K(3) * x0) * du**2
        + TR(q_prime_at) * du * ds
        + lift_bz(h_tt / K(2), TR, tb, tz) * ds**2
    )
    cubic_tail = (
        du**3
        + TR(q_second_at / K(2)) * du * ds**2
        + tr_bz[0] * ds**3
    )
    assert translated_f == tangent_quadratic + cubic_tail

    # Every affine singular point satisfies Q2=C3=0: Euler applied to the
    # two homogeneous pieces gives 0=u*f_u+s*f_s=2*Q2+3*C3, while f=Q2+C3.
    # The homogeneous resultant is computed by setting ds=1; [1:0] is not
    # common because the coefficient of du^3 in C3 is one.
    ER, direction, eb, ez = ring("direction,B,Z", K)
    c_bz = lift_bz(h_tt / K(2), ER, eb, ez)
    e_bz = lift_bz(r_bz[0], ER, eb, ez)
    q2_direction = (
        ER(K(3) * x0) * direction**2
        + ER(q_prime_at) * direction
        + c_bz
    )
    c3_direction = (
        direction**3
        + ER(q_second_at / K(2)) * direction
        + e_bz
    )
    direction_resultant_er = q2_direction.resultant(c3_direction)
    direction_resultant = drop_first_variable(direction_resultant_er, BR, b, z)
    assert direction_resultant

    # At infinity (v=1,w=0), F_w=q1*X+r1.  Since q1 != 0, its sole root is
    # X=-r1/q1.  The following nonzero numerator is F_X at that root times q1^2.
    assert q[1] != K.zero
    infinity_obstruction = K(3) * r_bz[1] ** 2 + BR(q[0] * q[1] ** 2)
    assert infinity_obstruction

    witness = None
    preferred_points = [(37, 56), (0, 0), (1, 0), (0, 1), (1, 1)]
    preferred_points += [(bv, zv) for bv in range(7) for zv in range(7)]
    for b_value, z_value in preferred_points:
        values = {
            "hessian_determinant": evaluate_mod67(
                hessian_determinant, b_value, z_value
            ),
            "affine_direction_resultant": evaluate_mod67(
                direction_resultant, b_value, z_value
            ),
            "infinity_obstruction": evaluate_mod67(
                infinity_obstruction, b_value, z_value
            ),
        }
        if all(values.values()):
            witness = {
                "prime": 67,
                "zeta11": 9,
                "point_BZ": [b_value, z_value],
                "values": values,
            }
            break
    assert witness is not None

    # Independent finite-field replay at the nonvanishing witness.
    b_value, z_value = witness["point_BZ"]
    q_mod = [disc.reduce_coefficient(value, 67, 9) for value in q]
    r_mod = [
        (
            disc.reduce_coefficient(r_base[index], 67, 9)
            + b_value * disc.reduce_coefficient(slots["rB"][index], 67, 9)
            + z_value * disc.reduce_coefficient(slots["rZ"][index], 67, 9)
        )
        % 67
        for index in range(4)
    ]
    point_mod67 = [
        disc.reduce_coefficient(x0, 67, 9),
        disc.reduce_coefficient(t0, 67, 9),
    ]
    affine_singular_points = []
    for x_value in range(67):
        for t_value in range(67):
            q_value = (
                q_mod[0] * t_value**2 + q_mod[1] * t_value + q_mod[2]
            ) % 67
            r_value = (
                r_mod[0] * t_value**3
                + r_mod[1] * t_value**2
                + r_mod[2] * t_value
                + r_mod[3]
            ) % 67
            f_value = (x_value**3 + x_value * q_value + r_value) % 67
            fx_value = (3 * x_value**2 + q_value) % 67
            ft_value = (
                x_value * (2 * q_mod[0] * t_value + q_mod[1])
                + 3 * r_mod[0] * t_value**2
                + 2 * r_mod[1] * t_value
                + r_mod[2]
            ) % 67
            if f_value == fx_value == ft_value == 0:
                affine_singular_points.append([x_value, t_value])
    assert affine_singular_points == [point_mod67]

    infinity_singular_points = []
    for x_value in range(67):
        infinity_values = [
            x_value**3 + q_mod[0] * x_value + r_mod[0],
            3 * x_value**2 + q_mod[0],
            2 * q_mod[0] * x_value + 3 * r_mod[0],
            q_mod[1] * x_value + r_mod[1],
        ]
        if all(value % 67 == 0 for value in infinity_values):
            infinity_singular_points.append(x_value)
    assert not infinity_singular_points
    witness.update(
        {
            "reduced_singular_point_Xt": point_mod67,
            "affine_F67_singular_points": affine_singular_points,
            "infinity_F67_singular_points": infinity_singular_points,
        }
    )

    hessian_serialized = serialize_bz_poly(hessian_determinant)
    direction_resultant_serialized = serialize_bz_poly(direction_resultant)
    infinity_obstruction_serialized = serialize_bz_poly(infinity_obstruction)
    payload = {
        "schema": "klein-cubic-t3-plane-generic-node-exact-v1",
        "field": "QQ(zeta11)(B,Z)",
        "plane": ["A-15", "Y-12"],
        "fixed_frame_formula": (
            "F=X^3+X*(q0*v^2+q1*v*w+q2*w^2)"
            "+r0*v^3+r1*v^2*w+r2*v*w^2+r3*w^3"
        ),
        "singular_point": {
            "projective_coordinates": [
                disc.serialize_k11(x0),
                disc.serialize_k11(t0),
                disc.serialize_k11(K.one),
            ],
            "independent_of_BZ": True,
            "derivation": {
                "monic_gcd_rB_rZ": [
                    disc.serialize_k11(coefficient_at(common, exponent))
                    for exponent in range(3)
                ],
                "gcd_degree": 2,
                "gcd_discriminant_zero": True,
                "gcd_equals_t_minus_t0_squared": True,
                "rB_t0_and_derivative_zero": True,
                "rZ_t0_and_derivative_zero": True,
                "qprime_t0_nonzero": True,
                "x0_formula": "-r_base'(t0)/q'(t0)",
                "F_FX_Ft_zero": True,
            },
        },
        "singular_scheme": {
            "affine_chart": "w=1, t=v/w",
            "jacobian_ideal": ["f", "partial_X(f)", "partial_t(f)"],
            "translated_coordinates": ["du=X-x0", "ds=t-t0"],
            "translated_decomposition": {
                "identity": "f=Q2+C3",
                "Q2": "3*x0*du^2+q'(t0)*du*ds+(F_tt/2)*ds^2",
                "C3": "du^3+(q''/2)*du*ds^2+r0(B,Z)*ds^3",
                "identity_checked_exactly": True,
                "singular_point_implication": (
                    "f=f_du=f_ds=0 implies Q2=C3=0 by homogeneous Euler"
                ),
            },
            "affine_direction_resultant": {
                "description": "Res_direction(Q2(direction,1),C3(direction,1))",
                "polynomial_BZ": direction_resultant_serialized,
                "stats": bz_stats(direction_resultant),
                "sha256": canonical_hash(direction_resultant_serialized),
                "nonzero": True,
                "direction_at_ds_zero_excluded_by_C3_du3_coefficient_one": True,
                "conclusion": "No affine singular point other than (x0,t0).",
            },
            "deduced_reduced_groebner_basis": ["X-x0", "t-t0"],
            "quotient_vector_space_dimension": 1,
            "infinity_chart": "v=1, w=0",
            "infinity_restricted_equations": {
                "F_X": "3*X^2+q0",
                "F_w": "q1*X+r1(B,Z)",
                "q1_nonzero": True,
                "obstruction_numerator": "3*r1(B,Z)^2+q0*q1^2",
                "obstruction_polynomial_BZ": infinity_obstruction_serialized,
                "obstruction_stats": bz_stats(infinity_obstruction),
                "obstruction_sha256": canonical_hash(infinity_obstruction_serialized),
                "obstruction_nonzero": True,
            },
            "no_singular_point_at_infinity": True,
            "unique_projective_singular_point_generically": True,
            "length_one_reason": (
                "The direction resultant gives unique support, and the invertible "
                "Hessian makes the local Jacobian ideal the maximal ideal."
            ),
        },
        "hessian": {
            "variables": ["X", "t"],
            "entries": {
                "F_XX_at_point": disc.serialize_k11(K(6) * x0),
                "F_Xt_at_point": disc.serialize_k11(q_prime_at),
                "F_tt_at_point_polynomial_BZ": serialize_bz_poly(h_tt),
            },
            "determinant_polynomial_BZ": hessian_serialized,
            "determinant_stats": bz_stats(hessian_determinant),
            "determinant_sha256": canonical_hash(hessian_serialized),
            "determinant_nonzero": True,
            "mod67_witness": witness,
            "conclusion": (
                "The quadratic tangent cone is nondegenerate over the algebraic "
                "closure, hence the unique generic singularity is an ordinary node."
            ),
        },
        "verdict": {
            "generic_singular_scheme_length": 1,
            "generic_singularity": "one ordinary node",
            "cusp_or_multiple_node": False,
            "scope": (
                "Generic fiber over QQ(zeta11)(B,Z) on the exact plane only; "
                "special proper closed loci in the (B,Z)-plane are not classified."
            ),
        },
        "source_sha256": {
            str(FORMS_PATH.relative_to(ROOT)): file_hash(FORMS_PATH),
            str(FORMS_SEAL.relative_to(ROOT)): file_hash(FORMS_SEAL),
            str(BUILD_PATH.relative_to(HERE)): file_hash(BUILD_PATH),
            str(CONTACT_PATH.relative_to(HERE)): file_hash(CONTACT_PATH),
        },
    }

    encoded = json.dumps(payload, sort_keys=True, separators=(",", ":")).encode()
    OUTPUT_GZ.write_bytes(gzip.compress(encoded, compresslevel=9, mtime=0))
    summary = {
        "schema": payload["schema"],
        "field": payload["field"],
        "plane": payload["plane"],
        "singular_point": payload["singular_point"],
        "singular_scheme": payload["singular_scheme"],
        "hessian": payload["hessian"],
        "verdict": payload["verdict"],
        "source_sha256": payload["source_sha256"],
        "payload": OUTPUT_GZ.name,
        "payload_sha256": file_hash(OUTPUT_GZ),
        "payload_uncompressed_bytes": len(encoded),
        "payload_gzip_bytes": OUTPUT_GZ.stat().st_size,
    }
    SUMMARY_PATH.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print(json.dumps(summary, indent=2, sort_keys=True))
    print("T3_DISC_PLANE_GENERIC_ONE_ORDINARY_NODE")


if __name__ == "__main__":
    main()
