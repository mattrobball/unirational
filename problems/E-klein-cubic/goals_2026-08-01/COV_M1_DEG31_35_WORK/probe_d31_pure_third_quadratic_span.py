#!/usr/bin/env python3
"""Divided quadratic Taylor system on the four residual d31 pure-third charts.

The first two scalar charts (the exponent-zero block) are already empty over
F_463.  On their complement that block is zero.  The exponent-two third jet
is a nonzero scalar polynomial times a fixed smooth Klein root R.  We impose
its fourth-order tangent equation and then materialize the divided fifth-order
quadratic coefficient

    B_R(q4,q4) + s*dF_R(q5) = 0.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402
import probe_c3_constant_gate as c3  # noqa: E402
import probe_c3_second_normal_gate as jets  # noqa: E402
import probe_cubic_scalar_cubes as cubic  # noqa: E402
from combine_c3_first_normal_nonbased_tangent_gate import klein_gradient  # noqa: E402
from probe_d35_mixed_third_quadratic_span import (  # noqa: E402
    cross_coefficient_orders,
    product_coefficients,
    quadratic_monomials,
)


DEGREE = 31
DIMENSION = 198
PURE_GATE_DIMENSION = 36
ORDERS = (3, 4, 5)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=463)
    parser.add_argument("--zeta", type=int, default=15)
    args = parser.parse_args()
    prime = args.prime
    c3.P = prime
    c3.ZETA = args.zeta

    gate_kernel, _, _ = cubic.degree31_third_pure(prime)
    assert gate_kernel.shape == (DIMENSION, PURE_GATE_DIMENSION)
    with np.load(
        HERE / f"degree_31/c3_third_normal_exp0_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        exp0_values = frozen["third_normal_values"].astype(np.int64)
        exp0_root = frozen["target_root"].astype(np.int64)
    exp0_reduced = np.einsum(
        "pjn,nk->pjk", exp0_values, gate_kernel
    ) % prime
    exp0_pivot = int(np.flatnonzero(exp0_root)[0])
    exp0_scalar = (
        pow(int(exp0_root[exp0_pivot]), -1, prime)
        * exp0_reduced[:, exp0_pivot, :]
    ) % prime
    exp0_rows = cubic.independent_rows(exp0_scalar, prime)
    assert len(exp0_rows) == 2
    exp0_zero = exp0_scalar[exp0_rows]

    with np.load(
        HERE / f"degree_31/c3_third_normal_exp2_p{prime}.npz",
        allow_pickle=False,
    ) as frozen:
        points = frozen["source_points"].astype(np.int64)
        normal_coordinates = frozen["direction_coordinates"].astype(np.int64)
        normal_directions = frozen["normal_directions"].astype(np.int64)
        stored_third = frozen["third_normal_values"].astype(np.int64)
        root = frozen["target_root"].astype(np.int64)
    module = basis.module_at(prime, args.zeta)
    records = json.loads(
        (HERE / "degree_31/m1_cross_basis_circuits.json").read_text()
    )["basis"]
    dual_records = json.loads(
        (HERE / "dual_hironaka_generators.json").read_text()
    )["generators"]
    evaluator = basis.DualEvaluator(module, points, prime)
    saved = {order: [] for order in ORDERS}
    for index, direction in enumerate(normal_directions):
        print(f"d31 fifth-normal sample {index + 1}/{len(normal_directions)}", flush=True)
        dual_values = jets.dual_jets(
            evaluator, dual_records, direction, max_order=5
        )
        values = cross_coefficient_orders(
            records, dual_values, points, direction, prime
        )
        for order in ORDERS:
            saved[order].append(values[order])
    original = {
        order: np.concatenate(saved[order]) % prime for order in ORDERS
    }
    assert np.array_equal(original[3], stored_third % prime)
    pure_reduced = {
        order: np.einsum(
            "pjn,nk->pjk", original[order], gate_kernel
        ) % prime
        for order in ORDERS
    }
    gradient = klein_gradient(root, prime)
    tangent = np.einsum("i,pik->pk", gradient, pure_reduced[4]) % prime
    tangent_base = np.concatenate([exp0_zero, tangent]) % prime
    tangent_rank = c3.rank_mod(tangent_base, prime)
    reduction = c3.nullspace_mod(tangent_base, prime).T
    reduced_dimension = reduction.shape[1]
    assert not np.any(exp0_zero @ reduction % prime)
    reduced = {
        order: np.einsum(
            "pjn,nk->pjk", pure_reduced[order], reduction
        ) % prime
        for order in ORDERS
    }
    q3, q4, q5 = (reduced[order] for order in ORDERS)
    pivot = int(np.flatnonzero(root)[0])
    scalar = pow(int(root[pivot]), -1, prime) * q3[:, pivot, :] % prime
    assert all(np.array_equal(
        q3[:, output, :] % prime,
        root[output] * scalar % prime,
    ) for output in range(5))
    scalar_rank = c3.rank_mod(scalar, prime)
    assert not np.any(np.einsum("i,pik->pk", gradient, q4) % prime)
    monomials = quadratic_monomials(reduced_dimension)
    tangent_fifth = np.einsum("i,pik->pk", gradient, q5) % prime
    coefficient = product_coefficients(
        scalar, tangent_fifth, monomials, prime
    )
    for target in range(5):
        coefficient += (
            int(root[(target + 1) % 5])
            * product_coefficients(
                q4[:, target, :], q4[:, target, :], monomials, prime
            )
            + 2 * int(root[target])
            * product_coefficients(
                q4[:, target, :], q4[:, (target + 1) % 5, :],
                monomials, prime,
            )
        )
        coefficient %= prime
    quadratic_rank = c3.rank_mod(coefficient, prime)
    output = HERE / f"degree_31/d31_pure_third_quadratic_span_p{prime}.npz"
    np.savez_compressed(
        output,
        source_points=points.astype(np.uint16),
        normal_coordinates=normal_coordinates.astype(np.uint16),
        normal_directions=normal_directions.astype(np.uint16),
        pure_gate_kernel_basis=gate_kernel.astype(np.uint16),
        exponent_zero_scalar_zero_rows=exp0_zero.astype(np.uint16),
        tangent_gate_matrix=tangent.astype(np.uint16),
        tangent_reduction_basis=reduction.astype(np.uint16),
        leading_target_root=root.astype(np.uint16),
        leading_scalar_forms=scalar.astype(np.uint16),
        quadratic_monomials=monomials.astype(np.uint16),
        quadratic_coefficient_matrix=coefficient.astype(np.uint16),
        third_normal_values=q3.astype(np.uint16),
        fourth_normal_values=q4.astype(np.uint16),
        fifth_normal_values=q5.astype(np.uint16),
    )
    print(
        f"p={prime}: exp0ZeroRank=2 tangentRank={tangent_rank} "
        f"reduced={reduced_dimension} scalarRank={scalar_rank} "
        f"quadraticMonomials={len(monomials)} spanRank={quadratic_rank}",
        flush=True,
    )


if __name__ == "__main__":
    main()
