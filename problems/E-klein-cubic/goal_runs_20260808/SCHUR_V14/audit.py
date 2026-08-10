#!/usr/bin/env python3
"""Exact finite-field audit for the Schur-source V14 branch.

This script has two independent jobs.

1.  At the split good primes 881 and 1321 it reconstructs the six-dimensional
    Weil module U, the 10' summand M in wedge^2 U, and

        V14 = Gr(2,U) cap P(M).

    It then records the C5/D10, C11/F55, C2/D12, and A5 fixed-stratum
    profiles on the projective source P(U) and on V14.

2.  At the good prime 23 it constructs the *complete* spaces

        Hom_(2.G)(Sym^d(U), M),  d = 4,6,8,10,

    by Reynolds averaging.  Any rational G-map P(U) --> V14 must be
    undefined on the D10-stable C5-fixed line P(U_0), because V14^C5 is
    finite and V14^D10 is empty.  Hence a homogeneous covariant representing
    such a map must restrict to zero on U_0.  We compute this forced kernel
    and then test its complete Pluecker landing equations.

No characteristic-zero conclusion is inferred from point counts.  The
bounded landing exclusions use projective properness: an empty projective
special fibre of the integral coefficient scheme excludes a characteristic-
zero point in the same complete degree.
"""

from __future__ import annotations

from dataclasses import dataclass
from itertools import combinations
from math import comb, prod
from pathlib import Path
import sys

import numpy as np


ROOT = Path(__file__).resolve().parents[2]
V14_SCRIPTS = ROOT / "goal_runs_after_d0ab8d0/FIX_IX_V14MODEL/scripts"
sys.path.insert(0, str(V14_SCRIPTS))

import fp  # type: ignore  # noqa: E402
import fixloci  # type: ignore  # noqa: E402
import geom  # type: ignore  # noqa: E402
import groups  # type: ignore  # noqa: E402
import v14lib as V  # type: ignore  # noqa: E402


def matrix_power(A, exponent, prime):
    out = fp.ident(len(A))
    while exponent:
        if exponent & 1:
            out = fp.matmul(A, out, prime)
        A = fp.matmul(A, A, prime)
        exponent //= 2
    return out


def inverse(A, prime):
    n = len(A)
    augmented = [
        row[:] + [1 if i == j else 0 for j in range(n)]
        for i, row in enumerate(A)
    ]
    reduced, pivots = fp.rref(augmented, prime)
    assert pivots[:n] == list(range(n))
    return [row[n:] for row in reduced]


def normalize(vector, prime):
    return fixloci.normalize([int(x) for x in vector], prime)


def permutation_on_points(matrix, points, prime):
    keys = {normalize(point, prime): i for i, point in enumerate(points)}
    return [
        keys[normalize(fp.matvec(matrix, point, prime), prime)]
        for point in points
    ]


def cycle_lengths(permutation):
    seen = set()
    lengths = []
    for start in range(len(permutation)):
        if start in seen:
            continue
        current = start
        length = 0
        while current not in seen:
            seen.add(current)
            length += 1
            current = permutation[current]
        lengths.append(length)
    return sorted(lengths)


def subspace_is_stable(matrix, basis, prime):
    images = [fp.matvec(matrix, vector, prime) for vector in basis]
    return len(fp.rowspace_basis(basis + images, prime)) == len(basis)


def subspace_key(basis, prime):
    reduced, _ = fp.rref(basis, prime)
    nonzero = [row for row in reduced if any(entry % prime for entry in row)]
    return tuple(tuple(entry % prime for entry in row) for row in nonzero)


def quadric_coefficient_rank(quadrics, variables, prime):
    pairs = [(i, j) for i in range(variables) for j in range(i, variables)]
    rows = [[quadric.get(pair, 0) for pair in pairs] for quadric in quadrics]
    return len(fp.rowspace_basis(rows, prime))


def target_fixed_points(model, generator15):
    prime = model.p
    points = []
    pieces = []
    for character, basis10 in fixloci.fixed_pieces(
        [model.to10(generator15)], prime
    ):
        basis15 = [geom._lincomb(model.Mrows, row, prime) for row in basis10]
        quadrics = model.quadrics(basis=basis15)
        # The C2 fixed locus also has a P5 piece containing the elliptic
        # sextic.  Only the at-most-P3 pieces used in the reduced-point
        # audits can be exhaustively enumerated over the finite field.
        local_points = (
            fixloci.points_in_P(quadrics, len(basis10), prime)
            if len(basis10) <= 4
            else []
        )
        pieces.append((
            tuple(character),
            len(basis10),
            len(local_points),
            quadric_coefficient_rank(quadrics, len(basis10), prime),
        ))
        for local in local_points:
            points.append(geom._lincomb(basis10, local, prime))
    return pieces, points


def find_d10(by_order, prime):
    c5 = by_order[5][0]
    c5_inverse = matrix_power(c5, 4, prime)
    for reflection in by_order[2]:
        conjugate = fp.matmul(
            reflection, fp.matmul(c5, reflection, prime), prime
        )
        if fp.key(conjugate, prime) != fp.key(c5_inverse, prime):
            continue
        if len(groups.subgroup([c5, reflection], prime)) == 10:
            return c5, reflection
    raise AssertionError("D10 not found")


def find_f55(by_order, prime):
    c11 = by_order[11][0]
    powers = {k: matrix_power(c11, k, prime) for k in range(1, 11)}
    for complement in by_order[5]:
        complement_inverse = matrix_power(complement, 4, prime)
        conjugate = fp.matmul(
            complement, fp.matmul(c11, complement_inverse, prime), prime
        )
        exponent = next(
            (k for k, value in powers.items()
             if fp.key(value, prime) == fp.key(conjugate, prime)),
            None,
        )
        if exponent is None or exponent == 1:
            continue
        if len(groups.subgroup([c11, complement], prime)) == 55:
            return c11, complement, exponent
    raise AssertionError("F55 not found")


def source_eigenlines(generator6, prime):
    pieces = fixloci.fixed_pieces([generator6], prime)
    points = []
    profile = []
    for character, basis in pieces:
        profile.append((tuple(character), len(basis)))
        if len(basis) == 1:
            points.append(basis[0])
    return profile, points


def fixed_normalizer_audit(prime):
    model = V.Model(prime)
    group15 = model.group15()
    by_order = groups.elements_by_order(group15, prime)
    sl_group = V.closure([model.A6, model.B6], prime, limit=2000)
    lift = {fp.key(V.lam2(element, prime), prime): element
            for element in sl_group.values()}
    assert len(group15) == 660
    assert len(sl_group) == 1320

    c5, reflection = find_d10(by_order, prime)
    c5_pieces, c5_target = target_fixed_points(model, c5)
    assert len(c5_target) == 4
    # Each projective C5 character piece is a P1 and at least one restricted
    # Pluecker equation is nonzero, so the geometric fixed scheme is finite;
    # this conclusion does not rely on rational-point enumeration.
    assert all(dimension == 2 and quadratic_rank > 0
               for _, dimension, _, quadratic_rank in c5_pieces)
    d10_permutation = permutation_on_points(
        model.to10(reflection), c5_target, prime
    )
    assert cycle_lengths(d10_permutation) == [2, 2]
    d10_target_fixed = fixloci.fixed_pieces(
        [model.to10(c5), model.to10(reflection)], prime
    )
    d10_on_target = []
    d10_quadratic_ranks = []
    for character, basis10 in d10_target_fixed:
        basis15 = [geom._lincomb(model.Mrows, row, prime) for row in basis10]
        quadrics = model.quadrics(basis=basis15)
        d10_quadratic_ranks.append(
            quadric_coefficient_rank(quadrics, len(basis10), prime)
        )
        points = fixloci.points_in_P(
            quadrics, len(basis10), prime
        )
        d10_on_target.extend(points)
    assert d10_on_target == []
    # There is one projective-character P1 and its restricted quadrics span
    # all binary quadrics.  Hence V14^D10 is geometrically empty, not merely
    # devoid of rational points over the audit field.
    assert [len(basis) for _, basis in d10_target_fixed] == [2]
    assert d10_quadratic_ranks == [3]

    c5_lift = lift[fp.key(c5, prime)]
    reflection_lift = lift[fp.key(reflection, prime)]
    c5_source_profile, _ = source_eigenlines(c5_lift, prime)
    assert sorted(dimension for _, dimension in c5_source_profile) == [1, 1, 1, 1, 2]
    c5_source_pieces = fixloci.fixed_pieces([c5_lift], prime)
    c5_planes = [basis for _, basis in c5_source_pieces if len(basis) == 2]
    assert len(c5_planes) == 1
    c5_plane = c5_planes[0]
    c5_line_stabilizer = [
        element15
        for element15 in group15.values()
        if subspace_is_stable(lift[fp.key(element15, prime)], c5_plane, prime)
    ]
    assert len(c5_line_stabilizer) == 10
    source_d10_fixed = fixloci.fixed_pieces(
        [c5_lift, reflection_lift], prime
    )
    assert sorted(len(basis) for _, basis in source_d10_fixed) == [1, 1]
    assert all(
        len(fp.rowspace_basis(c5_plane + basis, prime)) == 2
        for _, basis in source_d10_fixed
    )

    c11, complement, conjugation_exponent = find_f55(by_order, prime)
    c11_pieces, c11_target = target_fixed_points(model, c11)
    assert len(c11_target) == 5
    f55_target_permutation = permutation_on_points(
        model.to10(complement), c11_target, prime
    )
    assert cycle_lengths(f55_target_permutation) == [5]
    c11_lift = lift[fp.key(c11, prime)]
    complement_lift = lift[fp.key(complement, prime)]
    c11_source_profile, c11_source_lines = source_eigenlines(c11_lift, prime)
    assert sorted(dimension for _, dimension in c11_source_profile) == [1] * 6
    f55_source_permutation = permutation_on_points(
        complement_lift, c11_source_lines, prime
    )
    assert cycle_lengths(f55_source_permutation) == [1, 5]
    source_f55_fixed = fixloci.fixed_pieces(
        [c11_lift, complement_lift], prime
    )
    assert sorted(len(basis) for _, basis in source_f55_fixed) == [1]

    # The orbit of the unique F55-fixed source point has size 12.  The orbit
    # of the C5-fixed line has size 66, and is exactly the complete secant
    # graph on those twelve vertices.
    f55_point = source_f55_fixed[0][1][0]
    vertex_orbit = {
        normalize(fp.matvec(element, f55_point, prime), prime)
        for element in lift.values()
    }
    assert len(vertex_orbit) == 12
    line_orbit = {
        subspace_key(
            [fp.matvec(element, vector, prime) for vector in c5_plane], prime
        )
        for element in lift.values()
    }
    assert len(line_orbit) == 66
    vertices = [list(point) for point in sorted(vertex_orbit)]
    line_vertex_pairs = []
    vertex_degrees = [0] * len(vertices)
    for line in sorted(line_orbit):
        line_basis = [list(row) for row in line]
        incident = [
            index for index, point in enumerate(vertices)
            if len(fp.rowspace_basis(line_basis + [point], prime)) == 2
        ]
        assert len(incident) == 2
        line_vertex_pairs.append(tuple(incident))
        for index in incident:
            vertex_degrees[index] += 1
    assert len(set(line_vertex_pairs)) == comb(12, 2)
    assert sorted(vertex_degrees) == [11] * 12

    subgroups, _ = groups.pick(model)
    involution = subgroups["C2"][0]
    centralizer = groups.centralizer(involution, group15, prime)
    involution_lift = lift[fp.key(involution, prime)]
    swapping_lift = None
    swapping_element = None
    for element in centralizer:
        candidate = lift[fp.key(element, prime)]
        candidate_inverse = matrix_power(
            candidate, V.order_of(candidate, prime) - 1, prime
        )
        conjugate = fp.matmul(
            candidate, fp.matmul(involution_lift, candidate_inverse, prime), prime
        )
        if fp.key(conjugate, prime) == fp.key(
            fp.scal(involution_lift, prime - 1, prime), prime
        ):
            swapping_lift = candidate
            swapping_element = element
            break
    assert swapping_lift is not None and swapping_element is not None
    involution_source = fixloci.fixed_pieces([involution_lift], prime)
    assert sorted(len(basis) for _, basis in involution_source) == [3, 3]
    # The chosen D12 element swaps the two source eigenplanes.
    first_image = fp.matvec(swapping_lift, involution_source[0][1][0], prime)
    assert len(fp.rowspace_basis(involution_source[1][1] + [first_image], prime)) == 3

    involution_target_pieces, involution_target = target_fixed_points(
        model, involution
    )
    # target_fixed_points enumerates only the isolated P3 piece here; the
    # other eigenspace contains the sealed elliptic sextic and has dimension 6.
    assert len(involution_target) == 2
    d12_pair_permutation = permutation_on_points(
        model.to10(swapping_element), involution_target, prime
    )
    assert cycle_lengths(d12_pair_permutation) == [2]

    a5_source = fixloci.fixed_pieces(
        [lift[fp.key(g, prime)] for g in subgroups["A5"]], prime
    )
    a5_target = fixloci.fixed_pieces(
        [model.to10(g) for g in subgroups["A5"]], prime
    )
    assert a5_source == []
    a5_target_points = []
    for _, basis10 in a5_target:
        basis15 = [geom._lincomb(model.Mrows, row, prime) for row in basis10]
        a5_target_points.extend(
            fixloci.points_in_P(model.quadrics(basis=basis15), len(basis10), prime)
        )
    assert a5_target_points == []

    return {
        "prime": prime,
        "group_orders": [len(group15), len(sl_group)],
        "C5_source_dimensions": sorted(d for _, d in c5_source_profile),
        "C5_target_piece_profile": c5_pieces,
        "D10_target_C5_point_orbits": cycle_lengths(d10_permutation),
        "D10_source_projective_fixed_points": len(source_d10_fixed),
        "C5_source_line_stabilizer_order": len(c5_line_stabilizer),
        "C5_source_line_orbit_size": len(group15) // len(c5_line_stabilizer),
        "D10_target_fixed_points": len(d10_on_target),
        "D10_fixed_piece_quadratic_ranks": d10_quadratic_ranks,
        "C11_source_dimensions": sorted(d for _, d in c11_source_profile),
        "C11_target_piece_profile": c11_pieces,
        "F55_conjugation_exponent": conjugation_exponent,
        "F55_source_C11_point_orbits": cycle_lengths(f55_source_permutation),
        "F55_target_C11_point_orbits": cycle_lengths(f55_target_permutation),
        "F55_source_projective_fixed_points": len(source_f55_fixed),
        "F55_source_vertex_orbit_size": len(vertex_orbit),
        "C5_line_graph": "K12",
        "C5_line_vertex_degrees": sorted(set(vertex_degrees)),
        "C2_source_dimensions": sorted(len(b) for _, b in involution_source),
        "D12_target_isolated_point_orbits": cycle_lengths(d12_pair_permutation),
        "A5_source_fixed_pieces": len(a5_source),
        "A5_target_fixed_points": len(a5_target_points),
    }


def monomials(degree, variables=6):
    result = []

    def visit(prefix, remaining, slots):
        if slots == 1:
            result.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, slots - 1)

    visit((), degree, variables)
    return result


def trace(matrix, prime):
    return sum(matrix[i][i] for i in range(len(matrix))) % prime


def symmetric_character(matrix, max_degree, prime):
    """Characters h_d of Sym^d(matrix), by Newton's identities."""
    power = fp.ident(len(matrix))
    power_sums = [0]
    for _ in range(max_degree):
        power = fp.matmul(power, matrix, prime)
        power_sums.append(trace(power, prime))
    complete = [1]
    for degree in range(1, max_degree + 1):
        numerator = sum(
            power_sums[index] * complete[degree - index]
            for index in range(1, degree + 1)
        ) % prime
        complete.append(numerator * pow(degree, -1, prime) % prime)
    return complete


def crt(residues, primes):
    modulus = prod(primes)
    answer = 0
    for residue, prime in zip(residues, primes):
        partial = modulus // prime
        answer += residue * partial * pow(partial, -1, prime)
    return answer % modulus


def character_multiplicities(max_degree=10):
    """Independent complete multiplicities by four-prime character averaging.

    The coefficient space is (Sym^d U^* tensor M)^(2.G), so the summand at
    g is h_d(g^{-1}|U) tr(g|M).  Since all primes are larger than the degrees
    and avoid 1320, Newton and Reynolds denominators are units.
    """
    primes = (23, 67, 89, 199)
    residues = {degree: [] for degree in range(max_degree + 1)}
    for prime in primes:
        model = V.Model(prime)
        sl_group = V.closure([model.A6, model.B6], prime, limit=2000)
        assert len(sl_group) == 1320
        totals = [0] * (max_degree + 1)
        for element in sl_group.values():
            inverse_element = inverse(element, prime)
            symmetric = symmetric_character(
                inverse_element, max_degree, prime
            )
            target = model.to10(V.lam2(element, prime))
            target_trace = trace(target, prime)
            for degree in range(max_degree + 1):
                totals[degree] += symmetric[degree] * target_trace
        group_inverse = pow(1320, -1, prime)
        for degree, total in enumerate(totals):
            residues[degree].append(total % prime * group_inverse % prime)

    multiplicities = {
        degree: crt(residues[degree], primes)
        for degree in range(max_degree + 1)
    }
    modulus = prod(primes)
    for degree, dimension in multiplicities.items():
        ambient_bound = 10 * comb(degree + 5, 5)
        assert modulus > ambient_bound
        assert dimension <= ambient_bound
    assert multiplicities == {
        0: 0, 1: 0, 2: 0, 3: 0, 4: 3, 5: 0,
        6: 6, 7: 0, 8: 22, 9: 0, 10: 42,
    }
    return {
        "primes": primes,
        "CRT_modulus": modulus,
        "multiplicities": multiplicities,
    }


def add_echelon_row(basis, row, prime):
    remainder = np.array(row, dtype=np.int64) % prime
    for pivot, basis_row in basis:
        if remainder[pivot]:
            remainder -= remainder[pivot] * basis_row
            remainder %= prime
    nonzero = np.flatnonzero(remainder)
    if not len(nonzero):
        return False
    pivot = int(nonzero[0])
    remainder *= pow(int(remainder[pivot]), -1, prime)
    remainder %= prime
    basis.append((pivot, remainder))
    return True


@dataclass(frozen=True)
class Seed:
    output: int
    exponents: tuple[int, ...]


class SpinCovariants:
    def __init__(self, prime=23):
        self.prime = prime
        self.model = V.Model(prime)
        sl_group = V.closure(
            [self.model.A6, self.model.B6], prime, limit=2000
        )
        assert len(sl_group) == 1320
        self.domain_group = np.array(list(sl_group.values()), dtype=np.int64)
        target = [
            self.model.to10(V.lam2(element, prime))
            for element in sl_group.values()
        ]
        self.target_inverse_group = np.array(
            [inverse(element, prime) for element in target], dtype=np.int64
        )
        self.rng = np.random.default_rng(20260808)
        self.selection_points = [
            self.rng.integers(0, prime, size=6, dtype=np.int64)
            for _ in range(7)
        ]
        by_order = groups.elements_by_order(self.model.group15(), prime)
        c5, _ = find_d10(by_order, prime)
        lift = {
            fp.key(V.lam2(element, prime), prime): element
            for element in sl_group.values()
        }
        c5_lift = lift[fp.key(c5, prime)]
        rational_pieces = fixloci.fixed_pieces([c5_lift], prime)
        two_spaces = [basis for _, basis in rational_pieces if len(basis) == 2]
        assert len(two_spaces) == 1
        self.c5_plane = np.array(two_spaces[0], dtype=np.int64)

    def evaluate_seed(self, seed, point):
        p = self.prime
        transformed = np.einsum("gij,j->gi", self.domain_group, point) % p
        values = np.ones(len(self.domain_group), dtype=np.int64)
        for coordinate, exponent in enumerate(seed.exponents):
            if exponent:
                values *= np.array(
                    [pow(int(value), exponent, p)
                     for value in transformed[:, coordinate]],
                    dtype=np.int64,
                )
                values %= p
        return np.sum(
            values[:, None]
            * self.target_inverse_group[:, :, seed.output],
            axis=0,
            dtype=np.int64,
        ) % p

    def basis(self, degree, expected_dimension):
        echelon = []
        result = []
        for exponents in monomials(degree):
            for output in range(10):
                seed = Seed(output, exponents)
                signature = np.concatenate([
                    self.evaluate_seed(seed, point)
                    for point in self.selection_points
                ])
                if add_echelon_row(echelon, signature, self.prime):
                    result.append(seed)
                    if len(result) == expected_dimension:
                        self.check_equivariance(result)
                        return result
        raise AssertionError(
            f"found only {len(result)} of {expected_dimension} covariants"
        )

    def check_equivariance(self, seeds):
        p = self.prime
        for generator in (self.model.A6, self.model.B6):
            target = np.array(
                self.model.to10(V.lam2(generator, p)), dtype=np.int64
            )
            for point in self.selection_points[:2]:
                left = self.values(
                    seeds, np.array(fp.matvec(generator, point.tolist(), p))
                )
                right = self.values(seeds, point) @ target.T % p
                assert np.array_equal(left % p, right % p)

    def values(self, seeds, point):
        return np.stack([self.evaluate_seed(seed, point) for seed in seeds])

    def restriction_kernel(self, seeds, degree):
        p = self.prime
        u0, u1 = self.c5_plane
        rows = []
        # d+1 affine points determine a binary homogeneous degree-d form.
        for parameter in range(degree + 1):
            point = (u0 + parameter * u1) % p
            rows.extend(self.values(seeds, point).T.tolist())
        kernel = fp.nullspace(rows, p)
        restriction_rank = len(seeds) - len(kernel)
        return np.array(kernel, dtype=np.int64), restriction_rank

    @staticmethod
    def coefficient_pairs(dimension):
        return list(combinations(range(dimension), 2))

    def pluecker_coefficient_rows(self, kernel_values):
        p = self.prime
        dimension = len(kernel_values)
        pairs = self.coefficient_pairs(dimension)
        rows = []
        quadrics = self.model.quadrics()
        for quadric in quadrics:
            diagonal = [
                V.eval_quads([quadric], kernel_values[i].tolist(), p)[0]
                for i in range(dimension)
            ]
            row = diagonal[:]
            for i, j in pairs:
                value = V.eval_quads(
                    [quadric],
                    ((kernel_values[i] + kernel_values[j]) % p).tolist(),
                    p,
                )[0]
                row.append((value - diagonal[i] - diagonal[j]) % p)
            rows.append(row)
        return rows

    def landing_rank(self, seeds, kernel, max_points=240):
        p = self.prime
        dimension = len(kernel)
        quadratic_dimension = dimension * (dimension + 1) // 2
        if dimension == 0:
            return 0, 0, 0
        echelon = []
        stagnant = 0
        points_used = 0
        points = self.selection_points + [
            self.rng.integers(0, p, size=6, dtype=np.int64)
            for _ in range(max_points)
        ]
        for point in points:
            seed_values = self.values(seeds, point)
            kernel_values = kernel @ seed_values % p
            old_rank = len(echelon)
            for row in self.pluecker_coefficient_rows(kernel_values):
                add_echelon_row(echelon, row, p)
            points_used += 1
            if len(echelon) == quadratic_dimension:
                break
            if len(echelon) == old_rank:
                stagnant += 1
            else:
                stagnant = 0
            if stagnant >= 30:
                break
        return len(echelon), quadratic_dimension, points_used


def spin_covariant_audit():
    character_certificate = character_multiplicities(10)
    expected = {
        degree: character_certificate["multiplicities"][degree]
        for degree in (4, 6, 8, 10)
    }
    scanner = SpinCovariants(23)
    rows = []
    for degree, dimension in expected.items():
        seeds = scanner.basis(degree, dimension)
        kernel, restriction_rank = scanner.restriction_kernel(seeds, degree)
        landing_rank, quadratic_dimension, points_used = scanner.landing_rank(
            seeds, kernel
        )
        rows.append({
            "degree": degree,
            "covariant_dimension": dimension,
            "C5_line_restriction_rank": restriction_rank,
            "forced_base_kernel_dimension": len(kernel),
            "landing_quadratic_rank": landing_rank,
            "landing_quadratic_dimension": quadratic_dimension,
            "points_used": points_used,
            "projective_landing_empty": (
                len(kernel) == 0 or landing_rank == quadratic_dimension
            ),
        })
    return character_certificate, rows


def main():
    print("FIXED_NORMALIZER_AUDIT")
    for prime in (881, 1321):
        row = fixed_normalizer_audit(prime)
        print(row)
    print("SPIN_COVARIANT_FORCED_BASE_AUDIT")
    character_certificate, rows = spin_covariant_audit()
    print(character_certificate)
    for row in rows:
        print(row)
    print("SCHUR_V14_FIXED_NORMALIZER_AND_FORCED_BASE_AUDIT_OK")


if __name__ == "__main__":
    main()
