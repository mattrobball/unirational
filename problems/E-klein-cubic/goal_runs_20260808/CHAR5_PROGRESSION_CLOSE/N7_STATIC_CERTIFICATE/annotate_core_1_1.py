#!/usr/bin/env python3
"""Annotate the independent 212-row CaDiCaL core for the (1,1) family.

The input row indices use the insertion order of
CHAR5_PROGRESSION_LOW_DEGREE/verify.py.  This script reconstructs that exact
order and writes a deterministic JSON annotation containing the target
exponent, every coefficient monomial and the H/K root exponents.
"""

from __future__ import annotations

import hashlib
import json
from collections import defaultdict
from itertools import combinations_with_replacement
from pathlib import Path


P = 5
W = (1, 9, 4, 3, 5)
ROOT_DEGREE = 7
HERE = Path(__file__).resolve().parent
CORE = HERE.parent / "N7_SUPPORT" / "cadical_core_1_1.json"
OUTPUT = HERE / "core_1_1_annotation.json"


def exponent_basis(degree, wanted_weight):
    out = []
    for indices in combinations_with_replacement(range(5), degree):
        exponent = [0] * 5
        for index in indices:
            exponent[index] += 1
        if sum(e * w for e, w in zip(exponent, W)) % 11 == wanted_weight:
            out.append(tuple(exponent))
    return tuple(out)


def rho(exponent, power=1):
    power %= 5
    return tuple(exponent[(j - power) % 5] for j in range(5))


def reconstruct():
    d = r = 1
    a = tuple((d * j) % 5 for j in range(5))
    b = tuple((entry + r) % 5 for entry in a)
    weight_a = sum(x * w for x, w in zip(a, W)) % 11
    weight_b = sum(x * w for x, w in zip(b, W)) % 11
    weight_h = 9 * (1 - weight_a) % 11
    weight_k = 9 * (1 - weight_b) % 11
    basis_h = exponent_basis(ROOT_DEGREE, weight_h)
    basis_k = exponent_basis(ROOT_DEGREE, weight_k)
    support = []
    for index, u in enumerate(basis_h):
        support.append((tuple(a[j] + 5 * u[j] for j in range(5)), index))
    offset = len(basis_h)
    for index, u in enumerate(basis_k):
        support.append((tuple(b[j] + 5 * u[j] for j in range(5)), offset + index))

    equations = defaultdict(lambda: defaultdict(int))
    for shift in range(5):
        current = [(rho(e, shift), c) for e, c in support]
        following = [(rho(e, shift + 1), c) for e, c in support]
        for e1, c1 in current:
            for e2, c2 in current:
                for e3, c3 in following:
                    target = tuple(x + y + z for x, y, z in zip(e1, e2, e3))
                    monomial = tuple(sorted((c1, c2, c3)))
                    equations[target][monomial] = (
                        equations[target][monomial] + 1
                    ) % P
    clean = []
    for target, polynomial in equations.items():
        terms = {m: c for m, c in polynomial.items() if c}
        if terms:
            clean.append((target, terms))
    return a, b, weight_h, weight_k, basis_h, basis_k, tuple(clean)


def variable_entry(variable, basis_h, basis_k):
    if variable < len(basis_h):
        return {
            "variable": variable,
            "name": f"H{variable}",
            "block": "H",
            "root_exponent": list(basis_h[variable]),
        }
    index = variable - len(basis_h)
    return {
        "variable": variable,
        "name": f"K{index}",
        "block": "K",
        "root_exponent": list(basis_k[index]),
    }


def main():
    core = tuple(json.loads(CORE.read_text()))
    assert len(core) == 212 and len(set(core)) == 212
    a, b, wh, wk, basis_h, basis_k, clean = reconstruct()
    assert len(basis_h) == len(basis_k) == 30
    assert len(clean) == 8825
    assert all(0 <= row < len(clean) for row in core)
    variables = [
        variable_entry(variable, basis_h, basis_k)
        for variable in range(len(basis_h) + len(basis_k))
    ]
    by_variable = {entry["variable"]: entry for entry in variables}

    rows = []
    pure_cube_rows = 0
    pure_cube_terms = 0
    core_set = set(core)
    target_to_index = {target: index for index, (target, _) in enumerate(clean)}
    orbit_closed_rows = 0
    orbit_closure = set()
    for row_index in core:
        target, polynomial = clean[row_index]
        terms = []
        pure = []
        for monomial, coefficient in sorted(polynomial.items()):
            entry = {
                "coefficient_variables": list(monomial),
                "coefficient": coefficient,
                "labels": [by_variable[v]["name"] for v in monomial],
            }
            terms.append(entry)
            if len(set(monomial)) == 1:
                pure.append(by_variable[monomial[0]]["name"])
        if pure:
            pure_cube_rows += 1
            pure_cube_terms += len(pure)
        orbit = []
        for shift in range(5):
            shifted = rho(target, shift)
            assert shifted in target_to_index
            orbit.append(target_to_index[shifted])
        orbit_closure.update(orbit)
        if set(orbit) <= core_set:
            orbit_closed_rows += 1
        rows.append(
            {
                "insertion_row_index": row_index,
                "target_exponent": list(target),
                "cyclic_row_orbit": orbit,
                "term_count": len(terms),
                "pure_cube_labels": pure,
                "terms": terms,
            }
        )

    document = {
        "statement": (
            "Exact annotation of the independent one-minimal 212-row "
            "assumption core; the static UNSAT verdict is checked separately "
            "by verify.py."
        ),
        "family": {"d": 1, "r": 1, "root_degree": ROOT_DEGREE},
        "residues": {"a": list(a), "b": list(b)},
        "root_weights": {"H": wh, "K": wk},
        "variables": variables,
        "statistics": {
            "all_nonzero_rows": len(clean),
            "core_rows": len(core),
            "core_rows_containing_pure_cube": pure_cube_rows,
            "pure_cube_terms_in_core": pure_cube_terms,
            "core_rows_whose_full_cyclic_orbit_lies_in_core": orbit_closed_rows,
            "cyclic_orbit_closure_size": len(orbit_closure),
        },
        "rows": rows,
    }
    OUTPUT.write_text(json.dumps(document, indent=2, sort_keys=True) + "\n")
    digest = hashlib.sha256(OUTPUT.read_bytes()).hexdigest()
    stats = document["statistics"]
    print("CORE_ROWS", stats["core_rows"])
    print("PURE_CUBE_ROWS", stats["core_rows_containing_pure_cube"])
    print("PURE_CUBE_TERMS", stats["pure_cube_terms_in_core"])
    print("ORBIT_CLOSED_ROWS", stats["core_rows_whose_full_cyclic_orbit_lies_in_core"])
    print("ORBIT_CLOSURE_SIZE", stats["cyclic_orbit_closure_size"])
    print("ANNOTATION_SHA256", digest)
    print("N7-CORE-1-1-ANNOTATION-OK")


if __name__ == "__main__":
    main()
