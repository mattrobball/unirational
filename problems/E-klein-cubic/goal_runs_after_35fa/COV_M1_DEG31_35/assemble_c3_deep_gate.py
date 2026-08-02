#!/usr/bin/env python3
"""Assemble the exact third/fourth-normal C3 gate ledger."""

from __future__ import annotations

import hashlib
import json
from pathlib import Path

import numpy as np

import combine_c3_third_normal_gate as third
import probe_c3_constant_gate as c3
import probe_c3_fourth_normal_gate as fourth
from combine_c3_first_normal_nonbased_tangent_gate import klein_gradient


HERE = Path(__file__).resolve().parent


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def payload_record(path: Path) -> dict:
    return {"payload": str(path.relative_to(HERE)), "payload_sha256": sha256(path)}


def first_paths(degree: int, prime: int) -> list[Path]:
    paths = [HERE / f"degree_{degree}/c3_first_normal_exp0_p{prime}.npz"]
    if degree == 31:
        paths.append(HERE / f"degree_31/c3_first_normal_exp2_p{prime}.npz")
    else:
        paths.extend([
            HERE / f"degree_35/c3_first_normal_exp2_dir0_p{prime}.npz",
            HERE / f"degree_35/c3_first_normal_exp2_dir1_p{prime}.npz",
        ])
    return paths


def first_nonbased_tangent_record(degree: int, dimension: int,
                                  prime: int) -> dict:
    with np.load(
        HERE / f"degree_{degree}/c3_constant_gate_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        line_zero = frozen["basis_values"].astype(np.int64).reshape(-1, dimension)
    first_gate = [line_zero]
    for path in first_paths(degree, prime):
        with np.load(path, allow_pickle=False) as frozen:
            first_gate.append(frozen["extra_gate_matrix"].astype(np.int64))
    first_gate = np.concatenate(first_gate) % prime
    first_rank = c3.rank_mod(first_gate, prime)
    leading_path = (
        HERE / f"degree_31/c3_first_normal_exp2_p{prime}.npz"
        if degree == 31 else
        HERE / f"degree_35/c3_first_normal_exp0_p{prime}.npz"
    )
    with np.load(leading_path, allow_pickle=False) as frozen:
        leading = frozen["derivative_values"].astype(np.int64)
        root = frozen["target_root"].astype(np.int64)
    gradient = klein_gradient(root, prime)
    second_values = []
    for exponent in (0, 2):
        with np.load(
            HERE / f"degree_{degree}/c3_second_normal_exp{exponent}_p{prime}.npz",
            allow_pickle=False,
        ) as frozen:
            second_values.append(frozen["second_normal_values"].astype(np.int64))
    with np.load(
        HERE / f"degree_{degree}/c3_second_mixed_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        second_values.append(frozen["mixed_second_values"].astype(np.int64))
    tangent = np.concatenate([
        np.einsum("i,pin->pn", gradient, values) % prime
        for values in second_values
    ])
    combined = np.concatenate([first_gate, tangent]) % prime
    combined_rank = c3.rank_mod(combined, prime)
    kernel = c3.nullspace_mod(combined, prime).T
    restricted = np.einsum("pjn,nk->pjk", leading, kernel) % prime
    pivot = int(np.flatnonzero(root)[0])
    scalar = pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
    return {
        "first_gate_rank": first_rank,
        "tangent_extra_rank": combined_rank - first_rank,
        "combined_rank": combined_rank,
        "tangent_kernel_dimension": dimension - combined_rank,
        "leading_scalar_rank": c3.rank_mod(scalar, prime),
        "leading_block": payload_record(leading_path),
    }


def scalar_rank(values: np.ndarray, root: np.ndarray, gate: np.ndarray,
                prime: int) -> int:
    kernel = c3.nullspace_mod(gate, prime).T
    restricted = np.einsum("pjn,nk->pjk", values, kernel) % prime
    pivot = int(np.flatnonzero(root)[0])
    scalar = pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
    return c3.rank_mod(scalar, prime)


def third_record(degree: int, dimension: int, prime: int) -> dict:
    lower = third.lower_matrix(degree, prime, dimension)
    pure_payloads = []
    pure_gates = []
    pure_values = []
    pure_roots = []
    for exponent in (0, 2):
        path = HERE / f"degree_{degree}/c3_third_normal_exp{exponent}_p{prime}.npz"
        with np.load(path, allow_pickle=False) as frozen:
            pure_gates.append(frozen["extra_gate_matrix"].astype(np.int64))
            pure_values.append(frozen["third_normal_values"].astype(np.int64))
            pure_roots.append(frozen["target_root"].astype(np.int64))
        pure_payloads.append({"normal_exponent": exponent, **payload_record(path)})
    cumulative = [
        c3.rank_mod(np.concatenate([lower, *pure_gates[:end]]), prime)
        for end in (1, 2)
    ]
    pure_gate = np.concatenate([lower, *pure_gates]) % prime
    scalar_blocks = []
    kernel = c3.nullspace_mod(pure_gate, prime).T
    for values, root in zip(pure_values, pure_roots):
        restricted = np.einsum("pjn,nk->pjk", values, kernel) % prime
        pivot = int(np.flatnonzero(root)[0])
        scalar_blocks.append(
            pow(int(root[pivot]), -1, prime) * restricted[:, pivot, :] % prime
        )
    pure_scalar_rank = c3.rank_mod(np.concatenate(scalar_blocks), prime)
    pure_zero = np.concatenate([
        lower, *[values.reshape(-1, dimension) for values in pure_values]
    ]) % prime
    pure_zero_rank = c3.rank_mod(pure_zero, prime)

    mixed_path = HERE / f"degree_{degree}/c3_third_mixed_p{prime}.npz"
    with np.load(mixed_path, allow_pickle=False) as frozen:
        b1_values = frozen["b1_values"].astype(np.int64)
        b1_gate = frozen["b1_extra_gate_matrix"].astype(np.int64)
        b1_root = frozen["b1_target_root"].astype(np.int64)
        b2_values = frozen["b2_values"].astype(np.int64)
        b2_gate = frozen["b2_extra_gate_matrix"].astype(np.int64)
        b2_root = frozen["b2_target_root"].astype(np.int64)
    b1_gated = np.concatenate([pure_zero, b1_gate]) % prime
    b1_gate_rank = c3.rank_mod(b1_gated, prime)
    if len(b1_root):
        b1_scalar_rank = scalar_rank(b1_values, b1_root, b1_gated, prime)
        b1_zero = np.concatenate([pure_zero, b1_values.reshape(-1, dimension)]) % prime
    else:
        b1_scalar_rank = 0
        b1_zero = b1_gated
    b1_zero_rank = c3.rank_mod(b1_zero, prime)
    b2_gated = np.concatenate([b1_zero, b2_gate]) % prime
    b2_gate_rank = c3.rank_mod(b2_gated, prime)
    if len(b2_root):
        b2_scalar_rank = scalar_rank(b2_values, b2_root, b2_gated, prime)
        b2_zero = np.concatenate([b1_zero, b2_values.reshape(-1, dimension)]) % prime
    else:
        b2_scalar_rank = 0
        b2_zero = b2_gated
    b2_zero_rank = c3.rank_mod(b2_zero, prime)
    return {
        "pure_blocks": pure_payloads,
        "pure_cumulative_ranks": cumulative,
        "pure_gate_dimension": dimension - cumulative[-1],
        "pure_scalar_rank": pure_scalar_rank,
        "pure_zero_dimension": dimension - pure_zero_rank,
        "mixed_block": payload_record(mixed_path),
        "mixed_b1_gate_rank": b1_gate_rank,
        "mixed_b1_scalar_rank": b1_scalar_rank,
        "mixed_b1_zero_rank": b1_zero_rank,
        "mixed_b2_gate_rank": b2_gate_rank,
        "mixed_b2_scalar_rank": b2_scalar_rank,
        "mixed_b2_zero_rank": b2_zero_rank,
        "mixed_deep_gate_dimension": dimension - b2_gate_rank,
    }


def fourth_record(prime: int) -> dict:
    dimension = 361
    lower = fourth.fifth_based_matrix(prime)
    pure_payloads = []
    pure_gates = []
    pure_values = []
    pure_roots = []
    for exponent in (0, 2):
        path = HERE / f"degree_35/c3_fourth_normal_exp{exponent}_p{prime}.npz"
        with np.load(path, allow_pickle=False) as frozen:
            pure_gates.append(frozen["extra_gate_matrix"].astype(np.int64))
            pure_values.append(frozen["fourth_normal_values"].astype(np.int64))
            pure_roots.append(frozen["target_root"].astype(np.int64))
        pure_payloads.append({"normal_exponent": exponent, **payload_record(path)})
    cumulative = [
        c3.rank_mod(np.concatenate([lower, *pure_gates[:end]]), prime)
        for end in (1, 2)
    ]
    pure_gate = np.concatenate([lower, *pure_gates]) % prime
    pure_scalar_rank = scalar_rank(pure_values[0], pure_roots[0], pure_gate, prime)
    pure_zero = np.concatenate([
        lower, *[values.reshape(-1, dimension) for values in pure_values]
    ]) % prime
    pure_zero_rank = c3.rank_mod(pure_zero, prime)

    mixed_path = HERE / f"degree_35/c3_fourth_mixed_p{prime}.npz"
    with np.load(mixed_path, allow_pickle=False) as frozen:
        b1_values = frozen["b1_values"].astype(np.int64)
        b2_values = frozen["b2_values"].astype(np.int64)
        b2_gate = frozen["b2_extra_gate_matrix"].astype(np.int64)
        b2_root = frozen["b2_target_root"].astype(np.int64)
    b1_zero = np.concatenate([pure_zero, b1_values.reshape(-1, dimension)]) % prime
    b1_zero_rank = c3.rank_mod(b1_zero, prime)
    b2_gated = np.concatenate([b1_zero, b2_gate]) % prime
    b2_gate_rank = c3.rank_mod(b2_gated, prime)
    b2_scalar_rank = scalar_rank(b2_values, b2_root, b2_gated, prime)
    b2_zero = np.concatenate([b1_zero, b2_values.reshape(-1, dimension)]) % prime
    b2_zero_rank = c3.rank_mod(b2_zero, prime)
    return {
        "pure_blocks": pure_payloads,
        "pure_cumulative_ranks": cumulative,
        "pure_gate_dimension": dimension - cumulative[-1],
        "pure_scalar_rank": pure_scalar_rank,
        "pure_zero_dimension": dimension - pure_zero_rank,
        "mixed_block": payload_record(mixed_path),
        "mixed_b1_zero_rank": b1_zero_rank,
        "mixed_b2_gate_rank": b2_gate_rank,
        "mixed_b2_scalar_rank": b2_scalar_rank,
        "mixed_b2_zero_rank": b2_zero_rank,
        "mixed_deep_gate_dimension": dimension - b2_gate_rank,
    }


def third_mixed_nonbased_tangent_record(prime: int) -> dict:
    path = HERE / f"degree_35/c3_third_mixed_nonbased_tangent_p{prime}.npz"
    with np.load(path, allow_pickle=False) as frozen:
        base = frozen["base_gate_matrix"].astype(np.int64)
        tangent = frozen["tangent_gate_matrix"].astype(np.int64)
        kernel = frozen["combined_kernel_basis"].astype(np.int64)
        scalar = frozen["leading_scalar_forms"].astype(np.int64)
    return {
        **payload_record(path),
        "base_gate_rank": c3.rank_mod(base, prime),
        "tangent_combined_rank": c3.rank_mod(np.concatenate([base, tangent]), prime),
        "tangent_kernel_dimension": kernel.shape[1],
        "leading_scalar_rank": c3.rank_mod(scalar, prime),
    }


def second_mixed_nonbased_tangent_record(degree: int, prime: int) -> dict:
    path = HERE / (
        f"degree_{degree}/c3_second_mixed_nonbased_tangent_p{prime}.npz"
    )
    with np.load(path, allow_pickle=False) as frozen:
        base = frozen["base_gate_matrix"].astype(np.int64)
        tangent = frozen["tangent_gate_matrix"].astype(np.int64)
        kernel = frozen["combined_kernel_basis"].astype(np.int64)
        scalar = frozen["leading_scalar_forms"].astype(np.int64)
    return {
        **payload_record(path),
        "base_gate_rank": c3.rank_mod(base, prime),
        "tangent_combined_rank": c3.rank_mod(
            np.concatenate([base, tangent]), prime
        ),
        "tangent_kernel_dimension": kernel.shape[1],
        "leading_scalar_rank": c3.rank_mod(scalar, prime),
        "conclusion": (
            "the necessary tangent gate reduces this nonbased branch to "
            "the displayed kernel and independent leading-scalar chart cover"
        ),
    }


def main() -> None:
    prime_records = []
    for prime, zeta in ((463, 15), (727, 46)):
        prime_records.append({
            "prime": prime,
            "zeta11": zeta,
            "degrees": {
                "31": {
                    "first_normal_nonbased_tangent":
                        first_nonbased_tangent_record(31, 198, prime),
                    "second_mixed_nonbased_tangent":
                        second_mixed_nonbased_tangent_record(31, prime),
                    "third_normal": third_record(31, 198, prime),
                },
                "35": {
                    "first_normal_nonbased_tangent":
                        first_nonbased_tangent_record(35, 361, prime),
                    "second_mixed_nonbased_tangent":
                        second_mixed_nonbased_tangent_record(35, prime),
                    "third_normal": third_record(35, 361, prime),
                    "third_mixed_nonbased_tangent":
                        third_mixed_nonbased_tangent_record(prime),
                    "fourth_normal": fourth_record(prime),
                },
            },
        })
    deep_spans = {}
    for degree in (31, 35):
        path = HERE / f"degree_{degree}/d{degree}_deep_cubic_span_p463.npz"
        with np.load(path, allow_pickle=False) as frozen:
            coefficients = frozen["cubic_coefficient_matrix"].astype(np.int64)
            rows = frozen["fixed_minor_rows"].astype(np.int64)
        assert coefficients.shape[1] == 35
        assert len(rows) == 35
        assert c3.rank_mod(coefficients[rows], 463) == 35
        deep_spans[str(degree)] = {
            **payload_record(path),
            "gate_dimension": 5,
            "cubic_monomial_count": 35,
            "fixed_minor_rank": 35,
            "conclusion": "the complete landing cubics span every cubic on the deep gate, so its projectivization is empty over F_463",
        }
    root = {
        "schema": "cov-m1-c3-deep-normal-gate-v1",
        "scope": "special-fibre necessary recursive gates; tangent reduction of mixed-second nonbased branches and exact closure of the two deepest five-dimensional gates; earlier nonbased charts remain separate",
        "mathematical_gate": "On the scalar-zero branch of every lower normal order, the first nonzero next normal coefficient must lie in a character-compatible Klein fixed-root line or vanish. On a nonzero fixed-root branch, the next Klein coefficient imposes the exact tangent condition dF_R(q)=0. This reduces the mixed-second nonbased branches to smaller scalar chart covers. The two resulting five-dimensional deepest gates are empty because the complete landing cubics span their full degree-three coordinate spaces.",
        "prime_records": prime_records,
        "deep_cubic_spans": deep_spans,
        "decision_status": "mixed-second nonbased branches tangent-reduced and deep tails empty; earlier nonbased chart saturations open",
    }
    output = HERE / "c3_deep_normal_gate.json"
    output.write_text(json.dumps(root, indent=2, sort_keys=True) + "\n")
    print(f"wrote {output.name}")


if __name__ == "__main__":
    main()
