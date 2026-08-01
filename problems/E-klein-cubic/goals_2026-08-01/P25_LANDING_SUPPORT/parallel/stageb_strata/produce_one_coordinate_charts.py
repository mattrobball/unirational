#!/usr/bin/env python3
"""Certify affine one-coordinate thickenings of the closed stratum L.

For each i outside {4,...,11}, restrict the r256 cubic module to

    P<span(q_4,...,q_11,q_i)>

and dehomogenize at q_i=1.  In the eight remaining L variables this script
tests whether all six constant module basis vectors lie in the row span of a
bounded affine Macaulay map.  Absence of all six appended constant rows from
the exact FFLAS row-rank profile is a unit-module certificate on that chart.

A failed bounded membership test is recorded only as ``not_certified``.  It
does not produce or assert a rank-drop point.
"""

from __future__ import annotations

import argparse
import ctypes
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
DEFAULT_RESULT = HERE / "one_coordinate_chart_certificates.json"
P = 89
EXPECTED_SOURCE_SHA256 = (
    "2e718c491172480e3aa3f055d5806d28a9414db2627e6daf3f0204bdc3b840ea"
)
L_COORDINATES = tuple(range(4, 12))
OUTSIDE_COORDINATES = tuple(
    coordinate for coordinate in range(37) if coordinate not in L_COORDINATES
)


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(2**20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def monomials_exact(total: int, variables: int) -> list[tuple[int, ...]]:
    answer = []
    for multiset in combinations_with_replacement(range(variables), total):
        exponent = [0] * variables
        for variable in multiset:
            exponent[variable] += 1
        answer.append(tuple(exponent))
    return sorted(answer)


def monomials_upto(total: int, variables: int) -> list[tuple[int, ...]]:
    return [
        exponent
        for degree in range(total + 1)
        for exponent in monomials_exact(degree, variables)
    ]


def restricted_affine_tensor(
    p3: np.ndarray,
    global_cubics: list[tuple[int, ...]],
    chart: int,
) -> tuple[np.ndarray, np.ndarray]:
    local_cubics = monomials_upto(3, len(L_COORDINATES))
    local_index = {monomial: index for index, monomial in enumerate(local_cubics)}
    global_indices = []
    local_indices = []
    retained = set(L_COORDINATES) | {chart}
    for global_index, exponent in enumerate(global_cubics):
        if all(power == 0 or coordinate in retained for coordinate, power in enumerate(exponent)):
            local = tuple(exponent[coordinate] for coordinate in L_COORDINATES)
            global_indices.append(global_index)
            local_indices.append(local_index[local])
    if len(global_indices) != 165 or sorted(local_indices) != list(range(165)):
        raise RuntimeError(f"chart q{chart}: bad dehomogenized cubic indexing")
    tensor = np.zeros((256, 6, len(local_cubics)), dtype=np.uint8)
    tensor[:, :, local_indices] = p3[:, :, global_indices]
    nonzero_rows = np.flatnonzero(np.any(tensor != 0, axis=(1, 2))).astype(np.int32)
    return np.ascontiguousarray(tensor[nonzero_rows]), nonzero_rows


def multiplication_table(
    multipliers: list[tuple[int, ...]],
    cubics: list[tuple[int, ...]],
    targets: list[tuple[int, ...]],
) -> np.ndarray:
    target_index = {monomial: index for index, monomial in enumerate(targets)}
    return np.asarray(
        [
            [
                target_index[tuple(x + y for x, y in zip(multiplier, cubic))]
                for cubic in cubics
            ]
            for multiplier in multipliers
        ],
        dtype=np.int32,
    )


def build_augmented_map(
    tensor: np.ndarray,
    multipliers: list[tuple[int, ...]],
    targets: list[tuple[int, ...]],
    multiplication: np.ndarray,
) -> tuple[np.ndarray, int]:
    generators, components, cubic_count = tensor.shape
    source_rows = generators * len(multipliers)
    target_columns = components * len(targets)
    matrix = np.zeros((source_rows + components, target_columns), dtype=np.float64)
    local_rows = np.arange(len(multipliers), dtype=np.intp)[:, None]
    for generator in range(generators):
        rows = generator * len(multipliers) + local_rows
        for component in range(components):
            columns = component * len(targets) + multiplication
            matrix[rows, columns] = tensor[generator, component][None, :]
    constant_index = targets.index((0,) * len(L_COORDINATES))
    for component in range(components):
        matrix[source_rows + component, component * len(targets) + constant_index] = 1
    expected_nnz = int(np.count_nonzero(tensor)) * len(multipliers) + components
    if int(np.count_nonzero(matrix)) != expected_nnz:
        raise RuntimeError("affine Macaulay nonzero-entry census failed")
    return matrix, source_rows


def fflas_row_rank_profile(matrix: np.ndarray) -> tuple[int, np.ndarray]:
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.RowRankProfile_modular_double
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_size_t)),
        ctypes.c_int,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    pointer = ctypes.POINTER(ctypes.c_size_t)()
    rows, columns = matrix.shape
    rank = int(
        function(
            float(P),
            rows,
            columns,
            matrix,
            columns,
            ctypes.byref(pointer),
            2,
            False,
        )
    )
    profile = np.ctypeslib.as_array(pointer, shape=(rank,)).copy().astype(np.int32)
    return rank, profile


def parse_charts(specification: str) -> list[int]:
    if not specification:
        return list(OUTSIDE_COORDINATES)
    charts = sorted({int(piece) for piece in specification.split(",")})
    if not charts or any(chart not in OUTSIDE_COORDINATES for chart in charts):
        raise ValueError("--charts must list coordinates outside 4,...,11")
    return charts


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--max-multiplier-degree", type=int, default=2, choices=(0, 1, 2, 3)
    )
    parser.add_argument("--charts", default="", help="comma-separated subset; default is all 29")
    parser.add_argument(
        "--output",
        type=Path,
        default=DEFAULT_RESULT,
        help="result JSON path; relative paths are resolved in this worker directory",
    )
    args = parser.parse_args()
    charts = parse_charts(args.charts)
    started = time.monotonic()
    source_hash = sha256_file(SOURCE)
    if source_hash != EXPECTED_SOURCE_SHA256:
        raise RuntimeError(f"sealed source hash changed: {source_hash}")
    global_cubics = monomials_exact(3, 37)
    local_cubics = monomials_upto(3, 8)
    with np.load(SOURCE) as frozen:
        if int(frozen["prime"]) != P or frozen["p3"].shape != (256, 6, 9139):
            raise RuntimeError("unexpected sealed source metadata")
        p3 = frozen["p3"].astype(np.uint8)
        chosen_syzygies = frozen["chosen_syzygies"].astype(np.int32)

    chart_results = []
    for chart in charts:
        tensor, nonzero_rows = restricted_affine_tensor(p3, global_cubics, chart)
        print(
            f"chart q{chart}: generators={len(tensor)} coeff_nnz={np.count_nonzero(tensor)}",
            flush=True,
        )
        trials = []
        unit_degree = None
        for degree in range(args.max_multiplier_degree + 1):
            multipliers = monomials_upto(degree, 8)
            targets = monomials_upto(degree + 3, 8)
            multiplication = multiplication_table(multipliers, local_cubics, targets)
            matrix, source_rows = build_augmented_map(
                tensor, multipliers, targets, multiplication
            )
            trial_started = time.monotonic()
            rank, profile = fflas_row_rank_profile(matrix)
            trial_seconds = time.monotonic() - trial_started
            selected_unit_components = sorted(
                int(ordinal - source_rows) for ordinal in profile if ordinal >= source_rows
            )
            unit = selected_unit_components == []
            trial = {
                "multiplier_degree_bound": degree,
                "source_multipliers": len(multipliers),
                "source_rows": source_rows,
                "target_columns": len(targets) * 6,
                "augmented_rows": source_rows + 6,
                "augmented_rank": rank,
                "selected_appended_unit_components": selected_unit_components,
                "all_six_units_in_source_row_span": unit,
                "rank_profile_int32_sha256": sha256_array(profile),
                "rank_seconds": trial_seconds,
            }
            trials.append(trial)
            print(
                f"  d={degree} rank={rank} selected_units={selected_unit_components} "
                f"seconds={trial_seconds:.3f}",
                flush=True,
            )
            if unit:
                unit_degree = degree
                break
        chart_results.append(
            {
                "chart_coordinate": chart,
                "projective_slice_coordinates": list(L_COORDINATES) + [chart],
                "affine_definition": f"q_{chart}=1 and q_j=0 outside {{4,...,11,{chart}}}",
                "nonzero_generator_count": len(tensor),
                "global_generator_ordinals": nonzero_rows.astype(int).tolist(),
                "source_syzygy_indices": chosen_syzygies[nonzero_rows].astype(int).tolist(),
                "affine_cubic_tensor_shape": list(tensor.shape),
                "affine_cubic_tensor_uint8_sha256": sha256_array(tensor),
                "affine_cubic_tensor_nonzero_coefficients": int(np.count_nonzero(tensor)),
                "trials": trials,
                "unit_certificate": unit_degree is not None,
                "first_unit_multiplier_degree": unit_degree,
                "conclusion": (
                    "r256 rank-drop locus is empty on this affine chart"
                    if unit_degree is not None
                    else "not certified at the tested multiplier-degree bound"
                ),
                "scope_guard": (
                    "A failed bounded test is not a rank-drop survivor and is inconclusive."
                ),
            }
        )

    certified = [entry["chart_coordinate"] for entry in chart_results if entry["unit_certificate"]]
    unresolved = [entry["chart_coordinate"] for entry in chart_results if not entry["unit_certificate"]]
    payload = {
        "certificate_kind": "one-coordinate affine module chart cover around closed L",
        "prime": P,
        "source_sha256": source_hash,
        "closed_L_coordinates": list(L_COORDINATES),
        "outside_coordinate_cover": list(OUTSIDE_COORDINATES),
        "charts_requested": charts,
        "max_multiplier_degree": args.max_multiplier_degree,
        "chart_results": chart_results,
        "certified_unit_charts": certified,
        "not_certified_charts": unresolved,
        "proved_scope": (
            "For each certified i, the r256 rank-drop locus is empty on "
            "P<span(L,q_i)> minus L. Combined with the separate closed-L "
            "certificate, the whole coordinate P^8 slice is empty."
        ),
        "global_scope_guard": (
            "These 29 one-coordinate slices do not cover points with two or "
            "more nonzero coordinates outside L. No global Stage-B conclusion follows."
        ),
        "backend": "FFLAS-FFPACK 2.5.0 RowRankProfile_modular_double, PLUQ",
        "total_seconds": time.monotonic() - started,
        "max_rss_raw": resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
        "max_rss_note": "ru_maxrss units are platform-dependent; on macOS this is bytes",
    }
    output = args.output if args.output.is_absolute() else HERE / args.output
    if output.parent.resolve() != HERE.resolve():
        raise ValueError("--output must stay in the stageb_strata worker directory")
    output.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(
        f"wrote {output.name}: certified={certified} not_certified={unresolved}",
        flush=True,
    )


if __name__ == "__main__":
    main()
