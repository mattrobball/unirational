#!/usr/bin/env python3
"""Exact good-fibre probe of the full five-coordinate R8 Schur frame.

This is a positive-candidate search and, on a unit ideal, a scoped
characteristic-zero exclusion.  It is not an all-height point theorem.
All generated artifacts stay beside this script.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
import time
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
TERNARY = PROBLEM / "tmp" / "schur_ternary_planes"
sys.path.insert(0, str(TERNARY))
import core  # noqa: E402


DEGREE = 8
DIMENSION = core.INVARIANT_DIMENSIONS[DEGREE]
VARIABLE_COUNT = 5 * DIMENSION
BASIS_SEED = 202608010851
SAMPLE_SEED = 202608010852
PREFIX = "full_frame_r8"
BASIS_LIMIT = None
LABEL = "R8"


def digest(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def build(samples: int, stagnant_limit: int) -> dict:
    scan = core.Scan()
    basis_rng = np.random.default_rng(BASIS_SEED)
    basis_points = [
        basis_rng.integers(0, core.P, size=6, dtype=np.int64)
        for _ in range(24)
    ]
    complete_invariant_seeds = core.invariant_basis(scan, DEGREE, basis_points)
    invariant_seeds = (
        complete_invariant_seeds
        if BASIS_LIMIT is None
        else complete_invariant_seeds[:BASIS_LIMIT]
    )
    assert len(invariant_seeds) == DIMENSION

    cubic = core.invariant_cubic_coefficients(scan)
    tensor = core.symmetric_cubic_tensor(cubic)
    monomials, triples, factors = core.local_cubic_indices(VARIABLE_COUNT)
    coordinates = np.arange(VARIABLE_COUNT, dtype=np.int64)
    mapped = coordinates[triples]

    echelon: list[tuple[int, np.ndarray]] = []
    accepted: list[np.ndarray] = []
    accepted_points: list[list[int]] = []
    rng = np.random.default_rng(SAMPLE_SEED)
    stagnant = 0
    attempted = 0
    started = time.monotonic()
    for index in range(samples):
        attempted += 1
        point = rng.integers(0, core.P, size=6, dtype=np.int64)
        frame, invariants = core.frame_and_invariants_at_point(
            scan, invariant_seeds, point
        )
        outputs = core.product_outputs(frame, invariants)
        ordered = np.einsum(
            "rst,ri,sj,tk->ijk",
            tensor,
            outputs,
            outputs,
            outputs,
            optimize=True,
        ) % core.P
        row = (
            ordered[mapped[:, 0], mapped[:, 1], mapped[:, 2]] * factors
        ) % core.P
        if index == 0:
            slow = core.landing_row(outputs, cubic, monomials) % core.P
            assert np.array_equal(row.astype(np.int64), slow)
        if core.add_echelon_row(echelon, row):
            accepted.append(np.asarray(row, dtype=np.uint8))
            accepted_points.append([int(value) for value in point])
            stagnant = 0
        else:
            stagnant += 1
        if (index + 1) % 50 == 0:
            print(
                f"samples={index + 1} rank={len(echelon)} "
                f"stagnant={stagnant} elapsed={time.monotonic() - started:.2f}s",
                flush=True,
            )
        if stagnant >= stagnant_limit:
            break

    rows = np.stack(accepted).astype(np.uint8)
    rows_path = HERE / f"{PREFIX}_rows.npz"
    np.savez_compressed(rows_path, rows=rows)
    metadata = {
        "format": f"Q-SCHUR-FULL-FRAME-{LABEL}-v1",
        "scope": (
            f"all five degree-eight frame columns with complete R{DEGREE} coefficients"
            if DIMENSION == core.INVARIANT_DIMENSIONS[DEGREE]
            else f"all five degree-eight frame columns with one displayed {DIMENSION}-dimensional slice inside R{DEGREE}"
        ),
        "prime": core.P,
        "cyclotomic_specialization": "zeta_11=2",
        "frame_degree": core.FRAME_DEGREE,
        "coefficient_degree": DEGREE,
        "total_covariant_degree": core.FRAME_DEGREE + DEGREE,
        "invariant_dimension": DIMENSION,
        "complete_invariant_dimension": core.INVARIANT_DIMENSIONS[DEGREE],
        "variable_count": VARIABLE_COUNT,
        "cubic_monomials": len(monomials),
        "basis_seed": BASIS_SEED,
        "invariant_seeds": [list(seed) for seed in invariant_seeds],
        "sample_seed": SAMPLE_SEED,
        "attempted_samples": attempted,
        "accepted_points": accepted_points,
        "equation_rank": len(echelon),
        "stagnant_count": stagnant,
        "rows_file": rows_path.name,
        "rows_sha256": digest(rows_path),
        "boundary": f"unit ideal proves only this R{DEGREE} full-frame slice empty; a nonunit sampled ideal is a nonverdict",
    }
    metadata_path = HERE / f"{PREFIX}_metadata.json"
    metadata_path.write_text(json.dumps(metadata, indent=2) + "\n")
    print(json.dumps({key: value for key, value in metadata.items() if key != "accepted_points"}, indent=2))
    return metadata


def polynomial_text(row: np.ndarray, monomials: list[tuple[int, ...]]) -> str:
    variables = [f"a{index}" for index in range(VARIABLE_COUNT)]
    return core.polynomial_text(row.astype(np.int64), monomials, variables)


def solve(timeout: int, threads: int) -> dict:
    metadata_path = HERE / f"{PREFIX}_metadata.json"
    metadata = json.loads(metadata_path.read_text())
    rows_path = HERE / metadata["rows_file"]
    assert digest(rows_path) == metadata["rows_sha256"]
    rows = np.load(rows_path)["rows"].astype(np.uint8)
    assert core.rank(rows) == metadata["equation_rank"]
    monomials = core.monomials(3, VARIABLE_COUNT)
    variables = [f"a{index}" for index in range(VARIABLE_COUNT)]
    equations = [polynomial_text(row, monomials) for row in rows]
    source = HERE / f"{PREFIX}.in"
    source.write_text(
        ",".join(variables) + f"\n{core.P}\n" + ",\n".join(equations) + "\n"
    )
    leading = HERE / f"{PREFIX}.leading.out"
    log = HERE / f"{PREFIX}.solve.log"
    command = [
        "msolve", "-f", str(source), "-g", "1", "-o", str(leading),
        "-t", str(threads), "-v", "2",
    ]
    started = time.monotonic()
    try:
        completed = subprocess.run(
            command,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            timeout=timeout,
            check=False,
        )
        output = completed.stdout
        returncode = completed.returncode
        timed_out = False
    except subprocess.TimeoutExpired as error:
        output = error.stdout or ""
        if isinstance(output, bytes):
            output = output.decode(errors="replace")
        returncode = -1
        timed_out = True
    log.write_text(output)
    leading_text = leading.read_text() if leading.exists() else ""
    literal_unit = leading_text.strip() == "[-1]:"
    pure_power_bounds = {}
    for index in range(VARIABLE_COUNT):
        matches = re.findall(
            rf"^[\s\[]*a{index}\^(\d+)(?:,|\]:?)\s*$",
            leading_text,
            flags=re.MULTILINE,
        )
        if matches:
            pure_power_bounds[f"a{index}"] = min(int(value) for value in matches)
    artinian_at_origin = len(pure_power_bounds) == VARIABLE_COUNT
    matrices = re.findall(r"(\d+)\s+x\s+(\d+)", output)
    result = {
        "format": f"Q-SCHUR-FULL-FRAME-{LABEL}-SOLVE-v1",
        "input_sha256": digest(source),
        "leading_sha256": digest(leading) if leading.exists() else None,
        "log_sha256": digest(log),
        "timeout_seconds": timeout,
        "threads": threads,
        "elapsed_seconds": time.monotonic() - started,
        "returncode": returncode,
        "timed_out": timed_out,
        "literal_unit_ideal": literal_unit,
        "pure_power_bounds": pure_power_bounds,
        "artinian_at_origin": artinian_at_origin,
        "last_matrix": list(matrices[-1]) if matrices else None,
        "verdict": (
            f"SCOPED_{LABEL}_FULL_FRAME_EMPTY"
            if literal_unit or artinian_at_origin
            else "NONVERDICT_NO_CHARACTERISTIC_ZERO_POINT"
        ),
    }
    (HERE / f"{PREFIX}_result.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=("build", "solve", "all"))
    parser.add_argument("--samples", type=int, default=700)
    parser.add_argument("--stagnant", type=int, default=120)
    parser.add_argument("--timeout", type=int, default=600)
    parser.add_argument("--threads", type=int, default=4)
    args = parser.parse_args()
    if args.action in ("build", "all"):
        build(args.samples, args.stagnant)
    if args.action in ("solve", "all"):
        solve(args.timeout, args.threads)


if __name__ == "__main__":
    main()
