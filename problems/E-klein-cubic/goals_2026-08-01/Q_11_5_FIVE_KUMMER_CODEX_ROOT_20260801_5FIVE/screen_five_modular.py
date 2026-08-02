#!/usr/bin/env python3
"""Exact modular singleton-support screen for five Kummer coordinates."""

from __future__ import annotations

import importlib.util
from itertools import product
from pathlib import Path
import sys


HERE = Path(__file__).resolve().parent
PROBLEM = next(parent for parent in (HERE, *HERE.parents)
               if parent.name == "E-klein-cubic")
SOURCE = (
    PROBLEM / "goal_runs_after_35fa/Q_SCHUR_INDEX_ONE/"
    "h_trace_three_kummer_planes/verify.py"
)
spec = importlib.util.spec_from_file_location("three_planes", SOURCE)
three = importlib.util.module_from_spec(spec)
assert spec.loader is not None
sys.modules[spec.name] = three
spec.loader.exec_module(three)


def five_components():
    answer = {}
    indices = tuple(range(5))
    for counts in product(range(4), repeat=5):
        if sum(counts) != 3:
            continue
        used = [i for i, count in enumerate(counts) if count]
        total_degree = sum(count * indices[i] for i, count in enumerate(counts))
        if len(used) == 1:
            scalar = three.EPS ** indices[used[0]]
        elif len(used) == 2:
            repeated = next(i for i in used if counts[i] == 2)
            single = next(i for i in used if counts[i] == 1)
            scalar = 2 * three.EPS ** indices[repeated] + three.EPS ** indices[single]
        else:
            scalar = 2 * sum((three.EPS ** indices[i] for i in used), three.ZERO)
        answer[counts] = three.scale_polynomial(
            three.trace_coefficient(total_degree), scalar
        )
    assert len(answer) == 35
    assert all(len(polynomial) == 7 for polynomial in answer.values())
    return answer


def contributions(components):
    return [
        (counts, exponent)
        for counts, polynomial in sorted(components.items())
        for exponent in sorted(polynomial)
    ]


def has_no_singletons(rows):
    """Return one Boolean per row using exact run lengths after sorting."""
    import numpy as np

    ordered = np.sort(rows, axis=1)
    left_diff = np.ones(ordered.shape, dtype=bool)
    right_diff = np.ones(ordered.shape, dtype=bool)
    left_diff[:, 1:] = ordered[:, 1:] != ordered[:, :-1]
    right_diff[:, :-1] = ordered[:, :-1] != ordered[:, 1:]
    return ~np.any(left_diff & right_diff, axis=1)


def allowed_fourth_mask(indices, coordinate_labels):
    allowed = has_no_singletons(coordinate_labels[:, indices])
    mask = 0
    for choice_index in allowed.nonzero()[0]:
        mask |= 1 << int(choice_index)
    return mask


def cached_final_refinement(codes, prefixes, coordinate_labels, batch_size=2048):
    """Intersect cached 81-bit fourth-coordinate masks block by block."""
    import numpy as np

    full_mask = (1 << len(coordinate_labels)) - 1
    cache = {}
    survivors = []
    for start in range(0, len(codes), batch_size):
        stop = min(start + batch_size, len(codes))
        orders = np.argsort(codes[start:stop], axis=1, kind="stable")
        for local_row, order in enumerate(orders):
            row = codes[start + local_row]
            ordered_values = row[order]
            boundaries = np.flatnonzero(ordered_values[1:] != ordered_values[:-1]) + 1
            groups = np.split(order, boundaries)
            groups.sort(key=len)
            mask = full_mask
            for group in groups:
                # Stable sorting makes the item indices increasing inside a block.
                key = group.astype(np.uint8, copy=False).tobytes()
                block_mask = cache.get(key)
                if block_mask is None:
                    block_mask = allowed_fourth_mask(group, coordinate_labels)
                    cache[key] = block_mask
                mask &= block_mask
                if not mask:
                    break
            if mask:
                prefix = int(prefixes[start + local_row]) * len(coordinate_labels)
                while mask:
                    low_bit = mask & -mask
                    digit = low_bit.bit_length() - 1
                    survivors.append(prefix + digit)
                    mask ^= low_bit
        print(
            f"FINAL_PROGRESS {stop}/{len(codes)} CACHE {len(cache)} "
            f"SURVIVORS {len(survivors)}",
            flush=True,
        )
    return np.array(survivors, dtype=np.int64), len(cache)


def refine_screen(items, modulus=3, batch_size=256):
    import numpy as np

    choices = np.array(list(product(range(modulus), repeat=4)), dtype=np.uint8)
    count_matrix = np.array(
        [counts[1:] for counts, _ in items], dtype=np.uint8
    )
    exponent_matrix = np.array(
        [exponent for _, exponent in items], dtype=np.uint8
    )
    labels = [
        ((choices @ count_matrix.T + exponent_matrix[:, coordinate]) % modulus)
        .astype(np.uint8)
        for coordinate in range(4)
    ]

    codes = np.zeros((1, len(items)), dtype=np.uint8)
    prefixes = np.zeros(1, dtype=np.int64)
    depth_counts = []
    choice_count = len(choices)
    for depth, coordinate_labels in enumerate(labels[:3], start=1):
        next_codes = []
        next_prefixes = []
        for start in range(0, len(codes), batch_size):
            stop = min(start + batch_size, len(codes))
            parent_codes = codes[start:stop]
            parent_prefixes = prefixes[start:stop]
            combined = (
                np.repeat(parent_codes, choice_count, axis=0) * modulus
                + np.tile(coordinate_labels, (len(parent_codes), 1))
            ).astype(np.uint8)
            mask = has_no_singletons(combined)
            if not np.any(mask):
                continue
            branch_numbers = np.tile(
                np.arange(choice_count, dtype=np.int64), len(parent_codes)
            )
            encoded_parents = np.repeat(parent_prefixes, choice_count)
            next_codes.append(combined[mask])
            next_prefixes.append(
                (encoded_parents * choice_count + branch_numbers)[mask]
            )
        if next_codes:
            codes = np.concatenate(next_codes)
            prefixes = np.concatenate(next_prefixes)
        else:
            codes = np.empty((0, len(items)), dtype=np.uint8)
            prefixes = np.empty(0, dtype=np.int64)
        depth_counts.append(len(codes))
        print(
            f"DEPTH {depth} CANDIDATES {len(codes)} "
            f"OF {modulus ** (4 * depth)}",
            flush=True,
        )
        if not len(codes):
            break
    if len(codes):
        prefixes, cache_size = cached_final_refinement(
            codes, prefixes, labels[3], max(256, batch_size)
        )
        depth_counts.append(len(prefixes))
        print(
            f"DEPTH 4 CANDIDATES {len(prefixes)} OF {modulus ** 16} "
            f"UNIQUE_BLOCK_MASKS {cache_size}",
            flush=True,
        )
    else:
        prefixes = np.empty(0, dtype=np.int64)
        depth_counts.append(0)
    return choices, prefixes, depth_counts


def decode_prefix(encoded, choices, depth=4):
    result = []
    radix = len(choices)
    for _ in range(depth):
        encoded, digit = divmod(int(encoded), radix)
        result.append(tuple(map(int, choices[digit])))
    assert encoded == 0
    # Digits were accumulated coordinate by coordinate.
    coordinate_choices = list(reversed(result))
    return tuple(
        tuple(coordinate_choices[coordinate][shift] for coordinate in range(depth))
        for shift in range(4)
    )


def main():
    import argparse

    parser = argparse.ArgumentParser()
    parser.add_argument("--modulus", type=int, default=3)
    parser.add_argument("--batch-size", type=int, default=256)
    parser.add_argument("--max-examples", type=int, default=20)
    args = parser.parse_args()

    items = contributions(five_components())
    assert len(items) == 245
    choices, prefixes, depth_counts = refine_screen(
        items, args.modulus, args.batch_size
    )
    print(
        f"TOTAL {args.modulus ** 16} SURVIVORS {len(prefixes)}",
        flush=True,
    )
    for encoded in prefixes[:args.max_examples]:
        shifts = decode_prefix(encoded, choices)
        group_count = len({
            tuple(
                (exponent[coordinate] + sum(
                    counts[shift + 1] * shifts[shift][coordinate]
                    for shift in range(4)
                )) % args.modulus
                for coordinate in range(4)
            )
            for counts, exponent in items
        })
        print(f"EXAMPLE {shifts} GROUPS {group_count}")
    if args.modulus == 3 and not len(prefixes):
        print("H_TRACE_FIVE_KUMMER_MOD3_SINGLETON_EXCLUSION_OK")


if __name__ == "__main__":
    main()
