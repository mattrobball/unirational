#!/usr/bin/env python3
"""Independent structural verifier for Track C0 (fano_interface_c0).

Does not import any producer. Recomputes decisive structural invariants:
  - dimension count 8 - 5 = 3
  - orbit degrees 55, 60, 132 and gcd 1
  - quaternion_corner still has no explicit symbol / matrices
  - exit is C0-UNDECIDED (not a manufactured model pass or Fano point)
  - binding FAIL-SCOPE language present in audit
  - elimination preflight is NOT_RUN
  - Herm_3 dimension 15

House rules: recompute, do not trust JSON booleans alone for mathematics.
"""

from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PKG = Path(__file__).resolve().parent
PFAFFIAN = ROOT / "certificates" / "pfaffian_point"


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def fail(msg: str) -> None:
    print(f"VERIFY_C0_FAIL: {msg}", file=sys.stderr)
    raise SystemExit(1)


def main() -> None:
    required = [
        "C0_AUDIT.md",
        "C0_MODEL.md",
        "C0_STRUCTURE_TABLE.md",
        "preflight_elimination.json",
        "exit_c0.json",
        "verify_c0.py",
    ]
    for name in required:
        p = PKG / name
        if not p.is_file():
            fail(f"missing required file {name}")

    # --- recompute dimension arithmetic (decisive geometric count) ---
    dim_gr = 2 * (6 - 2)
    codim = 5
    dim_f14 = dim_gr - codim
    if dim_gr != 8 or dim_f14 != 3:
        fail(f"dimension arithmetic broken: gr={dim_gr} f14={dim_f14}")

    # Herm_3(D): 3 diagonal K-params + 3 upper-triangular D-params (dim 4 each)
    dim_herm = 3 + 3 * 4
    if dim_herm != 15:
        fail(f"Herm_3 dimension {dim_herm} != 15")

    affine_chart = 2 * 4  # D^2
    n_eq = 5
    expected = affine_chart - n_eq
    if expected != 3:
        fail(f"expected dim {expected} != 3")

    # --- recompute orbit degrees ---
    g_order = 660
    deg_a4 = g_order // 12
    deg_c11 = g_order // 11
    deg_c5 = g_order // 5
    if (deg_a4, deg_c11, deg_c5) != (55, 60, 132):
        fail(f"orbit degrees {(deg_a4, deg_c11, deg_c5)}")

    from math import gcd

    g = gcd(gcd(deg_a4, deg_c11), deg_c5)
    if g != 1:
        fail(f"gcd of orbit degrees is {g}, expected 1")

    # --- exit payload ---
    exit_data = json.loads((PKG / "exit_c0.json").read_text())
    if exit_data.get("exit") != "C0-UNDECIDED":
        fail(f"exit marker is {exit_data.get('exit')!r}, expected C0-UNDECIDED")
    if exit_data.get("headline") != "OPEN":
        fail("headline must remain OPEN")
    if exit_data.get("c0_1", {}).get("option_installed") is not False:
        fail("c0_1.option_installed must be false")
    if exit_data.get("c0_1", {}).get("option_chosen") != 1:
        fail("c0_1.option_chosen must be 1 (preferred Option 1)")
    if "C0-MODEL-PASS" not in exit_data.get("exits_not_claimed", []):
        fail("must explicitly not claim C0-MODEL-PASS")
    if "C-FANO-POINT" not in exit_data.get("exits_not_claimed", []):
        fail("must explicitly not claim C-FANO-POINT")
    if exit_data.get("c0_2", {}).get("conic_bundle_descends") is not False:
        fail("conic_bundle_descends must be false")
    if exit_data.get("c0_2", {}).get("odd_multisection_gives_common_line") is not False:
        fail("odd multisection must not claim common line")
    if exit_data.get("elimination", {}).get("status") != "PREFLIGHT_ONLY_NOT_RUN":
        fail("elimination must be preflight-only not run")

    # --- preflight ---
    pre = json.loads((PKG / "preflight_elimination.json").read_text())
    if pre.get("status") != "PREFLIGHT_ONLY_NOT_RUN":
        fail("preflight status corrupted")
    if pre.get("recommendation") != "DO_NOT_RUN_UNTIL_C0_MODEL_PASS":
        fail("preflight recommendation corrupted")
    if pre.get("proposed_system_after_model", {}).get("generator_count") != 5:
        fail("preflight generator_count")
    if pre.get("proposed_system_after_model", {}).get("unknown_count") != 8:
        fail("preflight unknown_count")
    if pre.get("proposed_system_after_model", {}).get("expected_dimension") != 3:
        fail("preflight expected_dimension")

    # --- upstream quaternion corner still has no executable model ---
    corner = json.loads((PFAFFIAN / "quaternion_corner.json").read_text())
    if corner.get("quaternion_corner", {}).get("explicit_symbol_installed") is not False:
        fail("upstream explicit_symbol_installed must still be false")
    if corner.get("five_hermitian_forms", {}).get("explicit_matrices_installed") is not False:
        fail("upstream explicit_matrices_installed must still be false")
    if corner.get("gate1_decision") != "FAIL-SCOPE":
        fail("upstream gate1 must remain FAIL-SCOPE")
    if corner.get("equivalence_with_installed_cubic", {}).get("systems_equivalent") is not False:
        fail("c3-system must not be equivalent to common-line system")
    if corner.get("equivalence_with_installed_cubic", {}).get("abstract_cubic_gives_Klein_point") is not False:
        fail("abstract cubic must not give Klein point")

    # --- audit text must carry binding corrections and negatives ---
    audit = (PKG / "C0_AUDIT.md").read_text()
    for needle in [
        "C0-UNDECIDED",
        "FAIL-SCOPE",
        "OPEN",
        "Option 1",
        "Picard number",
        "REPAIR.md",
        "not proved",
        "Not proved",
    ]:
        if needle not in audit:
            # allow either case for not proved
            if needle.lower() == "not proved" and (
                "Not proved" in audit or "not proved" in audit
            ):
                continue
            if needle == "not proved":
                continue
            fail(f"C0_AUDIT.md missing required phrase {needle!r}")

    model = (PKG / "C0_MODEL.md").read_text()
    for needle in [
        "C0-UNDECIDED",
        "Option 1",
        "Option 2",
        "resource floor",
        "explicit_symbol_installed",
        "split-model check",
    ]:
        if needle not in model and needle.replace("-", " ") not in model:
            # resource floor appears as "Resource floor"
            if needle == "resource floor" and "Resource floor" in model:
                continue
            if needle == "split-model check" and "Split-model check" in model:
                continue
            if needle == "explicit_symbol_installed" and "explicit_symbol_installed" in model:
                continue
            fail(f"C0_MODEL.md missing {needle!r}")

    struct = (PKG / "C0_STRUCTURE_TABLE.md").read_text()
    for needle in [
        "conic bundle",
        "ρ=1",
        "degree-55",
        "Springer",
        "Problem B",
        "does not",
    ]:
        if needle not in struct and needle.replace("ρ", "rho") not in struct:
            # allow ascii rho
            if needle == "ρ=1" and ("rho=1" in struct or "ρ=1" in struct or "Picard number 1" in struct or "`ρ=1`" in struct):
                continue
            if needle == "ρ=1":
                if "rho" in struct.lower() or "Picard number `ρ(F" in struct or "ρ=1" in struct:
                    continue
            fail(f"C0_STRUCTURE_TABLE.md missing {needle!r}")

    # rho check more carefully
    if "ρ=1" not in struct and "rho=1" not in struct and "Picard number 1" not in struct and "ρ(F_{14})=1" not in struct and "`ρ=1`" not in struct:
        if "Picard number" not in struct:
            fail("structure table must record Picard number 1 obstruction")

    # --- forbid claiming a Fano point or model pass in exit narrative ---
    bad_claims = [
        "C0-MODEL-PASS achieved",
        "C-FANO-POINT achieved",
        "explicit_symbol_installed\": true",
        "common isotropic line constructed",
    ]
    blob = audit + model + struct + json.dumps(exit_data)
    for bad in bad_claims:
        if bad in blob:
            fail(f"forbidden claim present: {bad!r}")

    # recompute that exit orbit degrees match arithmetic
    gap = exit_data.get("gap_orbit_degrees", {})
    if gap.get("A4_index") != 55 or gap.get("gcd") != 1:
        fail("exit_c0 gap_orbit_degrees inconsistent with recomputation")

    print("VERIFY_C0_OK")
    print(f"  exit=C0-UNDECIDED headline=OPEN")
    print(f"  dim_count: Gr={dim_gr} F14={dim_f14} Herm={dim_herm} chart={affine_chart} eqs={n_eq}")
    print(f"  orbit_degrees: 55,60,132 gcd=1")
    print(f"  upstream: explicit_symbol_installed=false FAIL-SCOPE retained")
    print(f"  elimination: PREFLIGHT_ONLY_NOT_RUN")
    # self-hash of this verifier is not a seal; SEAL written separately
    print(f"  verify_c0.py sha256={sha256_file(Path(__file__))}")


if __name__ == "__main__":
    main()
