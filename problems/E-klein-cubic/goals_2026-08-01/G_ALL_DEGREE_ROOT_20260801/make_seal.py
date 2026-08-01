#!/usr/bin/env python3
"""Refresh the isolated packet seal without sealing exploratory degree ladders."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    seal_path = HERE / "SEAL.json"
    seal = json.loads(seal_path.read_text())
    names = set(seal["files"])
    names.discard("m3_line1_char0.out")
    names.discard("m3_line1_reduction.out")
    names.update(
        {
            "LINE1_CHAR0_FLATNESS.md",
            "LINE4_SCHEME_RIGIDITY.md",
            "make_seal.py",
            "m3_line1_char0.json",
            "m3_line1_char0_output.txt",
            "m3_line1_char0.sing",
            "m3_line1_reduction_output.txt",
            "m3_line1_reduction.sing",
            "m3_line1_reduction_boundary_output.txt",
            "m3_line1_reduction_boundary.sing",
            "produce_line1_char0.py",
            "produce_line4_normal_rigidity.py",
            "verify_line1_char0.py",
            "verify_line4_normal_rigidity.py",
        }
    )
    names.update(
        str(path.relative_to(HERE))
        for path in (HERE / "line4_normal_rigidity").iterdir()
        if path.is_file()
    )
    # Exploratory line-degree-five/six emissions are intentionally excluded:
    # they are a finite ladder and support no theorem in the packet.
    seal["scope"] = (
        "characteristic-zero all-order first gate and line-constant obstruction; "
        "exact split-F67 central boundary recurrence and scheme-theoretic "
        "line-degree-four classification; exact cyclotomic rank-48 flatness "
        "and characteristic-zero degree-four classification; no headline decision"
    )
    seal["files"] = {name: digest(HERE / name) for name in sorted(names)}
    replay = seal["replay"]
    command = "python3 G_ALL_DEGREE_ROOT_20260801/verify_line4_normal_rigidity.py"
    if command not in replay:
        replay.append(command)
    command = "/opt/homebrew/bin/python3 G_ALL_DEGREE_ROOT_20260801/verify_line1_char0.py"
    if command not in replay:
        replay.append(command)
    seal["unresolved_frontier"] = (
        "an all-line and higher-transverse-layer theorem; equivalently the "
        "exact K_proj-rational-point problem for the generic twisted Klein cubic"
    )
    seal_path.write_text(json.dumps(seal, indent=2, sort_keys=False) + "\n")


if __name__ == "__main__":
    main()
