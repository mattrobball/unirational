#!/usr/bin/env python3
"""Independent verifier for WP-4C V4 fixed line module. No produce import."""

from __future__ import annotations

import hashlib
import json
import math
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
TRANS = HERE.parent
CERT = TRANS.parent
sys.path.insert(0, str(TRANS))
sys.path.insert(0, str(CERT))
import common  # noqa: E402
import exact_weil_check as ew  # noqa: E402


def binom(n, k):
    if k < 0 or n < 0 or k > n:
        return 0
    return math.comb(n, k)


def n_triv(m):
    count = 0
    for a in range(m + 1):
        for b in range(m - a + 1):
            g = m - a - b
            if (a + g) % 2 == 0 and (b + g) % 2 == 0:
                count += 1
    return count


def dim_M(m, d):
    if d < m or m < 0:
        return 0
    return (n_triv(m) + binom(m + 2, 2)) * (d - m + 1)


def main():
    data = json.loads((HERE / "module.json").read_text())
    assert data["headline"] == "OPEN"
    body = json.dumps({k: v for k, v in data.items() if k != "self_sha256"},
                      indent=2, sort_keys=True) + "\n"
    assert hashlib.sha256(body.encode()).hexdigest() == data["self_sha256"]

    table = data["module"]["hilbert_coeffs_m0_8_d0_11"]
    for m in range(9):
        for d in range(12):
            assert table[f"{m},{d}"] == dim_M(m, d), (m, d, table[f"{m},{d}"], dim_M(m, d))

    seq = data["module"]["dimension_formula"]["n_triv_sequence_m0_to_20"]
    assert seq == [n_triv(m) for m in range(21)]

    def n_triv_closed(m):
        if m % 2 == 0:
            k = m // 2
            return (k + 1) * (k + 2) // 2
        k = (m - 1) // 2
        return k * (k + 1) // 2

    assert all(n_triv(m) == n_triv_closed(m) for m in range(41))
    assert data["module"]["dimension_formula"]["n_triv_closed_form"]["verified_m_le_40"] is True

    assert data["regressions"]["n_triv_0"] == 1
    assert data["regressions"]["n_triv_1"] == 0
    assert data["regressions"]["n_triv_2"] == 3
    # m=0: rank = 1 + 1 = 2, dim at d=0 is 2 (target A dim 2)
    assert dim_M(0, 0) == 2
    assert data["regressions"]["dim_M_0_0"] == 2
    # m=1: n_triv=0, binom(3,2)=3, rank=3; dim_M(1,1)=3
    assert dim_M(1, 1) == 3
    assert data["regressions"]["dim_M_1_1"] == 3

    fp = data["module"]["finite_presentation"]
    assert fp["for_each_fixed_m"]["free_over_R"] is True
    assert fp["as_bigraded_module"]["finitely_generated_in_m"] is False

    ids = {s["id"] for s in data["geometric_theorem"]["statements"]}
    assert "4C.1_forced_base" in ids
    assert "4C.4_charge_tracking" in ids
    for s in data["geometric_theorem"]["statements"]:
        assert "PROVED" in s["status"] or "ACCEPTED" in s["status"]

    # Exact V4 joint dims via modular projectors at p=67
    p, zeta = 67, 64
    # Find a V4: two commuting distinct involutions
    invol = [g for g in ew.rho if common.order_key(g) == 2]
    z = ew.fs  # standard involution
    s = None
    for g in invol:
        if g == z:
            continue
        if common.mul_key(g, z) == common.mul_key(z, g) and g != z:
            # check product is third involution
            r = common.mul_key(z, g)
            if common.order_key(r) == 2 and r != z and r != g:
                s = g
                break
    assert s is not None
    r = common.mul_key(z, s)
    mats = {name: common.mmod(ew.rho[k], p, zeta) for name, k in [("z", z), ("s", s), ("r", r)]}
    I = [[int(i == j) for j in range(5)] for i in range(5)]

    def ker_sign(M, sign):
        # ker(M - sign I)
        return common.nullspace_mod(
            [[(M[i][j] - sign * I[i][j]) % p for j in range(5)] for i in range(5)], p
        )

    # Joint: A = ++, B = +-, C = -+, D = --
    # ++ = ker(z-I) ∩ ker(s-I)
    def intersect(b1, b2):
        # span intersection by solving coords
        # simple: vectors in span(b1) that are in span(b2)
        if not b1 or not b2:
            return []
        # For low dim use nullspace of stacked constraints
        # v = B1 c, and (I - proj_B2) v = 0
        # Use: members of b1 reduced against b2
        from itertools import combinations
        # Build matrix whose nullspace is joint by projectors
        return None

    # Projector dimensions via traces: dim E_χ = (1/|V4|) sum_g χ(g)^{-1} tr(g)
    # For triv: (1/4)(tr(1)+tr(z)+tr(s)+tr(r)) = (1/4)(5+1+1+1)=2
    # For each nontrivial: (1/4)(5 + χ(z)+χ(s)+χ(r)) with appropriate signs
    tr = {name: sum(mats[name][i][i] for i in range(5)) % p for name in mats}
    # All involutions have tr=1 in this rep (exact and mod p)
    assert all(tr[name] % p == 1 for name in tr)
    dim_A = (5 + 1 + 1 + 1) // 4
    assert dim_A == 2
    # χ_z: z→+1, s→-1, r→-1: dim = (5+1-1-1)/4 = 1
    assert (5 + 1 - 1 - 1) // 4 == 1

    # A4 character lines off X: certified in subgroup_orbit_check; record flag
    assert data["regressions"]["A4_character_lines_off_X"] is True
    assert data["charge_tracking"]["Gate1_consistency"] == "CLAIM_1_SURVIVES_CLAIM_2_REFUTED"

    print("PASS dim formula and n_triv sequence")
    print("PASS n_triv closed form (even/odd binomial)")
    print("PASS free presentation metadata and forced-base theorem markers")
    print("PASS V4 joint dims (2,1,1,1) via character projectors mod 67")
    print("PASS charge tracking references WP-3 / Gate 1")
    print("PASS self_sha256")
    print("V4_FIXED_LINE_MODULE_OK")


if __name__ == "__main__":
    main()
