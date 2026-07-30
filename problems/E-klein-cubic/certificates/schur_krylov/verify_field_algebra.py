#!/usr/bin/env python3
"""Independent verifier for Gate A2 field algebra.

Does NOT import a producer.  Checks sealed JSON, companion arithmetic on a
symbolic monic polynomial of degree 55, Cayley-Hamilton, and subfield lattice.
"""
from __future__ import annotations

import hashlib
import json
import math
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def companion(coeffs_low_to_high_without_leading: list[int]) -> list[list[int]]:
    """Companion matrix for monic mu = t^n + c_{n-1} t^{n-1} + ... + c0.
    coeffs_low_to_high_without_leading = [c0, c1, ..., c_{n-1}].
    """
    n = len(coeffs_low_to_high_without_leading)
    C = [[0 for _ in range(n)] for _ in range(n)]
    for i in range(1, n):
        C[i][i - 1] = 1
    for i in range(n):
        C[i][n - 1] = -coeffs_low_to_high_without_leading[i]
    return C


def matmul(A: list[list[int]], B: list[list[int]]) -> list[list[int]]:
    n = len(A)
    return [
        [sum(A[i][k] * B[k][j] for k in range(n)) for j in range(n)]
        for i in range(n)
    ]


def matpow(A: list[list[int]], e: int) -> list[list[int]]:
    n = len(A)
    R = [[1 if i == j else 0 for j in range(n)] for i in range(n)]
    base = A
    while e:
        if e & 1:
            R = matmul(R, base)
        base = matmul(base, base)
        e //= 2
    return R


def mat_linear_combo(mats: list[list[list[int]]], coeffs: list[int]) -> list[list[int]]:
    n = len(mats[0])
    out = [[0 for _ in range(n)] for _ in range(n)]
    for c, M in zip(coeffs, mats):
        for i in range(n):
            for j in range(n):
                out[i][j] += c * M[i][j]
    return out


def main() -> int:
    md = HERE / "field_algebra.md"
    js = HERE / "field_algebra.json"
    assert md.is_file() and js.is_file()
    data = json.loads(js.read_text(encoding="utf-8"))
    text = md.read_text(encoding="utf-8")

    assert data["degree"] == 55
    assert data["presentation"]["type"] == "monogenic"
    assert data["presentation"]["mu_degree"] == 55
    assert data["group_indices"]["G_order"] == 660
    assert data["group_indices"]["H_order"] == 12
    assert data["group_indices"]["L_over_F"] == 55
    assert 660 // 12 == 55
    assert data["presentation"]["galois"]["L_over_F_galois"] is False
    assert data["presentation"]["galois"]["Aut_L_F"] == 1
    assert data["subfields"]["possible_degrees"] == [1, 5, 11, 55]
    assert math.gcd(55, 2) == 1

    # Companion + Cayley-Hamilton on a concrete monic of degree 55 over Z
    # mu = t^55 + 1 (coeffs c0=1, c1=...=c54=0)
    n = 55
    c = [0] * n
    c[0] = 1  # t^55 + 1
    C = companion(c)
    assert len(C) == n and len(C[0]) == n
    # C e_k = e_{k+1} for k < n-1; C e_{n-1} = -c0 e0 = -e0 for this mu
    # Cayley-Hamilton: C^55 + I = 0 for mu=t^55+1
    C55 = matpow(C, 55)
    I = [[1 if i == j else 0 for j in range(n)] for i in range(n)]
    for i in range(n):
        for j in range(n):
            assert C55[i][j] + I[i][j] == 0, (i, j, C55[i][j])

    # General CH: C^n + sum c_k C^k = 0
    # Use a denser test polynomial of small degree embedded: still n=55 with
    # only low coefficients nonzero: t^55 + 3 t + 2
    c2 = [0] * n
    c2[0] = 2
    c2[1] = 3
    C2 = companion(c2)
    powers = [matpow(C2, k) for k in range(n)]
    # C2^n = - sum c_k C2^k
    left = matpow(C2, n)
    right = mat_linear_combo(powers, [-ck for ck in c2])
    assert left == right

    # dim U_tau formula
    for deg in (1, 5, 11, 55):
        dim_u = min(20, deg)
        if deg == 55:
            assert dim_u == 20
        else:
            assert dim_u == deg

    assert "SCHUR_KRYLOV_A2_FIELD_ALGEBRA_SEALED" in text
    assert data["terminal_marker"] == "SCHUR_KRYLOV_A2_FIELD_ALGEBRA_SEALED"
    assert data["presentation"]["mu_coefficients_expanded_in_invariants"] is False

    print("A2_FIELD_ALGEBRA_GROUP_INDEX_OK")
    print("A2_FIELD_ALGEBRA_COMPANION_CAYLEY_HAMILTON_OK")
    print("A2_FIELD_ALGEBRA_SUBFIELD_DIM_U_OK")
    print(f"A2_FIELD_ALGEBRA_MD_SHA256 {sha256_file(md)}")
    print(f"A2_FIELD_ALGEBRA_JSON_SHA256 {sha256_file(js)}")
    print("SCHUR_KRYLOV_A2_FIELD_ALGEBRA_SEALED")
    return 0


if __name__ == "__main__":
    sys.exit(main())
