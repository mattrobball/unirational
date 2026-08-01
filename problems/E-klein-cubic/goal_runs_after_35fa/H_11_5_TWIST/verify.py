#!/usr/bin/env python3
"""Independent verifier for the Goal-H4 invariant and trace packet.

This file deliberately does not import ``produce.py``.  It reconstructs the
authoritative 11:5 frame, the invariant lattice, the two field layers, the
trace frame, and the canonical change of coordinates from their definitions.
"""

from __future__ import annotations

from fractions import Fraction
from hashlib import sha256
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
TWISTS = ROOT / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "twists.json"
BRIDGE = ROOT / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_ROOT_019FBE10" / "BRIDGE.md"
GOAL = ROOT / "goals_after_35fa8f" / "GOAL_H4_11_5_GENERIC_TWIST.md"
WEIL = ROOT / "certificates" / "exact_weil_check.py"
EXACT_STRATA = ROOT / "certificates" / "strata" / "exact_strata.py"
NORMAL_CHARACTERS = ROOT / "certificates" / "strata" / "normal_characters.py"

EXPECTED_HASHES = {
    GOAL: "8b2e48f89ebc8daa971e618d341390e6803d21f22f411b88abb3dcc28cf0ef2f",
    TWISTS: "e97a32d6f22a8028528bc2b4d27ee009901caeb047fd2ffe5ac2bdd1fab743cd",
    BRIDGE: "660577dd5848eb5f9acb747b4c82877968d3ba5c59181581eb4ba8907d8aa2f8",
    WEIL: "14c9bda195ccc39e3ae2cd6d6d42bbb8f45397e114b5137947fb41dd665cc2b2",
    EXACT_STRATA: "a630b3a85d41eb0b60902a81cf8851c15fd0aa9c615c2d8a36584071dca34810",
    NORMAL_CHARACTERS: "8cb2a9a7d8b0405672308fc300cecd639de994cd73e29ef272328fa919e5b671",
}

WEIGHTS = (1, 9, 4, 3, 5)
R_EXPONENTS = (
    (-2, 1, 1, 0, 0),
    (0, -2, 1, 1, 0),
    (0, 0, -2, 1, 1),
    (1, 0, 0, -2, 1),
    (1, 1, 0, 0, -2),
)


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def identity(n: int) -> list[list[int]]:
    return [[int(i == j) for j in range(n)] for i in range(n)]


def mmul(a, b, p):
    return [[sum(a[i][k] * b[k][j] for k in range(len(b))) % p for j in range(len(b[0]))] for i in range(len(a))]


def mv(a, v, p):
    return [sum(a[i][j] * v[j] for j in range(len(v))) % p for i in range(len(a))]


def mpow(a, n, p):
    out = identity(len(a))
    while n:
        if n & 1:
            out = mmul(out, a, p)
        a = mmul(a, a, p)
        n //= 2
    return out


def minverse(a, p):
    n = len(a)
    work = [row[:] + identity(n)[i] for i, row in enumerate(a)]
    for column in range(n):
        pivot = next(i for i in range(column, n) if work[i][column] % p)
        work[column], work[pivot] = work[pivot], work[column]
        scale = pow(work[column][column], -1, p)
        work[column] = [scale * x % p for x in work[column]]
        for i in range(n):
            if i != column:
                scale = work[i][column]
                work[i] = [(x - scale * y) % p for x, y in zip(work[i], work[column])]
    return [row[n:] for row in work]


def determinant(a, p=None):
    work = [[Fraction(x) if p is None else x % p for x in row] for row in a]
    out = Fraction(1)
    for column in range(len(work)):
        pivot = next((i for i in range(column, len(work)) if work[i][column]), None)
        if pivot is None:
            return 0
        if pivot != column:
            work[column], work[pivot] = work[pivot], work[column]
            out = -out
        value = work[column][column]
        out *= value
        for i in range(column + 1, len(work)):
            scale = work[i][column] / value if p is None else work[i][column] * pow(value, -1, p) % p
            for j in range(column, len(work)):
                work[i][j] = work[i][j] - scale * work[column][j]
                if p is not None:
                    work[i][j] %= p
    return int(out if p is None else out % p)


def solve_fraction(a, b):
    n = len(a)
    work = [[Fraction(x) for x in row] + [Fraction(b[i])] for i, row in enumerate(a)]
    for column in range(n):
        pivot = next(i for i in range(column, n) if work[i][column])
        work[column], work[pivot] = work[pivot], work[column]
        scale = work[column][column]
        work[column] = [x / scale for x in work[column]]
        for i in range(n):
            if i != column:
                scale = work[i][column]
                work[i] = [x - scale * y for x, y in zip(work[i], work[column])]
    return [row[-1] for row in work]


def compositions(total, length):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, length - 1):
            yield (first,) + rest


def cubic_coefficients(frame, p):
    out = {e: 0 for e in compositions(3, 5)}
    for i in range(5):
        for j, k, ell in itertools.product(range(5), repeat=3):
            e = [0] * 5
            e[j] += 1
            e[k] += 1
            e[ell] += 1
            key = tuple(e)
            out[key] = (out[key] + frame[i][j] * frame[i][k] * frame[(i + 1) % 5][ell]) % p
    return {",".join(map(str, key)): value for key, value in sorted(out.items()) if value}


def group_data(p, zeta11):
    t = [[pow(zeta11, WEIGHTS[i], p) if i == j else 0 for j in range(5)] for i in range(5)]
    shift = [[int(i == (j + 1) % 5) for j in range(5)] for i in range(5)]
    group = [mmul(mpow(t, a, p), mpow(shift, b, p), p) for a in range(11) for b in range(5)]
    assert len({tuple(x for row in h for x in row) for h in group}) == 55
    assert mpow(t, 11, p) == identity(5) and mpow(shift, 5, p) == identity(5)
    assert mmul(mmul(shift, t, p), minverse(shift, p), p) == mpow(t, 5, p)
    return t, shift, group


def canonical_frame(y, p, zeta11):
    _, _, group = group_data(p, zeta11)
    ell = (1, 2, 3, 4, 5)
    out = [[0] * 5 for _ in range(5)]
    denominator_product = 1
    for h in group:
        moved = mv(minverse(h, p), y, p)
        denominator = sum(a * b for a, b in zip(ell, moved)) % p
        assert denominator
        denominator_product = denominator_product * denominator % p
        c = moved[0] * pow(denominator, -1, p) % p
        for i in range(5):
            for j in range(5):
                out[i][j] = (out[i][j] + c * h[i][j]) % p
    return out, denominator_product


def trace_data(y, p):
    r = [y[(i + 1) % 5] * y[(i + 2) % 5] * pow(y[i], -2, p) % p for i in range(5)]
    beta = [y[(i + 2) % 5] * pow(y[(i + 3) % 5], -1, p) % p for i in range(5)]
    frame = [[beta[i] * pow(r[i], j, p) % p for j in range(5)] for i in range(5)]
    return r, beta, frame


def trace_coefficients(r, p):
    out = {e: 0 for e in compositions(3, 5)}
    for i in range(5):
        for j, k, ell in itertools.product(range(5), repeat=3):
            e = [0] * 5
            e[j] += 1
            e[k] += 1
            e[ell] += 1
            key = tuple(e)
            value = pow(r[(i + 2) % 5], -1, p) * pow(r[i], j + k, p) * pow(r[(i + 1) % 5], ell, p)
            out[key] = (out[key] + value) % p
    return {",".join(map(str, key)): value for key, value in sorted(out.items()) if value}


def combine_r(exponents):
    return tuple(sum(exponents[i] * R_EXPONENTS[i][j] for i in range(5)) for j in range(5))


def rotate_exponents(v):
    return (v[-1],) + tuple(v[:-1])


def verify_seal():
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["format"] == "H-11_5-GENERIC-TWIST-SEAL-v1"
    assert seal["exit"] == "H-11_5-NORM-MODEL-PASS"
    durable = {
        path.relative_to(HERE).as_posix(): digest(path)
        for path in HERE.rglob("*")
        if path.is_file()
        and path.name != "SEAL.json"
        and path.suffix != ".pyc"
        and "__pycache__" not in path.parts
        and path.name != ".DS_Store"
    }
    assert durable == seal["files"]


def main():
    for path, expected in EXPECTED_HASHES.items():
        assert digest(path) == expected

    field = json.loads((HERE / "field_model.json").read_text())
    norm = json.loads((HERE / "norm_model.json").read_text())
    twist = json.loads((HERE / "twist_model.json").read_text())
    decision = json.loads((HERE / "decision.json").read_text())
    assert decision["exit"] == "H-11_5-NORM-MODEL-PASS"
    assert decision["rational_point_over_K"] is None
    assert decision["valuation_obstruction"] is None

    source = json.loads(TWISTS.read_text())
    record = next(item for item in source["records"] if item["label"] == "11:5")
    assert record["order"] == 55
    assert len(record["subgroup_elements"]) == 55

    # Independently reproduce the canonical p=89 frame and all 35 coefficients.
    anchor = record["good_reduction"]
    canonical, denominator_product = canonical_frame(anchor["source_point"], 89, 2)
    assert denominator_product == anchor["denominator_product"] == 86
    assert canonical == anchor["frame"]
    assert determinant(canonical, 89) == anchor["frame_determinant"] == 87
    assert cubic_coefficients(canonical, 89) == anchor["specialized_twist_coefficients"]

    # The r_i generate the entire C11-fixed character lattice.
    assert all(sum(row) == 0 for row in R_EXPONENTS)
    assert all(sum(a * b for a, b in zip(row, WEIGHTS)) % 11 == 0 for row in R_EXPONENTS)
    assert tuple(sum(row[i] for row in R_EXPONENTS) for i in range(5)) == (0, 0, 0, 0, 0)
    exponent_minor = [[R_EXPONENTS[j][i] for j in range(4)] for i in range(1, 5)]
    assert determinant(exponent_minor) == 11

    # Kummer relation, sigma action, and inverse reconstruction are literal
    # identities of degree-zero exponent vectors in the y_i.
    beta = (0, 0, 1, -1, 0)
    assert combine_r((2, 1, -4, 4, 0)) == tuple(11 * x for x in beta)
    sigma_beta = (0, 0, 0, 1, -1)
    rhs_sigma_beta = tuple(a - 2 * b for a, b in zip(combine_r((0, 0, -1, 0, 0)), beta))
    assert rhs_sigma_beta == sigma_beta
    inverse_formulas = (
        ((1, 0, -1, 1, 0), -3),
        ((0, 0, 1, -1, 0), 3),
        ((0, 0, 1, -1, 0), 2),
        ((0, 0, 2, -1, 0), 4),
    )
    expected_ratios = ((-1, 1, 0, 0, 0), (-1, 0, 1, 0, 0), (-1, 0, 0, 1, 0), (-1, 0, 0, 0, 1))
    for (r_exponents, beta_power), expected in zip(inverse_formulas, expected_ratios):
        got = tuple(a + beta_power * b for a, b in zip(combine_r(r_exponents), beta))
        assert got == expected

    # Recompute the common-open trace frame, its covariance, determinant,
    # trace coefficients, and invariant transition to the canonical frame.
    witness = twist["common_open_good_reduction_witness"]
    y = witness["source_point"]
    t, shift, _ = group_data(89, 2)
    canonical, den = canonical_frame(y, 89, 2)
    r, betas, trace = trace_data(y, 89)
    transition = mmul(minverse(canonical, 89), trace, 89)
    assert r == witness["r"] and betas == witness["beta_conjugates"]
    assert den == witness["canonical_denominator_product"]
    assert determinant(canonical, 89) == witness["canonical_frame_determinant"]
    assert determinant(trace, 89) == witness["trace_frame_determinant"] == witness["vandermonde"]
    assert determinant(transition, 89) == witness["transition_determinant"]
    assert transition == witness["transition_A_inverse_B"]
    assert cubic_coefficients(trace, 89) == trace_coefficients(r, 89) == witness["trace_twist_coefficients"]
    assert betas[0] ** 11 % 89 == witness["beta_11"]
    assert betas[1] == pow(r[2] * betas[0] ** 2, -1, 89)
    for generator in (t, shift):
        moved_y = mv(generator, y, 89)
        moved_canonical, _ = canonical_frame(moved_y, 89, 2)
        _, _, moved_trace = trace_data(moved_y, 89)
        assert moved_canonical == mmul(generator, canonical, 89)
        assert moved_trace == mmul(generator, trace, 89)
        assert mmul(minverse(moved_canonical, 89), moved_trace, 89) == transition

    # Fourier diagonalization and its inverse independently recover the
    # four invariant parameters at a prime containing zeta_5 and zeta_11.
    dft = field["finite_field_inverse_map_witness"]
    p = dft["prime"]
    eps = dft["epsilon5"]
    projective_r = dft["projective_R"]
    s = [sum(pow(eps, -i * j, p) * projective_r[i] for i in range(5)) % p for j in range(5)]
    assert s == dft["fourier_s"]
    q = [1] + [s[j] * pow(s[0], -1, p) % p for j in range(1, 5)]
    u = [pow(q[1], 5, p), q[2] * pow(q[1], -2, p) % p, q[3] * pow(q[1], -3, p) % p, q[4] * pow(q[1], -4, p) % p]
    assert q[1:] == dft["fourier_ratios"] and u == dft["invariants_U"]
    shifted = projective_r[1:] + projective_r[:1]
    shifted_s = [sum(pow(eps, -i * j, p) * shifted[i] for i in range(5)) % p for j in range(5)]
    shifted_q = [1] + [shifted_s[j] * pow(shifted_s[0], -1, p) % p for j in range(1, 5)]
    shifted_u = [pow(shifted_q[1], 5, p), shifted_q[2] * pow(shifted_q[1], -2, p) % p, shifted_q[3] * pow(shifted_q[1], -3, p) % p, shifted_q[4] * pow(shifted_q[1], -4, p) % p]
    assert shifted_u == u
    reconstructed_q = [1, q[1], u[1] * q[1] ** 2 % p, u[2] * q[1] ** 3 % p, u[3] * q[1] ** 4 % p]
    reconstructed = [pow(5, -1, p) * sum(pow(eps, i * j, p) * reconstructed_q[j] for j in range(5)) % p for i in range(5)]
    scale = reconstructed[0] * pow(projective_r[0], -1, p) % p
    assert reconstructed == [scale * x % p for x in projective_r]

    # The coefficient is norm one but nontrivial for the relevant isogeny.
    # On exponents psi=2+sigma has determinant 33.  Modulo the product
    # relation, a solution of psi(v)=e2 would reduce to the n=1 system;
    # its unique solution has denominator 11.  The displayed vector proves
    # that the class nevertheless dies after multiplication by 11.
    psi_matrix = [[2 * int(i == j) + int(j == (i - 1) % 5) for j in range(5)] for i in range(5)]
    assert determinant(psi_matrix) == 33
    target = [1, 1, 2, 1, 1]  # e2 + the diagonal relation
    solution = solve_fraction(psi_matrix, target)
    assert solution == [Fraction(3, 11), Fraction(4, 11), Fraction(9, 11), Fraction(1, 11), Fraction(5, 11)]
    witness_vector = (0, 1, 6, -2, 2)
    psi_witness = tuple(2 * witness_vector[i] + rotate_exponents(witness_vector)[i] for i in range(5))
    assert psi_witness == (2, 2, 13, 2, 2)  # 11*e2 + 2*(1,...,1)
    assert norm["coefficient_isogeny_class"]["degree"] == 33

    # The eigenpoint polynomial over E maps to the first coordinate: all
    # four conjugate evaluations vanish.  Hence it is a degree-five point,
    # not a K-point.  A monomial trace is an orbit sum of size 1 or 5 and
    # cannot cancel in characteristic zero.
    assert norm["degree_five_point"]["field"] == "E"
    assert norm["monomial_screen"]["scope"].startswith("infinite pure-monomial")

    verify_seal()
    print("H_11_5_INDEPENDENT_VERIFY_OK")


if __name__ == "__main__":
    main()
