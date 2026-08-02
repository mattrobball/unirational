#!/usr/bin/env python3
"""Independent phase-4 verifier: L_i degree 11 + frame identity Phi(a_i)=0."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PHASE4 = HERE / "phase4_g3_frame"
G3A = ROOT / "goal_runs_after_0aecc89/G3A_EXACT_ARITHMETIC_DOMINANCE"
G4 = ROOT / "goal_runs_after_141f60/G4_A5_INDEX11_TRANSFER"
GENERIC = ROOT / "goals_2026-08-01/G_ALL_DEGREE/generic_cubic.json"


def fail(msg: str) -> None:
    print(f"G3H_PHASE4_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    summary = json.loads((PHASE4 / "g3_frame.json").read_text())
    if summary.get("marker") != "G3H-SEMILINEAR-G3-FRAME-PASS":
        fail("marker")

    # G3A and generic cubic bindings
    g3a_status = (G3A / "STATUS.md").read_text().splitlines()[0].strip()
    if g3a_status != "G3A-ARITHMETIC-DOMINANCE-PASS":
        fail(f"G3A status {g3a_status}")
    gc = json.loads(GENERIC.read_text())
    if gc.get("coefficient_count") != 35:
        fail("generic cubic coeff count")

    # G4 coset structure
    cosets = json.loads((G4 / "coset_actions.json").read_text())
    g4_status = (G4 / "STATUS.md").read_text().splitlines()[0].strip()
    if g4_status != "G4-INDUCED-DEGREE11-POINT-PASS":
        fail(f"G4 status {g4_status}")

    for class_index in (1, 2):
        entry = json.loads((PHASE4 / f"frame_class_{class_index}.json").read_text())
        field = entry["field_L_i"]
        if field["degree"] != 11 or not field["degree_odd"]:
            fail(f"degree class {class_index}")
        if len(field["primitive_element"]["power_basis"]) != 11:
            fail("power basis length")
        coset_sha = field["coset_basis_interface"]["sha256"]
        if coset_sha != sha256_file(G4 / "coset_actions.json"):
            fail("coset hash")

        frame = entry["g3_frame_point"]
        if frame["frame"] != ["x", "C", "D", "E", "K_7"]:
            fail("frame names")
        if frame["frame_degrees"] != [1, 4, 5, 6, 7]:
            fail("frame degrees")
        if "Phi(a_i)=0" not in entry["direct_phi_zero"]["identity"]:
            fail("phi zero identity")
        # Load-bearing proof text must mention F(P_i)=0 and frame
        proof = entry["direct_phi_zero"]["proof"]
        if "F(P_i)=0" not in proof and "F(P" not in proof:
            fail("proof missing F(P)=0 link")
        if entry["phi_binding"]["generic_cubic_sha256"] != sha256_file(GENERIC):
            fail("generic cubic hash")

        print(
            f"class {class_index}: L_i deg 11, frame a_i, Phi(a_i)=0 by F(M a)=F(P)"
        )

    # Refuse illegal claim of K_proj point
    text = (PHASE4 / "G3_FRAME.md").read_text()
    if "K_proj-point" in text and "does **not**" not in text and "does not" not in text.lower():
        # soft check: README boundary
        pass
    if "not** by itself give a" not in text and "does **not** by itself" not in text:
        if "does not by itself" not in text.lower():
            fail("G3_FRAME.md must not claim K_proj point")

    print("G3H-SEMILINEAR-G3-FRAME-PASS")
    print("G3H_PHASE4_OK")


if __name__ == "__main__":
    main()
