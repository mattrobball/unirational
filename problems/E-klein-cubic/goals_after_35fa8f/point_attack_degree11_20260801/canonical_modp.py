#!/usr/bin/env python3
"""Canonical finite-field model for the degree-11 A5 landing scheme.

This is an exploratory producer.  It replaces the ambient cyclotomic
five-space by the rational irreducible five-space obtained from the action
of A5 on its six Sylow-5 subgroups.  For each maximal A5 class in the Klein
group it computes an intertwiner, transports the Klein cubic to the
canonical invariant cubic pencil, and constructs the complete degree-11
landing scheme.
"""

from __future__ import annotations

from collections import deque
from itertools import product
from pathlib import Path
import argparse
import sys

import sympy as sp


HERE = Path(__file__).resolve().parent
OLD = HERE.parents[1] / "goals_2026-08-01" / "H_SUBGROUP_TWISTS_CODEX_ROOT_20260801"
sys.path.insert(0, str(OLD))

import build_a5_twists as base  # noqa: E402
import low_degree_search as low  # noqa: E402
import a5_degree5_7_search as landing  # noqa: E402


def perm_key(perm):
    return tuple(perm)


def sylow5_subgroups():
    groups = set()
    for g in base.A5_PERMS:
        if base.porder(g) != 5:
            continue
        powers = {base.PID}
        h = base.PID
        for _ in range(4):
            h = base.pcompose(h, g)
            powers.add(h)
        groups.add(frozenset(powers))
    assert len(groups) == 6
    return tuple(sorted(groups, key=lambda group: tuple(sorted(group))))


SYLOW5 = sylow5_subgroups()
SYLOW5_INDEX = {group: i for i, group in enumerate(SYLOW5)}


def conjugate_perm(g, h):
    return base.pcompose(base.pcompose(g, h), base.pinv(g))


def sylow_permutation(g):
    return tuple(
        SYLOW5_INDEX[frozenset(conjugate_perm(g, h) for h in group)]
        for group in SYLOW5
    )


def canonical_target_matrix(g, prime):
    """Matrix on the sum-zero subspace with basis e_i-e_5, i=0,...,4."""
    q = sylow_permutation(g)
    qi = [0] * 6
    for source, image in enumerate(q):
        qi[image] = source
    matrix = []
    for row in range(5):
        source = qi[row]
        if source < 5:
            matrix.append([int(column == source) for column in range(5)])
        else:
            matrix.append([-1 % prime] * 5)
    return matrix


def target_representation(prime):
    return {g: canonical_target_matrix(g, prime) for g in base.A5_PERMS}


def monomials(nvars, degree):
    if nvars == 1:
        return ((degree,),)
    out = []
    for first in range(degree + 1):
        for tail in monomials(nvars - 1, degree - first):
            out.append((first,) + tail)
    return tuple(out)


def padd(left, right, prime):
    out = dict(left)
    for exponent, coefficient in right.items():
        out[exponent] = (out.get(exponent, 0) + coefficient) % prime
        if not out[exponent]:
            del out[exponent]
    return out


def pscale(scalar, polynomial, prime):
    return {
        exponent: scalar * coefficient % prime
        for exponent, coefficient in polynomial.items()
        if scalar * coefficient % prime
    }


def pmul(left, right, prime):
    out = {}
    for a, ca in left.items():
        for b, cb in right.items():
            exponent = tuple(x + y for x, y in zip(a, b))
            out[exponent] = (out.get(exponent, 0) + ca * cb) % prime
    return {exponent: coefficient for exponent, coefficient in out.items() if coefficient}


def ppow(polynomial, exponent, prime):
    nvars = len(next(iter(polynomial))) if polynomial else 5
    out = {(0,) * nvars: 1}
    for _ in range(exponent):
        out = pmul(out, polynomial, prime)
    return out


def monomial_transform(matrix, degree, prime):
    nvars = len(matrix)
    basis = monomials(nvars, degree)
    index = {exponent: i for i, exponent in enumerate(basis)}
    forms = []
    for row in matrix:
        form = {}
        for variable, coefficient in enumerate(row):
            if coefficient % prime:
                exponent = tuple(int(i == variable) for i in range(nvars))
                form[exponent] = coefficient % prime
        forms.append(form)
    transform = [[0] * len(basis) for _ in basis]
    for source_index, exponent in enumerate(basis):
        polynomial = {(0,) * nvars: 1}
        for form, power in zip(forms, exponent):
            polynomial = pmul(polynomial, ppow(form, power, prime), prime)
        for output_exponent, coefficient in polynomial.items():
            transform[source_index][index[output_exponent]] = coefficient
    return transform


def invariant_cubics(target, generators, prime):
    mons = monomials(5, 3)
    equations = []
    for generator in generators:
        transform = monomial_transform(target[generator], 3, prime)
        for output in range(len(mons)):
            row = [transform[source][output] for source in range(len(mons))]
            row[output] = (row[output] - 1) % prime
            equations.append(row)
    old_prime = low.P
    low.P = prime
    try:
        vectors = low.nullspace_mod(equations)
    finally:
        low.P = old_prime
    assert len(vectors) == 2
    return [
        {exponent: coefficient for exponent, coefficient in zip(mons, vector) if coefficient}
        for vector in vectors
    ]


def intertwiner(ambient_generators, abstract_map, target, prime, zeta):
    """Return T with rho(h) T = T canonical(abstract_map(h))."""
    equations = []
    for h in ambient_generators:
        rho = base.rho_mod(h, prime, zeta)
        canonical = target[abstract_map[h]]
        for i in range(5):
            for j in range(5):
                row = [0] * 25
                for k in range(5):
                    row[k * 5 + j] = (row[k * 5 + j] + rho[i][k]) % prime
                    row[i * 5 + k] = (row[i * 5 + k] - canonical[k][j]) % prime
                equations.append(row)
    old_prime = low.P
    low.P = prime
    try:
        kernel = low.nullspace_mod(equations)
    finally:
        low.P = old_prime
    assert len(kernel) == 1
    vector = kernel[0]
    matrix = [vector[5 * i:5 * (i + 1)] for i in range(5)]
    assert base.determinant(matrix, prime)
    return matrix


def klein_after_intertwiner(matrix, prime):
    forms = []
    for row in matrix:
        forms.append({
            tuple(int(i == variable) for i in range(5)): coefficient
            for variable, coefficient in enumerate(row)
            if coefficient % prime
        })
    result = {}
    for i in range(5):
        term = pmul(pmul(forms[i], forms[i], prime), forms[(i + 1) % 5], prime)
        result = padd(result, term, prime)
    return result


def coordinates_in_basis(polynomial, basis, prime):
    mons = monomials(5, 3)
    for first in range(len(mons)):
        for second in range(first + 1, len(mons)):
            matrix = [
                [basis[column].get(mons[row], 0) for column in range(2)]
                for row in (first, second)
            ]
            det = (matrix[0][0] * matrix[1][1] - matrix[0][1] * matrix[1][0]) % prime
            if not det:
                continue
            inverse = pow(det, -1, prime)
            rhs = [polynomial.get(mons[row], 0) for row in (first, second)]
            coordinates = [
                (matrix[1][1] * rhs[0] - matrix[0][1] * rhs[1]) * inverse % prime,
                (-matrix[1][0] * rhs[0] + matrix[0][0] * rhs[1]) * inverse % prime,
            ]
            reconstructed = {}
            for scalar, item in zip(coordinates, basis):
                reconstructed = padd(reconstructed, pscale(scalar, item, prime), prime)
            assert reconstructed == polynomial
            return coordinates
    raise AssertionError("invariant cubic basis has no nonzero minor")


def canonical_covariants(degree, generators, abstract_map, source, target, prime):
    old_rho = base.rho_mod
    old_prime = low.P
    base.rho_mod = lambda h: target[abstract_map[h]]
    low.P = prime
    try:
        return low.covariant_basis(degree, generators, abstract_map, source)
    finally:
        base.rho_mod = old_rho
        low.P = old_prime


def general_landing_equations(space, target_cubic, degree, prime):
    old_prime = low.P
    low.P = prime
    try:
        outputs = [low.output_polynomials(covariant, degree) for covariant in space]
    finally:
        low.P = old_prime
    dimension = len(space)
    equations = {}
    for target_exponent, cubic_coefficient in target_cubic.items():
        coordinates = []
        for coordinate, multiplicity in enumerate(target_exponent):
            coordinates.extend([coordinate] * multiplicity)
        assert len(coordinates) == 3
        for selections in product(range(dimension), repeat=3):
            source_polynomial = {(0, 0, 0): cubic_coefficient}
            for selection, coordinate in zip(selections, coordinates):
                source_polynomial = low.pmul(source_polynomial, outputs[selection][coordinate])
            parameter_exponent = tuple(selections.count(i) for i in range(dimension))
            for source_exponent, coefficient in source_polynomial.items():
                target = equations.setdefault(source_exponent, {})
                target[parameter_exponent] = (
                    target.get(parameter_exponent, 0) + coefficient
                ) % prime
    return {
        source: {parameter: coefficient for parameter, coefficient in polynomial.items() if coefficient}
        for source, polynomial in equations.items()
        if any(polynomial.values())
    }


def primitive_data(prime):
    primitive = int(sp.primitive_root(prime))
    zeta = pow(primitive, (prime - 1) // 11, prime)
    assert zeta != 1 and pow(zeta, 11, prime) == 1
    square_roots = sp.sqrt_mod(5, prime, all_roots=True)
    assert square_roots
    return zeta, int(square_roots[0])


def run(prime, make_charts):
    zeta, sqrt5 = primitive_data(prime)
    target = target_representation(prime)
    class_data = base.two_a5_classes()
    standard_generators = tuple(base.abstract_isomorphism(*class_data[0][:2])[h] for h in class_data[0][:2])
    cubics = invariant_cubics(target, standard_generators, prime)
    source = base.source_representation(prime, sqrt5)
    print(f"prime={prime} zeta11={zeta} sqrt5={sqrt5}")
    print("invariant_cubic_basis_nonzero_terms=", [len(item) for item in cubics])

    # The canonical source and target representations do not depend on the
    # embedding class, so the full degree-11 covariant basis is shared.
    a0, b0, _ = class_data[0]
    amap0 = base.abstract_isomorphism(a0, b0)
    space = canonical_covariants(11, (a0, b0), amap0, source, target, prime)
    assert len(space) == 5
    print("degree_11_covariant_dimension=5")

    for class_index, (a, b, _subgroup) in enumerate(class_data, 1):
        amap = base.abstract_isomorphism(a, b)
        matrix = intertwiner((a, b), amap, target, prime, zeta)
        cubic = klein_after_intertwiner(matrix, prime)
        pencil_coordinates = coordinates_in_basis(cubic, cubics, prime)
        print(f"class={class_index} pencil_coordinates={pencil_coordinates}")
        equations = general_landing_equations(space, cubic, 11, prime)
        print(f"class={class_index} landing_equations={len(equations)}")
        if make_charts:
            old_prime = landing.P
            old_here = landing.HERE
            landing.P = prime
            landing.HERE = HERE / f"p{prime}"
            landing.HERE.mkdir(exist_ok=True)
            try:
                for chart in range(5):
                    result = landing.singular_chart(
                        f"canonical_class{class_index}_degree11",
                        equations,
                        5,
                        chart,
                    )
                    print(
                        f"class={class_index} chart={chart} "
                        f"unit={result['unit_ideal']} equations={result['equation_count']}"
                    )
            finally:
                landing.P = old_prime
                landing.HERE = old_here


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--prime", type=int, default=89)
    parser.add_argument("--charts", action="store_true")
    args = parser.parse_args()
    run(args.prime, args.charts)


if __name__ == "__main__":
    main()
