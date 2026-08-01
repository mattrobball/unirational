#!/usr/bin/env python3
"""Install all split cyclic fixed-locus gates on the complete landing ideals.

The prime 991 splits the element orders 2,3,5,6,11 and zeta_11=42.  The
existing fixed K1 circuits and both invariant evaluation frames remain full
rank there.  We enumerate every projective orbit of one-dimensional cyclic
eigenspaces.  In degree 35, the two exact-C5 orbits must map to the unique
C5-fixed target line; that line is off the Klein cubic, so both evaluations
vanish.  These are two new linear constraints.  All other one-dimensional
cyclic point images are zero already or lie on X.

The producer stacks these constraints with the C3/C6 constant-image gate,
restricts every complete factored landing equation, and records the based and
nonbased C3 strata.  It decides no saturation by itself.
"""

from __future__ import annotations

import hashlib
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402
import produce_landing_circuits as landing  # noqa: E402
import probe_c3_constant_gate as linear  # noqa: E402
import reduce_landing_by_c3 as reduction  # noqa: E402


P = 991
ZETA = 42
TARGETS = {31: (198, 5349), 35: (361, 8555)}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def canonical(vector: np.ndarray) -> tuple[int, ...]:
    value = np.asarray(vector, dtype=np.int64) % P
    pivot = int(np.flatnonzero(value)[0])
    value = value * pow(int(value[pivot]), -1, P) % P
    return tuple(map(int, value))


def projective_orbit(module, vector: np.ndarray):
    return {canonical(matrix @ vector % P) for matrix in module.GROUP}


def klein(vector: np.ndarray) -> int:
    return sum(
        int(vector[index]) ** 2 * int(vector[(index + 1) % 5])
        for index in range(5)
    ) % P


def cyclic_point_orbits(module):
    by_order = {}
    for index, matrix in enumerate(module.GROUP):
        by_order.setdefault(linear.matrix_order(matrix, P), []).append(index)
    assert {order: len(indices) for order, indices in by_order.items()} == {
        1: 1, 2: 55, 3: 110, 5: 264, 6: 110, 11: 120,
    }
    result = {}
    for order in (3, 5, 6, 11):
        matrix_index = by_order[order][0]
        matrix = module.GROUP[matrix_index]
        eigenvalues = [value for value in range(1, P) if pow(value, order, P) == 1]
        for eigenvalue in eigenvalues:
            eigenspace = linear.nullspace_mod(
                matrix - eigenvalue * np.eye(5, dtype=np.int64), P
            )
            if len(eigenspace) != 1:
                continue
            vector = eigenspace[0]
            orbit = projective_orbit(module, vector)
            key = min(orbit)
            if key not in result:
                result[key] = {
                    "vector": np.asarray(key, dtype=np.int64),
                    "orbit_size": len(orbit),
                    "orders": set(),
                    "eigen_records": [],
                }
            result[key]["orders"].add(order)
            result[key]["eigen_records"].append({
                "order": order,
                "matrix_index": matrix_index,
                "eigenvalue": eigenvalue,
            })
    assert len(result) == 7
    assert sorted(record["orbit_size"] for record in result.values()) == [
        55, 60, 66, 110, 110, 132, 132,
    ]
    return list(result.values()), by_order


def frame_points(degree: int, equation_count: int) -> np.ndarray:
    if degree == 35:
        payload = json.loads(
            (HERE / "degree_35/invariant_frame_points.json").read_text()
        )
        return np.asarray(payload["points"], dtype=np.int64)
    return basis.fixed_points(equation_count)


def main() -> None:
    linear.P = P
    linear.ZETA = ZETA
    module = basis.module_at(P, ZETA)
    generator_path = HERE / "dual_hironaka_generators.json"
    generators = json.loads(generator_path.read_text())["generators"]
    orbit_records, order_records = cyclic_point_orbits(module)
    orbit_points = np.asarray([record["vector"] for record in orbit_records])
    orbit_evaluator = basis.DualEvaluator(module, orbit_points, P)
    orbit_dual_values = basis.evaluate_fixed_dual_generators(
        orbit_evaluator, generators
    )
    summary = {
        "schema": "cov-m1-split-cyclic-reduced-landing-v1",
        "prime": P,
        "zeta11": ZETA,
        "group_order_ledger": {
            str(order): len(indices) for order, indices in order_records.items()
        },
        "scope": (
            "complete p=991 landing systems after C3/C6 and every "
            "one-dimensional cyclic fixed-locus gate; saturation open"
        ),
        "degrees": {},
    }
    for degree, (dimension, equation_count) in TARGETS.items():
        basis_path = HERE / f"degree_{degree}/m1_cross_basis_circuits.json"
        records = json.loads(basis_path.read_text())["basis"]
        assert len(records) == dimension

        # The exact fixed K1 circuits retain full rank at this decision prime.
        holdout_points = basis.fixed_points(80) % P
        holdout_evaluator = basis.DualEvaluator(module, holdout_points, P)
        holdout_dual = basis.evaluate_fixed_dual_generators(
            holdout_evaluator, generators
        )
        holdout = basis.evaluate_fixed_crosses(
            records, holdout_dual, holdout_points, P
        )
        fixed_basis_rank = basis.rank_mod(holdout, P)
        assert fixed_basis_rank == dimension

        # Enumerate the complete one-dimensional cyclic point-orbit ledger.
        orbit_values = basis.evaluate_fixed_crosses(
            records, orbit_dual_values, orbit_points, P
        ).reshape(len(orbit_points), 5, dimension)
        point_ledger = []
        new_gate_blocks = []
        for index, (orbit_record, values) in enumerate(
            zip(orbit_records, orbit_values)
        ):
            image_rank = basis.rank_mod(values, P)
            target_vector = None
            klein_value = None
            if image_rank == 1:
                column = int(np.flatnonzero(np.any(values, axis=0))[0])
                target_vector = values[:, column]
                klein_value = klein(target_vector)
                if klein_value:
                    new_gate_blocks.append(values)
            point_ledger.append({
                "index": index,
                "projective_vector": canonical(orbit_record["vector"]),
                "orbit_size": orbit_record["orbit_size"],
                "stabilizer_order": 660 // orbit_record["orbit_size"],
                "element_orders": sorted(orbit_record["orders"]),
                "eigen_records": orbit_record["eigen_records"],
                "evaluation_image_rank": image_rank,
                "target_image_generator": (
                    target_vector.tolist() if target_vector is not None else None
                ),
                "target_Klein_value": klein_value,
                "landing_linear_cut": bool(klein_value),
            })
        cyclic_gate = (
            np.concatenate(new_gate_blocks, axis=0) % P
            if new_gate_blocks else np.zeros((0, dimension), dtype=np.int64)
        )
        cyclic_gate_rank = (
            0 if cyclic_gate.shape[0] == 0 else basis.rank_mod(cyclic_gate, P)
        )
        assert cyclic_gate_rank == ({31: 0, 35: 2}[degree])
        if degree == 35:
            cut_orbits = [
                item for item in point_ledger if item["landing_linear_cut"]
            ]
            assert len(cut_orbits) == 2
            assert all(item["element_orders"] == [5] for item in cut_orbits)
            assert all(item["orbit_size"] == 132 for item in cut_orbits)

        cyclic_gate_path = HERE / (
            f"degree_{degree}/cyclic_fixed_locus_gate_p{P}.npz"
        )
        np.savez_compressed(
            cyclic_gate_path,
            orbit_points=orbit_points.astype(np.uint16),
            orbit_basis_values=orbit_values.astype(np.uint16),
            cyclic_gate_matrix=cyclic_gate.astype(np.uint16),
            fixed_basis_holdout_points=holdout_points.astype(np.uint16),
            fixed_basis_holdout_values=holdout.astype(np.uint16),
        )

        # Check the same complete invariant frame and evaluate all K1 circuits.
        points = frame_points(degree, equation_count)
        labels = landing.invariant_labels(3 * degree)
        invariant_matrix = landing.invariant_evaluation_matrix(
            labels, points % P, P
        )
        invariant_frame_rank = landing.rank_inplace_int32(invariant_matrix, P)
        del invariant_matrix
        assert invariant_frame_rank == equation_count
        landing_path = HERE / f"degree_{degree}/landing_circuits_p{P}.npz"
        basis_values = landing.evaluate_fixed_basis(
            records, generators, module, points, P, reuse_path=landing_path
        )
        np.savez_compressed(
            landing_path,
            fixed_source_points=(points % P).astype(np.uint16),
            basis_values=basis_values,
        )

        # Stack with the positive-dimensional C3/C6 constant gate.
        c3_path = HERE / f"degree_{degree}/c3_constant_gate_p{P}.npz"
        with np.load(c3_path, allow_pickle=False) as frozen:
            c3_gate = frozen["gate_matrix"].astype(np.int64)
            c3_line_values = frozen["basis_values"].astype(np.int64)
            c3_root = frozen["unique_c6_root"].astype(np.int64)
        combined_gate = np.vstack([c3_gate, cyclic_gate]) % P
        combined_rank = basis.rank_mod(combined_gate, P)
        assert combined_rank == ({31: 11, 35: 15}[degree])
        pivots, free, kernel = reduction.rref_kernel(combined_gate, P)
        reduced_dimension = dimension - combined_rank
        assert len(free) == reduced_dimension
        assert not np.any(combined_gate @ kernel % P)
        reduced_forms = reduction.restrict_forms(
            basis_values.reshape(-1, dimension), pivots, free, kernel, P
        ).reshape(equation_count, 5, reduced_dimension)
        form_rank = reduction.rank_mod(
            reduced_forms.reshape(-1, reduced_dimension)[:2 * reduced_dimension], P
        )
        assert form_rank == reduced_dimension

        # Split by zero/nonzero C3 restriction exactly as in the p=463 packet.
        c3_reduced = reduction.restrict_forms(
            c3_line_values.reshape(-1, dimension), pivots, free, kernel, P
        ).reshape(c3_line_values.shape[0], 5, reduced_dimension)
        root_pivot = int(np.flatnonzero(c3_root)[0])
        scalar_forms = (
            pow(int(c3_root[root_pivot]), -1, P)
            * c3_reduced[:, root_pivot, :].astype(np.int64)
        ) % P
        assert all(np.array_equal(
            c3_reduced[:, target, :] % P,
            c3_root[target] * scalar_forms % P,
        ) for target in range(5))
        scalar_rank = reduction.rank_mod(scalar_forms, P)
        assert scalar_rank == ({31: 10, 35: 12}[degree])
        scalar_pivots, scalar_free, based_kernel = reduction.rref_kernel(
            scalar_forms, P
        )
        based_dimension = reduced_dimension - scalar_rank
        assert len(scalar_free) == based_dimension

        reduced_path = HERE / f"degree_{degree}/cyclic_reduced_landing_p{P}.npz"
        np.savez_compressed(
            reduced_path,
            source_points=(points % P).astype(np.uint16),
            reduced_basis_values=reduced_forms.astype(np.uint16),
            combined_gate_matrix=combined_gate.astype(np.uint16),
            combined_kernel_basis=kernel.astype(np.uint16),
            combined_pivot_columns=pivots.astype(np.uint16),
            combined_free_columns=free.astype(np.uint16),
            c3_scalar_forms=scalar_forms.astype(np.uint16),
            based_kernel_basis=based_kernel.astype(np.uint16),
            scalar_pivot_columns=scalar_pivots.astype(np.uint16),
            scalar_free_columns=scalar_free.astype(np.uint16),
        )
        record = {
            "degree": degree,
            "original_parameter_dimension": dimension,
            "fixed_basis_rank": fixed_basis_rank,
            "invariant_frame_rank": invariant_frame_rank,
            "complete_equation_count": equation_count,
            "cyclic_point_orbits": point_ledger,
            "new_cyclic_gate_rank": cyclic_gate_rank,
            "c3_gate_rank": basis.rank_mod(c3_gate, P),
            "combined_gate_rank": combined_rank,
            "reduced_parameter_dimension": reduced_dimension,
            "factored_linear_form_shape": list(reduced_forms.shape),
            "factored_linear_form_rank": form_rank,
            "c3_scalar_form_rank": scalar_rank,
            "based_restriction_zero_dimension": based_dimension,
            "nonbased_chart_count": scalar_rank,
            "cyclic_gate_payload": str(cyclic_gate_path.relative_to(HERE)),
            "cyclic_gate_payload_sha256": sha256(cyclic_gate_path),
            "c3_gate_payload": str(c3_path.relative_to(HERE)),
            "c3_gate_payload_sha256": sha256(c3_path),
            "landing_payload": str(landing_path.relative_to(HERE)),
            "landing_payload_sha256": sha256(landing_path),
            "payload": str(reduced_path.relative_to(HERE)),
            "payload_sha256": sha256(reduced_path),
            "decision_status": "complete split-cyclic reduction; saturation open",
        }
        metadata_path = HERE / f"degree_{degree}/cyclic_reduced_landing_p{P}.json"
        metadata_path.write_text(json.dumps(record, indent=2, sort_keys=True) + "\n")
        summary["degrees"][str(degree)] = {
            "metadata": str(metadata_path.relative_to(HERE)),
            "metadata_sha256": sha256(metadata_path),
            **record,
        }
        print(
            f"d={degree}: cyclic+ C3 rank={combined_rank}, "
            f"reduced={reduced_dimension}, based={based_dimension}, "
            f"charts={scalar_rank}", flush=True,
        )
    output = HERE / "split_cyclic_reduced_landing.json"
    output.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print("COV_M1_SPLIT_CYCLIC_REDUCTION_OK")


if __name__ == "__main__":
    main()
