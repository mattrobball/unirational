#!/usr/bin/env python3
"""Independently compute Hilbert functions of saved ambient leading ideals."""

from __future__ import annotations

import argparse
import json
import re
from collections import Counter
from pathlib import Path


HERE = Path(__file__).resolve().parent
SHARED = HERE.parent / "C_PFAFFIAN_FANO"


def parse(path: Path) -> tuple[int, int, set[tuple[int, ...]]]:
    text = path.read_text()
    prime = int(re.search(r"#field characteristic:\s+(\d+)", text).group(1))
    variables = re.search(r"#variable order:\s+([^\n]+)", text).group(1).split(", ")
    claimed = int(re.search(r"#length of basis:\s+(\d+) elements", text).group(1))
    start, stop = text.index("[") + 1, text.rindex("]")
    monomials: set[tuple[int, ...]] = set()
    for expression in text[start:stop].split(","):
        expression = expression.strip()
        if not expression:
            continue
        exponent = [0] * len(variables)
        factors = re.findall(r"a(\d+)\^(\d+)", expression)
        assert factors and "*".join(f"a{i}^{e}" for i, e in factors) == expression
        for raw_i, raw_e in factors:
            exponent[int(raw_i)] = int(raw_e)
        monomials.add(tuple(exponent))
    assert len(monomials) == claimed
    return prime, len(variables), monomials


def hilbert(leads: set[tuple[int, ...]], variables: int, maximum: int) -> list[int]:
    zero = (0,) * variables
    standard = {zero}
    values = [1]
    for _degree in range(1, maximum + 1):
        raw_candidates: set[tuple[int, ...]] = set()
        for monomial in standard:
            for index in range(variables):
                candidate = list(monomial)
                candidate[index] += 1
                raw_candidates.add(tuple(candidate))
        candidates: set[tuple[int, ...]] = set()
        for candidate in raw_candidates:
            if candidate in leads:
                continue
            # A monomial outside a monomial ideal has every immediate divisor
            # outside it.  Conversely, if a proper leading generator divides
            # the candidate, removing a variable from the quotient produces a
            # nonstandard immediate divisor.
            all_predecessors_standard = True
            for index, exponent in enumerate(candidate):
                if exponent:
                    predecessor = list(candidate)
                    predecessor[index] -= 1
                    if tuple(predecessor) not in standard:
                        all_predecessors_standard = False
                        break
            if all_predecessors_standard:
                candidates.add(candidate)
        standard = candidates
        values.append(len(standard))
    return values


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--max-degree", type=int, default=8)
    args = parser.parse_args()
    records = []
    for degree in range(9, 13):
        path = SHARED / f"ambient_degree{degree}_leading.out"
        prime, variables, leads = parse(path)
        values = hilbert(leads, variables, args.max_degree)
        record = {
            "covariant_degree": degree,
            "prime": prime,
            "variables": variables,
            "leading_basis_size": len(leads),
            "leading_degree_tally": dict(sorted(Counter(map(sum, leads)).items())),
            "hilbert_function": values,
        }
        records.append(record)
        print(json.dumps(record, sort_keys=True), flush=True)
    (HERE / "ambient_leading_audit.json").write_text(
        json.dumps({
            "format": "ambient-leading-hilbert-audit-v1",
            "scope": "mod-23 auxiliary ambient projector schemes only",
            "records": records,
            "theorem_boundary": (
                "Hilbert functions of modular initial ideals do not construct a "
                "characteristic-zero projector and do not impose the Fano section"
            ),
        }, indent=2) + "\n"
    )
    print("AMBIENT-LEADING-HILBERT-AUDITED")


if __name__ == "__main__":
    main()
