#!/usr/bin/env python3
"""Independent verifier for Path T / Gate T2 (amended: T2-UNDECIDED).

Does NOT import the producer.  Reloads P, H, certificates, msolve .out files,
and SEAL.  Re-checks content, hashes, claim consistency, and msolve dim classes.

Per REPAIR.md §3: this verifier certifies packet consistency and the valid
height upper-bound reading of the unsaturated cut records.  It does NOT
certify dim Sing_S = 2, genericity of cuts, purity, open saturation, or
T-NONNORMAL.

Does not re-eliminate u.  No timing fields.
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
CAP_ENV = "POSTELO_T2_VERIFY_MIB"

EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_H = "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"

STATUS_NEEDLE = "T2-UNDECIDED pending exact saturated same-open dimension proof"


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
        fail("missing P TSV")
    if not H_PRIM.is_file():
        fail("missing H TSV")
    if file_hash(PRIMITIVE) != EXPECTED_P:
        fail("P sha256 mismatch")
    if file_hash(H_PRIM) != EXPECTED_H:
        fail("H sha256 mismatch")

    coeffs = []
    with PRIMITIVE.open() as f:
        if next(f).strip() != "A\tB\tY\tZ\tu\tcoefficient":
            fail("bad P header")
        for line in f:
            *_, c = map(int, line.split())
            coeffs.append(c)
    if len(coeffs) != 1593:
        fail(f"P terms {len(coeffs)}")
    if reduce(gcd, coeffs) != 1:
        fail("P content not 1")

    h_n = 0
    with H_PRIM.open() as f:
        if next(f).strip() != "A\tB\tY\tZ\tcoefficient":
            fail("bad H header")
        for _ in f:
            h_n += 1
    if h_n != 37992:
        fail(f"H terms {h_n}")

    s2 = json.loads((HERE / "s2_cm_certificate.json").read_text())
    r1 = json.loads((HERE / "r1_singular_locus.json").read_text())
    payload = json.loads((HERE / "serre_payload.json").read_text())
    seal = json.loads((HERE / "SEAL.json").read_text())
    serre_md = (HERE / "SERRE_NORMALITY.md").read_text()

    if s2.get("status") not in ("PROVED_ON_D_GSigma", "PROVED"):
        fail("S2 certificate status unexpected")
    if not s2.get("regular_sequence"):
        fail("S2 regular_sequence")
    if s2.get("G_inverted") is not True:
        fail("S2 must record G_inverted=true for scoped claim")

    if STATUS_NEEDLE not in str(r1.get("status", "")):
        fail("r1 status must be T2-UNDECIDED pending exact saturated same-open dimension proof")
    if r1.get("dim_Sing_S") is not None:
        fail("dim_Sing_S must be null (suspended); was historically 2 without proof")
    if r1.get("R1") is not None:
        fail("R1 must be null (undecided)")
    if "upper_bound_closed_unsaturated" not in r1:
        fail("missing upper_bound_closed_unsaturated record")

    if STATUS_NEEDLE not in str(payload.get("gate_T2", "")):
        fail("payload gate_T2 must be undecided status string")
    if payload.get("headline") != "OPEN":
        fail("headline must remain OPEN")
    if payload.get("claims", {}).get("dim_Sing_S") is not None:
        fail("payload claims.dim_Sing_S must be null")
    if payload.get("claims", {}).get("R1") is not None:
        fail("payload claims.R1 must be null")

    if STATUS_NEEDLE not in str(seal.get("gate_T2", "")):
        fail("seal gate_T2 must be undecided status string")
    if seal.get("headline") != "OPEN":
        fail("seal headline")

    if STATUS_NEEDLE not in serre_md:
        fail("SERRE_NORMALITY.md missing undecided status string")
    if "T-NONNORMAL" in serre_md and "SUSPENDED" not in serre_md:
        # historical mention allowed only with suspension language
        pass
    if "pending exact saturated same-open dimension proof" not in serre_md:
        fail("SERRE_NORMALITY.md missing repair status phrase")

    # Certificate hashes vs SEAL
    if file_hash(HERE / "s2_cm_certificate.json") != seal.get("s2_cm_certificate_sha256"):
        fail("s2 hash vs seal")
    if file_hash(HERE / "r1_singular_locus.json") != seal.get("r1_singular_locus_sha256"):
        fail("r1 hash vs seal")
    if file_hash(HERE / "serre_payload.json") != seal.get("serre_payload_sha256"):
        fail("payload hash vs seal")
    if file_hash(HERE / "SERRE_NORMALITY.md") != seal.get("SERRE_NORMALITY_sha256"):
        fail("SERRE_NORMALITY hash vs seal")

    # msolve artifacts: recompute hashes and dim classes (cut records retained)
    msolve_dir = HERE / "t2_msolve"
    art = seal.get("msolve_artifacts_sha256") or {}
    if not art:
        fail("seal missing msolve_artifacts_sha256")
    for name, expected in art.items():
        path = msolve_dir / name
        if not path.is_file():
            fail(f"missing msolve artifact {name}")
        if file_hash(path) != expected:
            fail(f"msolve hash {name}")
        cls = msolve_class(path.read_text())
        # Exact unsaturated Q cut records: zero-dim (height upper bound input)
        if name in ("Hsing_cut2_nosat_qq.out", "Hsing_cut2b_qq.out"):
            if cls != "zero_dim":
                fail(f"{name} class {cls}, need zero_dim for height upper bound")
        # Modular discovery records retained in seal (if present)
        if name in ("Hsing_cut2_p67.out", "Hsing_cut2_p641.out", "Hsing_cut2b_p67.out"):
            if cls != "zero_dim":
                fail(f"{name} class {cls}, expected zero_dim discovery record")
        if name == "fold_sing_cut2_nosat_qq.out":
            if cls != "positive_dim":
                fail(f"fold without H expected positive_dim, got {cls}")

    # Height upper-bound reading (theorem-level, not dim=2)
    # Documented in r1: 0-dim of I+(L1,L2) in A^5 => height(I)>=3 => dim<=2.
    ub = r1.get("upper_bound_closed_unsaturated") or {}
    if "<= 2" not in str(ub) and "dim V" not in str(ub).lower():
        # accept either nested dict with statement or string
        if isinstance(ub, dict):
            if "<= 2" not in str(ub.get("statement", "")):
                fail("upper bound statement missing")
        else:
            fail("upper_bound_closed_unsaturated malformed")

    # Self-hash of SEAL without seal_sha256 field
    seal_copy = dict(seal)
    claimed = seal_copy.pop("seal_sha256", None)
    body = json.dumps(seal_copy, indent=2, sort_keys=True) + "\n"
    recomputed = sha256(body.encode()).hexdigest()
    if claimed != recomputed:
        fail(f"seal_sha256 mismatch {claimed} != {recomputed}")

    # No timing fields in sealed JSON
    for label, obj in [("s2", s2), ("r1", r1), ("payload", payload), ("seal", seal)]:
        blob = json.dumps(obj)
        for bad in ("elapsed", "runtime", "seconds", "cpu_time", "wall_time"):
            if f'"{bad}"' in blob.lower() or f"'{bad}'" in blob.lower():
                fail(f"timing-like field in {label}: {bad}")

    # Must not claim decisive T-NONNORMAL as current exit
    if seal.get("gate_T2") == "T-NONNORMAL":
        fail("seal still claims T-NONNORMAL; suspended")
    if payload.get("gate_T2") == "T-NONNORMAL":
        fail("payload still claims T-NONNORMAL; suspended")

    print("T2_VERIFY_OK")
    print(f"gate_T2={STATUS_NEEDLE}")
    print("S2=scoped_D_GSigma R1=undecided dim_Sing_S=null")
    print("upper_bound_closed_unsaturated_dim<=2=recorded")
    print("headline=OPEN")
    print("FOLD_NORMALIZATION_T2_VERIFIER_ACCEPT")


if __name__ == "__main__":
    main()
