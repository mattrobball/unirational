#!/usr/bin/env python3
"""Write the content-only seal for the Goal G structural packet."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
PINNED_BASELINE = "715faf441289e2589b9325311b6613ea0331bf88"
LEGACY_REQUIRED = (
    "ATTACKS.md",
    "DECISION.md",
    "FINITE_GENERATION.md",
    "FIRST_GATE.md",
    "STATUS.md",
    "UNIVERSAL_OBJECT.md",
    "WORKLOG.md",
    "generic_cubic.json",
    "generic_cubic_reduction.log",
    "generic_cubic_reduction.m2",
    "make_seal.py",
    "produce_generic_cubic.py",
    "produce_line_constant_certificate.py",
    "verify_all.py",
    "verify_generic_cubic.py",
    "verify_line_constant.py",
    "verify_seal.py",
    "verify_structural.py",
    "verify_universal_object.py",
    "attacks/constructive_point/RESULT.md",
    "attacks/constructive_point/basis_atom_search.json",
    "attacks/constructive_point/build_frame_line_inputs.py",
    "attacks/constructive_point/frame_line_C_D.sing",
    "attacks/constructive_point/frame_line_C_E.sing",
    "attacks/constructive_point/frame_line_C_K.sing",
    "attacks/constructive_point/frame_line_D_E.sing",
    "attacks/constructive_point/frame_line_D_K.sing",
    "attacks/constructive_point/frame_line_E_K.sing",
    "attacks/constructive_point/frame_line_x_C.sing",
    "attacks/constructive_point/frame_line_x_D.sing",
    "attacks/constructive_point/frame_line_x_E.sing",
    "attacks/constructive_point/frame_line_x_K.sing",
    "attacks/constructive_point/frame_lines.index",
    "attacks/constructive_point/produce_structural_exclusions.py",
    "attacks/constructive_point/search_basis_atoms.py",
    "attacks/constructive_point/structural_exclusions.json",
    "attacks/constructive_point/verify.py",
    "attacks/local_infinite_descent/RESULT.md",
    "attacks/local_infinite_descent/STATUS.md",
    "attacks/local_infinite_descent/verify.py",
    "attacks/valuation_obstruction/AUDIT.md",
    "attacks/valuation_obstruction/RESULT.md",
    "attacks/valuation_obstruction/THEOREM.md",
    "attacks/valuation_obstruction/certificate.json",
    "attacks/valuation_obstruction/produce_certificate.py",
    "attacks/valuation_obstruction/verify.py",
    "attacks/zero_cycle_containment/REPORT.md",
    "attacks/zero_cycle_containment/counterexample.sing",
    "attacks/zero_cycle_containment/group_check.g",
    "attacks/zero_cycle_containment/verify.py",
)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def artifact_names() -> tuple[str, ...]:
    """Seal the complete durable tree, excluding only generated caches."""
    return tuple(
        sorted(
            str(path.relative_to(HERE))
            for path in HERE.rglob("*")
            if path.is_file()
            and path != HERE / "SEAL.json"
            and "__pycache__" not in path.parts
            and path.suffix != ".pyc"
        )
    )


def main() -> None:
    names = artifact_names()
    missing = [name for name in LEGACY_REQUIRED if name not in names]
    if missing:
        raise FileNotFoundError(f"missing legacy seal artifacts: {missing}")
    status = (HERE / "STATUS.md").read_text().splitlines()[0]
    if status != "G-STRUCTURAL-UNDECIDED":
        raise AssertionError(f"unexpected exit: {status}")
    payload = {
        "schema": "G_ALL_DEGREE_STRUCTURAL_SEAL_V3",
        "exit": status,
        "pinned_mathematical_baseline": PINNED_BASELINE,
        "scope": (
            "Corrected all-degree object with checked denominator clearing, "
            "exact generic cubic, exact xCD-plane pointlessness, unsaturated "
            "all-order local recurrence, C1-residue henselian solubility, and "
            "an exact primitive-quartic frontier; no full rational-point or "
            "pointlessness verdict."
        ),
        "artifacts": {name: sha256(HERE / name) for name in names},
    }
    (HERE / "SEAL.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print(f"G_ALL_DEGREE_SEAL_WRITTEN artifacts={len(names)}")


if __name__ == "__main__":
    main()
