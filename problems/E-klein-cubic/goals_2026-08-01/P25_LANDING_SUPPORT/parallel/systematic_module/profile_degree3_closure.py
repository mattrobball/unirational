#!/usr/bin/env python3
"""Exact low-memory pivot profile and monomial-shadow forecast for P3.

Columns are streamed in the genuine Singular `(Dp,C)` order used by the
shifted-module packet.  At each step an exact FFLAS column-rank profile keeps
only the lexicographically first independent columns seen so far.  Once the
rank reaches 10,767, all later columns are necessarily dependent, so the
result is the exact degree-three leading-monomial set without materializing a
10,767 by 54,834 modular-double matrix.

This script computes no degree-four or degree-five coefficients.  Its shadow
counts are exact combinatorics and resource forecasts, not membership tests.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import time

import numpy as np


HERE = Path(__file__).resolve().parent
P3 = HERE.parent / "stageb_global_basis" / "full_p3_contractions.npy"
OUT = HERE / "degree3_pivot_profile.npz"
MANIFEST = HERE / "degree3_pivot_profile.json"
P = 89
NQ = 37
RANK = 10767
COMPONENTS = 6
VARIABLE_ORDER = tuple(range(5, 37)) + (4, 0, 1, 2, 3)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def weak_compositions(total: int, parts: int) -> list[tuple[int, ...]]:
    if parts == 1:
        return [(total,)]
    return [
        (first,) + tail
        for first in range(total + 1)
        for tail in weak_compositions(total - first, parts - 1)
    ]


def column_rank_profile(dense: np.ndarray) -> tuple[int, np.ndarray]:
    if dense.dtype != np.float64 or not dense.flags.c_contiguous:
        raise TypeError("FFLAS input must be contiguous modular doubles")
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    function = library.ColumnRankProfile_modular_double
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
    rows, columns = dense.shape
    rank = int(
        function(
            float(P), rows, columns, dense, columns,
            ctypes.byref(pointer), 2, False,
        )
    )
    profile = np.ctypeslib.as_array(pointer, shape=(rank,)).copy()
    return rank, profile.astype(np.int32)


def ordered_columns(q3: list[tuple[int, ...]]) -> np.ndarray:
    monomial_order = sorted(
        range(len(q3)),
        key=lambda index: tuple(q3[index][variable] for variable in VARIABLE_ORDER),
        reverse=True,
    )
    # `(Dp,C)` is term-over-position, and capital C makes the larger generator
    # number the larger module term.
    return np.asarray(
        [
            component * len(q3) + monomial
            for monomial in monomial_order
            for component in reversed(range(COMPONENTS))
        ],
        dtype=np.int32,
    )


def shadow_counts(
    pivot_components: np.ndarray,
    pivot_exponents: np.ndarray,
) -> dict:
    q2 = weak_compositions(2, NQ)
    degree4: set[tuple[int, tuple[int, ...]]] = set()
    degree5: set[tuple[int, tuple[int, ...]]] = set()
    pure_covered: list[dict] = []
    pure_pivots = {
        (int(component), tuple(map(int, exponent)))
        for component, exponent in zip(pivot_components, pivot_exponents)
    }
    for component, raw in zip(pivot_components, pivot_exponents):
        exponent = tuple(map(int, raw))
        for variable in range(NQ):
            lifted = list(exponent)
            lifted[variable] += 1
            degree4.add((int(component), tuple(lifted)))
        for multiplier in q2:
            lifted = tuple(exponent[i] + multiplier[i] for i in range(NQ))
            degree5.add((int(component), lifted))
    for component in range(COMPONENTS):
        for axis in range(NQ):
            cube = [0] * NQ
            cube[axis] = 3
            if (component, tuple(cube)) in pure_pivots:
                pure_covered.append({"axis": axis, "component": component})
    source4 = RANK * NQ
    source5 = RANK * len(q2)
    total4 = COMPONENTS * len(weak_compositions(4, NQ))
    total5 = COMPONENTS * len(weak_compositions(5, NQ))
    return {
        "degree4": {
            "all_one_variable_prolongations": source4,
            "distinct_initial_shadow": len(degree4),
            "duplicate_lcm_fiber_relations": source4 - len(degree4),
            "ambient_module_terms": total4,
            "standard_terms_before_new_degree4_pivots": total4 - len(degree4),
        },
        "degree5": {
            "all_quadratic_prolongations": source5,
            "distinct_initial_shadow": len(degree5),
            "duplicate_prolongations": source5 - len(degree5),
            "ambient_module_terms": total5,
            "standard_terms_before_degree4_or_degree5_new_pivots": total5 - len(degree5),
        },
        "pure_power_targets": {
            "total": NQ * COMPONENTS,
            "covered_by_degree3_initial_shadow": len(pure_covered),
            "uncovered_before_higher_pairs": NQ * COMPONENTS - len(pure_covered),
            "covered": pure_covered,
        },
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--block", type=int, default=4096)
    parser.add_argument("--max-blocks", type=int, default=0)
    args = parser.parse_args()
    if args.block <= 0:
        raise SystemExit("block must be positive")
    p3 = np.load(P3, mmap_mode="r")
    q3 = weak_compositions(3, NQ)
    if p3.shape != (RANK, COMPONENTS, len(q3)) or p3.dtype != np.uint8:
        raise AssertionError(f"unexpected P3 tensor {p3.shape} {p3.dtype}")
    flat = p3.reshape(RANK, -1)
    order = ordered_columns(q3)
    if len(order) != flat.shape[1] or len(np.unique(order)) != len(order):
        raise AssertionError("column order is not a permutation")

    selected = np.empty(0, dtype=np.int32)
    attempts: list[dict] = []
    overall = time.monotonic()
    for block_number, start in enumerate(range(0, len(order), args.block)):
        if args.max_blocks and block_number >= args.max_blocks:
            break
        end = min(len(order), start + args.block)
        candidates = np.concatenate((selected, order[start:end]))
        matrix_u8 = np.ascontiguousarray(flat[:, candidates], dtype=np.uint8)
        matrix_sha = sha256_array(matrix_u8)
        dense = matrix_u8.astype(np.float64)
        started = time.monotonic()
        rank, profile = column_rank_profile(dense)
        elapsed = time.monotonic() - started
        selected = candidates[profile]
        attempts.append(
            {
                "block_number": block_number,
                "ordered_columns_seen": end,
                "candidate_columns": len(candidates),
                "rank": rank,
                "fflas_seconds": round(elapsed, 6),
                "candidate_uint8_sha256": matrix_sha,
                "uint8_bytes": int(matrix_u8.nbytes),
                "modular_double_bytes": int(dense.nbytes),
            }
        )
        print(json.dumps(attempts[-1], sort_keys=True), flush=True)
        del dense, matrix_u8, candidates, profile
        if rank == RANK:
            break

    complete = len(selected) == RANK
    if not complete:
        payload = {
            "status": "BOUNDED_PREFLIGHT_INCOMPLETE",
            "rank_reached": len(selected),
            "attempts": attempts,
            "scope": "No degree-three pivot profile or membership conclusion.",
        }
        print(json.dumps(payload, sort_keys=True), flush=True)
        return

    position = np.full(flat.shape[1], -1, dtype=np.int32)
    position[order] = np.arange(len(order), dtype=np.int32)
    pivot_positions = position[selected]
    if np.any(np.diff(pivot_positions) <= 0):
        raise AssertionError("rank profile is not ordered")
    pivot_components = (selected // len(q3)).astype(np.int8)
    pivot_monomials = (selected % len(q3)).astype(np.int32)
    pivot_exponents = np.asarray([q3[int(index)] for index in pivot_monomials], dtype=np.int8)
    shadows = shadow_counts(pivot_components, pivot_exponents)
    np.savez_compressed(
        OUT,
        prime=np.int32(P),
        variable_order=np.asarray(VARIABLE_ORDER, dtype=np.int8),
        ordered_columns=order,
        pivot_columns=selected,
        pivot_order_positions=pivot_positions,
        pivot_components=pivot_components,
        pivot_monomials=pivot_monomials,
        pivot_exponents=pivot_exponents,
        full_p3_sha256=np.asarray(sha256(P3)),
    )
    payload = {
        "status": "PASS_EXACT_DEGREE3_PIVOT_PROFILE",
        "prime": P,
        "source": {"path": str(P3), "sha256": sha256(P3)},
        "term_order": {
            "singular": "(Dp,C)",
            "variables": [f"q{i}" for i in VARIABLE_ORDER],
            "module_component_tiebreak": "gen(6)>...>gen(1)",
        },
        "matrix_shape": list(flat.shape),
        "rank": len(selected),
        "ordered_columns_examined_until_full_rank": int(pivot_positions[-1]) + 1,
        "attempts": attempts,
        "pivot_profile": {
            "file": OUT.name,
            "sha256": sha256(OUT),
            "bytes": OUT.stat().st_size,
            "pivot_columns_sha256": sha256_array(selected),
            "pivot_exponents_sha256": sha256_array(pivot_exponents),
        },
        "shadows": shadows,
        "pair_criteria": {
            "cross_component_pairs": "omitted: module leading terms in distinct components have zero S-polynomial",
            "same_lcm_fibers": (
                "for each degree-four product monomial, keep a spanning tree of "
                "representations q_i*LT(g); every other pair is a linear "
                "combination of tree differences in the same fiber"
            ),
            "higher_lcm_pairs": (
                "omitted from the degree-four layer only; homogeneous Buchberger/F4 "
                "processes them when their lcm degree is reached"
            ),
        },
        "elapsed_seconds": round(time.monotonic() - overall, 6),
        "scope": (
            "Exact degree-three pivots and monomial-shadow counts only. New "
            "degree-four/degree-five S-polynomial coefficients were not reduced, "
            "so no target membership or Stage-B verdict follows."
        ),
    }
    MANIFEST.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()

