#!/usr/bin/env python3
"""Assemble the two-prime C3 second-normal branch certificate."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np

import probe_c3_constant_gate as c3


HERE = Path(__file__).resolve().parent
PRIMES = {463: 15, 727: 46}
DIMENSIONS = {31: 198, 35: 361}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def first_paths(degree: int, prime: int):
    paths = [HERE / f"degree_{degree}/c3_first_normal_exp0_p{prime}.npz"]
    if degree == 31:
        paths.append(HERE / f"degree_{degree}/c3_first_normal_exp2_p{prime}.npz")
    else:
        paths.extend([
            HERE / f"degree_{degree}/c3_first_normal_exp2_dir0_p{prime}.npz",
            HERE / f"degree_{degree}/c3_first_normal_exp2_dir1_p{prime}.npz",
        ])
    return paths


def file_record(path: Path):
    return {"payload": str(path.relative_to(HERE)), "payload_sha256": sha256(path)}


def main() -> None:
    result = {
        "schema": "cov-m1-c3-second-normal-gate-v1",
        "mathematical_gate": (
            "When p and its first normal jet vanish on the C3 line, each pure "
            "second-normal eigenblock must land in the Klein cubic. The unique "
            "nonzero-eligible pure block is projectively constant at its C6-fixed "
            "root. After its scalar vanishes, the remaining mixed E0*E2 block "
            "must likewise be constant at the original fixed root."
        ),
        "scope": (
            "special-fibre necessary recursive pre-elimination; residual "
            "nonbased charts and third-based saturation are open"
        ),
        "prime_records": [],
        "degrees": {
            "31": {
                "second_based_dimension": 130,
                "pure_gate_dimension": 99,
                "pure_nonbased_chart_count": 7,
                "pure_zero_dimension": 92,
                "mixed_gate_dimension": 78,
                "mixed_nonbased_chart_count": 13,
                "third_based_dimension": 65,
            },
            "35": {
                "second_based_dimension": 289,
                "pure_gate_dimension": 247,
                "pure_nonbased_chart_count": 24,
                "pure_zero_dimension": 223,
                "mixed_gate_dimension": 204,
                "mixed_nonbased_chart_count": 20,
                "third_based_dimension": 184,
            },
        },
        "decision_status": "necessary second-normal reduction proved; saturation open",
    }
    for prime, zeta in PRIMES.items():
        c3.P = prime
        prime_record = {"prime": prime, "zeta11": zeta, "degrees": {}}
        for degree, dimension in DIMENSIONS.items():
            c3_path = HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz"
            with np.load(c3_path, allow_pickle=False) as frozen:
                line_values = frozen["basis_values"].astype(np.int64).reshape(
                    -1, dimension
                )
            first_records = []
            lower = [line_values]
            for path in first_paths(degree, prime):
                with np.load(path, allow_pickle=False) as frozen:
                    lower.append(
                        frozen["derivative_values"].astype(np.int64).reshape(
                            -1, dimension
                        )
                    )
                first_records.append(file_record(path))
            second_based = np.concatenate(lower, axis=0) % prime
            second_based_rank = c3.rank_mod(second_based, prime)
            pure_records = []
            pure_gates = []
            pure_values = []
            for exponent in (0, 2):
                path = (
                    HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{prime}.npz"
                )
                with np.load(path, allow_pickle=False) as frozen:
                    pure_gates.append(frozen["extra_gate_matrix"].astype(np.int64))
                    pure_values.append(
                        frozen["second_normal_values"].astype(np.int64).reshape(
                            -1, dimension
                        )
                    )
                pure_records.append({"normal_exponent": exponent, **file_record(path)})
            pure_cumulative = [
                c3.rank_mod(np.concatenate([second_based, *pure_gates[:end]]), prime)
                for end in (1, 2)
            ]
            pure_combined = np.concatenate([second_based, *pure_gates], axis=0) % prime
            pure_kernel = c3.nullspace_mod(pure_combined, prime).T
            surviving_index = 0 if degree == 31 else 1
            surviving_path = HERE / pure_records[surviving_index]["payload"]
            with np.load(surviving_path, allow_pickle=False) as frozen:
                surviving = frozen["second_normal_values"].astype(np.int64)
                surviving_root = frozen["target_root"].astype(np.int64)
            surviving_reduced = np.einsum(
                "pjn,nk->pjk", surviving, pure_kernel
            ) % prime
            pivot = int(np.flatnonzero(surviving_root)[0])
            pure_scalar = (
                pow(int(surviving_root[pivot]), -1, prime)
                * surviving_reduced[:, pivot, :]
            ) % prime
            pure_scalar_rank = c3.rank_mod(pure_scalar, prime)
            pure_zero = np.concatenate([second_based, *pure_values], axis=0) % prime
            pure_zero_rank = c3.rank_mod(pure_zero, prime)
            mixed_path = HERE / f"degree_{degree}/c3_second_mixed_p{prime}.npz"
            with np.load(mixed_path, allow_pickle=False) as frozen:
                mixed_gate = frozen["extra_gate_matrix"].astype(np.int64)
                mixed_values = frozen["mixed_second_values"].astype(np.int64)
                mixed_root = frozen["target_root"].astype(np.int64)
            mixed_combined = np.concatenate([pure_zero, mixed_gate], axis=0) % prime
            mixed_rank = c3.rank_mod(mixed_combined, prime)
            mixed_kernel = c3.nullspace_mod(mixed_combined, prime).T
            mixed_reduced = np.einsum("pjn,nk->pjk", mixed_values, mixed_kernel) % prime
            pivot = int(np.flatnonzero(mixed_root)[0])
            mixed_scalar = (
                pow(int(mixed_root[pivot]), -1, prime)
                * mixed_reduced[:, pivot, :]
            ) % prime
            mixed_scalar_rank = c3.rank_mod(mixed_scalar, prime)
            third_based = np.concatenate(
                [pure_zero, mixed_values.reshape(-1, dimension)], axis=0
            ) % prime
            third_based_rank = c3.rank_mod(third_based, prime)
            expected = {
                31: (68, [76, 99], 7, 106, 120, 13, 133),
                35: (72, [82, 114], 24, 138, 157, 20, 177),
            }[degree]
            actual = (second_based_rank, pure_cumulative, pure_scalar_rank,
                      pure_zero_rank, mixed_rank, mixed_scalar_rank,
                      third_based_rank)
            assert actual == expected
            prime_record["degrees"][str(degree)] = {
                "input_dimension": dimension,
                "c3_gate": file_record(c3_path),
                "first_normal_blocks": first_records,
                "second_based_rank": second_based_rank,
                "pure_blocks": pure_records,
                "pure_cumulative_ranks": pure_cumulative,
                "pure_combined_kernel_dimension": dimension - pure_cumulative[-1],
                "pure_scalar_rank": pure_scalar_rank,
                "pure_zero_rank": pure_zero_rank,
                "mixed_block": file_record(mixed_path),
                "mixed_combined_rank": mixed_rank,
                "mixed_combined_kernel_dimension": dimension - mixed_rank,
                "mixed_scalar_rank": mixed_scalar_rank,
                "third_based_rank": third_based_rank,
                "third_based_dimension": dimension - third_based_rank,
            }
            print(f"p={prime} d={degree}: {actual}", flush=True)
        result["prime_records"].append(prime_record)
    (HERE / "c3_second_normal_gate.json").write_text(
        json.dumps(result, indent=2, sort_keys=True) + "\n"
    )
    print("COV_M1_C3_SECOND_NORMAL_GATE_OK")


if __name__ == "__main__":
    main()
