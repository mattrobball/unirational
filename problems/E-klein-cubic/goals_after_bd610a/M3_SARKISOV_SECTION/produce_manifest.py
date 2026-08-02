#!/usr/bin/env python3
"""Create the current-hash input manifest for the M3 packet."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
M2 = PROBLEM / "goal_runs_after_35fa" / "M_SARKISOV"
FRAME = (
    PROBLEM
    / "goals_2026-08-01"
    / "Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D"
)
QUARTIC = PROBLEM / "goals_2026-08-01" / "Q_SCHUR_DESCENT"
OUT = HERE / "INPUT_MANIFEST.json"


FILES: tuple[tuple[str, str], ...] = (
    ("goals_after_bd610a/GOAL_M3_SARKISOV_SECTION.md", "authoritative M3 work order"),
    ("goals_after_bd610a/README.md", "common goal-run contract"),
    ("CURRENT_PATHS.md", "authoritative path ledger"),
    ("DIRECTOR_REVIEW_AFTER_BD610A.md", "director state after pinned revision"),
    ("SPEC.md", "problem specification and bridge boundaries"),
    ("REPAIR.md", "repair ledger"),
    ("RESOLUTION.md", "current theorem ledger and active-field no-line theorem"),
    ("goal_runs_after_35fa/M_SARKISOV/STATUS.md", "binding M2 exit"),
    ("goal_runs_after_35fa/M_SARKISOV/THEOREM.md", "binding link theorem"),
    ("goal_runs_after_35fa/M_SARKISOV/ARITHMETIC.md", "degree 3/55 and Voisin alternative"),
    ("goal_runs_after_35fa/M_SARKISOV/DESCENT.md", "projective Schur field and frame"),
    ("goal_runs_after_35fa/M_SARKISOV/DIVISOR_COX.md", "Picard, Cox, and curve classes"),
    ("goal_runs_after_35fa/M_SARKISOV/REFERENCES.md", "external theorem ledger"),
    ("goal_runs_after_35fa/M_SARKISOV/SEAL.json", "binding packet seal with recorded drift"),
    (
        "goal_runs_after_35fa/M_SARKISOV/links/schur_plane_012_dp3/link_payload.json",
        "selected-link machine payload",
    ),
    (
        "goal_runs_after_35fa/M_SARKISOV/links/schur_plane_012_dp3/verify_link.py",
        "independent selected-link verifier",
    ),
    ("goal_runs_after_35fa/M_SARKISOV/payload/centre_census.json", "ten-plane census"),
    ("goal_runs_after_35fa/M_SARKISOV/payload/mori_cox.json", "Mori/Cox payload"),
    ("goal_runs_after_35fa/M_SARKISOV/verify_census.py", "independent centre-census verifier"),
    ("goal_runs_after_35fa/M_SARKISOV/verify.py", "top M2 verifier with recorded upstream hash drift"),
    (
        "goals_2026-08-01/Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D/exact_frame.json",
        "exact equal-degree projective Schur frame",
    ),
    (
        "goals_2026-08-01/Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D/exact_representation_core.py",
        "exact cyclotomic representation core",
    ),
    (
        "goals_2026-08-01/Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D/verify_all.py",
        "independent frame packet verifier",
    ),
    (
        "goals_2026-08-01/Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D/SEAL.json",
        "exact-frame packet seal",
    ),
    (
        "goals_2026-08-01/Q_SCHUR_EXPLICIT_FRAME_CODEX_ROOT_20260801_8F3D/verify_exact_frame.py",
        "independent exact-frame core verifier",
    ),
    ("tmp/schur_structural_routes/REPORT.md", "active-field no-line/no-conic theorem"),
    ("tmp/schur_structural_routes/PROOF_AUDIT.md", "external-dependency audit for no-line theorem"),
    ("tmp/projective_source/DEGREE8_RATIONAL_FRAME_REPORT.md", "projective-source point equivalence"),
    ("tmp/projective_source/REPORT.md", "quadratic-descent versality bridge"),
    ("tmp/projective_source/landing_scan.py", "PSL2(11) group enumeration for pair residuals"),
    ("tmp/projective_source/character_scan.py", "Fano and representation data for independent pair replay"),
    ("tmp/projective_source/invariant_scan.py", "indirect exact invariant dependency of the frame module"),
    ("tmp/fano14_twist/fano_covariant_scan.py", "indirect six-dimensional representation core for pair replay"),
    ("tmp/projective_source/degree8_m2.py", "invariant cubic reconstruction for pair residuals"),
    ("tmp/projective_source/degree8_rational_frame.py", "degree-eight frame seeds for pair residuals"),
    ("goals_2026-08-01/Q_SCHUR_DESCENT/quartic_frontier.json", "primitive quartic frontier"),
    ("goals_2026-08-01/Q_SCHUR_DESCENT/verify_quartic_frontier.py", "quartic group verifier"),
    (
        "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/quartic_descent/field_certificate.json",
        "quartic/Schur field-independence certificate",
    ),
    (
        "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/quartic_descent/verify_field_certificate.py",
        "field-independence verifier",
    ),
    (
        "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/root_secant/resolvent_geometry_probe.json",
        "resolvent-collinearity counterexample payload",
    ),
    (
        "goals_2026-08-01/Q_SCHUR_DESCENT/parallel/root_secant/verify_resolvent_geometry.py",
        "resolvent-geometry verifier",
    ),
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def build() -> dict:
    inputs = []
    for relative, role in FILES:
        path = PROBLEM / relative
        assert path.is_file(), path
        inputs.append({"path": relative, "sha256": sha256(path), "role": role})

    m2_seal = json.loads((M2 / "SEAL.json").read_text())
    stale = next(
        entry
        for entry in m2_seal["upstream_files"]
        if entry.get("path") == "C_PFAFFIAN_FANO_CODEX_ROOT/STATUS.md"
    )
    current_stale_path = (
        PROBLEM
        / "goals_2026-08-01"
        / "C_PFAFFIAN_FANO_CODEX_ROOT"
        / "STATUS.md"
    )
    current_text = current_stale_path.read_text()
    assert current_text.startswith("C-UNDECIDED")

    return {
        "schema": "m3-sarkisov-section-input-manifest-v1",
        "base_field": "K_Schur=C(P(V6))^PSL2(F11)",
        "pinned_state": "bd610a032bb9561d2daeb91a2cb60c48c082ca2f",
        "inputs": inputs,
        "external_theorems": [
            {
                "author": "Claire Voisin",
                "title": "Rank 2 vector bundles and degrees of points of del Pezzo surfaces",
                "version": "arXiv:2509.17996v2",
                "url": "https://arxiv.org/html/2509.17996v2",
                "scope": "characteristic-zero cubic-surface point-or-degree-four theorem",
            },
            {
                "author": "Janos Kollar",
                "title": "Unirationality of cubic hypersurfaces",
                "version": "arXiv:math/0005146v1",
                "url": "https://arxiv.org/abs/math/0005146v1",
                "scope": "a smooth cubic hypersurface with a rational point is unirational",
            },
        ],
        "binding_replay_audit": {
            "top_level_command": "python3 goal_runs_after_35fa/M_SARKISOV/verify.py",
            "top_level_exit": "FAIL_STALE_UPSTREAM_HASH",
            "stale_path": "goals_2026-08-01/C_PFAFFIAN_FANO_CODEX_ROOT/STATUS.md",
            "sealed_sha256": stale["sha256"],
            "current_sha256": sha256(current_stale_path),
            "current_marker": "C-UNDECIDED",
            "load_bearing_selected_link_replays_independently": True,
            "classification": "non-load-bearing status drift; not M3-CANONICAL-INPUT-FAIL",
        },
        "forbidden_substitutions": [
            "C(W)^G and the mixed-degree x,C,D,E,K frame",
            "K_proj=C(P(W))^G and the normalized xCD plane",
            "a stable transcendental extension of either field",
        ],
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    args = parser.parse_args()
    text = json.dumps(build(), indent=2, sort_keys=True) + "\n"
    if args.write:
        OUT.write_text(text)
        print(f"WROTE {OUT}")
    else:
        print(text, end="")


if __name__ == "__main__":
    main()
