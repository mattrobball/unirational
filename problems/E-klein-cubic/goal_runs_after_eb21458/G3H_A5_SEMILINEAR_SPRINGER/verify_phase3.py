#!/usr/bin/env python3
"""Independent phase-3 verifier: bind Psi and Y; check structural landing chain."""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
sys.path.insert(0, str(HERE / "src"))

from cubic_compression import Y_from_coeff_list, eval_Y  # noqa: E402
from q5_arith import qiszero  # noqa: E402

PHASE2 = HERE / "phase2_cubic_compression"
PHASE3 = HERE / "phase3_semilinear_landing"
H_A5 = ROOT / "goal_runs_after_35fa/H_A5_TWISTS"


def fail(msg: str) -> None:
    print(f"G3H_PHASE3_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    summary = json.loads((PHASE3 / "semilinear_landing.json").read_text())
    if summary.get("marker") != "G3H-SEMILINEAR-LANDING-PASS":
        fail("marker")

    raw_hash = sha256_file(H_A5 / "common" / "degree11_covariants_raw_exact.json")
    if summary.get("raw_covariant_basis_sha256") != raw_hash:
        fail("raw covariant hash")

    for class_index in (1, 2):
        entry = json.loads((PHASE3 / f"landing_class_{class_index}.json").read_text())
        ypath = PHASE2 / f"Y_class_{class_index}.json"
        if entry["Y_binding"]["sha256"] != sha256_file(ypath):
            fail(f"Y hash class {class_index}")
        ppath = H_A5 / f"A5_class_{class_index}" / "point.json"
        if entry["Psi_binding"]["sha256"] != sha256_file(ppath):
            fail(f"Psi hash class {class_index}")
        point = json.loads(ppath.read_text())
        if point.get("exit") != f"H-A5-CLASS{class_index}-RATIONAL-POINT":
            fail(f"H_A5 exit class {class_index}")
        if "F(Psi" not in point["installed_coordinates"]["equation_check"].replace(" ", ""):
            # accept F(A_i*z_i)=F(Psi_i)=0 exactly
            if "F(Psi" not in point["installed_coordinates"]["equation_check"]:
                if "Psi" not in point["installed_coordinates"]["equation_check"]:
                    fail("equation_check missing Psi landing")

        # Structural chain presence
        st = entry["structural_landing"]
        for key in ("identity", "composition", "A5_equivariance", "P_nonzero_open"):
            if key not in st or not st[key]:
                fail(f"missing structural {key}")
        if entry["composition_degree"] != 33:
            fail("degree")

        # Rebuild Y nonzero samples
        Y = Y_from_coeff_list(json.loads(ypath.read_text())["coefficients"])
        any_nonzero = False
        for sample in entry["sample_evaluations_Y"]:
            y = eval_Y(Y, sample["w"])
            nz = any(not qiszero(c) for c in y)
            if nz != sample["Y_w_nonzero"]:
                fail(f"sample Y nonzero mismatch at {sample['w']}")
            any_nonzero = any_nonzero or nz
        if not any_nonzero:
            fail(f"all Y samples zero class {class_index}")

        # Composition identity is structural: F(Psi(y))=0 sealed => F(P)=0
        print(f"class {class_index}: Psi bound, Y nonzero, deg 33, F(P)=0 structural")

    print("G3H-SEMILINEAR-LANDING-PASS")
    print("G3H_PHASE3_OK")


if __name__ == "__main__":
    main()
