#!/usr/bin/env python3
"""Deterministic exact u-grid certificate for six cleared T111 RUR identities."""

from __future__ import annotations

import argparse
import concurrent.futures
import hashlib
import json
import subprocess
import tempfile
from pathlib import Path

WORK = Path("/Users/worker/unirational/problems/E-klein-cubic/goals_after_bd610a")
EMITTER = WORK / "scratch_t3/emit_t111_generic_rur_u_slice.py"
SINGULAR = Path("/opt/homebrew/bin/Singular")
OUT = WORK / "scratch_t3/verify_t111_generic_rur_identities_result.json"
U_VALUES = tuple(range(-225, 226))
EXPECTED = ("P0", "Pu0", "PA0", "PB0", "PY0", "PZ0")


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run_one(pair):
    u0, directory = pair
    script = Path(directory) / f"u_{u0}.sing"
    emitted = subprocess.run(
        ["python3", str(EMITTER), str(u0), "--output", str(script)],
        cwd=WORK, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        timeout=30, check=False,
    )
    if emitted.returncode:
        return u0, False, "EMIT\n" + emitted.stdout[-2000:]
    checked = subprocess.run(
        [str(SINGULAR), "-q", str(script)], cwd=WORK,
        text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        timeout=90, check=False,
    )
    output = checked.stdout
    ok = checked.returncode == 0 and f"U_SLICE_PASS={u0}" in output
    ok = ok and all(f"PASS_{name}" in output for name in EXPECTED)
    return u0, ok, output[-3000:]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--workers", type=int, default=4)
    args = parser.parse_args()
    failures = []
    passed = []
    with tempfile.TemporaryDirectory(prefix="t111_u_grid_") as directory:
        jobs = [(u0, directory) for u0 in U_VALUES]
        with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
            for u0, ok, output in pool.map(run_one, jobs):
                if ok:
                    passed.append(u0)
                else:
                    failures.append({"u": u0, "output": output})
                if (len(passed) + len(failures)) % 20 == 0:
                    print(
                        f"PROGRESS {len(passed)+len(failures)}/{len(U_VALUES)} "
                        f"failures={len(failures)}",
                        flush=True,
                    )
    report = {
        "schema": "klein-t111-cleared-rur-u-grid-v1",
        "status": "PASS" if not failures and passed == list(U_VALUES) else "FAIL",
        "workers": args.workers,
        "u_values": [min(U_VALUES), max(U_VALUES)],
        "u_value_count": len(U_VALUES),
        "passed_count": len(passed),
        "failures": failures,
        "identity_degree_bound": {
            "construction": "pseudo-remainder in Z of cleared F by QZ",
            "QZ_Z_degree": 6,
            "QZ_leading_coefficient_u_degree": 8,
            "QZ_other_coefficient_max_u_degree": 12,
            "NB_NY_QZprime_max_u_degree": 12,
            "max_cleared_F_u_degree": 78,
            "max_cleared_F_Z_degree": 36,
            "pseudo_reduction_steps": 31,
            "max_pseudoremainder_u_degree": 450,
            "reason": "78 + 31*max(8,12) = 450",
            "conclusion": "451 distinct integral u-slices force every pseudoremainder coefficient to vanish identically",
        },
        "integer_slice_leading_coefficient": {
            "factor": "(u^2-8u-29)^4 up to a nonzero rational constant",
            "nonzero_on_all_integer_slices": True,
            "reason": "u^2-8u-29 has nonsquare discriminant 180 and no integer root",
        },
        "input_sha256": {
            "QZ": sha(WORK / "scratch_t3/generic_singular_rur_QZ.tsv"),
            "NB": sha(WORK / "scratch_t3/generic_singular_rur_NB.tsv"),
            "NY": sha(WORK / "scratch_t3/generic_singular_rur_NY.tsv"),
            "primitive": sha(WORK / "../tmp/target_branch_delta_saturated_singularity/global_primitive_u_sextic_exact.tsv"),
            "slice_emitter": sha(EMITTER),
        },
    }
    OUT.write_text(json.dumps(report, indent=2, sort_keys=True) + "\n")
    print(json.dumps(report, indent=2, sort_keys=True), flush=True)
    raise SystemExit(0 if report["status"] == "PASS" else 1)


if __name__ == "__main__":
    main()
