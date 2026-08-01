#!/usr/bin/env python3
"""Compute the standard invariant-multiple quotient of the fixed K1 bases.

This is a module-theoretic calculation, not a false replacement of the
projective primitive locus.  The linear span R_+ K1 may contain sums whose
five components have gcd one.  Consequently the landing equations are not
asserted to descend to this quotient; the complete landing computation must
retain the full coefficient vector or use an actual saturation by the
factorable/composition incidence loci.
"""

from __future__ import annotations

import hashlib
import itertools
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as base  # noqa: E402


PRIMES = {419: 13, 463: 15}
TARGETS = {31: 198, 35: 361}
LOWER_DIMENSIONS = {
    17: 2, 18: 3, 19: 7, 20: 11, 21: 16, 22: 25, 23: 34,
    24: 44, 25: 59, 26: 75, 27: 91, 28: 115, 29: 138,
    30: 165, 31: 198, 32: 232,
}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def fixed_direction_value(record, values, points, prime):
    indices = tuple(map(int, record["dual_generator_indices"]))
    multiplier = record["multiplier"]
    label = (
        int(multiplier["secondary_index"]),
        tuple(map(int, multiplier["primary_exponents"])),
    )
    cross = base.cross4(values, indices, prime)
    scalar = base.evaluate_polynomial(
        base.invariant_polynomial(label), points, prime
    )
    return cross * scalar[:, None] % prime


def scan_degree(target, generators, values, points, prime, positive_only=False):
    degrees = [int(record["degree"]) for record in generators]
    echelon = base.Echelon(prime)
    selected = []
    candidate_count = 0
    for indices in itertools.combinations(range(len(generators)), 4):
        residual = target - sum(degrees[index] for index in indices)
        if residual < 0 or (positive_only and residual == 0):
            continue
        cross = base.cross4(values, indices, prime)
        for label in base.invariant_labels(residual):
            candidate_count += 1
            scalar = base.evaluate_polynomial(
                base.invariant_polynomial(label), points, prime
            )
            vector = cross * scalar[:, None] % prime
            if echelon.add(vector.reshape(-1)):
                selected.append(base.direction_json(indices, label))
    return len(echelon), selected, candidate_count


def main() -> None:
    generator_path = HERE / "dual_hironaka_generators.json"
    generator_payload = json.loads(generator_path.read_text())
    generators = generator_payload["generators"]
    points = base.fixed_points(80)
    fixed_positive = {}
    fixed_complements = {}
    prime_records = {}
    for prime, zeta in PRIMES.items():
        module = base.module_at(prime, zeta)
        evaluator = base.DualEvaluator(module, points % prime, prime)
        values = base.evaluate_fixed_dual_generators(evaluator, generators)
        lower = {}
        # These are exactly the lower source degrees used by multiplication
        # into 31 or 35 by a positive-degree invariant.
        for degree, expected in LOWER_DIMENSIONS.items():
            rank, _selected, count = scan_degree(
                degree, generators, values, points % prime, prime
            )
            assert rank == expected
            lower[str(degree)] = {
                "wedge_rank": rank,
                "literal_K1_dimension": expected,
                "candidate_count": count,
            }
        degree_records = {}
        for target, dimension in TARGETS.items():
            rank, selected, count = scan_degree(
                target, generators, values, points % prime, prime,
                positive_only=True,
            )
            if prime == next(iter(PRIMES)):
                fixed_positive[target] = selected
            else:
                fixed_matrix = np.column_stack([
                    fixed_direction_value(record, values, points % prime, prime).reshape(-1)
                    for record in fixed_positive[target]
                ])
                fixed_rank = base.rank_mod(fixed_matrix, prime)
                assert fixed_rank == len(fixed_positive[target])
            expected_rank = {31: 197, 35: 361}[target]
            assert rank == expected_rank

            target_payload = json.loads(
                (HERE / f"degree_{target}/m1_cross_basis_circuits.json").read_text()
            )
            target_values = [
                fixed_direction_value(record, values, points % prime, prime).reshape(-1)
                for record in target_payload["basis"]
            ]
            quotient_echelon = base.Echelon(prime)
            for record in fixed_positive[target]:
                assert quotient_echelon.add(
                    fixed_direction_value(record, values, points % prime, prime).reshape(-1)
                )
            complement_indices = []
            for index, vector in enumerate(target_values):
                if quotient_echelon.add(vector):
                    complement_indices.append(index)
            assert len(quotient_echelon) == dimension
            assert len(complement_indices) == dimension - expected_rank
            if prime == next(iter(PRIMES)):
                fixed_complements[target] = complement_indices
            else:
                assert complement_indices == fixed_complements[target]
            degree_records[str(target)] = {
                "literal_K1_dimension": dimension,
                "positive_multiplier_candidate_count": count,
                "positive_multiplier_span_rank_in_this_fibre": rank,
                "fixed_positive_basis_rank": len(fixed_positive[target]),
                "fixed_complement_indices": complement_indices,
                "standard_module_quotient_dimension_in_this_fibre": len(complement_indices),
            }
            print(
                f"primitive-module p={prime} degree={target} "
                f"Rplus={rank} quotient={len(complement_indices)}",
                flush=True,
            )
        prime_records[str(prime)] = {
            "prime": prime,
            "zeta11": zeta,
            "lower_wedge_coverage": lower,
            "degrees": degree_records,
        }

    summary = {
        "schema": "cov-m1-standard-primitive-module-v1",
        "canonical_bases": "canonical_bases.json",
        "canonical_bases_sha256": sha256(HERE / "canonical_bases.json"),
        "dual_generators_sha256": sha256(generator_path),
        "definition": (
            "N_d is the span of invariant multiples I*p with deg(I)>0 and "
            "p in a lower literal K1 space; the displayed wedge presentation "
            "covers every lower source degree needed for d=31,35."
        ),
        "prime_records": prime_records,
        "characteristic_zero_scope": (
            "The displayed fixed factorable circuits give characteristic-zero "
            "subspaces of dimensions at least 197 and 361. Hence the standard "
            "module quotient has dimension at most 1 in degree 31 and is exactly "
            "zero in degree 35. Equality 1 in degree 31 requires an exact upper "
            "certificate for the full R_+ image; two agreeing reductions alone "
            "are not that certificate."
        ),
        "projective_warning": (
            "K1_d/N_d is an indecomposable-module quotient only. F(p)=0 does "
            "not descend under p -> p+n, and a sum of factorable covariants can "
            "have component gcd one. It is therefore forbidden to infer full-"
            "degree landing emptiness from quotient dimensions 1 or 0."
        ),
        "required_landing_operation": (
            "Retain all K1 coefficients and saturate the landing ideal away from "
            "the actual factorable and composition incidence loci."
        ),
        "degrees": {},
    }
    for target in TARGETS:
        directory = HERE / f"degree_{target}"
        nonprimitive_path = directory / "fixed_invariant_multiple_basis.json"
        nonprimitive_path.write_text(json.dumps({
            "schema": "cov-m1-fixed-invariant-multiple-circuits-v1",
            "degree": target,
            "dimension": len(fixed_positive[target]),
            "basis": fixed_positive[target],
            "fixed_complement_indices": fixed_complements[target],
        }, indent=2, sort_keys=True) + "\n")
        summary["degrees"][str(target)] = {
            "payload": str(nonprimitive_path.relative_to(HERE)),
            "payload_sha256": sha256(nonprimitive_path),
            "fixed_factorable_subspace_dimension": len(fixed_positive[target]),
            "fixed_complement_dimension": len(fixed_complements[target]),
        }
    counterexample_path = HERE / "primitive_quotient_counterexample.json"
    if counterexample_path.is_file():
        summary["primitive_quotient_counterexample"] = {
            "payload": counterexample_path.name,
            "payload_sha256": sha256(counterexample_path),
            "conclusion": (
                "In each selected degree an exact sum of two invariant-multiple "
                "directions has component gcd one. Hence the linear quotient "
                "provably deletes primitive covariants."
            ),
        }
    output = HERE / "primitive_module.json"
    output.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print("COV_M1_PRIMITIVE_MODULE_PRODUCED")


if __name__ == "__main__":
    main()
