#!/usr/bin/env python3
"""Build scoped certificates for common 3-dimensional secondary subspaces."""

from __future__ import annotations

import argparse
import hashlib
import itertools
import json
from pathlib import Path
import subprocess
import time

from build_common_pencils import MSOLVE, PRIME, parse_leading, sha256
from common_pencil import (
    FRAME_NAMES,
    GENERIC_PATH,
    GOALS,
    PROBLEM,
    TABLE_PATH,
    TRIPLES,
    msolve_input_support,
)


HERE = Path(__file__).resolve().parent
SYSTEMS = HERE / "plane_systems"
CERTIFICATE = HERE / "common_plane_certificate.json"
ALL_SUPPORTS = tuple(
    (0, left, right) for left, right in itertools.combinations(range(1, 12), 2)
)
# The durable bounded packet deliberately keeps one uniform P8 family across
# all ten ternary frame planes.  The larger exploratory sweep was capped.
SUPPORTS = ((0, 1, 2),)


def build_one(frame_triple, support):
    stem = f"{''.join(map(str, frame_triple))}_s{support[0]:02d}{support[1]:02d}{support[2]:02d}"
    source = SYSTEMS / f"{stem}.in"
    leading = SYSTEMS / f"{stem}.leading.out"
    text, equations, rows = msolve_input_support(frame_triple, support, PRIME)
    source.write_text(text)
    started = time.monotonic()
    completed = subprocess.run(
        [str(MSOLVE), "-f", str(source), "-g", "1", "-o", str(leading)],
        cwd=HERE,
        text=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        check=False,
    )
    elapsed = time.monotonic() - started
    if completed.returncode != 0:
        raise RuntimeError(
            f"msolve failed for {stem} ({completed.returncode}):\n{completed.stdout[-4000:]}"
        )
    basis_length, pure_powers = parse_leading(leading)
    variable_count = 3 * len(support)
    return {
        "stem": stem,
        "frame_indices": list(frame_triple),
        "frame_names": [FRAME_NAMES[index] for index in frame_triple],
        "support": list(support),
        "ansatz": [
            "+".join(f"u{i}{offset}*beta_{basis}" for offset, basis in enumerate(support))
            for i in range(3)
        ],
        "exact_coefficient_equations": len(equations),
        "good_prime": PRIME,
        "modular_equation_rank": len(rows),
        "leading_basis_length": basis_length,
        "pure_powers": {
            f"a{index}": pure_powers.get(index) for index in range(variable_count)
        },
        "projective_special_fibre_empty": set(pure_powers) == set(range(variable_count)),
        "input": str(source.relative_to(HERE)),
        "input_sha256": sha256(source),
        "leading": str(leading.relative_to(HERE)),
        "leading_sha256": sha256(leading),
        "elapsed_seconds": round(elapsed, 6),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--limit", type=int)
    parser.add_argument("--triple")
    parser.add_argument("--support", help="three basis indices, comma-separated")
    parser.add_argument("--all-supports", action="store_true")
    parser.add_argument("--prune", action="store_true", help="remove generated systems outside this job set")
    args = parser.parse_args()

    SYSTEMS.mkdir(parents=True, exist_ok=True)
    triples = TRIPLES
    if args.triple:
        chosen = tuple(map(int, args.triple))
        if chosen not in TRIPLES:
            raise ValueError(f"invalid frame triple: {args.triple}")
        triples = (chosen,)
    supports = ALL_SUPPORTS if args.all_supports else SUPPORTS
    if args.support:
        chosen = tuple(map(int, args.support.split(",")))
        if chosen not in ALL_SUPPORTS:
            raise ValueError(f"support must be one of the unit-containing triples: {chosen}")
        supports = (chosen,)
    jobs = [(triple, support) for triple in triples for support in supports]
    if args.limit is not None:
        jobs = jobs[: args.limit]

    if args.prune:
        wanted = {
            f"{''.join(map(str, triple))}_s{support[0]:02d}{support[1]:02d}{support[2]:02d}"
            for triple, support in jobs
        }
        for path in SYSTEMS.glob("*"):
            if path.is_file() and path.name.endswith((".in", ".leading.out")):
                stem = path.name.removesuffix(".leading.out").removesuffix(".in")
                if stem not in wanted:
                    path.unlink()

    systems = []
    for position, (triple, support) in enumerate(jobs, 1):
        result = build_one(triple, support)
        systems.append(result)
        print(
            f"[{position}/{len(jobs)}] {result['stem']} "
            f"rank={result['modular_equation_rank']} "
            f"pure={result['projective_special_fibre_empty']} "
            f"time={result['elapsed_seconds']}s",
            flush=True,
        )

    payload = {
        "schema": "G_TERNARY_COMMON_PLANE_V1",
        "field": "K_proj over P0=QQ(t3,t6,t8,t11)",
        "frame": list(FRAME_NAMES),
        "basis": [f"beta_{index}" for index in range(12)],
        "ansatz": (
            "for each listed frame triple and listed support {0,s,t}, each of its "
            "three coordinates is an arbitrary QQ-linear combination of beta_0,beta_s,beta_t"
        ),
        "prime": PRIME,
        "source_hashes": {
            str(GENERIC_PATH.relative_to(GOALS)): sha256(GENERIC_PATH),
            str(TABLE_PATH.relative_to(PROBLEM)): sha256(TABLE_PATH),
        },
        "systems": systems,
        "system_count": len(systems),
        "all_projective_special_fibres_empty": all(
            row["projective_special_fibre_empty"] for row in systems
        ),
        "scope": (
            "Good-fibre projective emptiness proves characteristic-zero emptiness "
            "only for the listed 9-variable constant-field ansatze."
        ),
    }
    CERTIFICATE.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(
        "G_TERNARY_COMMON_PLANES_BUILT",
        f"systems={len(systems)} all_empty={payload['all_projective_special_fibres_empty']}",
    )


if __name__ == "__main__":
    main()
