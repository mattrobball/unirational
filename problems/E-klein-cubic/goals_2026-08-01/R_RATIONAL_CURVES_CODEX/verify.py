#!/usr/bin/env python3
"""Top-level verifier for the Goal R structural packet."""

from __future__ import annotations

import hashlib
import json
import subprocess
import sys
from pathlib import Path


HERE = Path(__file__).resolve().parent


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def require_text(path: str, needles: list[str]) -> None:
    text = (HERE / path).read_text()
    for needle in needles:
        if needle not in text:
            raise AssertionError(f"{path}: missing {needle!r}")


def main() -> None:
    status = (HERE / "STATUS.md").read_text().splitlines()
    assert status[0] == "R-HILBERT-COMPONENT-STRUCTURAL"
    require_text(
        "STATUS.md",
        [
            "headline remains **OPEN**",
            "does **not** assert",
            "no geometrically integral",
            "2140419410cfff2f7d7dcca166acef8c16a0d41b",
        ],
    )
    require_text(
        "THEOREM.md",
        [
            "J_T(K)=\\{0\\}",
            "multiplication by \\(3\\pmod {11}\\)",
            "{}^T M_X(K)=X_T(K)",
            "structural exit, not a positive or negative headline",
        ],
    )
    require_text(
        "HILBERT_INVENTORY.md",
        [
            "exact inventory cutoff is \\(e_0=3\\)",
            "all geometrically integral \\(K\\)-conics excluded",
            "generic-cubic hypothesis fails",
            "No finite-field or bounded search",
        ],
    )

    inventory = json.loads((HERE / "component_inventory.json").read_text())
    assert inventory["cutoff"]["e0"] == 3
    assert inventory["degrees"][1]["K_status"] == "empty"
    assert inventory["fixed_jacobian"]["result"].endswith("exactly the zero point")
    assert inventory["headline"] == "OPEN"
    assert inventory["exit"] == status[0]

    payload = json.loads((HERE / "fixed_jacobian_payload.json").read_text())
    assert payload["tau_minus_one"]["smith_diagonal"] == [1] * 9 + [11]
    assert payload["sigma_on_J_tau"]["scalar_mod_11"] == 3
    assert payload["sigma_on_J_tau"]["fixed_subgroup_order"] == 1
    assert payload["terminal_marker"] == "R_FIXED_JACOBIAN_ZERO_CERTIFIED"

    proc = subprocess.run(
        [sys.executable, str(HERE / "verify_fixed_jacobian.py")],
        cwd=HERE,
        text=True,
        capture_output=True,
        check=True,
    )
    assert "R_FIXED_JACOBIAN_INDEPENDENT_VERIFY_OK" in proc.stdout

    seal = json.loads((HERE / "SEAL.json").read_text())
    assert seal["exit"] == status[0]
    assert seal["headline"] == "OPEN"
    assert "SEAL.json" not in seal["sha256"]
    for name, expected in seal["sha256"].items():
        assert digest(HERE / name) == expected, f"hash mismatch: {name}"

    print(proc.stdout.strip())
    print("R_RATIONAL_CURVES_PACKET_VERIFY_OK")
    print("R-HILBERT-COMPONENT-STRUCTURAL")
    print("HEADLINE_OPEN")


if __name__ == "__main__":
    main()

