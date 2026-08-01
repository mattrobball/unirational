#!/usr/bin/env python3
"""Produce an exact normalized Stage-C emptiness certificate on L8.

Let A be the degree-six Macaulay map of the 114 nonzero restricted P3 rows:

    A : S_3^114 -> S_6^6,  dimensions 13680 -> 10296.

The independently certified Stage-B result says A is onto, so ker(A) has
dimension 3384.  Contract that complete kernel against the restricted P4 rows,
obtaining 3384 scalar septics.  If their products by the eight L8 coordinates
span S_8 (dimension 6435), then their ideal contains every octic.  Every
normalized Stage-C solution would annihilate all these compatibility septics,
which is impossible projectively.

This is a guarded 2--4 GiB FFLAS job and must not be launched beside another
large exact computation.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import resource
import subprocess
import time

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
SOURCE = P25 / "syzygy_r256_q0_contracted.npz"
CLOSED_CERT = P25 / "parallel" / "stageb_strata" / "closed_L_degree6_certificate.json"
CLOSED_VERIFY = P25 / "parallel" / "stageb_strata" / "verify_closed_L_degree6_result.json"
ARTIFACT = HERE / "closed_L8_stageC_compatibility.npz"
CERTIFICATE = HERE / "closed_L8_stageC_certificate.json"

P = 89
L8 = tuple(range(4, 12))
ROWS = 114


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def array_sha256(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def free_gib() -> float | None:
    try:
        output = subprocess.check_output(["vm_stat"], text=True)
    except (FileNotFoundError, subprocess.CalledProcessError):
        return None
    page_size = 16384
    free = speculative = None
    for line in output.splitlines():
        if line.startswith("Mach Virtual Memory Statistics") and "page size of" in line:
            page_size = int(line.split("page size of", 1)[1].split("bytes", 1)[0])
        elif line.startswith("Pages free:"):
            free = int(line.split(":", 1)[1].strip().rstrip("."))
        elif line.startswith("Pages speculative:"):
            speculative = int(line.split(":", 1)[1].strip().rstrip("."))
    if free is None or speculative is None:
        return None
    return (free + speculative) * page_size / 2**30


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def restriction_indices(
    local: list[tuple[int, ...]], global_basis: list[tuple[int, ...]]
) -> np.ndarray:
    global_index = {monomial: index for index, monomial in enumerate(global_basis)}
    answer: list[int] = []
    for monomial in local:
        exponent = [0] * 37
        for variable, power in zip(L8, monomial):
            exponent[variable] = power
        answer.append(global_index[tuple(exponent)])
    return np.asarray(answer, dtype=np.int32)


def product_map(
    left: list[tuple[int, ...]],
    right: list[tuple[int, ...]],
    target: list[tuple[int, ...]],
) -> np.ndarray:
    target_index = {monomial: index for index, monomial in enumerate(target)}
    answer = np.empty((len(left), len(right)), dtype=np.int32)
    for i, first in enumerate(left):
        for j, second in enumerate(right):
            answer[i, j] = target_index[
                tuple(a + b for a, b in zip(first, second))
            ]
    return answer


def variable_product_map(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    target_index = {monomial: index for index, monomial in enumerate(target)}
    answer = np.empty((8, len(source)), dtype=np.int32)
    for variable in range(8):
        for index, monomial in enumerate(source):
            exponent = list(monomial)
            exponent[variable] += 1
            answer[variable, index] = target_index[tuple(exponent)]
    return answer


def fflas_right_nullspace(matrix: np.ndarray) -> tuple[np.ndarray, int]:
    if matrix.dtype != np.float64 or not matrix.flags.c_contiguous:
        raise TypeError("FFLAS nullspace input must be C-contiguous float64")
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    symbol = (
        "_Z29NullSpaceBasis_modular_doubledN5FFLAS10FFLAS_SIDEEmm"
        "PdmPS1_PmS3_b"
    )
    function = getattr(library, symbol)
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_int,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.POINTER(ctypes.c_double)),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    pointer = ctypes.POINTER(ctypes.c_double)()
    leading = ctypes.c_size_t()
    nullity = ctypes.c_size_t()
    rows, columns = matrix.shape
    returned = function(
        float(P),
        142,  # FflasRight
        rows,
        columns,
        matrix,
        columns,
        ctypes.byref(pointer),
        ctypes.byref(leading),
        ctypes.byref(nullity),
        False,
    )
    if returned != nullity.value or leading.value != nullity.value:
        raise AssertionError("unexpected FFLAS nullspace layout")
    raw = np.ctypeslib.as_array(pointer, shape=(columns * nullity.value,))
    return raw.reshape(columns, nullity.value), int(nullity.value)


def fflas_row_rank_profile(matrix: np.ndarray) -> tuple[int, np.ndarray]:
    if matrix.dtype != np.float64 or not matrix.flags.c_contiguous:
        raise TypeError("FFLAS rank input must be C-contiguous float64")
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
    profile = np.ctypeslib.as_array(pointer, shape=(rank,)).copy()
    return rank, profile.astype(np.int32)


def build_p3_transpose(
    restricted_p3: np.ndarray,
    multiplication: np.ndarray,
    sextic_count: int,
) -> np.ndarray:
    cubic_count = restricted_p3.shape[2]
    source_count = len(restricted_p3) * cubic_count
    target_count = 6 * sextic_count
    matrix = np.zeros((target_count, source_count), dtype=np.float64)
    multipliers = np.arange(cubic_count, dtype=np.intp)[:, None]
    for generator in range(len(restricted_p3)):
        columns = generator * cubic_count + multipliers
        for component in range(6):
            rows = component * sextic_count + multiplication
            matrix[rows, columns] = restricted_p3[generator, component][None, :]
        if (generator + 1) % 20 == 0 or generator + 1 == len(restricted_p3):
            print(f"built P3 generators {generator + 1}/{len(restricted_p3)}", flush=True)
    return matrix


def build_p4_map(
    restricted_p4: np.ndarray,
    multiplication: np.ndarray,
    septic_count: int,
) -> np.ndarray:
    multiplier_count = multiplication.shape[0]
    matrix = np.zeros(
        (len(restricted_p4) * multiplier_count, septic_count), dtype=np.float64
    )
    local_rows = np.arange(multiplier_count, dtype=np.intp)[:, None]
    for generator in range(len(restricted_p4)):
        rows = generator * multiplier_count + local_rows
        matrix[rows, multiplication] = restricted_p4[generator][None, :]
    return matrix


def build_degree8_map(
    compatibility: np.ndarray, multiplication: np.ndarray, octic_count: int
) -> np.ndarray:
    rows = len(compatibility) * 8
    matrix = np.zeros((rows, octic_count), dtype=np.float64)
    for kernel_index in range(len(compatibility)):
        for variable in range(8):
            matrix[kernel_index * 8 + variable, multiplication[variable]] = compatibility[
                kernel_index
            ]
    return matrix


def rebuild_selected_minor(
    compatibility: np.ndarray,
    multiplication: np.ndarray,
    profile: np.ndarray,
    octic_count: int,
) -> np.ndarray:
    minor = np.zeros((len(profile), octic_count), dtype=np.uint8)
    for row, source_ordinal in enumerate(profile):
        kernel_index = int(source_ordinal) // 8
        variable = int(source_ordinal) % 8
        minor[row, multiplication[variable]] = compatibility[kernel_index]
    return minor


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--min-free-gib",
        type=float,
        default=40.0,
        help="refuse the 2--4 GiB exact run below this shared-memory margin",
    )
    args = parser.parse_args()
    observed_free = free_gib()
    if observed_free is not None and observed_free < args.min_free_gib:
        raise SystemExit(
            f"resource guard: free+speculative={observed_free:.2f} GiB "
            f"< required {args.min_free_gib:.2f} GiB"
        )
    for path in (SOURCE, CLOSED_CERT, CLOSED_VERIFY):
        if not path.is_file():
            raise FileNotFoundError(path)
    with CLOSED_VERIFY.open() as handle:
        closed = json.load(handle)
    if closed.get("status") != "PASS" or closed.get("certificate_sha256") != sha256(
        CLOSED_CERT
    ):
        raise AssertionError("closed-L8 Stage-B certificate is not bound")

    started = time.monotonic()
    q3_global = weak_compositions(3, 37)
    q4_global = weak_compositions(4, 37)
    q3 = weak_compositions(3, 8)
    q4 = weak_compositions(4, 8)
    q6 = weak_compositions(6, 8)
    q7 = weak_compositions(7, 8)
    q8 = weak_compositions(8, 8)
    indices3 = restriction_indices(q3, q3_global)
    indices4 = restriction_indices(q4, q4_global)
    multiply33 = product_map(q3, q3, q6)
    multiply34 = product_map(q3, q4, q7)
    multiply78 = variable_product_map(q7, q8)

    with np.load(SOURCE, allow_pickle=False) as frozen:
        p3_all = frozen["p3"].astype(np.uint8)
        p4_all = frozen["p4"].astype(np.uint8)
        if int(frozen["prime"]) != P:
            raise AssertionError("r256 prime mismatch")
    restricted3_all = p3_all[:, :, indices3]
    nonzero = np.flatnonzero(np.any(restricted3_all != 0, axis=(1, 2)))
    if nonzero.tolist() != list(range(142, 256)):
        raise AssertionError("closed-L8 generator set changed")
    restricted3 = np.ascontiguousarray(restricted3_all[nonzero])
    restricted4 = np.ascontiguousarray(p4_all[nonzero][:, indices4])
    if restricted3.shape != (ROWS, 6, 120) or restricted4.shape != (ROWS, 330):
        raise AssertionError("restricted tensor shape mismatch")

    p3_transpose = build_p3_transpose(restricted3, multiply33, len(q6))
    if p3_transpose.shape != (10296, 13680):
        raise AssertionError("P3 Macaulay shape mismatch")
    null_started = time.monotonic()
    kernel_columns, nullity = fflas_right_nullspace(p3_transpose)
    null_seconds = time.monotonic() - null_started
    if nullity != 3384:
        raise AssertionError(f"P3 Macaulay nullity {nullity} != 3384")
    kernel = (
        np.rint(kernel_columns.T).astype(np.int64) % P
    ).astype(np.uint8)
    if kernel.shape != (3384, 13680):
        raise AssertionError("kernel basis shape mismatch")
    del p3_transpose

    # Bind an explicit identity minor proving the stored kernel rows independent.
    kernel_columns_uint8 = kernel.T
    coordinate_nnz = np.count_nonzero(kernel_columns_uint8, axis=1)
    candidate_coordinates = np.flatnonzero(coordinate_nnz == 1)
    identity_coordinates = np.full(3384, -1, dtype=np.int32)
    for coordinate in candidate_coordinates:
        row = int(np.flatnonzero(kernel_columns_uint8[coordinate])[0])
        if kernel_columns_uint8[coordinate, row] == 1 and identity_coordinates[row] < 0:
            identity_coordinates[row] = int(coordinate)
    if np.any(identity_coordinates < 0):
        raise AssertionError("systematic kernel identity coordinates missing")
    if not np.array_equal(
        kernel[:, identity_coordinates], np.eye(3384, dtype=np.uint8)
    ):
        raise AssertionError("kernel systematic minor is not identity")

    p4_map = build_p4_map(restricted4, multiply34, len(q7))
    compat_started = time.monotonic()
    compatibility_double = kernel.astype(np.float64) @ p4_map
    np.remainder(compatibility_double, float(P), out=compatibility_double)
    compatibility = compatibility_double.astype(np.uint8)
    compat_seconds = time.monotonic() - compat_started
    del compatibility_double, p4_map
    if compatibility.shape != (3384, 3432):
        raise AssertionError("compatibility shape mismatch")

    degree8 = build_degree8_map(compatibility, multiply78, len(q8))
    if degree8.shape != (27072, 6435):
        raise AssertionError("degree-eight compatibility shape mismatch")
    rank_started = time.monotonic()
    rank, profile = fflas_row_rank_profile(degree8)
    rank_seconds = time.monotonic() - rank_started
    del degree8
    full_rank = rank == len(q8)
    if not full_rank:
        payload = {
            "status": "CLOSED_L8_STAGEC_UNDECIDED",
            "prime": P,
            "degree8_rank": rank,
            "degree8_target": len(q8),
            "scope": "Rank failure is not a Stage-C point or nonemptiness proof.",
        }
        CERTIFICATE.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
        print(json.dumps(payload, sort_keys=True))
        return

    selected_minor = rebuild_selected_minor(
        compatibility, multiply78, profile, len(q8)
    )
    if selected_minor.shape != (6435, 6435):
        raise AssertionError("selected minor shape mismatch")

    np.savez_compressed(
        ARTIFACT,
        kernel=kernel,
        compatibility=compatibility,
        identity_coordinates=identity_coordinates,
        row_rank_profile=profile,
        selected_minor_uint8_sha256=np.asarray(array_sha256(selected_minor)),
        restricted_p3_uint8_sha256=np.asarray(array_sha256(restricted3)),
        restricted_p4_uint8_sha256=np.asarray(array_sha256(restricted4)),
        multiply33_int32_sha256=np.asarray(array_sha256(multiply33)),
        multiply34_int32_sha256=np.asarray(array_sha256(multiply34)),
        multiply78_int32_sha256=np.asarray(array_sha256(multiply78)),
        source_sha256=np.asarray(sha256(SOURCE)),
        prime=np.int32(P),
    )
    payload = {
        "status": "PASS_CLOSED_L8_STAGEC_EMPTY",
        "prime": P,
        "closed_stratum": "L8=P<span(q4,...,q11)>",
        "source": {
            "path": str(SOURCE.relative_to(P25)),
            "sha256": sha256(SOURCE),
        },
        "stageB_binding": {
            "certificate_sha256": sha256(CLOSED_CERT),
            "independent_replay_sha256": sha256(CLOSED_VERIFY),
            "degree6_rank": 10296,
        },
        "restricted": {
            "rows": nonzero.astype(int).tolist(),
            "p3_shape": list(restricted3.shape),
            "p3_uint8_sha256": array_sha256(restricted3),
            "p4_shape": list(restricted4.shape),
            "p4_uint8_sha256": array_sha256(restricted4),
        },
        "degree6_P3_map": {
            "source_dimension": 13680,
            "target_dimension": 10296,
            "rank": 10296,
            "kernel_dimension": nullity,
            "kernel_shape": list(kernel.shape),
            "kernel_uint8_sha256": array_sha256(kernel),
            "systematic_identity_coordinates_int32_sha256": array_sha256(
                identity_coordinates
            ),
            "nullspace_seconds": null_seconds,
        },
        "compatibility": {
            "scalar_septics": len(compatibility),
            "septic_monomials": compatibility.shape[1],
            "uint8_sha256": array_sha256(compatibility),
            "contraction_seconds": compat_seconds,
        },
        "degree8_map": {
            "source_dimension": len(compatibility) * 8,
            "target_dimension": len(q8),
            "rank": rank,
            "full_target_rank": True,
            "row_rank_profile_int32_sha256": array_sha256(profile),
            "selected_minor_uint8_sha256": array_sha256(selected_minor),
            "rank_seconds": rank_seconds,
        },
        "artifact": {
            "path": ARTIFACT.name,
            "sha256": sha256(ARTIFACT),
        },
        "theorem": {
            "ideal_statement": (
                "the scalar compatibility ideal contains every degree-eight form on L8"
            ),
            "conclusion": (
                "the r256 normalized Stage-C contraction incidence is empty on L8"
            ),
            "safe_implication": "the true normalized Stage-C incidence is empty on L8",
            "scope_guard": "No conclusion is made on P36 minus L8.",
        },
        "resources": {
            "observed_free_plus_speculative_gib": observed_free,
            "total_seconds": time.monotonic() - started,
            "max_rss_raw": resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
            "max_rss_note": "on macOS ru_maxrss is bytes",
        },
    }
    CERTIFICATE.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS: normalized Stage C is empty on L8")
    print(f"degree-eight compatibility rank {rank}/{len(q8)}")


if __name__ == "__main__":
    main()
