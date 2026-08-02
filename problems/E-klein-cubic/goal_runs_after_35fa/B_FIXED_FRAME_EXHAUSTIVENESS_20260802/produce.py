#!/usr/bin/env python3
"""Produce the machine ledger for the Goal B exhaustiveness refutation."""

from __future__ import annotations

import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]

SOURCES = {
    "goal": E_ROOT / "goals_after_35fa8f/GOAL_B_FIXED_FRAME_TO_GENERIC_BRIDGE.md",
    "c0_audit": E_ROOT / "certificates/fano_interface_c0/C0_AUDIT.md",
    "old_dictionary": E_ROOT / "goal_runs_after_35fa/B_FIXED_FRAME_BRIDGE/OBJECT_DICTIONARY.md",
    "old_gate": E_ROOT / "goal_runs_after_35fa/B_FIXED_FRAME_BRIDGE/REMAINING_GATE.md",
    "c5_status": E_ROOT / "goals_after_bd610a/C5_PROJECTOR_INCIDENCE/STATUS.md",
}


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def read(name: str) -> str:
    path = SOURCES[name]
    require(path.is_file(), f"missing source: {path}")
    return path.read_text()


def main() -> None:
    goal = read("goal")
    c0 = read("c0_audit")
    dictionary = read("old_dictionary")
    gate = read("old_gate")
    c5 = read("c5_status")

    require("B-BRIDGE-REFUTED" in goal, "authorized B exit drift")
    require("degree-14 Fano threefold of genus 8 and" in c0,
            "C0 genus-eight pin drift")
    require("Picard number one" in c0, "C0 Picard-rank pin drift")
    require("Gamma = PGU(h_struct) cap Stab" in dictionary,
            "five-plane gauge definition drift")
    require("selected fixed ternary frame" in dictionary.lower(),
            "fixed-frame source drift")
    require('"implication": "C(K)=empty  =>  F14_T(K)=empty"' in gate,
            "historical missing implication drift")
    require("projective threefolds of dimension three and degree fourteen" in c5,
            "C5 dimension/degree pin drift")
    require("geometrically integral" in c5, "C5 integrality pin drift")

    payload = {
        "schema": "klein-goal-b-exhaustiveness-refutation-v1",
        "exit": "B-BRIDGE-REFUTED",
        "headline": "OPEN",
        "field": "K_proj",
        "objects": {
            "fano": {
                "symbol": "Y=F14_T",
                "dimension": 3,
                "geometrically_integral": True,
                "degree": 14,
            },
            "fixed_frame_image": {
                "symbol": "Sigma",
                "source": "C_K^open, an open of a projective plane cubic",
                "dimension_upper_bound": 1,
            },
            "gauge": {
                "symbol": "Gamma=PGU(h_struct) cap Stab(H_T)",
                "effective_action_finite": True,
                "factorization": "Gamma_eff is a subgroup of Aut(F14_T,Kbar)",
                "finiteness_theorem": "Kuznetsov-Prokhorov-Shramov Theorem 1.1.2: smooth Picard-rank-one genus-8 Fano threefolds have finite automorphism group",
            },
        },
        "theorem": {
            "normalizable_locus": "Y_Kbar intersect union_{g in Gamma_eff} g(Sigma_Kbar)",
            "dimension_upper_bound": 1,
            "proper_in_fano": True,
            "universal_exhaustiveness": False,
            "counterexample_field": "K_proj(F14_T)",
            "counterexample_point": "generic point eta_F14_T",
        },
        "scope": {
            "fixed_frame_normalization_bridge": "REFUTED",
            "bare_single_field_implication": "UNDECIDED",
            "F14_T_K_proj_points": "UNDECIDED",
            "X_gen_K_proj_points": "UNDECIDED",
            "klein_headline": "OPEN",
            "successor_front": "C/C5 direct common-line point or direct emptiness",
        },
        "source_paths": {name: str(path.relative_to(E_ROOT)) for name, path in SOURCES.items()},
    }

    (HERE / "bridge_refutation.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("B-EXHAUSTIVENESS-PAYLOAD-PRODUCED")


if __name__ == "__main__":
    main()
