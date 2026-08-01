#!/usr/bin/env python3
"""Build complete homogeneous covariant landing equations for 11:5.

In an order-eleven eigenbasis the Klein representation has weights
(1,9,4,3,5), an order-five generator cyclically permutes the coordinates,
and the Klein form is sum q_i^2 q_{i+1}.  A degree-d covariant is determined
by its weight-one first coordinate; the other coordinates are its cyclic
translates.  This script constructs the *complete* coefficient scheme over
QQ (or writes it in Singular syntax) without sampling source points.
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path


WEIGHTS = (1, 9, 4, 3, 5)


def compositions(total: int, length: int):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, length - 1):
            yield (first,) + rest


def weight(exponents: tuple[int, ...]) -> int:
    return sum(e * w for e, w in zip(exponents, WEIGHTS)) % 11


def shift(exponents: tuple[int, ...], amount: int) -> tuple[int, ...]:
    """Translate x_j to x_(j+amount)."""
    result = [0] * 5
    for j, exponent in enumerate(exponents):
        result[(j + amount) % 5] = exponent
    return tuple(result)


def add_exp(left: tuple[int, ...], right: tuple[int, ...]) -> tuple[int, ...]:
    return tuple(a + b for a, b in zip(left, right))


def equations(degree: int, character: int = 0, prime: int = 0):
    basis = tuple(e for e in compositions(degree, 5) if weight(e) == WEIGHTS[0])
    coefficient_polynomials: dict[tuple[int, ...], dict[tuple[int, int, int], int]] = {}
    if prime and character:
        root5 = next(
            value
            for value in range(2, prime)
            if pow(value, 5, prime) == 1 and value != 1
        )
        scales = [pow(root5, character * i, prime) for i in range(5)]
    elif prime:
        scales = [1] * 5
    else:
        if character:
            raise ValueError("nontrivial characters require a split finite prime")
        scales = [1] * 5
    # q_i is the i-th cyclic translate of the first coordinate.  Expand
    # sum_i q_i^2 q_(i+1), recording cubic coefficient monomials c_a c_b c_c.
    for i in range(5):
        qi = [shift(e, i) for e in basis]
        qnext = [shift(e, i + 1) for e in basis]
        for a, ea in enumerate(qi):
            for b, eb in enumerate(qi):
                for c, ec in enumerate(qnext):
                    source_monomial = add_exp(add_exp(ea, eb), ec)
                    coeff_monomial = tuple(sorted((a, b, c)))
                    record = coefficient_polynomials.setdefault(source_monomial, {})
                    scalar = scales[i] * scales[i] * scales[(i + 1) % 5]
                    if prime:
                        scalar %= prime
                    record[coeff_monomial] = record.get(coeff_monomial, 0) + scalar
    # Remove coefficient equations that cancel identically (none are assumed).
    coefficient_polynomials = {
        source: {
            term: (value % prime if prime else value)
            for term, value in poly.items()
            if (value % prime if prime else value)
        }
        for source, poly in coefficient_polynomials.items()
    }
    coefficient_polynomials = {
        source: poly for source, poly in coefficient_polynomials.items() if poly
    }
    return basis, coefficient_polynomials


def singular_polynomial(poly: dict[tuple[int, int, int], int]) -> str:
    terms = []
    for indices, value in sorted(poly.items()):
        monomial = "*".join(f"c{i}" for i in indices)
        terms.append(f"{value}*{monomial}")
    return "+".join(terms) or "0"


def write_singular(
    degree: int, output: Path, character: int = 0, prime: int = 0
) -> dict:
    basis, polys = equations(degree, character=character, prime=prime)
    variables = ",".join(f"c{i}" for i in range(len(basis)))
    entries = [singular_polynomial(poly) for poly in polys.values()]
    if not entries:
        entries = ["0"]
    text = (
        f"ring r={prime},({variables}),dp;\n"
        f"ideal I={','.join(entries)};\n"
        "option(redSB);\n"
        "ideal G=std(I);\n"
        'print("BASIS_SIZE="+string(size(G)));\n'
        'print("DIM="+string(dim(G)));\n'
        'print("VDIM="+string(vdim(G)));\n'
        "quit;\n"
    )
    output.write_text(text)
    return {
        "degree": degree,
        "character_mod_5": character,
        "character_root_prime": prime,
        "covariant_dimension": len(basis),
        "coefficient_equations": len(polys),
        "basis": [list(e) for e in basis],
        "singular_input": str(output),
    }


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("degrees", nargs="+", type=int)
    parser.add_argument("--directory", type=Path, default=Path(__file__).resolve().parent)
    parser.add_argument("--prime", type=int, default=0)
    parser.add_argument("--characters", type=int, nargs="*", default=[0])
    args = parser.parse_args()
    summaries = []
    for degree in args.degrees:
        for character in args.characters:
            suffix = f"_chi{character}_p{args.prime}" if args.prime else ""
            output = args.directory / f"f55_degree{degree}{suffix}.sing"
            summary = write_singular(
                degree, output, character=character, prime=args.prime
            )
            summaries.append(summary)
            print(json.dumps(summary, sort_keys=True))
    suffix = f"_p{args.prime}" if args.prime else ""
    (args.directory / f"f55_covariant_inputs{suffix}.json").write_text(
        json.dumps(summaries, indent=2, sort_keys=True) + "\n"
    )


if __name__ == "__main__":
    main()
