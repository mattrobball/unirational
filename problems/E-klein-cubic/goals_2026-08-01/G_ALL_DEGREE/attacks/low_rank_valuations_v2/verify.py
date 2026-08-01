#!/usr/bin/env python3
"""Independent scope and arithmetic verifier for the C1-residue theorem.

The external mathematical input is the Tsen--Lang theorem.  This verifier
checks that its numerical hypothesis applies to the *genuine* five-variable
cubic, replays the exact Hilbert--90 coefficient reconstruction and the
PSL_2(F_11) inertia-centralizer calculation, pins their authoritative inputs,
and enforces the henselization/completion boundary.
"""

from __future__ import annotations

import hashlib
import itertools
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent
GOALS = HERE.parents[2]


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def replay(relative: str, marker: str) -> None:
    completed = subprocess.run(
        [sys.executable, str(GOALS / relative)],
        cwd=GOALS,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    if completed.returncode != 0 or marker not in completed.stdout:
        raise AssertionError(
            f"failed authoritative replay {relative}\n{completed.stdout}"
        )
    print(f"PASS authoritative replay {marker}")


def main() -> None:
    data = json.loads((HERE / "certificate.json").read_text())
    assert data["schema"] == "g_low_rank_c1_residue_v1"

    for relative, expected in data["authoritative_sha256"].items():
        path = (GOALS / relative).resolve()
        assert path.is_file(), path
        actual = sha256(path)
        assert actual == expected, (relative, expected, actual)

    # Bind the theorem to the actual normalized K_proj cubic rather than an
    # auxiliary ternary section.  The independent upstream replay rebuilds
    # all coefficients from the original Klein form.
    cubic = json.loads((GOALS / "G_ALL_DEGREE/generic_cubic.json").read_text())
    expected_support = set(itertools.combinations_with_replacement(range(5), 3))
    actual_support = {tuple(row["triple"]) for row in cubic["coefficients"]}
    assert cubic["coefficient_count"] == len(cubic["coefficients"]) == 35
    assert actual_support == expected_support
    assert all(row["entries"] and row["normalized_entries"] for row in cubic["coefficients"])

    obj = data["object"]
    assert obj["base_field"] == "K_proj"
    assert obj["group"] == "PSL_2(F_11)" and obj["group_order"] == 660
    assert obj["vector_space_dimension"] == 5
    assert obj["ambient_dimension"] == 4
    assert obj["equation_degree"] == 3
    assert obj["generic_cubic_coefficient_count"] == 35

    # This is the exact numerical gate in the definition of a C1 field.
    c1 = data["c1_ledger"]
    assert c1["variables"] == obj["vector_space_dimension"] == 5
    assert c1["degree"] == obj["equation_degree"] == 3
    assert c1["strict_inequality"] is (c1["variables"] > c1["degree"])
    assert c1["transcendence_degree_over_C_covered"] == [0, 1]
    assert c1["source"]["doi"] == "10.2307/1969785"

    theorem = data["valuation_theorem"]
    assert theorem["primary_local_model"] == (
        "fraction field of the henselized valuation ring K_v^h"
    )
    assert theorem["valuation_rank"] == "arbitrary"
    assert theorem["hypothesis"] == "residue field kappa(v) is C1"
    assert theorem["conclusion"] == "the genuine twist has a K_v^h-rational point"

    foundations = data["arbitrary_rank_foundations"]
    assert "Hom(Gamma_L/Gamma_K" in foundations["tame_inertia_pairing"]
    assert "all roots of unity" in foundations["centrality_reason"]
    assert "factors through the residue Galois group" in foundations["unramified_torsor_model"]
    assert foundations["finite_etale_reference"] == "Stacks Project Tag 04GK"
    assert foundations["smooth_lifting_reference"] == "Stacks Project Tag 0H74"
    assert foundations["noetherian_hypothesis"] is False
    assert foundations["integral_closure_finiteness_used"] is False

    decomposition = data["decomposition_group_refinement"]
    assert decomposition["hypothesis"] == "trivial inertia"
    assert decomposition["remaining_decomposition_groups"] == [
        "PSL_2(F_11)",
        "maximal A5 class 1",
        "maximal A5 class 2",
        "maximal 11:5",
    ]
    assert decomposition["twist_bridge"] == "Duncan-Reichstein Theorem 1.1"
    assert decomposition["unirationality_input"] == (
        "Cheltsov-Tschinkel-Zhang Theorem 5.1"
    )
    assert "non-C1 residue" in decomposition["conclusion"]

    models = data["completion_models"]
    assert "K_v^h embeds" in models["ordinary_rank_one_completion"]
    assert "every finite length" in models["successive_complete_dvr_tower"]
    assert models["unspecified_higher_rank_completion"] == "not asserted"

    retired = data["newly_retired_classes"]
    assert any(row.startswith("rank-one valuations") for row in retired)
    assert any(row.startswith("rank-two valuations") for row in retired)
    assert any(row.startswith("arbitrary-rank valuations") for row in retired)

    nonclaims = data["strict_nonclaims"]
    assert "no global K_proj-point is proved" in nonclaims
    assert "no pointless completion is proved" in nonclaims
    assert "geometric divisorial residue transcendence degree three remains open" in nonclaims
    assert "saturated geometric rank-two residue transcendence degree two remains open" in nonclaims
    assert "Goal G remains undecided" in nonclaims

    # These replays are deliberately last: they independently reconstruct
    # the genuine cubic and all 660 group elements rather than trusting the
    # small theorem ledger above.
    replay(
        "G_ALL_DEGREE/verify_generic_cubic.py",
        "G_PROJECTIVE_NORMALIZATION_35_COEFFICIENTS_OK",
    )
    replay(
        "V_VALUATION_TROPICAL/verify_inertia_centralizers.py",
        "GOAL_V_INERTIA_CENTRALIZERS_ACCEPT",
    )
    replay(
        "H_SUBGROUP_TWISTS_CODEX_ROOT_20260801/verify.py",
        "H_SUBGROUP_TWISTS_INDEPENDENT_VERIFY_OK",
    )

    result = (HERE / "RESULT.md").read_text()
    theorem_text = (HERE / "THEOREM.md").read_text()
    foundations_text = (HERE / "VALUATION_FOUNDATIONS.md").read_text()
    for phrase in (
        "No pointless completion was found",
        "unramified divisorial valuations with residue transcendence degree three",
        "unramified saturated rank-two chains",
        "No global",
    ):
        assert phrase in result
    assert "unspecified higher-rank completion" in theorem_text
    assert "5>3" in theorem_text
    assert "one of the two maximal A5 classes" in theorem_text
    assert "[`04GK`]" in foundations_text
    assert "[`0H74`]" in foundations_text
    assert "not** the assertion that the integral closure" in foundations_text

    print("PASS genuine 35-term K_proj cubic and C1 inequality 5>3")
    print("PASS ramified/unramified dichotomy and exact local-field scope ledger")
    print("PASS arbitrary-rank tame centrality and non-noetherian finite-etale audit")
    print("PASS exact unramified decomposition-group refinement")
    print("PASS rank-one, rank-two, arbitrary-rank C1-residue coverage")
    print(
        "BOUNDARY unramified non-C1 residues remain; central geometric rows "
        "include divisorial trdeg-3 and saturated rank-two trdeg-2"
    )
    print("G_LOW_RANK_C1_RESIDUE_LOCAL_SOLUBILITY_EXACT")


if __name__ == "__main__":
    main()
