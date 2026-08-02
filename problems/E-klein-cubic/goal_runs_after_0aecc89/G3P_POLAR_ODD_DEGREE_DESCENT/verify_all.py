#!/usr/bin/env python3
"""Aggregate verifier for G3P: runs independent checks and seals hashes."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def run(script: str) -> str:
    r = subprocess.run(
        [sys.executable, "-u", str(HERE / script)],
        cwd=ROOT,
        capture_output=True,
        text=True,
    )
    sys.stdout.write(r.stdout)
    sys.stderr.write(r.stderr)
    if r.returncode != 0:
        raise SystemExit(f"{script} failed with {r.returncode}")
    return r.stdout


def main() -> None:
    out1 = run("verify_polars.py")
    out2 = run("verify_quadrics.py")
    out3 = run("verify_point.py")
    assert "G3P_POLARS_VERIFY_OK" in out1
    assert "G3P_QUADRICS_VERIFY_OK" in out2
    assert "G3P_POINT_BOUNDARY_OK" in out3

    status = (HERE / "STATUS.md").read_text().splitlines()[0].strip()

    # Files that must exist
    required = [
        "INPUT_MANIFEST.json",
        "TAUTOLOGICAL_POINT.md",
        "POLAR_SYSTEM.md",
        "polar_system.json",
        "QUADRATIC_INVARIANTS.md",
        "quadratic_invariants.json",
        "TANGENT_INCIDENCE.md",
        "ODD_DEGREE_DESCENT.md",
        "odd_degree_descent.json",
        "constructions.json",
        "produce.py",
        "verify_polars.py",
        "verify_quadrics.py",
        "verify_point.py",
        "verify_all.py",
        "REPLAY.md",
        "STATUS.md",
        "src/polar_core.py",
    ]
    for name in required:
        p = HERE / name
        if not p.is_file():
            raise SystemExit(f"missing required {name}")

    # Write SHA256SUMS for packet files (excluding SEAL itself)
    names = sorted(
        p.name if p.parent == HERE else str(p.relative_to(HERE))
        for p in HERE.rglob("*")
        if p.is_file()
        and p.name not in ("SHA256SUMS", "SEAL.json")
        and "__pycache__" not in p.parts
        and not p.name.endswith(".pyc")
    )
    lines = []
    files_map = {}
    for rel in names:
        fp = HERE / rel
        dig = sha256(fp)
        lines.append(f"{dig}  {rel}")
        files_map[rel] = dig
    sums_text = "\n".join(lines) + "\n"
    (HERE / "SHA256SUMS").write_text(sums_text)

    seal = {
        "format": "g3p-polar-odd-degree-descent-seal-v1",
        "exit": status,
        "headline": "OPEN",
        "parent_exits": {
            "G3A": "G3A-ARITHMETIC-DOMINANCE-PASS",
            "G4": "G4-INDUCED-DEGREE11-POINT-PASS",
            "G2": "G2-FINITE-GENERATION-PASS",
        },
        "consumed_commit": "7030ddafb53acdea23070b0d9d20050b592ceb1b",
        "pinned_goal_state": "0aecc89f0598cfd982295107352e6cc6e9fb04e9",
        "markers": [
            "G3P_POLARS_VERIFY_OK",
            "G3P_QUADRICS_VERIFY_OK",
            "G3P_POINT_BOUNDARY_OK",
            "G3P_VERIFY_ALL_OK",
        ],
        "files": files_map,
        "sha256sums": sha256(HERE / "SHA256SUMS"),
        "nonclaims": [
            "no K_proj-point of X_gen",
            "no G3P-POINT-HEADLINE-POSITIVE",
            "no illegal cubic odd-degree descent",
            "not a Problem-E headline",
            "Clifford class over full K_proj not expanded",
        ],
        "residual_gates": [
            "section of Q_q or I_q over K_proj",
            "G3-frame materialization of G4 degree-11 points for Springer path",
        ],
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")

    print("G3P_VERIFY_ALL_OK")
    print(status)
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
