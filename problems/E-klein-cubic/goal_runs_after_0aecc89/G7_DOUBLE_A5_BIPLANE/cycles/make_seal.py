#!/usr/bin/env python3
"""Write SEAL.json and SHA256SUMS for the G7B cycles packet (REDO)."""
from __future__ import annotations

import hashlib
import json
import subprocess
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]

FILES = [
    "INPUT_MANIFEST.json",
    "scaling_interface.json",
    "cycles.json",
    "incidence_correspondence.json",
    "PROJECTIVE_SCALING.md",
    "CYCLES.md",
    "INCIDENCE_CORRESPONDENCE.md",
    "INDUCED_CYCLE_REFUTATION.md",
    "produce.py",
    "produce_meta.json",
    "verify_scaling.py",
    "verify_cycles.py",
    "audit_induced_refutation.py",
    "REPLAY.md",
    "STATUS.md",
    "make_seal.py",
]

OPTIONAL = [
    "cycles_WITHDRAWN_rho_e0.json",
]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> None:
    try:
        commit = subprocess.check_output(
            ["git", "rev-parse", "HEAD"], cwd=ROOT, text=True
        ).strip()
    except Exception:
        commit = "unknown"

    status_first = (HERE / "STATUS.md").read_text().splitlines()[0].strip()
    authorized = {
        "G7-INDUCED-DOUBLE-CYCLE-PASS",
        "G7-PROJECTIVE-SCALING-PASS",
        "G7-UNDECIDED",
        "G7-CANONICAL-INPUT-FAIL",
    }
    if status_first not in authorized:
        raise SystemExit(f"unauthorized STATUS exit: {status_first}")

    cycles = json.loads((HERE / "cycles.json").read_text())
    residual = cycles.get("materialization_status") == "RESIDUAL"
    if status_first == "G7-INDUCED-DOUBLE-CYCLE-PASS" and residual:
        raise SystemExit("cannot seal induced pass with residual cycles")

    files = {}
    sums_lines = []
    for name in FILES:
        p = HERE / name
        if not p.is_file():
            raise SystemExit(f"missing {name}")
        dig = sha256(p)
        files[name] = dig
        sums_lines.append(f"{dig}  {name}")

    for name in OPTIONAL:
        p = HERE / name
        if p.is_file():
            dig = sha256(p)
            files[name] = dig
            sums_lines.append(f"{dig}  {name}")

    seal = {
        "format": "g7b-double-a5-cycles-seal-v2",
        "exit": status_first,
        "also": (
            ["G7-PROJECTIVE-SCALING-PASS"]
            if status_first != "G7-PROJECTIVE-SCALING-PASS"
            else []
        ),
        "g7_3_materialization": "RESIDUAL" if residual else "MATERIALIZED",
        "residual_gate": cycles.get("residual_gate"),
        "headline": "OPEN",
        "stages": ["G7.2", "G7.3-residual" if residual else "G7.3"],
        "consumed_commit": commit,
        "n_correct_G3_coordinates": cycles.get("n_correct_G3_coordinates", None),
        "both_classes_materialized": cycles.get("both_classes_materialized", False),
        "files": files,
        "nonclaims": [
            "no K_proj-point of X_gen",
            "no G7C geometry (G7.4+)",
            "does not reseal H_A5, G4, G7A, G3A",
            "no G7-INDUCED-DOUBLE-CYCLE-PASS without well-defined materialization",
            "withdrawn rho(g_i)·e0 construction is non-consumable",
        ],
        "residual_gates": [
            cycles.get("residual_gate")
            or "need L_H cocycle coordinates from H_A5 formula in G3 frame",
            "G7C cross-ops / third intersections only after correct cycles",
            "G3P.3 Springer needs genuine G3-frame induced points",
        ],
        "supersedes": {
            "prior_exit": "G7-INDUCED-DOUBLE-CYCLE-PASS",
            "prior_construction": "rho(g_i)*e0",
            "status": "non-consumable",
            "artifact": "cycles_WITHDRAWN_rho_e0.json",
        },
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")
    seal_dig = sha256(HERE / "SEAL.json")
    sums_lines.append(f"{seal_dig}  SEAL.json")
    (HERE / "SHA256SUMS").write_text("\n".join(sums_lines) + "\n")
    print("G7B_SEAL_OK")
    print(seal["exit"])
    print(f"g7_3_materialization={seal['g7_3_materialization']}")


if __name__ == "__main__":
    main()
