#!/usr/bin/env python3
"""Build the divided second-normal quadratic system on residual P25 branch A."""

from __future__ import annotations

import argparse
import json
from pathlib import Path

import numpy as np

import produce_cross_basis as basis
import probe_c3_constant_gate as c3
import probe_c3_second_normal_gate as jets
from combine_c3_first_normal_nonbased_tangent_gate import klein_gradient
from probe_d35_mixed_third_quadratic_span import (
    product_coefficients, quadratic_monomials,
)


HERE = Path(__file__).resolve().parent
DEGREE = 31
DIMENSION = 198
BRANCH_DIMENSION = 51


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    parser.add_argument("--zeta", type=int, default=15)
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    c3.ZETA = args.zeta
    module = basis.module_at(prime, args.zeta)
    omega, generator, eigenspaces, stabilizer, roots, fixed_roots = (
        c3.c3_geometry(module)
    )
    e0 = c3.nullspace_mod(
        generator - np.eye(5, dtype=np.int64), prime
    )[0]
    e20, e21 = eigenspaces[2]
    source = eigenspaces[1]
    points = np.asarray([
        (source[0] + parameter * source[1]) % prime
        for parameter in range(61)
    ], dtype=np.int64)
    directions = np.asarray([
        e0, e20, e21,
        (e20 + e21) % prime,
        (e0 + e20) % prime,
        (e0 + e21) % prime,
    ], dtype=np.int64)
    common_path = HERE / "p25_common_nonbased_branches_p463.npz"
    with np.load(common_path, allow_pickle=False) as frozen:
        degree25_kernel = frozen["branch_A_degree25_kernel"].astype(np.int64)
    embedding = np.load(
        HERE / "degree_31/p25_multiplier_embedding_p463.npz",
        allow_pickle=False,
    )["multiplier_embedding"].astype(np.int64)
    target_kernel = embedding @ degree25_kernel % prime
    assert target_kernel.shape == (DIMENSION, BRANCH_DIMENSION)
    records = json.loads(
        (HERE / "degree_31/m1_cross_basis_circuits.json").read_text()
    )["basis"]
    dual_records = json.loads(
        (HERE / "dual_hironaka_generators.json").read_text()
    )["generators"]
    evaluator = basis.DualEvaluator(module, points, prime)
    root = np.load(
        HERE / "degree_31/c3_constant_gate_p463.npz", allow_pickle=False
    )["unique_c6_root"].astype(np.int64)
    gradient = klein_gradient(root, prime)
    pivot = int(np.flatnonzero(root)[0])
    monomials = quadratic_monomials(BRANCH_DIMENSION)
    quadratic_rows = []
    saved = {order: [] for order in (0, 1, 2)}
    for index, direction in enumerate(directions):
        print(f"branch-A second-normal direction {index + 1}/6", flush=True)
        dual_values = jets.dual_jets(
            evaluator, dual_records, direction, max_order=2
        )
        values = {
            order: jets.cross_coefficient_values(
                records, dual_values, points, direction, prime, order
            )
            for order in (0, 1, 2)
        }
        reduced = {
            order: np.einsum("pjn,nk->pjk", value, target_kernel) % prime
            for order, value in values.items()
        }
        for order in (0, 1, 2):
            saved[order].append(reduced[order])
        q0, q1, q2 = (reduced[order] for order in (0, 1, 2))
        scalar = (
            pow(int(root[pivot]), -1, prime) * q0[:, pivot, :]
        ) % prime
        assert all(np.array_equal(
            q0[:, output, :] % prime,
            root[output] * scalar % prime,
        ) for output in range(5))
        assert not np.any(np.einsum("i,pik->pk", gradient, q1) % prime)
        tangent_second = np.einsum("i,pik->pk", gradient, q2) % prime
        coefficient = product_coefficients(
            scalar, tangent_second, monomials, prime
        )
        for target in range(5):
            coefficient += (
                int(root[(target + 1) % 5])
                * product_coefficients(
                    q1[:, target, :], q1[:, target, :], monomials, prime
                )
                + 2 * int(root[target])
                * product_coefficients(
                    q1[:, target, :], q1[:, (target + 1) % 5, :],
                    monomials, prime,
                )
            )
            coefficient %= prime
        quadratic_rows.append(coefficient.astype(np.uint16))
    quadratic = np.concatenate(quadratic_rows).astype(np.int64)
    rank = c3.rank_mod(quadratic, prime)
    output = HERE / f"p25_branch_a_quadratic_span_p{prime}.npz"
    np.savez_compressed(
        output,
        source_points=points.astype(np.uint16),
        normal_directions=directions.astype(np.uint16),
        degree25_kernel=degree25_kernel.astype(np.uint16),
        target_kernel=target_kernel.astype(np.uint16),
        leading_target_root=root.astype(np.uint16),
        quadratic_monomials=monomials.astype(np.uint16),
        quadratic_coefficient_matrix=quadratic.astype(np.uint16),
        zeroth_normal_values=np.concatenate(saved[0]).astype(np.uint16),
        first_normal_values=np.concatenate(saved[1]).astype(np.uint16),
        second_normal_values=np.concatenate(saved[2]).astype(np.uint16),
    )
    print(
        f"p={prime}: branchA={BRANCH_DIMENSION} quadrics={len(monomials)} "
        f"rows={len(quadratic)} rank={rank}", flush=True
    )


if __name__ == "__main__":
    main()
