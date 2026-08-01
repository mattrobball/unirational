#!/usr/bin/env python3
"""Produce the deterministic T0 bridge-scope proof payload."""

from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]

SOURCES = {
    "goal": "goals_2026-08-01/GOAL_T_TARGET_BRANCH_INDEX3.md",
    "repair": "REPAIR.md",
    "headline_workorder": "WORKORDER_CAS_HEADLINE.md",
    "post_elo_workorder": "WORKORDER_POST_ELO_CONSTRUCTION.md",
    "bridge_audit": "certificates/pfaffian_point/BRIDGE_AUDIT.md",
    "fixed_frame_report": "tmp/pfaffian_global_fixed_frame_hostile_audit/REPORT.md",
    "fixed_frame_audit": "tmp/pfaffian_global_fixed_frame_hostile_audit/PROOF_AUDIT.md",
    "ternary_report": "tmp/pfaffian_minimal_ternary_model/REPORT.md",
    "ternary_audit": "tmp/pfaffian_minimal_ternary_model/PROOF_AUDIT.md",
    "branch_report": "tmp/full_scaled_frame_branch_line_hostile_audit/REPORT.md",
    "branch_audit": "tmp/full_scaled_frame_branch_line_hostile_audit/PROOF_AUDIT.md",
    "branch_certificate": "tmp/full_scaled_frame_branch_line_hostile_audit/certificate.json",
}

MARKERS = {
    "goal": [
        "return `T-BRIDGE-BLOCKED` with a precise counterexample/gap",
        "another theorem that destroys the proposed negative implication",
        "not for an auxiliary Pfaffian cubic, a coordinate ternary section",
    ],
    "repair": [
        "This is not a point of \\(F_{14,T}\\) or of the generic Klein twist.",
        "The `FAIL-SCOPE` bridge audit is authoritative.",
    ],
    "headline_workorder": [
        "**Not headline bridges:** emptiness of the auxiliary Morita-projector cubic;",
        "fixed-frame auxiliary genus-one torsor",
        "without a separate bridge to `F_{14,T}` or the generic Klein twist",
    ],
    "post_elo_workorder": [
        "**The auxiliary Morita idempotent is not a Klein point.**",
    ],
    "bridge_audit": [
        "**Gate 1 decision:** `FAIL-SCOPE`",
        "has a **broken first arrow**",
        "common isotropic right D-line",
        "Idempotent ⇒ auxiliary Morita point",
    ],
    "fixed_frame_report": [
        "The full fixed-frame Pfaffian plane cubic descends to `F`",
        "This is not a no-point theorem over `K_proj`.",
        "does not settle equivariant unirationality",
    ],
    "fixed_frame_audit": [
        "the full fixed-frame plane cubic is the generic member",
        "`C(K_proj)` empty | **not proved**",
    ],
    "ternary_report": [
        "`(0,1,2)` coordinate plane over `K_proj`",
        "neither finds a `K_proj` point nor proves that none exists",
    ],
    "ternary_audit": [
        "the minimal curve has a `K_proj` point | **not proved**",
        "the minimal curve has no `K_proj` point | **not proved**",
    ],
    "branch_report": [
        "ramification residue degree",
        "generic ramification residue degree is exactly `m=1`",
        "(e,f)=(2,1).",
    ],
    "branch_audit": [
        "unique ramified prime with `(e,f)=(2,1)`",
        "residue degree at this divisor is `m=1`.",
    ],
    "branch_certificate": [
        '"generic_ramification_residue_degree_m": 1',
        '"ramified_pairs_e_f"',
        '"scope": "there exists a global target branch divisor with m=1; no index-survival or no-point conclusion"',
    ],
}


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            h.update(block)
    return h.hexdigest()


def current_head() -> str:
    return subprocess.check_output(
        ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
    ).strip()


def main() -> None:
    source_payload = {}
    for label, relative in SOURCES.items():
        path = ROOT / relative
        text = path.read_text(encoding="utf-8")
        missing = [marker for marker in MARKERS[label] if marker not in text]
        if missing:
            raise RuntimeError(f"{relative}: missing binding markers {missing!r}")
        source_payload[label] = {
            "path": relative,
            "sha256": sha256(path),
            "required_markers": MARKERS[label],
        }

    payload = {
        "schema": "t-target-branch-t0-scope-v1",
        "exit": "T-ROUTE-REFUTED",
        "t0_subexit": "T-BRIDGE-BLOCKED",
        "problem_e_headline": "OPEN",
        "pinned_mathematical_baseline": "715faf441289e2589b9325311b6613ea0331bf88",
        "consumed_head": current_head(),
        "fields": {
            "F": "C(A,B,Y,Z)",
            "K_proj": "C(P(W))^G",
            "extension_degree": 6,
            "branch_residue": {"e": 2, "f": 1, "residue_fields_equal": True},
        },
        "objects": {
            "C_fix": "full fixed-frame Pfaffian plane cubic; auxiliary (0,1,2) coordinate-plane model",
            "X_gen": "genuine generic Klein cubic threefold over K_proj",
            "morita_projector": "sigma-self-adjoint reduced-rank-two idempotent",
            "headline_source": "common isotropic right D-line for all five descended Hermitian forms",
        },
        "implication_ledger": {
            "valid": [
                "ind(C_fix/k(D))=3 => C_fix(K_proj)=empty, by proper specialization at residue-degree-one R",
                "common isotropic line => twisted Fano point => X_gen(K_proj) nonempty",
                "X_gen(K_proj) empty => negative generic-twist headline",
            ],
            "invalid_or_unavailable": [
                "Morita projector => common isotropic line",
                "C_fix(K_proj) empty => no Morita projector",
                "C_fix(K_proj) empty => X_gen(K_proj) empty",
            ],
        },
        "counterexample": {
            "field": "C((s))((t))",
            "plane_cubic": "x^3+s*y^3+t*z^3",
            "plane_cubic_index": 3,
            "ambient_cubic": "x^3+s*y^3+t*z^3+w^2*x+q^3",
            "coordinate_section": "w=q=0",
            "rational_point": [0, 0, 0, 1, 0],
            "t_valuation_residues": [0, 0, 1],
            "residual_cube_obstruction": "v_s(-s)=1 mod 3",
        },
        "stopping_rule": "T1--T3 not run because the mandatory T0 headline arrow is unavailable",
        "sources": source_payload,
    }

    output = HERE / "proof_payload.json"
    output.write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n", encoding="utf-8"
    )
    print(f"wrote {output.name}")
    print("T_TARGET_BRANCH_BRIDGE_SCOPE_PRODUCER_ACCEPT")


if __name__ == "__main__":
    main()
