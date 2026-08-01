#!/usr/bin/env python3
"""Exact replay for the all-exponent three-monomial support exclusion."""

from __future__ import annotations

import hashlib
import importlib.util
import itertools
import json
from pathlib import Path


HERE = Path(__file__).resolve().parent
ALGORITHM_PATH = HERE / "all_exponent_monomial_search.py"
MARKER = "H_TRACE_THREE_KUMMER_LAURENT_MONOMIAL_ALL_EXPONENT_EXCLUSION_OK"


def load(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def component_table(algorithm):
    data = []
    for triple in itertools.combinations(range(5), 3):
        components = []
        for counts, polynomial in sorted(algorithm.THREE.compact_components(triple).items()):
            components.append({
                "counts": list(counts),
                "terms": [
                    {"e": list(exponent), "c": [str(value) for value in coefficient.c]}
                    for exponent, coefficient in sorted(polynomial.items())
                ],
            })
        data.append({"triple": list(triple), "components": components})
    return json.dumps(data, sort_keys=True, separators=(",", ":")).encode()


def main():
    payload = json.loads((HERE / "payload.json").read_text())
    assert payload["marker"] == MARKER
    assert hashlib.sha256(ALGORITHM_PATH.read_bytes()).hexdigest() == payload["algorithm_sha256"]

    algorithm = load("all_exponent_support", ALGORITHM_PATH)
    table = component_table(algorithm)
    assert len(table) == payload["upstream_component_table_bytes"]
    assert hashlib.sha256(table).hexdigest() == payload["upstream_component_table_sha256"]
    expected = payload["per_triple"]
    totals = {
        "terms": 0,
        "equations": 0,
        "pairs": 0,
        "candidates": 0,
        "finite": 0,
        "parallel": 0,
    }
    tags = []
    for triple in itertools.combinations(range(5), 3):
        tags.append("".join(map(str, triple)))
        components = algorithm.THREE.compact_components(triple)
        items = algorithm.contributions(components)
        assert len(items) == expected["expanded_nonzero_terms"]
        assert all(coefficient for _, _, coefficient in items)

        equations, pair_count, candidates, viable = algorithm.finite_support_candidates(items)
        directions, families = algorithm.parallel_support_families(items, equations)
        assert directions
        assert len(equations) == expected["collision_equations"]
        assert pair_count == expected["nonparallel_equation_pairs"]
        assert len(candidates) == expected["integral_exponent_candidates"]
        assert len(viable) == expected["viable_finite_supports"] == 0
        assert len(families) == expected["viable_parallel_support_families"] == 0

        totals["terms"] += len(items)
        totals["equations"] += len(equations)
        totals["pairs"] += pair_count
        totals["candidates"] += len(candidates)
        totals["finite"] += len(viable)
        totals["parallel"] += len(families)

    assert tags == payload["triples"]
    print("ALGORITHM_SHA256_OK", payload["algorithm_sha256"])
    print("UPSTREAM_COMPONENT_TABLE_SHA256_OK", payload["upstream_component_table_sha256"])
    print("THREE_KUMMER_PLANES", len(tags))
    print("EXPANDED_NONZERO_TERMS", totals["terms"])
    print("COLLISION_EQUATIONS", totals["equations"])
    print("NONPARALLEL_EQUATION_PAIRS", totals["pairs"])
    print("INTEGRAL_EXPONENT_CANDIDATES", totals["candidates"])
    print("VIABLE_FINITE_SUPPORTS", totals["finite"])
    print("VIABLE_PARALLEL_SUPPORT_FAMILIES", totals["parallel"])
    print(MARKER)


if __name__ == "__main__":
    main()
