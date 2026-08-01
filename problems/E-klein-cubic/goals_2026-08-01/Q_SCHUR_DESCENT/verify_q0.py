#!/usr/bin/env python3
"""Independent finite/arithmetic verifier for the Q0 Schur ledger.

This checker recomputes the group indices, both signed degree-one identities,
the degree-19 residual, and the exact D12-line stabilizer from the upstream
exact cyclotomic matrix model.  It deliberately does not turn those checks
into a rational-point claim.
"""

from __future__ import annotations

import json
import math
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
CERT = PROBLEM / "certificates"
sys.path.insert(0, str(CERT))

import exact_weil_check as ew  # exact Q(zeta_11) matrices


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
    for n in range(1, 100):
        out = mul(out, a)
        if out == ew.fone:
            return n
    raise AssertionError("order bound exceeded")


def matadd(a, b):
    return [[a[i][j] + b[i][j] for j in range(5)] for i in range(5)]


def matscale(c, a):
    return [[ew.C(c) * a[i][j] for j in range(5)] for i in range(5)]


def zero_matrix():
    return [[ew.C(0) for _ in range(5)] for _ in range(5)]


def trace(a):
    return sum(a[i][i] for i in range(5))


def column(a, j):
    return [a[i][j] for i in range(5)]


def matvec(a, v):
    return [sum(a[i][j] * v[j] for j in range(5)) for i in range(5)]


def proportional(u, v):
    return all(
        u[i] * v[j] == u[j] * v[i]
        for i in range(5)
        for j in range(i + 1, 5)
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
        for a in range(5)
        for b in range(a + 1, 5)
        for c in range(b + 1, 5)
    )


def klein_line_coefficients(u, v):
    out = [ew.C(0) for _ in range(4)]
    for i in range(5):
        j = (i + 1) % 5
        out[0] += u[i] * u[i] * u[j]
        out[1] += u[i] * u[i] * v[j] + 2 * u[i] * v[i] * u[j]
        out[2] += v[i] * v[i] * u[j] + 2 * u[i] * v[i] * v[j]
        out[3] += v[i] * v[i] * v[j]
    return tuple(out)


payload = json.loads((HERE / "q0_ledger.json").read_text())
group = list(ew.rho)
assert len(group) == payload["field"]["galois_group_order"] == 660

orders = {g: order(g) for g in group}
tau = next(g for g in group if orders[g] == 2)
H = {g for g in group if mul(g, tau) == mul(tau, g)}
assert len(H) == payload["closed_point_55"]["stabilizer_order"] == 12
assert len(group) // len(H) == payload["closed_point_55"]["degree"] == 55

# Reconstruct the two two-dimensional D12 isotypic projectors.  Exactly one
# projective image line must be contained in the Klein cubic.
r = next(g for g in H if orders[g] == 6 and power(g, 3) == tau)
characters = (
    (2, 1, -1, -2, -1, 1),
    (2, -1, -1, 2, -1, -1),
)
contained = []
for values in characters:
    projector = zero_matrix()
    for j in range(6):
        projector = matadd(projector, matscale(values[j], ew.rho[power(r, j)]))
    projector = matscale(ew.C(1) / 6, projector)
    assert ew.matmul(projector, projector) == projector
    assert trace(projector) == 2
    cols = [column(projector, j) for j in range(5)]
    u = next(v for v in cols if any(x != 0 for x in v))
    v = next(v for v in cols if any(x != 0 for x in v) and not proportional(u, v))
    if all(c == 0 for c in klein_line_coefficients(u, v)):
        contained.append((u, v))
assert len(contained) == 1

u, v = contained[0]
stabilizer = {
    g for g in group
    if in_span(u, v, matvec(ew.rho[g], u))
    and in_span(u, v, matvec(ew.rho[g], v))
}
assert stabilizer == H

cycle_degrees = []
for row in payload["orbit_cycles"]:
    assert 660 % row["order"] == 0
    assert row["degree"] == 660 // row["order"]
    cycle_degrees.append(row["degree"])
assert cycle_degrees == [60, 132, 165, 220]
assert math.gcd(*cycle_degrees) == 1

for cert in payload["degree_one_certificates"]:
    assert sum(c * d for c, d in zip(cert["coefficients"], cert["degrees"])) == 1
    assert cert["effective"] is False

assert math.gcd(55, 3) == payload["index"] == 1
assert 3 * 19 - 55 == payload["degree_19_residual"] == 2

print("PASS exact D12 contained line and full stabilizer order 12")
print("PASS generic residue degree [E^D12:K]=55 and Galois group order 660")
print("PASS orbit degrees 60,132,165,220 and gcd one")
print("PASS both signed degree-one identities; neither is effective")
print("PASS degree-19 residual arithmetic 3*19-55=2")
print("Q_SCHUR_Q0_LEDGER_EXACT")
print("BOUNDARY Q0 does not decide X_Schur(K_Schur)")

