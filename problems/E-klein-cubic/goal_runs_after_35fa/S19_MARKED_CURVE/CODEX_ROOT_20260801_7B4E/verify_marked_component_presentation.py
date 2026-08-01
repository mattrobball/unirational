#!/usr/bin/env python3
"""Independent structural replay of marked_component_presentation.json."""

from __future__ import annotations

import hashlib
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
PAYLOAD = HERE / "marked_component_presentation.json"
UNIVERSAL = HERE / "universal_marked_family.json"
UPSTREAM = {
    "marked_hilbert": PROBLEM / "certificates/schur_degree19/marked_hilbert.json",
    "rao_resolutions": PROBLEM / "certificates/schur_degree19/rao_resolutions.json",
    "quintic_carriers": PROBLEM / "certificates/schur_degree19/quintic_carriers.json",
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def monomials(variables: int, degree: int):
    answer = []

    def recurse(prefix, left, total):
        if left == 1:
            answer.append(prefix + [total])
            return
        for first in range(total, -1, -1):
            recurse(prefix + [first], left - 1, total - first)

    recurse([], variables, degree)
    return answer


def h0_p1(degree: int) -> int:
    return max(degree + 1, 0)


def h1_p1(degree: int) -> int:
    return max(-degree - 1, 0)


def main():
    payload = json.loads(PAYLOAD.read_text())
    universal = json.loads(UNIVERSAL.read_text())
    upstream = {name: json.loads(path.read_text()) for name, path in UPSTREAM.items()}

    assert payload["schema"] == "s19-marked-component-presentation-v1"
    assert payload["terminal_marker"] == "S19_MARKED_COMPONENTS_FINITE_PRESENTATION_EXACT"
    assert payload["source_sha256"]["universal_marked_family.json"] == digest(UNIVERSAL)
    for path in UPSTREAM.values():
        key = str(path.relative_to(PROBLEM))
        assert payload["source_sha256"][key] == digest(path)
    assert universal["terminal_marker"] == "S19_CANONICAL_MARKED_55_FAMILY_EXACT"
    assert universal["generic_freeness"]["hilbert_function_d0_to_d6"] == [1, 4, 10, 19, 31, 45, 55]
    print("PASS hash-bound canonical family and three audited frontier packets")

    normalized = payload["normalized_map_atlas"]
    assert normalized["coefficient_variables"] == 4 * (19 + 1) == 80
    assert normalized["remaining_source_point_factors"] == 55 - 3 == 52
    incidence = payload["incidence_ideal"]
    assert incidence["equation_count"] == 55 * 4 == 220
    # A-coefficients + 52 P1 dimensions + 54 lambdas + four h dimensions.
    assert incidence["ambient_dimension_before_equations"] == 80 + 52 + 54 + 4 == 190
    assert incidence["expected_relative_dimension"] == 190 - 220 == -30
    assert incidence["expected_fixed_h_dimension"] == -34
    print("PASS exact three-mark/PGL2 slice and 220-equation incidence ledger")

    substitution = payload["degree_five_substitution"]
    expected_columns = monomials(4, 5)
    assert len(expected_columns) == math.comb(8, 3) == 56
    assert substitution["columns"] == expected_columns
    assert substitution["column_count"] == 56
    assert substitution["row_count"] == 5 * 19 + 1 == 96
    assert len(substitution["rows"]) == 96
    assert substitution["entry_degree_in_a"] == 5
    compressed = payload["degree_five_compressed_point_ideal"]
    assert compressed["shape"] == [96, 11]
    assert compressed["epsilon_0"] == "rank 11"
    assert "rank 10" in compressed["epsilon_1"]
    print("PASS 96-by-56 full and 96-by-11 compressed quintic substitution specifications")

    rao = upstream["rao_resolutions"]["branches"]
    assert payload["branches"]["epsilon_0"]["rao_d0_to_5"] == rao["epsilon_0"]["rao_d0_to_5"]
    assert payload["branches"]["epsilon_1"]["rao_d0_to_5"] == rao["epsilon_1"]["rao_d0_to_5"]
    assert payload["branches"]["epsilon_0"]["nonemptiness"] == "UNDECIDED"
    assert payload["branches"]["epsilon_1"]["nonemptiness"] == "UNDECIDED"
    print("PASS epsilon=0 rank-56 and epsilon=1 rank-55 Rao branch boundary")

    deformation = payload["vertical_deformation_at_any_geometric_point"]
    possible_splittings = []
    for b1 in range(2, 19):
        b2 = 36 - b1
        if b1 > b2:
            continue
        degrees = [b1 - 36, b2 - 36]
        h0 = sum(h0_p1(degree) for degree in degrees)
        h1 = sum(h1_p1(degree) for degree in degrees)
        assert h0 == 0
        assert h1 == 34
        possible_splittings.append((b1, b2))
    assert possible_splittings[0] == (2, 34)
    assert possible_splittings[-1] == (18, 18)
    assert deformation["tangent_dimension_h0"] == 0
    assert deformation["obstruction_space_dimension_h1"] == 34
    assert deformation["virtual_dimensions"] == {"fixed_h": -34, "relative_over_h": -30}
    print("PASS every allowed normal splitting gives vertical (h0,h1)=(0,34)")

    carrier = payload["carrier_picard_boundary"]
    assert len(payload["branches"]["epsilon_1"]["carrier_variables"]) == math.comb(5, 2) == 10
    assert carrier["smooth_carrier_adjunction"]["C_dot_H"] == 19
    # On a smooth quintic K=H, so -2=C.(C+K)=C^2+19.
    assert carrier["smooth_carrier_adjunction"]["C_square"] == -2 - 19 == -21
    old_carrier = upstream["quintic_carriers"]
    assert old_carrier["picard"]["rank_one_excludes_degree_19"] is True
    assert old_carrier["picard"]["rank_one_proved_for_all_q"] is False
    assert carrier["actual_special_carrier_picard"] == "UNDECIDED"
    print("PASS unique-carrier, adjunction, and strict Picard boundary")

    assert all("UNDECIDED" in payload["branches"][name]["nonemptiness"] for name in ("epsilon_0", "epsilon_1"))
    assert "no point of either marked component is constructed" in payload["strict_nonclaims"]
    print("S19_MARKED_COMPONENT_PRESENTATION_INDEPENDENT_REPLAY_OK")


if __name__ == "__main__":
    main()
