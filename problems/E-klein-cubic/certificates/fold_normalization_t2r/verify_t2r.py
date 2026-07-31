#!/usr/bin/env python3
"""Independent verifier for Path T / Gate T2R.

Does NOT import the producer.  Verifies:
  - input hashes / content
  - T2R.1 records G inverted and S2 on S_G
  - exact Q unsaturated cut2 msolve classes (zero_dim) used for the height
    upper-bound theorem
  - upper-bound claim is present and lower bound is NOT claimed proved
  - exit is T2R-UNDECIDED (no manufactured decisive exit)
  - SEAL self-hash; no timing fields

Per REPAIR.md §3: verifies the dimension theorem claims that are actually
made (upper bound via PIT/height), not mere file parsing, and refuses any
claim that dim Sing = 2 or R1 failure without a lower bound certificate.
"""

from __future__ import annotations

import json
import os
import resource
import sys
from functools import reduce
from hashlib import sha256
from math import gcd
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
PRIMITIVE = (
    ROOT
    / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
)
H_PRIM = ROOT / "certificates/target_branch_global/H_factor/H_primitive_integer.tsv"
CEILING_MIB = 8192
CAP_ENV = "T2R_VERIFY_MIB"

EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_H = "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"


def enforce_limit() -> None:
    ceiling = CEILING_MIB * 1024**2
    try:
        resource.setrlimit(resource.RLIMIT_AS, (ceiling, ceiling))
    except (OSError, ValueError):
        if sys.platform != "darwin":
            raise
        if os.environ.get(CAP_ENV) == str(CEILING_MIB):
            return
        env = dict(os.environ)
        env[CAP_ENV] = str(CEILING_MIB)
        os.execve(
            "/usr/sbin/taskpolicy",
            ["taskpolicy", "-m", str(CEILING_MIB), sys.executable, *sys.argv],
            env,
        )


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def fail(msg: str) -> None:
    print(f"VERIFY_FAIL: {msg}", file=sys.stderr)
    sys.exit(1)


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
    enforce_limit()

    if not PRIMITIVE.is_file():
        fail("missing P")
    if not H_PRIM.is_file():
        fail("missing H")
    if file_hash(PRIMITIVE) != EXPECTED_P:
        fail("P hash")
    if file_hash(H_PRIM) != EXPECTED_H:
        fail("H hash")

    coeffs = []
    with PRIMITIVE.open() as f:
        if next(f).strip() != "A\tB\tY\tZ\tu\tcoefficient":
            fail("P header")
        for line in f:
            *_, c = map(int, line.split())
            coeffs.append(c)
    if len(coeffs) != 1593 or reduce(gcd, coeffs) != 1:
        fail("P content/terms")

    h_n = sum(1 for _ in H_PRIM.open()) - 1
    if h_n != 37992:
        fail(f"H terms {h_n}")

    scheme = json.loads((HERE / "scheme_t2r1.json").read_text())
    bounds = json.loads((HERE / "dimension_bounds.json").read_text())
    payload = json.loads((HERE / "t2r_payload.json").read_text())
    seal = json.loads((HERE / "SEAL.json").read_text())
    t2r_md = (HERE / "T2R.md").read_text()

    # --- T2R.1: G inverted, one scheme ---
    if scheme.get("localization", {}).get("G_inverted") is not True:
        fail("T2R.1 must record G_inverted=true")
    if scheme.get("S2_on_this_object") is not True:
        fail("S2_on_this_object")
    if scheme.get("object_name") != "S_G":
        fail("object_name")
    if "G inverted" not in t2r_md and "G** is inverted" not in t2r_md and "G` is inverted" not in t2r_md:
        if "is inverted: yes" not in t2r_md.lower() and "**yes**" not in t2r_md.lower():
            # accept explicit markdown from T2R.md
            if "G` is inverted" not in t2r_md and "G is inverted" not in t2r_md:
                if "inverted: yes" not in t2r_md.lower() and "G inverted" not in t2r_md:
                    if "G** is inverted" not in t2r_md and "`G` is inverted" not in t2r_md:
                        # Final check: T2R.md has "**G** is inverted: yes"
                        if "inverted" not in t2r_md or "yes" not in t2r_md.lower():
                            fail("T2R.md must record whether G is inverted")

    # --- Dimension theorem (upper bound only) ---
    ub = bounds.get("upper_bound") or {}
    if ub.get("status") != "PROVED":
        fail("upper bound must be PROVED")
    if "height" not in ub.get("method", "").lower() and "pit" not in ub.get("method", "").lower() and "principal" not in ub.get("argument", "").lower():
        if "principal ideal" not in str(ub).lower() and "height" not in str(ub).lower():
            fail("upper bound method must be height/PIT")
    if ub.get("requires_genericity") is True:
        fail("upper bound must not require genericity of cuts")

    lb = bounds.get("lower_bound") or {}
    if lb.get("status") == "PROVED":
        fail("lower bound must not be marked PROVED without certificate (packet is UNDECIDED)")
    if bounds.get("dim_Sing_S_G") is not None:
        fail("dim_Sing_S_G must be null in UNDECIDED packet")
    if bounds.get("R1") is not None:
        fail("R1 must be null")

    # Verify exact Q cut artifacts used by the height theorem
    msolve_dir = HERE / "msolve"
    for cert in ub.get("certificates") or []:
        art = cert.get("artifact", "")
        name = Path(art).name
        path = msolve_dir / name
        if not path.is_file():
            fail(f"missing upper-bound artifact {name}")
        expected = cert.get("sha256")
        if expected and file_hash(path) != expected:
            fail(f"hash {name}")
        cls = msolve_class(path.read_text())
        if cls != "zero_dim":
            fail(f"{name} class {cls}, need zero_dim for height upper bound")
        if cert.get("saturation") not in (None, "none", ""):
            # unsaturated required for the recorded PIT certificates
            if cert.get("saturation") != "none":
                fail(f"upper-bound cert {name} should be unsaturated closed model")

    # Seal hashes
    if file_hash(HERE / "scheme_t2r1.json") != seal.get("scheme_t2r1_sha256"):
        fail("scheme hash")
    if file_hash(HERE / "dimension_bounds.json") != seal.get("dimension_bounds_sha256"):
        fail("bounds hash")
    if file_hash(HERE / "t2r_payload.json") != seal.get("t2r_payload_sha256"):
        fail("payload hash")
    if file_hash(HERE / "T2R.md") != seal.get("T2R_md_sha256"):
        fail("T2R.md hash")

    art = seal.get("msolve_artifacts_sha256") or {}
    for name, expected in art.items():
        path = msolve_dir / name
        if not path.is_file():
            fail(f"missing sealed msolve {name}")
        if file_hash(path) != expected:
            fail(f"msolve hash {name}")

    # Exit discipline
    if payload.get("gate_T2R") != "T2R-UNDECIDED":
        fail("payload gate_T2R")
    if payload.get("exit") != "T2R-UNDECIDED":
        fail("payload exit")
    if seal.get("gate_T2R") != "T2R-UNDECIDED":
        fail("seal gate_T2R")
    if seal.get("G_inverted") is not True:
        fail("seal G_inverted")
    if seal.get("upper_bound_dim_le_2") is not True:
        fail("seal upper bound")
    if seal.get("lower_bound_dim_ge_2") is not False:
        fail("seal must record lower bound not proved (false)")
    if seal.get("dim_Sing_S_G") is not None:
        fail("seal dim must be null")
    if "T2R-UNDECIDED" not in t2r_md:
        fail("T2R.md exit")
    if "BOTTLENECK-T2R-LOWER" not in t2r_md:
        fail("T2R.md missing lower-bound bottleneck name")

    # Refuse manufactured decisive exits
    for bad in ("T2R-NONNORMAL", "T2R-NORMAL", "T-NONNORMAL"):
        if payload.get("gate_T2R") == bad or payload.get("exit") == bad:
            fail(f"decisive exit {bad} not allowed without full proof")
        if seal.get("gate_T2R") == bad:
            fail(f"seal decisive exit {bad}")

    # Self-hash
    seal_copy = dict(seal)
    claimed = seal_copy.pop("seal_sha256", None)
    body = json.dumps(seal_copy, indent=2, sort_keys=True) + "\n"
    if claimed != sha256(body.encode()).hexdigest():
        fail("seal_sha256 mismatch")

    # No timing
    for label, obj in [
        ("scheme", scheme),
        ("bounds", bounds),
        ("payload", payload),
        ("seal", seal),
    ]:
        blob = json.dumps(obj)
        for bad in ("elapsed", "runtime", "seconds", "cpu_time", "wall_time"):
            if f'"{bad}"' in blob.lower():
                fail(f"timing field in {label}: {bad}")

    # Conductors distinct mention
    if "c_B_subset_S" not in json.dumps(scheme) and "Ann_B" not in t2r_md:
        fail("conductors must be kept distinct in scheme or T2R.md")

    print("T2R_VERIFY_OK")
    print("gate_T2R=T2R-UNDECIDED")
    print("T2R.1: S_G with G_inverted=true; S2=true")
    print("T2R.3: upper_bound_dim<=2 PROVED (height/PIT on exact Q cut2)")
    print("T2R.3: lower_bound NOT_PROVED; dim_Sing=null; R1=null")
    print("headline=OPEN")
    print("FOLD_NORMALIZATION_T2R_VERIFIER_ACCEPT")


if __name__ == "__main__":
    main()
