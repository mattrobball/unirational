#!/usr/bin/env python3
"""Exact low-degree implicit equations of the six A5 landing surfaces."""

from __future__ import annotations

import itertools
import json
from pathlib import Path

import emit_minor_system as emit
import search


HERE = Path(__file__).resolve().parent
SEC = search.SEC
BASE = search.BASE
P = search.P


def compositions(total, length):
    if length == 1:
        yield (total,)
        return
    for first in range(total + 1):
        for tail in compositions(total - first, length - 1):
            yield (first,) + tail


def pair(value):
    value = SEC.F89x2.coerce(value)
    return (value.a, value.b)


def pair_add(left, right):
    return ((left[0] + right[0]) % P, (left[1] + right[1]) % P)


def pair_mul(left, right):
    return search.fp2_mul(left, right)


def polynomial_mul(left, right):
    answer = {}
    for exponent_left, coefficient_left in left.items():
        for exponent_right, coefficient_right in right.items():
            exponent = tuple(a + b for a, b in zip(exponent_left, exponent_right))
            value = pair_add(
                answer.get(exponent, (0, 0)),
                pair_mul(coefficient_left, coefficient_right),
            )
            if value == (0, 0):
                answer.pop(exponent, None)
            else:
                answer[exponent] = value
    return answer


def polynomial_add_scaled(answer, polynomial, scalar):
    for exponent, coefficient in polynomial.items():
        value = pair_add(
            answer.get(exponent, (0, 0)), pair_mul(coefficient, scalar)
        )
        if value == (0, 0):
            answer.pop(exponent, None)
        else:
            answer[exponent] = value


def evaluate_q(point, parameters, covariants):
    return BASE.canonical_point(point, parameters, covariants)


def target_monomial_value(point, exponent):
    value = SEC.F89x2(1)
    for coordinate, degree in zip(point, exponent):
        value = value * coordinate**degree
    return value


def evaluation_rows(parameters, covariants, target_monomials, sample_count):
    rows = []
    source_points = search.projective_plane_points()
    # The catalog is lexicographic, so a prefix lies on one source line.
    # A coprime stride spreads the exact witnesses across P2(F_89).
    for offset in range(len(source_points)):
        point = source_points[(101 * offset) % len(source_points)]
        source = tuple(int(value) for value in point)
        target = evaluate_q(source, parameters, covariants)
        if not any(target):
            continue
        rows.append([
            target_monomial_value(target, exponent)
            for exponent in target_monomials
        ])
        if len(rows) == sample_count:
            break
    assert len(rows) == sample_count
    return rows


def substituted_monomials(q_polynomials, degree):
    one = {(0, 0, 0): (1, 0)}
    powers = []
    for polynomial in q_polynomials:
        current = [one]
        for _ in range(degree):
            current.append(polynomial_mul(current[-1], polynomial))
        powers.append(current)
    target_monomials = list(compositions(degree, 5))
    substitutions = []
    for exponent in target_monomials:
        polynomial = one
        for coordinate, power in enumerate(exponent):
            polynomial = polynomial_mul(polynomial, powers[coordinate][power])
        substitutions.append(polynomial)
    return target_monomials, substitutions


def verify_kernel(substitutions, kernel):
    for vector in kernel:
        answer = {}
        for coefficient, polynomial in zip(vector, substitutions):
            polynomial_add_scaled(answer, polynomial, pair(coefficient))
        assert not answer


def normalize_vector(vector):
    pivot = next(value for value in vector if value)
    inverse = SEC.F89x2.coerce(pivot).inverse()
    normalized = [SEC.F89x2.coerce(value) * inverse for value in vector]
    return [[value.a, value.b] for value in normalized]


def implicit_degrees(parameters, covariants, q_polynomials):
    results = []
    kernels = {}
    for degree in range(1, 6):
        target_monomials, substitutions = substituted_monomials(q_polynomials, degree)
        sample_count = min(500, max(80, 3 * len(target_monomials)))
        rows = evaluation_rows(parameters, covariants, target_monomials, sample_count)
        kernel = BASE.nullspace(rows)
        print("DEGREE", degree, "RAW_KERNEL", len(kernel), flush=True)
        verify_kernel(substitutions, kernel)
        kernels[degree] = (target_monomials, kernel)
        record = {
            "degree": degree,
            "target_form_dimension": len(target_monomials),
            "evaluation_rank": len(target_monomials) - len(kernel),
            "ideal_dimension": len(kernel),
            "kernel_verified_by_exact_substitution": True,
        }
        results.append(record)
        print("DEGREE", degree, "FORMS", len(target_monomials), "IDEAL", len(kernel), flush=True)
    degree5_monomials, degree5_kernel = kernels[5]
    return results, degree5_monomials, degree5_kernel


def main():
    twists = json.loads((BASE.SUBGROUP / "twists.json").read_text())
    covariants = BASE.load_covariants()
    maps = [
        (twists["records"][0], -1, SEC.class1_roots()[0], "class1_root0", None),
        (twists["records"][0], -1, SEC.class1_roots()[1], "class1_root1_fp2", "class1_root2_fp2"),
        (twists["records"][1], 1, SEC.class2_roots()[0], "class2_root0", None),
        (twists["records"][1], 1, SEC.class2_roots()[1], "class2_root1", None),
        (twists["records"][1], 1, SEC.class2_roots()[2], "class2_root2", None),
    ]
    records = []
    for _record, radical_sign, root, label, conjugate in maps:
        parameters = SEC.parameter_vector(radical_sign, root)
        q_polynomials = emit.source_polynomials(covariants, parameters)
        print("MAP", label, flush=True)
        degree_table, monomials5, kernel5 = implicit_degrees(
            parameters, covariants, q_polynomials
        )
        record = {
            "label": label,
            "covers_frobenius_conjugate": conjugate,
            "root": SEC.field_to_json(root),
            "parameters": SEC.vector_to_json(parameters),
            "implicit_ideal_dimensions_degrees_1_to_5": degree_table,
            "degree5_kernel_basis": [normalize_vector(vector) for vector in kernel5],
            "degree5_target_monomials": [list(exponent) for exponent in monomials5],
        }
        records.append(record)
    payload = {
        "format": "A5-LANDING-SURFACE-LOW-DEGREE-IMPLICIT-v1",
        "prime": P,
        "records": records,
        "scope": (
            "Exact polynomial substitution over F_89 or F_(89^2). This is a "
            "good-fibre implicit-ideal computation; characteristic-zero degree "
            "and generic map degree require a separate lift/open-flatness audit."
        ),
    }
    (HERE / "landing_surface_geometry.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True) + "\n"
    )
    print("A5_LANDING_SURFACE_LOW_DEGREE_IMPLICIT_OK")


if __name__ == "__main__":
    main()
