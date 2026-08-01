#!/usr/bin/env python3
"""Independent arithmetic/group check for the Goal Q zero-cycle ledger.

The script rebuilds the D12 contained line using the normalizer of a C3,
whereas the upstream hostile audit uses the centralizer of an involution.
It imports only the repository's exact Q(zeta_11) action model.
"""

from __future__ import annotations

import json
import math
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
sys.path.insert(0, str(PROBLEM / "certificates"))
import exact_weil_check as ew  # noqa: E402


def mul(a, b):
    return ew.fcanon(ew.fmul(a, b))


def inv(a):
    aa, b, c, d = a
    return ew.fcanon((d, -b, -c, aa))


def power(a, n):
    out = ew.fone
    for _ in range(n):
        out = mul(out, a)
    return out


def order(a):
    out = ew.fone
    for n in range(1, 61):
        out = mul(out, a)
        if out == ew.fone:
            return n
    raise AssertionError("unexpected element order")


GROUP = tuple(ew.rho)
ORDERS = {g: order(g) for g in GROUP}


def cyclic(g):
    return {power(g, i) for i in range(ORDERS[g])}


def conjugate(g, h):
    return mul(mul(g, h), inv(g))


def normalizer(subgroup):
    return {
        g for g in GROUP
        if {conjugate(g, h) for h in subgroup} == subgroup
    }


def zero_matrix():
    return [[ew.C(0) for _ in range(5)] for _ in range(5)]


def identity_matrix():
    return [[ew.C(i == j) for j in range(5)] for i in range(5)]


def matadd(a, b):
    return [[a[i][j] + b[i][j] for j in range(5)] for i in range(5)]


def matsub(a, b):
    return [[a[i][j] - b[i][j] for j in range(5)] for i in range(5)]


def matscale(c, a):
    return [[ew.C(c) * a[i][j] for j in range(5)] for i in range(5)]


def trace(a):
    return sum(a[i][i] for i in range(5))


def column(a, j):
    return [a[i][j] for i in range(5)]


def matvec(a, v):
    return [sum(a[i][j] * v[j] for j in range(5)) for i in range(5)]


def proportional(u, v):
    return all(
        u[i] * v[j] == u[j] * v[i]
        for i in range(5) for j in range(i + 1, 5)
    )


def det3(rows):
    return (
        rows[0][0] * (rows[1][1] * rows[2][2] - rows[1][2] * rows[2][1])
        - rows[0][1] * (rows[1][0] * rows[2][2] - rows[1][2] * rows[2][0])
        + rows[0][2] * (rows[1][0] * rows[2][1] - rows[1][1] * rows[2][0])
    )


def in_span(u, v, w):
    return all(
        det3([[u[a], v[a], w[a]], [u[b], v[b], w[b]], [u[c], v[c], w[c]]]) == 0
        for a in range(5) for b in range(a + 1, 5) for c in range(b + 1, 5)
    )


def klein_binary(u, v):
    coeffs = [ew.C(0) for _ in range(4)]
    for i in range(5):
        j = (i + 1) % 5
        coeffs[0] += u[i] * u[i] * u[j]
        coeffs[1] += u[i] * u[i] * v[j] + 2 * u[i] * v[i] * u[j]
        coeffs[2] += v[i] * v[i] * u[j] + 2 * u[i] * v[i] * v[j]
        coeffs[3] += v[i] * v[i] * v[j]
    return tuple(coeffs)


assert len(GROUP) == 660
c3_generator = next(g for g in GROUP if ORDERS[g] == 3)
C3 = cyclic(c3_generator)
H = normalizer(C3)
assert len(H) == 12

r = next(g for g in H if ORDERS[g] == 6 and C3 <= cyclic(g))
R = cyclic(r)
s = next(g for g in H if g not in R and ORDERS[g] == 2)
assert H == R | {mul(s, power(r, j)) for j in range(6)}
assert mul(mul(s, r), s) == inv(r)

characters = (
    (2, 1, -1, -2, -1, 1),
    (2, -1, -1, 2, -1, -1),
)
projectors = []
contained_lines = []
for values in characters:
    projector = zero_matrix()
    for j in range(6):
        projector = matadd(
            projector, matscale(values[j], ew.rho[power(r, j)])
        )
    projector = matscale(ew.C(1) / 6, projector)
    assert ew.matmul(projector, projector) == projector
    assert trace(projector) == 2
    columns = [column(projector, j) for j in range(5)]
    u = next(v for v in columns if any(x != 0 for x in v))
    v = next(v for v in columns if any(x != 0 for x in v) and not proportional(u, v))
    if klein_binary(u, v) == (ew.C(0),) * 4:
        contained_lines.append((u, v))
    projectors.append(projector)

assert ew.matmul(projectors[0], projectors[1]) == zero_matrix()
residual = matsub(matsub(identity_matrix(), projectors[0]), projectors[1])
assert trace(residual) == 1 and ew.matmul(residual, residual) == residual
assert len(contained_lines) == 1
u, v = contained_lines[0]
stabilizer = {
    g for g in GROUP
    if in_span(u, v, matvec(ew.rho[g], u))
    and in_span(u, v, matvec(ew.rho[g], v))
}
assert stabilizer == H

core = {
    h for h in H
    if all(conjugate(g, h) in H for g in GROUP)
}
assert core == {ew.fone}

payload = json.loads((HERE / "zero_cycle_payload.json").read_text())
assert payload["group_order"] == len(GROUP)
assert payload["d12_order"] == len(H)
assert payload["d12_line_orbit_degree"] == len(GROUP) // len(H) == 55

degrees = payload["sylow_orbit_degrees"]
coeffs = payload["formal_degree_one_coefficients"]
assert degrees == [60, 132, 165, 220]
assert math.gcd(*degrees) == 1
assert sum(c * d for c, d in zip(coeffs, degrees)) == 1
assert 55 + payload["degree55_section_coefficient"] * 3 == 1
assert payload["least_proper_curve_degree_through_degree55_point"] == 19
assert 3 * 18 < 55 <= 3 * 19
assert 3 * 19 - 55 == payload["residual_degree"] == 2
assert 3 * 55 - 3 - 55 == payload["balestrieri_bound"] == 107

print("PASS D12 reconstructed as N_G(C3), with exact dihedral relations")
print("PASS unique rank-two D12 summand is a contained Klein line")
print("PASS full line stabilizer D12, orbit degree 55, trivial core")
print("PASS orbit-cycle gcd and both signed degree-one ledgers")
print("PASS degree-19 residual-two and Balestrieri-107 arithmetic")
print("Q_SCHUR_ZERO_CYCLE_LEDGER_EXACT")
