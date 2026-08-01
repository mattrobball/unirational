#!/usr/bin/env python3
"""Search D_12 plus three primitive directions for a landing covariant.

All 16+2 coordinate slices were previously proved empty.  This is the first
untested sparse frontier in the deterministic 16+32 degree-12 basis.  Each
slice is solved from 700 genuine F_23 landing equations.  Empty output has
only slice scope; nonempty output is a candidate signal requiring complete
special-fibre and characteristic-zero verification.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import sys
import tempfile
import time
from collections import Counter
from functools import lru_cache
from itertools import combinations
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
OLD = one.OLD_DIMENSION
PRIMITIVE = one.PRIMITIVE_DIMENSION
DIMENSION = OLD + 3
CUBICS = 1_330
TRIPLES = tuple(combinations(range(PRIMITIVE), 3))
OUTPUTS = HERE / "degree12_triple_outputs"
SUMMARY = HERE / "degree12_triple_results.json"


def sha256_bytes(value: bytes) -> str:
    return hashlib.sha256(value).hexdigest()


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def index_data():
    monomial_basis = one.monomials(3, DIMENSION)
    assert len(monomial_basis) == CUBICS
    indices = []
    factors = []
    for exponents in monomial_basis:
        values = []
        for coordinate, exponent in enumerate(exponents):
            values.extend([coordinate] * exponent)
        indices.append(values)
        factors.append(one.multinomial(exponents))
    return (
        monomial_basis,
        np.asarray(indices, dtype=np.int64),
        np.asarray(factors, dtype=np.int64),
    )


def global_outputs():
    metadata = json.loads(one.METADATA.read_text())
    assert one.sha256(one.ROWS) == metadata["rows_sha256"]
    scan, basis_points, old_basis, primitive_basis = one.reconstruct_custom_basis()
    assert [[int(value) for value in point] for point in basis_points] == metadata[
        "basis_points"
    ]
    assert [one.descriptor_json(value) for value in old_basis] == metadata[
        "old_product_basis"
    ]
    assert [
        {"output": int(output), "exponents": list(exponents)}
        for output, exponents in primitive_basis
    ] == metadata["primitive_reynolds_seeds"]
    values = np.empty((metadata["sample_count"], 5, OLD + PRIMITIVE), dtype=np.uint8)
    for point_index, raw_point in enumerate(metadata["sample_points"]):
        point = np.asarray(raw_point, dtype=np.int64)
        old_values = [
            one.product_value(scan, descriptor, point) for descriptor in old_basis
        ]
        primitive_values = [
            scan.evaluate_seed(*seed, point) for seed in primitive_basis
        ]
        values[point_index] = np.stack(old_values + primitive_values, axis=1)
    cubic = one.invariant_cubic_coefficients(scan)
    return metadata, values.astype(np.int64), cubic, one.symmetric_cubic_tensor(cubic)


def slice_rows(all_outputs, cubic, tensor, triple):
    monomial_basis, indices, factors = index_data()
    coordinate_map = list(range(OLD)) + [OLD + value for value in triple]
    rows = np.empty((len(all_outputs), CUBICS), dtype=np.uint8)
    for point_index, outputs in enumerate(all_outputs):
        selected = outputs[:, coordinate_map]
        ordered = np.einsum(
            "rst,ri,sj,tk->ijk",
            tensor,
            selected,
            selected,
            selected,
            optimize=True,
        ) % P
        row = ordered[indices[:, 0], indices[:, 1], indices[:, 2]] * factors % P
        rows[point_index] = row
        if point_index == 0:
            slow = one.landing_row(selected, cubic, monomial_basis) % P
            assert np.array_equal(row, slow)
    return rows, monomial_basis


def polynomial_text(row, monomial_basis):
    terms = []
    for coefficient, exponents in zip(row, monomial_basis):
        coefficient = int(coefficient)
        if coefficient == 0:
            continue
        factors = [] if coefficient == 1 else [str(coefficient)]
        for coordinate, exponent in enumerate(exponents):
            if exponent == 1:
                factors.append(f"a{coordinate}")
            elif exponent:
                factors.append(f"a{coordinate}^{exponent}")
        terms.append("*".join(factors))
    return "+".join(terms)


@lru_cache(maxsize=None)
def weak_compositions(total, slots):
    values = []

    def visit(prefix, remaining, left):
        if left == 1:
            values.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, left - 1)

    visit((), total, slots)
    return tuple(values)


def parse_leads(text):
    length = re.search(r"#length of basis:\s+(\d+) elements", text)
    assert length is not None
    expressions = [
        value.strip() for value in text[text.index("[") + 1:text.rindex("]")].split(",")
        if value.strip()
    ]
    leads = []
    for expression in expressions:
        exponents = [0] * DIMENSION
        factors = re.findall(r"a(\d+)\^(\d+)", expression)
        assert factors and "*".join(f"a{i}^{e}" for i, e in factors) == expression
        for coordinate, exponent in factors:
            exponents[int(coordinate)] = int(exponent)
        leads.append(tuple(exponents))
    assert len(leads) == int(length.group(1)) == len(set(leads))
    return leads


def hilbert_value(leads, degree):
    all_monomials = set(weak_compositions(degree, DIMENSION))
    covered = set()
    for lead in leads:
        if sum(lead) > degree:
            continue
        for quotient in weak_compositions(degree - sum(lead), DIMENSION):
            covered.add(tuple(left + right for left, right in zip(lead, quotient)))
    assert covered <= all_monomials
    return len(all_monomials - covered)


def solve_slice(rows, monomial_basis, triple_index, triple, timeout, threads):
    rank, library, profile = rank_mod_prime(rows, profile=True)
    assert profile is not None
    variables = [f"a{index}" for index in range(DIMENSION)]
    expressions = [polynomial_text(rows[index], monomial_basis) for index in profile]
    solver_text = ",".join(variables) + f"\n{P}\n" + ",\n".join(expressions) + "\n"
    input_sha = sha256_bytes(solver_text.encode())
    stem = f"triple_{triple_index:04d}_{triple[0]:02d}_{triple[1]:02d}_{triple[2]:02d}"
    log_path = OUTPUTS / f"{stem}.log"
    leading_path = OUTPUTS / f"{stem}_leading.out"
    started = time.monotonic()
    with tempfile.TemporaryDirectory(prefix="schur-primitive-three-") as directory:
        source = Path(directory) / "slice.in"
        answer = Path(directory) / "leading.out"
        source.write_text(solver_text)
        command = [
            "msolve", "-f", str(source), "-o", str(answer), "-t", str(threads),
            "-v", "2", "-g", "1", "-l", "2", "-q", "0", "-r", "0",
            "-s", "20", "-m", "2000", "--random-seed", "0",
        ]
        try:
            completed = subprocess.run(
                command, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
                timeout=timeout, check=False,
            )
        except subprocess.TimeoutExpired as error:
            output = error.stdout or ""
            if isinstance(output, bytes):
                output = output.decode(errors="replace")
            log_path.write_text(output)
            return {
                "triple_index": triple_index, "triple": list(triple),
                "rank": rank, "ffpack_library": library, "input_sha256": input_sha,
                "status": "timeout", "seconds": time.monotonic() - started,
                "log_file": log_path.name, "log_sha256": sha256(log_path),
            }
        log_path.write_text(completed.stdout)
        assert completed.returncode == 0 and answer.is_file()
        leading_path.write_text(answer.read_text())
    leads = parse_leads(leading_path.read_text())
    hilbert = []
    for degree in range(9):
        hilbert.append(hilbert_value(leads, degree))
        if hilbert[-1] == 0:
            break
    return {
        "triple_index": triple_index, "triple": list(triple), "rank": rank,
        "ffpack_library": library, "input_sha256": input_sha,
        "status": "empty" if hilbert[-1] == 0 else "nonempty_or_inconclusive",
        "seconds": time.monotonic() - started, "leading_count": len(leads),
        "leading_degree_tally": dict(sorted(Counter(map(sum, leads)).items())),
        "hilbert_function": hilbert, "leading_file": leading_path.name,
        "leading_sha256": sha256(leading_path), "log_file": log_path.name,
        "log_sha256": sha256(log_path),
    }


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--start-index", type=int, default=0)
    parser.add_argument("--stop-index", type=int, default=10)
    parser.add_argument("--timeout", type=int, default=120)
    parser.add_argument("--threads", type=int, default=2)
    arguments = parser.parse_args()
    assert 0 <= arguments.start_index < arguments.stop_index <= len(TRIPLES)
    assert 1 <= arguments.timeout <= 1800 and 1 <= arguments.threads <= 8
    OUTPUTS.mkdir(exist_ok=True)
    prior = json.loads(SUMMARY.read_text()) if SUMMARY.is_file() else {"results": []}
    result_map = {value["triple_index"]: value for value in prior["results"]}
    metadata, outputs, cubic, tensor = global_outputs()
    for triple_index in range(arguments.start_index, arguments.stop_index):
        if result_map.get(triple_index, {}).get("status") in {
            "empty", "nonempty_or_inconclusive"
        }:
            print(f"tripleIndex={triple_index} SKIP", flush=True)
            continue
        triple = TRIPLES[triple_index]
        rows, monomial_basis = slice_rows(outputs, cubic, tensor, triple)
        result = solve_slice(
            rows, monomial_basis, triple_index, triple,
            arguments.timeout, arguments.threads,
        )
        result_map[triple_index] = result
        prior = {
            "field_characteristic": P,
            "basis": "16 multiplication-span plus 32 deterministic primitive seeds",
            "sample_count": metadata["sample_count"],
            "slice_dimension": DIMENSION,
            "triples_total": len(TRIPLES),
            "logical_scope": (
                "empty proves only this coordinate slice has no landing point; "
                "nonempty is a discovery signal pending complete exact verification"
            ),
            "results": [result_map[index] for index in sorted(result_map)],
        }
        SUMMARY.write_text(json.dumps(prior, indent=2) + "\n")
        print(
            f"tripleIndex={triple_index} triple={triple} rank={result['rank']} "
            f"status={result['status']} seconds={result['seconds']:.3f}",
            flush=True,
        )


if __name__ == "__main__":
    main()
