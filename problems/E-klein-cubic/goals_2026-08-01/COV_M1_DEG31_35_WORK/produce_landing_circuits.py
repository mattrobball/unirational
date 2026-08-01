#!/usr/bin/env python3
"""Construct the complete landing ideals as fixed factored cubic circuits.

For p in the fixed K1 basis, F(p) is a G-invariant scalar form of degree 3d.
The invariant Hironaka basis has dimensions 5349 and 8555.  A fixed square
evaluation frame with nonzero determinant therefore turns coefficientwise
vanishing into the same number of factored cubics

    F(sum_i c_i p_i(x_j)).

No source coefficient and no parameter monomial is omitted; the evaluation
frame is an invertible change of generators in the full invariant coefficient
space.  Modular payloads certify fixed minors but the defining circuits are
the characteristic-zero Reynolds/wedge formulas and integral evaluation
points.
"""

from __future__ import annotations

import ctypes
import hashlib
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as base  # noqa: E402


FFPACK = "/opt/homebrew/lib/libffpack_c.dylib"
PRIMES = {419: 13, 463: 15}
TARGETS = {31: (198, 5349), 35: (361, 8555)}


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for block in iter(lambda: stream.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def rank_inplace_int32(matrix: np.ndarray, prime: int) -> int:
    assert matrix.dtype == np.int32 and matrix.flags.c_contiguous
    row_permutation = np.empty(matrix.shape[0], dtype=np.uintp)
    column_permutation = np.empty(matrix.shape[1], dtype=np.uintp)
    function = ctypes.CDLL(FFPACK).RowEchelonForm_modular_int32_t
    function.argtypes = [
        ctypes.c_int32,
        ctypes.c_size_t,
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_int32),
        ctypes.c_size_t,
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.POINTER(ctypes.c_size_t),
        ctypes.c_bool,
        ctypes.c_int,
        ctypes.c_bool,
    ]
    function.restype = ctypes.c_size_t
    return int(
        function(
            prime,
            matrix.shape[0],
            matrix.shape[1],
            matrix.ctypes.data_as(ctypes.POINTER(ctypes.c_int32)),
            matrix.shape[1],
            row_permutation.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
            column_permutation.ctypes.data_as(ctypes.POINTER(ctypes.c_size_t)),
            False,
            2,
            True,
        )
    )


def invariant_labels(degree: int):
    labels = []
    for secondary, secondary_degree in enumerate(base.core.SECONDARY_DEGREES):
        if secondary_degree <= degree:
            for exponents in base.core.weighted_exponents(degree - secondary_degree):
                labels.append((secondary, tuple(map(int, exponents))))
    return labels


def factor_values(points: np.ndarray, prime: int):
    primary = [
        base.evaluate_polynomial(base.core.forms()[degree], points, prime)
        for degree in base.core.PRIMARY_DEGREES
    ]
    secondary = [
        base.evaluate_polynomial(polynomial, points, prime)
        for polynomial in base.core.secondary_polynomials()
    ]
    return primary, secondary


def invariant_evaluation_matrix(labels, points: np.ndarray, prime: int):
    primary, secondary = factor_values(points, prime)
    matrix = np.empty((len(points), len(labels)), dtype=np.int32)
    power_cache = {}
    for column, (secondary_index, exponents) in enumerate(labels):
        value = secondary[secondary_index].copy()
        for index, exponent in enumerate(exponents):
            key = index, exponent
            if exponent and key not in power_cache:
                power_cache[key] = np.asarray(
                    [pow(int(item), exponent, prime) for item in primary[index]],
                    dtype=np.int64,
                )
            if exponent:
                value = value * power_cache[key] % prime
        matrix[:, column] = value.astype(np.int32)
    return matrix


def evaluate_fixed_basis(
    records, generators, module, points, prime, chunk=32, reuse_path=None
):
    answer = np.empty((len(points), 5, len(records)), dtype=np.uint16)
    missing = list(range(len(points)))
    if reuse_path is not None and Path(reuse_path).exists():
        with np.load(reuse_path) as frozen:
            old_points = frozen["fixed_source_points"].astype(np.int64)
            old_values = frozen["basis_values"].astype(np.uint16)
        lookup = {tuple(map(int, point)): index for index, point in enumerate(old_points)}
        missing = []
        for index, point in enumerate(np.asarray(points, dtype=np.int64) % prime):
            old_index = lookup.get(tuple(map(int, point)))
            if old_index is None:
                missing.append(index)
            else:
                answer[index] = old_values[old_index]
        print(
            f"landing values p={prime} reused={len(points)-len(missing)} "
            f"missing={len(missing)}",
            flush=True,
        )
    for start in range(0, len(missing), chunk):
        selected = missing[start:start + chunk]
        block = np.asarray(points[selected], dtype=np.int64) % prime
        evaluator = base.DualEvaluator(module, block, prime)
        dual_values = base.evaluate_fixed_dual_generators(evaluator, generators)
        matrix = base.evaluate_fixed_crosses(
            records, dual_values, block, prime
        )
        answer[selected] = matrix.reshape(len(block), 5, len(records)).astype(np.uint16)
        stop = min(start + chunk, len(missing))
        if stop % 1024 < chunk or stop == len(missing):
            print(
                f"landing values p={prime} computed_missing={stop}/{len(missing)}",
                flush=True,
            )
    return answer


def klein_value(vector: np.ndarray, prime: int):
    return sum(
        int(vector[index]) * int(vector[index])
        * int(vector[(index + 1) % 5])
        for index in range(5)
    ) % prime


def main() -> None:
    generators_path = HERE / "dual_hironaka_generators.json"
    generators = json.loads(generators_path.read_text())["generators"]
    primitive = json.loads((HERE / "primitive_module.json").read_text())
    summary = {
        "schema": "cov-m1-complete-factored-landing-ideals-v1",
        "decision_status": (
            "complete coefficientwise ideals constructed; C3/C6 linear "
            "elimination installed; projective saturation not decided"
        ),
        "canonical_bases": "canonical_bases.json",
        "canonical_bases_sha256": sha256(HERE / "canonical_bases.json"),
        "parameter_basis": "canonical_bases.json",
        "parameter_basis_sha256": sha256(HERE / "canonical_bases.json"),
        "dual_generators_sha256": sha256(generators_path),
        "degrees": {},
    }
    for target, (dimension, equation_count) in TARGETS.items():
        coefficient_degree = 3 * target
        labels = invariant_labels(coefficient_degree)
        assert len(labels) == equation_count
        common_frame_path = HERE / f"degree_{target}/invariant_frame_points.json"
        if common_frame_path.exists():
            frame = json.loads(common_frame_path.read_text())
            assert frame["degree"] == coefficient_degree
            assert frame["dimension"] == equation_count
            points = np.asarray(frame["points"], dtype=np.int64)
        else:
            points = base.fixed_points(equation_count)
        basis_path = HERE / f"degree_{target}/m1_cross_basis_circuits.json"
        records = json.loads(basis_path.read_text())["basis"]
        assert len(records) == dimension
        prime_records = []
        for prime, zeta in PRIMES.items():
            invariant_matrix = invariant_evaluation_matrix(
                labels, points % prime, prime
            )
            invariant_rank = rank_inplace_int32(invariant_matrix, prime)
            del invariant_matrix
            assert invariant_rank == equation_count
            module = base.module_at(prime, zeta)
            output = HERE / f"degree_{target}/landing_circuits_p{prime}.npz"
            basis_values = evaluate_fixed_basis(
                records, generators, module, points, prime,
                reuse_path=output,
            )
            complement_indices = primitive["prime_records"][str(prime)][
                "degrees"
            ][str(target)]["fixed_complement_indices"]
            complement_test = []
            for index in complement_indices:
                nonzero_witness = None
                for point_index in range(len(points)):
                    value = klein_value(
                        basis_values[point_index, :, int(index)], prime
                    )
                    if value:
                        nonzero_witness = {
                            "basis_index": int(index),
                            "point_index": point_index,
                            "Klein_value": value,
                        }
                        break
                complement_test.append(nonzero_witness)
            np.savez_compressed(
                output,
                fixed_source_points=(points % prime).astype(np.uint16),
                basis_values=basis_values,
            )
            prime_records.append({
                "prime": prime,
                "zeta11": zeta,
                "invariant_evaluation_rank": invariant_rank,
                "fixed_landing_equation_count": equation_count,
                "basis_dimension": dimension,
                "standard_module_complement_nonlanding_witnesses": complement_test,
                "payload": output.name,
                "payload_sha256": sha256(output),
            })
            print(
                f"landing degree={target} p={prime} invariant_frame={invariant_rank} "
                f"basis={dimension}",
                flush=True,
            )
        circuit_path = HERE / f"degree_{target}/landing_ideal_circuits.json"
        circuit_path.write_text(json.dumps({
            "schema": "cov-m1-complete-factored-landing-ideal-v1",
            "degree": target,
            "parameter_dimension": dimension,
            "source_coefficient_degree": coefficient_degree,
            "invariant_coefficient_dimension": equation_count,
            "fixed_source_points": points.tolist(),
            "fixed_basis": basis_path.name,
            "fixed_basis_sha256": sha256(basis_path),
            "equations": {
                "index_set": f"0 <= j < {equation_count}",
                "linear_forms": (
                    "L_(j,k)(c)=sum_i c_i p_i(x_j), for 0<=k<5, with p_i "
                    "the exact fixed Reynolds/wedge circuit"
                ),
                "factored_cubic": (
                    "E_j(c)=sum_(k=0)^4 L_(j,k)(c)^2 L_(j,k+1 mod 5)(c)"
                ),
                "coefficientwise_completeness": (
                    "F(p) is G-invariant of degree 3d. Evaluation at the fixed "
                    "points is an isomorphism on the full invariant coefficient "
                    "space because the displayed square evaluation determinant "
                    "has nonzero reductions at both holdout primes. Thus all "
                    "coefficients vanish iff every E_j vanishes."
                ),
            },
            "decomposition": {
                "invariant_hironaka_labels": [
                    {
                        "secondary_index": secondary,
                        "secondary_degree": int(base.core.SECONDARY_DEGREES[secondary]),
                        "primary_exponents": list(exponents),
                    }
                    for secondary, exponents in labels
                ],
                "normal_orders": [3, 3 * target],
                "normal_order_note": (
                    "The interval denotes every order 3 through 3d. Since each "
                    "p_i has plane order one, orders below three are identically "
                    "zero; coefficient extraction is routed by Taylor order in "
                    "the same exact evaluation circuit."
                ),
                "character_blocks": (
                    "Target/source characters are inherited from the four dual "
                    "Reynolds factors and the invariant multiplier; no fibrewise "
                    "basis change occurs."
                ),
            },
            "prime_records": prime_records,
            "decision_status": (
                "complete ideal constructed; projective saturation/elimination "
                "not yet decided"
            ),
        }, indent=2, sort_keys=True) + "\n")
        summary["degrees"][str(target)] = {
            "payload": str(circuit_path.relative_to(HERE)),
            "payload_sha256": sha256(circuit_path),
            "parameter_dimension": dimension,
            "equation_count": equation_count,
            "source_coefficient_degree": coefficient_degree,
            "prime_records": prime_records,
            "independent_nodal_crosscheck": [
                {
                    "prime": prime,
                    "metadata": f"degree_{target}/landing_ideal_p{prime}.json",
                    "metadata_sha256": sha256(
                        HERE / f"degree_{target}/landing_ideal_p{prime}.json"
                    ),
                    "payload": f"degree_{target}/landing_nodes_p{prime}.npz",
                    "payload_sha256": sha256(
                        HERE / f"degree_{target}/landing_nodes_p{prime}.npz"
                    ),
                }
                for prime in PRIMES
            ],
        }
    c3_path = HERE / "c3_constant_gate.json"
    if c3_path.is_file():
        summary["linear_elimination"] = {
            "payload": c3_path.name,
            "payload_sha256": sha256(c3_path),
            "scope": (
                "necessary linear consequence of the complete cubic landing "
                "ideal on the C3/C6 orbit; retained in the original K1 "
                "coordinates"
            ),
        }
    reduced_path = HERE / "c3_reduced_landing.json"
    if reduced_path.is_file():
        summary["reduced_special_fibre"] = {
            "prime": 463,
            "payload": reduced_path.name,
            "payload_sha256": sha256(reduced_path),
            "scope": (
                "complete factored landing equations on the C3/C6 gate "
                "kernel, with based and nonbased C3 strata materialized"
            ),
        }
    first_normal_path = HERE / "c3_first_normal_gate.json"
    if first_normal_path.is_file():
        summary["first_normal_pre_elimination"] = {
            "payload": first_normal_path.name,
            "payload_sha256": sha256(first_normal_path),
            "scope": "necessary first-normal gates on the C3-based branch",
        }
    first_reduced_path = HERE / "c3_first_normal_reduced_landing.json"
    if first_reduced_path.is_file():
        summary["first_normal_reduced_special_fibre"] = {
            "prime": 463,
            "payload": first_reduced_path.name,
            "payload_sha256": sha256(first_reduced_path),
            "scope": (
                "complete factored equations on the first-normal gate kernels, "
                "with first-normal nonbased and second-based strata materialized"
            ),
        }
    second_normal_path = HERE / "c3_second_normal_gate.json"
    if second_normal_path.is_file():
        summary["second_normal_pre_elimination"] = {
            "payload": second_normal_path.name,
            "payload_sha256": sha256(second_normal_path),
            "scope": "necessary pure and mixed second-normal C3 branch gates",
        }
    third_based_path = HERE / "c3_third_based_reduced_landing.json"
    if third_based_path.is_file():
        summary["third_based_reduced_special_fibre"] = {
            "prime": 463,
            "payload": third_based_path.name,
            "payload_sha256": sha256(third_based_path),
            "scope": (
                "complete factored equations after the C3 line and its first "
                "and second normal jets vanish"
            ),
        }
    output = HERE / "landing_ideals.json"
    output.write_text(json.dumps(summary, indent=2, sort_keys=True) + "\n")
    print("COV_M1_COMPLETE_LANDING_IDEALS_PRODUCED")


if __name__ == "__main__":
    main()
