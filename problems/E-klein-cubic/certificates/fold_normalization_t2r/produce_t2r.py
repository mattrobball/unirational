#!/usr/bin/env python3
"""Path T / Gate T2R producer — same-open saturated singular dimension.

Exit: T2R-UNDECIDED.
Does not import the verifier.  No re-elimination of u for H.
No timing fields.  Self-hashes after last payload byte.
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
MSOLVE = HERE / "msolve"
CEILING_MIB = 8192
CAP_ENV = "T2R_PRODUCER_MIB"

EXPECTED_P = "921816025f014da4667c53aa64dddf0983e575d3afa907f4e3f821509068c344"
EXPECTED_H = "b727ee2f004f6b237881ff1c933f0148420727f5e76a938916759feb6979d501"

# Portable cut records (exact Q unsaturated + modular discovery)
EXPECTED_MSOLVE = {
    "Hsing_cut2_nosat_qq.out": "121e6d4cdc5ec8d09b9821743ace4c0054eadef87e3acbf737fcd77ad148278b",
    "Hsing_cut2b_qq.out": "01efacf368942c5782dfe192f03d81791518359d41b45db9482690acd348872d",
    "Hsing_hist_sat_cut2A_p67.out": "5ebf0004a840993562bc66bcf168ec58988845c78944b9df4fab0418dcafdf88",
    "Hsing_hist_sat_cut2A_p641.out": "866deb4a72e4d539c6362ca375ecf1bce289de35598b596f7b8939f66c659467",
}


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

    assert PRIMITIVE.is_file() and H_PRIM.is_file()
    assert file_hash(PRIMITIVE) == EXPECTED_P
    assert file_hash(H_PRIM) == EXPECTED_H

    coeffs = []
    with PRIMITIVE.open() as f:
        assert next(f).strip() == "A\tB\tY\tZ\tu\tcoefficient"
        for line in f:
            *_, c = map(int, line.split())
            coeffs.append(c)
    assert len(coeffs) == 1593
    assert reduce(gcd, coeffs) == 1

    h_n = 0
    with H_PRIM.open() as f:
        assert next(f).strip() == "A\tB\tY\tZ\tcoefficient"
        for _ in f:
            h_n += 1
    assert h_n == 37992

    msolve_hashes = {}
    for name, expected in EXPECTED_MSOLVE.items():
        path = MSOLVE / name
        assert path.is_file(), f"missing {path}"
        h = file_hash(path)
        assert h == expected, f"hash mismatch {name}"
        msolve_hashes[name] = h
        cls = msolve_class(path.read_text())
        if "nosat_qq" in name or name == "Hsing_cut2b_qq.out":
            assert cls == "zero_dim", name
        if "sat" in name or "hist_sat" in name:
            assert cls == "zero_dim", name

    # Optional discovery artifacts (hashed if present)
    for name in ("Hsing_sat_lcPuu_cut2A_p67.out", "Hsing_nosat_cut2A_p67.out"):
        path = MSOLVE / name
        if path.is_file():
            msolve_hashes[name] = file_hash(path)
            assert msolve_class(path.read_text()) == "zero_dim", name

    scheme = json.loads((HERE / "scheme_t2r1.json").read_text())
    bounds = json.loads((HERE / "dimension_bounds.json").read_text())
    payload = json.loads((HERE / "t2r_payload.json").read_text())
    t2r_md = HERE / "T2R.md"

    assert scheme.get("localization", {}).get("G_inverted") is True
    assert bounds["upper_bound"]["status"] == "PROVED"
    assert bounds["lower_bound"]["status"] == "NOT_PROVED"
    assert bounds.get("dim_Sing_S_G") is None
    assert payload.get("gate_T2R") == "T2R-UNDECIDED"
    assert payload.get("exit") == "T2R-UNDECIDED"
    md = t2r_md.read_text()
    assert "T2R-UNDECIDED" in md
    assert "G is inverted: yes" in md

    sources = {
        "tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv": EXPECTED_P,
        "certificates/target_branch_global/H_factor/H_primitive_integer.tsv": EXPECTED_H,
    }
    for name, h in msolve_hashes.items():
        sources[f"certificates/fold_normalization_t2r/msolve/{name}"] = h

    seal = {
        "schema": "klein-cubic-T2R-seal-v1",
        "headline": "OPEN",
        "gate_T1": "T-BIRATIONAL",
        "gate_T2R": "T2R-UNDECIDED",
        "G_inverted": True,
        "upper_bound_dim_le_2": True,
        "lower_bound_dim_ge_2": False,
        "dim_Sing_S_G": None,
        "R1": None,
        "T2R_md_sha256": file_hash(t2r_md),
        "scheme_t2r1_sha256": file_hash(HERE / "scheme_t2r1.json"),
        "dimension_bounds_sha256": file_hash(HERE / "dimension_bounds.json"),
        "t2r_payload_sha256": file_hash(HERE / "t2r_payload.json"),
        "sources_sha256": sources,
        "msolve_artifacts_sha256": msolve_hashes,
        "repair_reference": "REPAIR.md Part I §§1-6",
        "bottlenecks": [
            "BOTTLENECK-T2R-LOWER",
            "BOTTLENECK-T2R-FULL-SAT",
            "BOTTLENECK-T2R-RESOURCE",
        ],
        "terminal_marker": "FOLD_NORMALIZATION_T2R_PRODUCER_SEALED",
    }
    body = json.dumps(seal, indent=2, sort_keys=True) + "\n"
    seal["seal_sha256"] = sha256(body.encode()).hexdigest()
    (HERE / "SEAL.json").write_text(json.dumps(seal, indent=2, sort_keys=True) + "\n")

    print("T2R_PRODUCER_OK")
    print("gate_T2R=T2R-UNDECIDED")
    print("G_inverted=true S2=true R1=null dim_Sing=null")
    print("upper_bound_dim_le_2=PROVED lower_bound=NOT_PROVED")
    print("FOLD_NORMALIZATION_T2R_PRODUCER_SEALED")


if __name__ == "__main__":
    main()
