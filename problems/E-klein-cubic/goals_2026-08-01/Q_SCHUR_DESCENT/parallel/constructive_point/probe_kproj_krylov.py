#!/usr/bin/env python3
"""Exact candidate probe in small Krylov subspaces of ``K_proj``.

The normalized Hironaka basis is

    1, f7, f9, f10, f12, f14, f7^2, ..., f7^3, ... .

For a chosen set ``S`` of basis indices this script substitutes

    a_i = sum_{s in S} z_(i,s) beta_s

in all five coordinates of the certified generic Klein cubic.  Parameter
specializations only supply necessary coefficient equations.  Therefore an
empty projective locus for the sampled equations is already a rigorous
exclusion of the displayed characteristic-zero ansatz after good reduction;
a survivor is only a discovery signal until it is checked symbolically.

The structural cases are the first Krylov spans for multiplication by f7:

    pair:   <1,f7>
    triple: <1,f7,f7^2>.
"""

from __future__ import annotations

import argparse
from collections import Counter
import ctypes
import hashlib
import itertools
import json
from math import comb
from pathlib import Path
import re
import subprocess
import time

import numpy as np


HERE = Path(__file__).resolve().parent
PROBLEM = HERE.parents[3]
GOALS = PROBLEM / "goals_2026-08-01"
GENERIC = GOALS / "G_ALL_DEGREE" / "generic_cubic.json"
TABLE = PROBLEM / "tmp" / "kproj_arithmetic" / "normalized_kproj_table.json"
FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"
PRIME = 199
SAMPLE_COUNT = 64
RNG_SEED = 202608011733
CASES = {
    "pair": (0, 1),
    "triple": (0, 1, 6),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def digest(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).view(np.uint8)).hexdigest()


def mod_fraction(numerator: int, denominator: int) -> int:
    return numerator * pow(denominator, -1, PRIME) % PRIME


def scalar(rows: list[dict], values: tuple[int, ...]) -> int:
    answer = 0
    for row in rows:
        term = mod_fraction(row["numerator"], row["denominator"])
        for value, exponent in zip(values, row["exponents"]):
            term = term * pow(value, exponent, PRIME) % PRIME
        answer += term
    return answer % PRIME


def load_inputs():
    generic = json.loads(GENERIC.read_text())
    table = json.loads(TABLE.read_text())
    assert generic["schema"] == "G_GENERIC_KLEIN_CUBIC_V1"
    assert generic["coefficient_count"] == 35
    assert len(table["products"]) == 78
    return generic, table


def specialize_products(table: dict, values: tuple[int, ...]):
    products = {}
    for row in table["products"]:
        result = [0] * 12
        for entry in row["entries"]:
            result[entry["basis"]] = scalar(entry["coefficient"], values)
        products[(row["left"], row["right"])] = tuple(result)
    return products


def specialize_coefficients(generic: dict, values: tuple[int, ...]):
    answer = {}
    for item in generic["coefficients"]:
        vector = [0] * 12
        for entry in item["normalized_entries"]:
            term = mod_fraction(entry["numerator"], entry["denominator"])
            for value, exponent in zip(values, entry["projective_exponents"]):
                term = term * pow(value, exponent, PRIME) % PRIME
            basis = entry["secondary"]
            vector[basis] = (vector[basis] + term) % PRIME
        answer[tuple(item["triple"])] = tuple(vector)
    assert len(answer) == 35
    return answer


def basis(index: int):
    return tuple(1 if position == index else 0 for position in range(12))


def multiply(left, right, products):
    answer = [0] * 12
    for i, a in enumerate(left):
        if not a:
            continue
        for j, b in enumerate(right):
            if not b:
                continue
            for k, c in enumerate(products[tuple(sorted((i, j))) ]):
                answer[k] = (answer[k] + a * b * c) % PRIME
    return tuple(answer)


def rank_details(matrix: np.ndarray):
    value = np.array(matrix, dtype=np.int32, order="C", copy=True)
    row_permutation = np.empty(value.shape[0], dtype=np.uintp)
    pivot_columns = np.empty(value.shape[1], dtype=np.uintp)
    library = ctypes.CDLL(FFPACK)
    function = library.RowEchelonForm_modular_int32_t
    function.argtypes = [
        ctypes.c_int32,
        ctypes.c_size_t,
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_int32),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_bool,
        ctypes.c_int,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rank = int(
        function(
            PRIME,
            value.shape[0],
            value.shape[1],
            value.ctypes.data_as(ctypes.POINTER(ctypes.c_int32)),
            value.shape[1],
            row_permutation.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
            pivot_columns.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
            False,
            2,
            True,
        )
    )
    row_order = np.empty_like(row_permutation)
    convert = library.LAPACKPerm2MathPerm
    convert.argtypes = [
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_size_t,
    ]
    convert(
        row_order.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        row_permutation.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
        len(row_order),
    )
    assert sorted(row_order.tolist()) == list(range(len(row_order)))
    return rank, row_order.astype(np.int64)


def rank(matrix: np.ndarray) -> int:
    return rank_details(matrix)[0]


def cubic_rows(indices: tuple[int, ...], points: np.ndarray):
    generic, table = load_inputs()
    width = len(indices)
    variables = 5 * width
    monomials = tuple(itertools.combinations_with_replacement(range(variables), 3))
    monomial_index = {monomial: column for column, monomial in enumerate(monomials)}
    rows = np.zeros((12 * len(points), len(monomials)), dtype=np.int32)
    basis_vectors = {index: basis(index) for index in indices}
    for point_index, raw_values in enumerate(points):
        values = tuple(map(int, raw_values))
        products = specialize_products(table, values)
        coefficients = specialize_coefficients(generic, values)
        block = rows[12 * point_index : 12 * (point_index + 1)]
        for (i, j, k), coefficient in coefficients.items():
            for ii, si in enumerate(indices):
                for jj, sj in enumerate(indices):
                    for kk, sk in enumerate(indices):
                        column = monomial_index[
                            tuple(sorted((i * width + ii, j * width + jj, k * width + kk)))
                        ]
                        value = multiply(coefficient, basis_vectors[si], products)
                        value = multiply(value, basis_vectors[sj], products)
                        value = multiply(value, basis_vectors[sk], products)
                        block[:, column] = (block[:, column] + value) % PRIME
    return rows, monomials


def monomial_text(monomial: tuple[int, ...]) -> str:
    counts = Counter(monomial)
    return "*".join(
        f"a{variable}" if exponent == 1 else f"a{variable}^{exponent}"
        for variable, exponent in sorted(counts.items())
    )


def write_input(case: str, independent: np.ndarray, monomials):
    variables = independent.shape[1]
    # Recover n from C(n+2,3).
    n = next(value for value in range(1, 100) if comb(value + 2, 3) == variables)
    texts = [monomial_text(monomial) for monomial in monomials]
    path = HERE / f"krylov_{case}.in"
    with path.open("w") as stream:
        stream.write(",".join(f"a{i}" for i in range(n)) + f"\n{PRIME}\n")
        for row_index, row in enumerate(independent):
            terms = []
            for column in np.flatnonzero(row):
                coefficient = int(row[column])
                term = texts[int(column)]
                terms.append(term if coefficient == 1 else f"{coefficient}*{term}")
            stream.write("+".join(terms))
            stream.write("\n" if row_index + 1 == len(independent) else ",\n")
    return path


def multiply_degree(rows: np.ndarray, monomials, variables: int, degree: int):
    targets = tuple(itertools.combinations_with_replacement(range(variables), degree + 1))
    target_index = {monomial: index for index, monomial in enumerate(targets)}
    result = np.zeros((len(rows) * variables, len(targets)), dtype=np.int32)
    for row_index, row in enumerate(rows):
        nonzero = np.flatnonzero(row)
        for variable in range(variables):
            target = result[row_index * variables + variable]
            for column in nonzero:
                target[target_index[tuple(sorted(monomials[int(column)] + (variable,)))]] = row[column]
    result_rank, order = rank_details(result)
    return result[order[:result_rank]], targets, result_rank


def parse_leads(text: str, variables: int):
    length = re.search(r"#length of basis:\s+(\d+) elements", text)
    assert length is not None
    expressions = [
        value.strip()
        for value in text[text.index("[") + 1 : text.rindex("]")].split(",")
        if value.strip()
    ]
    leads = []
    for expression in expressions:
        exponents = [0] * variables
        factors = re.findall(r"a(\d+)\^(\d+)", expression)
        assert factors
        for coordinate, exponent in factors:
            exponents[int(coordinate)] = int(exponent)
        assert "*".join(
            f"a{coordinate}^{exponent}"
            for coordinate, exponent in enumerate(exponents)
            if exponent
        ) == expression
        leads.append(tuple(exponents))
    assert len(leads) == int(length.group(1)) == len(set(leads))
    return leads


def hilbert_from_leads(leads, variables: int, maximum_degree: int = 9):
    values = []
    for degree in range(maximum_degree + 1):
        relevant = [lead for lead in leads if sum(lead) <= degree]
        survivors = 0
        for monomial in itertools.combinations_with_replacement(range(variables), degree):
            exponents = [0] * variables
            for coordinate in monomial:
                exponents[coordinate] += 1
            if not any(
                all(left <= right for left, right in zip(lead, exponents))
                for lead in relevant
            ):
                survivors += 1
        values.append(survivors)
        if survivors == 0:
            break
    return values


def run_case(case: str, timeout: int, threads: int):
    indices = CASES[case]
    rng = np.random.default_rng(RNG_SEED)
    points = rng.integers(1, PRIME, size=(SAMPLE_COUNT, 4), dtype=np.int32)
    rows, monomials = cubic_rows(indices, points)
    cubic_rank, order = rank_details(rows)
    independent = rows[order[:cubic_rank]]
    npz = HERE / f"krylov_{case}_rows.npz"
    np.savez_compressed(npz, points=points, rows=rows, independent_indices=order[:cubic_rank])
    input_path = write_input(case, independent, monomials)
    result = {
        "case": case,
        "basis_indices": list(indices),
        "field_characteristic": PRIME,
        "sample_count": SAMPLE_COUNT,
        "rng_seed": RNG_SEED,
        "variables": 5 * len(indices),
        "cubic_monomials": len(monomials),
        "cubic_rank": cubic_rank,
        "rows_file": npz.name,
        "rows_sha256": sha256(npz),
        "rows_semantic_sha256": digest(rows),
        "input_file": input_path.name,
        "input_sha256": sha256(input_path),
        "authoritative_inputs": {
            str(GENERIC.relative_to(PROBLEM)): sha256(GENERIC),
            str(TABLE.relative_to(PROBLEM)): sha256(TABLE),
        },
        "scope": "necessary specialized equations for the displayed constant-Krylov coefficient ansatz",
    }
    if case == "pair":
        degree_rows, degree_monomials = independent, monomials
        hilbert = [1, result["variables"], comb(result["variables"] + 1, 2)]
        for degree in (3, 4, 5):
            if degree == 3:
                current_rank = cubic_rank
            else:
                degree_rows, degree_monomials, current_rank = multiply_degree(
                    degree_rows, degree_monomials, result["variables"], degree - 1
                )
            target = comb(result["variables"] + degree - 1, degree)
            hilbert.append(target - current_rank)
            if current_rank == target:
                break
        result.update(
            {
                "method": "exact homogeneous ideal closure by multiplication",
                "hilbert_function": hilbert,
                "status": "empty" if hilbert[-1] == 0 else "nonempty_or_inconclusive",
            }
        )
    else:
        leading = HERE / f"krylov_{case}_leading.out"
        log = HERE / f"krylov_{case}.log"
        command = [
            "msolve", "-f", str(input_path), "-o", str(leading),
            "-t", str(threads), "-v", "2", "-g", "1", "-l", "2",
            "-q", "0", "-r", "0", "-s", "20", "-m", "2000",
            "--random-seed", "0",
        ]
        started = time.monotonic()
        try:
            completed = subprocess.run(
                command, text=True, stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT, timeout=timeout, check=False,
            )
            log.write_text(completed.stdout)
            result.update(
                {
                    "method": "exact msolve projective leading ideal",
                    "solver_returncode": completed.returncode,
                    "solver_seconds": time.monotonic() - started,
                    "log_file": log.name,
                    "log_sha256": sha256(log),
                    "leading_file": leading.name if leading.is_file() else None,
                    "leading_sha256": sha256(leading) if leading.is_file() and leading.stat().st_size else None,
                    "status": "completed_unparsed" if completed.returncode == 0 else "solver_error",
                }
            )
            if completed.returncode == 0 and leading.is_file() and leading.stat().st_size:
                leads = parse_leads(leading.read_text(), result["variables"])
                hilbert = hilbert_from_leads(leads, result["variables"])
                result.update(
                    {
                        "leading_count": len(leads),
                        "leading_degree_tally": dict(sorted(Counter(map(sum, leads)).items())),
                        "hilbert_function": hilbert,
                        "status": "empty" if hilbert[-1] == 0 else "nonempty_or_inconclusive",
                    }
                )
        except subprocess.TimeoutExpired as error:
            output = error.stdout or ""
            if isinstance(output, bytes):
                output = output.decode(errors="replace")
            log.write_text(output)
            result.update(
                {
                    "method": "exact msolve projective leading ideal",
                    "solver_seconds": time.monotonic() - started,
                    "timeout_seconds": timeout,
                    "log_file": log.name,
                    "log_sha256": sha256(log),
                    "status": "timeout",
                }
            )
    output = HERE / f"krylov_{case}_result.json"
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(json.dumps(result, indent=2, sort_keys=True), flush=True)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("case", choices=tuple(CASES))
    parser.add_argument("--timeout", type=int, default=300)
    parser.add_argument("--threads", type=int, default=4)
    arguments = parser.parse_args()
    assert 30 <= arguments.timeout <= 1800
    assert 1 <= arguments.threads <= 8
    run_case(arguments.case, arguments.timeout, arguments.threads)


if __name__ == "__main__":
    main()
