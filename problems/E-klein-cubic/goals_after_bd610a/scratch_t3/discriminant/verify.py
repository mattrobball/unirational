#!/usr/bin/env python3
"""Independent exact verifier for the fixed-frame discriminant packet.

The verifier reconstructs the invariant from the authoritative five forms and
the saved universal invariant strings, checks both rational descents, and then
rechecks the two exact contact calculations used by this packet.  The modular
projective slice and the candidate-conductor calculation are deliberately
checked only at their advertised (non-exhaustive) scope.
"""
from __future__ import annotations

import hashlib
import json
import re
from collections import defaultdict
from fractions import Fraction
from math import comb, gcd, lcm
from pathlib import Path

import sympy as sp

HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
FORMS = PROBLEM / "certificates/fixed_frame_arithmetic/five_forms.json"
UNIVERSAL = PROBLEM / "tmp/xcd_descent_algebra/universal_invariants.json"
TARGET = PROBLEM / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_tsv(path: Path) -> dict[tuple[int, ...], int]:
    answer: dict[tuple[int, ...], int] = {}
    with path.open() as stream:
        header = next(stream).split()
        assert header[-1] == "coefficient"
        for line in stream:
            row = list(map(int, line.split()))
            monomial, coefficient = tuple(row[:-1]), row[-1]
            assert monomial not in answer and coefficient
            answer[monomial] = coefficient
    return answer


def primitive_fraction(
    terms: dict[tuple[int, ...], Fraction],
) -> dict[tuple[int, ...], int]:
    terms = {monomial: value for monomial, value in terms.items() if value}
    denominator = 1
    for value in terms.values():
        denominator = lcm(denominator, value.denominator)
    integer = {
        monomial: value.numerator * (denominator // value.denominator)
        for monomial, value in terms.items()
    }
    content = 0
    for value in integer.values():
        content = gcd(content, abs(value))
    integer = {monomial: value // content for monomial, value in integer.items()}
    lead = max(integer)
    if integer[lead] < 0:
        integer = {monomial: -value for monomial, value in integer.items()}
    return integer


def ground_fraction(value) -> Fraction:
    assert value.is_ground and len(value.rep) == 1
    item = value.rep[0]
    return Fraction(int(item.numerator), int(item.denominator))


def primitive_algebraic(poly) -> dict[tuple[int, ...], int]:
    rows = poly.terms()
    anchor = rows[0][1]
    rational: dict[tuple[int, ...], Fraction] = {}
    for monomial, coefficient in rows:
        ratio = coefficient / anchor
        rational[monomial] = ground_fraction(ratio)
    return primitive_fraction(rational)


def reconstruct_discriminant() -> tuple[dict[tuple[int, ...], int], dict[tuple[int, ...], int]]:
    root = sp.symbols("root")
    cyclotomic = sp.Poly(sum(root**i for i in range(11)), root)
    field = sp.QQ.alg_field_from_poly(cyclotomic)
    ring = field.poly_ring("a_param", "b_param", "y_param", "t_param")
    a_param, b_param, y_param, t_param = ring.gens

    def kval(row):
        value = field.zero
        for numerator, denominator in reversed(row):
            value = value * field.unit + field(Fraction(int(numerator), int(denominator)))
        return value

    source = json.loads(FORMS.read_text())
    slots = {
        name: [kval(coefficient) for coefficient in vector]
        for name, vector in source["binary_slots"].items()
    }
    q = [
        slots["q0"][i] + a_param * slots["qA"][i] + y_param * slots["qY"][i]
        for i in range(3)
    ]
    r = [
        slots["r0"][i]
        + a_param * slots["rA"][i]
        + b_param * slots["rB"][i]
        + y_param * slots["rY"][i]
        + t_param * slots["rZ"][i]
        for i in range(4)
    ]

    # Evaluate the saved universal formulas, specialized to a monic depressed
    # cubic.  This route is independent of the hard-coded formulas in the
    # producer.
    universal = json.loads(UNIVERSAL.read_text())
    names = {
        "A": ring.one,
        "A2": ring.zero,
        "A3": ring.zero,
        "B": r[0],
        "B1": q[0],
        "B3": r[1],
        "C": r[3],
        "C1": q[2],
        "C2": r[2],
        "M": q[1],
    }
    safe = {"__builtins__": {}}
    c4 = eval(universal["c4"], safe, names)  # noqa: S307 - fixed local JSON
    c6 = eval(universal["c6"], safe, names)  # noqa: S307 - fixed local JSON
    delta_t = (c4**3 - c6**2).quo_ground(field(1728))
    primitive_t = primitive_algebraic(delta_t)

    z_fraction: defaultdict[tuple[int, ...], Fraction] = defaultdict(Fraction)
    for (ea, eb, ey, et), coefficient in primitive_t.items():
        for j in range(et + 1):
            z_fraction[(ea + 2 * (et - j), eb, ey, j)] += (
                Fraction(coefficient)
                * comb(et, j)
                * Fraction(-11, 18) ** (et - j)
            )
    return primitive_t, primitive_fraction(z_fraction)


def transform_target_to_t() -> dict[tuple[int, int, int, int], Fraction]:
    source = load_tsv(TARGET)
    result: defaultdict[tuple[int, int, int, int], Fraction] = defaultdict(Fraction)
    for (ea, eb, ey, ez), coefficient in source.items():
        for j in range(ez + 1):
            # Z=T+11*A^2/18.
            result[(ea + 2 * (ez - j), eb, ey, j)] += (
                Fraction(coefficient) * comb(ez, j) * Fraction(11, 18) ** (ez - j)
            )
    return {monomial: value for monomial, value in result.items() if value}


def falling(value: int, order: int) -> int:
    answer = 1
    for offset in range(order):
        answer *= value - offset
    return answer


def plane_derivative(
    terms: dict[tuple[int, int, int, int], Fraction], da: int, dy: int
) -> dict[tuple[int, int], Fraction]:
    result: defaultdict[tuple[int, int], Fraction] = defaultdict(Fraction)
    for (ea, eb, ey, et), coefficient in terms.items():
        if ea < da or ey < dy:
            continue
        result[(eb, et)] += (
            coefficient
            * falling(ea, da)
            * falling(ey, dy)
            * 15 ** (ea - da)
            * 12 ** (ey - dy)
        )
    return {monomial: value for monomial, value in result.items() if value}


def multiply2(left, right):
    result: defaultdict[tuple[int, int], Fraction] = defaultdict(Fraction)
    for (b1, t1), c1 in left.items():
        for (b2, t2), c2 in right.items():
            result[(b1 + b2, t1 + t2)] += c1 * c2
    return {monomial: value for monomial, value in result.items() if value}


def subtract2(left, right):
    result: defaultdict[tuple[int, int], Fraction] = defaultdict(Fraction)
    result.update(left)
    for monomial, value in right.items():
        result[monomial] -= value
    return {monomial: value for monomial, value in result.items() if value}


def expression(terms, variables):
    return sum(
        coefficient
        * sp.prod(variable**exponent for variable, exponent in zip(variables, monomial))
        for monomial, coefficient in terms.items()
    )


def check_plane_contact(h_t, d_t) -> None:
    assert not plane_derivative(h_t, 0, 0)
    assert not plane_derivative(h_t, 0, 1)
    assert not plane_derivative(d_t, 0, 0)
    assert not plane_derivative(d_t, 0, 1)
    h10 = plane_derivative(h_t, 1, 0)
    d10 = plane_derivative(d_t, 1, 0)
    h02 = {monomial: value / 2 for monomial, value in plane_derivative(h_t, 0, 2).items()}
    d02 = {monomial: value / 2 for monomial, value in plane_derivative(d_t, 0, 2).items()}
    assert h10 and d10
    numerator = subtract2(multiply2(h10, d02), multiply2(d10, h02))
    saved = load_tsv(HERE / "affine_plane_contact_numerator.tsv")
    assert primitive_fraction(numerator) == saved

    b, t = sp.symbols("B T")
    numerator_expr = expression(saved, (b, t))
    f15 = expression(load_tsv(HERE / "affine_plane_F15.tsv"), (b, t))
    q3 = (
        b**3
        + 24 * b**2 * t
        - 324 * b**2
        + 192 * b * t**2
        + 2592 * b * t
        - 7776 * b
        + 512 * t**3
        + 18144 * t**2
        + 194400 * t
        + 554040
    )
    expected = (
        (b - 10 * t - 117) ** 2
        * (b + 8 * t + 108) ** 2
        * (2 * b - 2 * t - 9)
        * (4 * b + 2 * t + 9) ** 4
        * q3
        * f15
    )
    ratio = sp.LC(sp.Poly(numerator_expr, b, t)) / sp.LC(sp.Poly(expected, b, t))
    assert sp.Poly(numerator_expr - ratio * expected, b, t).is_zero
    _, f15_factors = sp.factor_list(f15)
    assert len(f15_factors) == 1 and f15_factors[0][1] == 1


def check_boundary(h_t, d_t) -> None:
    a, b, y, t, c = sp.symbols("A B Y T c")
    h_degree, d_degree = 39, 11
    assert max(map(sum, h_t)) == h_degree and max(map(sum, d_t)) == d_degree
    h_top = {monomial: value for monomial, value in h_t.items() if sum(monomial) == 39}
    d_top = {monomial: value for monomial, value in d_t.items() if sum(monomial) == 11}
    h_expr = expression(h_top, (a, b, y, t))
    d_expr = expression(d_top, (a, b, y, t))
    top_gcd = sp.gcd(sp.Poly(h_expr, a, b, y, t), sp.Poly(d_expr, a, b, y, t))
    assert top_gcd.monic().as_expr() == a**4

    minima = {}
    for monomial in h_t:
        ea = monomial[0]
        ell = h_degree - sum(monomial)
        minima[ea] = min(minima.get(ea, ell), ell)
    lower = []
    for point in sorted(minima.items()):
        while len(lower) >= 2:
            p0, p1 = lower[-2], lower[-1]
            cross = (p1[0] - p0[0]) * (point[1] - p0[1]) - (p1[1] - p0[1]) * (point[0] - p0[0])
            if cross > 0:
                break
            lower.pop()
        lower.append(point)
    assert lower[:3] == [(0, 11), (10, 6), (28, 0)]

    def initial(terms, degree, weight, wanted=None):
        rows = []
        for (ea, eb, ey, et), coefficient in terms.items():
            ell = degree - ea - eb - ey - et
            rows.append((ea + weight * ell, ea, eb, ey, et, coefficient))
        value = min(row[0] for row in rows) if wanted is None else wanted
        return value, sum(
            coefficient * c**ea * b**eb * y**ey * t**et
            for weight_value, ea, eb, ey, et, coefficient in rows
            if weight_value == value
        )

    _, h2 = initial(h_t, 39, 2, 22)
    _, h3 = initial(h_t, 39, 3, 28)
    m2, d2 = initial(d_t, 11, 2)
    m3, d3 = initial(d_t, 11, 3)
    assert m2 == m3 == 4
    fraction_field = sp.QQ.frac_field(b, y, t)
    assert sp.gcd(sp.Poly(h2, c, domain=fraction_field), sp.Poly(d2, c, domain=fraction_field)).degree() == 0
    # Every slope -1/3 root has c != 0; the initial discriminant is a
    # nonzero scalar times c^4 there.
    assert sp.factor(d3) == 2985984 * c**4 * y**7
    assert h3 != 0


def check_payload_scopes() -> None:
    discriminant = json.loads((HERE / "discriminant_payload.json").read_text())
    plane = json.loads((HERE / "affine_plane_contact_payload.json").read_text())
    boundary = json.loads((HERE / "boundary_contact_payload.json").read_text())
    local = json.loads((HERE / "plane_local_types_payload.json").read_text())
    conductor = json.loads((HERE / "conductor_delta_payload.json").read_text())
    projective = json.loads((HERE / "projective_slice_payload.json").read_text())

    assert discriminant["T"]["sha256"] == sha(HERE / "fixed_frame_discriminant_T.tsv")
    assert discriminant["Z"]["sha256"] == sha(HERE / "fixed_frame_discriminant_Z.tsv")
    assert plane["generic_contact_order"] == 2 and plane["generic_contact_mod_3"] == 2
    assert [row["v_Delta"] for row in boundary["normalization_contact_orders"]] == [4, 4]
    assert [row["mod_3"] for row in boundary["normalization_contact_orders"]] == [1, 1]
    assert local["raw_target_singular_curves"]["mod3_verdict"] == "OPEN"
    assert "does not certify" in conductor["scope"]
    assert all(witness["Delta_norm_nonzero"] for witness in conductor["witnesses"])
    assert "good-reduction audit only" in projective["scope"]
    result = projective["results"][0]
    assert (result["prime"], result["ci_degree"], result["ci_residual_degree"]) == (1009, 429, 383)
    assert result["jacobian_residual_first"] == 1
    script = HERE / "projective_slice_p1009.sing"
    log = HERE / "projective_slice_p1009.out"
    assert sha(script) == result["script_sha256"] and sha(log) == result["log_sha256"]
    output = log.read_text()
    for marker in (
        "CI_DEGREE=",
        "CI_RESIDUAL_DEGREE=",
        "JAC_RESIDUAL_FIRST=1",
        "T3_PROJECTIVE_SLICE_DONE",
    ):
        assert marker in output
    assert re.search(r"CI_RESIDUAL_DEGREE=.*?degree \(proj\.\)\s*=\s*383", output, re.S)


def check_seal() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["schema"] == "t3-fixed-frame-discriminant-partial-seal-v1"
    assert "global normalized T3.D ledger open" in seal["status"]
    for section in ("artifacts", "sources"):
        for item in seal[section]:
            path = PROBLEM / item["path"]
            assert path.stat().st_size == item["bytes"]
            assert sha(path) == item["sha256"]


def main() -> None:
    saved_t = load_tsv(HERE / "fixed_frame_discriminant_T.tsv")
    saved_z = load_tsv(HERE / "fixed_frame_discriminant_Z.tsv")
    rebuilt_t, rebuilt_z = reconstruct_discriminant()
    assert rebuilt_t == saved_t and rebuilt_z == saved_z

    aa, bb, yy, zz = sp.symbols("A B Y Z")
    z_expr = expression(saved_z, (aa, bb, yy, zz))
    unit, factors = sp.factor_list(z_expr)
    assert unit == 1 and len(factors) == 1 and factors[0][1] == 1

    h_t = transform_target_to_t()
    d_t = {monomial: Fraction(value) for monomial, value in saved_t.items()}
    check_plane_contact(h_t, d_t)
    check_boundary(h_t, d_t)
    check_payload_scopes()
    check_seal()
    assert sha(FORMS) == "61377d6e464f7c78cf1fa91d13610b76dc4567de7b7214256e04de50066c83a4"
    assert sha(TARGET) == "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"
    print("T3_DISCRIMINANT_PACKET_VERIFIED")


if __name__ == "__main__":
    main()
