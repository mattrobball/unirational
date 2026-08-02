#!/usr/bin/env python3
"""Independent exact replay of the closed-L8 normalized Stage-C certificate.

This verifier rebuilds the restricted tensors and Macaulay maps from the r256
packet, independently recomputes the complete FFLAS nullspace, reconstructs
all compatibility septics, and checks the producer-selected 6435-square minor
has full rank over GF(89).  It does not import producer code.
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
ARTIFACT = HERE / "closed_L8_stageC_compatibility.npz"
CERTIFICATE = HERE / "closed_L8_stageC_certificate.json"
CLOSED_CERT = P25 / "parallel" / "stageb_strata" / "closed_L_degree6_certificate.json"
CLOSED_VERIFY = P25 / "parallel" / "stageb_strata" / "verify_closed_L_degree6_result.json"
OUTPUT = HERE / "verify_closed_L8_stageC_result.json"
P = 89
L8 = tuple(range(4, 12))


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
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


def compositions(total: int, variables: int) -> list[tuple[int, ...]]:
    if variables == 1:
        return [(total,)]
    answer: list[tuple[int, ...]] = []
    for first in range(total + 1):
        for tail in compositions(total - first, variables - 1):
            answer.append((first,) + tail)
    return answer


def restricted_columns(
    local_basis: list[tuple[int, ...]], global_basis: list[tuple[int, ...]]
) -> np.ndarray:
    lookup = {monomial: ordinal for ordinal, monomial in enumerate(global_basis)}
    columns: list[int] = []
    for local in local_basis:
        global_exponent = [0] * 37
        for coordinate, exponent in zip(L8, local):
            global_exponent[coordinate] = exponent
        columns.append(lookup[tuple(global_exponent)])
    return np.asarray(columns, dtype=np.int32)


def multiplication_table(
    first: list[tuple[int, ...]],
    second: list[tuple[int, ...]],
    target: list[tuple[int, ...]],
) -> np.ndarray:
    lookup = {monomial: ordinal for ordinal, monomial in enumerate(target)}
    table = np.empty((len(first), len(second)), dtype=np.int32)
    for i, left in enumerate(first):
        for j, right in enumerate(second):
            table[i, j] = lookup[tuple(a + b for a, b in zip(left, right))]
    return table


def variable_table(
    source: list[tuple[int, ...]], target: list[tuple[int, ...]]
) -> np.ndarray:
    lookup = {monomial: ordinal for ordinal, monomial in enumerate(target)}
    table = np.empty((len(L8), len(source)), dtype=np.int32)
    for variable in range(len(L8)):
        for ordinal, monomial in enumerate(source):
            product = list(monomial)
            product[variable] += 1
            table[variable, ordinal] = lookup[tuple(product)]
    return table


def exact_nullspace(matrix: np.ndarray) -> np.ndarray:
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
        142,
        rows,
        columns,
        matrix,
        columns,
        ctypes.byref(pointer),
        ctypes.byref(leading),
        ctypes.byref(nullity),
        False,
    )
    if returned != 3384 or nullity.value != 3384 or leading.value != 3384:
        raise AssertionError("independent P3 nullity replay failed")
    raw = np.ctypeslib.as_array(pointer, shape=(columns * 3384,))
    return (np.rint(raw.reshape(columns, 3384).T).astype(np.int64) % P).astype(
        np.uint8
    )


def exact_rank(matrix: np.ndarray) -> int:
    dense = np.ascontiguousarray(matrix, dtype=np.float64)
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
    profile = ctypes.POINTER(ctypes.c_size_t)()
    return int(
        function(
            float(P),
            dense.shape[0],
            dense.shape[1],
            dense,
            dense.shape[1],
            ctypes.byref(profile),
            2,
            False,
        )
    )


def p3_matrix(
    restricted: np.ndarray, multiplication: np.ndarray, sextics: int
) -> np.ndarray:
    # Independent construction organized by source column, not target blocks.
    matrix = np.zeros((6 * sextics, len(restricted) * 120), dtype=np.float64)
    for generator in range(len(restricted)):
        for multiplier in range(120):
            column = generator * 120 + multiplier
            targets = multiplication[multiplier]
            for component in range(6):
                matrix[component * sextics + targets, column] = restricted[
                    generator, component
                ]
        if (generator + 1) % 24 == 0 or generator + 1 == len(restricted):
            print(f"replayed P3 generators {generator + 1}/{len(restricted)}", flush=True)
    return matrix


def p4_matrix(
    restricted: np.ndarray, multiplication: np.ndarray, septics: int
) -> np.ndarray:
    matrix = np.zeros((len(restricted) * 120, septics), dtype=np.float64)
    for generator in range(len(restricted)):
        for multiplier in range(120):
            matrix[generator * 120 + multiplier, multiplication[multiplier]] = restricted[
                generator
            ]
    return matrix


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--min-free-gib", type=float, default=24.0)
    args = parser.parse_args()
    observed_free = free_gib()
    if observed_free is not None and observed_free < args.min_free_gib:
        raise SystemExit(
            f"resource guard: free+speculative={observed_free:.2f} GiB "
            f"< required {args.min_free_gib:.2f} GiB"
        )
    for path in (SOURCE, ARTIFACT, CERTIFICATE, CLOSED_CERT, CLOSED_VERIFY):
        if not path.is_file():
            raise FileNotFoundError(path)
    with CERTIFICATE.open() as handle:
        certificate = json.load(handle)
    if certificate.get("status") != "PASS_CLOSED_L8_STAGEC_EMPTY":
        raise AssertionError("producer certificate is not terminal")
    with CLOSED_VERIFY.open() as handle:
        closed_replay = json.load(handle)
    if closed_replay.get("status") != "PASS" or closed_replay.get(
        "certificate_sha256"
    ) != sha256(CLOSED_CERT):
        raise AssertionError("closed-L8 Stage-B replay binding failed")

    started = time.monotonic()
    q3_global = compositions(3, 37)
    q4_global = compositions(4, 37)
    q3 = compositions(3, 8)
    q4 = compositions(4, 8)
    q6 = compositions(6, 8)
    q7 = compositions(7, 8)
    q8 = compositions(8, 8)
    columns3 = restricted_columns(q3, q3_global)
    columns4 = restricted_columns(q4, q4_global)
    multiply33 = multiplication_table(q3, q3, q6)
    multiply34 = multiplication_table(q3, q4, q7)
    multiply78 = variable_table(q7, q8)

    with np.load(SOURCE, allow_pickle=False) as frozen:
        if int(frozen["prime"]) != P:
            raise AssertionError("source prime changed")
        all3 = frozen["p3"][:, :, columns3].astype(np.uint8)
        all4 = frozen["p4"][:, columns4].astype(np.uint8)
    rows3 = np.flatnonzero(np.any(all3 != 0, axis=(1, 2)))
    rows4 = np.flatnonzero(np.any(all4 != 0, axis=1))
    if rows3.tolist() != list(range(142, 256)) or not np.array_equal(rows3, rows4):
        raise AssertionError("restricted row support changed")
    restricted3 = np.ascontiguousarray(all3[rows3])
    restricted4 = np.ascontiguousarray(all4[rows4])

    with np.load(ARTIFACT, allow_pickle=False) as frozen:
        stored_kernel = frozen["kernel"].astype(np.uint8)
        stored_compatibility = frozen["compatibility"].astype(np.uint8)
        identity_coordinates = frozen["identity_coordinates"].astype(np.int32)
        selected_rows = frozen["row_rank_profile"].astype(np.int32)
        artifact_scalars = {
            key: str(frozen[key])
            for key in (
                "selected_minor_uint8_sha256",
                "restricted_p3_uint8_sha256",
                "restricted_p4_uint8_sha256",
                "multiply33_int32_sha256",
                "multiply34_int32_sha256",
                "multiply78_int32_sha256",
                "source_sha256",
            )
        }
        if int(frozen["prime"]) != P:
            raise AssertionError("artifact prime changed")

    expected_scalars = {
        "restricted_p3_uint8_sha256": array_sha256(restricted3),
        "restricted_p4_uint8_sha256": array_sha256(restricted4),
        "multiply33_int32_sha256": array_sha256(multiply33),
        "multiply34_int32_sha256": array_sha256(multiply34),
        "multiply78_int32_sha256": array_sha256(multiply78),
        "source_sha256": sha256(SOURCE),
    }
    for key, expected in expected_scalars.items():
        if artifact_scalars[key] != expected:
            raise AssertionError(f"artifact binding failed for {key}")

    dense_p3 = p3_matrix(restricted3, multiply33, len(q6))
    replayed_kernel = exact_nullspace(dense_p3)
    del dense_p3
    if not np.array_equal(replayed_kernel, stored_kernel):
        raise AssertionError("independent complete nullspace differs from artifact")
    if not np.array_equal(
        stored_kernel[:, identity_coordinates], np.eye(3384, dtype=np.uint8)
    ):
        raise AssertionError("stored kernel systematic identity minor failed")

    dense_p4 = p4_matrix(restricted4, multiply34, len(q7))
    replayed_compatibility_double = replayed_kernel.astype(np.float64) @ dense_p4
    np.remainder(replayed_compatibility_double, float(P), out=replayed_compatibility_double)
    replayed_compatibility = replayed_compatibility_double.astype(np.uint8)
    del dense_p4, replayed_compatibility_double, replayed_kernel
    if not np.array_equal(replayed_compatibility, stored_compatibility):
        raise AssertionError("independent compatibility contraction differs")

    if selected_rows.shape != (6435,) or len(np.unique(selected_rows)) != 6435:
        raise AssertionError("selected degree-eight rows are not 6435 distinct rows")
    if np.any(selected_rows < 0) or np.any(selected_rows >= 3384 * 8):
        raise AssertionError("selected degree-eight row ordinal outside source")
    minor = np.zeros((6435, 6435), dtype=np.uint8)
    for row, ordinal in enumerate(selected_rows.tolist()):
        compatibility_row, variable = divmod(ordinal, 8)
        minor[row, multiply78[variable]] = stored_compatibility[compatibility_row]
    if array_sha256(minor) != artifact_scalars["selected_minor_uint8_sha256"]:
        raise AssertionError("selected minor hash differs")
    rank = exact_rank(minor)
    if rank != 6435:
        raise AssertionError(f"selected degree-eight minor rank {rank} != 6435")

    payload = {
        "status": "PASS_INDEPENDENT_CLOSED_L8_STAGEC_EMPTY",
        "prime": P,
        "source_sha256": sha256(SOURCE),
        "artifact_sha256": sha256(ARTIFACT),
        "certificate_sha256": sha256(CERTIFICATE),
        "restricted_p3_uint8_sha256": array_sha256(restricted3),
        "restricted_p4_uint8_sha256": array_sha256(restricted4),
        "kernel_shape": list(stored_kernel.shape),
        "kernel_uint8_sha256": array_sha256(stored_kernel),
        "compatibility_shape": list(stored_compatibility.shape),
        "compatibility_uint8_sha256": array_sha256(stored_compatibility),
        "selected_minor_shape": list(minor.shape),
        "selected_minor_uint8_sha256": array_sha256(minor),
        "selected_minor_rank": rank,
        "closed_L8_stageC_empty": True,
        "theorem": (
            "The compatibility ideal contains S_8, so the normalized Stage-C "
            "incidence is empty at every projective point of L8."
        ),
        "scope_guard": "No conclusion is made on P36 minus L8.",
        "resources": {
            "observed_free_plus_speculative_gib": observed_free,
            "elapsed_seconds": time.monotonic() - started,
            "max_rss_raw": resource.getrusage(resource.RUSAGE_SELF).ru_maxrss,
            "max_rss_note": "on macOS ru_maxrss is bytes",
        },
    }
    OUTPUT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("PASS: independent closed-L8 Stage-C certificate replayed")
    print(f"selected degree-eight minor rank {rank}/6435")


if __name__ == "__main__":
    main()
