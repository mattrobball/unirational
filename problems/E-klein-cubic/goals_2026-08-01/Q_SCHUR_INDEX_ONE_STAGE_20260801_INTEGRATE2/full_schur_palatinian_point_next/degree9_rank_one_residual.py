#!/usr/bin/env python3
"""Exact 13-variable residual test after six rank-one eigenline equations.

The F_529 eigenline packet supplies six independent coefficient forms L_j
such that every full degree-nine landing point must satisfy L_j=0.  Their
common kernel is defined over F_23 and has dimension 13.  This script verifies
those fourth-power equations, restricts the complete 19-dimensional
self-covariant family to that kernel, emits exact necessary landing equations
in all 13 residual coefficients, and runs msolve for projective emptiness.
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
import subprocess
import time
from collections import Counter
from functools import lru_cache
from math import comb, factorial
from pathlib import Path

import numpy as np

import degree9_full_landing as landing


HERE = Path(__file__).resolve().parent
EIGENLINES = HERE / "degree9_rank_one_eigenlines_f529.json"
ROWS = HERE / "degree9_rank_one_residual_rows.npy"
METADATA = HERE / "degree9_rank_one_residual.json"
P = 23
AMBIENT = 19
RESIDUAL = 13
MONOMIAL_COUNT = comb(RESIDUAL + 3, 4)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def multinomial(alpha):
    answer = factorial(sum(alpha))
    for exponent in alpha:
        answer //= factorial(exponent)
    return answer


def coefficient_data():
    monomials = landing.probe_core.monomials(4, RESIDUAL)
    indices = []
    factors = []
    for alpha in monomials:
        ordered = []
        for index, exponent in enumerate(alpha):
            ordered.extend([index] * exponent)
        indices.append(ordered)
        factors.append(multinomial(alpha))
    assert len(monomials) == MONOMIAL_COUNT
    return monomials, np.asarray(indices), np.asarray(factors)


def normalized_forms(payload):
    answer = []
    seen = set()
    witnesses = []
    for record in payload["records"]:
        raw = record.get("normalized_coefficient_form")
        if raw is None or not record.get("nonzero_fourth_power_equation"):
            continue
        form = np.asarray(raw, dtype=np.int64) % P
        key = tuple(int(value) for value in form.reshape(-1))
        if key not in seen:
            seen.add(key)
            answer.append(form)
            witnesses.append(record)
    assert len(answer) == 6
    return answer, witnesses


def base_constraints(forms):
    real_forms = [form[:, 0] for form in forms if not np.any(form[:, 1])]
    nonreal = [form for form in forms if np.any(form[:, 1])]
    assert len(real_forms) == 4 and len(nonreal) == 2
    # The two nonreal forms are Frobenius conjugate after the shared
    # normalization.  Their common kernel is cut out by real and imaginary
    # parts of either one.
    assert np.array_equal(nonreal[0][:, 0], nonreal[1][:, 0])
    assert np.array_equal(nonreal[0][:, 1], -nonreal[1][:, 1] % P)
    matrix = np.stack(real_forms + [nonreal[0][:, 0], nonreal[0][:, 1]]) % P
    assert landing.probe_core.fano.rank(matrix) == 6
    kernel = landing.probe_core.fano.nullspace(matrix)
    assert kernel.shape == (AMBIENT, RESIDUAL)
    for form in forms:
        assert np.all(form[:, 0] @ kernel % P == 0)
        assert np.all(form[:, 1] @ kernel % P == 0)
    return matrix, kernel


def verify_witnesses(probe, basis, quartic, forms, witnesses):
    checks = []
    for expected_form, record in zip(forms, witnesses):
        point = np.asarray(record["eigenvector"], dtype=np.int64)
        outputs = landing.extension_seed_values(probe, basis, point)
        nonzero = np.argwhere(np.any(outputs != 0, axis=2))
        assert len(nonzero)
        output_coordinate = int(nonzero[0, 1])
        form = outputs[:, output_coordinate, :]
        form_index = int(np.flatnonzero(np.any(form != 0, axis=1))[0])
        scale = landing.gf529_power(form[form_index], 527)
        normalized = landing.gf529_multiply(form, scale)
        assert np.array_equal(normalized % P, expected_form)
        direction = landing.gf529_multiply(outputs[form_index], scale)
        direction_i4 = landing.gf529_quartic_value(quartic, direction)
        assert np.any(direction_i4)
        # Rank one: every 2x2 minor vanishes in both extension components.
        for left in range(AMBIENT):
            for right in range(left + 1, AMBIENT):
                for i in range(6):
                    for j in range(i + 1, 6):
                        determinant = (
                            landing.gf529_multiply(outputs[left, i], outputs[right, j])
                            - landing.gf529_multiply(outputs[left, j], outputs[right, i])
                        ) % P
                        assert not np.any(determinant)
        checks.append(
            {
                "eigenvector": point.tolist(),
                "normalized_form": normalized.tolist(),
                "direction_I4": direction_i4.tolist(),
                "checks": ["rank-one minors", "nonzero fourth-power scalar"],
            }
        )
    return checks


def generate(sample_count):
    payload = json.loads(EIGENLINES.read_text())
    assert payload["coefficient_form_rank_over_F529"] == 6
    forms, witnesses = normalized_forms(payload)
    constraints, kernel = base_constraints(forms)
    probe = landing.probe_core.Probe()
    basis = probe.basis(9, AMBIENT)
    quartic, _ = landing.pencil_core.reconstruct()
    witness_checks = verify_witnesses(probe, basis, quartic, forms, witnesses)
    tensor = landing.symmetric_quartic_tensor(quartic)
    monomials, indices, factors = coefficient_data()
    rng = np.random.default_rng(2026080139)
    points = [rng.integers(0, P, 6, dtype=np.int64) for _ in range(sample_count)]
    rows = np.lib.format.open_memmap(
        ROWS, mode="w+", dtype=np.uint8, shape=(sample_count, MONOMIAL_COUNT)
    )
    checks = []
    started = time.monotonic()
    for point_index, point in enumerate(points):
        ambient_outputs = landing.fast_seed_values(probe, basis, point)
        outputs = kernel.T @ ambient_outputs % P
        ordered = np.einsum(
            "rstu,ir,js,kt,lu->ijkl",
            tensor, outputs, outputs, outputs, outputs, optimize=True,
        ) % P
        row = (
            ordered[indices[:, 0], indices[:, 1], indices[:, 2], indices[:, 3]]
            * factors
        ) % P
        rows[point_index] = row
        if point_index in (0, sample_count - 1):
            coefficients = rng.integers(0, P, RESIDUAL, dtype=np.int64)
            values = landing.coefficient_monomial_values(monomials, coefficients)
            left = int(np.dot(row, values) % P)
            right = landing.quartic_value(quartic, coefficients @ outputs % P)
            assert left == right
            checks.append(
                {"point_index": point_index,
                 "coefficient_vector": coefficients.tolist(),
                 "landing_value": left,
                 "check": "tensor/direct residual I4"}
            )
    del rows
    saved = np.load(ROWS, mmap_mode="r")
    rank, library, profile = landing.rank_mod_prime(saved, profile=True)
    metadata = {
        "field_characteristic": P,
        "scope": "exact full residual after six necessary fourth-power eigenline equations",
        "ambient_coefficient_dimension": AMBIENT,
        "rank_one_constraint_rank": 6,
        "rank_one_constraints": constraints.tolist(),
        "residual_kernel_basis": kernel.tolist(),
        "residual_dimension": RESIDUAL,
        "quartic_monomials": MONOMIAL_COUNT,
        "eigenline_file": EIGENLINES.name,
        "eigenline_sha256": sha256(EIGENLINES),
        "eigenline_witness_checks": witness_checks,
        "sample_rng_seed": 2026080139,
        "sample_count": sample_count,
        "sample_points": [point.tolist() for point in points],
        "tensor_checks": checks,
        "rows_file": ROWS.name,
        "rows_bytes": ROWS.stat().st_size,
        "rows_sha256": sha256(ROWS),
        "row_rank_over_F23": rank,
        "row_rank_profile": profile,
        "ffpack_library": library,
        "elapsed_seconds": time.monotonic() - started,
    }
    METADATA.write_text(json.dumps(metadata, indent=2) + "\n")
    print(
        f"constraints=6 residualDimension={RESIDUAL} rows={sample_count} "
        f"quarticMonomials={MONOMIAL_COUNT} rank={rank}"
    )


def monomial_text(alpha):
    factors = []
    for index, exponent in enumerate(alpha):
        if exponent == 1:
            factors.append(f"c{index}")
        elif exponent:
            factors.append(f"c{index}^{exponent}")
    return "*".join(factors) or "1"


def write_input(row_count):
    metadata = json.loads(METADATA.read_text())
    assert sha256(ROWS) == metadata["rows_sha256"]
    assert 1 <= row_count <= metadata["sample_count"]
    rows = np.load(ROWS, mmap_mode="r")
    monomials, _, _ = coefficient_data()
    texts = [monomial_text(alpha) for alpha in monomials]
    path = HERE / f"degree9_rank_one_residual_{row_count}.in"
    with path.open("w") as stream:
        stream.write(",".join(f"c{i}" for i in range(RESIDUAL)) + "\n")
        stream.write(str(P) + "\n")
        for equation_index in range(row_count):
            row = rows[equation_index]
            terms = []
            for column in np.flatnonzero(row):
                coefficient = int(row[column])
                text = texts[int(column)]
                terms.append(text if coefficient == 1 else f"{coefficient}*{text}")
            stream.write("+".join(terms))
            stream.write("\n" if equation_index + 1 == row_count else ",\n")
    metadata.setdefault("solver_inputs", {})[str(row_count)] = {
        "file": path.name, "bytes": path.stat().st_size,
        "sha256": sha256(path), "equations": row_count,
    }
    METADATA.write_text(json.dumps(metadata, indent=2) + "\n")
    print(f"input={path.name} bytes={path.stat().st_size} sha256={sha256(path)}")


@lru_cache(maxsize=None)
def compositions(total, slots):
    answer = []
    def visit(prefix, remaining, left):
        if left == 1:
            answer.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, left - 1)
    visit((), total, slots)
    return tuple(answer)


def parse_leads(text):
    match = re.search(r"#length of basis:\s+(\d+) elements", text)
    assert match
    expressions = [part.strip() for part in text[text.index("[") + 1:text.rindex("]")].split(",")]
    expressions = [expression for expression in expressions if expression]
    leads = []
    for expression in expressions:
        exponents = [0] * RESIDUAL
        factors = re.findall(r"c(\d+)\^(\d+)", expression)
        assert factors and "*".join(f"c{i}^{e}" for i, e in factors) == expression
        for coordinate, exponent in factors:
            exponents[int(coordinate)] = int(exponent)
        leads.append(tuple(exponents))
    assert len(leads) == int(match.group(1))
    return leads


def hilbert_value(leads, degree):
    all_monomials = compositions(degree, RESIDUAL)
    uncovered = 0
    for monomial in all_monomials:
        if not any(all(a <= b for a, b in zip(lead, monomial)) for lead in leads):
            uncovered += 1
    return uncovered


def run_solver(row_count, timeout, threads, max_pairs):
    metadata = json.loads(METADATA.read_text())
    info = metadata["solver_inputs"][str(row_count)]
    source = HERE / info["file"]
    assert sha256(source) == info["sha256"]
    leading = HERE / f"degree9_rank_one_residual_{row_count}_leading.out"
    log = HERE / f"degree9_rank_one_residual_{row_count}_msolve.log"
    result_path = HERE / f"degree9_rank_one_residual_{row_count}_result.json"
    command = [
        "msolve", "-f", str(source), "-o", str(leading),
        "-t", str(threads), "-v", "2", "-g", "1", "-l", "2",
        "-q", "0", "-r", "0", "-s", "20", "-m", str(max_pairs),
        "--random-seed", "0",
    ]
    started = time.monotonic()
    try:
        completed = subprocess.run(
            command, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
            timeout=timeout, check=False,
        )
    except subprocess.TimeoutExpired as error:
        output = error.stdout or ""
        if isinstance(output, bytes):
            output = output.decode(errors="replace")
        log.write_text(output)
        result = {
            "status": "timeout_nonverdict", "equations": row_count,
            "elapsed_seconds": time.monotonic() - started,
            "timeout_seconds": timeout, "max_pairs": max_pairs,
            "input_file": source.name, "input_bytes": source.stat().st_size,
            "input_sha256": sha256(source), "log_file": log.name,
            "log_sha256": sha256(log),
        }
        result_path.write_text(json.dumps(result, indent=2) + "\n")
        print(json.dumps(result, indent=2))
        return
    log.write_text(completed.stdout)
    assert completed.returncode == 0 and leading.exists(), completed.stdout
    leads = parse_leads(leading.read_text())
    hilbert = []
    for degree in range(20):
        hilbert.append(hilbert_value(leads, degree))
        if hilbert[-1] == 0:
            break
    result = {
        "status": "projectively_empty" if hilbert[-1] == 0 else "completed_nonverdict",
        "equations": row_count, "elapsed_seconds": time.monotonic() - started,
        "leading_monomials": len(leads),
        "leading_degree_tally": dict(sorted(Counter(map(sum, leads)).items())),
        "hilbert_function": hilbert,
        "input_file": source.name, "input_bytes": source.stat().st_size,
        "input_sha256": sha256(source), "log_file": log.name,
        "log_sha256": sha256(log), "leading_file": leading.name,
        "leading_sha256": sha256(leading),
    }
    result_path.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2))
    if result["status"] == "projectively_empty":
        print("FULL_DEGREE9_SPECIAL_FIBRE_PROJECTIVE_EMPTINESS_OK")


def main():
    parser = argparse.ArgumentParser()
    commands = parser.add_subparsers(dest="command", required=True)
    producer = commands.add_parser("generate")
    producer.add_argument("--samples", type=int, default=128)
    writer = commands.add_parser("write-msolve")
    writer.add_argument("--rows", type=int, required=True)
    solver = commands.add_parser("run-msolve")
    solver.add_argument("--rows", type=int, required=True)
    solver.add_argument("--timeout", type=int, default=300)
    solver.add_argument("--threads", type=int, default=4)
    solver.add_argument("--max-pairs", type=int, default=64)
    arguments = parser.parse_args()
    if arguments.command == "generate":
        generate(arguments.samples)
    elif arguments.command == "write-msolve":
        write_input(arguments.rows)
    else:
        run_solver(arguments.rows, arguments.timeout, arguments.threads, arguments.max_pairs)


if __name__ == "__main__":
    main()
