#!/usr/bin/env python3
"""Exact streamed P3 pivot profile for degree-reverse-lexicographic ties."""

from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import time

import numpy as np

import profile_degree3_closure as base


HERE = Path(__file__).resolve().parent
OUT = HERE / "degree3_dp_pivot_profile.npz"
MANIFEST = HERE / "degree3_dp_pivot_profile.json"


def ordered_columns(q3: list[tuple[int, ...]]) -> np.ndarray:
    # At fixed degree, Singular dp compares exponent vectors from the last
    # variable backwards and declares the monomial with the smaller exponent
    # at the last difference to be larger.
    monomial_order = sorted(
        range(len(q3)),
        key=lambda index: tuple(
            -q3[index][variable] for variable in reversed(base.VARIABLE_ORDER)
        ),
        reverse=True,
    )
    return np.asarray(
        [
            component * len(q3) + monomial
            for monomial in monomial_order
            for component in reversed(range(base.COMPONENTS))
        ],
        dtype=np.int32,
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--block", type=int, default=4096)
    args = parser.parse_args()
    p3 = np.load(base.P3, mmap_mode="r")
    q3 = base.weak_compositions(3, base.NQ)
    if p3.shape != (base.RANK, base.COMPONENTS, len(q3)) or p3.dtype != np.uint8:
        raise AssertionError("unexpected P3 tensor")
    flat = p3.reshape(base.RANK, -1)
    order = ordered_columns(q3)
    selected = np.empty(0, dtype=np.int32)
    attempts: list[dict] = []
    overall = time.monotonic()
    for block_number, start in enumerate(range(0, len(order), args.block)):
        end = min(len(order), start + args.block)
        candidates = np.concatenate((selected, order[start:end]))
        matrix_u8 = np.ascontiguousarray(flat[:, candidates], dtype=np.uint8)
        dense = matrix_u8.astype(np.float64)
        started = time.monotonic()
        rank, profile = base.column_rank_profile(dense)
        elapsed = time.monotonic() - started
        selected = candidates[profile]
        attempt = {
            "block_number": block_number,
            "ordered_columns_seen": end,
            "candidate_columns": len(candidates),
            "rank": rank,
            "fflas_seconds": round(elapsed, 6),
            "candidate_uint8_sha256": base.sha256_array(matrix_u8),
            "uint8_bytes": int(matrix_u8.nbytes),
            "modular_double_bytes": int(dense.nbytes),
        }
        attempts.append(attempt)
        print(json.dumps(attempt, sort_keys=True), flush=True)
        del candidates, matrix_u8, dense, profile
        if rank == base.RANK:
            break
    if len(selected) != base.RANK:
        raise RuntimeError(f"rank stopped at {len(selected)}")
    position = np.full(flat.shape[1], -1, dtype=np.int32)
    position[order] = np.arange(len(order), dtype=np.int32)
    pivot_positions = position[selected]
    if np.any(np.diff(pivot_positions) <= 0):
        raise AssertionError("unordered profile")
    pivot_components = (selected // len(q3)).astype(np.int8)
    pivot_monomials = (selected % len(q3)).astype(np.int32)
    pivot_exponents = np.asarray([q3[int(index)] for index in pivot_monomials], dtype=np.int8)
    shadows = base.shadow_counts(pivot_components, pivot_exponents)
    np.savez_compressed(
        OUT,
        prime=np.int32(base.P),
        variable_order=np.asarray(base.VARIABLE_ORDER, dtype=np.int8),
        ordered_columns=order,
        pivot_columns=selected,
        pivot_order_positions=pivot_positions,
        pivot_components=pivot_components,
        pivot_monomials=pivot_monomials,
        pivot_exponents=pivot_exponents,
        full_p3_sha256=np.asarray(base.sha256(base.P3)),
    )
    payload = {
        "status": "PASS_EXACT_DEGREE3_DP_PIVOT_PROFILE",
        "prime": base.P,
        "source": {"path": str(base.P3), "sha256": base.sha256(base.P3)},
        "implementation_dependency": {
            "file": Path(base.__file__).name,
            "sha256": base.sha256(Path(base.__file__)),
        },
        "term_order": {
            "homogeneous_tie": "Singular dp (degree reverse lexicographic)",
            "variables": [f"q{i}" for i in base.VARIABLE_ORDER],
            "module_component_tiebreak": "gen(6)>...>gen(1)",
        },
        "matrix_shape": list(flat.shape),
        "rank": len(selected),
        "ordered_columns_examined_until_full_rank": int(pivot_positions[-1]) + 1,
        "attempts": attempts,
        "pivot_profile": {
            "file": OUT.name,
            "sha256": base.sha256(OUT),
            "bytes": OUT.stat().st_size,
            "pivot_columns_sha256": base.sha256_array(selected),
            "pivot_exponents_sha256": base.sha256_array(pivot_exponents),
        },
        "shadows": shadows,
        "pair_criteria": {
            "different_components": "omit by the module product criterion",
            "same_degree4_lcm": (
                "one spanning tree per product fiber suffices because every pair "
                "difference is a linear combination of tree differences"
            ),
            "lcm_degree_above4": "defer, never discard, until that homogeneous layer",
        },
        "elapsed_seconds": round(time.monotonic() - overall, 6),
        "scope": "Exact P3 pivots/shadows only; no higher-pair reduction or membership verdict.",
    }
    MANIFEST.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print(json.dumps(payload, sort_keys=True), flush=True)


if __name__ == "__main__":
    main()

