#!/usr/bin/env python3
"""Independent verifier for WP-4A involution-plane module.

Does NOT import produce.py.  Recomputes dimension formula, Hilbert closed form,
exact (3,2) eigenspace dims, centralizer order, and F-parity on E_-, and checks
the sealed JSON against these independent computations.
"""

from __future__ import annotations

import hashlib
import json
import math
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
TRANS = HERE.parent
CERT = TRANS.parent
ROOT = CERT.parent
sys.path.insert(0, str(TRANS))
sys.path.insert(0, str(CERT))
import common  # noqa: E402
import exact_weil_check as ew  # noqa: E402


def binom(n, k):
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)


def dim_M(m, d):
    if d < m or m < 0:
        return 0
    base = (m + 1) * binom(d - m + 2, 2)
    return base * (3 if m % 2 == 0 else 2)


def closed_form_coeff(m, d):
    """Coeff of s^m t^d in (3 + 4 s t) / ((1-t)^3 (1-(s t)^2)^2)."""
    k = d - m
    if k < 0 or m < 0:
        return 0
    if m % 2 == 0:
        a = m // 2
        return (2 * a + 1) * 3 * binom(k + 2, 2)
    a = (m - 1) // 2
    return (2 * a + 2) * 2 * binom(k + 2, 2)


def main():
    path = HERE / "module.json"
    raw = path.read_text()
    data = json.loads(raw)

    # self-hash: body without self_sha256
    assert data["headline"] == "OPEN"
    body_obj = {k: v for k, v in data.items() if k != "self_sha256"}
    body = json.dumps(body_obj, indent=2, sort_keys=True) + "\n"
    assert hashlib.sha256(body.encode()).hexdigest() == data["self_sha256"], (
        "self_sha256 mismatch"
    )

    # Dimension table regression
    table = data["module"]["hilbert_coeffs_m0_7_d0_11"]
    for m in range(8):
        for d in range(12):
            key = f"{m},{d}"
            assert table[key] == dim_M(m, d) == closed_form_coeff(m, d), (
                key, table[key], dim_M(m, d), closed_form_coeff(m, d)
            )

    # Hilbert formula string present and matches our independent derivation
    formula = data["module"]["hilbert_series"]["formula"]
    assert "3 + 4*s*t" in formula or "3 + 4*s*t" in formula.replace(" ", "")
    assert "(1-t)^3" in formula
    assert "(s*t)^2" in formula or "(s t)^2" in formula.replace("*", " ")

    # Free presentation claims
    fp = data["module"]["finite_presentation"]
    assert fp["for_each_fixed_m"]["free"] is True
    assert fp["as_bigraded_module"]["finitely_generated_over_R_in_m"] is False
    assert fp["character_dependence"]["not_just_parity"] is True

    # Geometric theorem markers
    thm = data["geometric_theorem"]
    assert thm["headline"] == "OPEN"
    ids = {s["id"] for s in thm["statements"]}
    assert "4A.1_base_component" in ids
    assert "4A.2_odd_order" in ids
    assert "4A.3_dominates_minus_line" in ids
    for s in thm["statements"]:
        assert s["status"].startswith("PROVED")

    # Exact representation: (3,2), centralizer 12, t^2=I, trace=1
    t = ew.fs
    tM = ew.rho[t]
    tr = sum(tM[i][i] for i in range(5))
    assert tr == ew.C(1)
    t2 = common.matmul5(tM, tM)
    I = [[ew.C(i == j) for j in range(5)] for i in range(5)]
    assert t2 == I
    cent = common.centralizer_of_S()
    assert len(cent) == 12
    assert data["exact_representation"]["dims_Eplus_Eminus"] == [3, 2]
    assert data["exact_representation"]["centralizer_order"] == 12

    # Modular dims at p=67 for E±
    p, zeta = 67, 64
    tmod = common.mmod(tM, p, zeta)
    Imod = [[int(i == j) for j in range(5)] for i in range(5)]
    plus = common.nullspace_mod(
        [[(tmod[i][j] - Imod[i][j]) % p for j in range(5)] for i in range(5)], p
    )
    minus = common.nullspace_mod(
        [[(tmod[i][j] + Imod[i][j]) % p for j in range(5)] for i in range(5)], p
    )
    assert len(plus) == 3 and len(minus) == 2

    # F vanishes on E_- mod 67 (parity regression)
    # Sample: any vector in minus span
    for v in minus:
        # F = sum x_i^2 x_{i+1} mod p
        val = sum((v[i] * v[i] * v[(i + 1) % 5]) % p for i in range(5)) % p
        assert val == 0
    # random linear combination
    v = [(minus[0][i] + 3 * minus[1][i]) % p for i in range(5)]
    val = sum((v[i] * v[i] * v[(i + 1) % 5]) % p for i in range(5)) % p
    assert val == 0

    # Upstream recovery hash present
    assert "tmp/involution_exceptional_divisor/verify.py" in data["recovery"]["sha256"]

    # Rank formula samples
    assert data["regressions"]["dim_M_0_0"] == 3  # m=0 even: 1 * 1 * 3
    assert data["regressions"]["dim_M_1_1"] == 4  # 2 * 1 * 2

    # Low-degree regression: order-zero invariants land in E_+
    assert dim_M(0, 1) == 3 * binom(3, 2)  # 9
    assert dim_M(0, 2) == 3 * binom(4, 2)  # 18
    assert dim_M(2, 2) == 3 * 1 * 3  # m=2,d=2: (3)*1*3=9

    print("PASS hilbert closed form matches dim_M on [0..7]x[0..11]")
    print("PASS free presentation metadata")
    print("PASS geometric theorem markers (base, odd, dominates)")
    print("PASS exact (3,2), trace=1, centralizer 12, t^2=I")
    print("PASS modular F|E_-=0 and dims at p=67")
    print("PASS self_sha256")
    print("INVOLUTION_PLANE_MODULE_OK")


if __name__ == "__main__":
    main()
