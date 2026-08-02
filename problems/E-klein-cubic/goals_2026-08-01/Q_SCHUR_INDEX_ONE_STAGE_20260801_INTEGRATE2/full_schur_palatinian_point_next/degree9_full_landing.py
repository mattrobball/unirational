#!/usr/bin/env python3
"""Exact full 19-parameter degree-nine Schur--Palatini test over F_23.

This is deliberately different from ``search_degree9_mod23.py``: every row
is a quartic equation in all 19 coefficients.  Evaluation rows are necessary
conditions for the polynomial identity

    I4(sum_i a_i q_i(x)) == 0.

Consequently, projective emptiness for *any* stored row subset proves that no
nonzero degree-nine self-covariant in the complete 19-dimensional special
fibre lands on the Palatini quartic.  The optional rank computation uses the
degree-36 invariant-space dimension 1157 as a theorem-level upper bound; if
the evaluation rank reaches 1157, the stored rows span the complete landing
equation space, rather than merely a sampled subsystem.
"""
from __future__ import annotations

import argparse
import ctypes
import ctypes.util
import hashlib
import importlib.util
import json
import re
import subprocess
import sys
import time
from collections import Counter
from functools import lru_cache
from math import comb, factorial
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
ROOT = Path("/Users/worker/unirational/problems/E-klein-cubic")
PACKET = ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/full_schur_palatinian"
CHAR_SOURCE = ROOT / "tmp/projective_source/character_scan.py"
PROBE_SOURCE = PACKET / "probe_self_covariants_palatinian.py"
PENCIL_SOURCE = HERE / "pencil_mod23.py"
P = 23
N = 19
DEGREE = 9
INVARIANT_DEGREE = 36
INVARIANT_DIMENSION = 1_157
QUARTIC_MONOMIALS = comb(N + 3, 4)
RAW_X_MONOMIALS = comb(INVARIANT_DEGREE + 5, 5)
ROWS = HERE / "degree9_full_landing_rows.npy"
EXTENSION_ROWS = HERE / "degree9_full_landing_rows_f529.npy"
METADATA = HERE / "degree9_full_landing.json"
NONSQUARE = 5  # F_529 = F_23[u]/(u^2 - 5).


def load(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    spec.loader.exec_module(module)
    return module


probe_core = load("degree9_full_probe", PROBE_SOURCE)
pencil_core = load("degree9_full_pencil", PENCIL_SOURCE)
chars = load("degree9_full_chars", CHAR_SOURCE)


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def multinomial(alpha: tuple[int, ...]) -> int:
    answer = factorial(sum(alpha))
    for exponent in alpha:
        answer //= factorial(exponent)
    return answer


def coefficient_data():
    monomials = probe_core.monomials(4, N)
    assert len(monomials) == QUARTIC_MONOMIALS
    indices = []
    factors = []
    for alpha in monomials:
        ordered = []
        for index, exponent in enumerate(alpha):
            ordered.extend([index] * exponent)
        assert len(ordered) == 4
        indices.append(ordered)
        factors.append(multinomial(alpha))
    return (
        monomials,
        np.asarray(indices, dtype=np.int64),
        np.asarray(factors, dtype=np.int64),
    )


def symmetric_quartic_tensor(quartic):
    tensor = np.zeros((6, 6, 6, 6), dtype=np.int64)
    for alpha, coefficient in quartic.items():
        ordered = []
        for index, exponent in enumerate(alpha):
            ordered.extend([index] * exponent)
        value = coefficient * pow(multinomial(alpha), -1, P) % P
        # Assign the same divided coefficient to all distinct orderings.
        from itertools import permutations

        for indices in set(permutations(ordered)):
            tensor[indices] = value
    return tensor


def invariant_dimension_certificate():
    primes = [23, 67, 89, 199]
    residues = []
    roots = []
    for prime in primes:
        roots.append(chars.configure_prime(prime))
        group = chars.paired_schur_group()
        assert len(group) == 1320
        total = 0
        for v, _ in group:
            total = (
                total
                + chars.complete_symmetric_traces(
                    chars.FANO.inv(v), INVARIANT_DEGREE
                )[INVARIANT_DEGREE]
            ) % prime
        residues.append(total * pow(len(group), -1, prime) % prime)
    value, modulus = chars.crt(residues, primes)
    assert modulus > RAW_X_MONOMIALS
    assert value == INVARIANT_DIMENSION
    return {
        "split_primes": primes,
        "zeta11_roots": roots,
        "residues": residues,
        "crt_value": value,
        "crt_modulus": modulus,
        "elementary_upper_bound": RAW_X_MONOMIALS,
    }


def fast_seed_values(probe, basis, point):
    transformed = np.einsum(
        "gij,j->gi", probe.group, point, optimize=True
    ) % P
    answer = []
    for output, exponents in basis:
        values = np.ones(len(probe.group), dtype=np.int64)
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                values = (
                    values * np.power(transformed[:, coordinate], exponent)
                ) % P
        answer.append(
            np.einsum(
                "g,gi->i", values, probe.inverse[:, :, output], optimize=True
            ) % P
        )
    return np.stack(answer)


def quartic_value(quartic, point):
    answer = 0
    for alpha, coefficient in quartic.items():
        term = coefficient
        for value, exponent in zip(point, alpha):
            if exponent:
                term = term * pow(int(value), exponent, P) % P
        answer += term
    return answer % P


def gf529_multiply(left, right):
    """Multiply arrays of pairs a+b*u with u^2=5."""
    return np.stack(
        [
            (left[..., 0] * right[..., 0]
             + NONSQUARE * left[..., 1] * right[..., 1]) % P,
            (left[..., 0] * right[..., 1]
             + left[..., 1] * right[..., 0]) % P,
        ],
        axis=-1,
    )


def gf529_power(value, exponent):
    answer = np.zeros_like(value)
    answer[..., 0] = 1
    base = value
    while exponent:
        if exponent & 1:
            answer = gf529_multiply(answer, base)
        exponent //= 2
        if exponent:
            base = gf529_multiply(base, base)
    return answer


def extension_seed_values(probe, basis, point):
    assert point.shape == (6, 2)
    transformed = np.stack(
        [
            np.einsum(
                "gij,j->gi", probe.group, point[:, component], optimize=True
            ) % P
            for component in range(2)
        ],
        axis=-1,
    )
    answer = []
    for output, exponents in basis:
        values = np.zeros((len(probe.group), 2), dtype=np.int64)
        values[:, 0] = 1
        for coordinate, exponent in enumerate(exponents):
            if exponent:
                values = gf529_multiply(
                    values, gf529_power(transformed[:, coordinate], exponent)
                )
        answer.append(
            np.stack(
                [
                    np.einsum(
                        "g,gi->i",
                        values[:, component],
                        probe.inverse[:, :, output],
                        optimize=True,
                    ) % P
                    for component in range(2)
                ],
                axis=-1,
            )
        )
    return np.stack(answer)


def gf529_quartic_value(quartic, point):
    answer = np.zeros(2, dtype=np.int64)
    for alpha, coefficient in quartic.items():
        term = np.asarray([coefficient, 0], dtype=np.int64)
        for value, exponent in zip(point, alpha):
            if exponent:
                term = gf529_multiply(term, gf529_power(value, exponent))
        answer = (answer + term) % P
    return answer


def extension_ordered_tensors(tensor, outputs):
    """Real/imaginary coefficient tensors after an F_529 evaluation."""
    assert outputs.shape == (N, 6, 2)
    answer = [np.zeros((N, N, N, N), dtype=np.int64) for _ in range(2)]
    for mask in range(16):
        components = [(mask >> axis) & 1 for axis in range(4)]
        count = sum(components)
        term = np.einsum(
            "rstu,ir,js,kt,lu->ijkl",
            tensor,
            outputs[:, :, components[0]],
            outputs[:, :, components[1]],
            outputs[:, :, components[2]],
            outputs[:, :, components[3]],
            optimize=True,
        ) % P
        component = count % 2
        scale = pow(NONSQUARE, count // 2, P)
        answer[component] = (answer[component] + scale * term) % P
    return answer


def coefficient_monomial_values(monomials, point):
    answer = np.ones(len(monomials), dtype=np.int64)
    for column, alpha in enumerate(monomials):
        for value, exponent in zip(point, alpha):
            if exponent:
                answer[column] = (
                    answer[column] * pow(int(value), exponent, P)
                ) % P
    return answer


def load_ffpack():
    candidates = [
        ctypes.util.find_library("ffpack_c"),
        "/opt/homebrew/lib/libffpack_c.dylib",
        "/usr/local/lib/libffpack_c.dylib",
        "/usr/lib/libffpack_c.so",
    ]
    for candidate in candidates:
        if not candidate:
            continue
        try:
            return ctypes.CDLL(candidate), candidate
        except OSError:
            pass
    raise RuntimeError("could not load libffpack_c")


def rank_mod_prime(rows, profile=False):
    library, library_name = load_ffpack()
    matrix = np.ascontiguousarray(rows, dtype=np.float64)
    if profile:
        function = library.RowRankProfile_modular_double
        function.argtypes = [
            ctypes.c_double,
            ctypes.c_size_t,
            ctypes.c_size_t,
            ctypes.POINTER(ctypes.c_double),
            ctypes.c_size_t,
            ctypes.POINTER(ctypes.POINTER(ctypes.c_size_t)),
            ctypes.c_int,
            ctypes.c_bool,
        ]
        function.restype = ctypes.c_size_t
        pointer = ctypes.POINTER(ctypes.c_size_t)()
        rank = int(
            function(
                float(P),
                matrix.shape[0],
                matrix.shape[1],
                matrix.ctypes.data_as(ctypes.POINTER(ctypes.c_double)),
                matrix.shape[1],
                ctypes.byref(pointer),
                2,
                True,
            )
        )
        indices = [int(pointer[index]) for index in range(rank)]
        ctypes.CDLL(None).free(pointer)
        return rank, library_name, indices
    function = library.Rank_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_double),
        ctypes.c_size_t,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    rank = int(
        function(
            float(P),
            matrix.shape[0],
            matrix.shape[1],
            matrix.ctypes.data_as(ctypes.POINTER(ctypes.c_double)),
            matrix.shape[1],
            True,
        )
    )
    return rank, library_name, None


def generate(sample_count: int):
    assert sample_count >= 1
    started = time.monotonic()
    invariant_certificate = invariant_dimension_certificate()
    probe = probe_core.Probe()
    basis = probe.basis(DEGREE, N)
    quartic, _ = pencil_core.reconstruct()
    tensor = symmetric_quartic_tensor(quartic)
    monomials, indices, factors = coefficient_data()
    rng = np.random.default_rng(2026080119)
    points = [rng.integers(0, P, 6, dtype=np.int64) for _ in range(sample_count)]
    rows = np.lib.format.open_memmap(
        ROWS, mode="w+", dtype=np.uint8, shape=(sample_count, QUARTIC_MONOMIALS)
    )
    checks = []
    for point_index, point in enumerate(points):
        outputs = fast_seed_values(probe, basis, point)
        assert outputs.shape == (N, 6)
        ordered = np.einsum(
            "rstu,ir,js,kt,lu->ijkl",
            tensor,
            outputs,
            outputs,
            outputs,
            outputs,
            optimize=True,
        ) % P
        row = (
            ordered[
                indices[:, 0], indices[:, 1], indices[:, 2], indices[:, 3]
            ]
            * factors
        ) % P
        rows[point_index] = row
        if point_index in (0, sample_count - 1):
            coefficients = rng.integers(0, P, N, dtype=np.int64)
            left = int(
                np.dot(row, coefficient_monomial_values(monomials, coefficients))
                % P
            )
            right = quartic_value(quartic, coefficients @ outputs % P)
            assert left == right
            slow_outputs = np.stack(
                [probe.eval_seed(*seed, point) for seed in basis]
            )
            assert np.array_equal(outputs, slow_outputs)
            checks.append(
                {
                    "point_index": point_index,
                    "coefficient_vector": coefficients.tolist(),
                    "landing_value": left,
                    "checks": ["fast/slow Reynolds", "tensor/direct I4"],
                }
            )
        if (point_index + 1) % 100 == 0 or point_index + 1 == sample_count:
            rows.flush()
            print(
                f"generated={point_index + 1}/{sample_count} "
                f"elapsedSeconds={time.monotonic() - started:.3f}",
                flush=True,
            )
    del rows

    saved = np.load(ROWS, mmap_mode="r")
    rank_started = time.monotonic()
    rank, library, profile = rank_mod_prime(saved, profile=True)
    rank_seconds = time.monotonic() - rank_started
    metadata = {
        "field_characteristic": P,
        "scope": "exact necessary landing equations on the full 19-dimensional degree-nine self-covariant space",
        "degree": DEGREE,
        "basis": [[int(output), list(exponents)] for output, exponents in basis],
        "coefficient_dimension": N,
        "coefficient_quartic_monomials": QUARTIC_MONOMIALS,
        "raw_degree36_x_monomials": RAW_X_MONOMIALS,
        "degree36_invariant_dimension": INVARIANT_DIMENSION,
        "invariant_dimension_certificate": invariant_certificate,
        "sample_rng_seed": 2026080119,
        "sample_count": sample_count,
        "sample_points": [point.tolist() for point in points],
        "fast_slow_checks": checks,
        "rows_file": ROWS.name,
        "rows_bytes": ROWS.stat().st_size,
        "rows_sha256": sha256(ROWS),
        "row_rank_over_F23": rank,
        "row_rank_profile": profile,
        "complete_landing_row_span": rank == INVARIANT_DIMENSION,
        "ffpack_library": library,
        "rank_seconds": rank_seconds,
        "elapsed_seconds": time.monotonic() - started,
        "source_sha256": {
            str(PROBE_SOURCE.relative_to(ROOT)): sha256(PROBE_SOURCE),
            str(PENCIL_SOURCE.relative_to(HERE)): sha256(PENCIL_SOURCE),
            str(CHAR_SOURCE.relative_to(ROOT)): sha256(CHAR_SOURCE),
        },
    }
    METADATA.write_text(json.dumps(metadata, indent=2) + "\n")
    print(
        f"rankOverF{P}={rank}/{sample_count} upper={INVARIANT_DIMENSION} "
        f"rankSeconds={rank_seconds:.3f} rowsSha256={metadata['rows_sha256']}",
        flush=True,
    )
    if rank == INVARIANT_DIMENSION:
        print("PASS evaluation rows span the complete degree-nine landing system")
    else:
        print("SCOPE exact evaluation subsystem; completeness not established")


def generate_extension(point_count: int):
    """Append two F_23 rows per F_529 point and test the complete-span bound."""
    assert point_count >= 1
    metadata = json.loads(METADATA.read_text())
    assert sha256(ROWS) == metadata["rows_sha256"]
    base_rows = np.load(ROWS, mmap_mode="r")
    base_count = base_rows.shape[0]
    started = time.monotonic()
    probe = probe_core.Probe()
    basis = probe.basis(DEGREE, N)
    assert [[int(o), list(e)] for o, e in basis] == metadata["basis"]
    quartic, _ = pencil_core.reconstruct()
    tensor = symmetric_quartic_tensor(quartic)
    monomials, indices, factors = coefficient_data()
    rng = np.random.default_rng(2026080129)
    points = [
        rng.integers(0, P, (6, 2), dtype=np.int64)
        for _ in range(point_count)
    ]
    rows = np.lib.format.open_memmap(
        EXTENSION_ROWS,
        mode="w+",
        dtype=np.uint8,
        shape=(base_count + 2 * point_count, QUARTIC_MONOMIALS),
    )
    rows[:base_count] = base_rows
    checks = []
    for point_index, point in enumerate(points):
        outputs = extension_seed_values(probe, basis, point)
        ordered = extension_ordered_tensors(tensor, outputs)
        component_rows = []
        for component in range(2):
            component_rows.append(
                (
                    ordered[component][
                        indices[:, 0],
                        indices[:, 1],
                        indices[:, 2],
                        indices[:, 3],
                    ]
                    * factors
                ) % P
            )
            rows[base_count + 2 * point_index + component] = component_rows[-1]
        if point_index in (0, point_count - 1):
            coefficients = rng.integers(0, P, N, dtype=np.int64)
            monomial_values = coefficient_monomial_values(monomials, coefficients)
            left = np.asarray(
                [int(np.dot(row, monomial_values) % P) for row in component_rows]
            )
            combined = np.stack(
                [
                    coefficients @ outputs[:, :, component] % P
                    for component in range(2)
                ],
                axis=-1,
            )
            right = gf529_quartic_value(quartic, combined)
            assert np.array_equal(left, right)
            checks.append(
                {
                    "point_index": point_index,
                    "coefficient_vector": coefficients.tolist(),
                    "landing_value_pair": left.tolist(),
                    "check": "tensor/direct I4 over F_529",
                }
            )
        if (point_index + 1) % 10 == 0 or point_index + 1 == point_count:
            rows.flush()
            print(
                f"extensionPoints={point_index + 1}/{point_count} "
                f"rows={base_count + 2 * (point_index + 1)} "
                f"elapsedSeconds={time.monotonic() - started:.3f}",
                flush=True,
            )
    del rows
    saved = np.load(EXTENSION_ROWS, mmap_mode="r")
    rank_started = time.monotonic()
    rank, library, profile = rank_mod_prime(saved, profile=True)
    rank_seconds = time.monotonic() - rank_started
    metadata["extension_evaluation"] = {
        "field": "F_23[u]/(u^2-5)",
        "nonsquare": NONSQUARE,
        "point_rng_seed": 2026080129,
        "point_count": point_count,
        "points": [point.tolist() for point in points],
        "component_rows_per_point": 2,
        "fast_slow_checks": checks,
        "combined_rows_file": EXTENSION_ROWS.name,
        "combined_rows_bytes": EXTENSION_ROWS.stat().st_size,
        "combined_rows_sha256": sha256(EXTENSION_ROWS),
        "combined_row_count": saved.shape[0],
        "row_rank_over_F23": rank,
        "row_rank_profile": profile,
        "complete_landing_row_span": rank == INVARIANT_DIMENSION,
        "ffpack_library": library,
        "rank_seconds": rank_seconds,
        "elapsed_seconds": time.monotonic() - started,
    }
    METADATA.write_text(json.dumps(metadata, indent=2) + "\n")
    print(
        f"combinedRankOverF{P}={rank}/{saved.shape[0]} "
        f"upper={INVARIANT_DIMENSION} rankSeconds={rank_seconds:.3f}",
        flush=True,
    )
    if rank == INVARIANT_DIMENSION:
        print("PASS F_529 evaluation rows span the complete degree-nine landing system")
    else:
        print("SCOPE extension evaluation subsystem; completeness not established")


def monomial_text(alpha):
    factors = []
    for index, exponent in enumerate(alpha):
        if exponent == 1:
            factors.append(f"a{index}")
        elif exponent:
            factors.append(f"a{index}^{exponent}")
    return "*".join(factors) or "1"


def write_msolve(row_count: int):
    metadata = json.loads(METADATA.read_text())
    assert sha256(ROWS) == metadata["rows_sha256"]
    assert 1 <= row_count <= metadata["sample_count"]
    rows = np.load(ROWS, mmap_mode="r")
    monomials, _, _ = coefficient_data()
    texts = [monomial_text(alpha) for alpha in monomials]
    path = HERE / f"degree9_full_landing_{row_count}.in"
    with path.open("w") as stream:
        stream.write(",".join(f"a{i}" for i in range(N)) + "\n")
        stream.write(str(P) + "\n")
        for equation_index in range(row_count):
            row = rows[equation_index]
            nonzero = np.flatnonzero(row)
            terms = []
            for column in nonzero:
                coefficient = int(row[column])
                monomial = texts[int(column)]
                terms.append(
                    monomial if coefficient == 1 else f"{coefficient}*{monomial}"
                )
            stream.write("+".join(terms))
            stream.write("\n" if equation_index + 1 == row_count else ",\n")
    metadata.setdefault("solver_inputs", {})[str(row_count)] = {
        "file": path.name,
        "bytes": path.stat().st_size,
        "sha256": sha256(path),
        "equations": row_count,
        "variables": N,
        "degree": 4,
    }
    METADATA.write_text(json.dumps(metadata, indent=2) + "\n")
    print(
        f"input={path.name} equations={row_count} bytes={path.stat().st_size} "
        f"sha256={sha256(path)}"
    )


def run_msolve(row_count: int, timeout: int, threads: int, max_pairs: int):
    metadata = json.loads(METADATA.read_text())
    input_info = metadata["solver_inputs"][str(row_count)]
    source = HERE / input_info["file"]
    assert sha256(source) == input_info["sha256"]
    leading = HERE / f"degree9_full_landing_{row_count}_leading.out"
    log = HERE / f"degree9_full_landing_{row_count}_msolve.log"
    result_path = HERE / f"degree9_full_landing_{row_count}_result.json"
    command = [
        "msolve", "-f", str(source), "-o", str(leading),
        "-t", str(threads), "-v", "2", "-g", "1", "-l", "2",
        "-q", "0", "-r", "0", "-s", "20", "-m", str(max_pairs),
        "--random-seed", "0",
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
        log.write_text(output)
        result = {
            "status": "timeout_nonverdict",
            "equations": row_count,
            "timeout_seconds": timeout,
            "max_pairs_per_matrix": max_pairs,
            "elapsed_seconds": time.monotonic() - started,
            "input_file": source.name,
            "input_bytes": source.stat().st_size,
            "input_sha256": sha256(source),
            "log_file": log.name,
            "log_bytes": log.stat().st_size,
            "log_sha256": sha256(log),
        }
        result_path.write_text(json.dumps(result, indent=2) + "\n")
        print(json.dumps(result, indent=2), flush=True)
        return
    log.write_text(completed.stdout)
    result = {
        "status": "completed_needs_leading_audit",
        "equations": row_count,
        "returncode": completed.returncode,
        "elapsed_seconds": time.monotonic() - started,
        "max_pairs_per_matrix": max_pairs,
        "input_file": source.name,
        "input_bytes": source.stat().st_size,
        "input_sha256": sha256(source),
        "log_file": log.name,
        "log_bytes": log.stat().st_size,
        "log_sha256": sha256(log),
        "leading_file": leading.name if leading.exists() else None,
        "leading_bytes": leading.stat().st_size if leading.exists() else None,
        "leading_sha256": sha256(leading) if leading.exists() else None,
    }
    result_path.write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps(result, indent=2), flush=True)


def main():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)
    generate_parser = subparsers.add_parser("generate")
    generate_parser.add_argument("--samples", type=int, default=1_300)
    input_parser = subparsers.add_parser("write-msolve")
    input_parser.add_argument("--rows", type=int, required=True)
    solve_parser = subparsers.add_parser("run-msolve")
    solve_parser.add_argument("--rows", type=int, required=True)
    solve_parser.add_argument("--timeout", type=int, default=300)
    solve_parser.add_argument("--threads", type=int, default=4)
    solve_parser.add_argument("--max-pairs", type=int, default=32)
    extension_parser = subparsers.add_parser("generate-extension")
    extension_parser.add_argument("--points", type=int, default=100)
    arguments = parser.parse_args()
    if arguments.command == "generate":
        generate(arguments.samples)
    elif arguments.command == "generate-extension":
        generate_extension(arguments.points)
    elif arguments.command == "write-msolve":
        write_msolve(arguments.rows)
    else:
        run_msolve(arguments.rows, arguments.timeout, arguments.threads, arguments.max_pairs)


if __name__ == "__main__":
    main()
