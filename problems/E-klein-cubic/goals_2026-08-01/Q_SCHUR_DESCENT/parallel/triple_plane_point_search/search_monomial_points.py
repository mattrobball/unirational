#!/usr/bin/env python3
"""Exact screen for Laurent-monomial points on the ten Kummer planes."""

from __future__ import annotations

import importlib.util
import itertools
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / "h_trace_three_kummer_planes" / "verify.py"
STRUCTURAL = HERE / "search_structural.py"


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


ALG = load("structural", STRUCTURAL)
THREE = ALG.THREE


def monomial(exp, scalar):
    return {tuple(exp): scalar}


def specialized_coefficients(components, values, prime, root):
    answer = []
    for counts, coefficient in sorted(components.items()):
        answer.append((counts, ALG.keval(coefficient, values, prime, root)))
    return answer


def monomial_mod(exp, values, prime):
    answer = 1
    for value, power in zip(values, exp):
        if power >= 0:
            answer = answer * pow(value, power, prime) % prime
        else:
            answer = answer * pow(pow(value, -power, prime), -1, prime) % prime
    return answer


def cubic_scalar(coefficients, y, z, prime):
    answer = 0
    for counts, coefficient in coefficients:
        answer = (answer + coefficient * pow(y, counts[1], prime)
                  * pow(z, counts[2], prime)) % prime
    return answer


def main():
    triples = list(itertools.combinations(range(5), 3))
    components = {triple: THREE.compact_components(triple) for triple in triples}
    screen_data = []
    for prime, value_sets in [
        (11, [(2, 3, 5, 7), (7, 2, 6, 8)]),
        (31, [(2, 3, 5, 7), (11, 13, 17, 19)]),
        (41, [(3, 7, 11, 13)]),
    ]:
        root = ALG.primitive_fifth_root(prime)
        for values in value_sets:
            screen_data.append((prime, root, values, {
                triple: specialized_coefficients(components[triple], values, prime, root)
                for triple in triples
            }))

    bound = 1
    exponents = list(itertools.product(range(-bound, bound + 1), repeat=4))
    # Precompute all monomial values at each specialization.
    monomial_values = []
    for prime, root, values, coefficient_tables in screen_data:
        monomial_values.append({exp: monomial_mod(exp, values, prime) for exp in exponents})

    tested = 0
    modular_survivors = 0
    hits = []
    for triple in triples:
        for ey in exponents:
            for ez in exponents:
                for py in range(5):
                    for pz in range(5):
                        tested += 1
                        survives = True
                        for screen_index, (prime, root, values, coefficient_tables) in enumerate(screen_data):
                            y = pow(root, py, prime) * monomial_values[screen_index][ey] % prime
                            z = pow(root, pz, prime) * monomial_values[screen_index][ez] % prime
                            if cubic_scalar(coefficient_tables[triple], y, z, prime):
                                survives = False
                                break
                        if not survives:
                            continue
                        modular_survivors += 1
                        coords = (
                            monomial((0, 0, 0, 0), THREE.ONE),
                            monomial(ey, THREE.EPS ** py),
                            monomial(ez, THREE.EPS ** pz),
                        )
                        value = ALG.cubic_value(components[triple], coords)
                        if not value:
                            hit = (triple, ey, py, ez, pz)
                            hits.append(hit)
                            print("POINT", hit)

    print("EXPONENT_BOUND", bound)
    print("CANDIDATES_TESTED", tested)
    print("MODULAR_SURVIVORS", modular_survivors)
    print("POINTS_FOUND", len(hits))
    if not hits:
        print("LAURENT_MONOMIAL_ROOT_OF_UNITY_SEARCH_NO_HIT")


if __name__ == "__main__":
    main()
