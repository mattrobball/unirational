#!/usr/bin/env python3
"""Exact coefficient reconstruction for the fixed three-residue pattern.

All arithmetic in the coefficient dictionaries is reduced modulo five.
The two expansion routines deliberately use different multiplication models:
``unordered_expansion`` uses Sym^2 with its off-diagonal factor two, while
``ordered_expansion`` literally multiplies two ordered copies of the current
coordinate.  Equality of their cleaned dictionaries is therefore an
independent reconstruction check, not a comparison of stored solver input.
"""

from __future__ import annotations

from collections import Counter, defaultdict
from hashlib import sha256
from itertools import combinations_with_replacement


P = 5
W = (1, 9, 4, 3, 5)
A = (
    (4, 0, 4, 1, 1),
    (0, 4, 1, 1, 4),
    (0, 0, 3, 4, 3),
)
ROOT_WEIGHTS = (10, 3, 10)


def basis(degree: int, wanted_weight: int):
    result = []
    for indices in combinations_with_replacement(range(5), degree):
        exponent = tuple(indices.count(j) for j in range(5))
        if sum(exponent[j] * W[j] for j in range(5)) % 11 == wanted_weight:
            result.append(exponent)
    return tuple(result)


def rho(exponent, power: int):
    return tuple(exponent[(j - power) % 5] for j in range(5))


def add3(a, b, c):
    return tuple(a[j] + b[j] + c[j] for j in range(5))


def variables(degree: int):
    data = []
    groups = []
    for block, (residue, wanted_weight) in enumerate(zip(A, ROOT_WEIGHTS)):
        ids = []
        for root_exponent in basis(degree, wanted_weight):
            variable_id = len(data)
            full_exponent = tuple(
                residue[j] + 5 * root_exponent[j] for j in range(5)
            )
            assert sum(full_exponent) == 10 + 5 * degree
            assert sum(full_exponent[j] * W[j] for j in range(5)) % 11 == 1
            data.append((block, root_exponent, full_exponent))
            ids.append(variable_id)
        groups.append(tuple(ids))
    return tuple(data), tuple(groups)


def clean(raw):
    result = {}
    for source, polynomial in raw.items():
        cleaned = tuple(
            sorted(
                (monomial, coefficient % P)
                for monomial, coefficient in polynomial.items()
                if coefficient % P
            )
        )
        if cleaned:
            result[source] = cleaned
    return result


def unordered_expansion(variable_data):
    """Primary exact expansion using unordered square pairs."""
    exponents = tuple(item[2] for item in variable_data)
    shifted = tuple(
        tuple(rho(exponent, shift) for exponent in exponents)
        for shift in range(5)
    )
    raw = defaultdict(lambda: defaultdict(int))
    for shift in range(5):
        current = shifted[shift]
        following = shifted[(shift + 1) % 5]
        for j, left_j in enumerate(current):
            for k in range(j, len(current)):
                factor = 1 if j == k else 2
                left_k = current[k]
                for ell, right in enumerate(following):
                    source = add3(left_j, left_k, right)
                    monomial = tuple(sorted((j, k, ell)))
                    raw[source][monomial] += factor
    return clean(raw)


def ordered_expansion(variable_data):
    """Independent exact expansion by literal ordered multiplication."""
    exponents = tuple(item[2] for item in variable_data)
    shifted = tuple(
        tuple(rho(exponent, shift) for exponent in exponents)
        for shift in range(5)
    )
    raw = defaultdict(lambda: defaultdict(int))
    for shift in range(5):
        current = shifted[shift]
        following = shifted[(shift + 1) % 5]
        for j, left_j in enumerate(current):
            for k, left_k in enumerate(current):
                for ell, right in enumerate(following):
                    source = add3(left_j, left_k, right)
                    monomial = tuple(sorted((j, k, ell)))
                    raw[source][monomial] += 1
    return clean(raw)


def support_rows(polynomial_rows):
    all_rows = []
    for polynomial in polynomial_rows.values():
        # Multiplicity is intentional: a^2*b and a*b^2 are distinct
        # coefficient monomials even though they have the same Boolean mask.
        all_rows.append(
            tuple(
                sorted(
                    sum(1 << variable for variable in set(monomial))
                    for monomial, _ in polynomial
                )
            )
        )
    return tuple(all_rows), tuple(sorted(set(all_rows)))


def polynomial_digest(polynomial_rows):
    state = sha256()
    for source, polynomial in sorted(polynomial_rows.items()):
        state.update(repr(source).encode("ascii"))
        state.update(b":")
        state.update(repr(polynomial).encode("ascii"))
        state.update(b"\n")
    return state.hexdigest()


def support_digest(rows):
    state = sha256()
    for row in rows:
        state.update(repr(row).encode("ascii"))
        state.update(b"\n")
    return state.hexdigest()


def active_histogram(polynomial_rows, groups, support_mask):
    assert all(any(support_mask & (1 << j) for j in group) for group in groups)
    histogram = Counter()
    bad_sources = []
    for source, polynomial in polynomial_rows.items():
        active = sum(
            1
            for monomial, _ in polynomial
            if all(support_mask & (1 << j) for j in monomial)
        )
        histogram[active] += 1
        if active == 1:
            bad_sources.append(source)
    assert not bad_sources
    return histogram
