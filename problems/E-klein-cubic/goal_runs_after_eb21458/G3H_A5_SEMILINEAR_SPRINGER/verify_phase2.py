#!/usr/bin/env python3
"""Independent phase-2 verifier: rebuild Hom and check Y certificates."""

from __future__ import annotations

import json
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE / "src"))

from cubic_compression import (  # noqa: E402
    EXPS,
    Y_from_coeff_list,
    compute_cubic_compression,
    find_nonzero_minor,
    formal_equivariance_failures,
)
from q5_arith import q5_from_json, qeq, qiszero  # noqa: E402

PHASE2 = HERE / "phase2_cubic_compression"


def fail(msg: str) -> None:
    print(f"G3H_PHASE2_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    summary = json.loads((PHASE2 / "cubic_compression.json").read_text())
    if summary.get("marker") != "G3H-CUBIC-COMPRESSION-PASS":
        fail("marker")

    for class_index, sign in ((1, 1), (2, -1)):
        path = PHASE2 / f"Y_class_{class_index}.json"
        sealed = json.loads(path.read_text())
        if sealed["hom_dimension_over_Q5"] != 1:
            fail(f"class {class_index} hom dim")
        if sealed["equivariance_checks"]["failures"] != 0:
            fail(f"class {class_index} sealed equivar")

        # Rebuild independently
        rebuilt = compute_cubic_compression(sign_sqrt5=sign)
        Y_seal = Y_from_coeff_list(sealed["coefficients"])
        Y_new = rebuilt["Y"]
        # Unique up to scale: compare after matching first nonzero
        # Both are normalized to first nonzero = 1, so should match exactly
        for o in range(3):
            for m in range(35):
                if not qeq(Y_seal[o][m], Y_new[o][m]):
                    # allow global sign if free variable orientation differs
                    fail(
                        f"class {class_index} coeff mismatch at out={o} mon={EXPS[m]}: "
                        f"{Y_seal[o][m]} vs {Y_new[o][m]}"
                    )

        bad, checks = formal_equivariance_failures(
            Y_seal, rebuilt["source"], rebuilt["action"]
        )
        if bad:
            fail(f"class {class_index} equivar {bad}/{checks}")
        minor = find_nonzero_minor(Y_seal)
        if minor is None:
            fail(f"class {class_index} no jacobian minor")
        print(
            f"class {class_index}: Hom=1, equivar 0/{checks}, "
            f"minor at {minor['point']} cols {minor['columns']}"
        )

    print("G3H-CUBIC-COMPRESSION-PASS")
    print("G3H_PHASE2_OK")


if __name__ == "__main__":
    main()
