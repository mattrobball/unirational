#!/usr/bin/env python3
"""Audit a complete msolve leading ideal for a degree-six 11:5 system."""

from __future__ import annotations

import argparse
import hashlib
import json
import re
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
DIMENSION = 19


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def parse_leads(path: Path, prime: int) -> list[tuple[int, ...]]:
    text = path.read_text()
    assert f"#field characteristic: {prime}" in text
    variables = re.search(r"#variable order:\s+([^\n]+)", text)
    assert variables is not None
    assert [value.strip() for value in variables.group(1).split(",")] == [
        f"c{index}" for index in range(DIMENSION)
    ]
    length = re.search(r"#length of basis:\s+(\d+) elements", text)
    assert length is not None
    start, stop = text.index("[") + 1, text.rindex("]")
    expressions = [part.strip() for part in text[start:stop].split(",")]
    expressions = [expression for expression in expressions if expression]
    leads = []
    for expression in expressions:
        exponents = [0] * DIMENSION
        factors = re.findall(r"c(\d+)\^(\d+)", expression)
        assert factors
        assert "*".join(f"c{i}^{e}" for i, e in factors) == expression
        for raw_coordinate, raw_exponent in factors:
            coordinate, exponent = int(raw_coordinate), int(raw_exponent)
            assert 0 <= coordinate < DIMENSION and exponent > 0
            assert exponents[coordinate] == 0
            exponents[coordinate] = exponent
        leads.append(tuple(exponents))
    assert len(leads) == int(length.group(1)) == len(set(leads))
    return leads


def divides(left: tuple[int, ...], right: tuple[int, ...]) -> bool:
    return all(a <= b for a, b in zip(left, right))


def hilbert_function(
    leads: list[tuple[int, ...]], max_degree: int
) -> tuple[list[int], bool]:
    """Enumerate standard monomials degree by degree without ambient expansion."""
    current = {(0,) * DIMENSION}
    values = [1]
    for _degree in range(1, max_degree + 1):
        candidates = set()
        for monomial in current:
            for coordinate in range(DIMENSION):
                product = list(monomial)
                product[coordinate] += 1
                candidates.add(tuple(product))
        current = {
            monomial
            for monomial in candidates
            if not any(divides(lead, monomial) for lead in leads)
        }
        values.append(len(current))
        if not current:
            return values, True
    return values, False


def audit(character: int, prime: int, max_degree: int) -> dict[str, object]:
    source = HERE / f"degree6_chi{character}_p{prime}.in"
    leading = HERE / f"degree6_chi{character}_p{prime}_leading.out"
    assert source.is_file() and leading.is_file() and leading.stat().st_size > 0
    leads = parse_leads(leading, prime)
    pure_powers: dict[int, int] = {}
    for lead in leads:
        support = [index for index, exponent in enumerate(lead) if exponent]
        if len(support) == 1:
            coordinate = support[0]
            pure_powers[coordinate] = min(
                pure_powers.get(coordinate, lead[coordinate]), lead[coordinate]
            )
    hilbert, reached_zero = hilbert_function(leads, max_degree)
    zero_dimensional = len(pure_powers) == DIMENSION
    assert not reached_zero or zero_dimensional
    if zero_dimensional:
        status = "empty_projective_scheme"
    else:
        status = "nonempty_projective_scheme_over_algebraic_closure"
    result = {
        "schema": "klein-f55-degree6-leading-audit-v1",
        "degree": 6,
        "character_mod_5": character,
        "prime": prime,
        "variables": DIMENSION,
        "input_file": source.name,
        "input_sha256": sha256(source),
        "leading_file": leading.name,
        "leading_sha256": sha256(leading),
        "leading_monomials": len(leads),
        "leading_degree_tally": dict(sorted(Counter(map(sum, leads)).items())),
        "pure_power_exponents": {
            str(index): pure_powers[index] for index in sorted(pure_powers)
        },
        "zero_dimensional_affine_quotient": zero_dimensional,
        "hilbert_function": hilbert,
        "hilbert_reached_zero": reached_zero,
        "hilbert_cutoff": max_degree,
        "status": status,
    }
    output = HERE / f"degree6_chi{character}_p{prime}_result.json"
    output.write_text(json.dumps(result, indent=2, sort_keys=True) + "\n")
    return result


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("character", type=int, choices=range(5))
    parser.add_argument("--prime", type=int, choices=(23, 331), default=331)
    parser.add_argument("--max-degree", type=int, default=64)
    arguments = parser.parse_args()
    assert arguments.prime == 331 or arguments.character == 0
    assert 1 <= arguments.max_degree <= 256
    result = audit(arguments.character, arguments.prime, arguments.max_degree)
    print(json.dumps(result, indent=2, sort_keys=True))
    print("Q_F55_DEGREE6_LEADING_IDEAL_AUDIT_EXACT")


if __name__ == "__main__":
    main()
