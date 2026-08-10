#!/usr/bin/env python3
"""Exact characteristic-5 degree-5 F55 landing-scheme replay.

The faithful module has C11 weights (1,9,4,3,5), and C5 cyclically shifts
the five coordinates.  In characteristic 5 there is only the trivial
projective C5 character.  A homogeneous degree-5 self-covariant is therefore
determined by an arbitrary weight-one polynomial T_0; T_i is its i-th cyclic
translate.  This script constructs the complete coefficient ideal of

    sum_i T_i^2 T_(i+1) = 0

over F_5 and asks Singular for its exact affine dimension.  The ideal is
homogeneous.  Consequently dimension zero is equivalent to the projective
landing scheme being empty: a finite affine cone over an algebraically closed
field consists only of its vertex.
"""

from __future__ import annotations

import hashlib
import re
import subprocess
import tempfile
from pathlib import Path


WEIGHTS = (1, 9, 4, 3, 5)
PRIME = 5
DEGREE = 5
SINGULAR = "/opt/homebrew/bin/Singular"


def compositions(total: int, length: int):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for rest in compositions(total - first, length - 1):
            yield (first,) + rest


def c11_weight(exponents: tuple[int, ...]) -> int:
    return sum(e * w for e, w in zip(exponents, WEIGHTS)) % 11


def shift(exponents: tuple[int, ...], amount: int) -> tuple[int, ...]:
    result = [0] * 5
    for j, exponent in enumerate(exponents):
        result[(j + amount) % 5] = exponent
    return tuple(result)


def add3(a: tuple[int, ...], b: tuple[int, ...], c: tuple[int, ...]):
    return tuple(x + y + z for x, y, z in zip(a, b, c))


def complete_landing_ideal():
    basis = tuple(
        e
        for e in compositions(DEGREE, 5)
        if c11_weight(e) == WEIGHTS[0]
    )
    equations: dict[
        tuple[int, ...], dict[tuple[int, int, int], int]
    ] = {}
    for i in range(5):
        qi = tuple(shift(e, i) for e in basis)
        qnext = tuple(shift(e, i + 1) for e in basis)
        for a, ea in enumerate(qi):
            for b, eb in enumerate(qi):
                for c, ec in enumerate(qnext):
                    source = add3(ea, eb, ec)
                    coefficient = tuple(sorted((a, b, c)))
                    poly = equations.setdefault(source, {})
                    poly[coefficient] = (poly.get(coefficient, 0) + 1) % PRIME
    equations = {
        source: {term: value for term, value in poly.items() if value}
        for source, poly in equations.items()
    }
    equations = {source: poly for source, poly in equations.items() if poly}
    return basis, equations


def singular_poly(poly: dict[tuple[int, int, int], int]) -> str:
    terms = []
    for indices, coefficient in sorted(poly.items()):
        monomial = "*".join(f"c{i}" for i in indices)
        terms.append(f"{coefficient}*{monomial}")
    return "+".join(terms)


def singular_input(basis, equations) -> str:
    variables = ",".join(f"c{i}" for i in range(len(basis)))
    generators = ",".join(singular_poly(poly) for poly in equations.values())
    return (
        f"ring r={PRIME},({variables}),dp;\n"
        f"ideal I={generators};\n"
        "option(redSB);\n"
        "ideal G=std(I);\n"
        'print(\"GB_SIZE=\"+string(size(G)));\n'
        'print(\"DIM=\"+string(dim(G)));\n'
        'print(\"VDIM=\"+string(vdim(G)));\n'
        "quit;\n"
    )


def parse_integer(label: str, output: str) -> int:
    match = re.search(rf"^{label}=(-?\d+)$", output, re.MULTILINE)
    if not match:
        raise RuntimeError(f"Singular output has no {label}:\n{output}")
    return int(match.group(1))


def main() -> None:
    basis, equations = complete_landing_ideal()
    assert len(basis) == 11
    assert basis[5] == (0, 5, 0, 0, 0)  # the forced Frobenius covariant
    assert len(equations) == 350
    assert all(len(term) == 3 for poly in equations.values() for term in poly)

    source = singular_input(basis, equations)
    digest = hashlib.sha256(source.encode()).hexdigest()
    with tempfile.TemporaryDirectory(prefix="f55_char5_degree5_") as temp:
        input_path = Path(temp) / "landing.sing"
        input_path.write_text(source)
        process = subprocess.run(
            [SINGULAR, "-q", str(input_path)],
            check=True,
            text=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
        )

    dimension = parse_integer("DIM", process.stdout)
    vdimension = parse_integer("VDIM", process.stdout)
    gb_size = parse_integer("GB_SIZE", process.stdout)
    print(f"BASIS_SIZE={len(basis)}")
    print(f"EQUATION_COUNT={len(equations)}")
    print(f"INPUT_SHA256={digest}")
    print(f"GB_SIZE={gb_size}")
    print(f"DIM={dimension}")
    print(f"VDIM={vdimension}")
    if dimension == 0:
        print("PROJECTIVE_LANDING_EMPTY=1")
        print("F55-CHAR5-DEGREE5-LANDING-EMPTY")
    else:
        print("PROJECTIVE_LANDING_EMPTY=0")
        print("F55-CHAR5-DEGREE5-LANDING-NONEMPTY-OR-UNRESOLVED")


if __name__ == "__main__":
    main()
