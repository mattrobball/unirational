#!/usr/bin/env python3
"""Independent replay of the bounded polarized-Segre claims."""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
import math
import subprocess
from pathlib import Path

import numpy as np


HERE = Path(__file__).resolve().parent
P25 = HERE.parents[1]
GLOBAL = P25 / "parallel" / "stageb_global_basis"
RESULT = HERE / "polarized_segre_result.json"
FULL_P3 = GLOBAL / "full_p3_contractions.npy"
P3_MINOR = GLOBAL / "lt_cover_nonpure_minor.npz"
P = 89
NULLITY = 10767


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while chunk := handle.read(1 << 20):
            digest.update(chunk)
    return digest.hexdigest()


def array_sha256(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def piece(a: int, b: int) -> int:
    if a < 0 or b < 0:
        return 0
    return math.comb(a + 36, 36) * math.comb(b + 242, 242)


def dimensions(a: int, b: int) -> tuple[int, int]:
    return 690 * piece(a - 1, b - 1), piece(a, b)


def free_gib() -> float | None:
    try:
        output = subprocess.check_output(["vm_stat"], text=True)
    except (FileNotFoundError, subprocess.CalledProcessError):
        return None
    page_size = 16384
    pages: dict[str, int] = {}
    for line in output.splitlines():
        if line.startswith("Mach Virtual Memory Statistics") and "page size of" in line:
            page_size = int(line.split("page size of", 1)[1].split("bytes", 1)[0])
        elif line.startswith("Pages free:"):
            pages["free"] = int(line.split(":", 1)[1].strip().rstrip("."))
        elif line.startswith("Pages speculative:"):
            pages["speculative"] = int(line.split(":", 1)[1].strip().rstrip("."))
    if set(pages) != {"free", "speculative"}:
        return None
    return (pages["free"] + pages["speculative"]) * page_size / 2**30


def rank_mod_89(matrix: np.ndarray) -> int:
    if matrix.dtype != np.float64 or not matrix.flags.c_contiguous:
        raise TypeError("rank matrix must be contiguous float64")
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
    rows, columns = matrix.shape
    return int(function(float(P), rows, columns, matrix, columns, False))


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--skip-rank", action="store_true")
    parser.add_argument("--min-free-gib", type=float, default=10.0)
    args = parser.parse_args()

    with RESULT.open() as handle:
        result = json.load(handle)
    assert result["status"] == "PASS_POLARIZED_SEGRE_LOW_DEGREE_NONVERDICT"
    assert result["prime"] == P

    geometry = result["geometry"]
    assert geometry["ambient_projective_dimension"] == 37 * 243 - 1
    assert geometry["segre_projective_dimension"] == 36 + 242
    assert geometry["linear_kernel_vector_dimension"] == 37 * 243 - 690
    assert geometry["expected_intersection_dimension"] == -412
    assert geometry["maximal_possible_decomposable_free_vector_dimension"] == 36 * 242
    assert geometry["segre_degree"] == math.comb(278, 36)

    feasible = []
    for a in range(1, 41):
        for b in range(1, 41):
            source, target = dimensions(a, b)
            if source >= target:
                feasible.append((a + b, target, a, b, source))
    assert min(item[0] for item in feasible) == 8
    assert [(a, b) for total, _target, a, b, _source in feasible if total == 8] == [
        (3, 5),
        (4, 4),
        (5, 3),
    ]
    smallest = min(feasible, key=lambda item: item[1])
    assert smallest[2:4] == (5, 3)
    assert dimensions(5, 3) == (1_869_450_078_600, 1_814_360_003_820)
    assert dimensions(4, 4) == (15_267_175_641_900, 13_607_700_028_650)
    assert dimensions(1, 14) == (
        1_565_030_249_233_815_370_308_750,
        1_534_572_103_596_552_710_928_000,
    )
    assert dimensions(20, 1) == (
        193_597_627_818_845_250,
        190_904_095_605_713_490,
    )

    low = result["bounded_exact_low_degree"]
    assert low["full_m2_syzygy_rank"] == 14763
    assert low["full_m2_syzygy_nullity"] == NULLITY
    assert low["bidegree_2_1_source_dimension"] == 690 * 37
    assert low["bidegree_2_1_target_dimension"] == math.comb(38, 36) * 243
    assert low["bidegree_2_1_quotient_dimension"] == 145299
    assert low["standard_degree_2_quotient_lower_bound"] == (
        piece(2, 2) - 690 * piece(1, 1) + math.comb(690, 2)
    )

    assert sha256(FULL_P3) == result["input_hashes"][
        "parallel/stageb_global_basis/full_p3_contractions.npy"
    ]
    assert sha256(P3_MINOR) == result["input_hashes"][
        "parallel/stageb_global_basis/lt_cover_nonpure_minor.npz"
    ]
    with np.load(P3_MINOR, allow_pickle=False) as frozen:
        columns = frozen["minor_columns"].astype(np.int32)
        expected_sha = str(frozen["minor_uint8_sha256"])
        assert int(frozen["prime"]) == P
    p3 = np.load(FULL_P3, mmap_mode="r")
    minor = np.ascontiguousarray(
        p3.reshape(NULLITY, 6 * 9139)[:, columns], dtype=np.uint8
    )
    assert minor.shape == (NULLITY, NULLITY)
    assert array_sha256(minor) == expected_sha
    if not args.skip_rank:
        available = free_gib()
        if available is not None and available < args.min_free_gib:
            raise SystemExit(
                f"resource guard: free+speculative={available:.2f} GiB "
                f"< required {args.min_free_gib:.2f} GiB"
            )
        rank = rank_mod_89(minor.astype(np.float64))
        assert rank == NULLITY
    else:
        rank = None

    print("PASS: independent polarized-Segre low-degree replay")
    print(f"P3 minor rank: {rank}/{NULLITY}")
    print("global Segre kernel: UNDECIDED")


if __name__ == "__main__":
    main()

