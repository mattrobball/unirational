#!/usr/bin/env python3
"""Independent verification of the C6 point-search ledger.

Does not import produce.py.  Confirms lanes were recorded, modular seeds
satisfy the five-form equations, residual exact points (if present) are not
over-claimed as K_proj Fano / headline points, and STATUS honesty.
"""

from __future__ import annotations

import json
from pathlib import Path

from c6_core import (
    HERE,
    M_of,
    build_forms_mod,
    evaluate_quartic,
    load_sealed_sources,
    omega,
    primitive_root_11,
    rank_mod,
)


def main() -> None:
    sources = load_sealed_sources()
    search = json.loads((HERE / "point_search.json").read_text())
    status = (HERE / "STATUS.md").read_text()
    quartic = json.loads((HERE / "quartic.json").read_text())

    assert search["summary"]["K_proj_point_found"] is False
    assert search["summary"]["headline_bridge"] is False
    assert set(search["summary"]["lanes_run"]) == {"A", "B", "C", "D"}
    assert search["lane_c"]["reconstruction"]["success"] is False
    assert "C6-POINT-HEADLINE-POSITIVE" not in status.splitlines()[0]
    assert status.splitlines()[0].strip() == "C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS"
    assert not (HERE / "BRIDGE_FANO_POS.md").exists()

    # Re-check every recorded modular seed
    coeff_by_prime = {
        int(item["prime"]): item["coefficients"]
        for item in quartic["modular_specializations"]
    }
    for entry in search["lane_c"]["seeds"]:
        seed = entry["seed"]
        if seed is None:
            continue
        prime = int(entry["prime"])
        point = tuple(entry["point_x"])
        forms = build_forms_mod(
            sources["q_linear"],
            sources["frame_vectors"],
            point,
            prime,
            primitive_root_11(prime),
        )
        u, v = seed["u"], seed["v"]
        assert all(omega(form, u, v, prime) == 0 for form in forms)
        assert rank_mod(M_of(forms, u, prime), prime) <= 4
        assert evaluate_quartic(coeff_by_prime[prime], u, prime) == 0

    # Lane A/B/D present for at least the three selected primes
    for prime in ("23", "331", "419"):
        assert prime in search["lane_a"]
        assert prime in search["lane_b"]
        assert prime in search["lane_d"]
        assert search["lane_d"][prime]["method"].startswith("linear")

    # STATUS residual honesty
    assert "OPEN" in status
    assert "C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS" in status.splitlines()[0]

    # If residual exact points exist, they must not claim K_proj Fano / headline
    residual_path = HERE / "residual_search.json"
    exact_path = HERE / "exact_points.json"
    if residual_path.exists():
        residual = json.loads(residual_path.read_text())
        assert residual["summary"]["K_proj_fano_point_found"] is False
        assert residual["summary"]["headline_bridge"] is False
        assert set(residual["summary"]["lanes_run"]) == {"A", "B", "C", "D"}
    if exact_path.exists():
        exact = json.loads(exact_path.read_text())
        assert exact["definition"]["K_proj_fano_claimed"] is False
        assert exact["count"] == len(exact["points"])
        for point in exact["points"]:
            assert point.get("K_proj_fano_point_claimed") is False
        point_md = HERE / "POINT.md"
        assert point_md.exists()
        text = point_md.read_text().lower()
        assert "headline" in text
        assert "not" in text

    print("C6_POINT_VERIFY_OK")
    print("C6_NO_KPROJ_POINT_CLAIMED")


if __name__ == "__main__":
    main()
