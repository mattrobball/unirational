#!/usr/bin/env python3
"""Independent verifier for the (A_empty) orbit-code packet.

Does NOT import any producer.  Checks documents, JSON contracts, integer
index arithmetic, GAP orbit facts (if gap is available), and SEAL updates.
Never claims (A_empty) proved or N-A.
"""
from __future__ import annotations

import hashlib
import json
import re
import subprocess
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
GAP = Path("/opt/homebrew/Caskroom/miniforge/base/bin/gap")
PY = Path("/opt/homebrew/bin/python3")

REQUIRED_FILES = [
    "A_EMPTY.md",
    "vz_power_basis.md",
    "vz_power_basis.json",
    "orbit_code.md",
    "orbit_code.json",
    "orbit_code.g",
    "verify_a_empty.py",
    "SEAL.json",
    "field_algebra.json",
    "marked_point.json",
    "krylov_incidence.json",
    "structural_collapse.json",
]


def sha256_file(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 16), b""):
            h.update(chunk)
    return h.hexdigest()


def read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def main() -> int:
    errors: list[str] = []

    # --- presence ---
    for rel in REQUIRED_FILES:
        if not (HERE / rel).is_file():
            errors.append(f"missing {rel}")

    # --- sealed A2: expansion still false ---
    fa = json.loads(read(HERE / "field_algebra.json"))
    mp = json.loads(read(HERE / "marked_point.json"))
    if fa["presentation"].get("mu_coefficients_expanded_in_invariants") is not False:
        errors.append("field_algebra must still report mu not expanded")
    if mp["coordinates"].get("expanded_coefficients_in_F") is not False:
        errors.append("marked_point must still report coordinates not expanded")
    if mp["V_Z"]["dimension"] != 4:
        errors.append("dim V_Z must be 4")
    if fa["degree"] != 55:
        errors.append("deg L/F must be 55")

    # --- vz_power_basis contract ---
    vzj = json.loads(read(HERE / "vz_power_basis.json"))
    if vzj["expansion_status"] != "NOT_AVAILABLE":
        errors.append("Task 1 must report expansion NOT_AVAILABLE")
    if "SCHUR_KRYLOV_VZ_POWER_BASIS_NOT_EXPANDED" not in read(HERE / "vz_power_basis.md"):
        errors.append("vz_power_basis.md missing terminal marker")
    if vzj.get("terminal_marker") != "SCHUR_KRYLOV_VZ_POWER_BASIS_NOT_EXPANDED":
        errors.append("vz_power_basis.json marker mismatch")

    # --- orbit_code contract ---
    ocj = json.loads(read(HERE / "orbit_code.json"))
    if ocj["group"]["index"] != 55:
        errors.append("orbit index must be 55")
    if ocj["group"]["H_maximal"] is not True:
        errors.append("H must be maximal")
    if ocj["group"]["Aut_L_F"] != 1:
        errors.append("Aut(L/F) must be 1")
    if ocj["subdegrees"] != [1, 3, 3, 6, 6, 6, 6, 12, 12]:
        errors.append("subdegrees mismatch")
    if ocj["subdegrees_are_F_splitting_of_L"] is not False:
        errors.append("subdegrees must not be advertised as F-splitting")
    if sum(ocj["subdegrees"]) != 55:
        errors.append("subdegrees must sum to 55")
    degs = ocj["permutation_module"]["irr_degrees_of_G"]
    mult = ocj["permutation_module"]["decomposition_multiplicities"]
    if sum(m * d for m, d in zip(mult, degs)) != 55:
        errors.append("perm module decomp does not sum to 55")
    if ocj["Krylov"]["index_s"] != 34:
        errors.append("Krylov index must be 34")
    if ocj["Krylov"]["block_matrix_B34_shape"] != [55, 140]:
        errors.append("B34 shape must be 55x140")
    if ocj["Krylov"]["sealed_phi_tau_shape"] != [140, 55]:
        errors.append("phi_tau shape must be 140x55")
    if ocj["Krylov"]["equivalent_to_incidence_empty_on_primitive_locus"] is not True:
        errors.append("orbit_code must record B34/incidence equivalence")
    if "SCHUR_KRYLOV_ORBIT_CODE_FORMULATED_A_EMPTY_UNDECIDED" not in read(
        HERE / "orbit_code.md"
    ):
        errors.append("orbit_code.md missing terminal marker")

    # --- index arithmetic (Task 3) ---
    # U_tau dim 20 (powers 0..19); L dim 55; max s with 20+s < 55 is s=34
    u_dim = 20
    n = 55
    s = 34
    if u_dim + s != 54:
        errors.append("20+34 must be 54")
    if u_dim + s >= n:
        errors.append("index 34 must force ambient power span proper")
    if u_dim + (s + 1) != n:
        errors.append("s+1=35 must equal dim(L/U)=35")
    if 4 * (s + 1) != 140:
        errors.append("4*(34+1) must be 140")
    if n - u_dim != s + 1:
        errors.append("dim(L/U_tau) must equal 35 = 34+1")

    # sealed krylov / collapse shapes agree
    ki = json.loads(read(HERE / "krylov_incidence.json"))
    sc = json.loads(read(HERE / "structural_collapse.json"))
    if ki["incidence"]["matrix_M"]["shape"] != [55, 24]:
        errors.append("sealed M shape drift")
    if sc["minimal_irreducible_system"]["structured_matrix"]["shape"] != [140, 55]:
        errors.append("sealed phi_tau shape drift")

    # --- A_EMPTY.md markers and non-claims ---
    atext = read(HERE / "A_EMPTY.md")
    required_patterns = [
        (r"A_EMPTY_UNDECIDED", "A_EMPTY_UNDECIDED"),
        (r"SCHUR_KRYLOV_A_EMPTY_UNDECIDED_HEADLINE_OPEN", "terminal marker"),
        (r"A_empty|A_\{\\mathrm\{empty\}\}", "(A_empty) statement"),
        (r"not.*headline", "non-headline boundary"),
        (r"N-A|N\\text\{-\}A", "N-A boundary"),
    ]
    for pat, label in required_patterns:
        if not re.search(pat, atext):
            errors.append(f"A_EMPTY.md missing {label}")

    if "A_EMPTY_PROVED" in atext and re.search(
        r"A_EMPTY_PROVED\s*\*\*.*taken", atext
    ):
        errors.append("must not claim A_EMPTY_PROVED taken")
    # explicit non-claims
    if "not taken" not in atext.lower() and "NOT taken" not in atext:
        # table uses **not taken**
        if "not taken" not in atext:
            errors.append("A_EMPTY.md should record PROVED/REFUTED not taken")

    # must not claim N-A affirmatively as proved
    if re.search(r"N-A\s+claimed:\s*yes", atext, re.I):
        errors.append("N-A must not be claimed")

    # specialness warning present
    if "planted" not in atext.lower() and "arbitrary" not in atext.lower():
        errors.append("A_EMPTY.md should attack general-4-plane arguments")

    # --- GAP orbit script (if available) ---
    gap_script = HERE / "orbit_code.g"
    if GAP.is_file():
        proc = subprocess.run(
            [str(GAP), "-q", "-b", str(gap_script)],
            cwd=str(ROOT),
            capture_output=True,
            text=True,
            timeout=120,
        )
        gout = proc.stdout + proc.stderr
        if proc.returncode != 0:
            errors.append(f"GAP orbit_code.g exit {proc.returncode}: {gout[-500:]}")
        if "ORBIT_CODE_GAP_OK" not in gout:
            errors.append("GAP missing ORBIT_CODE_GAP_OK")
        if "H_maximal=true" not in gout:
            errors.append("GAP did not confirm H maximal")
        if "[ 1, 3, 3, 6, 6, 6, 6, 12, 12 ]" not in gout and (
            "subdegrees=[ 1, 3, 3, 6, 6, 6, 6, 12, 12 ]" not in gout
        ):
            # GAP prints with spaces after commas
            if "1, 3, 3, 6, 6, 6, 6, 12, 12" not in gout:
                errors.append("GAP subdegrees mismatch")
    else:
        errors.append(f"GAP not found at {GAP}")

    # --- SEAL.json contract for this exit ---
    seal = json.loads(read(HERE / "SEAL.json"))
    if seal.get("headline") != "OPEN":
        errors.append("SEAL headline must be OPEN")
    if seal.get("N_A_claimed") is not False:
        errors.append("SEAL must not claim N-A")
    if seal.get("P_A_claimed") is not False:
        errors.append("SEAL must not claim P-A")
    a_empty = seal.get("A_empty") or seal.get("gates", {}).get("A_empty")
    # accept either nested gates or top-level
    exit_val = None
    if isinstance(seal.get("A_empty"), dict):
        exit_val = seal["A_empty"].get("decision_exit")
    if exit_val is None:
        exit_val = seal.get("A_empty_decision_exit")
    if exit_val is None and "gates" in seal:
        exit_val = seal["gates"].get("A_empty")
    if exit_val != "A_EMPTY_UNDECIDED":
        errors.append(f"SEAL A_empty exit must be A_EMPTY_UNDECIDED, got {exit_val!r}")

    # deliverable hashes present for new files
    dsha = seal.get("deliverable_sha256", {})
    for rel in [
        "A_EMPTY.md",
        "vz_power_basis.md",
        "vz_power_basis.json",
        "orbit_code.md",
        "orbit_code.json",
        "orbit_code.g",
        "verify_a_empty.py",
    ]:
        if rel not in dsha:
            errors.append(f"SEAL missing hash for {rel}")
            continue
        actual = sha256_file(HERE / rel)
        if dsha[rel] != actual:
            errors.append(f"SEAL hash mismatch {rel}")

    # self-hash
    seal_obj = json.loads(read(HERE / "SEAL.json"))
    claimed = seal_obj.pop("seal_sha256_self", None)
    canonical = json.dumps(seal_obj, indent=2, sort_keys=True) + "\n"
    actual_self = hashlib.sha256(canonical.encode("utf-8")).hexdigest()
    if claimed != actual_self:
        errors.append(f"SEAL self-hash mismatch {claimed} != {actual_self}")

    # forbidden files not edited — existence check only
    for forbidden in ["HANDOFF.md", "RESOLUTION.md", "CURRENT_PATHS.md", "SPEC.md"]:
        if not (ROOT / forbidden).is_file():
            errors.append(f"forbidden path missing unexpectedly: {forbidden}")

    if errors:
        print("VERIFY_A_EMPTY_FAIL")
        for e in errors:
            print(" ERROR:", e)
        return 1

    print("A_EMPTY_INDEX_ARITHMETIC_OK")
    print("A_EMPTY_VZ_NOT_EXPANDED_OK")
    print("A_EMPTY_ORBIT_CODE_OK")
    print("A_EMPTY_SEAL_OK")
    print("SCHUR_KRYLOV_A_EMPTY_UNDECIDED")
    print("HEADLINE_OPEN")
    print("N_A_NOT_CLAIMED")
    print("SCHUR_KRYLOV_A_EMPTY_UNDECIDED_HEADLINE_OPEN")
    return 0


if __name__ == "__main__":
    sys.exit(main())
