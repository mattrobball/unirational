#!/usr/bin/env python3
"""Independent replay verifier for the stored degree-12 attack artifacts."""

from __future__ import annotations

import hashlib
import json
import re
import sys
from functools import lru_cache
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[1]
DEGREE12 = PROBLEM / "tmp" / "projective_source_degree12"
sys.path.insert(0, str(DEGREE12))
from rank_rows import rank_mod_prime  # noqa: E402


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


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


def parse_leads(path: Path, dimension: int):
    text = path.read_text()
    length = re.search(r"#length of basis:\s+(\d+) elements", text)
    assert length is not None
    expressions = [
        value.strip()
        for value in text[text.index("[") + 1:text.rindex("]")].split(",")
        if value.strip()
    ]
    leads = []
    for expression in expressions:
        exponents = [0] * dimension
        factors = re.findall(r"a(\d+)\^(\d+)", expression)
        assert factors and "*".join(f"a{i}^{e}" for i, e in factors) == expression
        for coordinate, exponent in factors:
            assert int(coordinate) < dimension
            exponents[int(coordinate)] = int(exponent)
        leads.append(tuple(exponents))
    assert len(leads) == int(length.group(1)) == len(set(leads))
    return leads


def hilbert_value(leads, degree: int, dimension: int) -> int:
    all_monomials = set(weak_compositions(degree, dimension))
    covered = set()
    for lead in leads:
        if sum(lead) > degree:
            continue
        for quotient in weak_compositions(degree - sum(lead), dimension):
            covered.add(tuple(left + right for left, right in zip(lead, quotient)))
    assert covered <= all_monomials
    return len(all_monomials - covered)


primitive_metadata = json.loads((HERE / "degree12_primitive_rows.json").read_text())
primitive_rows_path = HERE / primitive_metadata["rows_file"]
assert sha256(primitive_rows_path) == primitive_metadata["rows_sha256"]
primitive_rows = np.load(primitive_rows_path, mmap_mode="r")
assert primitive_rows.shape == (700, 5984) and primitive_rows.dtype == np.uint8
rank, library, profile = rank_mod_prime(primitive_rows, profile=True)
assert rank == primitive_metadata["row_rank_over_F23"] == 669
assert profile == primitive_metadata["row_rank_profile"]
assert library.endswith("libffpack_c.dylib")
primitive_input = HERE / primitive_metadata["solver_input_file"]
assert sha256(primitive_input) == primitive_metadata["solver_input_sha256"]
assert primitive_metadata["solver_input_sha256"] == (
    "adb4261fbcf4c9c0f81b01cf3c34a2b27b732d12303efa4a7b7faf1b8ca47abe"
)

for name, seconds, max_pairs in (
    ("degree12_primitive_result.json", 600, 2000),
    ("degree12_primitive_m512_result.json", 900, 512),
):
    result = json.loads((HERE / name).read_text())
    assert result["status"] == "timeout"
    assert result["timeout_seconds"] == seconds
    if "max_pairs_per_matrix" in result:
        assert result["max_pairs_per_matrix"] == max_pairs
    log = HERE / result["log_file"]
    assert sha256(log) == result["log_sha256"]
    log_text = log.read_text()
    selection = re.search(r"max pair selection\s+(\d+)", log_text)
    assert selection is not None and int(selection.group(1)) == max_pairs
    assert "deg     sel   pairs" in log_text

triple_summary = json.loads((HERE / "degree12_triple_results.json").read_text())
triple_indices = {value["triple_index"] for value in triple_summary["results"]}
assert triple_indices == set(range(5)) | set(range(1000, 1005)) | set(range(4955, 4960))
for result in triple_summary["results"]:
    assert result["rank"] == 669 and result["status"] == "empty"
    assert result["hilbert_function"] == [1, 19, 190, 661, 0]
    leading = HERE / "degree12_triple_outputs" / result["leading_file"]
    assert sha256(leading) == result["leading_sha256"]
    leads = parse_leads(leading, 19)
    assert [hilbert_value(leads, degree, 19) for degree in range(5)] == (
        result["hilbert_function"]
    )

nested_summary = json.loads((HERE / "degree12_nested_results.json").read_text())
expected_hilbert = {
    4: [1, 20, 210, 871, 0],
    5: [1, 21, 231, 1102, 0],
    6: [1, 22, 253, 1355, 0],
    7: [1, 23, 276, 1631, 0],
}
assert {value["primitive_count"] for value in nested_summary["results"]} == set(
    expected_hilbert
)
for result in nested_summary["results"]:
    count = result["primitive_count"]
    dimension = 16 + count
    assert result["rank"] == 669 and result["status"] == "empty"
    assert result["primitive_selection"] == list(range(count))
    assert result["hilbert_function"] == expected_hilbert[count]
    leading = HERE / "degree12_nested_outputs" / result["leading_file"]
    assert sha256(leading) == result["leading_sha256"]
    leads = parse_leads(leading, dimension)
    assert [hilbert_value(leads, degree, dimension) for degree in range(5)] == (
        expected_hilbert[count]
    )

print("PASS pure primitive row rank 669 and exact solver-input hash")
print("PASS both pure-block solver records are timeouts, not verdicts")
print("PASS 15 stored three-direction slices independently have empty Proj")
print("PASS nested primitive supports 4 through 7 independently have empty Proj")
print("Q_SCHUR_DEGREE12_SCOPED_ATTACK_EXACT")
print("BOUNDARY full degree-12 and all-degree landing schemes remain undecided")
