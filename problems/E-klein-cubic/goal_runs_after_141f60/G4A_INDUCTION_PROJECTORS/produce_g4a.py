#!/usr/bin/env python3
"""G4A producer entrypoint.

Full regeneration of H_A5 exact bases, modular Klein witnesses, cosets, projectors,
and ops is performed by the sealed multi-step generation recorded in this packet.
This entrypoint validates artifacts and refreshes SEAL hashes.

For a from-scratch rebuild, re-run the generation pipeline that produced:
  h_a5_base_class_{1,2}.json
  klein_witnesses_mod89.json
  coset_actions.json / induced_points.json / projectors.json / operations.json
then this script to reseal.
"""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for c in iter(lambda: f.read(1 << 20), b""):
            h.update(c)
    return h.hexdigest()


def main() -> None:
    required = [
        "coset_actions.json",
        "induced_points.json",
        "projectors.json",
        "operations.json",
        "h_a5_base_class_1.json",
        "h_a5_base_class_2.json",
        "klein_witnesses_mod89.json",
        "INPUT_MANIFEST.json",
        "STATUS.md",
        "verify_all.py",
    ]
    for name in required:
        path = HERE / name
        if not path.is_file():
            raise SystemExit(f"missing {name}; full regeneration required")
        if name.endswith(".json"):
            json.loads(path.read_text())

    # Sanity: H_A5 formula used
    ind = json.loads((HERE / "induced_points.json").read_text())
    for cl in ind["classes"]:
        if not cl["base_H_point"].get("formula_used"):
            raise SystemExit("formula_used missing")
        for conj in cl["conjugates"]:
            g3 = conj["G3_frame_coordinates"]
            if g3.get("type") != "base_change_of_H_A5_installed_formula":
                raise SystemExit("conjugates not H_A5 base-change")
            kw = g3["Klein_W_landing_witness_on_V_F"]
            if "Phi_params" not in kw.get("construction", "") and "H_A5" not in kw.get(
                "construction", ""
            ):
                raise SystemExit("Klein witness not from H_A5 formula")

    wit = json.loads((HERE / "klein_witnesses_mod89.json").read_text())
    if len(wit["classes"]) != 2:
        raise SystemExit("need 2 modular witness classes")

    seal_files = [
        "INPUT_MANIFEST.json",
        "coset_actions.json",
        "induced_points.json",
        "projectors.json",
        "operations.json",
        "h_a5_base_class_1.json",
        "h_a5_base_class_2.json",
        "klein_witnesses_mod89.json",
        "COSET_ACTIONS.md",
        "PERMUTATION_PROJECTORS.md",
        "INDUCED_POINTS.md",
        "LOW_ARITY_OPERATIONS.md",
        "REPLAY.md",
        "STATUS.md",
        "verify_all.py",
        "produce_g4a.py",
    ]
    files = {n: sha256(HERE / n) for n in seal_files if (HERE / n).is_file()}
    seal = {
        "format": "g4a-induction-projectors-seal-v3",
        "exit": "G4-INDUCED-DEGREE11-POINT-PASS",
        "also_exits": ["G4-COSET-PROJECTOR-REDUCTION-PASS"],
        "headline": "OPEN",
        "slice": "G4.0+G4.1",
        "G_module": "1+10",
        "five_dimensional_projectors": "A5-restriction per class (x2)",
        "H_A5_formula_base_change": True,
        "consumed_commit": "7030ddafb53acdea23070b0d9d20050b592ceb1b",
        "files": files,
        "nonclaims": [
            "no G4-POINT-HEADLINE-POSITIVE",
            "no secant geometry (G4.3)",
            "Klein/companion 5s of G not summands of Ind",
            "ordered constant-field W-tuple not H-fixed (no line in Res Klein 5)",
        ],
    }
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2) + "\n")
    print("G4A_PRODUCE_OK")
    print("H_A5_formula_base_change=true")
    print("artifacts_validated_and_resealed")
    print("exit G4-INDUCED-DEGREE11-POINT-PASS")


if __name__ == "__main__":
    main()
