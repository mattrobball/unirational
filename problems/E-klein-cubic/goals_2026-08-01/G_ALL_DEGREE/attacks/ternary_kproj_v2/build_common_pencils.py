#!/usr/bin/env python3
"""Build exact good-reduction certificates for all common two-plane ansatze."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re
import subprocess
import time

from common_pencil import (
    FRAME_NAMES,
    GENERIC_PATH,
    GOALS,
    PROBLEM,
    TABLE_PATH,
    TRIPLES,
    msolve_input,
    triple_name,
)


HERE = Path(__file__).resolve().parent
SYSTEMS = HERE / "systems"
CERTIFICATE = HERE / "common_pencil_certificate.json"
MSOLVE = Path("/opt/homebrew/bin/msolve")
PRIME = 101


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for block in iter(lambda: handle.read(1 << 20), b""):
            digest.update(block)
    return digest.hexdigest()


def parse_leading(path: Path):
    text = path.read_text()
    require = re.search(r"#length of basis:\s+(\d+) elements", text)
    if not require:
        raise RuntimeError(f"no leading-basis length in {path}")
    body_match = re.search(r"\n\[(.*)\]:\s*$", text, re.DOTALL)
    if not body_match:
        raise RuntimeError(f"no leading-monomial list in {path}")
    entries = [item.strip() for item in body_match.group(1).split(",")]
    pure = {}
    for entry in entries:
        match = re.fullmatch(r"a(\d+)\^(\d+)", entry)
        if match:
            variable, exponent = map(int, match.groups())
            pure[variable] = min(pure.get(variable, exponent), exponent)
    return int(require.group(1)), pure


def build_one(frame_triple, secondary):
    stem = f"{''.join(map(str, frame_triple))}_s{secondary:02d}"
    source = SYSTEMS / f"{stem}.in"
    leading = SYSTEMS / f"{stem}.leading.out"
    text, equations, rows = msolve_input(frame_triple, secondary, PRIME)
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
    return {
        "stem": stem,
        "frame_indices": list(frame_triple),
        "frame_names": [FRAME_NAMES[index] for index in frame_triple],
        "secondary": secondary,
        "ansatz": [f"u{i}0+u{i}1*beta_{secondary}" for i in range(3)],
        "exact_coefficient_equations": len(equations),
        "good_prime": PRIME,
        "modular_equation_rank": len(rows),
        "leading_basis_length": basis_length,
        "pure_powers": {f"a{index}": pure_powers.get(index) for index in range(6)},
        "projective_special_fibre_empty": set(pure_powers) == set(range(6)),
        "input": str(source.relative_to(HERE)),
        "input_sha256": sha256(source),
        "leading": str(leading.relative_to(HERE)),
        "leading_sha256": sha256(leading),
        "elapsed_seconds": round(elapsed, 6),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--limit", type=int)
    parser.add_argument("--triple", help="three frame indices, e.g. 012")
    parser.add_argument("--secondary", type=int)
    args = parser.parse_args()

    if not MSOLVE.is_file():
        raise RuntimeError(f"missing exact solver: {MSOLVE}")
    SYSTEMS.mkdir(parents=True, exist_ok=True)
    triples = TRIPLES
    if args.triple:
        chosen = tuple(map(int, args.triple))
        if chosen not in TRIPLES:
            raise ValueError(f"invalid frame triple: {args.triple}")
        triples = (chosen,)
    secondaries = tuple(range(1, 12))
    if args.secondary is not None:
        if not 1 <= args.secondary < 12:
            raise ValueError("secondary must be in 1..11")
        secondaries = (args.secondary,)
    jobs = [(triple, secondary) for triple in triples for secondary in secondaries]
    if args.limit is not None:
        jobs = jobs[: args.limit]

    systems = []
    for position, (triple, secondary) in enumerate(jobs, 1):
        result = build_one(triple, secondary)
        systems.append(result)
        print(
            f"[{position}/{len(jobs)}] {result['stem']} "
            f"rank={result['modular_equation_rank']} "
            f"pure={result['pure_powers']} time={result['elapsed_seconds']}s",
            flush=True,
        )

    payload = {
        "schema": "G_TERNARY_COMMON_PENCIL_V1",
        "field": "K_proj over P0=QQ(t3,t6,t8,t11)",
        "frame": list(FRAME_NAMES),
        "basis": [f"beta_{index}" for index in range(12)],
        "ansatz": (
            "for a frame triple T and one s in 1..11, each of its three "
            "coordinates is an arbitrary QQ-linear combination of 1 and beta_s"
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
            "only for the listed common-pencil ansatze; it is not pointlessness "
            "of any unrestricted ternary cubic or of the full generic cubic."
        ),
    }
    CERTIFICATE.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(
        "G_TERNARY_COMMON_PENCILS_BUILT",
        f"systems={len(systems)} all_empty={payload['all_projective_special_fibres_empty']}",
    )


if __name__ == "__main__":
    main()
