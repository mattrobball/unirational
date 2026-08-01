#!/usr/bin/env python3
"""Write the complete landing ideal in a fixed factored nodal basis.

For degree d the scalar F(p) is a G-invariant form of degree 3d.  The exact
Hironaka invariant basis has dimension 5349 (d=31) or 8555 (d=35).  A fixed
set of the same number of integral nodes has an invertible evaluation matrix.
Consequently the values F(p(node)) are an exact coefficient basis for the
complete landing equation.  Each saved equation remains factored as the
Klein cubic in five linear forms on the K1 coefficient vector.
"""

from __future__ import annotations

import argparse
import ctypes
import hashlib
import json
from pathlib import Path
import sys

import numpy as np


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import produce_cross_basis as basis  # noqa: E402


EXPECTED = {31: (198, 5349), 35: (361, 8555)}


def fixed_nodes(count: int) -> np.ndarray:
    state = 202608020093105
    answer = []
    for _ in range(count):
        point = []
        for _ in range(5):
            state = (2862933555777941757 * state + 3037000493) % (1 << 64)
            point.append((state >> 25) % 251)
        answer.append(point)
    return np.asarray(answer, dtype=np.int64)


def determinant_mod(matrix: np.ndarray, prime: int) -> int:
    value = np.asarray(matrix, dtype=np.float64, order="C")
    function = ctypes.CDLL(basis.FFPACK).Det_modular_double
    function.argtypes = [
        ctypes.c_double, ctypes.c_size_t, ctypes.POINTER(ctypes.c_double),
        ctypes.c_size_t, ctypes.c_bool,
    ]
    function.restype = ctypes.c_double
    result = function(
        float(prime), len(value),
        value.ctypes.data_as(ctypes.POINTER(ctypes.c_double)),
        value.shape[1], True,
    )
    return int(round(result)) % prime


def invariant_labels(degree: int):
    answer = []
    for secondary, secondary_degree in enumerate(basis.core.SECONDARY_DEGREES):
        if secondary_degree <= degree:
            for exponents in basis.core.weighted_exponents(degree - secondary_degree):
                answer.append((secondary, tuple(map(int, exponents))))
    return answer


def invariant_label_json(label):
    secondary, exponents = label
    return {
        "secondary_index": int(secondary),
        "secondary_name": basis.core.SECONDARY_NAMES[secondary],
        "secondary_degree": int(basis.core.SECONDARY_DEGREES[secondary]),
        "primary_exponents": list(exponents),
    }


def invariant_evaluation_matrix(nodes: np.ndarray, degree: int, prime: int):
    labels = invariant_labels(degree)
    forms = basis.core.forms()
    primary = np.column_stack([
        basis.evaluate_polynomial(forms[item], nodes, prime)
        for item in basis.core.PRIMARY_DEGREES
    ])
    secondary = np.column_stack([
        basis.evaluate_polynomial(item, nodes, prime)
        for item in basis.core.secondary_polynomials()
    ])
    matrix = np.empty((len(nodes), len(labels)), dtype=np.uint16)
    power_cache = {}
    for column, (secondary_index, exponents) in enumerate(labels):
        value = secondary[:, secondary_index].copy()
        for index, exponent in enumerate(exponents):
            key = index, int(exponent)
            if exponent and key not in power_cache:
                power = np.ones(len(nodes), dtype=np.int64)
                for _ in range(int(exponent)):
                    power = power * primary[:, index] % prime
                power_cache[key] = power
            if exponent:
                value = value * power_cache[key] % prime
        matrix[:, column] = value.astype(np.uint16)
    return labels, matrix


def cross_node_matrix(
    module, prime: int, nodes: np.ndarray, generators, records, chunk=128
):
    output = np.empty((len(nodes) * 5, len(records)), dtype=np.uint16)
    direction_data = []
    for record in records:
        multiplier = record["multiplier"]
        direction_data.append((
            tuple(map(int, record["dual_generator_indices"])),
            int(multiplier["secondary_index"]),
            tuple(map(int, multiplier["primary_exponents"])),
        ))
    primitive_forms = basis.core.forms()
    primary_forms = [primitive_forms[item] for item in basis.core.PRIMARY_DEGREES]
    secondary_forms = basis.core.secondary_polynomials()
    for start in range(0, len(nodes), chunk):
        block = nodes[start:start + chunk]
        evaluator = basis.DualEvaluator(module, block, prime)
        dual_values = basis.evaluate_fixed_dual_generators(evaluator, generators)
        primary = np.column_stack([
            basis.evaluate_polynomial(item, block, prime) for item in primary_forms
        ])
        secondary = np.column_stack([
            basis.evaluate_polynomial(item, block, prime) for item in secondary_forms
        ])
        power_cache = {}
        wedge_cache = {}
        columns = []
        for indices, secondary_index, exponents in direction_data:
            if indices not in wedge_cache:
                wedge_cache[indices] = basis.cross4(dual_values, indices, prime)
            scalar = secondary[:, secondary_index].copy()
            for index, exponent in enumerate(exponents):
                key = index, exponent
                if exponent and key not in power_cache:
                    power = np.ones(len(block), dtype=np.int64)
                    for _ in range(exponent):
                        power = power * primary[:, index] % prime
                    power_cache[key] = power
                if exponent:
                    scalar = scalar * power_cache[key] % prime
            columns.append(wedge_cache[indices] * scalar[:, None] % prime)
        values = np.asarray(columns).transpose(1, 2, 0).reshape(
            len(block) * 5, len(records)
        )
        row_start = start * 5
        output[row_start:row_start + len(block) * 5] = values.astype(np.uint16)
        if start and start % (chunk * 10) == 0:
            print(
                f"landing-nodes p={prime} rows={start}/{len(nodes)}",
                flush=True,
            )
    return output


def sha256_array(array: np.ndarray) -> str:
    return hashlib.sha256(np.ascontiguousarray(array).tobytes()).hexdigest()


def produce(degree: int, prime: int) -> None:
    dimension, invariant_dimension = EXPECTED[degree]
    zeta = basis.PRIMES[prime]
    directory = HERE / f"degree_{degree}"
    selection_path = directory / f"landing_node_selection_p{prime}.json"
    candidate_count = invariant_dimension + (256 if degree == 35 else 0)
    candidates = fixed_nodes(candidate_count)
    existing_payload = directory / f"landing_nodes_p{prime}.npz"
    if not selection_path.exists() and existing_payload.exists():
        with np.load(existing_payload) as frozen:
            old_nodes = np.asarray(frozen["nodes"], dtype=np.int64) % prime
        lookup = {
            tuple(map(int, row % prime)): index
            for index, row in enumerate(candidates)
        }
        selected_rows = np.asarray(
            [lookup[tuple(map(int, row))] for row in old_nodes], dtype=np.int64
        )
        assert len(selected_rows) == invariant_dimension
        selection_path.write_text(json.dumps({
            "schema": "cov-m1-fixed-landing-node-selection-v1",
            "degree": degree,
            "candidate_count": candidate_count,
            "node_rule": "fixed_nodes from produce_landing_ideal.py",
            "selection_prime": prime,
            "selected_candidate_rows": selected_rows.tolist(),
            "note": "reconstructed from the self-contained accepted node payload",
        }, indent=2, sort_keys=True) + "\n")
    if selection_path.exists():
        selection = json.loads(selection_path.read_text())
        assert selection["candidate_count"] == candidate_count
        selected_rows = np.asarray(selection["selected_candidate_rows"], dtype=np.int64)
        nodes = candidates[selected_rows] % prime
        labels, invariant_matrix = invariant_evaluation_matrix(
            nodes, 3 * degree, prime
        )
    else:
        candidate_nodes = candidates % prime
        labels, candidate_matrix = invariant_evaluation_matrix(
            candidate_nodes, 3 * degree, prime
        )
        selected_rows = basis.rank_profile(candidate_matrix, prime)
        assert len(selected_rows) == invariant_dimension
        selected_rows = selected_rows[:invariant_dimension]
        nodes = candidate_nodes[selected_rows]
        invariant_matrix = candidate_matrix[selected_rows]
        selection_path.write_text(json.dumps({
            "schema": "cov-m1-fixed-landing-node-selection-v1",
            "degree": degree,
            "candidate_count": candidate_count,
            "node_rule": "fixed_nodes from produce_landing_ideal.py",
            "selection_prime": prime,
            "selected_candidate_rows": selected_rows.tolist(),
        }, indent=2, sort_keys=True) + "\n")
        del candidate_matrix
    assert len(labels) == invariant_dimension
    matrix_hash = sha256_array(invariant_matrix)
    determinant = determinant_mod(invariant_matrix, prime)
    if not determinant and selection_path.exists() and candidate_count > invariant_dimension:
        # The previous prime's selected matroid basis can drop rank at a
        # holdout. Reselect from the same fixed integral oversample, then send
        # this exact row set back through the earlier prime.
        candidate_nodes = candidates % prime
        labels, candidate_matrix = invariant_evaluation_matrix(
            candidate_nodes, 3 * degree, prime
        )
        selected_rows = basis.rank_profile(candidate_matrix, prime)
        assert len(selected_rows) == invariant_dimension
        selected_rows = selected_rows[:invariant_dimension]
        nodes = candidate_nodes[selected_rows]
        invariant_matrix = candidate_matrix[selected_rows]
        matrix_hash = sha256_array(invariant_matrix)
        determinant = determinant_mod(invariant_matrix, prime)
        assert determinant
        selection_path.write_text(json.dumps({
            "schema": "cov-m1-fixed-landing-node-selection-v1",
            "degree": degree,
            "candidate_count": candidate_count,
            "node_rule": "fixed_nodes from produce_landing_ideal.py",
            "selection_prime": prime,
            "selected_candidate_rows": selected_rows.tolist(),
            "note": "holdout reselection; must be replayed at every listed prime",
        }, indent=2, sort_keys=True) + "\n")
        del candidate_matrix
    assert determinant
    del invariant_matrix
    print(
        f"degree={degree} p={prime} invariant_nodes={invariant_dimension} "
        f"det={determinant}",
        flush=True,
    )

    generators = json.loads((HERE / "dual_hironaka_generators.json").read_text())[
        "generators"
    ]
    records = json.loads(
        (HERE / f"degree_{degree}" / "m1_cross_basis_circuits.json").read_text()
    )["basis"]
    assert len(records) == dimension
    module = basis.module_at(prime, zeta)
    linear_forms = cross_node_matrix(
        module, prime, nodes, generators, records
    )
    assert linear_forms.shape == (5 * invariant_dimension, dimension)
    assert basis.rank_mod(linear_forms, prime) == dimension

    payload = directory / f"landing_nodes_p{prime}.npz"
    np.savez_compressed(
        payload,
        nodes=nodes.astype(np.uint16),
        linear_forms=linear_forms.astype(np.uint16),
    )
    metadata = {
        "schema": "cov-m1-complete-factored-landing-nodes-v1",
        "degree": degree,
        "parameter_dimension": dimension,
        "source_invariant_degree": 3 * degree,
        "equation_count": invariant_dimension,
        "prime": prime,
        "zeta11": zeta,
        "node_rule": "fixed_nodes from produce_landing_ideal.py",
        "invariant_hironaka_basis": [invariant_label_json(label) for label in labels],
        "invariant_evaluation_matrix_sha256_uint16_row_major": matrix_hash,
        "invariant_evaluation_determinant_residue": determinant,
        "linear_form_matrix_shape": list(linear_forms.shape),
        "linear_form_matrix_rank": dimension,
        "equation_rule": (
            "For node r and parameter a, let ell_i(r,a) be row (5r+i) of "
            "linear_forms times a. The equation is sum_(i mod 5) "
            "ell_i(r,a)^2 ell_(i+1)(r,a)=0."
        ),
        "completeness_proof": (
            "F(p_a) is an invariant form of degree 3d. The displayed exact "
            "Hironaka basis has the same size as the node set, and the saved "
            "evaluation determinant is nonzero. Hence all nodal cubics vanish "
            "iff every coefficient of F(p_a) vanishes."
        ),
        "payload": payload.name,
        "payload_sha256": basis.sha256(payload),
    }
    path = directory / f"landing_ideal_p{prime}.json"
    path.write_text(json.dumps(metadata, indent=2, sort_keys=True) + "\n")
    print(
        f"COV_M1_LANDING_IDEAL degree={degree} p={prime} "
        f"payload={payload.name}",
        flush=True,
    )


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--degree", type=int, choices=sorted(EXPECTED), required=True)
    parser.add_argument("--prime", type=int, choices=sorted(basis.PRIMES), required=True)
    args = parser.parse_args()
    produce(args.degree, args.prime)


if __name__ == "__main__":
    main()
