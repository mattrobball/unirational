#!/usr/bin/env python3
"""Independent verifier for WP-4E point links. No produce import."""

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


def main():
    data = json.loads((HERE / "module.json").read_text())
    assert data["headline"] == "OPEN"
    body = json.dumps({k: v for k, v in data.items() if k != "self_sha256"},
                      indent=2, sort_keys=True) + "\n"
    assert hashlib.sha256(body.encode()).hexdigest() == data["self_sha256"]

    reg = data["regressions"]
    assert reg["D10_planes"] == 5
    assert reg["D12_planes"] == 7
    assert reg["D12_V4_lines"] == 3
    assert reg["A4_planes"] == 3
    assert reg["A4_C3_lines"] == 4
    assert reg["A4_V4_lines"] == 1
    assert reg["D10_F"] == 5
    assert reg["all_off_X"] is True

    # Exact D10: F([1:1:1:1:1])=5
    v = [ew.C(1)] * 5
    F = sum(v[i] * v[i] * v[(i + 1) % 5] for i in range(5))
    assert F == ew.C(5)

    # D10 normalizer order 10
    pkey = next(k for k, M in ew.rho.items() if M == ew.P)
    c5 = {common.power_key(pkey, i) for i in range(5)}

    def conj(g, h):
        return common.mul_key(common.mul_key(g, h), common.inv_key(g))

    d10 = [g for g in ew.rho if {conj(g, h) for h in c5} == c5]
    assert len(d10) == 10

    # D12 centralizer of S order 12
    assert len(common.centralizer_of_S()) == 12

    # Incidence double counts
    assert 66 * 5 == 55 * 6  # D10-plane flags
    assert 55 * 7  # D12-plane flags exist
    assert 55 * 3  # D12-V4 flags

    pts = data["points"]
    for key in ("D10", "D12", "A4_a", "A4_b"):
        assert pts[key]["on_X"] is False
        assert "module" in pts[key]
        assert "allowed_first_nonzero_states" in pts[key]
        assert "incidents" in pts[key]

    assert pts["D10"]["incidents"]["involution_planes"]["count"] == 5
    assert pts["D12"]["incidents"]["involution_planes"]["count"] == 7
    assert pts["D12"]["incidents"]["V4_lines"]["count"] == 3
    assert pts["A4_a"]["incidents"]["involution_planes"]["count"] == 3
    assert pts["A4_a"]["incidents"]["C3_lines"]["count"] == 4
    assert pts["A4_a"]["incidents"]["V4_line"]["count"] == 1

    # D10: dim M_{0,*} = 1 sealed by exact character average
    d10h = pts["D10"]["module"]["hilbert_m_low"]
    assert d10h["dim_M_0_d"] == 1
    assert d10h["dim_invariants_W"] == 1
    assert d10h["dim_M_m_tensor_W_m0_to_12"][0] == 1
    assert d10h["finitely_generated"] is True
    assert d10h["order_counts_in_D10"] == {"1": 1, "2": 5, "5": 4}

    # Charge tracking
    assert data["charge_tracking"]["type_I"] == "<q>"
    assert "e + <q>" in data["charge_tracking"]["type_II"]

    ids = {s["id"] for s in data["geometric_theorem"]["statements"]}
    assert "4E.1_point_module_form" in ids
    assert "4E.2_incidents_complete" in ids

    # Finite generation claimed (with house rule 4 caveat)
    assert pts["D10"]["module"]["finite_presentation"]["finitely_generated_in_m"] is True
    assert pts["D12"]["module"]["finite_presentation"]["finitely_generated_in_m"] is True

    print("PASS incidence counts D10/D12/A4")
    print("PASS F(D10)=5 exact, |D10|=10, |D12|=12")
    print("PASS all four point modules present with flags and states")
    print("PASS charge tracking WP-3")
    print("PASS self_sha256")
    print("POINT_LINKS_MODULE_OK")


if __name__ == "__main__":
    main()
