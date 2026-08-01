#!/usr/bin/env python3
"""Build an independent split-prime ambient Grassmannian projector system.

This deliberately targets the full primal wedge, hence only the auxiliary
Morita-projector variety.  It does not impose the distinguished B_10 Fano
section.  The script reuses the sealed Reynolds implementation read-only,
changes its finite-field globals before constructing any representation data,
and records whether the deterministic seed frame agrees with the p=23 frame.
"""

from __future__ import annotations

import argparse
import json
import runpy
from hashlib import sha256
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
FULL_WEDGE = ROOT / "tmp" / "pfaffian_rank2_idempotent_attack" / "full_wedge.py"
SHARED_P23 = HERE.parent / "C_PFAFFIAN_FANO" / "ambient_degree12_probe.json"


def order_eleven_root(prime: int) -> int:
    for candidate in range(2, prime):
        if pow(candidate, 11, prime) == 1 and candidate != 1:
            return candidate
    raise ValueError(f"{prime} has no nontrivial eleventh root")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=67)
    parser.add_argument("--zeta", type=int)
    parser.add_argument("--degree", type=int, default=12)
    args = parser.parse_args()
    prime = args.prime
    zeta = order_eleven_root(prime) if args.zeta is None else args.zeta % prime
    assert zeta != 1 and pow(zeta, 11, prime) == 1

    fw = runpy.run_path(str(FULL_WEDGE))
    # ``runpy`` may return a shallow namespace copy.  Mutate the live global
    # dictionaries retained by the imported functions, not that copy.
    fw_live = fw["FullWedgeScanner"].__init__.__globals__
    fano_namespace = fw_live["fano"]
    fano_live = fano_namespace["six_dimensional_generators"].__globals__
    fw_live["P"] = prime
    fano_live["P"] = prime
    fano_live["ZETA"] = zeta

    scanner = fw["FullWedgeScanner"]()
    seeds = scanner.covariant_basis(args.degree)
    print(f"prime={prime} zeta={zeta} degree={args.degree} dimension={len(seeds)}", flush=True)
    equations = scanner.landing_equations(seeds, extra_points=180)
    rows = [row for _pivot, row in equations]
    seed_payload = [[int(output), list(exponents)] for output, exponents in seeds]
    row_array = np.stack(rows)
    if prime < 256:
        row_bytes = bytes(row_array.astype(np.uint8).flat)
        row_encoding = "one-byte-residues"
    else:
        row_bytes = row_array.astype("<u2").tobytes()
        row_encoding = "little-endian-uint16-residues"

    p23_payload = json.loads(SHARED_P23.read_text())
    same_seed_frame = seed_payload == p23_payload["seeds"]
    record = {
        "format": "ambient-projector-split-prime-v1",
        "scope": "auxiliary ambient decomposable covariant; not the distinguished Fano section",
        "prime": prime,
        "zeta11": zeta,
        "degree": args.degree,
        "dimension": len(seeds),
        "quadratic_rank": len(rows),
        "same_seed_frame_as_p23": same_seed_frame,
        "seeds": seed_payload,
        "quadratic_row_sha256": sha256(row_bytes).hexdigest(),
        "quadratic_row_encoding": row_encoding,
        "source": str(FULL_WEDGE.relative_to(ROOT)),
        "theorem_boundary": (
            "a modular ambient projector is neither characteristic-zero Morita data "
            "nor a point of the five-hyperplane Fano section"
        ),
    }
    suffix = f"_zeta{zeta}" if args.zeta is not None else ""
    stem = HERE / f"ambient_degree{args.degree}_p{prime}{suffix}"
    stem.with_suffix(".json").write_text(json.dumps(record, indent=2) + "\n")
    stem.with_suffix(".in").write_text(fw["msolve_input"](rows, len(seeds)))
    print(json.dumps({key: value for key, value in record.items() if key != "seeds"}, indent=2))
    print("AMBIENT-PROJECTOR-INDEPENDENT-PRIME-BUILT")


if __name__ == "__main__":
    main()
