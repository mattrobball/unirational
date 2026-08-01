#!/usr/bin/env python3
"""CRT reconstruction of the exact triangular degree-11 landing point."""

from __future__ import annotations

from pathlib import Path
import json
import re
import sys

import sympy as sp
from sympy.polys.domains import ZZ
from sympy.polys.modulargcd import _integer_rational_reconstruction


HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(HERE))
import modular_reconstruct as modular  # noqa: E402


A1, A2, A3, A4 = sp.symbols("a1 a2 a3 a4")


def relation_vector(output, prime):
    lines = re.findall(r"^J\[\d+\]=(.*)$", output, flags=re.MULTILINE)
    if len(lines) != 4:
        raise ValueError(f"unexpected Singular basis with {len(lines)} elements")
    expressions = [sp.sympify(line.replace("^", "**")) for line in lines]
    p = sp.Poly(expressions[0], A4, modulus=prime).monic()
    if p.degree() != 3:
        raise ValueError("eliminant is not cubic")

    coefficient_a3 = sp.Poly(expressions[1], A3).coeff_monomial(A3)
    if int(coefficient_a3) % prime != 1:
        raise ValueError("a3 relation is not monic linear")
    tail3 = sp.Poly(expressions[1].subs(A3, 0), A4, modulus=prime).rem(p)
    solution3 = -tail3

    substituted2 = sp.expand(expressions[2].subs(A3, solution3.as_expr()))
    coefficient_a2 = sp.Poly(substituted2, A2).coeff_monomial(A2)
    if int(coefficient_a2) % prime != 1:
        raise ValueError("a2 relation is not monic linear")
    tail2 = sp.Poly(substituted2.subs(A2, 0), A4, modulus=prime).rem(p)
    solution2 = -tail2

    substituted1 = sp.expand(
        expressions[3].subs({A3: solution3.as_expr(), A2: solution2.as_expr()})
    )
    coefficient_a1 = sp.Poly(substituted1, A1).coeff_monomial(A1)
    if int(coefficient_a1) % prime != 1:
        raise ValueError("a1 relation is not monic linear")
    tail1 = sp.Poly(substituted1.subs(A1, 0), A4, modulus=prime).rem(p)
    solution1 = -tail1

    def coefficients(poly, degrees):
        return [int(poly.coeff_monomial(A4 ** degree)) % prime for degree in degrees]

    # p=a4^3+p2*a4^2+p1*a4+p0; ai=sum cij*a4^j, j=0,1,2.
    return (
        coefficients(p, (2, 1, 0))
        + coefficients(solution1, (0, 1, 2))
        + coefficients(solution2, (0, 1, 2))
        + coefficients(solution3, (0, 1, 2))
    )


def components_from_embeddings(values, prime, sqrt5, sqrt_minus11):
    inverse4 = pow(4, -1, prime)
    output = []
    for position in range(len(next(iter(values.values())))):
        def value(es, er):
            return values[es, er][position] % prime
        total = sum(value(es, er) for es in (1, -1) for er in (1, -1))
        sqrt_total = sum(es * value(es, er) for es in (1, -1) for er in (1, -1))
        radical_total = sum(er * value(es, er) for es in (1, -1) for er in (1, -1))
        product_total = sum(es * er * value(es, er) for es in (1, -1) for er in (1, -1))
        output.extend((
            total * inverse4 % prime,
            sqrt_total * inverse4 * pow(sqrt5, -1, prime) % prime,
            radical_total * inverse4 * pow(sqrt_minus11, -1, prime) % prime,
            product_total * inverse4 * pow(sqrt5 * sqrt_minus11 % prime, -1, prime) % prime,
        ))
    return output


def prime_data(prime):
    roots5 = sp.sqrt_mod(5, prime, all_roots=True)
    roots11 = sp.sqrt_mod(-11, prime, all_roots=True)
    if not roots5 or not roots11 or prime in (2, 3, 5, 11):
        return None
    sqrt5, sqrt_minus11 = int(roots5[0]), int(roots11[0])
    embeddings = {}
    for es in (1, -1):
        for er in (1, -1):
            output = modular.singular_groebner(
                prime, es * sqrt5 % prime, er * sqrt_minus11 % prime
            )
            embeddings[es, er] = relation_vector(output, prime)
    return components_from_embeddings(embeddings, prime, sqrt5, sqrt_minus11)


def crt_update(residues, modulus, values, prime):
    if modulus == 1:
        return list(values), prime
    inverse = pow(modulus % prime, -1, prime)
    updated = [
        residue + modulus * ((value - residue) * inverse % prime)
        for residue, value in zip(residues, values)
    ]
    return updated, modulus * prime


def rational_reconstruct(residue, modulus):
    value = _integer_rational_reconstruction(ZZ(residue), ZZ(modulus), ZZ)
    if value is None:
        return None
    return sp.Rational(int(value.numerator), int(value.denominator))


def main():
    residues = [0] * (12 * 4)
    modulus = 1
    used_primes = []
    for prime in list(sp.primerange(67, 5000)):
        if len(used_primes) >= 96:
            break
        try:
            values = prime_data(prime)
        except (AssertionError, ValueError, ZeroDivisionError) as error:
            print("skip", prime, type(error).__name__, str(error), flush=True)
            continue
        if values is None:
            continue
        residues, modulus = crt_update(residues, modulus, values, prime)
        used_primes.append(prime)
        reconstruction = [rational_reconstruct(value, modulus) for value in residues]
        print(
            "prime", prime,
            "count", len(used_primes),
            "modulus_bits", modulus.bit_length(),
            "reconstructed", sum(value is not None for value in reconstruction),
            flush=True,
        )

    reconstruction = [rational_reconstruct(value, modulus) for value in residues]
    if any(value is None for value in reconstruction):
        raise AssertionError("rational reconstruction incomplete")
    names = ("p2", "p1", "p0") + tuple(
        f"a{coordinate}_{degree}"
        for coordinate in (1, 2, 3)
        for degree in (0, 1, 2)
    )
    payload = {
        "basis": ["1", "sqrt5", "sqrt_minus11", "sqrt5*sqrt_minus11"],
        "field_relations": ["sqrt5^2=5", "sqrt_minus11^2=-11"],
        "used_primes": used_primes,
        "crt_modulus": str(modulus),
        "relations": {
            name: [str(reconstruction[4 * index + component]) for component in range(4)]
            for index, name in enumerate(names)
        },
    }
    path = HERE / "degree11_reconstructed_relations.json"
    path.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")
    print("wrote", path)


if __name__ == "__main__":
    main()
