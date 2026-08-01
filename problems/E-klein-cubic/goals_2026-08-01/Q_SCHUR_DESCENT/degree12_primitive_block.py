#!/usr/bin/env python3
"""Exact F_23 attack on the pure primitive degree-12 Schur covariants.

The degree-12 covariant space has the audited decomposition

    M_12 = D_12 + P_12,   dim(D_12) = 16, dim(P_12) = 32,

where ``D_12`` is the multiplication span used by the upstream structural
certificate and ``P_12`` is its deterministic Reynolds complement.  This
script restricts the Klein-cubic landing equations to ``P_12``.  It stores
every sampled coefficient row, certifies its exact rank with FFPACK, writes
an msolve input, and optionally tests projective emptiness from the leading
monomial ideal.

An empty sampled system is already a rigorous nonexistence result for this
32-plane, since the sampled equations are necessary landing equations.  A
nonempty result is only a discovery signal until a candidate is checked
against the complete characteristic-zero identity.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
import time
from collections import Counter
from functools import lru_cache
from itertools import product
from math import factorial
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
STRUCTURAL = PROBLEM / "tmp" / "projective_source_degree12_structural"
DEGREE12 = PROBLEM / "tmp" / "projective_source_degree12"
for directory in (STRUCTURAL, DEGREE12):
    if str(directory) not in sys.path:
        sys.path.insert(0, str(directory))

import primitive_one_slices as one  # noqa: E402
from rank_rows import rank_mod_prime  # noqa: E402


P = one.P
DIMENSION = one.PRIMITIVE_DIMENSION
CUBICS = 5_984
DEFAULT_SAMPLES = 700
ROWS = HERE / "degree12_primitive_rows.npy"
METADATA = HERE / "degree12_primitive_rows.json"
SOLVER_INPUT = HERE / "degree12_primitive.in"


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def multinomial(exponents: tuple[int, ...]) -> int:
    value = factorial(sum(exponents))
    for exponent in exponents:
        value //= factorial(exponent)
    return value


def coefficient_index_data():
    coefficient_monomials = one.monomials(3, DIMENSION)
    assert len(coefficient_monomials) == CUBICS
    triples = []
    factors = []
    for exponents in coefficient_monomials:
        indices = []
        for coordinate, exponent in enumerate(exponents):
            indices.extend([coordinate] * exponent)
        triples.append(indices)
        factors.append(multinomial(exponents))
    return (
        coefficient_monomials,
        np.asarray(triples, dtype=np.int64),
        np.asarray(factors, dtype=np.int64),
    )


def _basis_metadata(old_basis, primitive_basis):
    return {
        "old_product_basis": [one.descriptor_json(value) for value in old_basis],
        "primitive_reynolds_seeds": [
            {"output": int(output), "exponents": list(exponents)}
            for output, exponents in primitive_basis
        ],
    }


def generate(samples: int) -> dict[str, object]:
    upstream_metadata = json.loads(one.METADATA.read_text())
    assert one.sha256(one.ROWS) == upstream_metadata["rows_sha256"]
    assert samples <= upstream_metadata["sample_count"]

    scan, basis_points, old_basis, primitive_basis = one.reconstruct_custom_basis()
    assert len(old_basis) == one.OLD_DIMENSION
    assert len(primitive_basis) == DIMENSION
    assert [[int(value) for value in point] for point in basis_points] == (
        upstream_metadata["basis_points"]
    )
    basis_metadata = _basis_metadata(old_basis, primitive_basis)
    assert basis_metadata["old_product_basis"] == upstream_metadata["old_product_basis"]
    assert basis_metadata["primitive_reynolds_seeds"] == (
        upstream_metadata["primitive_reynolds_seeds"]
    )

    cubic = one.invariant_cubic_coefficients(scan)
    tensor = one.symmetric_cubic_tensor(cubic)
    coefficient_monomials, triples, factors = coefficient_index_data()
    rows = np.lib.format.open_memmap(
        ROWS, mode="w+", dtype=np.uint8, shape=(samples, CUBICS)
    )
    checks = []
    started = time.monotonic()
    for point_index, raw_point in enumerate(upstream_metadata["sample_points"][:samples]):
        point = np.asarray(raw_point, dtype=np.int64)
        outputs = np.stack(
            [scan.evaluate_seed(*seed, point) for seed in primitive_basis], axis=1
        )
        assert outputs.shape == (5, DIMENSION)
        ordered = np.einsum(
            "rst,ri,sj,tk->ijk",
            tensor,
            outputs,
            outputs,
            outputs,
            optimize=True,
        ) % P
        row = (
            ordered[triples[:, 0], triples[:, 1], triples[:, 2]] * factors
        ) % P
        rows[point_index] = row
        if point_index in (0, samples - 1):
            slow = one.landing_row(outputs, cubic, coefficient_monomials) % P
            assert np.array_equal(row, slow)
            checks.append({"point_index": point_index, "method": "sparse expansion"})
        if (point_index + 1) % 100 == 0 or point_index + 1 == samples:
            rows.flush()
            print(
                f"generated={point_index + 1}/{samples} "
                f"elapsedSeconds={time.monotonic() - started:.3f}",
                flush=True,
            )
    del rows

    saved = np.load(ROWS, mmap_mode="r")
    rank_started = time.monotonic()
    rank, library, profile = rank_mod_prime(saved, profile=True)
    rank_seconds = time.monotonic() - rank_started
    assert profile is not None and len(profile) == rank
    metadata = {
        "field_characteristic": P,
        "scope": "sampled necessary landing equations on the pure P_12 block",
        "primitive_dimension": DIMENSION,
        "coefficient_cubic_monomials": CUBICS,
        "sample_count": samples,
        "sample_points": upstream_metadata["sample_points"][:samples],
        "upstream_rows_file": str(one.ROWS.relative_to(PROBLEM)),
        "upstream_rows_sha256": upstream_metadata["rows_sha256"],
        "basis_rng_seed": upstream_metadata["basis_rng_seed"],
        "basis_points": upstream_metadata["basis_points"],
        **basis_metadata,
        "fast_slow_checks": checks,
        "rows_file": ROWS.name,
        "rows_bytes": ROWS.stat().st_size,
        "rows_sha256": sha256(ROWS),
        "row_rank_over_F23": rank,
        "row_rank_profile": profile,
        "ffpack_library": library,
        "rank_seconds": rank_seconds,
        "elapsed_seconds": time.monotonic() - started,
    }
    METADATA.write_text(json.dumps(metadata, indent=2) + "\n")
    print(
        f"rankOverF{P}={rank}/{samples} rowsSha256={metadata['rows_sha256']} "
        f"rankSeconds={rank_seconds:.3f}",
        flush=True,
    )
    return metadata


def _monomial_text(exponents: tuple[int, ...]) -> str:
    factors = []
    for index, exponent in enumerate(exponents):
        if exponent == 1:
            factors.append(f"p{index}")
        elif exponent:
            factors.append(f"p{index}^{exponent}")
    assert factors
    return "*".join(factors)


def write_solver_input() -> dict[str, object]:
    metadata = json.loads(METADATA.read_text())
    assert sha256(ROWS) == metadata["rows_sha256"]
    rows = np.load(ROWS, mmap_mode="r")
    assert rows.shape == (metadata["sample_count"], CUBICS)
    profile = metadata["row_rank_profile"]
    coefficient_monomials, _, _ = coefficient_index_data()
    monomial_strings = [_monomial_text(value) for value in coefficient_monomials]
    with SOLVER_INPUT.open("w") as stream:
        stream.write(",".join(f"p{index}" for index in range(DIMENSION)) + "\n")
        stream.write(str(P) + "\n")
        for equation_index, row_index in enumerate(profile):
            row = rows[row_index]
            nonzero = np.flatnonzero(row)
            assert len(nonzero)
            terms = []
            for column in nonzero:
                coefficient = int(row[column])
                monomial = monomial_strings[int(column)]
                terms.append(
                    monomial if coefficient == 1 else f"{coefficient}*{monomial}"
                )
            stream.write("+".join(terms))
            stream.write("\n" if equation_index + 1 == len(profile) else ",\n")
            if (equation_index + 1) % 100 == 0:
                print(f"written={equation_index + 1}/{len(profile)}", flush=True)
    metadata.update(
        {
            "solver_equations": len(profile),
            "solver_input_file": SOLVER_INPUT.name,
            "solver_input_bytes": SOLVER_INPUT.stat().st_size,
            "solver_input_sha256": sha256(SOLVER_INPUT),
        }
    )
    METADATA.write_text(json.dumps(metadata, indent=2) + "\n")
    print(
        f"input={SOLVER_INPUT} bytes={metadata['solver_input_bytes']} "
        f"sha256={metadata['solver_input_sha256']}",
        flush=True,
    )
    return metadata


@lru_cache(maxsize=None)
def weak_compositions(total: int, slots: int):
    values = []

    def visit(prefix, remaining, left):
        if left == 1:
            values.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, left - 1)

    visit((), total, slots)
    return tuple(values)


def parse_leads(text: str):
    length = re.search(r"#length of basis:\s+(\d+) elements", text)
    assert length is not None
    start, stop = text.index("[") + 1, text.rindex("]")
    expressions = [part.strip() for part in text[start:stop].split(",")]
    expressions = [expression for expression in expressions if expression]
    leads = []
    for expression in expressions:
        exponents = [0] * DIMENSION
        factors = re.findall(r"p(\d+)\^(\d+)", expression)
        assert factors
        assert "*".join(f"p{i}^{e}" for i, e in factors) == expression
        for raw_coordinate, raw_exponent in factors:
            coordinate, exponent = int(raw_coordinate), int(raw_exponent)
            assert 0 <= coordinate < DIMENSION
            exponents[coordinate] = exponent
        leads.append(tuple(exponents))
    assert len(leads) == int(length.group(1)) == len(set(leads))
    return leads


def hilbert_value(leads, degree: int) -> int:
    monomial_count = len(weak_compositions(degree, DIMENSION))
    covered = set()
    for lead in leads:
        lead_degree = sum(lead)
        if lead_degree > degree:
            continue
        for quotient in weak_compositions(degree - lead_degree, DIMENSION):
            covered.add(tuple(a + b for a, b in zip(lead, quotient)))
    assert len(covered) <= monomial_count
    return monomial_count - len(covered)


def run_solver(timeout: int, threads: int, max_pairs: int) -> dict[str, object]:
    metadata = json.loads(METADATA.read_text())
    assert sha256(SOLVER_INPUT) == metadata["solver_input_sha256"]
    stem = f"degree12_primitive_m{max_pairs}"
    solver_log = HERE / f"{stem}_msolve.log"
    leading_output = HERE / f"{stem}_leading.out"
    result_path = HERE / f"{stem}_result.json"
    command = [
        "msolve",
        "-f",
        str(SOLVER_INPUT),
        "-o",
        str(leading_output),
        "-t",
        str(threads),
        "-v",
        "2",
        "-g",
        "1",
        "-l",
        "2",
        "-q",
        "0",
        "-r",
        "0",
        "-s",
        "20",
        "-m",
        str(max_pairs),
        "--random-seed",
        "0",
    ]
    started = time.monotonic()
    try:
        completed = subprocess.run(
            command,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            timeout=timeout,
            check=False,
        )
    except subprocess.TimeoutExpired as error:
        output = error.stdout or ""
        if isinstance(output, bytes):
            output = output.decode(errors="replace")
        solver_log.write_text(output)
        result = {
            "status": "timeout",
            "timeout_seconds": timeout,
            "max_pairs_per_matrix": max_pairs,
            "elapsed_seconds": time.monotonic() - started,
            "log_file": solver_log.name,
            "log_sha256": sha256(solver_log),
        }
        result_path.write_text(json.dumps(result, indent=2) + "\n")
        print(f"TIMEOUT after {result['elapsed_seconds']:.3f} seconds", flush=True)
        return result

    solver_log.write_text(completed.stdout)
    assert completed.returncode == 0 and leading_output.is_file()
    leading_text = leading_output.read_text()
    leads = parse_leads(leading_text)
    hilbert = []
    for degree in range(13):
        value = hilbert_value(leads, degree)
        hilbert.append(value)
        if value == 0:
            break
    result = {
        "status": "empty" if hilbert[-1] == 0 else "nonempty_or_inconclusive",
        "elapsed_seconds": time.monotonic() - started,
        "max_pairs_per_matrix": max_pairs,
        "leading_monomials": len(leads),
        "leading_degree_tally": dict(sorted(Counter(map(sum, leads)).items())),
        "hilbert_function": hilbert,
        "input_file": SOLVER_INPUT.name,
        "input_sha256": sha256(SOLVER_INPUT),
        "leading_file": leading_output.name,
        "leading_sha256": sha256(leading_output),
        "log_file": solver_log.name,
        "log_sha256": sha256(solver_log),
    }
    result_path.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2), flush=True)
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--samples", type=int, default=DEFAULT_SAMPLES)
    parser.add_argument("--generate", action="store_true")
    parser.add_argument("--write-input", action="store_true")
    parser.add_argument("--run", action="store_true")
    parser.add_argument("--timeout", type=int, default=600)
    parser.add_argument("--threads", type=int, default=4)
    parser.add_argument("--max-pairs", type=int, default=512)
    arguments = parser.parse_args()
    assert 1 <= arguments.samples <= DEFAULT_SAMPLES
    assert 1 <= arguments.timeout <= 3600
    assert 1 <= arguments.threads <= 8
    assert 1 <= arguments.max_pairs <= 4000
    if arguments.generate:
        generate(arguments.samples)
    if arguments.write_input:
        write_solver_input()
    if arguments.run:
        run_solver(arguments.timeout, arguments.threads, arguments.max_pairs)
    if not (arguments.generate or arguments.write_input or arguments.run):
        parser.error("choose --generate, --write-input, and/or --run")


if __name__ == "__main__":
    main()
