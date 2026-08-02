#!/usr/bin/env python3
"""Run the exact Q(u) RUR membership verifier on a decisive A-grid.

After denominator-cleared substitution, every coefficient of each of the six
critical remainders has A-degree at most 232:

* the source has deg_A <= 12 and B,Y-degree <= 6;
* NB, NY, and dQ/dZ have deg_A <= 16, giving initial degree <= 108;
* the Z-degree is at most 6 + 5*6 = 36;
* Q has A-degree bounds (16,14,12,10,8,4,0) in Z-degrees 0..6, so monic
  reduction increases A-degree by at most four per unit of Z-degree removed;
  reducing degree 36 to at most 5 adds at most 4*31 = 124.

Thus exact vanishing at 233 distinct A-values proves the identities over
Q(A,u).  Each fibre calculation remains symbolic and exact in u.
"""

from __future__ import annotations

import json
import subprocess
from concurrent.futures import ThreadPoolExecutor, as_completed
from hashlib import sha256
from pathlib import Path


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
BINARY = HERE / "verify_generic_rur_flint"
A_VALUES = list(range(-116, 117))
MARKER = "GENERIC_RUR_FLINT_A_FIBRE_PASS"


def digest(path: Path) -> str:
    return sha256(path.read_bytes()).hexdigest()


def run_one(a0: int) -> tuple[int, str]:
    result = subprocess.run(
        [str(BINARY), str(ROOT), str(a0)],
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        timeout=300,
        check=False,
    )
    if result.returncode or MARKER not in result.stdout:
        raise RuntimeError(f"A={a0} failed ({result.returncode}): {result.stdout[-2000:]}")
    return a0, result.stdout


def main() -> None:
    if not BINARY.is_file():
        raise SystemExit(f"compile {HERE/'verify_generic_rur_flint.cpp'} first")
    outputs = {}
    with ThreadPoolExecutor(max_workers=4) as pool:
        futures = {pool.submit(run_one, a0): a0 for a0 in A_VALUES}
        for index, future in enumerate(as_completed(futures), 1):
            a0, output = future.result()
            outputs[str(a0)] = output
            print(f"A={a0}: PASS ({index}/{len(A_VALUES)})", flush=True)
    log = HERE / "generic_rur_A_grid.log"
    log.write_text("".join(outputs[str(a0)] for a0 in A_VALUES))
    payload = {
        "schema": "klein-t3-generic-rur-A-grid-v1",
        "method": "exact denominator-cleared reduction over Q(u)",
        "A_values": A_VALUES,
        "number_of_distinct_A_values": len(A_VALUES),
        "proved_A_degree_bound": 232,
        "bound_ledger": {
            "source_A_degree": 12,
            "source_BY_degree": 6,
            "RUR_coordinate_numerator_A_degree": 16,
            "initial_substitution_A_degree_bound": 108,
            "initial_Z_degree_bound": 36,
            "maximum_A_gain_per_Z_degree_reduced": 4,
            "reduction_A_degree_gain_bound": 124,
            "remainder_A_degree_bound": 232,
        },
        "result": "all six critical equations vanish over Q(A,u)",
        "artifacts": {
            "verifier_source_sha256": digest(HERE / "verify_generic_rur_flint.cpp"),
            "verifier_binary_sha256": digest(BINARY),
            "QZ_sha256": digest(HERE / "generic_singular_rur_QZ.tsv"),
            "NB_sha256": digest(HERE / "generic_singular_rur_NB.tsv"),
            "NY_sha256": digest(HERE / "generic_singular_rur_NY.tsv"),
            "log_sha256": digest(log),
        },
    }
    out = HERE / "generic_rur_A_grid.json"
    out.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(f"wrote {out}")
    print("GENERIC_RUR_A_GRID_IDENTITY_PASS")


if __name__ == "__main__":
    main()
