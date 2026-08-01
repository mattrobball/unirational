#!/usr/bin/env python3
"""Exact structural K-point search on the ten three-Kummer planes.

Candidates are obtained by projecting products of the five cyclic factors
R_i to three Kummer coordinates.  This includes Fourier truncations of R_i
and of their norm-adjugates (hence reciprocals up to K-scaling).
"""

from __future__ import annotations

import importlib.util
import itertools
from pathlib import Path


HERE = Path(__file__).resolve().parent
SOURCE = HERE.parent / "h_trace_three_kummer_planes" / "verify.py"
SPEC = importlib.util.spec_from_file_location("three_planes", SOURCE)
THREE = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(THREE)

Qz = THREE.Qz
ZERO = THREE.ZERO
ONE = THREE.ONE
EPS = THREE.EPS


def kclean(poly):
    return {exp: value for exp, value in poly.items() if value}


def kadd(left, right):
    answer = dict(left)
    for exp, value in right.items():
        answer[exp] = answer.get(exp, ZERO) + value
    return kclean(answer)


def kscale(poly, scalar):
    return kclean({exp: value * scalar for exp, value in poly.items()})


def kmul(left, right):
    answer = {}
    for e1, c1 in left.items():
        for e2, c2 in right.items():
            exp = tuple(a + b for a, b in zip(e1, e2))
            answer[exp] = answer.get(exp, ZERO) + c1 * c2
    return kclean(answer)


def kpow(poly, power):
    answer = {(0, 0, 0, 0): ONE}
    base = poly
    while power:
        if power & 1:
            answer = kmul(answer, base)
        base = kmul(base, base)
        power //= 2
    return answer


KONE = {(0, 0, 0, 0): ONE}


def emul(left, right):
    answer = [{} for _ in range(5)]
    for i, pi in enumerate(left):
        for j, pj in enumerate(right):
            if not pi or not pj:
                continue
            degree = i + j
            residue = degree % 5
            carry = degree // 5
            product = kmul(pi, pj)
            if carry:
                product = {tuple(exp[k] + (carry if k == 0 else 0) for k in range(4)): value
                           for exp, value in product.items()}
            answer[residue] = kadd(answer[residue], product)
    return answer


def r_factor(index):
    answer = []
    for degree in range(5):
        exp = [0, 0, 0, 0]
        if degree >= 2:
            exp[degree - 1] = 1
        answer.append({tuple(exp): EPS ** (index * degree)})
    return answer


R = [r_factor(index) for index in range(5)]


def candidate_product(exponents):
    answer = [KONE, {}, {}, {}, {}]
    for index, power in enumerate(exponents):
        for _ in range(power):
            answer = emul(answer, R[index])
    return answer


def cubic_value(components, coords):
    answer = {}
    for counts, coefficient in components.items():
        term = coefficient
        for coordinate, power in zip(coords, counts):
            term = kmul(term, kpow(coordinate, power))
        answer = kadd(answer, term)
    return answer


def primitive_fifth_root(prime):
    for value in range(2, prime):
        if pow(value, 5, prime) == 1 and value != 1:
            return value
    raise ValueError(prime)


def qz_mod(value, prime, root):
    answer = 0
    power = 1
    for coefficient in value.c:
        answer = (answer + coefficient.numerator
                  * pow(coefficient.denominator, -1, prime) * power) % prime
        power = power * root % prime
    return answer


def keval(poly, values, prime, root):
    answer = 0
    for exp, coefficient in poly.items():
        monomial = 1
        for value, power in zip(values, exp):
            monomial = monomial * pow(value, power, prime) % prime
        answer = (answer + qz_mod(coefficient, prime, root) * monomial) % prime
    return answer


def cubic_value_mod(components, coords, values, prime, root):
    coord_values = [keval(coordinate, values, prime, root) for coordinate in coords]
    answer = 0
    for counts, coefficient in components.items():
        term = keval(coefficient, values, prime, root)
        for value, power in zip(coord_values, counts):
            term = term * pow(value, power, prime) % prime
        answer = (answer + term) % prime
    return answer


def signature(poly):
    if not poly:
        return "0"
    mins = tuple(min(exp[i] for exp in poly) for i in range(4))
    normalized = sorted((tuple(exp[i] - mins[i] for i in range(4)), value.c)
                        for exp, value in poly.items())
    # K* multiples are not normalized here; this is only a cheap deduplicator.
    return repr(normalized)


def main():
    triples = list(itertools.combinations(range(5), 3))
    components = {triple: THREE.compact_components(triple) for triple in triples}

    candidates = []
    # All products of distinct R_i: singleton R_i, complement products giving
    # Norm(R)/R_i, and intermediate cyclic products.
    for mask in range(1, 32):
        exponents = tuple((mask >> i) & 1 for i in range(5))
        candidates.append((f"subset_{mask:02x}", exponents, candidate_product(exponents)))
    # Small repeated-factor products around the distinguished H=R2*R3^2.
    for exponents in itertools.product(range(3), repeat=5):
        if not 1 <= sum(exponents) <= 5:
            continue
        if max(exponents) < 2:
            continue
        candidates.append(("powers_" + "".join(map(str, exponents)), exponents,
                           candidate_product(exponents)))

    screens = []
    for prime, value_sets in [
        (11, [(2, 3, 5, 7), (7, 2, 6, 8)]),
        (31, [(2, 3, 5, 7), (11, 13, 17, 19)]),
    ]:
        root = primitive_fifth_root(prime)
        for values in value_sets:
            screens.append((prime, root, values))

    seen = set()
    tested = 0
    sparse_exact = []
    hits = []
    for name, exponents, element in candidates:
        nonzero = tuple(i for i, coefficient in enumerate(element) if coefficient)
        if len(nonzero) <= 3:
            sparse_exact.append((name, exponents, nonzero))
        for triple in triples:
            coords = tuple(element[index] for index in triple)
            if any(not coordinate for coordinate in coords):
                continue
            key = (triple, tuple(signature(coordinate) for coordinate in coords))
            if key in seen:
                continue
            seen.add(key)
            tested += 1
            if any(cubic_value_mod(components[triple], coords, values, prime, root)
                   for prime, root, values in screens):
                continue
            print("MODULAR_SURVIVOR", name, exponents, triple)
            value = cubic_value(components[triple], coords)
            if not value:
                hits.append((name, exponents, triple))
                print("POINT", name, exponents, triple)

    print("CANDIDATES", len(candidates))
    print("PROJECTED_TRIPLES_TESTED", tested)
    print("EXACT_SPARSE_PRODUCTS", sparse_exact)
    print("POINTS_FOUND", len(hits))
    if not hits:
        print("STRUCTURAL_PRODUCT_PROJECTION_SEARCH_NO_HIT")


if __name__ == "__main__":
    main()
