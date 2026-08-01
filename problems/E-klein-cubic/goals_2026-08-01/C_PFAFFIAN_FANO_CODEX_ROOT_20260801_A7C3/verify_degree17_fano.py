#!/usr/bin/env python3
"""Independently verify a saved degree-17 msolve leading-ideal certificate.

The projective-zero-locus test does not need a full Hilbert-function
enumeration.  A homogeneous monomial ideal has empty projective locus exactly
when its radical is the irrelevant ideal.  Thus it is enough to find a pure
power of every coefficient variable among the saved leading monomials.
"""

from __future__ import annotations

import re
from pathlib import Path


HERE = Path(__file__).resolve().parent
LEADING = HERE / "degree17_fano_p23.leading"
PRIME = 23
DIMENSION = 98


def parse_leading_monomials(path: Path) -> tuple[int, list[tuple[tuple[int, int], ...]]]:
    text = path.read_text()
    assert f"#field characteristic: {PRIME}" in text
    expected_variables = ", ".join(f"a{index}" for index in range(DIMENSION))
    assert f"#variable order:       {expected_variables}" in text
    length_match = re.search(r"#length of basis:\s+(\d+) elements", text)
    assert length_match is not None
    expected_length = int(length_match.group(1))
    body = text[text.index("[") + 1 : text.rindex("]")]
    monomials: list[tuple[tuple[int, int], ...]] = []
    for raw_expression in body.split(","):
        expression = raw_expression.strip()
        if not expression:
            continue
        factors = tuple(
            (int(raw_index), int(raw_exponent))
            for raw_index, raw_exponent in re.findall(r"a(\d+)\^(\d+)", expression)
        )
        assert factors
        assert "*".join(f"a{index}^{exponent}" for index, exponent in factors) == expression
        assert all(0 <= index < DIMENSION and exponent > 0 for index, exponent in factors)
        assert len({index for index, _exponent in factors}) == len(factors)
        monomials.append(factors)
    assert len(monomials) == expected_length
    assert len(set(monomials)) == expected_length
    return expected_length, monomials


def main() -> None:
    length, monomials = parse_leading_monomials(LEADING)
    degree_tally: dict[int, int] = {}
    pure_powers: dict[int, int] = {}
    for monomial in monomials:
        degree = sum(exponent for _index, exponent in monomial)
        degree_tally[degree] = degree_tally.get(degree, 0) + 1
        if len(monomial) == 1:
            index, exponent = monomial[0]
            pure_powers[index] = min(exponent, pure_powers.get(index, exponent))
    missing = sorted(set(range(DIMENSION)) - set(pure_powers))
    print(f"leadingBasisSize={length}")
    print(f"leadingDegreeTally={degree_tally}")
    print(f"purePowerCount={len(pure_powers)}")
    assert not missing, f"leading ideal has no pure power for variables {missing}"
    assert all(exponent >= 2 for exponent in pure_powers.values())
    print("PASS radical of saved leading ideal is the irrelevant ideal")
    print("PASS complete degree-17 matched-Fano projective locus is empty at p=23")
    print("DEGREE17-MATCHED-FANO-INDEPENDENTLY-VERIFIED")


if __name__ == "__main__":
    main()
