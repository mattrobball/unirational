#!/usr/bin/env python3
"""Write SEAL.json after all human-readable and replay sources are frozen."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
OUTPUT = HERE / "SEAL.json"
ARTIFACTS = sorted(
    path.name for path in HERE.iterdir()
    if path.is_file() and path.name != "SEAL.json" and not path.name.startswith(".")
)
CONSUMED = {
    "certificates/exact_weil_check.py": PROBLEM / "certificates/exact_weil_check.py",
    "goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md": PROBLEM / "goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md",
    "tmp/schur_degree19_structural_design_audit/certificate.json": PROBLEM / "tmp/schur_degree19_structural_design_audit/certificate.json",
    "tmp/schur_degree19_nonacm_attack_audit/certificate.json": PROBLEM / "tmp/schur_degree19_nonacm_attack_audit/certificate.json",
}


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    assert (HERE / "STATUS.md").read_text().splitlines()[0] == "S19-UNDECIDED"
    payload = {
        "schema": "s19-marked-curve-continuation-seal-v1",
        "date": "2026-08-01",
        "packet": "goal_runs_after_35fa/S19_MARKED_CURVE/CODEX_ROOT_20260801_7B4E",
        "repository_commit_consumed": "37d61c19a108781cf74af837e24810a9f7f7c3be",
        "pinned_state": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "decision_exit": "S19-UNDECIDED",
        "decision_meaning": "the canonical family and exact finite component search are certified, but no curve and no branch exclusion is proved",
        "artifact_sha256": {name: digest(HERE / name) for name in ARTIFACTS},
        "consumed_source_sha256": {name: digest(path) for name, path in CONSUMED.items()},
        "proved": [
            "canonical equivariant universal 55-point family on an explicit nonempty dense open",
            "generic Hilbert function 1,4,10,19,31,45,55,55,... and I_Z(5)=f3*S2 direct-sum <f5>",
            "exact saturated 220 by 135 marked-map presentation with all admissibility gates",
            "exact normalized three-mark atlas and universal image ideal for the qualified smooth locus",
            "exact 96 by 11 rank tests for epsilon 0 and epsilon 1",
            "smooth fixed-fibre marked tangent dimension 0 and obstruction dimension 34",
            "smooth epsilon-1 carrier lattice Gram [[5,19],[19,-21]] of determinant -466",
            "raw Hilbert resource rejection in favor of the sparse finite presentation",
        ],
        "not_proved": [
            "nonemptiness or emptiness of either saturated Rao branch",
            "an irreducible relative marked Hilbert component or its descended base-field point",
            "control of the actual special Noether-Lefschetz or singular quintic carrier",
            "an exact degree-19 curve",
            "an exact residual degree-two cycle or a rational point on the Schur twist",
            "the Klein-cubic headline",
        ],
        "independent_markers": [
            "S19_UNIVERSAL_MARKED_FAMILY_INDEPENDENT_REPLAY_OK",
            "S19_MARKED_INCIDENCE_PRESENTATION_INDEPENDENT_REPLAY_OK",
            "S19_MARKED_COMPONENT_PRESENTATION_INDEPENDENT_REPLAY_OK",
            "S19_NULL_CURVE_RESIDUAL_LEDGER_CONSISTENT",
        ],
        "terminal_marker": "S19_MARKED_CURVE_CONTINUATION_SEALED_UNDECIDED",
    }
    OUTPUT.write_text(json.dumps(payload, indent=2) + "\n")
    print("S19_MARKED_CURVE_CONTINUATION_SEAL_WRITTEN")


if __name__ == "__main__":
    main()
