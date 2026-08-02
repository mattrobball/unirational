#!/usr/bin/env python3
"""Fast exact F_529 matroid/SAT replay for the cached degree-nine clauses."""
from __future__ import annotations

import json
from pathlib import Path
import time

import numpy as np

import degree9_full_landing as landing
import degree9_binary_factor_sat as binary
import eigenline_rank_one_probe as field


HERE = Path(__file__).resolve().parent
CACHE = HERE / "degree9_binary_clauses_f529.json"
OUTPUT = HERE / "degree9_fast_linear_sat_f529.json"
P = 23
Q = P * P


def encode(pair):
    return int(pair[0]) % P + P * (int(pair[1]) % P)


def decode(value):
    return (int(value) % P, int(value) // P)


ADD = [[0] * Q for _ in range(Q)]
MUL = [[0] * Q for _ in range(Q)]
NEG = [0] * Q
INV = [0] * Q
for left in range(Q):
    a, b = decode(left)
    NEG[left] = encode((-a, -b))
    if left:
        INV[left] = encode(field.inverse((a, b)))
    for right in range(Q):
        c, d = decode(right)
        ADD[left][right] = encode((a + c, b + d))
        MUL[left][right] = encode((a * c + 5 * b * d, a * d + b * c))


def dot(left, right):
    answer = 0
    for a, b in zip(left, right):
        answer = ADD[answer][MUL[a][b]]
    return answer


def pivot(row):
    return next(index for index, value in enumerate(row) if value)


def normalize(row):
    scale = INV[next(value for value in row if value)]
    return tuple(MUL[scale][value] for value in row)


def reduce_row(row, state):
    vector = list(row)
    for old in state:
        column = pivot(old)
        coefficient = vector[column]
        if coefficient:
            scale = NEG[coefficient]
            for index in range(column, len(vector)):
                vector[index] = ADD[vector[index]][MUL[scale][old[index]]]
    return tuple(vector)


def extend(state, row):
    vector = reduce_row(row, state)
    if not any(vector):
        return state
    vector = normalize(vector)
    column = pivot(vector)
    answer = []
    for old in state:
        coefficient = old[column]
        if not coefficient:
            answer.append(old)
            continue
        scale = NEG[coefficient]
        answer.append(tuple(
            ADD[value][MUL[scale][new]] for value, new in zip(old, vector)
        ))
    answer.append(vector)
    answer.sort(key=pivot)
    return tuple(answer)


def in_span(row, state):
    return not any(reduce_row(row, state))


def kernel(state, dimension):
    pivots = [pivot(row) for row in state]
    free = [index for index in range(dimension) if index not in pivots]
    basis = []
    for column in free:
        vector = [0] * dimension
        vector[column] = 1
        for row, row_pivot in zip(state, pivots):
            vector[row_pivot] = NEG[row[column]]
        basis.append(tuple(vector))
    return basis, free


def quotient_data(raw):
    mandatory_pairs = tuple(
        tuple(tuple(entry) for entry in form) for form in raw["mandatory_forms"]
    )
    ambient_kernel_pairs = field.kernel(np.asarray(mandatory_pairs, dtype=np.int64))
    assert len(ambient_kernel_pairs) == 11
    ambient_kernel = [tuple(encode(value) for value in vector)
                      for vector in ambient_kernel_pairs]
    clauses = []
    seen = set()
    satisfied = 0
    for raw_clause in raw["clauses"]:
        factors = []
        clause_satisfied = False
        for raw_factor in raw_clause:
            factor = tuple(encode(value) for value in raw_factor)
            residual = tuple(dot(factor, vector) for vector in ambient_kernel)
            if not any(residual):
                clause_satisfied = True
                break
            residual = normalize(residual)
            if residual not in factors:
                factors.append(residual)
        if clause_satisfied:
            satisfied += 1
            continue
        clause = tuple(sorted(factors))
        if clause not in seen:
            seen.add(clause)
            clauses.append(clause)
    return mandatory_pairs, ambient_kernel_pairs, ambient_kernel, clauses, satisfied


def restricted_outputs(kernel_vectors, mandatory_outputs):
    answer = []
    for vector in kernel_vectors:
        output = []
        for coordinate in range(6):
            output.append(dot(vector, [row[coordinate] for row in mandatory_outputs]))
        answer.append(output)
    return answer


def lift_factor(factor, free, dimension=11):
    answer = [0] * dimension
    for column, value in zip(free, factor):
        answer[column] = value
    return normalize(answer)


def conditional_clause(state, evaluations, quartic):
    kernel_vectors, free = kernel(state, 11)
    residual_dimension = len(kernel_vectors)
    assert residual_dimension in (1, 2)
    for point_index, mandatory_outputs in enumerate(evaluations):
        encoded_outputs = restricted_outputs(kernel_vectors, mandatory_outputs)
        outputs = np.asarray(
            [[[decode(value)[0], decode(value)[1]] for value in row]
             for row in encoded_outputs],
            dtype=np.int64,
        )
        if residual_dimension == 1:
            value = landing.gf529_quartic_value(quartic, outputs[0])
            if np.any(value):
                return (lift_factor((1,), free),), point_index, value.tolist()
            continue
        if binary.output_rank(outputs) < 2:
            continue
        u, v, c_form, d_form = binary.image_coordinates(outputs)
        coefficients = binary.binary_quartic(quartic, u, v)
        factors = binary.split_factors(coefficients, c_form, d_form)
        if factors is None:
            continue
        encoded_factors = []
        for factor in factors:
            residual = tuple(encode(value) for value in factor)
            encoded_factors.append(lift_factor(residual, free))
        return tuple(encoded_factors), point_index, [list(value) for value in coefficients]
    return None, None, None


def solve(clauses, evaluations, quartic, node_limit=5_000_000):
    nodes = 0
    closed_leaves = 0
    memo = set()
    adaptive = {}
    open_witness = None

    def close(state):
        nonlocal nodes, closed_leaves, open_witness
        nodes += 1
        if nodes > node_limit:
            return "limit"
        if len(state) == 11:
            closed_leaves += 1
            return "closed"
        if state in memo:
            return "closed"
        if 11 - len(state) > 2:
            open_witness = {"rank": len(state), "reason": "residual dimension >2"}
            return "open"
        clause, point_index, data = conditional_clause(state, evaluations, quartic)
        if clause is None:
            open_witness = {"rank": len(state), "reason": "no split conditional equation"}
            return "open"
        adaptive[str(hash(state))] = {
            "input_rank_in_11_space": len(state),
            "point_index": point_index,
            "factor_count": len(clause),
            "factorization_data": data,
        }
        extensions = {extend(state, factor) for factor in clause}
        for extension in extensions:
            result = close(extension)
            if result != "closed":
                return result
        memo.add(state)
        return "closed"

    def visit(state, remaining):
        nonlocal nodes, closed_leaves, open_witness
        nodes += 1
        if nodes > node_limit:
            return "limit"
        if len(state) == 11:
            closed_leaves += 1
            return "closed"
        unsatisfied = []
        for clause_index in remaining:
            if any(in_span(factor, state) for factor in clauses[clause_index]):
                continue
            unsatisfied.append(clause_index)
        if not unsatisfied:
            return close(state)
        key = (state, tuple(unsatisfied))
        if key in memo:
            return "closed"
        selected = unsatisfied[0]
        next_remaining = tuple(index for index in unsatisfied if index != selected)
        extensions = {extend(state, factor) for factor in clauses[selected]}
        for extension in extensions:
            result = visit(extension, next_remaining)
            if result != "closed":
                return result
        memo.add(key)
        return "closed"

    status = visit(tuple(), tuple(range(len(clauses))))
    return {
        "status": status, "nodes": nodes, "closed_leaves": closed_leaves,
        "memoized_closed_states": len(memo), "node_limit": node_limit,
        "adaptive_state_count": len(adaptive),
        "adaptive_records": adaptive, "open_witness": open_witness,
    }


def main():
    started = time.monotonic()
    raw = json.loads(CACHE.read_text())
    mandatory_pairs, ambient_kernel_pairs, ambient_kernel, clauses, satisfied = quotient_data(raw)
    probe = landing.probe_core.Probe()
    basis = probe.basis(9, 19)
    quartic, _ = landing.pencil_core.reconstruct()
    rng = np.random.default_rng(2026080149)
    points = [rng.integers(0, P, 6, dtype=np.int64) for _ in range(48)]
    evaluations = []
    for point in points:
        ambient = landing.fast_seed_values(probe, basis, point)
        mandatory_outputs = []
        for vector in ambient_kernel:
            output = []
            for coordinate in range(6):
                raw_column = [encode((int(value), 0)) for value in ambient[:, coordinate]]
                output.append(dot(vector, raw_column))
            mandatory_outputs.append(output)
        evaluations.append(mandatory_outputs)
    sat = solve(clauses, evaluations, quartic)
    payload = {
        "field": "F_23[u]/(u^2-5)",
        "ambient_dimension": 19,
        "mandatory_rank": 8,
        "quotient_dimension": 11,
        "cached_clause_count": len(raw["clauses"]),
        "clauses_satisfied_by_mandatory_forms": satisfied,
        "unique_quotient_clauses": len(clauses),
        "adaptive_evaluation_rng_seed": 2026080149,
        "adaptive_evaluation_points": [point.tolist() for point in points],
        "sat": sat,
        "projective_emptiness_over_algebraic_closure": sat["status"] == "closed",
        "elapsed_seconds": time.monotonic() - started,
    }
    OUTPUT.write_text(json.dumps(payload, indent=2) + "\n")
    print(
        f"quotientClauses={len(clauses)} satisfied={satisfied} "
        f"status={sat['status']} nodes={sat['nodes']} "
        f"adaptive={sat['adaptive_state_count']} elapsed={payload['elapsed_seconds']:.3f}"
    )
    if payload["projective_emptiness_over_algebraic_closure"]:
        print("FULL_DEGREE9_PROJECTIVE_EMPTINESS_FAST_LINEAR_SAT_OK")
    else:
        print("SCOPE exact F_529 quotient linear SAT; no projective verdict")


if __name__ == "__main__":
    main()
