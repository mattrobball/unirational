#!/usr/bin/env python3
"""Verify every byte hash in SEAL.json."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def main() -> None:
    seal = json.loads((HERE / "SEAL.json").read_text())
    if seal["status"] != "SEALED_SYSTEMATIC_GRADED_PREFLIGHT_NONVERDICT":
        raise AssertionError("seal status drift")
    for name, record in seal["files"].items():
        path = HERE / name
        if path.stat().st_size != record["bytes"]:
            raise AssertionError(f"size mismatch: {name}")
        if sha256(path) != record["sha256"]:
            raise AssertionError(f"hash mismatch: {name}")
    if seal["affine_run"]["status"] != "TIMEOUT_NONVERDICT":
        raise AssertionError("affine status drift")
    if seal["systematic_term_order"]["status"] != "PASS_INDEPENDENT_SYSTEMATIC_LEADING_TERMS":
        raise AssertionError("systematic status drift")
    if seal["systematic_term_order"]["standard_basis_completed"]:
        raise AssertionError("false standard-basis completion claim")
    graded = seal["graded_closure"]
    if graded["status"] != "PASS_EXACT_DEGREE3_PROFILES_AND_DEGREE4_SCHEDULE":
        raise AssertionError("graded-closure status drift")
    if graded["first_layer"] != {
        "same_component_spairs": 10992,
        "residual_standard_rank": 225,
        "pure_m1_cubic_rows": 10767,
    }:
        raise AssertionError("first-layer split drift")
    if graded["degree3_Dp"]["rank"] != 10767:
        raise AssertionError("Dp profile rank drift")
    if graded["degree3_dp"]["rank"] != 10767:
        raise AssertionError("dp profile rank drift")
    schedule = graded["degree4_schedule"]
    if schedule["product_fibers"] + schedule["star_tree_difference_rows"] != 398379:
        raise AssertionError("degree-four schedule partition drift")
    if not schedule["row_space_coverage_verified"]:
        raise AssertionError("degree-four coverage verification drift")
    sample = graded["degree4_bounded_sample"]
    if sample["full_coefficient_reduction_completed"]:
        raise AssertionError("false degree-four completion claim")
    if sample["dense_uint8_rectangle_bytes"] != 52475072742:
        raise AssertionError("uint8 resource bound drift")
    if sample["dense_modular_double_rectangle_bytes"] != 419800581936:
        raise AssertionError("modular-double resource bound drift")
    print("PASS_SYSTEMATIC_MODULE_SEAL")


if __name__ == "__main__":
    main()
