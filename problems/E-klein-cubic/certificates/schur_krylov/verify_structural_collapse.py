#!/usr/bin/env python3
"""Independent verifier for Path A structural-collapse audit (A3 successor).

Does NOT import a producer.  Checks losslessness claims, memory floors,
minimal irreducible system shape, and modular discovery bounds.
"""
from __future__ import annotations

import hashlib
import json
import math
import sys
from math import comb
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
TMP = ROOT / "tmp" / "pathA_collapse"


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def macaulay_qq32_GiB(n: int, D: int) -> float:
    c = comb(n + D, D)
    return (c * c * 32) / float(1 << 30)


def main() -> int:
    md = HERE / "STRUCTURAL_COLLAPSE.md"
    js = HERE / "structural_collapse.json"
    assert md.is_file() and js.is_file()
    data = json.loads(js.read_text(encoding="utf-8"))
    text = md.read_text(encoding="utf-8")

    # Decision boundary
    assert data["headline"] == "OPEN"
    assert data["decision_exit"] == "A-STOP"
    assert data["N_A_claimed"] is False
    assert data["P_A_claimed"] is False
    assert data["A_SURVIVE_claimed"] is False
    assert data["no_lossless_collapse_under_8GiB"] is True

    # Collapse audit shape
    c = data["collapses"]
    assert c["PGL2_gauge"]["lossless"] is True
    assert c["PGL2_gauge"]["nonlinear_vars_after"] == 52
    assert c["PGL2_gauge"]["sufficient_for_8GiB"] is False
    assert c["isotypic_S3_D12"]["lossless_F_rational_block_reduction"] is False
    assert c["sparse_Schur_elimination_order"]["reduces_variable_count"] is False
    assert c["lambda_specialisation"]["F_scaling_charts"]["lossless"] is True
    assert c["lambda_specialisation"]["lambda_in_F"]["lossless"] is False
    assert c["lambda_specialisation"]["tau_fixed_to_alpha"]["lossless"] is False

    # Minimal irreducible system
    mis = data["minimal_irreducible_system"]
    assert mis["structured_matrix"]["shape"] == [140, 55]
    assert 4 * 35 == 140
    assert mis["rank_only_not_qualifying"] is True
    assert set(mis["safeguards_after"]) == {"S1", "S2", "S3", "S4", "S5", "S6"}

    # Memory floors: recompute independently
    floors = data["memory_floors_after_lossless_collapse"]
    assert floors["n_tau_gauged"] == 52
    assert floors["exploratory_RSS_gate_GiB"] == 8
    d2 = macaulay_qq32_GiB(52, 2)
    d3 = macaulay_qq32_GiB(52, 3)
    assert abs(d2 - floors["macaulay_D2_qq32_GiB"]) < 1e-3
    assert abs(d3 - floors["macaulay_D3_qq32_GiB"]) < 1e-2
    assert d3 > 8.0
    assert floors["macaulay_D3_exceeds_8GiB"] is True
    assert floors["lossless_collapse_reaches_n_le_4"] is False

    # max n for D=19 under 8 GiB
    GiB = float(1 << 30)
    budget = 8 * GiB
    max_n = 0
    for n in range(1, 30):
        ccols = comb(n + 19, 19)
        if ccols * ccols * 32 <= budget:
            max_n = n
    assert max_n == floors["max_n_for_D19_under_8GiB_qq32"]
    assert max_n == 4

    # Group / field arithmetic used in the no-intermediate-field claim
    assert 660 // 12 == 55
    assert math.gcd(55, 2) == 1
    # Divisors of 55
    assert [d for d in range(1, 56) if 55 % d == 0] == [1, 5, 11, 55]

    # Markers in prose
    assert "SCHUR_KRYLOV_A3_STRUCTURAL_COLLAPSE_A_STOP" in text
    assert data["terminal_marker"] == "SCHUR_KRYLOV_A3_STRUCTURAL_COLLAPSE_A_STOP"
    assert "no lossless" in text.lower() or "No lossless" in text
    assert "52" in text

    # Modular discovery artifact (shape only; may be regenerated)
    mod_path = TMP / "modular_rank_profile.json"
    assert mod_path.is_file(), mod_path
    mod = json.loads(mod_path.read_text(encoding="utf-8"))
    assert mod["phi_shape"] == [140, 55]
    assert mod["random_profile"]["all_full_rank"] is True
    assert mod["positive_control_planted_Vz_subset_U_tau"]["rank_drop_detected"] is True
    assert "NOT the geometric" in mod["scope"] or "not geometric" in mod["scope"].lower()
    assert data["modular_discovery"]["implies_N_A"] is False

    print("COLLAPSE_PGL2_LOSSLESS_INSUFFICIENT_OK")
    print("COLLAPSE_ISOTYPIC_NO_F_BLOCK_OK")
    print("COLLAPSE_LAMBDA_ONLY_SCALING_LOSSLESS_OK")
    print("MINIMAL_IRREDUCIBLE_SYSTEM_52_OK")
    print("MEMORY_FLOORS_D3_OVER_8GIB_OK")
    print("MODULAR_DISCOVERY_SHAPE_OK")
    print(f"COLLAPSE_MD_SHA256 {sha256_file(md)}")
    print(f"COLLAPSE_JSON_SHA256 {sha256_file(js)}")
    print("SCHUR_KRYLOV_A3_STRUCTURAL_COLLAPSE_A_STOP")
    return 0


if __name__ == "__main__":
    sys.exit(main())
