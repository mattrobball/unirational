#!/usr/bin/env python3
"""Independent verifier for the Goal B exhaustiveness refutation."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
E_ROOT = HERE.parents[1]


def require(condition: bool, message: str) -> None:
    if not condition:
        raise AssertionError(message)


def sha256(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def main() -> None:
    payload = json.loads((HERE / "bridge_refutation.json").read_text())

    require(payload["exit"] == "B-BRIDGE-REFUTED", "wrong exit")
    require(payload["headline"] == "OPEN", "headline overclaim")

    fano_dim = payload["objects"]["fano"]["dimension"]
    slice_dim = payload["objects"]["fixed_frame_image"]["dimension_upper_bound"]
    sat_dim = payload["theorem"]["dimension_upper_bound"]
    finite = payload["objects"]["gauge"]["effective_action_finite"]

    require(fano_dim == 3, "Fano dimension drift")
    require(slice_dim <= 1, "fixed-frame image is not curve-bounded")
    require(finite is True, "effective gauge image not certified finite")
    require(sat_dim == slice_dim, "finite saturation dimension mismatch")
    require(sat_dim < fano_dim, "saturation is not proper by dimension")
    require(payload["theorem"]["proper_in_fano"] is True, "properness missing")
    require(payload["theorem"]["universal_exhaustiveness"] is False,
            "exhaustiveness was not refuted")
    require(payload["theorem"]["counterexample_point"] == "generic point eta_F14_T",
            "generic-point counterexample missing")

    # Independent upstream theorem-boundary checks.
    c0 = (E_ROOT / payload["source_paths"]["c0_audit"]).read_text()
    dictionary = (E_ROOT / payload["source_paths"]["old_dictionary"]).read_text()
    c5 = (E_ROOT / payload["source_paths"]["c5_status"]).read_text()
    goal = (E_ROOT / payload["source_paths"]["goal"]).read_text()

    require("degree-14 Fano threefold of genus 8 and" in c0,
            "C0 genus-eight source pin absent")
    require("Picard number one" in c0, "C0 Picard-rank source pin absent")
    require("Gamma = PGU(h_struct) cap Stab" in dictionary,
            "Gamma source pin absent")
    require("C_K^open -> P_aux -> I_sigma" in dictionary,
            "fixed-frame image source pin absent")
    require("dimension three and degree fourteen" in c5,
            "C5 threefold source pin absent")
    require("geometrically integral" in c5, "C5 integrality source pin absent")
    require("B-BRIDGE-REFUTED" in goal, "authorized exit source pin absent")

    theorem = (HERE / "EXHAUSTIVENESS_THEOREM.md").read_text()
    status = (HERE / "STATUS.md").read_text()
    require("generic point" in theorem and "dim N <= 1 < 3 = dim Y" in theorem,
            "written proof boundary missing")
    require(status.startswith("B-BRIDGE-REFUTED\n"), "status marker drift")
    require("does **not** prove a `K_proj`-point" in status, "scope fence missing")

    seal = json.loads((HERE / "SEAL.json").read_text())
    require(seal["exit"] == "B-BRIDGE-REFUTED", "seal exit drift")
    for name, expected in seal["files"].items():
        path = HERE / name
        require(path.is_file(), f"sealed file missing: {name}")
        require(sha256(path) == expected, f"seal mismatch: {name}")

    print("B-FIXED-FRAME-EXHAUSTIVENESS-REFUTED")
    print("B-BRIDGE-REFUTED")
    print("HEADLINE-OPEN")


if __name__ == "__main__":
    main()
