#!/usr/bin/env python3
"""Replay the finite delta-Rabinowitsch border/lift certificate for T111."""

from __future__ import annotations

import hashlib
import json
import re
import subprocess
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
EMITTER = HERE / "emit_t111_delta_rab_border.py"
SCRIPT = HERE / "verify_t111_delta_rab_border.sing"
LIFT = HERE / "t111_delta_rab_lift_matrix.sing"
OUTPUT = HERE / "verify_t111_delta_rab_border_result.json"
SINGULAR = "/opt/homebrew/bin/Singular"

EXPECTED = {
    "primitive": "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344",
    "delta": "7119b244997c188ee280e0b8d96cdebddedb49f9bd797578bf8ccfeeb9cf30c9",
}
PIVOTS = ("ZT", "YT", "BT", "Z2", "YZ", "BZ", "Y2", "BY", "B2", "T3")
BASIS = ("1", "B", "Y", "Z", "T", "T2")
EXPECTED_GB = (
    "ZT-7T2-16B-2Y-44Z+28T-13",
    "YT-7T2-26B-24Y-49Z+T+19",
    "BT+30T2-13B-47Y-24Z+22T+44",
    "Z2-42T2-37B-45Y+39Z+27T+2",
    "YZ-20T2-26B-21Y+36Z+49T+3",
    "BZ+41T2-35B+41Y+31Z-14T-39",
    "Y2-23T2+43B+17Y+30Z-T-1",
    "BY+12T2+22B+12Y+43Z+26T+5",
    "B2+15T2-14B-8Y-40Z+32T-4",
    "T3+3T2+20B-9Y-25Z+28T+50",
)


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    primitive = ROOT / "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"
    delta = ROOT / "certificates/fold_normalization_t2r/saturation_factors/delta_Cramer.tsv"
    assert sha(primitive) == EXPECTED["primitive"]
    assert sha(delta) == EXPECTED["delta"]

    emitted = subprocess.run(
        ["python3", str(EMITTER)], cwd=HERE.parent,
        text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        timeout=30, check=False,
    )
    assert emitted.returncode == 0, emitted.stdout
    checked = subprocess.run(
        [SINGULAR, "-q", str(SCRIPT)], cwd=HERE.parent,
        text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        timeout=60, check=False,
    )
    text = checked.stdout
    assert checked.returncode == 0, text[-4000:]
    assert "LIFT_IDENTITY=1" in text
    assert "DIM=0 VDIM=6 GSIZE=10" in text

    gb = tuple(re.findall(r"^G\[\d+\]=(.*)$", text, re.MULTILINE))
    assert gb == EXPECTED_GB, gb
    leads = tuple(re.findall(r"^_\[\d+\]=(.*)$", text, re.MULTILINE))
    assert leads == PIVOTS, leads
    degree_rows = re.findall(r"^(\d+) multiplier=(\d+) row=(\d+)$", text, re.MULTILINE)
    assert degree_rows == [
        *((str(i), "15", "20") for i in range(1, 10)),
        ("10", "16", "21"),
    ], degree_rows
    assert LIFT.is_file() and LIFT.stat().st_size > 500_000

    report = {
        "schema": "klein-t111-delta-rabinowitsch-border-lift-v1",
        "status": "PASS",
        "specialization": {"characteristic": 101, "A": 17, "u": 1},
        "localized_ideal": "(P,Pu,PA,PB,PY,PZ,T*delta-1)",
        "dimension": 0,
        "length": 6,
        "standard_monomial_basis": list(BASIS),
        "pivot_monomials": list(PIVOTS),
        "pivot_coefficient_product_mod_101": 1,
        "max_multiplier_degree": 16,
        "max_macaulay_row_degree": 21,
        "lift_identity_checked": True,
        "lift_term_counts": [
            [int(value) for value in row]
            for row in re.findall(r"^(\d+) (\d+) (\d+)$", text, re.MULTILINE)
        ],
        "input_sha256": {
            **EXPECTED,
            "emitter": sha(EMITTER),
            "singular_payload": sha(SCRIPT),
            "lift_matrix": sha(LIFT),
        },
        "generic_rank_conclusion": (
            "The exported lift rows and ten monic pivot columns select a Macaulay "
            "minor nonzero modulo 101 at (17,1). Hence its integral parameter-polynomial "
            "minor is nonzero over Q(A,u), and the generic delta-localized quotient is "
            "spanned by 1,B,Y,Z,T,T^2, so has length at most six."
        ),
        "theorem_boundary": (
            "This is the finite no-escape upper-bound certificate. Equality and primality "
            "use the separate exact irreducible degree-six RUR membership certificate."
        ),
    }
    OUTPUT.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print("T111_DELTA_RAB_BORDER_LIFT_PASS")
    print(json.dumps({k: report[k] for k in (
        "dimension", "length", "standard_monomial_basis", "pivot_monomials",
        "max_multiplier_degree", "max_macaulay_row_degree",
    )}, sort_keys=True))


if __name__ == "__main__":
    main()
