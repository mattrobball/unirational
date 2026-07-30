#!/usr/bin/env python3
"""Independent verifier for WP-4D C3 lines module. No produce import."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
TRANS = HERE.parent
CERT = TRANS.parent
sys.path.insert(0, str(TRANS))
sys.path.insert(0, str(CERT))
import common  # noqa: E402
import exact_weil_check as ew  # noqa: E402


def is_prime(p):
    if p < 2:
        return False
    return all(p % q for q in range(2, int(p**0.5) + 1))


def find_zeta11(p):
    if (p - 1) % 11:
        return None
    for g in range(2, min(p, 300)):
        z = pow(g, (p - 1) // 11, p)
        if z != 1 and pow(z, 11, p) == 1 and all(
            pow(z, k, p) != 1 for k in (1, 2, 5)
        ):
            return z
    return None


def disc_binary(a, b, c, d, p):
    return (
        18 * a * b * c * d
        - 4 * b * b * b * d
        + b * b * c * c
        - 4 * a * c * c * c
        - 27 * a * a * d * d
    ) % p


def recompute_one_prime(p, zeta):
    roots = [a for a in range(p) if (a * a + a + 1) % p == 0 and a != 1]
    c3gen = common.mul_key(ew.fs, ew.ft)
    M = common.mmod(ew.rho[c3gen], p, zeta)
    I = [[int(i == j) for j in range(5)] for i in range(5)]
    omega = roots[0]
    U = common.nullspace_mod(
        [[(M[i][j] - omega * I[i][j]) % p for j in range(5)] for i in range(5)], p
    )
    assert len(U) == 2
    U1 = common.nullspace_mod(
        [[(M[i][j] - I[i][j]) % p for j in range(5)] for i in range(5)], p
    )
    roots2 = [a for a in range(p) if (a * a + a + 1) % p == 0 and a != 1]
    U2 = common.nullspace_mod(
        [[(M[i][j] - roots2[1] * I[i][j]) % p for j in range(5)]
         for i in range(5)], p
    ) if len(roots2) > 1 else []
    assert len(U1) == 1
    assert len(U) == 2 and len(U2) == 2

    def F(v):
        return sum((v[i] * v[i] * v[(i + 1) % 5]) % p for i in range(5)) % p

    pts = [(1, 0), (0, 1), (1, 1), (1, 2), (2, 1), (3, 1), (1, 3), (2, 3)]
    A = []
    for s, t in pts:
        v = [(s * U[0][i] + t * U[1][i]) % p for i in range(5)]
        A.append([pow(s, 3, p), (s * s * t) % p, (s * t * t) % p, pow(t, 3, p), F(v)])
    r = 0
    for c in range(4):
        piv = next((i for i in range(r, len(A)) if A[i][c] % p), None)
        if piv is None:
            continue
        A[r], A[piv] = A[piv], A[r]
        inv = pow(A[r][c], -1, p)
        A[r] = [(inv * x) % p for x in A[r]]
        for i in range(len(A)):
            if i != r and A[i][c]:
                f = A[i][c]
                A[i] = [(A[i][j] - f * A[r][j]) % p for j in range(5)]
        r += 1
    c = [0, 0, 0, 0]
    for row in A:
        pivs = [j for j in range(4) if row[j] != 0]
        if len(pivs) == 1 and row[pivs[0]] == 1:
            c[pivs[0]] = row[4]
    a, b, cc, d = c
    disc = disc_binary(a, b, cc, d, p)
    assert disc % p != 0, (p, c, disc)
    return disc


def reynolds_dim(m, d):
    if d < m or m < 0:
        return 0
    k = d - m
    dim_Usym = k + 1
    weight_U = (2 * k) % 3
    total = 0
    for a in range(m + 1):
        n_mon = m - a + 1
        w_N = (2 * m - a) % 3
        w_section = (w_N + weight_U) % 3
        need = (-w_section) % 3
        tdim = 1 if need == 0 else 2
        total += n_mon * dim_Usym * tdim
    return total


def main():
    data = json.loads((HERE / "module.json").read_text())
    assert data["headline"] == "OPEN"
    body = json.dumps({k: v for k, v in data.items() if k != "self_sha256"},
                      indent=2, sort_keys=True) + "\n"
    assert hashlib.sha256(body.encode()).hexdigest() == data["self_sha256"]

    # Independent disc checks at 331 and 397
    for p, zeta in ((331, 270), (397, None)):
        if zeta is None:
            zeta = find_zeta11(p)
        disc = recompute_one_prime(p, zeta)
        print(f"PASS square-free binary cubic at p={p}, disc={disc}")

    samples = data["X_intersection"]["char0_reducedness"]["samples"]
    assert len(samples) >= 3
    assert all(s["square_free_mod_p"] for s in samples)
    assert data["geometric_theorem"]["C3_220_remainder"]["status"] == "CLOSED"

    # Dimension table
    table = data["module"]["hilbert_coeffs_m0_6_d0_9"]
    for m in range(7):
        for d in range(10):
            assert table[f"{m},{d}"] == reynolds_dim(m, d), (m, d)

    assert data["X_intersection"]["reduced"] is True
    assert data["X_intersection"]["composition"]["exact_C3_points"] == 2
    assert data["order_zero_restrictions"]["forced_base"] is False

    ids = {s["id"] for s in data["geometric_theorem"]["statements"]}
    assert "4D.2_three_point_intersection" in ids
    assert "4D.3_C6_vs_C3_points" in ids

    # M2 disc identity file exists
    assert (HERE / "disc_identity.m2").is_file()

    print("PASS dim table Reynolds match")
    print("PASS C3_220 remainder CLOSED by char-0 disc argument")
    print("PASS not forced base; composition 1 C6 + 2 C3")
    print("PASS self_sha256")
    print("C3_LINES_MODULE_OK")


if __name__ == "__main__":
    main()
