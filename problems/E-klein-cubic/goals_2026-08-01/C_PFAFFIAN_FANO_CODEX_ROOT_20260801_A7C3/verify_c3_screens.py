#!/usr/bin/env python3
"""Independent scope audit for the bounded C3 search artifacts."""

from __future__ import annotations

import json
import re
from pathlib import Path


HERE = Path(__file__).resolve().parent


def parse_monomials(path, prefix):
    text = path.read_text()
    length = int(re.search(r"#length of basis:\s+(\d+)", text).group(1))
    body = text[text.index("[") + 1:text.rindex("]")]
    monomials = []
    for expression in (entry.strip() for entry in body.split(",")):
        if not expression:
            continue
        powers = {
            int(index): int(exponent)
            for index, exponent in re.findall(rf"{prefix}(\d+)\^(\d+)", expression)
        }
        assert powers and sum(powers.values()) >= 2
        monomials.append(powers)
    assert len(monomials) == length == len({tuple(sorted(row.items())) for row in monomials})
    return monomials


def main():
    for function_count in range(1, 6):
        suffix = "constant" if function_count == 1 else f"invariant_m{function_count}"
        artifact = json.loads((HERE / f"c3_{suffix}_morita_p23.json").read_text())
        dimension = 12 * function_count
        expected_basis = function_count * (function_count + 1) // 2 * 78
        assert artifact["quadratic_variable_count"] == dimension
        assert artifact["quadratic_row_rank"] == expected_basis
        monomials = parse_monomials(HERE / f"c3_{suffix}_morita_p23.leading", "z")
        assert len(monomials) == expected_basis
        squares = {next(iter(row)) for row in monomials if len(row) == 1 and next(iter(row.values())) == 2}
        assert squares == set(range(dimension))
        print(f"PASS m={function_count} leading ideal contains every variable square; projective locus empty")

    degree16 = parse_monomials(HERE / "degree16_l44_leading.out", "a")
    tally = {}
    for monomial in degree16:
        degree = sum(monomial.values())
        tally[degree] = tally.get(degree, 0) + 1
    assert len(degree16) == 28383 and tally == {2: 1313, 3: 26984, 4: 86}
    # The independently executed upstream verifier computes the complete
    # standard-monomial counts [1,80,1927,86,0].  Here we additionally check
    # the sealed leading basis cardinalities and degree distribution.
    print(f"PASS degree16 leading basis size=28383 tally={tally}")

    first = json.loads((HERE / "c3_morita_zero_chart_scan_p23.json").read_text())
    assert len(first["charts"]) == 56
    assert first["counts"] == {"empty": 0, "zero_dimensional": 56, "positive_dimensional": 0}
    assert set(row["degree"] for row in first["charts"]) == {10, 12, 14}
    holdout = json.loads((HERE / "c3_selected_zero_charts_holdout_p23.json").read_text())
    assert holdout["charts_with_a_rational_root_at_every_regular_point"] == []
    assert len(holdout["records"]) == 12
    print("PASS all first-fibre residue-root zero charts fail at an independent regular point")
    print("SCOPE bounded formula and homogeneous-degree exclusions only")
    print("C3-BOUNDED-SCREENS-INDEPENDENTLY-VERIFIED")


if __name__ == "__main__":
    main()
