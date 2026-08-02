#!/usr/bin/env python3
"""Factor rank-two eigenvector landing equations and run an exact linear SAT tree.

Each split binary restriction has the form product_j L_j(a)=0.  A landing
point must therefore choose at least one coefficient hyperplane from every
clause.  Starting with the six mandatory rank-one forms, the exact search
branches on those choices.  If every branch reaches linear rank 19, the full
degree-nine projective landing locus is empty over the algebraic closure.
"""
from __future__ import annotations

import json
from pathlib import Path

import numpy as np

import degree9_full_landing as landing
import eigenline_rank_one_probe as field


HERE = Path(__file__).resolve().parent
INPUT = HERE / "degree9_rank_one_eigenlines_f529.json"
OUTPUT = HERE / "degree9_binary_factor_sat_f529.json"
P = 23
DIMENSION = 19


def sub(left, right):
    return field.add(left, field.neg(right))


def scalar_mul(value, vector):
    return [field.mul(value, entry) for entry in vector]


def vector_add(left, right):
    return [field.add(a, b) for a, b in zip(left, right)]


def normalize(vector):
    pivot = next(entry for entry in vector if not field.is_zero(entry))
    scale = field.inverse(pivot)
    return tuple(field.mul(scale, entry) for entry in vector)


def rref(vectors):
    rows = [list(vector) for vector in vectors]
    pivot_row = 0
    for column in range(DIMENSION):
        selected = next(
            (index for index in range(pivot_row, len(rows))
             if not field.is_zero(rows[index][column])),
            None,
        )
        if selected is None:
            continue
        rows[pivot_row], rows[selected] = rows[selected], rows[pivot_row]
        scale = field.inverse(rows[pivot_row][column])
        rows[pivot_row] = scalar_mul(scale, rows[pivot_row])
        for index in range(len(rows)):
            if index == pivot_row or field.is_zero(rows[index][column]):
                continue
            rows[index] = vector_add(
                rows[index],
                scalar_mul(field.neg(rows[index][column]), rows[pivot_row]),
            )
        pivot_row += 1
        if pivot_row == len(rows):
            break
    nonzero = [tuple(row) for row in rows if any(not field.is_zero(x) for x in row)]
    return tuple(nonzero)


def in_span(form, state):
    return not any(not field.is_zero(value) for value in reduce_form(form, state))


def reduce_form(form, state):
    vector = list(form)
    for row in state:
        pivot = next(index for index, value in enumerate(row)
                     if not field.is_zero(value))
        coefficient = vector[pivot]
        if not field.is_zero(coefficient):
            vector = vector_add(
                vector, scalar_mul(field.neg(coefficient), row)
            )
    return tuple(vector)


def extend_state(state, form):
    vector = reduce_form(form, state)
    if not any(not field.is_zero(value) for value in vector):
        return state
    pivot = next(index for index, value in enumerate(vector)
                 if not field.is_zero(value))
    vector = tuple(scalar_mul(field.inverse(vector[pivot]), vector))
    rows = []
    for row in state:
        coefficient = row[pivot]
        if field.is_zero(coefficient):
            rows.append(row)
        else:
            rows.append(tuple(vector_add(
                row, scalar_mul(field.neg(coefficient), vector)
            )))
    rows.append(vector)
    rows.sort(key=lambda row: next(index for index, value in enumerate(row)
                                   if not field.is_zero(value)))
    return tuple(rows)


def output_rank(outputs):
    return field.rank(outputs.transpose(1, 0, 2))


def image_coordinates(outputs):
    vectors = [
        [tuple(int(x) for x in entry) for entry in output]
        for output in outputs
    ]
    first = next(index for index, vector in enumerate(vectors)
                 if any(not field.is_zero(x) for x in vector))
    second = next(
        index for index, vector in enumerate(vectors)
        if field.rank(np.asarray([vectors[first], vector], dtype=np.int64)) == 2
    )
    u, v = vectors[first], vectors[second]
    coordinate_pair = next(
        (i, j)
        for i in range(6) for j in range(i + 1, 6)
        if not field.is_zero(sub(field.mul(u[i], v[j]), field.mul(u[j], v[i])))
    )
    i, j = coordinate_pair
    determinant_inverse = field.inverse(
        sub(field.mul(u[i], v[j]), field.mul(u[j], v[i]))
    )
    c_form = []
    d_form = []
    for vector in vectors:
        c = field.mul(
            sub(field.mul(vector[i], v[j]), field.mul(vector[j], v[i])),
            determinant_inverse,
        )
        d = field.mul(
            sub(field.mul(u[i], vector[j]), field.mul(u[j], vector[i])),
            determinant_inverse,
        )
        assert all(
            field.add(field.mul(c, left), field.mul(d, right)) == target
            for left, right, target in zip(u, v, vector)
        )
        c_form.append(c)
        d_form.append(d)
    return u, v, c_form, d_form


def polynomial_multiply(left, right):
    answer = [(0, 0)] * (len(left) + len(right) - 1)
    for i, a in enumerate(left):
        for j, b in enumerate(right):
            answer[i + j] = field.add(answer[i + j], field.mul(a, b))
    return answer


def binary_quartic(quartic, u, v):
    answer = [(0, 0)] * 5
    for alpha, coefficient in quartic.items():
        term = [(1, 0)]
        for coordinate, exponent in enumerate(alpha):
            for _ in range(exponent):
                term = polynomial_multiply(term, [u[coordinate], v[coordinate]])
        assert len(term) == 5
        for index, value in enumerate(term):
            answer[index] = field.add(
                answer[index], field.mul((coefficient, 0), value)
            )
    return answer


def evaluate_polynomial(coefficients, value):
    answer = (0, 0)
    for coefficient in coefficients:
        answer = field.add(field.mul(answer, value), coefficient)
    return answer


def divide_linear(coefficients, root):
    quotient = [coefficients[0]]
    for coefficient in coefficients[1:-1]:
        quotient.append(field.add(coefficient, field.mul(root, quotient[-1])))
    remainder = field.add(coefficients[-1], field.mul(root, quotient[-1]))
    assert field.is_zero(remainder)
    return quotient


def split_factors(coefficients, c_form, d_form):
    # coefficients[k] multiplies s^(4-k)t^k.
    working = list(coefficients)
    factors = []
    while len(working) > 1 and field.is_zero(working[0]):
        # Degree loss of F(s,1) is a factor t, hence D(a).
        factors.append(normalize(d_form))
        working.pop(0)
    elements = [(a, b) for a in range(P) for b in range(P)]
    for root in elements:
        while len(working) > 1 and field.is_zero(evaluate_polynomial(working, root)):
            # Factor s-root*t, hence C(a)-root*D(a).
            form = [
                sub(c, field.mul(root, d))
                for c, d in zip(c_form, d_form)
            ]
            factors.append(normalize(form))
            working = divide_linear(working, root)
    if len(working) != 1 or field.is_zero(working[0]):
        return None
    assert len(factors) == 4
    # Repetitions do not create distinct SAT branches.
    return tuple(dict.fromkeys(factors))


def canonical_clause(factors):
    return tuple(sorted(factors))


def exact_sat(initial, clauses, node_limit=2_000_000):
    nodes = 0
    closed = 0
    memo = set()
    open_witness = None

    def visit(state, remaining):
        nonlocal nodes, closed, open_witness
        nodes += 1
        if nodes > node_limit:
            return "limit"
        if len(state) == DIMENSION:
            closed += 1
            return "closed"
        unsatisfied = []
        for clause_index in remaining:
            clause = clauses[clause_index]
            if any(in_span(factor, state) for factor in clause):
                continue
            unsatisfied.append(clause_index)
        if not unsatisfied:
            open_witness = {
                "linear_rank": len(state),
                "residual_dimension": DIMENSION - len(state),
                "rref": [[[a, b] for a, b in row] for row in state],
            }
            return "open"
        key = (state, tuple(unsatisfied))
        if key in memo:
            return "closed"
        # Branch first on the clause with the fewest distinct row-space
        # extensions after reduction.
        choices = []
        for clause_index in unsatisfied:
            extensions = {}
            for factor in clauses[clause_index]:
                new_state = extend_state(state, factor)
                extensions[new_state] = factor
            choices.append((len(extensions), clause_index, tuple(extensions)))
        _, selected, extensions = min(choices, key=lambda item: (item[0], item[1]))
        next_remaining = tuple(index for index in unsatisfied if index != selected)
        for new_state in extensions:
            result = visit(new_state, next_remaining)
            if result != "closed":
                return result
        memo.add(key)
        return "closed"

    status = visit(rref(initial), tuple(range(len(clauses))))
    return {
        "status": status,
        "nodes": nodes,
        "closed_leaves": closed,
        "memoized_closed_states": len(memo),
        "node_limit": node_limit,
        "open_witness": open_witness,
    }


def main():
    payload = json.loads(INPUT.read_text())
    probe = landing.probe_core.Probe()
    basis = probe.basis(9, 19)
    quartic, _ = landing.pencil_core.reconstruct()
    initial = []
    seen_initial = set()
    rank_two_records = []
    clauses = []
    seen_clauses = set()
    for record in payload["records"]:
        raw_form = record.get("normalized_coefficient_form")
        if raw_form is not None and record.get("nonzero_fourth_power_equation"):
            form = normalize(
                [tuple(int(x) for x in entry) for entry in raw_form]
            )
            if form not in seen_initial:
                seen_initial.add(form)
                initial.append(form)
        if record["evaluation_rank"] != 2:
            continue
        point = np.asarray(record["eigenvector"], dtype=np.int64)
        outputs = landing.extension_seed_values(probe, basis, point)
        assert output_rank(outputs) == 2
        u, v, c_form, d_form = image_coordinates(outputs)
        coefficients = binary_quartic(quartic, u, v)
        factors = split_factors(coefficients, c_form, d_form)
        item = {
            "group_type": record["group_type"],
            "eigenvalue": record["eigenvalue"],
            "eigenvector": record["eigenvector"],
            "binary_coefficients": [list(value) for value in coefficients],
            "split_over_F529": factors is not None,
            "distinct_linear_factors": 0 if factors is None else len(factors),
        }
        if factors is not None:
            clause = canonical_clause(factors)
            item["linear_factors"] = [
                [[a, b] for a, b in factor] for factor in clause
            ]
            if clause not in seen_clauses:
                seen_clauses.add(clause)
                clauses.append(clause)
        rank_two_records.append(item)
    initial_state = rref(tuple(initial))
    assert len(initial_state) == 6
    sat = exact_sat(initial_state, clauses)
    result = {
        "field": "F_23[u]/(u^2-5)",
        "initial_fourth_power_form_rank": len(initial_state),
        "rank_two_record_count": len(rank_two_records),
        "split_rank_two_record_count": sum(
            record["split_over_F529"] for record in rank_two_records
        ),
        "unique_split_clauses": len(clauses),
        "clause_size_tally": dict(
            sorted(__import__("collections").Counter(map(len, clauses)).items())
        ),
        "sat": sat,
        "projective_emptiness": sat["status"] == "closed",
        "rank_two_records": rank_two_records,
    }
    OUTPUT.write_text(json.dumps(result, indent=2) + "\n")
    print(
        f"initialRank={len(initial_state)} rankTwoRecords={len(rank_two_records)} "
        f"split={result['split_rank_two_record_count']} "
        f"uniqueClauses={len(clauses)} satStatus={sat['status']} "
        f"nodes={sat['nodes']}"
    )
    if result["projective_emptiness"]:
        print("FULL_DEGREE9_PROJECTIVE_EMPTINESS_LINEAR_SAT_OK")
    else:
        print("SCOPE exact split-binary linear SAT; no projective-emptiness verdict")


if __name__ == "__main__":
    main()
