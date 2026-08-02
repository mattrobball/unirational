#!/usr/bin/env python3
"""Independent verifier for Q3 monodromy + quartic-resolvent model.

Does not import produce.py.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path

from q3_core import (
    A4_QUOTIENT_ORDERS,
    PAIRINGS,
    PSL211_QUOTIENT_ORDERS,
    S4_QUOTIENT_ORDERS,
    a4_group,
    act_on_pairing,
    c3_orbit_partitions,
    common_quotient_orders,
    pairing_homomorphism,
    psl2_11_order,
    resolvent_image_group,
    s3_orbit_partitions,
    s3_orbit_type_exists_fixed_point_free,
    s4_group,
    sha256_file,
)

HERE = Path(__file__).resolve().parent


def load(name: str):
    return json.loads((HERE / name).read_text())


def main() -> int:
    model = load("quartic_resolvent.json")
    mon = load("monodromy.json")
    manifest = load("INPUT_MANIFEST.json")

    # --- inputs present ---
    assert manifest["marker"] == "Q3_INPUTS_HASHED", manifest.get("missing")
    assert not manifest["missing"]
    for rel, meta in manifest["binding_inputs"].items():
        path = HERE.parents[1] / rel
        assert path.is_file(), rel
        assert sha256_file(path) == meta["sha256"], rel

    # --- group model ---
    a4 = a4_group()
    s4 = s4_group()
    assert len(a4) == 12 and len(s4) == 24
    assert len(resolvent_image_group(a4)) == 3
    assert len(resolvent_image_group(s4)) == 6
    id3 = (0, 1, 2)
    a4_ker = {g for g, img in pairing_homomorphism(a4).items() if img == id3}
    s4_ker = {g for g, img in pairing_homomorphism(s4).items() if img == id3}
    assert len(a4_ker) == 4 and len(s4_ker) == 4

    assert model["A4"]["pairing_image_order"] == 3
    assert model["S4"]["pairing_image_order"] == 6
    assert model["A4"]["cubic_resolvent_galois"] == "C3"
    assert model["S4"]["cubic_resolvent_galois"] == "S3"
    assert model["marker"] == "Q3-QUARTIC-RESOLVENT-MODEL-PASS"

    # pairing action consistency
    for g in list(s4)[:10]:
        for i in range(3):
            j = act_on_pairing(g, i)
            assert 0 <= j < 3

    # linear disjointness
    assert psl2_11_order() == 660
    assert common_quotient_orders(A4_QUOTIENT_ORDERS, PSL211_QUOTIENT_ORDERS) == {1}
    assert common_quotient_orders(S4_QUOTIENT_ORDERS, PSL211_QUOTIENT_ORDERS) == {1}
    assert model["primitive_full_span_quartic"]["common_quotients_with_PSL2_11"]["A4"] == [1]
    assert model["primitive_full_span_quartic"]["common_quotients_with_PSL2_11"]["S4"] == [1]

    # --- C3 / S3 orbit arithmetic ---
    c3 = c3_orbit_partitions(8)
    assert all(p["forces_fixed_point"] for p in c3)
    assert min(p["fixed_points"] for p in c3) == 2
    assert {p["fixed_points"] for p in c3} == {2, 5, 8}
    assert s3_orbit_type_exists_fixed_point_free(8)

    a4m = mon["pullback_to_primitive_quartic_strata"]["A4"]
    s4m = mon["pullback_to_primitive_quartic_strata"]["S4"]
    assert a4m["c3_always_has_fixed_point_on_reduced_8_set"] is True
    assert a4m["min_fixed_points_if_c3_action"] == 2
    assert s4m["fixed_point_free_s3_action_exists"] is True

    # residual honesty: installed hypotheses still false
    for key, val in a4m["hypotheses_proved_for_installed_schur_quartic"].items():
        assert val is False, key
    assert mon["decisive_outcomes_checked"]["one_rational_component"] is False
    assert mon["forbidden_inference"].startswith("virtual count eight")
    assert mon["marker_achieved"] is True
    assert mon["marker_candidate"] == "Q3-SCHUR-MONODROMY-PASS"

    # generic degree eight
    assert mon["generic_geometric_monodromy"]["after_three_points_split"].startswith(
        "still one integral"
    )
    assert model["degree_eight_incidence"]["evaluation_map_to_X3_generic_degree"] == 8
    assert model["degree_eight_incidence"]["virtual_count_eight_implies_point"] is False

    # pairings match core
    assert len(PAIRINGS) == 3
    assert model["pairings"]["labels"] == ["01|23", "02|13", "03|12"]

    # s3 partitions include 2+6
    s3p = s3_orbit_partitions(8)
    assert any(
        p["fixed_points"] == 0
        and p["two_orbits"] == 1
        and p["six_orbits"] == 1
        and p["three_orbits"] == 0
        for p in s3p
    )

    print("Q3_MONODROMY_VERIFY_OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
