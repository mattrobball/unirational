#!/usr/bin/env python3
"""Exact codimension-three local-type checks on A=15, Y=12.

This is independent of the producers of the contact and node payloads: it
reconstructs the fixed-frame cubic from five_forms.json, recomputes the
marked singular point, and compares the resulting polynomials with the
saved exact payloads.  It proves the generic local statements on the
Hessian line L and the direction-resultant cubic D.  It also isolates the
remaining curves at which the raw target hypersurface itself is singular.
"""

from __future__ import annotations

import gzip
import hashlib
import importlib.util
import json
from pathlib import Path

from sympy.polys.rings import ring


HERE = Path(__file__).resolve().parent
SCRATCH = HERE.parent
ROOT = HERE.parents[2]
BUILD = SCRATCH / "t3_disc_build.py"
CONTACT = SCRATCH / "t3_disc_plane_contact_qzeta11.json.gz"
NODE = SCRATCH / "t3_disc_plane_node_payload.json.gz"
FORMS = ROOT / "certificates/fixed_frame_arithmetic/five_forms.json"
OUTPUT = HERE / "plane_local_types_payload.json"

A0 = 15
Y0 = 12


def load_build():
    spec = importlib.util.spec_from_file_location("t3_disc_build_local_types", BUILD)
    assert spec is not None and spec.loader is not None
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


disc = load_build()
K = disc.K
BR, B, Z = ring("B,Z", K)


def file_hash(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def canonical_hash(value) -> str:
    return hashlib.sha256(
        json.dumps(value, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest()


def serialize_k(value):
    return disc.serialize_k11(value)


def serialize_bz(poly):
    return [
        {
            "exponents_BZ": list(monomial),
            "coefficient_qzeta11": serialize_k(coefficient),
        }
        for monomial, coefficient in poly.terms()
    ]


def stats(poly):
    terms = poly.terms()
    return {
        "terms": len(terms),
        "total_degree": max((sum(monomial) for monomial, _ in terms), default=-1),
        "degrees_BZ": [
            max((monomial[index] for monomial, _ in terms), default=-1)
            for index in range(2)
        ],
    }


def decode(records):
    answer = BR.zero
    for record in records:
        b, z = record["exponents_BZ"]
        answer += (
            BR(disc.deserialize_k11(record["coefficient_qzeta11"]))
            * B**b
            * Z**z
        )
    return answer


def slots_from_payload(payload):
    return {
        name: [disc.deserialize_k11(value) for value in values]
        for name, values in payload["binary_slots"].items()
    }


def affine_unary(coefficients, unary_ring, variable):
    degree = len(coefficients) - 1
    return sum(
        (
            unary_ring(coefficient) * variable ** (degree - index)
            for index, coefficient in enumerate(coefficients)
        ),
        unary_ring.zero,
    )


def eval_unary(poly, value):
    answer = poly.ring.domain.zero
    for (exponent,), coefficient in poly.terms():
        answer += coefficient * value**exponent
    return answer


def coefficient_at(poly, exponent):
    return poly.get((exponent,), poly.ring.domain.zero)


def proportional(left, right):
    assert left and right
    ratio = left.LC / right.LC
    return left == right * ratio, ratio


def exact_quotient(numerator, denominator):
    quotient, remainder = divmod(numerator, denominator)
    assert not remainder
    return quotient


def evaluate_bz(poly, b_value, z_value):
    answer = K.zero
    for (b, z), coefficient in poly.terms():
        answer += coefficient * K(b_value) ** b * K(z_value) ** z
    return answer


def main():
    with gzip.open(CONTACT, "rt") as stream:
        contact = json.load(stream)
    with gzip.open(NODE, "rt") as stream:
        node = json.load(stream)
    forms = json.loads(FORMS.read_text())
    slots = slots_from_payload(forms)

    h_a = decode(contact["polynomials"]["H_A"])
    h_yy = decode(contact["polynomials"]["H_YY"])
    delta_a = decode(contact["polynomials"]["Delta_A"])
    delta_yy = decode(contact["polynomials"]["Delta_YY"])
    numerator = decode(contact["polynomials"]["N"])

    # Rational labels in the original Z-coordinate.
    hessian_line = B + 8 * Z - 992
    direction_cubic = (
        B**3
        + 24 * B**2 * Z
        - 3624 * B**2
        + 192 * B * Z**2
        - 50208 * B * Z
        + 3265824 * B
        + 512 * Z**3
        - 193056 * Z**2
        + 24244800 * Z
        - 1014140960
    )
    target_jacobian_line_1 = B - 10 * Z + 1258
    cancellation_line = B - Z + 133
    target_jacobian_line_2 = 2 * B + Z - 133

    # Reconstruct the fixed marked singular point on the plane.
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
    unary = lambda coefficients: affine_unary(coefficients, UR, u)
    rb_u = unary(slots["rB"])
    rz_u = unary(slots["rZ"])
    common = rb_u.gcd(rz_u)
    common = common / common.LC
    assert common.degree() == 2
    t0 = -coefficient_at(common, 1) / K(2)
    assert common == (u - UR(t0)) ** 2
    q_u = unary(q)
    rbase_u = unary(r_base)
    q_prime = eval_unary(q_u.diff(u), t0)
    q_second = eval_unary(q_u.diff(u).diff(u), t0)
    assert q_prime != K.zero
    x0 = -eval_unary(rbase_u.diff(u), t0) / q_prime

    # Recompute Q2 and C3 and compare L,D to the independent node payload.
    r_bz = [
        BR(r_base[index])
        + B * BR(slots["rB"][index])
        + Z * BR(slots["rZ"][index])
        for index in range(4)
    ]
    r_second = BR.zero
    for index, exponent in enumerate((3, 2, 1, 0)):
        if exponent >= 2:
            r_second += (
                r_bz[index]
                * K(exponent * (exponent - 1))
                * BR(t0) ** (exponent - 2)
            )
    a = K(3) * x0
    b = q_prime
    d = q_second / K(2)
    c = BR(x0 * q_second) / K(2) + r_second / K(2)
    e = r_bz[0]
    recomputed_hessian = K(4) * BR(a) * c - BR(b**2)
    saved_hessian = decode(node["hessian"]["determinant_polynomial_BZ"])
    same_hessian, hessian_scale = proportional(recomputed_hessian, saved_hessian)
    rational_hessian, rational_hessian_scale = proportional(
        recomputed_hessian, hessian_line
    )
    assert same_hessian and rational_hessian

    ER, direction, eb, ez = ring("direction,B,Z", K)
    lift = lambda poly: sum(
        (
            ER(coefficient) * eb**monomial[0] * ez**monomial[1]
            for monomial, coefficient in poly.terms()
        ),
        ER.zero,
    )
    q2_direction = ER(a) * direction**2 + ER(b) * direction + lift(c)
    c3_direction = direction**3 + ER(d) * direction + lift(e)
    recomputed_direction_er = q2_direction.resultant(c3_direction)
    recomputed_direction = BR.zero
    for monomial, coefficient in recomputed_direction_er.terms():
        if len(monomial) == 3:
            direction_exp, b_exp, z_exp = monomial
            assert direction_exp == 0
        else:
            b_exp, z_exp = monomial
        recomputed_direction += BR(coefficient) * B**b_exp * Z**z_exp
    saved_direction = decode(
        node["singular_scheme"]["affine_direction_resultant"]["polynomial_BZ"]
    )
    same_direction, direction_scale = proportional(
        recomputed_direction, saved_direction
    )
    rational_direction, rational_direction_scale = proportional(
        recomputed_direction, direction_cubic
    )
    assert same_direction and rational_direction
    direction_factorization = direction_cubic.factor_list()
    assert len(direction_factorization[1]) == 1
    assert direction_factorization[1][0][0] == direction_cubic
    assert direction_factorization[1][0][1] == 1

    # Full exact derivative factorization on the plane.  The common residual
    # factor has degree 15; no factorization claim for it is needed here.
    f15_ha = exact_quotient(
        h_a, target_jacobian_line_1**3 * target_jacobian_line_2**4
    )
    f15_hyy = exact_quotient(
        h_yy, target_jacobian_line_1**2 * target_jacobian_line_2**4
    )
    delta_a_residual = exact_quotient(delta_a, hessian_line**3 * direction_cubic)
    delta_yy_residual = exact_quotient(delta_yy, hessian_line**2 * direction_cubic)
    f15_n = exact_quotient(
        numerator,
        hessian_line**2
        * direction_cubic
        * target_jacobian_line_1**2
        * cancellation_line
        * target_jacobian_line_2**4,
    )
    same_f15_hyy, scale_f15_hyy = proportional(f15_ha, f15_hyy)
    same_f15_n, scale_f15_n = proportional(f15_ha, f15_n)
    assert same_f15_hyy and same_f15_n
    assert stats(f15_ha) == {"terms": 134, "total_degree": 15, "degrees_BZ": [15, 14]}
    assert stats(delta_a_residual) == {"terms": 1, "total_degree": 0, "degrees_BZ": [0, 0]}
    assert stats(delta_yy_residual) == {"terms": 1, "total_degree": 0, "degrees_BZ": [0, 0]}

    # L: fibre cusp, but the absolute incidence remains transverse A1.
    null_du = b
    null_ds = -K(2) * a
    cubic_on_null = (
        b**3 + K(4) * a**2 * b * d - K(8) * BR(a**3) * e
    )
    assert cubic_on_null.gcd(hessian_line).degree() == 0
    qy_u = unary(slots["qY"])
    ry_u = unary(slots["rY"])
    f_y_at_point = x0 * eval_unary(qy_u, t0) + eval_unary(ry_u, t0)
    assert f_y_at_point == K.zero
    f_xy_at_point = eval_unary(qy_u, t0)
    f_ty_at_point = (
        x0 * eval_unary(qy_u.diff(u), t0)
        + eval_unary(ry_u.diff(u), t0)
    )
    normal_coupling = null_du * f_xy_at_point + null_ds * f_ty_at_point
    assert normal_coupling != K.zero

    # D: an exact rational smooth point proves the generic second point is a
    # distinct ordinary node and that moving in B smooths it.
    witness_b = 640
    witness_z = 125
    assert evaluate_bz(direction_cubic, witness_b, witness_z) == K.zero
    assert 3 * witness_b**2 + 48 * witness_b * witness_z - 7248 * witness_b + 192 * witness_z**2 - 50208 * witness_z + 3265824 == 419904
    assert evaluate_bz(hessian_line, witness_b, witness_z) != K.zero
    for gate_curve in (
        target_jacobian_line_1,
        cancellation_line,
        target_jacobian_line_2,
        f15_ha,
    ):
        assert evaluate_bz(gate_curve, witness_b, witness_z) != K.zero
    witness_r = [
        r_base[index]
        + K(witness_b) * slots["rB"][index]
        + K(witness_z) * slots["rZ"][index]
        for index in range(4)
    ]
    witness_r_u = unary(witness_r)
    witness_c = (
        x0 * q_second
        + eval_unary(witness_r_u.diff(u).diff(u), t0)
    ) / K(2)
    witness_e = witness_r[0]
    witness_q2 = UR(a) * u**2 + UR(b) * u + UR(witness_c)
    witness_c3 = u**3 + UR(d) * u + UR(witness_e)
    witness_gcd = witness_q2.gcd(witness_c3)
    witness_gcd = witness_gcd / witness_gcd.LC
    assert witness_gcd.degree() == 1
    second_direction = -coefficient_at(witness_gcd, 0)
    second_scale = -(
        K(2) * a * second_direction + b
    ) / (K(3) * second_direction**2 + d)
    assert second_scale != K.zero
    second_du = second_scale * second_direction
    second_ds = second_scale
    second_f = (
        a * second_du**2
        + b * second_du * second_ds
        + witness_c * second_ds**2
        + second_du**3
        + d * second_du * second_ds**2
        + witness_e * second_ds**3
    )
    second_fu = (
        K(2) * a * second_du
        + b * second_ds
        + K(3) * second_du**2
        + d * second_ds**2
    )
    second_fs = (
        b * second_du
        + K(2) * witness_c * second_ds
        + K(2) * d * second_du * second_ds
        + K(3) * witness_e * second_ds**2
    )
    assert second_f == second_fu == second_fs == K.zero
    second_hessian = (
        (K(2) * a + K(6) * second_du)
        * (
            K(2) * witness_c
            + K(2) * d * second_du
            + K(6) * witness_e * second_ds
        )
        - (b + K(2) * d * second_ds) ** 2
    )
    assert second_hessian != K.zero
    second_t = t0 + second_ds
    second_f_b = eval_unary(rb_u, second_t)
    assert second_f_b != K.zero

    # The marked p0 branch itself remains A1 at generic D.  The determinant
    # below is the quadratic form normal to the marked-node plane in the
    # target incidence.  One exact point on irreducible D proves generic
    # nonvanishing.
    q_a_u = unary(slots["qA"])
    r_a_u = unary(slots["rA"])
    f_a_at_point = (
        x0 * eval_unary(q_a_u, t0)
        + eval_unary(r_a_u, t0)
        - K(55) / K(3) * eval_unary(rz_u, t0)
    )
    h_a_witness = evaluate_bz(h_a, witness_b, witness_z)
    h_yy_witness = evaluate_bz(h_yy, witness_b, witness_z)
    assert h_a_witness != K.zero
    a_second = -h_yy_witness / h_a_witness
    witness_h_tt = x0 * q_second + eval_unary(
        witness_r_u.diff(u).diff(u), t0
    )
    h_xx = K(6) * x0
    h_xt = b
    h_tt = witness_h_tt
    normal_hessian_determinant = (
        h_xx
        * (h_tt * a_second * f_a_at_point - f_ty_at_point**2)
        - h_xt
        * (h_xt * a_second * f_a_at_point - f_ty_at_point * f_xy_at_point)
        + f_xy_at_point
        * (h_xt * f_ty_at_point - h_tt * f_xy_at_point)
    )
    assert normal_hessian_determinant != K.zero

    # C: the split local equation is xy=tau^2*s.  Its class group has the
    # presentation Z^2/<(2,1)> = Z.  Here the node orientation is nonsplit:
    # L|_C = 9*(Z-125), a nonsquare in K(Z).  Branch exchange acts by -1,
    # so restriction has zero invariant image and corestriction kills every
    # descended class by 2.
    _, hessian_on_cancellation = divmod(hessian_line, cancellation_line)
    expected_hessian_on_cancellation = K(9) * (Z - 125)
    assert hessian_on_cancellation == expected_hessian_on_cancellation
    assert hessian_on_cancellation.degree(Z) == 1
    split_class_relation = [2, 1]
    assert __import__("math").gcd(*split_class_relation) == 1

    payload = {
        "schema": "t3-boundary-plane-local-types-v1",
        "field": "QQ(zeta11)",
        "plane": ["A-15", "Y-12"],
        "independent_reconstruction": {
            "marked_point_recomputed": True,
            "hessian_matches_saved_payload": same_hessian,
            "hessian_match_scale": serialize_k(hessian_scale),
            "hessian_is_B_plus_8Z_minus_992": rational_hessian,
            "hessian_rational_scale": serialize_k(rational_hessian_scale),
            "direction_matches_saved_payload": same_direction,
            "direction_match_scale": serialize_k(direction_scale),
            "direction_is_rational_cubic": rational_direction,
            "direction_rational_scale": serialize_k(rational_direction_scale),
            "direction_cubic_irreducible_over_Q_zeta11": True,
        },
        "plane_derivative_factorization": {
            "H_A": "unit*J1^3*J2^4*F15",
            "H_YY": "unit*J1^2*J2^4*F15",
            "Delta_A": "unit*L^3*D",
            "Delta_YY": "unit*L^2*D",
            "N": "unit*L^2*D*J1^2*C*J2^4*F15",
            "L": "B+8*Z-992",
            "D": str(direction_cubic),
            "J1": "B-10*Z+1258",
            "C": "B-Z+133",
            "J2": "2*B+Z-133",
            "F15_stats": stats(f15_ha),
            "F15_sha256": canonical_hash(serialize_bz(f15_ha / f15_ha.LC)),
            "common_F15_checked": True,
            "factor_scales": {
                "HYY_residual_over_HA_residual": serialize_k(scale_f15_hyy),
                "N_residual_over_HA_residual": serialize_k(scale_f15_n),
                "Delta_A_over_L3D": serialize_k(delta_a_residual.LC),
                "Delta_YY_over_L2D": serialize_k(delta_yy_residual.LC),
            },
        },
        "L_generic": {
            "fiber_type": "ordinary cusp A2 at the marked point",
            "C3_on_null_nonzero_mod_L": True,
            "C3_on_null_gcd_L_stats": stats(cubic_on_null.gcd(hessian_line)),
            "F_Y_at_marked_point_zero": True,
            "normal_null_coupling_nonzero": True,
            "normal_null_coupling": serialize_k(normal_coupling),
            "completed_total_incidence_after_separable_extension": "k(L)[[s,u,v,w]]/(u*v+w^2)",
            "punctured_Pic_exponent_divides": 2,
            "mod3_verdict": "harmless",
        },
        "D_generic": {
            "irreducible": True,
            "rational_witness_BZ": [witness_b, witness_z],
            "direction_gradient_B_at_witness": 419904,
            "second_point_gcd_degree": 1,
            "second_point_distinct": True,
            "second_point_is_ordinary_node": True,
            "second_point_hessian": serialize_k(second_hessian),
            "B_direction_smooths_second_node": True,
            "F_B_at_second_point": serialize_k(second_f_b),
            "marked_point_absolute_normal_hessian_nonzero": True,
            "marked_point_absolute_normal_hessian": serialize_k(
                normal_hessian_determinant
            ),
            "completed_marked_point_model": "A1 times a regular parameter",
            "marked_point_punctured_Pic_exponent_divides": 2,
            "completed_second_point_model": "regular",
            "mod3_verdict": "harmless at both singular points",
        },
        "C_generic": {
            "split_completed_model": "k'[[x,y,tau,s]]/(x*y-tau^2*s)",
            "split_class_group_presentation": "Z^2/<(2,1)> = Z",
            "split_branch_swap_action": "generator maps to its negative",
            "orientation_discriminant_mod_C": "9*(Z-125)",
            "orientation_nonsquare_reason": "odd valuation at Z=125 in QQ(zeta11)(Z)",
            "descent_punctured_Pic_exponent_divides": 2,
            "mod3_verdict": "harmless by restriction-corestriction",
        },
        "raw_target_singular_curves": {
            "support_on_plane": ["J1", "J2", "F15"],
            "reason": "H,H_Y,H_B,H_Z vanish on the plane and H_A=unit*J1^3*J2^4*F15",
            "normalization_required": True,
            "local_types_on_normalization": "not decided by this checker",
            "mod3_verdict": "OPEN",
        },
        "scope": {
            "proved": "generic local types on L, D, and C inside the exact boundary plane",
            "not_proved": [
                "normalization/local class groups above J1, J2, and F15",
                "codimension-three loci away from A=15,Y=12",
                "global vertical-lattice image or normalized Picard degree image",
            ],
        },
        "source_sha256": {
            str(FORMS.relative_to(ROOT)): file_hash(FORMS),
            str(CONTACT.relative_to(SCRATCH)): file_hash(CONTACT),
            str(NODE.relative_to(SCRATCH)): file_hash(NODE),
            str(BUILD.relative_to(SCRATCH)): file_hash(BUILD),
        },
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, indent=2, sort_keys=True))
    print("T3_BOUNDARY_PLANE_LOCAL_TYPES_DONE")


if __name__ == "__main__":
    main()
