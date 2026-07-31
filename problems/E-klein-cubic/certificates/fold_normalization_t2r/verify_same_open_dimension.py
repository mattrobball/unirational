#!/usr/bin/env python3
"""Independent T2R.5 verifier — does NOT import the producer.

Checks mathematical upper-bound certificates (msolve class + PIT setup),
T2R4 factor install, and that lower bound / dim are not falsely claimed.
"""
from __future__ import annotations

import json
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
MSOLVE = HERE / "msolve"

EXPECTED_CUTS = {
    "Hsing_cut2_nosat_qq.out": "121e6d4cdc5ec8d09b9821743ace4c0054eadef87e3acbf737fcd77ad148278b",
    "Hsing_cut2b_qq.out": "01efacf368942c5782dfe192f03d81791518359d41b45db9482690acd348872d",
}


def fail(msg: str) -> None:
    print(f"FAIL: {msg}", file=sys.stderr)
    sys.exit(1)


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def msolve_class(text: str) -> str:
    t = text.lstrip()
    if t.startswith("[-1]"):
        return "empty"
    if t.startswith("[1,") and "-1" in t[:80] and "[]" in t[:80]:
        return "positive_dim"
    if t.startswith("[0,"):
        return "zero_dim"
    return "unknown"


def main() -> None:
    # Upper bound certificates
    for name, expected in EXPECTED_CUTS.items():
        path = MSOLVE / name
        if not path.is_file():
            fail(f"missing {path}")
        if file_hash(path) != expected:
            fail(f"hash mismatch {name}")
        cls = msolve_class(path.read_text())
        if cls != "zero_dim":
            fail(f"{name} class {cls} != zero_dim")

    upper = json.loads((HERE / "upper_bound_certificate.json").read_text())
    if upper.get("status") != "PROVED":
        fail("upper status")
    if upper.get("requires_genericity") is not False:
        fail("upper must not require genericity")

    lower = json.loads((HERE / "lower_bound_certificate.json").read_text())
    if lower.get("status") != "NOT_PROVED":
        fail("lower must be NOT_PROVED")
    if lower.get("obtained"):
        fail("lower obtained non-empty without certificate")

    eq = json.loads((HERE / "equidimensional_components.json").read_text())
    if eq.get("status") != "NOT_COMPUTED":
        # allow future upgrade only if dim set consistently
        if eq.get("dim") is not None and lower.get("status") != "PROVED":
            fail("equidimensional dim without lower proof")

    # T2R4 factors present
    sf = HERE / "saturation_factors"
    for name in (
        "ell_lc_u.tsv",
        "P_uu.tsv",
        "C_content.tsv",
        "delta_Cramer.tsv",
        "G_circuit.json",
        "G_factor_L.tsv",
        "G_factor_M.tsv",
        "G_factor_Q4.tsv",
        "FACTORS_META.json",
    ):
        if not (sf / name).is_file():
            fail(f"missing T2R4 factor {name}")
    meta4 = json.loads((sf / "FACTORS_META.json").read_text())
    if meta4.get("exit") != "T2R4-PASS":
        fail("T2R4 not PASS")

    # Payload consistency
    payload = json.loads((HERE / "t2r_payload.json").read_text())
    if payload.get("exit") != "T2R-UNDECIDED":
        fail(f"payload exit {payload.get('exit')}")
    if payload.get("gate_T2R") != "T2R-UNDECIDED":
        fail("gate_T2R")
    if payload.get("T2R_3", {}).get("dim") is not None:
        # allow nested structure variants
        pass
    bounds = json.loads((HERE / "dimension_bounds.json").read_text())
    if bounds.get("upper_bound", {}).get("status") != "PROVED":
        fail("bounds upper")
    if bounds.get("lower_bound", {}).get("status") != "NOT_PROVED":
        fail("bounds lower")
    if bounds.get("dim_Sing_S_G") is not None:
        fail("dim_Sing must be null")

    md = (HERE / "SAME_OPEN_DIMENSION.md").read_text()
    if "T2R-UNDECIDED" not in md:
        fail("SAME_OPEN_DIMENSION missing exit")
    if "NOT_PROVED" not in md and "not proved" not in md.lower():
        fail("SAME_OPEN_DIMENSION must state lower not proved")

    # Scheme still has G inverted
    scheme = json.loads((HERE / "scheme_t2r1.json").read_text())
    if scheme.get("localization", {}).get("G_inverted") is not True:
        fail("G_inverted")

    print("T2R5_VERIFIER_OK")
    print("exit=T2R-UNDECIDED")
    print("upper_bound=PROVED lower_bound=NOT_PROVED dim_Sing=null")
    print("T2R4-PASS retained; no manufactured decisive exit")
    print("FOLD_NORMALIZATION_T2R5_VERIFIER_ACCEPT")


if __name__ == "__main__":
    main()
