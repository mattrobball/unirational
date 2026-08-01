#!/usr/bin/env python3
"""Generate the complete degree-nine H=11:5 landing support instance.

The binary instance records only coefficient-monomial supports, which is
exactly the data needed for the singleton deletion theorem.  Coefficients
are nevertheless expanded at the split good prime 331 for all five C5
projective characters, and their term-support hashes are checked equal.
"""
from __future__ import annotations

import hashlib
import json
import struct
import argparse
from pathlib import Path

HERE = Path(__file__).resolve().parent
P = 331
WEIGHTS = (1, 9, 4, 3, 5)
DEGREE = 9


def compositions(total: int, length: int):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for tail in compositions(total - first, length - 1):
            yield (first,) + tail


def shift(exponents, amount):
    result = [0] * 5
    for index, exponent in enumerate(exponents):
        result[(index + amount) % 5] = exponent
    return tuple(result)


def covariant_basis():
    return tuple(
        exponents
        for exponents in compositions(DEGREE, 5)
        if sum(e * w for e, w in zip(exponents, WEIGHTS)) % 11 == 1
    )


def landing_equations(character: int):
    basis = covariant_basis()
    root5 = 64
    assert pow(root5, 5, P) == 1 and root5 != 1
    scales = [pow(root5, character * index, P) for index in range(5)]
    equations = {}
    for index in range(5):
        current = [shift(exponents, index) for exponents in basis]
        following = [shift(exponents, index + 1) for exponents in basis]
        scalar = (
            scales[index]
            * scales[index]
            * scales[(index + 1) % 5]
        ) % P
        for a, ea in enumerate(current):
            for b, eb in enumerate(current):
                for c, ec in enumerate(following):
                    source = tuple(x + y + z for x, y, z in zip(ea, eb, ec))
                    coefficient_term = tuple(sorted((a, b, c)))
                    polynomial = equations.setdefault(source, {})
                    polynomial[coefficient_term] = (
                        polynomial.get(coefficient_term, 0) + scalar
                    ) % P
    return {
        source: {term: value for term, value in polynomial.items() if value}
        for source, polynomial in equations.items()
        if any(polynomial.values())
    }


def term_support_hash(equations):
    digest = hashlib.sha256()
    for source in sorted(equations):
        digest.update(
            (str(source) + ":" + str(sorted(equations[source])) + "\n").encode()
        )
    return digest.hexdigest()


def encode_instance(equations):
    basis = covariant_basis()
    result = bytearray(struct.pack("<II", len(basis), len(equations)))
    for polynomial in equations.values():
        result.extend(struct.pack("<I", len(polynomial)))
        for term in polynomial:
            low = high = 0
            for variable in set(term):
                if variable < 64:
                    low |= 1 << variable
                else:
                    high |= 1 << (variable - 64)
            result.extend(struct.pack("<QQ", low, high))
    return bytes(result)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        type=Path,
        default=HERE / "degree9.instance",
        help="generated binary path (the 11 MB binary is reproducible, not source)",
    )
    args = parser.parse_args()
    all_equations = {character: landing_equations(character) for character in range(5)}
    hashes = {
        character: term_support_hash(equations)
        for character, equations in all_equations.items()
    }
    assert len(set(hashes.values())) == 1
    characteristic_zero_support = all_equations[0]
    raw = encode_instance(characteristic_zero_support)
    output = args.output
    output.write_bytes(raw)
    summary = {
        "coefficient_dimension": len(covariant_basis()),
        "equation_count": len(characteristic_zero_support),
        "coefficient_term_count": sum(
            len(polynomial) for polynomial in characteristic_zero_support.values()
        ),
        "term_support_hashes_by_character": hashes,
        "instance_bytes": len(raw),
        "instance_sha256": hashlib.sha256(raw).hexdigest(),
    }
    (HERE / "generated_summary.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True) + "\n"
    )
    assert summary == {
        "coefficient_dimension": 65,
        "equation_count": 2860,
        "coefficient_term_count": 697125,
        "term_support_hashes_by_character": {
            character: "15e485e551f520f7f971038308c6f7a2bee3e28cd58535c2b7a9ac8058a30bcb"
            for character in range(5)
        },
        "instance_bytes": 11165448,
        "instance_sha256": "6d76ef7393f5a03131787ec149b9e6f3c43d39464befac19c8bebe312730be03",
    }
    print("WROTE", output)
    print("D9_VARIABLES=65 D9_EQUATIONS=2860 D9_TERMS=697125")
    print("D9_INSTANCE_SHA256=" + summary["instance_sha256"])
    print("F55_DEGREE9_INSTANCE_REGENERATED_OK")


if __name__ == "__main__":
    main()
