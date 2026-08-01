#!/usr/bin/env python3
"""Search exact monomial valuations for a local obstruction on the ten planes.

This is exploratory: a reported ``NO_INTEGER_TROPICAL_POINT`` is already a
rigorous obstruction for the corresponding discrete monomial valuation.
"""

from __future__ import annotations

import importlib.util
import itertools
import math
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / "h_trace_three_kummer_planes" / "verify.py"
SPEC = importlib.util.spec_from_file_location("three_planes", SOURCE)
THREE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(THREE)


def valuation(poly, w):
    return min(sum(a * b for a, b in zip(exp, w)) for exp in poly)


def egcd(a, b):
    if b == 0:
        return (abs(a), 1 if a >= 0 else -1, 0)
    g, x, y = egcd(b, a % b)
    return g, y, x - (a // b) * y


def floor_div(a, b):
    assert b > 0
    return a // b


def ceil_div(a, b):
    assert b > 0
    return -((-a) // b)


def pair_minimum_feasible(terms, i, j):
    """Return one integral (x,y) where terms i,j tie for the minimum."""
    vi, ai, bi = terms[i]
    vj, aj, bj = terms[j]
    A, B, C = ai - aj, bi - bj, vj - vi
    g = math.gcd(abs(A), abs(B))
    if g == 0 or C % g:
        return None

    gg, sx, sy = egcd(A, B)
    assert gg == g and A * sx + B * sy == g
    x0, y0 = sx * (C // g), sy * (C // g)
    dx, dy = B // g, -A // g

    lo = None
    hi = None
    for vk, ak, bk in terms:
        # term i <= term k
        d0 = (vi - vk) + (ai - ak) * x0 + (bi - bk) * y0
        dt = (ai - ak) * dx + (bi - bk) * dy
        if dt == 0:
            if d0 > 0:
                return None
        elif dt > 0:
            bound = floor_div(-d0, dt)
            hi = bound if hi is None else min(hi, bound)
        else:
            bound = ceil_div(d0, -dt)
            lo = bound if lo is None else max(lo, bound)
    if lo is not None and hi is not None and lo > hi:
        return None
    t = lo if lo is not None else (hi if hi is not None else 0)
    assert hi is None or t <= hi
    return x0 + dx * t, y0 + dy * t


def tropical_witness(components, w):
    terms = []
    counts_order = []
    for counts, poly in sorted(components.items()):
        # Normalize coordinate valuations by v(Z)=0.
        terms.append((valuation(poly, w), counts[0], counts[1]))
        counts_order.append(counts)
    for i, j in itertools.combinations(range(len(terms)), 2):
        point = pair_minimum_feasible(terms, i, j)
        if point is not None:
            x, y = point
            values = [v + a * x + b * y for v, a, b in terms]
            minimum = min(values)
            tied = [counts_order[k] for k, value in enumerate(values) if value == minimum]
            assert len(tied) >= 2
            return (x, y, tied, tuple(v for v, _, _ in terms))
    return None


def primitive_vectors(bound):
    for w in itertools.product(range(-bound, bound + 1), repeat=4):
        if w == (0, 0, 0, 0):
            continue
        if math.gcd(*map(abs, w)) == 1:
            yield w


def main():
    triples = list(itertools.combinations(range(5), 3))
    components = {triple: THREE.compact_components(triple) for triple in triples}
    unresolved = set(triples)
    for bound in range(1, 9):
        tested = 0
        for w in primitive_vectors(bound):
            if max(map(abs, w)) != bound:
                continue
            tested += 1
            for triple in tuple(unresolved):
                witness = tropical_witness(components[triple], w)
                if witness is None:
                    print("NO_INTEGER_TROPICAL_POINT", triple, w)
                    unresolved.remove(triple)
        print("BOUND", bound, "VECTORS", tested, "UNRESOLVED", sorted(unresolved))
        if not unresolved:
            break

    if unresolved:
        print("NO_SINGLE_VALUATION_OBSTRUCTION_FOUND", sorted(unresolved))
        for triple in sorted(unresolved):
            best = None
            for w in primitive_vectors(3):
                wit = tropical_witness(components[triple], w)
                assert wit is not None
                score = len(wit[2])
                if best is None or score > best[0]:
                    best = (score, w, wit)
            print("SAMPLE", triple, best)


if __name__ == "__main__":
    main()
