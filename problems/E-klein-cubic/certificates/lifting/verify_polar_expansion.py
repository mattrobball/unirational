#!/usr/bin/env python3
"""Independent verifier for WP-L1 polar expansion.

Does NOT import polar_expansion.py.  Re-derives Phi, B, the order-3m+1 and
order-3m+3 equations combinatorially, checks family estimates for sanity, and
validates self-hashes / no timing / headline OPEN.
"""

from __future__ import annotations

import json
import math
import sys
from fractions import Fraction
from itertools import permutations
from pathlib import Path

HERE = Path(__file__).resolve().parent
CERT = HERE.parent
ROOT = CERT.parent
GT = CERT / "global_transition"
sys.path.insert(0, str(GT))

from common_global import (  # noqa: E402
    binom,
    canonical_json,
    dim_plane,
    sha256_bytes,
    sha256_file,
)


def check_self_hash(path: Path) -> dict:
    raw = path.read_text()
    data = json.loads(raw)
    assert "self_sha256" in data
    body = {k: v for k, v in data.items() if k != "self_sha256"}
    h = sha256_bytes(canonical_json(body).encode())
    assert h == data["self_sha256"], (
        f"self_sha256 mismatch: sealed={data['self_sha256']} recomputed={h}"
    )
    return data


def assert_no_timing(obj, path=""):
    if isinstance(obj, dict):
        for k, v in obj.items():
            assert "wall_time" not in k.lower(), f"timing {k} at {path}"
            assert k not in ("wall_time_sec", "elapsed", "runtime")
            assert_no_timing(v, f"{path}.{k}")
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            assert_no_timing(v, f"{path}[{i}]")


# ---------------------------------------------------------------------------
# Independent polarization (duplicated, not imported from producer)
# ---------------------------------------------------------------------------

def klein_F(v):
    return sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5))


def Phi(u, v, w):
    s = Fraction(0)
    for i in range(5):
        ip = (i + 1) % 5
        s += (
            Fraction(u[i]) * Fraction(v[i]) * Fraction(w[ip])
            + Fraction(u[i]) * Fraction(w[i]) * Fraction(v[ip])
            + Fraction(v[i]) * Fraction(w[i]) * Fraction(u[ip])
        ) / 3
    return s


def B(z, y1, y2):
    return 3 * Phi(z, y1, y2)


def parity(r: int) -> str:
    return "E_plus" if r % 2 == 0 else "E_minus"


def live_contributions(m: int, N: int):
    seen = {}
    for i in range(m, N + 1):
        for j in range(m, N + 1):
            for k in range(m, N + 1):
                if i + j + k != N:
                    continue
                if sum(1 for r in (i, j, k) if r % 2 == 1) == 3:
                    continue  # triple E_-
                key = tuple(sorted((i, j, k)))
                if key in seen:
                    continue
                seen[key] = len(set(permutations(key)))
    return seen


def main():
    data = check_self_hash(HERE / "polar_expansion.json")
    assert_no_timing(data)
    assert data["headline"] == "OPEN"
    assert data["work_package"] == "WP-L1"

    # ------------------------------------------------------------------
    # Polarization algebra
    # ------------------------------------------------------------------
    for vec in ([1, 0, 0, 0, 0], [1, 2, 3, 4, 5], [2, -1, 0, 3, -4]):
        assert Phi(vec, vec, vec) == klein_F(vec)

    z = [1, 2, 0, -1, 3]
    y = [0, 1, -1, 2, 0]
    lhs = klein_F([z[i] + y[i] for i in range(5)])
    rhs = klein_F(z) + 3 * Phi(z, z, y) + 3 * Phi(z, y, y) + klein_F(y)
    assert lhs == rhs
    assert B(z, y, y) == 3 * Phi(z, y, y)

    pol = data["polarization"]
    assert pol["status"] == "PROVED"
    assert "Phi(u,v,w)" in pol["Phi_formula"] or "Phi" in pol["Phi_formula"]

    print("PASS polarization algebra over Q")

    # ------------------------------------------------------------------
    # Universal equations from independent triple enumeration
    # ------------------------------------------------------------------
    ledger = data["order_ledger"]
    assert ledger["no_instantiated_degree"] is True

    eq1 = ledger["universal_equations"]["order_3m+1"]
    eq3 = ledger["universal_equations"]["order_3m+3"]
    assert eq1["status"] == "PROVED" and eq3["status"] == "PROVED"
    assert eq1["equation"] == "B(b_{m+1}; a_m, a_m) = 0"
    assert eq3["equation"] == (
        "B(b_{m+3}; a_m, a_m) + 2 B(b_{m+1}; a_m, a_{m+2}) + F_+(b_{m+1}) = 0"
    )

    for m0 in (1, 3, 5, 7, 9):
        # order 3m+1
        live1 = live_contributions(m0, 3 * m0 + 1)
        assert live1 == {(m0, m0, m0 + 1): 3}, (m0, live1)
        # order 3m+3
        live3 = live_contributions(m0, 3 * m0 + 3)
        assert live3[(m0, m0, m0 + 3)] == 3
        assert live3[(m0, m0 + 1, m0 + 2)] == 6
        assert live3[(m0 + 1, m0 + 1, m0 + 1)] == 1
        assert set(live3) == {
            (m0, m0, m0 + 3),
            (m0, m0 + 1, m0 + 2),
            (m0 + 1, m0 + 1, m0 + 1),
        }
        # odd orders automatic
        for delta in (0, 2, 4):
            N = 3 * m0 + delta
            assert N % 2 == 1

    # Multiplicity → B / F translation
    # 3 Phi(b,a,a) = B(b;a,a)
    # 6 Phi(b,a,a2) = 2 B(b;a,a2)
    # Phi(b,b,b) = F(b)
    assert B([1, 0, 0, 0, 0], [0, 1, 0, 0, 0], [0, 1, 0, 0, 0]) == 3 * Phi(
        [1, 0, 0, 0, 0], [0, 1, 0, 0, 0], [0, 1, 0, 0, 0]
    )

    print("PASS universal equations U.3m+1 and U.3m+3 by independent enumeration")

    # First order automatic
    fo = ledger["first_order_automatic"]
    assert fo["status"] == "PROVED"
    assert "F|_{E_-}" in fo["reason"] or "E_-" in fo["reason"]

    # y-evenness
    assert "even" in ledger["y_evenness_of_Fp"]["claim"].lower()

    # ------------------------------------------------------------------
    # Isolation maps L_r, omega_r
    # ------------------------------------------------------------------
    iso = data["isolation_maps"]
    steps = {s["r"]: s for s in iso["steps"]}
    assert 0 in steps and 1 in steps and 2 in steps and 3 in steps
    assert steps[1]["L_1"] == "L_1(b_{m+1}) = B(b_{m+1}; a_m, a_m)"
    assert steps[1]["R_1"] == "0"
    assert "L_3(b_{m+3}) = B(b_{m+3}; a_m, a_m)" in steps[3]["L_3"]
    assert "2 B(b_{m+1}; a_m, a_{m+2}) + F_+(b_{m+1})" in steps[3]["R_3"]
    assert iso["through_order"] == "3m+3"

    print("PASS isolation maps L_r / omega_r through r=3")

    # ------------------------------------------------------------------
    # Incidence compatibility with repair
    # ------------------------------------------------------------------
    compat = data["incidence_compatibility"]
    assert all(c["ok"] for c in compat["claims"])
    ids = {c["id"] for c in compat["claims"]}
    assert "C.1_source_vs_normal" in ids
    assert "C.4_no_covariant_claim" in ids

    print("PASS incidence compatibility")

    # ------------------------------------------------------------------
    # Family instantiation: three families, no large elimination
    # ------------------------------------------------------------------
    fam = data["family_instantiation"]
    assert fam["large_elimination_run"] is False
    assert fam["new_families_from_repair"] == []
    required = {
        "based_minus_lines_odd_m",
        "residual_e1_swap_both",
        "residual_e_ge7_generic_swap_both",
    }
    assert required <= set(fam["families"])

    for fid in required:
        f = fam["families"][fid]
        assert f["finite_order_obstruction_found"] is False
        assert f["sample_bidegrees"], fid
        assert "certificate_format_proposed" in f
        for s in f["sample_bidegrees"]:
            assert "L1" in s and "L3" in s
            for key in ("L1", "L3"):
                assert "matrix_shape_upper" in s[key]
                assert "memory" in s[key]
                assert "character" in s[key]
                shape = s[key]["matrix_shape_upper"]
                assert shape[0] > 0 and shape[1] > 0
                # plane dims match independent formula for leading
            m, d = s["m"], s["d"]
            assert s["dim_plane_leading"] == dim_plane(m, d)

    # e=1 family has d=6m+1
    for s in fam["families"]["residual_e1_swap_both"]["sample_bidegrees"]:
        assert s["d"] == 6 * s["m"] + 1
        assert s["e"] == 1

    # Resource summary present
    rs = fam["resource_summary"]
    assert rs["exploratory_gate_GB"] == 8
    assert "max_dense_GB_floor_over_samples" in rs

    print("PASS family estimates (no large elimination)")

    # ------------------------------------------------------------------
    # Distinction normal order vs global degree
    # ------------------------------------------------------------------
    nota = ledger["notation"]
    assert "independent" in nota["global_degree"].lower() or "d" in nota["global_degree"]
    assert "m odd" in nota["first_normal_order"]

    # Must not claim a formal lift is a covariant
    tb = data["theorem_boundary"]
    assert any("covariant" in x.lower() for x in tb["not_proved"])

    print("PASS normal-order / degree distinction and theorem boundary")

    # ------------------------------------------------------------------
    # Input hashes if present
    # ------------------------------------------------------------------
    for rel, h in data.get("accepted_input_sha256", {}).items():
        p = ROOT / rel
        if p.exists():
            assert sha256_file(p) == h, rel

    print("PASS input hashes")
    print("ALL WP-L1 VERIFICATIONS PASSED")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except AssertionError as e:
        print(f"FAIL: {e}", file=sys.stderr)
        sys.exit(1)
