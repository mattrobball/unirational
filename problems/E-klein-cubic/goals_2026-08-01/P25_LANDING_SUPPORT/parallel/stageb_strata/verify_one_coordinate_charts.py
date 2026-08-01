#!/usr/bin/env python3
"""Independent exact rank replay for certified one-coordinate charts."""

from __future__ import annotations

import argparse
import ctypes
import gc
import hashlib
from itertools import combinations_with_replacement
import json
from pathlib import Path
import resource
import time

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
SOURCE = P25 / "syzygy_r256_q0_contracted.npz"
DEFAULT_CERTIFICATES = HERE / "one_coordinate_chart_certificates.json"
DEFAULT_RESULT = HERE / "verify_one_coordinate_charts_result.json"
P = 89
EXPECTED_SOURCE_SHA256 = (
    "2e718c491172480e3aa3f055d5806d28a9414db2627e6daf3f0204bdc3b840ea"
)
L_COORDINATES = tuple(range(4, 12))


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def exact_monomials(total: int, variables: int) -> list[tuple[int, ...]]:
    output = []
    for choices in combinations_with_replacement(range(variables), total):
        powers = [0] * variables
        for choice in choices:
            powers[choice] += 1
        output.append(tuple(powers))
    return sorted(output)


def bounded_monomials(total: int, variables: int) -> list[tuple[int, ...]]:
    return [m for degree in range(total + 1) for m in exact_monomials(degree, variables)]


def chart_tensor(
    p3: np.ndarray,
    global_cubics: list[tuple[int, ...]],
    chart: int,
) -> tuple[np.ndarray, np.ndarray]:
    local = bounded_monomials(3, 8)
    lookup = {monomial: index for index, monomial in enumerate(local)}
    tensor = np.zeros((256, 6, len(local)), dtype=np.uint8)
    keep = set(L_COORDINATES) | {chart}
    for global_index, exponent in enumerate(global_cubics):
        if all(power == 0 or coordinate in keep for coordinate, power in enumerate(exponent)):
            dehomogenized = tuple(exponent[coordinate] for coordinate in L_COORDINATES)
            tensor[:, :, lookup[dehomogenized]] = p3[:, :, global_index]
    rows = np.flatnonzero(np.any(tensor != 0, axis=(1, 2))).astype(np.int32)
    return np.ascontiguousarray(tensor[rows]), rows


def build_map(
    tensor: np.ndarray, degree: int, include_units: bool
) -> tuple[np.ndarray, int, int]:
    cubics = bounded_monomials(3, 8)
    multipliers = bounded_monomials(degree, 8)
    targets = bounded_monomials(degree + 3, 8)
    target_lookup = {monomial: index for index, monomial in enumerate(targets)}
    product = np.asarray(
        [
            [
                target_lookup[tuple(x + y for x, y in zip(multiplier, cubic))]
                for cubic in cubics
            ]
            for multiplier in multipliers
        ],
        dtype=np.int32,
    )
    source_rows = len(tensor) * len(multipliers)
    target_columns = 6 * len(targets)
    total_rows = source_rows + (6 if include_units else 0)
    matrix = np.zeros((total_rows, target_columns), dtype=np.float64)
    local_rows = np.arange(len(multipliers), dtype=np.intp)[:, None]
    for generator in range(len(tensor)):
        rows = generator * len(multipliers) + local_rows
        for component in range(6):
            columns = component * len(targets) + product
            matrix[rows, columns] = tensor[generator, component][None, :]
    constant_index = targets.index((0,) * 8)
    if include_units:
        for component in range(6):
            matrix[
                source_rows + component,
                component * len(targets) + constant_index,
            ] = 1
    return matrix, constant_index, source_rows


def fflas_rank(matrix: np.ndarray) -> int:
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.Rank_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    return int(
        function(
            float(P),
            matrix.shape[0],
            matrix.shape[1],
            matrix,
            matrix.shape[1],
            False,
        )
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--certificates", type=Path, default=DEFAULT_CERTIFICATES)
    parser.add_argument("--output", type=Path, default=DEFAULT_RESULT)
    args = parser.parse_args()
    certificate_path = (
        args.certificates if args.certificates.is_absolute() else HERE / args.certificates
    )
    output_path = args.output if args.output.is_absolute() else HERE / args.output
    if certificate_path.parent.resolve() != HERE.resolve():
        raise ValueError("--certificates must be in the stageb_strata worker directory")
    if output_path.parent.resolve() != HERE.resolve():
        raise ValueError("--output must stay in the stageb_strata worker directory")
    started = time.monotonic()
    certificates = json.loads(certificate_path.read_text())
    source_hash = sha256_file(SOURCE)
    if source_hash != EXPECTED_SOURCE_SHA256 or certificates["source_sha256"] != source_hash:
        raise RuntimeError("sealed source hash mismatch")
    with np.load(SOURCE) as frozen:
        p3 = frozen["p3"].astype(np.uint8)
        chosen = frozen["chosen_syzygies"].astype(np.int32)
        if int(frozen["prime"]) != P:
            raise RuntimeError("source prime mismatch")
    global_cubics = exact_monomials(3, 37)
    entries_by_chart = {
        int(entry["chart_coordinate"]): entry for entry in certificates["chart_results"]
    }
    replayed = []
    for chart in certificates["certified_unit_charts"]:
        chart = int(chart)
        entry = entries_by_chart[chart]
        degree = int(entry["first_unit_multiplier_degree"])
        tensor, rows = chart_tensor(p3, global_cubics, chart)
        if rows.astype(int).tolist() != entry["global_generator_ordinals"]:
            raise RuntimeError(f"q{chart}: generator row list mismatch")
        if chosen[rows].astype(int).tolist() != entry["source_syzygy_indices"]:
            raise RuntimeError(f"q{chart}: source syzygy list mismatch")
        if sha256_array(tensor) != entry["affine_cubic_tensor_uint8_sha256"]:
            raise RuntimeError(f"q{chart}: affine tensor hash mismatch")

        augmented, constant_index, source_rows = build_map(
            tensor, degree, include_units=True
        )
        rank_augmented = fflas_rank(augmented)
        del augmented
        gc.collect()
        # FFLAS overwrites its input, so rebuild the source map independently
        # before the second rank computation.
        source_rebuilt, second_constant_index, second_source_rows = build_map(
            tensor, degree, include_units=False
        )
        if second_constant_index != constant_index or second_source_rows != source_rows:
            raise RuntimeError("constant monomial index changed")
        rank_source = fflas_rank(source_rebuilt)
        if rank_source != rank_augmented:
            raise RuntimeError(
                f"q{chart}: unit rows increase rank {rank_source} -> {rank_augmented}"
            )
        producer_trial = entry["trials"][degree]
        if rank_augmented != producer_trial["augmented_rank"]:
            raise RuntimeError(f"q{chart}: producer/replay rank mismatch")
        replayed.append(
            {
                "chart_coordinate": chart,
                "multiplier_degree_bound": degree,
                "source_map_shape": list(source_rebuilt.shape),
                "source_rank": rank_source,
                "augmented_rank": rank_augmented,
                "rank_equality": True,
                "verified_unit_module": True,
            }
        )
        print(
            f"PASS q{chart}: rank(source)=rank(augmented)={rank_source}",
            flush=True,
        )

    result = {
        "status": "PASS",
        "prime": P,
        "source_sha256": source_hash,
        "certificate_sha256": sha256_file(certificate_path),
        "replayed_certified_charts": replayed,
        "certified_chart_coordinates": certificates["certified_unit_charts"],
        "not_replayed_not_certified_coordinates": certificates["not_certified_charts"],
        "verified_scope": (
            "Each replayed affine chart has unit r256 row module. Failed bounded "
            "producer charts are not promoted to survivors and were not replayed."
        ),
        "global_scope_guard": "The union does not cover support with at least two coordinates outside L.",
        "backend": "FFLAS-FFPACK 2.5.0 Rank_modular_double",
        "total_seconds": time.monotonic() - started,
        "max_rss_raw": resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
        "max_rss_note": "ru_maxrss units are platform-dependent; on macOS this is bytes",
    }
    output_path.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    print(f"PASS wrote {output_path.name}", flush=True)


if __name__ == "__main__":
    main()
