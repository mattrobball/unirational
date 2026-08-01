#!/usr/bin/env python3
"""Quadratic Taylor-span test on the 39D mixed-third nonbased branch.

After the third normal term is s*R and the fourth term h is tangent at R,
the next coefficient of the Klein equation, divided by the nonzero scalar
polynomial s, is

    B_R(h,h) + s*dF_R(k) = 0,

where k is the fifth normal coefficient.  We evaluate these exact quadratic
forms on 30 normal directions and 31 source-line points.  Full rank in all
quadratic monomials proves that the nonbased branch is empty.
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
from combine_c3_first_normal_nonbased_tangent_gate import klein_gradient  # noqa: E402


DEGREE = 35
DIMENSION = 361
REDUCED = 39
ORDERS = (3, 4, 5)


def cross_coefficient_orders(records, dual_values, points, direction, prime):
    """Evaluate several coefficient orders while sharing wedge/scalar jets."""
    cross_cache = {}
    scalar_cache = {}
    columns = {order: [] for order in ORDERS}
    for record in records:
        indices = tuple(map(int, record["dual_generator_indices"]))
        if indices not in cross_cache:
            cross_cache[indices] = jets.cross_jets(
                dual_values[:, list(indices)], prime
            )
        multiplier = record["multiplier"]
        label = (
            int(multiplier["secondary_index"]),
            tuple(map(int, multiplier["primary_exponents"])),
        )
        if label not in scalar_cache:
            scalar_cache[label] = jets.polynomial_jets(
                basis.invariant_polynomial(label), points, direction, prime, 5
            )
        cross = cross_cache[indices]
        scalar = scalar_cache[label]
        for order in ORDERS:
            columns[order].append(sum(
                (scalar[left][:, None] * cross[order - left]
                 for left in range(order + 1)),
                np.zeros_like(cross[0]),
            ) % prime)
    return {
        order: np.asarray(value).transpose(1, 2, 0)
        for order, value in columns.items()
    }


def quadratic_monomials(variables: int):
    left, right = np.triu_indices(variables)
    return np.column_stack([left, right]).astype(np.int64)


def product_coefficients(left_form, right_form, monomials, prime: int):
    left, right = monomials.T
    answer = left_form[:, left] * right_form[:, right] % prime
    distinct = left != right
    answer[:, distinct] += (
        left_form[:, right[distinct]] * right_form[:, left[distinct]]
    )
    return answer % prime


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
        for parameter in range(31)
    ], dtype=np.int64)
    normal_coordinates = np.asarray([
        (1, left, right) for left in range(6) for right in range(5)
    ], dtype=np.int64)
    normal_directions = np.asarray([
        (coordinates[0] * e0 + coordinates[1] * e20
         + coordinates[2] * e21) % prime
        for coordinates in normal_coordinates
    ], dtype=np.int64)
    tangent_path = (
        HERE / f"degree_35/c3_third_mixed_nonbased_tangent_p{prime}.npz"
    )
    with np.load(tangent_path, allow_pickle=False) as frozen:
        kernel = frozen["combined_kernel_basis"].astype(np.int64)
        root = frozen["leading_target_root"].astype(np.int64)
    assert kernel.shape == (DIMENSION, REDUCED)
    gradient = klein_gradient(root, prime)
    pivot = int(np.flatnonzero(root)[0])
    records = json.loads(
        (HERE / "degree_35/m1_cross_basis_circuits.json").read_text()
    )["basis"]
    dual_records = json.loads(
        (HERE / "dual_hironaka_generators.json").read_text()
    )["generators"]
    evaluator = basis.DualEvaluator(module, points, prime)
    monomials = quadratic_monomials(REDUCED)
    quadratic_rows = []
    saved = {order: [] for order in ORDERS}
    for index, direction in enumerate(normal_directions):
        print(f"fifth-normal sample {index + 1}/30", flush=True)
        dual_values = jets.dual_jets(
            evaluator, dual_records, direction, max_order=5
        )
        values = cross_coefficient_orders(
            records, dual_values, points, direction, prime
        )
        reduced = {
            order: np.einsum("pjn,nk->pjk", value, kernel) % prime
            for order, value in values.items()
        }
        for order in ORDERS:
            saved[order].append(reduced[order])
        q3, q4, q5 = (reduced[order] for order in ORDERS)
        scalar = (
            pow(int(root[pivot]), -1, prime) * q3[:, pivot, :]
        ) % prime
        assert all(np.array_equal(
            q3[:, output, :] % prime,
            root[output] * scalar % prime,
        ) for output in range(5))
        assert not np.any(np.einsum("i,pik->pk", gradient, q4) % prime)
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
        quadratic_rows.append(coefficient.astype(np.uint16))
    quadratic = np.concatenate(quadratic_rows, axis=0).astype(np.int64)
    rank = c3.rank_mod(quadratic, prime)
    output = (
        HERE / f"degree_35/d35_mixed_third_quadratic_span_p{prime}.npz"
    )
    np.savez_compressed(
        output,
        source_points=points.astype(np.uint16),
        normal_coordinates=normal_coordinates.astype(np.uint16),
        normal_directions=normal_directions.astype(np.uint16),
        tangent_kernel_basis=kernel.astype(np.uint16),
        leading_target_root=root.astype(np.uint16),
        quadratic_monomials=monomials.astype(np.uint16),
        quadratic_coefficient_matrix=quadratic.astype(np.uint16),
        third_normal_values=np.concatenate(saved[3]).astype(np.uint16),
        fourth_normal_values=np.concatenate(saved[4]).astype(np.uint16),
        fifth_normal_values=np.concatenate(saved[5]).astype(np.uint16),
    )
    print(
        f"p={prime}: tangentKernel={REDUCED} "
        f"quadraticMonomials={len(monomials)} spanRank={rank}",
        flush=True,
    )


if __name__ == "__main__":
    main()
