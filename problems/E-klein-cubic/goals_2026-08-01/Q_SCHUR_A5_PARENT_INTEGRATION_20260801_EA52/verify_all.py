#!/usr/bin/env python3
"""Independent end-to-end audit of decision, computations, and seal."""

from __future__ import annotations

import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys

import verify_f55_covariants


HERE = Path(__file__).resolve().parent


def source_root() -> Path:
    # Installed location: <root>/goal_runs_after_35fa/Q_SCHUR_INDEX_ONE.
    # Staged replays pass Q_SCHUR_SOURCE_ROOT explicitly.
    return (
        Path(os.environ["Q_SCHUR_SOURCE_ROOT"]).resolve()
        if "Q_SCHUR_SOURCE_ROOT" in os.environ
        else HERE.parents[1]
    )


def run_replay(relative: str, marker: str) -> None:
    process = subprocess.run(
        [sys.executable, "-u", str(HERE / relative)],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        cwd=HERE,
    )
    assert marker in process.stdout, (relative, process.stdout)
    print(process.stdout, end="")


def run_source_replay(relative: str, marker: str) -> None:
    process = subprocess.run(
        [sys.executable, "-u", str(source_root() / relative)],
        check=True,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        cwd=source_root(),
    )
    assert marker in process.stdout, (relative, process.stdout)
    print(process.stdout, end="")


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def durable_files() -> dict[str, str]:
    return {
        str(path.relative_to(HERE)): sha256(path)
        for path in sorted(HERE.rglob("*"))
        if path.is_file()
        and path.name != "SEAL.json"
        and "__pycache__" not in path.parts
    }


def verify_manifest() -> None:
    manifest = json.loads((HERE / "SOURCE_MANIFEST.json").read_text())
    assert manifest["pinned_repository_state"] == "35fa8f59b6a1423cc89300aeaceefe91552be5ba"
    for name, record in manifest["imports"].items():
        assert sha256(HERE / "imports" / name) == record["sha256"]
    for relative, record in manifest["replay_sources"].items():
        assert sha256(source_root() / relative) == record["sha256"]
    negative = manifest["imports"]["negative_obstruction_audit.json"]
    assert negative["provenance"] == "working-tree snapshot at run start; not the pinned 35fa8f blob"
    assert negative["pinned_35fa8f_blob_sha256"] == "5d1811f0cb6e3f1f4ff0a8df6f79821aa263e2b0196365c01bb9d1b14eebda1d"
    assert negative["sha256"] != negative["pinned_35fa8f_blob_sha256"]


def verify_decision() -> None:
    decision = json.loads((HERE / "decision.json").read_text())
    assert decision["exit"] == "Q-UNDECIDED"
    assert decision["headline"] == "OPEN"
    assert decision["binary"] == {
        "point_proved": False,
        "pointlessness_proved": False,
    }
    assert decision["index"]["effective_degrees"] == [3, 55]
    assert decision["index"]["value"] == 1
    assert decision["new_exact_result"]["schemes_replayed"] == 40
    assert decision["new_exact_result"]["complete_homogeneous_degrees_excluded"] == list(range(1, 9))
    assert decision["new_exact_result"]["coefficient_dimensions"] == [1, 1, 3, 7, 11, 19, 30, 45]
    boundary = decision["all_degree_boundary"]
    assert boundary["hsop_degrees"] == [3, 5, 6, 8, 11]
    assert boundary["secondary_rank"] == 720
    assert boundary["primitive_module_combinations_unbounded"] is True
    assert boundary["hsop_and_freeness_input_reconstructed"] is False
    model = decision["new_birational_model"]
    assert model["smooth_elliptic_normal_quintic_over_K_Schur"] is True
    assert model["associated_V14_over_K_Schur"] is True
    assert model["V14_rational_point_proved"] is False
    assert model["D10_66_line_common_incidence_empty"] is True
    assert model["D12_55_line_common_incidence_empty"] is True
    assert decision["fibration_pass"] is False
    assert len(decision["strict_nonclaims"]) == 6
    status = (HERE / "STATUS.md").read_text()
    audit = (HERE / "COMPLETION_AUDIT.md").read_text()
    assert status.startswith("Q-UNDECIDED\n")
    assert "NOT PROVED" in status and "OPEN" not in status.splitlines()[0]
    assert "Q-SCHUR-POINT-HEADLINE-POSITIVE      no" in audit
    assert "Q-SCHUR-POINTLESS-HEADLINE-NEGATIVE no" in audit


def verify_seal() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["schema"] == "q-schur-index-one-seal-v1"
    assert seal["exit"] == "Q-UNDECIDED" and seal["headline"] == "OPEN"
    assert seal["binary_point_proved"] is False
    assert seal["binary_pointlessness_proved"] is False
    assert seal["new_exact_marker"] == "Q_F55_ALL_PROJECTIVE_CHARACTERS_DEGREE_LE_8_EXACT"
    assert seal["exact_twist_model_marker"] == "Q_SCHUR_EXACT_FRAME_INDEPENDENT_REPLAY_OK"
    assert seal["a5_valuation_marker"] == "Q_SCHUR_A5_VALUATION_ELIMINATION_OK"
    files = durable_files()
    assert seal["file_count"] == len(files)
    assert seal["files"] == files


def main() -> None:
    verify_manifest()
    run_source_replay(
        "goals_2026-08-01/Q_SCHUR_DESCENT/verify_q0.py",
        "Q_SCHUR_Q0_LEDGER_EXACT",
    )
    run_source_replay(
        "goals_2026-08-01/Q_SCHUR_DESCENT/verify_zero_cycle_ledger.py",
        "Q_SCHUR_ZERO_CYCLE_LEDGER_EXACT",
    )
    verify_f55_covariants.main()
    run_replay(
        "f55_degree6_degree7/verify_certificate.py",
        "F55_DEGREE6_DEGREE7_CERTIFICATE_INDEPENDENT_REPLAY_OK",
    )
    run_replay(
        "f55_degree8/verify.py",
        "F55_DEGREE8_SINGLETON_CERTIFICATE_INDEPENDENT_REPLAY_OK",
    )
    run_replay(
        "f55_all_degree_boundary/verify.py",
        "H_TRACE_HILBERT_NEWTON_AUDIT_OK",
    )
    run_replay(
        "schur_enq_v14/verify.py",
        "Q_SCHUR_ENQ_V14_AUDIT_EXACT_NONTERMINAL",
    )
    run_replay(
        "exact_schur_frame/verify_all.py",
        "Q_SCHUR_EXACT_FRAME_PACKET_VERIFY_ALL_OK",
    )
    run_replay(
        "a5_valuation_elimination/verify.py",
        "Q_SCHUR_A5_VALUATION_ELIMINATION_OK",
    )
    verify_decision()
    verify_seal()
    print("PASS immutable source manifest")
    print("PASS requirement-level Q-UNDECIDED decision and strict nonclaims")
    print("PASS SEAL.json binds every durable packet file")
    print("Q_SCHUR_INDEX_ONE_PACKET_VERIFY_ALL_OK")


if __name__ == "__main__":
    main()
