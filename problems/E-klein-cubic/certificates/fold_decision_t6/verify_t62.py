#!/usr/bin/env python3
"""T6.2 independent verifier — binary R1 decision must not overclaim."""
from __future__ import annotations

import json
import sys
from hashlib import sha256
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
UPPER = ROOT / "certificates/fold_normalization_t2r/upper_bound_certificate.json"


def fail(msg: str) -> None:
    print("FAIL:", msg, file=sys.stderr)
    sys.exit(1)


def file_hash(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def msolve_class(text: str) -> str:
    t = text.lstrip()
    if t.startswith("[-1]"):
        return "empty"
    if t.startswith("[1,") and "-1" in t[:80]:
        return "positive_dim"
    if t.startswith("[0,"):
        return "zero_dim"
    return "unknown"


def main() -> None:
    for name in ("R1_DECISION.md", "r1_decision.json"):
        if not (HERE / name).is_file():
            fail(f"missing {name}")

    md = (HERE / "R1_DECISION.md").read_text()
    dec = json.loads((HERE / "r1_decision.json").read_text())

    if "T2R-UNDECIDED" not in md:
        fail("md exit")
    if dec.get("exit") != "T2R-UNDECIDED":
        fail("json exit")
    if dec.get("R1") is not None:
        fail("R1 must be null")
    if dec.get("dim_Sing_S_G") is not None:
        fail("dim_Sing must be null")
    if dec["upper_bound"]["status"] != "PROVED":
        fail("upper bound status")
    if dec["lower_bound"]["status"] != "NOT_PROVED":
        fail("lower bound must be NOT_PROVED")
    if dec["normal_certificate_dim_le_1"]["status"] != "NOT_OBTAINED":
        fail("normal cert")
    if dec["nonnormal_certificate_dim_eq_2"]["status"] != "NOT_OBTAINED":
        fail("nonnormal cert")

    # Must not claim affine section proves dim
    if "affine hyperplane" in md.lower() or "V2 §0" in md or "REPAIR" in md:
        pass
    else:
        fail("must reference V2/REPAIR ban on affine section dim proofs")

    forbidden = [
        "T2R-NORMAL",
        "T2R-NONNORMAL",
    ]
    # allowed only as labels of unattained exits
    if re_claim_decisive(md):
        fail("md claims decisive exit")

    # Upper bound artifact still present and zero_dim
    if not UPPER.is_file():
        fail("missing upper bound cert")
    ub = json.loads(UPPER.read_text())
    if ub.get("status") != "PROVED":
        fail("upper bound cert status")
    if ub.get("requires_genericity") is not False:
        fail("upper bound must not require genericity")
    t2r = ROOT / "certificates/fold_normalization_t2r/msolve"
    for cert in ub.get("certificates", []):
        art = t2r / Path(cert["artifact"]).name
        if not art.is_file():
            fail(f"missing {art}")
        if file_hash(art) != cert["sha256"]:
            fail(f"hash mismatch {art}")
        cls = msolve_class(art.read_text())
        if cls != "zero_dim":
            fail(f"{art} class {cls}")

    # Bottlenecks named
    bots = dec.get("bottlenecks", [])
    if "BOTTLENECK-T2R-EXACT-SAT-DIM" not in bots and "BOTTLENECK-T61-EXACT-FACTORWISE-SAT-DIM" not in bots:
        fail("missing core bottleneck")

    if dec.get("T6_3_status", "").startswith("NOT_STARTED") is False:
        if "NOT_STARTED" not in str(dec.get("T6_3_status")):
            fail("T6.3 must not have started")

    print("FOLD_DECISION_T62_VERIFIER_ACCEPT")
    print("exit=T2R-UNDECIDED R1=null dim_Sing=null upper<=2=PROVED lower=NOT_PROVED")


def re_claim_decisive(md: str) -> bool:
    # True if claims we proved NORMAL or NONNORMAL
    low = md.lower()
    if "exit: `t2r-normal`" in low or "exit: `t2r-nonnormal`" in low:
        return True
    if "**exit: `t2r-normal`**" in low or "**exit: `t2r-nonnormal`**" in low:
        return True
    # Our file says Exit: `T2R-UNDECIDED` which is fine
    if "proved normal" in low or "proved nonnormal" in low:
        return True
    return False


if __name__ == "__main__":
    main()
