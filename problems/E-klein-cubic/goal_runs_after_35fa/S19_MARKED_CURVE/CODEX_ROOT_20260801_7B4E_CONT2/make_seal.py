#!/usr/bin/env python3
"""Build the append-only S19 continuation-2 seal."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[2]
PARENT = HERE.parent / "CODEX_ROOT_20260801_7B4E"
OUTPUT = HERE / "SEAL.json"

ARTIFACTS = (
    "COMPLETION_AUDIT.md",
    "HANKEL_COMPRESSION.md",
    "PROOF_REPORT.md",
    "README.md",
    "RESIDUAL_GATE.md",
    "SOURCE_LEDGER.md",
    "STATUS.md",
    "TRISECANT_DEGENERATION.md",
    "TWO_TRANSVERSAL_FAMILY.md",
    "WORK_SCOPE.md",
    "analyze_cover_family_mod67.py",
    "hankel_probe.json",
    "make_seal.py",
    "probe_hankel_incidence.py",
    "produce_trisecant_degeneration.py",
    "run_all.py",
    "trisecant_degeneration.json",
    "two_transversal_family_mod67.json",
    "verify_hankel_incidence.py",
    "verify_seal.py",
    "verify_trisecant_degeneration.py",
)


def sha256(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def main():
    for name in ARTIFACTS:
        assert (HERE / name).is_file(), name
    assert (HERE / "STATUS.md").read_text().splitlines()[0] == "S19-UNDECIDED"
    data = {
        "schema": "s19-marked-curve-continuation-2-seal-v1",
        "date": "2026-08-01",
        "packet": "goal_runs_after_35fa/S19_MARKED_CURVE/CODEX_ROOT_20260801_7B4E_CONT2",
        "repository_commit_consumed": "37d61c19a108781cf74af837e24810a9f7f7c3be",
        "pinned_state": "35fa8f59b6a1423cc89300aeaceefe91552be5ba",
        "parent_seal_sha256": sha256(PARENT / "SEAL.json"),
        "decision_exit": "S19-UNDECIDED",
        "decision_meaning": "lossless incidence and exact degeneration boundaries are certified, but no qualifying curve or branch exclusion is proved",
        "artifact_sha256": {name: sha256(HERE / name) for name in ARTIFACTS},
        "consumed_source_sha256": {
            "goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md": sha256(PROBLEM / "goals_after_35fa8f/GOAL_S19_MARKED_CURVE_CONTINUATION.md"),
            "certificates/exact_weil_check.py": sha256(PROBLEM / "certificates/exact_weil_check.py"),
            "parent/SEAL.json": sha256(PARENT / "SEAL.json"),
            "parent/universal_marked_family.json": sha256(PARENT / "universal_marked_family.json"),
        },
        "proved": [
            "lossless 105 by 20 Reed-Solomon dual Hankel incidence criterion on the distinct affine source chart",
            "planted degree-19 control drops Hankel rank to 19 and reconstructs all four forms",
            "5468 bounded modular parameter tests are full rank at F_397, explicitly as a nonverdict",
            "exact orbit-line 55_3 triangle configuration with minimum universal triangle cover 21",
            "exact special hyperplane with 19 trisecants covering all 55 marks",
            "that exact union has 17 components, Hilbert polynomial 19t+17, and arithmetic genus -16",
            "one affine h4-nonzero chart of the natural two-transversal repair family has no qualified high-edge point over algebraic closure of F_67",
        ],
        "not_proved": [
            "nonemptiness or emptiness of either saturated Rao branch",
            "a dominant relative marked-Hilbert component or descended base-field point",
            "characteristic-zero exclusion of the two-transversal family or any other degeneration family",
            "an exact geometrically integral rational degree-19 curve",
            "an exact residual degree-two cycle or rational point",
            "the Klein-cubic headline",
        ],
        "replay_markers": [
            "S19_HANKEL_PROBE_REPRODUCES",
            "S19_HANKEL_COMPRESSION_INDEPENDENT_REPLAY_OK",
            "S19_EXACT_TRISECANT_DEGENERATION_REPRODUCES",
            "S19_EXACT_TRISECANT_DEGENERATION_INDEPENDENT_REPLAY_OK",
            "S19_TWO_TRANSVERSAL_MOD67_REPRODUCES",
            "S19_CONTINUATION_2_SEAL_VERIFIED",
        ],
        "terminal_marker": "S19_MARKED_CURVE_CONTINUATION_2_SEALED_UNDECIDED",
    }
    OUTPUT.write_text(json.dumps(data, indent=2, sort_keys=True) + "\n")
    print("S19_CONTINUATION_2_SEAL_WRITTEN")


if __name__ == "__main__":
    main()
