#!/usr/bin/env python3
"""Independent packet, incidence, scope, and seal verifier for Goal V2."""

from __future__ import annotations

from hashlib import sha256
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
EXIT = "V2-FIXED-FRAME-PLACE-NONTRANSFERABLE"


def find_problem() -> Path:
    for candidate in (HERE, *HERE.parents):
        if (candidate / "goals_2026-08-01/F_CONIC_ALGEBRA").is_dir():
            return candidate
    raise RuntimeError("cannot locate E-klein-cubic problem root")


PROBLEM = find_problem()


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def require_text(name: str, needles) -> None:
    text = (HERE / name).read_text()
    for needle in needles:
        assert needle in text, (name, needle)


def verify_seal() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["schema"] == "klein_goal_v2_seal_v1"
    assert seal["exit"] == EXIT
    assert "SEAL.json" not in seal["packet_files"]
    for relative, expected in seal["packet_files"].items():
        path = HERE / relative
        assert path.is_file(), path
        assert digest(path) == expected, (relative, digest(path), expected)
    for relative, expected in seal["upstream_files"].items():
        path = PROBLEM / relative
        assert path.is_file(), path
        assert digest(path) == expected, (relative, digest(path), expected)


def main() -> None:
    field = json.loads((HERE / "field_ramification.json").read_text())
    residual = json.loads((HERE / "compactification_residual_index.json").read_text())
    incidence = json.loads((HERE / "incidence_scope.json").read_text())
    assert field["schema"] == "klein_goal_v2_field_ramification_v1"
    assert residual["schema"] == "klein_goal_v2_compactification_residual_index_v1"
    assert field["exit"] == residual["exit"] == EXIT
    assert incidence["schema"] == "klein_goal_v2_incidence_scope_v1"

    assert field["infinity_divisor"]["selected_place_K_over_F"] == {
        "uniformizer": "s=1/u",
        "ramification_index": 1,
        "residue_degree": 1,
        "u_value": -1,
    }
    cramer = field["cramer_replay"]
    assert cramer["degrees_at_normalization_witness"] == {
        "delta": 5,
        "numerator_vcoord": 5,
        "numerator_t": 3,
    }
    assert cramer["values_on_K"] == {"u": -1, "vcoord": 0, "t": 2}
    scaled = field["scaled_affine_place_K_aff_over_K"]
    assert (scaled["degree"], scaled["ramification_index"], scaled["residue_degree"]) == (3, 3, 1)
    assert scaled["inertia"] == "mu3"
    assert scaled["normalized_weight_ray"] == {
        "f5": 2,
        "f8": -1,
        "f10": -2,
        "normalization": "w|K=3*nu",
    }
    genuine = field["genuine_splitting_torsor_place_L_over_K"]
    assert genuine["intersection_with_K_aff"] == "K"
    assert genuine["inertia"] == "not determined by the Cramer calculation"
    assert "point status is open" in genuine["dichotomy"]["trivial_inertia"]

    local = residual["universal_local_index"]
    assert math.gcd(*local["effective_cycle_degrees"]) == local["gcd"] == 1
    assert sum(
        degree * coefficient
        for degree, coefficient in zip(local["effective_cycle_degrees"], local["bezout_coefficients"])
    ) == 1
    rows = {row["model"]: row for row in residual["infinity_place_models"]}
    assert rows["selected fixed ternary cubic"]["residual_index"] == 3
    assert rows["proper closure of full auxiliary characteristic cubic"]["residual_index"] == 1
    assert rows["genuine Klein twist"]["residual_index"] == 1
    assert rows["twisted F14 common-line section"]["residual_index"] is None

    candidates = residual["candidate_boundaries"]
    assert [row["rank"] for row in candidates] == list(range(1, 7))
    assert candidates[0]["candidate"] == "Q5=(f5=0)"
    assert candidates[1]["candidate"] == "Q6=(f6=0)"
    assert "unknown for the genuine G-torsor" in candidates[3]["torsor_inertia"]
    assert "nontransferable" in candidates[3]["full_twist_status"]
    assert residual["candidate_search_verdict"] == (
        "no new genuine valuation pass; Q5 and Q6 remain the smallest known-unramified sites, while D still needs actual G-inertia and genuine-residue analysis"
    )

    require_text("STATUS.md", [EXIT, "nu(t)=2", "genuine headline remains open"])
    require_text(
        "VALUATION_TEMPLATE.md",
        ["criterion for properness", "smooth Hensel lifting", "I != 1"],
    )
    require_text(
        "OBJECT_AND_FIELD_MAP.md",
        ["C_fix(K) = empty", "P_aux(K) != empty", "no reverse arrow"],
    )
    require_text(
        "RAMIFICATION_AND_CENTRES.md",
        ["e(K_aff/K)=3", "Their intersection is `K`", "index `3`", "index `1`"],
    )
    require_text(
        "NONTRANSFER_THEOREM.md",
        [EXIT, "The genuine Klein-cubic headline remains open", "completely decides the transfer question"],
    )
    require_text(
        "BOUNDARY_CENSUS.md",
        ["Q5=(f5=0)", "Q6=(f6=0)", "no new genuine negative"],
    )
    require_text(
        "REQUIREMENTS.md",
        ["V2.0 proper valuation template", "V2.4 headline bridge", EXIT],
    )

    statements = incidence["accepted_point_statements"]
    assert statements == {
        "C_fix(K)": "empty",
        "P_aux(K)": "nonempty",
        "F14_T(K)": "undecided",
        "X_gen(K)": "undecided",
    }
    invalid = {(row["source"], row["target"]): row["status"] for row in incidence["missing_or_invalid_arrows"]}
    assert invalid[("C_fix(K)=empty", "F14_T(K)=empty")] == "undecided"
    assert invalid[("C_fix(K)=empty", "X_gen(K)=empty")] == "undecided"
    assert incidence["branch_comparison"]["verdict"] == "distinct valued ordered extensions over F"

    verify_seal()
    print("PASS V2 object scopes, incidence directions, and residual-index ledger")
    print("PASS V2 boundary census keeps bounded and open sites nonverdicts")
    print("PASS V2 packet and upstream seal")
    print(EXIT)


if __name__ == "__main__":
    main()
