#!/usr/bin/env python3
"""Orchestrate independent G3A verifiers."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
SCRIPTS = (
    "verify_field.py",
    "verify_phi.py",
    "verify_bridge.py",
)


def main() -> None:
    for name in (
        "INPUT_MANIFEST.json",
        "FIELD_MODEL.md",
        "field_model.json",
        "PHI_RECONSTRUCTION.md",
        "POLARIZATION.md",
        "SMOOTHNESS.md",
        "DOMINANCE_BRIDGE.md",
        "dominance_bridge.json",
        "EXPORTS.md",
        "produce.py",
        "verify_field.py",
        "verify_phi.py",
        "verify_bridge.py",
        "verify_all.py",
        "REPLAY.md",
        "SEAL.json",
        "STATUS.md",
    ):
        path = HERE / name
        if not path.is_file():
            # phi_exact.json created by verify_phi
            if name in ("phi_exact.json", "SHA256SUMS"):
                continue
            raise SystemExit(f"missing deliverable {name}")

    for script in SCRIPTS:
        print(f"=== {script} ===")
        proc = subprocess.run(
            [sys.executable, "-u", str(HERE / script)],
            cwd=ROOT,
            text=True,
        )
        if proc.returncode != 0:
            raise SystemExit(f"{script} failed with {proc.returncode}")

    # phi_exact must exist after verify_phi
    if not (HERE / "phi_exact.json").is_file():
        raise SystemExit("phi_exact.json missing after verify_phi")

    status = (HERE / "STATUS.md").read_text().splitlines()[0].strip()
    seal = __import__("json").loads((HERE / "SEAL.json").read_text())
    if status != seal.get("exit"):
        raise SystemExit(f"STATUS/SEAL mismatch {status} vs {seal.get('exit')}")
    if seal.get("headline") != "OPEN":
        raise SystemExit("headline must remain OPEN")
    if "POINT" in status and "PASS" in status and "ARITHMETIC" not in status:
        raise SystemExit("unexpected point exit")

    print("G3A_VERIFY_ALL_OK")
    print(status)
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
