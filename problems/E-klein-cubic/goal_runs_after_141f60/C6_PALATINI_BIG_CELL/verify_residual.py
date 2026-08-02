#!/usr/bin/env python3
"""Independent verification of C6 residual exact points.

Does not import produce.py or produce_residual.py.  Rebuilds forms and Plücker
identities from sealed C5 / Codex sources and residual JSON claims.
"""

from __future__ import annotations

import json
from pathlib import Path

from c6_core import (
    HERE,
    M_of,
    build_forms_mod,
    evaluate_quartic,
    interpolate_quartic,
    load_sealed_sources,
    omega,
    primitive_root_11,
    rank_mod,
)
from c6_exact import (
    M_of_exact,
    forms_at_exact,
    minors_all_zero,
    normalize_plucker,
    nullspace_exact,
    plucker_field,
    pluecker_hyperplanes_identically_zero,
    standard_plucker_quadrics,
    z_from_json,
    z_is_zero,
    z_mod,
)


def main() -> None:
    sources = load_sealed_sources()
    residual = json.loads((HERE / "residual_search.json").read_text())
    exact = json.loads((HERE / "exact_points.json").read_text())
    status = (HERE / "STATUS.md").read_text()
    point_md = (HERE / "POINT.md").read_text()

    assert residual["summary"]["K_proj_fano_point_found"] is False
    assert residual["summary"]["headline_bridge"] is False
    assert exact["definition"]["K_proj_fano_claimed"] is False
    assert exact["count"] >= 1
    assert exact["marker"] == "C6-EXACT-SPLIT-POINTS-PASS"
    assert "C6-POINT-HEADLINE-POSITIVE" not in status.splitlines()[0]
    assert status.splitlines()[0].strip() == "C6-DETERMINANTAL-BIRATIONAL-MODEL-PASS"
    assert "OPEN" in status
    assert "Not a headline claim" in point_md or "not a headline" in point_md.lower()
    assert not (HERE / "BRIDGE_FANO_POS.md").exists()

    linear_forms = sources["pluecker"]["equations"]["linear_forms"]
    witness_list = [(1, 2, 3, 4, 5), (2, 3, 5, 7, 11), (22, 21, 8, 1, 1)]

    for point in exact["points"]:
        u = point["u"]
        assert point["K_proj_fano_point_claimed"] is False
        # Exact minors at several x
        for witness in witness_list:
            forms = forms_at_exact(
                sources["q_linear"], sources["frame_vectors"], witness
            )
            assert minors_all_zero(forms, u), (u, witness)
        # Rebuild line at primary witness and compare Plücker hyperplane identity
        forms = forms_at_exact(
            sources["q_linear"], sources["frame_vectors"], (1, 2, 3, 4, 5)
        )
        basis, rank = nullspace_exact(M_of_exact(forms, u))
        assert rank == 4 and len(basis) == 2
        plucker = normalize_plucker(plucker_field(basis[0], basis[1]))
        assert pluecker_hyperplanes_identically_zero(linear_forms, plucker)
        assert all(z_is_zero(rel) for rel in standard_plucker_quadrics(plucker))
        # Stored plucker matches up to Q(zeta11)^* scale: check hyperplane id on stored
        stored = [z_from_json(coord) for coord in point["line"]["plucker_normalized_Qzeta11"]]
        assert pluecker_hyperplanes_identically_zero(linear_forms, stored)
        assert point["line"]["plucker_hyperplanes_identically_zero"] is True
        assert point["line"]["plucker_over_Q"] is False

        # Modular rank-4 and omega checks at a good prime
        prime = 331
        zeta = primitive_root_11(prime)
        mod_forms = build_forms_mod(
            sources["q_linear"],
            sources["frame_vectors"],
            (1, 2, 3, 4, 5),
            prime,
            zeta,
        )
        uu = [int(value) % prime for value in u]
        assert rank_mod(M_of(mod_forms, uu, prime), prime) == 4
        coeffs, _ = interpolate_quartic(mod_forms, prime, seed=1)
        assert evaluate_quartic(coeffs, uu, prime) == 0

    # Lane residual structure
    assert set(residual["summary"]["lanes_run"]) == {"A", "B", "C", "D"}
    assert residual["lane_a"]["singular_multiprime_candidates"] == []
    assert residual["lane_a"]["rank_le3_multiprime_candidates"] == []
    assert residual["lane_c"]["constant_Q_points"]["success"] is True

    # Multi-prime on_D consistency for listed height-1 u's
    primes = residual["same_x_fibre_primes"]
    point_x = tuple(residual["same_x_fibre_point"])
    for prime in primes:
        zeta = primitive_root_11(prime)
        forms = build_forms_mod(
            sources["q_linear"], sources["frame_vectors"], point_x, prime, zeta
        )
        coeffs, _ = interpolate_quartic(forms, prime, seed=prime)
        for point in exact["points"]:
            u = [int(value) % prime for value in point["u"]]
            assert evaluate_quartic(coeffs, u, prime) == 0

    print("C6_RESIDUAL_VERIFY_OK")
    print("C6_EXACT_SPLIT_POINTS_OK")
    print("C6_NO_KPROJ_FANO_POINT_CLAIMED")


if __name__ == "__main__":
    main()
