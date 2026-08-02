#!/usr/bin/env python3
"""Exhaust all F_529-lines in the order-3/order-6 two-eigenspaces.

This strengthens ``degree9_binary_factor_sat.py`` from three test lines per
two-dimensional eigenspace to every one of its 530 projective F_529-lines.
Every split rank-two landing equation becomes a four-way linear clause.  The
final exact SAT/rank tree is decisive only if all branches reach rank 19.
"""
from __future__ import annotations

from collections import Counter, defaultdict
import json
import os
from pathlib import Path
import time

import numpy as np

import degree9_full_landing as landing
import eigenline_rank_one_probe as field
import degree9_binary_factor_sat as binary


HERE = Path(__file__).resolve().parent
INPUT = HERE / "degree9_rank_one_eigenlines_f529.json"
OUTPUT = HERE / "degree9_binary_factor_sat_exhaustive_f529.json"
CACHE = HERE / "degree9_binary_clauses_f529.json"
P = 23


def vector_add_scaled(left, scalar, right):
    return [field.add(a, field.mul(scalar, b)) for a, b in zip(left, right)]


def rank_one_form(outputs, quartic):
    nonzero = np.argwhere(np.any(outputs != 0, axis=2))
    assert len(nonzero)
    coordinate = int(nonzero[0, 1])
    raw = [tuple(int(x) for x in entry) for entry in outputs[:, coordinate]]
    form = binary.normalize(raw)
    pivot_index = next(index for index, entry in enumerate(raw)
                       if not field.is_zero(entry))
    scale = field.inverse(raw[pivot_index])
    direction = [
        field.mul(scale, tuple(int(x) for x in entry))
        for entry in outputs[pivot_index]
    ]
    value = landing.gf529_quartic_value(quartic, np.asarray(direction))
    return form if np.any(value) else None


def recover_eigenspaces(payload):
    grouped = defaultdict(dict)
    for record in payload["records"]:
        group_type = record["group_type"]
        if group_type["order"] not in (3, 6):
            continue
        if record["source_eigenspace_dimension"] != 2:
            continue
        key = (
            group_type["order"], group_type["trace"],
            tuple(record["eigenvalue"]),
        )
        if record["test_vector_index"] in (0, 1):
            grouped[key][record["test_vector_index"]] = record["eigenvector"]
    assert len(grouped) == 6 and all(set(values) == {0, 1} for values in grouped.values())
    return [
        {
            "group_type": {"order": key[0], "trace": key[1]},
            "eigenvalue": list(key[2]),
            "basis": [values[0], values[1]],
        }
        for key, values in sorted(grouped.items())
    ]


def initial_forms(payload):
    forms = []
    seen = set()
    for record in payload["records"]:
        raw = record.get("normalized_coefficient_form")
        if raw is None or not record.get("nonzero_fourth_power_equation"):
            continue
        form = binary.normalize([tuple(int(x) for x in entry) for entry in raw])
        if form not in seen:
            seen.add(form)
            forms.append(form)
    assert len(binary.rref(tuple(forms))) == 6
    return forms


def conjugacy_checks(probe):
    checks = []
    for order in (3, 6):
        representative = next(
            matrix for matrix in probe.group
            if field.element_order(matrix) == order and int(np.trace(matrix) % P) == 0
        )
        conjugates = {
            bytes((g @ representative @ inverse % P).astype(np.uint8).flat)
            for g, inverse in zip(probe.group, probe.inverse)
        }
        typed = {
            bytes(matrix.astype(np.uint8).flat)
            for matrix in probe.group
            if field.element_order(matrix) == order and int(np.trace(matrix) % P) == 0
        }
        assert conjugates == typed and len(conjugates) == 110
        checks.append(
            {"order": order, "trace": 0, "conjugacy_class_size": 110,
             "covers_complete_type": True}
        )
    return checks


def free_columns(state):
    pivots = []
    for row in state:
        pivots.append(next(index for index, value in enumerate(row)
                           if not field.is_zero(value)))
    return [index for index in range(19) if index not in pivots]


def restricted_outputs(kernel, ambient_outputs):
    answer = []
    for vector in kernel:
        output = []
        for coordinate in range(6):
            value = (0, 0)
            for coefficient, raw in zip(vector, ambient_outputs[:, coordinate]):
                value = field.add(
                    value, field.mul(coefficient, (int(raw), 0))
                )
            output.append(value)
        answer.append(output)
    return np.asarray(answer, dtype=np.int64)


def lift_form(residual_form, state):
    free = free_columns(state)
    assert len(free) == len(residual_form)
    answer = [(0, 0)] * 19
    for column, value in zip(free, residual_form):
        answer[column] = value
    return binary.normalize(answer)


def adaptive_sat(initial, clauses, ambient_evaluations, quartic,
                 node_limit=5_000_000):
    """Close rank-17 leaves by split binary restrictions at general points."""
    nodes = 0
    closed = 0
    memo = set()
    adaptive_records = []
    adaptive_record_keys = set()
    open_witness = None

    def conditional_clause(state):
        kernel = field.kernel(np.asarray(state, dtype=np.int64))
        residual_dimension = len(kernel)
        assert residual_dimension in (1, 2)
        for point_index, ambient_outputs in enumerate(ambient_evaluations):
            outputs = restricted_outputs(kernel, ambient_outputs)
            if residual_dimension == 1:
                value = landing.gf529_quartic_value(quartic, outputs[0])
                if not np.any(value):
                    continue
                factor = lift_form(((1, 0),), state)
                clause = (factor,)
                key = (state, point_index, clause)
                if key not in adaptive_record_keys:
                    adaptive_record_keys.add(key)
                    adaptive_records.append(
                        {"input_rank": len(state), "point_index": point_index,
                         "residual_dimension": 1, "factor_count": 1,
                         "I4_value": value.tolist()}
                    )
                return clause
            if binary.output_rank(outputs) < 2:
                continue
            u, v, c_form, d_form = binary.image_coordinates(outputs)
            coefficients = binary.binary_quartic(quartic, u, v)
            factors = binary.split_factors(coefficients, c_form, d_form)
            if factors is None:
                continue
            clause = tuple(lift_form(factor, state) for factor in factors)
            key = (state, point_index, clause)
            if key not in adaptive_record_keys:
                adaptive_record_keys.add(key)
                adaptive_records.append(
                    {"input_rank": len(state), "point_index": point_index,
                     "residual_dimension": 2, "factor_count": len(clause),
                     "binary_coefficients": [list(value) for value in coefficients]}
                )
            return clause
        return None

    def close_residual(state):
        nonlocal nodes, closed, open_witness
        nodes += 1
        if nodes > node_limit:
            return "limit"
        if len(state) == 19:
            closed += 1
            return "closed"
        if state in memo:
            return "closed"
        residual_dimension = 19 - len(state)
        if residual_dimension > 2:
            open_witness = {"rank": len(state), "reason": "residual dimension > 2"}
            return "open"
        clause = conditional_clause(state)
        if clause is None:
            open_witness = {
                "rank": len(state),
                "reason": "no split/nonzero conditional equation in evaluation bank",
            }
            return "open"
        extensions = {binary.extend_state(state, factor) for factor in clause}
        for new_state in extensions:
            result = close_residual(new_state)
            if result != "closed":
                return result
        memo.add(state)
        return "closed"

    def visit(state, remaining):
        nonlocal nodes, closed, open_witness
        nodes += 1
        if nodes > node_limit:
            return "limit"
        if len(state) == 19:
            closed += 1
            return "closed"
        unsatisfied = []
        for clause_index in remaining:
            if any(binary.in_span(factor, state) for factor in clauses[clause_index]):
                continue
            unsatisfied.append(clause_index)
        if not unsatisfied:
            return close_residual(state)
        key = (state, tuple(unsatisfied))
        if key in memo:
            return "closed"
        # Prefer the clause whose four branches collectively satisfy the most
        # other currently-unsatisfied clauses.
        best = None
        for clause_index in unsatisfied[:8]:
            extensions = {binary.extend_state(state, factor) for factor in clauses[clause_index]}
            score = 0
            for extension in extensions:
                score += sum(
                    any(binary.in_span(factor, extension) for factor in clauses[other])
                    for other in unsatisfied[:64] if other != clause_index
                )
            candidate = (-score, len(extensions), clause_index, tuple(extensions))
            if best is None or candidate[:3] < best[:3]:
                best = candidate
        assert best is not None
        selected = best[2]
        next_remaining = tuple(index for index in unsatisfied if index != selected)
        for new_state in best[3]:
            result = visit(new_state, next_remaining)
            if result != "closed":
                return result
        memo.add(key)
        return "closed"

    status = visit(binary.rref(initial), tuple(range(len(clauses))))
    return {
        "status": status,
        "nodes": nodes,
        "closed_leaves": closed,
        "memoized_closed_states": len(memo),
        "node_limit": node_limit,
        "adaptive_record_count": len(adaptive_records),
        "adaptive_records": adaptive_records,
        "open_witness": open_witness,
    }


def main():
    started = time.monotonic()
    payload = json.loads(INPUT.read_text())
    eigenspaces = recover_eigenspaces(payload)
    mandatory = initial_forms(payload)
    mandatory_seen = set(mandatory)
    clauses = []
    clause_seen = set()
    probe = landing.probe_core.Probe()
    complete_conjugacy_checks = conjugacy_checks(probe)
    basis = probe.basis(9, 19)
    quartic, _ = landing.pencil_core.reconstruct()
    elements = [(a, b) for a in range(P) for b in range(P)]
    counters = Counter()
    space_summaries = []
    for space_index, space in enumerate(eigenspaces):
        left = [tuple(value) for value in space["basis"][0]]
        right = [tuple(value) for value in space["basis"][1]]
        projective_points = [right] + [vector_add_scaled(left, value, right) for value in elements]
        local = Counter()
        for point_index, point in enumerate(projective_points):
            outputs = landing.extension_seed_values(
                probe, basis, np.asarray(point, dtype=np.int64)
            )
            output_rank = binary.output_rank(outputs)
            local[f"rank_{output_rank}"] += 1
            counters[f"rank_{output_rank}"] += 1
            if output_rank == 1:
                form = rank_one_form(outputs, quartic)
                if form is not None:
                    local["rank_one_nonzero"] += 1
                    if form not in mandatory_seen:
                        mandatory_seen.add(form)
                        mandatory.append(form)
                continue
            if output_rank != 2:
                continue
            u, v, c_form, d_form = binary.image_coordinates(outputs)
            coefficients = binary.binary_quartic(quartic, u, v)
            factors = binary.split_factors(coefficients, c_form, d_form)
            if factors is None:
                local["nonsplit"] += 1
                counters["nonsplit"] += 1
                continue
            local["split"] += 1
            counters["split"] += 1
            clause = binary.canonical_clause(factors)
            if clause not in clause_seen:
                clause_seen.add(clause)
                clauses.append(clause)
        local["unique_mandatory_total"] = len(mandatory_seen)
        local["unique_clauses_total"] = len(clauses)
        summary = {**space, "line_count": len(projective_points), "counts": dict(local)}
        space_summaries.append(summary)
        print(
            f"space={space_index + 1}/{len(eigenspaces)} "
            f"order={space['group_type']['order']} eigen={space['eigenvalue']} "
            f"counts={dict(local)} elapsed={time.monotonic() - started:.2f}",
            flush=True,
        )
    mandatory_state = binary.rref(tuple(mandatory))
    CACHE.write_text(json.dumps(
        {
            "field": "F_23[u]/(u^2-5)",
            "mandatory_forms": [
                [[a, b] for a, b in form] for form in mandatory_state
            ],
            "clauses": [
                [
                    [[a, b] for a, b in factor]
                    for factor in clause
                ]
                for clause in clauses
            ],
            "space_summaries": space_summaries,
            "counts": dict(counters),
            "conjugacy_checks": complete_conjugacy_checks,
        },
        indent=2,
    ) + "\n")
    print(
        f"mandatoryRank={len(mandatory_state)} uniqueClauses={len(clauses)} "
        "starting exact SAT",
        flush=True,
    )
    if os.environ.get("DEGREE9_CACHE_ONLY") == "1":
        print(f"CACHE_ONLY_OK file={CACHE.name}")
        return
    evaluation_rng = np.random.default_rng(2026080149)
    evaluation_points = [
        evaluation_rng.integers(0, P, 6, dtype=np.int64) for _ in range(48)
    ]
    ambient_evaluations = [
        landing.fast_seed_values(probe, basis, point) for point in evaluation_points
    ]
    sat = adaptive_sat(
        mandatory_state, clauses, ambient_evaluations, quartic,
        node_limit=5_000_000,
    )
    result = {
        "field": "F_23[u]/(u^2-5)",
        "exhausted_projective_lines_per_eigenspace": 530,
        "eigenspace_count": len(eigenspaces),
        "total_lines": 530 * len(eigenspaces),
        "counts": dict(counters),
        "mandatory_form_count": len(mandatory_seen),
        "mandatory_form_rank": len(mandatory_state),
        "unique_split_clauses": len(clauses),
        "clause_size_tally": dict(sorted(Counter(map(len, clauses)).items())),
        "eigenspaces": space_summaries,
        "conjugacy_checks": complete_conjugacy_checks,
        "adaptive_evaluation_rng_seed": 2026080149,
        "adaptive_evaluation_points": [point.tolist() for point in evaluation_points],
        "sat": sat,
        "projective_emptiness": sat["status"] == "closed",
        "elapsed_seconds": time.monotonic() - started,
    }
    OUTPUT.write_text(json.dumps(result, indent=2) + "\n")
    print(
        f"mandatoryRank={len(mandatory_state)} clauses={len(clauses)} "
        f"satStatus={sat['status']} nodes={sat['nodes']} "
        f"elapsed={result['elapsed_seconds']:.2f}"
    )
    if result["projective_emptiness"]:
        print("FULL_DEGREE9_PROJECTIVE_EMPTINESS_EXHAUSTIVE_LINEAR_SAT_OK")
    else:
        print("SCOPE exhaustive order-3/order-6 binary-factor SAT; no projective verdict")


if __name__ == "__main__":
    main()
