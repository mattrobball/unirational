#!/usr/bin/env python3
"""Probe the involution-minus-line landing consequence on the fixed K1 bases."""

from __future__ import annotations

import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402
import probe_c3_constant_gate as linear  # noqa: E402


P = 463
ZETA = 15


def main() -> None:
    linear.P = P
    linear.ZETA = ZETA
    module = basis.module_at(P, ZETA)
    identity = np.eye(5, dtype=np.int64)
    generator = next(
        matrix for matrix in module.GROUP
        if linear.matrix_order(matrix, P) == 2
        and len(linear.nullspace_mod(matrix + identity, P)) == 2
    )
    minus = linear.nullspace_mod(generator + identity, P)
    plus = linear.nullspace_mod(generator - identity, P)
    assert minus.shape == (2, 5) and plus.shape == (3, 5)
    stabilizer = [
        matrix for matrix in module.GROUP
        if linear.stable_subspace(matrix, minus)
    ]
    roots = linear.projective_roots(minus)
    fixed_roots = [
        root for root in roots
        if linear.fixed_projectively(root, stabilizer)
    ]
    print(
        f"C2 minus line: stabilizer={len(stabilizer)} roots={len(roots)} "
        f"globally_fixed_roots={len(fixed_roots)}"
    )
    print("stabilizer_orders", sorted(linear.matrix_order(item, P) for item in stabilizer))
    print("roots", [item.tolist() for item in roots])
    generators = json.loads((HERE / "dual_hironaka_generators.json").read_text())[
        "generators"
    ]
    for degree in (31, 35):
        records = json.loads(
            (HERE / f"degree_{degree}/m1_cross_basis_circuits.json").read_text()
        )["basis"]
        points = linear.line_points(minus, degree)
        evaluator = basis.DualEvaluator(module, points, P)
        dual_values = basis.evaluate_fixed_dual_generators(evaluator, generators)
        values = basis.evaluate_fixed_crosses(
            records, dual_values, points, P
        ).reshape(len(points), 5, len(records))
        restriction = values.reshape(-1, len(records))
        restriction_rank = linear.rank_mod(restriction, P)
        assert np.array_equal(
            np.einsum("ij,pjk->pik", generator, values) % P,
            -values % P,
        )
        if not fixed_roots:
            gate = restriction
            gate_kind = "restriction-zero"
        elif len(fixed_roots) == 1:
            gate = linear.landing_constant_matrix(values, fixed_roots[0])
            gate_kind = "constant-to-unique-fixed-root"
        else:
            gate = np.empty((0, len(records)), dtype=np.int64)
            gate_kind = "branched-fixed-root-union"
        print(
            f"degree={degree} restriction_rank={restriction_rank} "
            f"gate_kind={gate_kind} gate_rank={linear.rank_mod(gate, P)} "
            f"kernel={len(records)-linear.rank_mod(gate, P)}"
        )


if __name__ == "__main__":
    main()
