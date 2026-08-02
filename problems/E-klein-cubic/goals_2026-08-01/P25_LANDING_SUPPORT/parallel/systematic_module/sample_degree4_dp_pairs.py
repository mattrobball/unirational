#!/usr/bin/env python3
"""Exact bounded sample of degree-four dp S-pair coefficient density.

The script normalizes only the degree-three rows needed by a deterministic
sample of duplicate one-variable leading-monomial fibers.  It solves against
the exact 10,767-square dp pivot minor with FFLAS, independently verifies the
selected normalized rows, expands the sampled S-polynomials, and measures how
many coefficients lie in the existing degree-four shadow versus its standard
complement.

Sampling is solely a resource forecast.  It is never a rank, membership, or
Stage-B certificate.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import time

import numpy as np

import profile_degree3_closure as base


HERE = Path(__file__).resolve().parent
PROFILE = HERE / "degree3_dp_pivot_profile.npz"
P3 = base.P3
P = base.P
NQ = base.NQ
RANK = base.RANK


def right_solve_inplace(a: np.ndarray, b: np.ndarray) -> int:
    """Replace B by X solving X*A=B over F_89."""
    library = ctypes.CDLL("/opt/homebrew/lib/libffpack_c.dylib")
    symbol = "_Z22fgesvin_modular_doubledN5FFLAS10FFLAS_SIDEEmmPdmS1_mPib"
    function = getattr(library, symbol)
    function.argtypes = [
        ctypes.c_double,
        ctypes.c_int,
        ctypes.c_size_t,
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        np.ctypeslib.ndpointer(np.float64, flags="C_CONTIGUOUS"),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_int),
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    info = ctypes.c_int()
    rank = int(
        function(
            float(P), 142, b.shape[0], a.shape[0], a, a.shape[1],
            b, b.shape[1], ctypes.byref(info), False,
        )
    )
    if info.value != 0:
        raise RuntimeError(f"FFLAS right solve info={info.value}")
    return rank


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        while block := handle.read(1 << 20):
            digest.update(block)
    return digest.hexdigest()


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--pairs", type=int, default=16)
    parser.add_argument("--chunk", type=int, default=512)
    args = parser.parse_args()
    if args.pairs <= 0:
        raise SystemExit("pairs must be positive")
    started_all = time.monotonic()
    p3 = np.load(P3, mmap_mode="r")
    q3 = base.weak_compositions(3, NQ)
    q4 = base.weak_compositions(4, NQ)
    q4_index = {monomial: index for index, monomial in enumerate(q4)}
    flat = p3.reshape(RANK, -1)
    with np.load(PROFILE, allow_pickle=False) as frozen:
        pivot_columns = frozen["pivot_columns"].astype(np.int32)
        pivot_components = frozen["pivot_components"].astype(np.int8)
        pivot_exponents = frozen["pivot_exponents"].astype(np.int8)
        if str(frozen["full_p3_sha256"]) != sha256(P3):
            raise AssertionError("P3 hash mismatch")
    if len(pivot_columns) != RANK:
        raise AssertionError("pivot profile rank mismatch")

    # Deterministic sample: scan pivot rows, then q variables, retaining the
    # first duplicate product fibers encountered.
    seen: dict[tuple[int, tuple[int, ...]], tuple[int, int]] = {}
    sampled: list[tuple[tuple[int, int], tuple[int, int], tuple[int, tuple[int, ...]]]] = []
    involved: set[int] = set()
    for row, (component, raw) in enumerate(zip(pivot_components, pivot_exponents)):
        exponent = list(map(int, raw))
        for variable in range(NQ):
            product = exponent.copy()
            product[variable] += 1
            key = (int(component), tuple(product))
            if key in seen:
                first = seen[key]
                sampled.append((first, (row, variable), key))
                involved.update((first[0], row))
                if len(sampled) == args.pairs:
                    break
            else:
                seen[key] = (row, variable)
        if len(sampled) == args.pairs:
            break
    if len(sampled) != args.pairs:
        raise RuntimeError("not enough duplicate fibers")
    involved_rows = np.asarray(sorted(involved), dtype=np.int32)
    local = {int(row): index for index, row in enumerate(involved_rows)}

    minor_u8 = np.ascontiguousarray(flat[:, pivot_columns], dtype=np.uint8)
    a = minor_u8.astype(np.float64)
    rhs = np.zeros((len(involved_rows), RANK), dtype=np.float64)
    rhs[np.arange(len(involved_rows)), involved_rows] = 1.0
    solve_started = time.monotonic()
    solve_rank = right_solve_inplace(a, rhs)
    solve_seconds = time.monotonic() - solve_started
    if solve_rank != RANK:
        raise RuntimeError(f"pivot solve rank {solve_rank}")
    coefficients = (np.rint(rhs).astype(np.int64) % P).astype(np.uint8)
    del a, rhs
    check = coefficients.astype(np.float64) @ minor_u8.astype(np.float64)
    np.remainder(check, float(P), out=check)
    expected = np.zeros((len(involved_rows), RANK), dtype=np.uint8)
    expected[np.arange(len(involved_rows)), involved_rows] = 1
    if not np.array_equal(check.astype(np.uint8), expected):
        raise RuntimeError("selected normalized pivot rows failed exact check")
    del check, expected, minor_u8

    normalized = np.empty((len(involved_rows), flat.shape[1]), dtype=np.uint8)
    left = coefficients.astype(np.float64)
    for start in range(0, flat.shape[1], args.chunk):
        end = min(flat.shape[1], start + args.chunk)
        right = np.ascontiguousarray(flat[:, start:end], dtype=np.float64)
        product = left @ right
        np.remainder(product, float(P), out=product)
        normalized[:, start:end] = product.astype(np.uint8)
        del right, product
    if not np.array_equal(normalized[:, pivot_columns], np.eye(RANK, dtype=np.uint8)[involved_rows]):
        raise RuntimeError("normalized full rows lost pivot identity")
    del left

    # Mark the complete exact degree-four shadow.
    shadow = np.zeros((base.COMPONENTS, len(q4)), dtype=bool)
    for component, raw in zip(pivot_components, pivot_exponents):
        exponent = list(map(int, raw))
        for variable in range(NQ):
            product = exponent.copy()
            product[variable] += 1
            shadow[int(component), q4_index[tuple(product)]] = True
    if int(np.count_nonzero(shadow)) != 232326:
        raise AssertionError("dp shadow count drift")

    # Cache each variable's injective cubic-to-quartic monomial lift.
    used_variables = sorted(
        {variable for pair in sampled for (_row, variable) in pair[:2]}
    )
    lifts: dict[int, np.ndarray] = {}
    for variable in used_variables:
        indices = np.empty(len(q3), dtype=np.int32)
        for monomial, exponent in enumerate(q3):
            product = list(exponent)
            product[variable] += 1
            indices[monomial] = q4_index[tuple(product)]
        lifts[variable] = indices

    sample_records = []
    total_columns4 = base.COMPONENTS * len(q4)
    for ordinal, (first, second, key) in enumerate(sampled):
        vector = np.zeros(total_columns4, dtype=np.int16)
        for sign, (row, variable) in ((1, first), (-1, second)):
            coefficients_row = normalized[local[row]].reshape(base.COMPONENTS, len(q3))
            lift = lifts[variable]
            for component in range(base.COMPONENTS):
                columns = component * len(q4) + lift
                vector[columns] += sign * coefficients_row[component].astype(np.int16)
        np.remainder(vector, P, out=vector)
        vector_u8 = vector.astype(np.uint8)
        nz = np.flatnonzero(vector_u8)
        components = nz // len(q4)
        monomials = nz % len(q4)
        in_shadow = shadow[components, monomials]
        record = {
            "ordinal": ordinal,
            "first": {"pivot_row": first[0], "multiplier_q": first[1]},
            "second": {"pivot_row": second[0], "multiplier_q": second[1]},
            "cancelled_component": key[0],
            "cancelled_monomial": list(key[1]),
            "raw_spoly_nnz": int(len(nz)),
            "existing_shadow_nnz": int(np.count_nonzero(in_shadow)),
            "standard_complement_nnz_before_reduction": int(np.count_nonzero(~in_shadow)),
            "raw_spoly_sha256": sha256_array(vector_u8),
        }
        sample_records.append(record)
        print(json.dumps(record, sort_keys=True), flush=True)

    packet = HERE / "degree4_dp_pair_sample.npz"
    np.savez_compressed(
        packet,
        prime=np.int32(P),
        involved_rows=involved_rows,
        normalized_coefficients=coefficients,
        normalized_rows=normalized,
        pivot_profile_sha256=np.asarray(sha256(PROFILE)),
        full_p3_sha256=np.asarray(sha256(P3)),
    )
    raw_nnz = np.asarray([item["raw_spoly_nnz"] for item in sample_records])
    standard_nnz = np.asarray(
        [item["standard_complement_nnz_before_reduction"] for item in sample_records]
    )
    full_pairs = 166053
    standard_columns = 316014
    payload = {
        "status": "PASS_EXACT_BOUNDED_DEGREE4_DP_PAIR_SAMPLE",
        "prime": P,
        "sample_rule": "first duplicate product fibers in pivot-row then q-variable scan",
        "sample_pairs": len(sample_records),
        "involved_normalized_rows": len(involved_rows),
        "pivot_solve": {
            "shape": [RANK, RANK],
            "rank": solve_rank,
            "seconds": round(solve_seconds, 6),
            "selected_rows_verified": True,
        },
        "raw_spoly_nnz": {
            "min": int(raw_nnz.min()),
            "median": float(np.median(raw_nnz)),
            "max": int(raw_nnz.max()),
        },
        "standard_complement_nnz_before_reduction": {
            "min": int(standard_nnz.min()),
            "median": float(np.median(standard_nnz)),
            "max": int(standard_nnz.max()),
        },
        "exact_layer_dimensions": {
            "canonical_degree4_pair_rows": full_pairs,
            "standard_degree4_columns_before_new_pivots": standard_columns,
            "dense_uint8_rectangle_bytes": full_pairs * standard_columns,
            "dense_modular_double_rectangle_bytes": full_pairs * standard_columns * 8,
        },
        "sample_records": sample_records,
        "packet": {"file": packet.name, "sha256": sha256(packet)},
        "inputs": {
            "pivot_profile": {"file": PROFILE.name, "sha256": sha256(PROFILE)},
            "full_p3": {"path": str(P3), "sha256": sha256(P3)},
        },
        "elapsed_seconds": round(time.monotonic() - started_all, 6),
        "scope": (
            "Exact deterministic density sample and storage forecast only. The "
            "sampled S-polynomials were not completely reduced by all degree-three "
            "rows; no rank, target membership, or Stage-B conclusion follows."
        ),
    }
    manifest = HERE / "degree4_dp_pair_sample.json"
    manifest.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()

