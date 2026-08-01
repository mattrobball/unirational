#!/usr/bin/env python3
"""Exhaust support patterns for three Laurent-monomial coordinates.

After homogeneous normalization, candidates have

    (X,Y,Z) = (1, c*U^a, d*U^b),

with a,b in Z^4 and nonzero constants c,d in C.  The support stage is finite:
an identity needs every one of the 70 expanded terms to collide with another.
"""

from __future__ import annotations

import importlib.util
import itertools
import json
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / "h_trace_three_kummer_planes" / "verify.py"
SPEC = importlib.util.spec_from_file_location("three_planes", SOURCE)
THREE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(THREE)


def contributions(components):
    answer = []
    for counts, polynomial in sorted(components.items()):
        for exponent, coefficient in sorted(polynomial.items()):
            answer.append((counts, exponent, coefficient))
    assert len(answer) == 70
    return answer


def equation(left, right):
    counts1, exp1, _ = left
    counts2, exp2, _ = right
    A = counts1[1] - counts2[1]
    B = counts1[2] - counts2[2]
    if A == 0 and B == 0:
        return None
    delta = tuple(y - x for x, y in zip(exp1, exp2))
    if A < 0 or (A == 0 and B < 0):
        A, B = -A, -B
        delta = tuple(-value for value in delta)
    return A, B, delta


def collision_groups(items, a, b):
    groups = {}
    for index, (counts, exponent, coefficient) in enumerate(items):
        shifted = tuple(exponent[k] + counts[1] * a[k] + counts[2] * b[k]
                        for k in range(4))
        groups.setdefault(shifted, []).append(index)
    return groups


def finite_support_candidates(items):
    equations = sorted({eq for pair in itertools.combinations(items, 2)
                        if (eq := equation(*pair)) is not None})
    candidates = set()
    nonparallel_pairs = 0
    for first_index, first in enumerate(equations):
        A1, B1, d1 = first
        for A2, B2, d2 in equations[first_index + 1:]:
            determinant = A1 * B2 - A2 * B1
            if determinant == 0:
                continue
            nonparallel_pairs += 1
            anum = tuple(d1[k] * B2 - d2[k] * B1 for k in range(4))
            bnum = tuple(A1 * d2[k] - A2 * d1[k] for k in range(4))
            if any(value % determinant for value in (*anum, *bnum)):
                continue
            a = tuple(value // determinant for value in anum)
            b = tuple(value // determinant for value in bnum)
            candidates.add((a, b))

    viable = []
    for a, b in candidates:
        groups = collision_groups(items, a, b)
        if min(map(len, groups.values())) >= 2:
            viable.append((a, b, groups))
    return equations, nonparallel_pairs, candidates, viable


def primitive_direction(A, B):
    g = math.gcd(abs(A), abs(B))
    A, B = A // g, B // g
    if A < 0 or (A == 0 and B < 0):
        A, B = -A, -B
    return A, B


def parallel_support_families(items, equations):
    directions = sorted({primitive_direction(A, B) for A, B, _ in equations})
    families = []
    for direction in directions:
        A0, B0 = direction
        possible_h = set()
        for A, B, delta in equations:
            if A * B0 == A0 * B:
                # A,B are a positive multiple of the normalized direction.
                scale = (A // A0) if A0 else (B // B0)
                if all(value % scale == 0 for value in delta):
                    possible_h.add(tuple(value // scale for value in delta))
        for h in possible_h:
            matched = [False] * len(items)
            for i, j in itertools.combinations(range(len(items)), 2):
                eq = equation(items[i], items[j])
                if eq is None:
                    continue
                A, B, delta = eq
                if A * B0 != A0 * B:
                    continue
                scale = (A // A0) if A0 else (B // B0)
                if delta == tuple(scale * value for value in h):
                    matched[i] = matched[j] = True
            if all(matched):
                families.append((direction, h))
    return directions, families


def serializable_groups(items, groups):
    answer = []
    for exponent, indices in sorted(groups.items()):
        terms = []
        for index in indices:
            counts, source_exp, coefficient = items[index]
            terms.append({
                "counts": list(counts),
                "source_exp": list(source_exp),
                "coefficient": [str(value) for value in coefficient.c],
            })
        answer.append({"exponent": list(exponent), "terms": terms})
    return answer


def main():
    payload = {"triples": {}}
    for triple in itertools.combinations(range(5), 3):
        items = contributions(THREE.compact_components(triple))
        equations, pair_count, candidates, viable = finite_support_candidates(items)
        directions, families = parallel_support_families(items, equations)
        print(
            "TRIPLE", triple,
            "EQUATIONS", len(equations),
            "NONPARALLEL_PAIRS", pair_count,
            "INTEGRAL_CANDIDATES", len(candidates),
            "VIABLE_FINITE", len(viable),
            "PARALLEL_FAMILIES", len(families),
        )
        payload["triples"]["".join(map(str, triple))] = {
            "equations": len(equations),
            "nonparallel_pairs": pair_count,
            "integral_candidates": len(candidates),
            "viable": [
                {"a": list(a), "b": list(b), "groups": serializable_groups(items, groups)}
                for a, b, groups in viable
            ],
            "parallel_families": [
                {"direction": list(direction), "h": list(h)}
                for direction, h in families
            ],
        }
    (HERE / "support_candidates.json").write_text(json.dumps(payload, indent=2) + "\n")
    print("SUPPORT_CANDIDATES_WRITTEN", HERE / "support_candidates.json")


if __name__ == "__main__":
    main()
