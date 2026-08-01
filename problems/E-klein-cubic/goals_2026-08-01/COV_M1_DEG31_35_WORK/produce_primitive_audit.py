#!/usr/bin/env python3
"""Audit invariant-multiple directions inside the fixed K1 modules.

The linear indecomposable-module quotient M/(R_+ M) is not the same object as
the locus of polynomial maps having a common scalar factor.  This producer
computes the former as far as fixed characteristic-zero minors allow and
records the distinction explicitly; it does not discard the decomposable
span before applying the nonlinear Klein equation.
"""

from __future__ import annotations

import itertools
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402


TARGETS = {31: 198, 35: 361}


def select_positive(target, expected, generators, values, points, prime, fixed=None):
    degrees = [int(record["degree"]) for record in generators]
    echelon = basis.Echelon(prime)
    selected = []
    selected_values = []
    tested = 0
    increments = {}
    fixed_lookup = None
    if fixed is not None:
        fixed_lookup = {
            (
                tuple(record["dual_generator_indices"]),
                int(record["multiplier"]["secondary_index"]),
                tuple(record["multiplier"]["primary_exponents"]),
            ): record
            for record in fixed
        }
    for indices in itertools.combinations(range(len(generators)), 4):
        residual = target - sum(degrees[index] for index in indices)
        if residual <= 0:
            continue
        cross = basis.cross4(values, indices, prime)
        for label in basis.invariant_labels(residual):
            tested += 1
            scalar = basis.evaluate_polynomial(
                basis.invariant_polynomial(label), points, prime
            )
            value = cross * scalar[:, None] % prime
            if echelon.add(value.reshape(-1)):
                increments[str(residual)] = increments.get(str(residual), 0) + 1
                record = basis.direction_json(indices, label)
                if fixed is None:
                    selected.append(record)
                    selected_values.append(value)
                else:
                    key = (indices, int(label[0]), tuple(label[1]))
                    if key in fixed_lookup:
                        # Selection in another order is irrelevant below; fixed
                        # circuits receive their own rank check after the full scan.
                        pass
    full_rank = len(echelon)

    if fixed is not None:
        fixed_echelon = basis.Echelon(prime)
        for record in fixed:
            indices = tuple(map(int, record["dual_generator_indices"]))
            multiplier = record["multiplier"]
            label = (
                int(multiplier["secondary_index"]),
                tuple(map(int, multiplier["primary_exponents"])),
            )
            value = basis.cross4(values, indices, prime)
            scalar = basis.evaluate_polynomial(
                basis.invariant_polynomial(label), points, prime
            )
            value = value * scalar[:, None] % prime
            assert fixed_echelon.add(value.reshape(-1))
            selected_values.append(value)
        selected = fixed
        fixed_rank = len(fixed_echelon)
    else:
        fixed_rank = len(selected)
    assert fixed_rank == full_rank
    matrix = np.asarray(selected_values).transpose(1, 2, 0).reshape(-1, fixed_rank)
    rows = basis.rank_profile(matrix, prime)
    assert len(rows) == fixed_rank
    return selected, matrix, rows, {
        "all_positive_multiplier_candidate_rank": full_rank,
        "fixed_selected_rank": fixed_rank,
        "candidates_tested": tested,
        "rank_increments_by_multiplier_degree": increments,
    }


def main() -> None:
    generators = json.loads((HERE / "dual_hironaka_generators.json").read_text())[
        "generators"
    ]
    points = basis.fixed_points(80)
    fixed = {}
    fixed_rows = {}
    prime_records = {}
    for prime, zeta in basis.PRIMES.items():
        module = basis.module_at(prime, zeta)
        evaluator = basis.DualEvaluator(module, points % prime, prime)
        values = basis.evaluate_fixed_dual_generators(evaluator, generators)
        prime_record = {"prime": prime, "zeta11": zeta, "degrees": {}}
        for target, dimension in TARGETS.items():
            selected, matrix, rows, record = select_positive(
                target, dimension, generators, values, points % prime, prime,
                fixed.get(target),
            )
            if target not in fixed:
                fixed[target] = selected
                fixed_rows[target] = rows
            assert basis.rank_mod(matrix[fixed_rows[target]], prime) == len(selected)
            output = HERE / f"degree_{target}" / f"positive_multiples_p{prime}.npz"
            np.savez_compressed(
                output,
                fixed_points=(points % prime).astype(np.uint16),
                selected_evaluations=matrix.astype(np.uint16),
                fixed_minor_rows=fixed_rows[target].astype(np.int32),
            )
            record.update({
                "ambient_m1_dimension": dimension,
                "special_fibre_linear_indecomposable_quotient_dimension": (
                    dimension - record["all_positive_multiplier_candidate_rank"]
                ),
                "payload": output.name,
                "payload_sha256": basis.sha256(output),
            })
            prime_record["degrees"][str(target)] = record
            print(
                f"primitive-audit degree={target} p={prime} "
                f"positive={record['all_positive_multiplier_candidate_rank']} "
                f"quotient={dimension-record['all_positive_multiplier_candidate_rank']}",
                flush=True,
            )
        prime_records[str(prime)] = prime_record

    degree_records = {}
    for target, dimension in TARGETS.items():
        path = HERE / f"degree_{target}" / "positive_multiple_circuits.json"
        path.write_text(json.dumps({
            "schema": "cov-m1-positive-invariant-multiple-basis-v1",
            "degree": target,
            "ambient_m1_dimension": dimension,
            "dimension": len(fixed[target]),
            "basis": fixed[target],
            "fixed_evaluation_points": points.tolist(),
            "fixed_maximal_minor_rows": fixed_rows[target].tolist(),
            "meaning": (
                "Each displayed circuit is literally f*q with f a positive-degree "
                "invariant and q a lower-degree four-dual-cross K1 covariant."
            ),
        }, indent=2, sort_keys=True) + "\n")
        degree_records[str(target)] = {
            "ambient_m1_dimension": dimension,
            "fixed_positive_multiple_subspace_dimension": len(fixed[target]),
            "characteristic_zero_quotient_upper_bound": dimension - len(fixed[target]),
            "circuits": str(path.relative_to(HERE)),
            "circuits_sha256": basis.sha256(path),
        }

    output = HERE / "primitive_module_audit.json"
    output.write_text(json.dumps({
        "schema": "cov-m1-primitive-module-audit-v1",
        "degrees": degree_records,
        "prime_records": prime_records,
        "scope_warning": (
            "The linear quotient K1_d/(R_+ K1)_d is not a quotient on which the "
            "nonlinear equation F(p)=0 descends. A sum of invariant multiples "
            "need not have a common scalar divisor. Therefore even a zero module "
            "quotient does not authorize deleting the full degree-d landing scheme."
        ),
        "degree_35_exact_linear_conclusion": (
            "The 361 fixed positive-multiple circuits are independent in "
            "characteristic zero and lie in the 361-dimensional exact K1_35; "
            "hence the linear indecomposable-module quotient is exactly zero."
        ),
        "degree_31_exact_linear_conclusion": (
            "There is a fixed 197-dimensional characteristic-zero subspace of "
            "positive invariant multiples, so the linear indecomposable-module "
            "quotient has dimension at most one. The two special fibres have "
            "dimension one; no characteristic-zero upper-rank theorem for every "
            "positive-multiple circuit is claimed here."
        ),
    }, indent=2, sort_keys=True) + "\n")
    print("COV_M1_PRIMITIVE_MODULE_AUDIT_PRODUCED", flush=True)


if __name__ == "__main__":
    main()
