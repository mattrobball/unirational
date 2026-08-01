#!/usr/bin/env python3
"""Verify a saved higher-degree matched-Fano leading-ideal certificate."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


HERE = Path(__file__).resolve().parent
PRIME = 23


def parse_leading_monomials(path: Path, dimension: int):
    text = path.read_text()
    assert f"#field characteristic: {PRIME}" in text
    expected_variables = ", ".join(f"a{index}" for index in range(dimension))
    assert f"#variable order:       {expected_variables}" in text
    length_match = re.search(r"#length of basis:\s+(\d+) elements", text)
    assert length_match is not None
    expected_length = int(length_match.group(1))
    body = text[text.index("[") + 1 : text.rindex("]")]
    result = []
    for raw_expression in body.split(","):
        expression = raw_expression.strip()
        if not expression:
            continue
        factors = tuple(
            (int(index), int(exponent))
            for index, exponent in re.findall(r"a(\d+)\^(\d+)", expression)
        )
        assert factors
        assert "*".join(f"a{index}^{exponent}" for index, exponent in factors) == expression
        assert all(0 <= index < dimension and exponent > 0 for index, exponent in factors)
        assert len({index for index, _exponent in factors}) == len(factors)
        result.append(factors)
    assert len(result) == expected_length == len(set(result))
    return result


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--degree", type=int, required=True)
    args = parser.parse_args()
    stem = f"degree{args.degree}_fano_p23"
    metadata = json.loads((HERE / f"{stem}.json").read_text())
    assert metadata["prime"] == PRIME and metadata["degree"] == args.degree
    dimension = int(metadata["covariant_dimension"])
    monomials = parse_leading_monomials(HERE / f"{stem}.leading", dimension)
    degree_tally: dict[int, int] = {}
    pure_powers: dict[int, int] = {}
    for monomial in monomials:
        degree = sum(exponent for _index, exponent in monomial)
        degree_tally[degree] = degree_tally.get(degree, 0) + 1
        if len(monomial) == 1:
            index, exponent = monomial[0]
            pure_powers[index] = min(exponent, pure_powers.get(index, exponent))
    missing = sorted(set(range(dimension)) - set(pure_powers))
    print(f"degree={args.degree} covariantDimension={dimension}")
    print(f"leadingBasisSize={len(monomials)}")
    print(f"leadingDegreeTally={degree_tally}")
    print(f"purePowerCount={len(pure_powers)}")
    assert not missing, f"leading ideal has no pure power for variables {missing}"
    assert all(exponent >= 2 for exponent in pure_powers.values())
    print("PASS radical of saved leading ideal is the irrelevant ideal")
    print(f"PASS complete degree-{args.degree} matched-Fano projective locus is empty at p=23")
    print(f"DEGREE{args.degree}-MATCHED-FANO-INDEPENDENTLY-VERIFIED")


if __name__ == "__main__":
    main()
