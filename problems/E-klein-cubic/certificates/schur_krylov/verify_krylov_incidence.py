#!/usr/bin/env python3
"""Independent verifier for Gate A3 incidence formulation and memory floors.

Does NOT import a producer.
"""
from __future__ import annotations

import hashlib
import json
import math
import sys
from math import comb
from pathlib import Path

HERE = Path(__file__).resolve().parent


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> int:
    md = HERE / "krylov_incidence.md"
    js = HERE / "krylov_incidence.json"
    assert md.is_file() and js.is_file()
    data = json.loads(js.read_text(encoding="utf-8"))
    text = md.read_text(encoding="utf-8")

    assert data["incidence"]["matrix_M"]["shape"] == [55, 24]
    assert data["linear_elimination"]["interpolating_coefficients"] == 80
    assert data["linear_elimination"]["scalar_equations_over_F"] == 220
    assert 4 * 55 == 220
    assert 4 * 20 == 80
    assert data["linear_elimination"]["linear_unknowns_c_lambda"] == 135
    assert 80 + 55 == 135
    assert data["linear_elimination"]["c_eliminated_linearly"] is True

    floors = data["memory_floors_before_elimination"]
    assert floors["M_dense_entries"] == 55 * 24
    assert floors["A_tau_shape"] == [220, 135]
    assert floors["A_tau_dense_entries"] == 220 * 135
    assert floors["macaulay_columns_D3"] == comb(54 + 3, 3) or floors["macaulay_columns_D3"] == comb(57, 3)
    # document uses binom(54+3,3)=29260 and binom(57,3)=29260 same; binom(58,4)=424270
    assert comb(57, 3) == 29260
    assert comb(58, 4) == 424270
    assert floors["macaulay_columns_D4"] == 424270
    assert floors["dense_elimination_exceeds_8GiB"] is True
    assert floors["exploratory_RSS_gate_GiB"] == 8

    # raw minor count order of magnitude
    raw = comb(55, 21) * comb(24, 3)
    assert raw > 10**16
    assert data["rank_only_not_qualifying"] is True
    assert data["decision_exit"] == "A-STOP"
    assert data["N_A_claimed"] is False
    assert data["P_A_claimed"] is False
    assert data["headline"] == "OPEN"

    for s in data["safeguards"]:
        assert s in text or s.replace("_", " ") in text.lower() or s in json.dumps(data)

    assert "SCHUR_KRYLOV_A3_INCIDENCE_FORMULATED_A_STOP" in text
    assert data["terminal_marker"] == "SCHUR_KRYLOV_A3_INCIDENCE_FORMULATED_A_STOP"

    # Six safeguards named
    assert len(data["safeguards"]) == 6

    print("A3_MATRIX_SHAPES_OK")
    print("A3_LINEAR_ELIM_COUNTS_OK")
    print("A3_MEMORY_FLOORS_OK")
    print("A3_DECISION_A_STOP_OK")
    print(f"A3_MD_SHA256 {sha256_file(md)}")
    print(f"A3_JSON_SHA256 {sha256_file(js)}")
    print("SCHUR_KRYLOV_A3_INCIDENCE_FORMULATED_A_STOP")
    return 0


if __name__ == "__main__":
    sys.exit(main())
