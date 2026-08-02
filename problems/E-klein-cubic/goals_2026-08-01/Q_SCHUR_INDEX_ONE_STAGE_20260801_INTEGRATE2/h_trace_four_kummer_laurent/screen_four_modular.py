#!/usr/bin/env python3
"""Necessary modular support screen for four Kummer Laurent coordinates."""

from __future__ import annotations

from itertools import combinations, product
import importlib.util
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
PROBLEM = next(parent for parent in (HERE, *HERE.parents)
               if parent.name == "E-klein-cubic")
SOURCE = (
    PROBLEM/"goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/"
    "h_trace_three_kummer_planes/verify.py"
)
spec = importlib.util.spec_from_file_location("three_planes", SOURCE)
three = importlib.util.module_from_spec(spec)
assert spec.loader is not None
sys.modules[spec.name] = three
spec.loader.exec_module(three)


EXPECTED_MOD3_BASES = {
    (0, 1, 2, 3): ((1, 0, 0, 0), (2, 0, 0, 0), (0, 0, 0, 0)),
    (0, 1, 2, 4): ((1, 0, 0, 0), (2, 0, 0, 0), (1, 0, 0, 0)),
    (0, 1, 3, 4): ((1, 0, 0, 0), (0, 0, 0, 0), (1, 0, 0, 0)),
    (0, 2, 3, 4): ((2, 0, 0, 0), (0, 0, 0, 0), (1, 0, 0, 0)),
    (1, 2, 3, 4): ((1, 0, 0, 0), (2, 0, 0, 0), (0, 0, 0, 0)),
}


def four_components(indices):
    answer = {}
    for counts in product(range(4), repeat=4):
        if sum(counts) != 3:
            continue
        used = [i for i, count in enumerate(counts) if count]
        total_degree = sum(count*indices[i] for i, count in enumerate(counts))
        if len(used) == 1:
            scalar = three.EPS**indices[used[0]]
        elif len(used) == 2:
            repeated = next(i for i in used if counts[i] == 2)
            single = next(i for i in used if counts[i] == 1)
            scalar = 2*three.EPS**indices[repeated]+three.EPS**indices[single]
        else:
            scalar = 2*sum((three.EPS**indices[i] for i in used), three.ZERO)
        answer[counts] = three.scale_polynomial(
            three.trace_coefficient(total_degree), scalar
        )
    assert len(answer) == 20
    assert all(len(polynomial) == 7 for polynomial in answer.values())
    return answer


def contributions(components):
    return [
        (counts, exponent)
        for counts, polynomial in sorted(components.items())
        for exponent in sorted(polynomial)
    ]


def vectors(modulus):
    return list(product(range(modulus), repeat=4))


def support_survives(items, shifts, modulus):
    seen = {}
    for counts, exponent in items:
        target = tuple(
            (exponent[k] + sum(counts[j+1]*shifts[j][k] for j in range(3))) % modulus
            for k in range(4)
        )
        seen[target] = seen.get(target, 0)+1
    return min(seen.values()) >= 2, len(seen)


def numpy_screen(items, modulus, max_examples):
    import numpy as np

    vector_array = np.array(vectors(modulus), dtype=np.int16)
    count = len(vector_array)
    indices = np.indices((count, count, count), dtype=np.int32).reshape(3, -1).T
    shifts = vector_array[indices]
    rows = np.arange(len(shifts), dtype=np.int32)
    cell_count = modulus**4
    counts = np.zeros((len(shifts), cell_count), dtype=np.uint8)
    place = np.array([modulus**3, modulus**2, modulus, 1], dtype=np.int16)
    for component_counts, exponent in items:
        target = np.array(exponent, dtype=np.int16)
        for shift_index in range(3):
            target = target + component_counts[shift_index+1]*shifts[:, shift_index, :]
        target %= modulus
        codes = target @ place
        counts[rows, codes] += 1
    mask = np.all(counts != 1, axis=1)
    survivor_indices = np.flatnonzero(mask)
    examples = []
    for index in survivor_indices[:max_examples]:
        examples.append((tuple(tuple(map(int, row)) for row in shifts[index]),
                         int(np.count_nonzero(counts[index]))))
    return len(shifts), len(survivor_indices), examples


def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--modulus", type=int, default=3)
    parser.add_argument("--max-examples", type=int, default=20)
    args = parser.parse_args()
    modulus = args.modulus
    candidate_vectors = vectors(modulus)
    total = 0
    survivors = 0
    examples = []
    for indices in combinations(range(5), 4):
        items = contributions(four_components(indices))
        assert len(items) == 140
        if modulus >= 3:
            local_total, local, local_examples = numpy_screen(
                items, modulus, args.max_examples-len(examples)
            )
            total += local_total
            survivors += local
            examples.extend((indices, shifts, group_count)
                            for shifts, group_count in local_examples)
            if modulus == 3:
                assert local == 1
                assert local_examples[0][0] == EXPECTED_MOD3_BASES[indices]
                assert local_examples[0][1] == 31
            print(f"QUADRUPLE {indices} MODULUS {modulus} SURVIVORS {local}")
            continue
        local = 0
        for shifts in product(candidate_vectors, repeat=3):
            total += 1
            survives, group_count = support_survives(items, shifts, modulus)
            if survives:
                survivors += 1
                local += 1
                if len(examples) < args.max_examples:
                    examples.append((indices, shifts, group_count))
        print(f"QUADRUPLE {indices} MODULUS {modulus} SURVIVORS {local}")
    print(f"TOTAL {total} SURVIVORS {survivors}")
    for example in examples:
        print(f"EXAMPLE {example}")
    if modulus == 3:
        assert total == 5*3**12 and survivors == 5
        print("H_TRACE_FOUR_KUMMER_UNIQUE_MOD3_SUPPORT_CLASSES_OK")


if __name__ == "__main__":
    main()
