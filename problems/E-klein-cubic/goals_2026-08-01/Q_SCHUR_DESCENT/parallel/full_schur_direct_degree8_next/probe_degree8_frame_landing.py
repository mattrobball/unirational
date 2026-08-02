#!/usr/bin/env python3
"""Exact good-fibre rank probe for the five degree-8 Schur frame covariants."""

from __future__ import annotations

import importlib.util
from itertools import islice, product
from pathlib import Path
import runpy


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
PACKET = ROOT / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/exact_schur_frame"
PRODUCER_PATH = PACKET / "produce_exact_frame.py"
CORE_PATH = PACKET / "exact_representation_core.py"
P = 23
ZETA = 2


def load_module(path: Path):
    spec = importlib.util.spec_from_file_location("degree8_frame_producer", path)
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def rank_add(basis, row):
    work = [value % P for value in row]
    for pivot, old in basis:
        if work[pivot]:
            scalar = work[pivot]
            work = [(a - scalar * b) % P for a, b in zip(work, old)]
    pivot = next((index for index, value in enumerate(work) if value), None)
    if pivot is None:
        return False
    inverse = pow(work[pivot], -1, P)
    work = [inverse * value % P for value in work]
    for index, (old_pivot, old) in enumerate(basis):
        if old[pivot]:
            scalar = old[pivot]
            basis[index] = (
                old_pivot,
                [(a - scalar * b) % P for a, b in zip(old, work)],
            )
    basis.append((pivot, work))
    basis.sort()
    return True


def main():
    producer = load_module(PRODUCER_PATH)
    core = runpy.run_path(str(CORE_PATH))
    records, _sources, _targets = producer.group_records(core)
    reduced = []
    for _abstract, _word, target_inverse, source in records:
        reduced.append((
            [[core["reduce_k11"](entry, ZETA, P) for entry in row] for row in target_inverse],
            [core["reduce_k11"](entry, ZETA, P) for entry in source[5]],
        ))
    assert len(reduced) == 660

    table = producer.cubic_coefficient_table()
    exponents = [tuple(entry["a_exponents"]) for entry in table]
    assert len(exponents) == len(set(exponents)) == 35

    def frame(point):
        answer = [[0] * 5 for _ in range(5)]
        for target_inverse, source_row in reduced:
            linear = sum(a * b for a, b in zip(source_row, point)) % P
            value = pow(linear, 8, P)
            if not value:
                continue
            for row in range(5):
                for seed in range(5):
                    answer[row][seed] = (
                        answer[row][seed] + target_inverse[row][seed] * value
                    ) % P
        return answer

    def coefficient_row(point):
        q = frame(point)
        answer = []
        for entry in table:
            total = 0
            for triple in entry["products"]:
                term = 1
                for row, column in triple:
                    term = term * q[row][column] % P
                total = (total + term) % P
            answer.append(total)
        return answer

    basis = []
    witnesses = []
    for point in islice(product(range(1, P), repeat=6), 600):
        row = coefficient_row(point)
        if rank_add(basis, row):
            witnesses.append((point, row))
            print(f"RANK={len(basis)} POINT={point}", flush=True)
            if len(basis) == 35:
                break
    print(f"DEGREE8_FRAME_LANDING_COEFFICIENT_RANK={len(basis)}")
    print(f"WITNESSES={len(witnesses)}")
    if len(basis) == 35:
        print("FULL_SCHUR_DEGREE8_FRAME_CONSTANT_LANDING_EMPTY_MOD23")
    else:
        print("FULL_SCHUR_DEGREE8_FRAME_CONSTANT_LANDING_RANK_INCOMPLETE")


if __name__ == "__main__":
    main()
