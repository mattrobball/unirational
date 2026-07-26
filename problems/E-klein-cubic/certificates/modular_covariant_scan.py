#!/usr/bin/env python3
"""Modular certificate excluding homogeneous self-covariants through degree 9.

This script reduces the exact cyclotomic matrices in ``exact_weil_check.py``
at the prime ``(23, zeta_11-2)``.  Since 23 does not divide 660, Reynolds
averaging is exact.  It constructs covariants by averaging monomial vector
maps, evaluates the cubic-on-covariants map, and checks its projective base
locus on affine patches with Groebner bases.

The ordinary characteristic-zero multiplicities are computed independently in
``exact_molien.py``.  In each degree, Reynolds seeds whose evaluations are
linearly independent give a basis after reduction.  If a nonzero
characteristic-zero covariant landed in the cubic, clear denominators at this
prime.  Equivalently, take the projective closure of its coefficient point
over a finite extension of the DVR and specialize it by properness.  Its
reduction would be a geometric projective common zero of the landing equations
below.  The exact finite-field Groebner calculations show that no such common
zero exists.  Thus the modular computation certifies the characteristic-zero
exclusion in degrees 1 through 9.
The separate ``degree10_m2_check.py`` performs the larger degree-10 projective
calculation.
"""

from __future__ import annotations

import math
from dataclasses import dataclass

import numpy as np
import sympy as sp


P = 23
ZETA = 2  # a primitive eleventh root of unity in F_23
JS = (1, 3, 2, 5, 4)
SIGNS = (1, 1, -1, 1, 1)
QUADRATIC_RESIDUES = {1, 3, 4, 5, 9}
GAMMA = sum(
    (1 if exponent in QUADRATIC_RESIDUES else -1)
    * pow(ZETA, exponent, P)
    for exponent in range(1, 11)
) % P
assert pow(ZETA, 11, P) == 1 and ZETA != 1
assert GAMMA * GAMMA % P == -11 % P

# Direct reductions of S and T from exact_weil_check.py.
A = np.array(
    [
        [
            SIGNS[column]
            * pow(SIGNS[row], -1, P)
            * (
                pow(ZETA, 9 * JS[row] * JS[column], P)
                - pow(ZETA, -9 * JS[row] * JS[column], P)
            )
            * pow(GAMMA, -1, P)
            % P
            for column in range(5)
        ]
        for row in range(5)
    ],
    dtype=np.int64,
)
B = np.diag([pow(ZETA, value * value, P) for value in JS]).astype(np.int64)
IDENTITY = np.eye(5, dtype=np.int64) % P


def matrix_key(matrix: np.ndarray) -> bytes:
    return bytes((matrix % P).astype(np.uint8).flat)


def matrix_product(left: np.ndarray, right: np.ndarray) -> np.ndarray:
    return left @ right % P


def matrix_power(matrix: np.ndarray, exponent: int) -> np.ndarray:
    result = IDENTITY.copy()
    while exponent:
        if exponent & 1:
            result = matrix_product(result, matrix)
        matrix = matrix_product(matrix, matrix)
        exponent //= 2
    return result


def generate_group() -> tuple[np.ndarray, np.ndarray]:
    seen = {matrix_key(IDENTITY): IDENTITY}
    queue = [IDENTITY]
    while queue:
        current = queue.pop()
        for generator in (A, B):
            candidate = matrix_product(current, generator)
            key = matrix_key(candidate)
            if key not in seen:
                seen[key] = candidate
                queue.append(candidate)
    group = np.stack(list(seen.values()))
    inverses = np.stack([matrix_power(matrix, 659) for matrix in group])
    assert len(group) == 660
    return group, inverses


GROUP, INVERSES = generate_group()


def monomials(degree: int, variables: int = 5) -> list[tuple[int, ...]]:
    """Weak compositions in filtered-product order, without the zero-sum scan."""

    result: list[tuple[int, ...]] = []

    def visit(prefix: tuple[int, ...], remaining: int, slots: int) -> None:
        if slots == 1:
            result.append(prefix + (remaining,))
            return
        for exponent in range(remaining + 1):
            visit(prefix + (exponent,), remaining - exponent, slots - 1)

    visit((), degree, variables)
    return result


def multiply_polynomials(
    left: dict[tuple[int, ...], int], right: dict[tuple[int, ...], int]
) -> dict[tuple[int, ...], int]:
    result: dict[tuple[int, ...], int] = {}
    for left_exponents, left_coefficient in left.items():
        for right_exponents, right_coefficient in right.items():
            exponents = tuple(
                first + second
                for first, second in zip(left_exponents, right_exponents)
            )
            result[exponents] = (
                result.get(exponents, 0)
                + left_coefficient * right_coefficient
            ) % P
    return {exponents: coefficient for exponents, coefficient in result.items() if coefficient}


def linear_power(row: np.ndarray, exponent: int) -> dict[tuple[int, ...], int]:
    result = {(0, 0, 0, 0, 0): 1}
    linear = {
        tuple(1 if index == variable else 0 for index in range(5)): int(row[variable])
        for variable in range(5)
        if row[variable]
    }
    for _ in range(exponent):
        result = multiply_polynomials(result, linear)
    return result


def substitute_monomial(
    exponents: tuple[int, ...], matrix: np.ndarray
) -> dict[tuple[int, ...], int]:
    result = {(0, 0, 0, 0, 0): 1}
    for coordinate, exponent in enumerate(exponents):
        result = multiply_polynomials(result, linear_power(matrix[coordinate], exponent))
    return result


F = {
    tuple(
        2 if coordinate == index else 1 if coordinate == (index + 1) % 5 else 0
        for coordinate in range(5)
    ): 1
    for index in range(5)
}


def transform_polynomial(
    polynomial: dict[tuple[int, ...], int], matrix: np.ndarray
) -> dict[tuple[int, ...], int]:
    result: dict[tuple[int, ...], int] = {}
    for source_exponents, source_coefficient in polynomial.items():
        for exponents, coefficient in substitute_monomial(source_exponents, matrix).items():
            result[exponents] = (
                result.get(exponents, 0) + source_coefficient * coefficient
            ) % P
    return {
        exponents: coefficient
        for exponents, coefficient in result.items()
        if coefficient
    }


assert transform_polynomial(F, A) == F
assert transform_polynomial(F, B) == F


def add_echelon_row(
    basis: list[tuple[int, np.ndarray]], row: np.ndarray
) -> bool:
    remainder = np.array(row, dtype=np.int64) % P
    for pivot, basis_row in basis:
        if remainder[pivot]:
            remainder = (remainder - remainder[pivot] * basis_row) % P
    nonzero = np.flatnonzero(remainder)
    if not len(nonzero):
        return False
    pivot = int(nonzero[0])
    remainder = remainder * pow(int(remainder[pivot]), -1, P) % P
    basis.append((pivot, remainder))
    return True


@dataclass(frozen=True)
class ReynoldsSeed:
    output: int
    exponents: tuple[int, ...]


def evaluate_seed(seed: ReynoldsSeed, point: np.ndarray) -> np.ndarray:
    transformed = np.einsum("gij,j->gi", GROUP, point) % P
    values = np.ones(len(GROUP), dtype=np.int64)
    for coordinate, exponent in enumerate(seed.exponents):
        if exponent:
            values = values * np.array(
                [pow(int(value), exponent, P) for value in transformed[:, coordinate]],
                dtype=np.int64,
            ) % P
    # Sum g^{-1} e_output * (g point)^exponents.  The harmless common factor
    # 1/|G| is omitted.
    return np.sum(
        values[:, None] * INVERSES[:, :, seed.output], axis=0, dtype=np.int64
    ) % P


RNG = np.random.default_rng(20260725)
SELECTION_POINTS = [RNG.integers(0, P, size=5, dtype=np.int64) for _ in range(4)]


def covariant_basis(degree: int, dimension: int) -> list[ReynoldsSeed]:
    echelon: list[tuple[int, np.ndarray]] = []
    result: list[ReynoldsSeed] = []
    for exponents in monomials(degree):
        for output in range(5):
            seed = ReynoldsSeed(output, exponents)
            evaluations = np.concatenate(
                [evaluate_seed(seed, point) for point in SELECTION_POINTS]
            )
            if add_echelon_row(echelon, evaluations):
                result.append(seed)
                if len(result) == dimension:
                    return result
    raise AssertionError(f"Only found {len(result)} of {dimension} covariants")


def cubic_coefficient_row(values: np.ndarray) -> np.ndarray:
    """Coefficients of F(sum_i a_i values[i]) as a cubic in the a_i."""

    dimension = len(values)
    coefficient_monomials = monomials(3, dimension)
    coefficient_index = {
        exponents: index for index, exponents in enumerate(coefficient_monomials)
    }
    row = np.zeros(len(coefficient_monomials), dtype=np.int64)
    linear_forms = []
    for coordinate in range(5):
        linear_forms.append(
            {
                tuple(1 if index == variable else 0 for index in range(dimension)): int(
                    values[variable, coordinate]
                )
                for variable in range(dimension)
                if values[variable, coordinate]
            }
        )
    one = {(0,) * dimension: 1}
    for source_exponents, source_coefficient in F.items():
        polynomial = one
        for coordinate, exponent in enumerate(source_exponents):
            for _ in range(exponent):
                product: dict[tuple[int, ...], int] = {}
                for left_exponents, left_coefficient in polynomial.items():
                    for right_exponents, right_coefficient in linear_forms[coordinate].items():
                        exponents = tuple(
                            first + second
                            for first, second in zip(left_exponents, right_exponents)
                        )
                        product[exponents] = (
                            product.get(exponents, 0)
                            + left_coefficient * right_coefficient
                        ) % P
                polynomial = product
        for exponents, coefficient in polynomial.items():
            row[coefficient_index[exponents]] = (
                row[coefficient_index[exponents]]
                + source_coefficient * coefficient
            ) % P
    return row


def landing_equations(
    seeds: list[ReynoldsSeed], extra_points: int = 500
) -> tuple[list[tuple[int, np.ndarray]], list[np.ndarray]]:
    dimension = len(seeds)
    target_rank_bound = math.comb(dimension + 2, 3)
    echelon: list[tuple[int, np.ndarray]] = []
    used_points: list[np.ndarray] = []
    points = SELECTION_POINTS + [
        RNG.integers(0, P, size=5, dtype=np.int64) for _ in range(extra_points)
    ]
    stagnant = 0
    for point in points:
        values = np.stack([evaluate_seed(seed, point) for seed in seeds])
        row = cubic_coefficient_row(values)
        if add_echelon_row(echelon, row):
            used_points.append(point)
            stagnant = 0
        else:
            stagnant += 1
        if len(echelon) == target_rank_bound or stagnant >= 50:
            break
    return echelon, used_points


def row_to_sympy(
    row: np.ndarray, variables: tuple[sp.Symbol, ...]
) -> sp.Expr:
    expression = 0
    for coefficient, exponents in zip(row, monomials(3, len(variables))):
        if coefficient:
            term = int(coefficient)
            for variable, exponent in zip(variables, exponents):
                term *= variable**exponent
            expression += term
    return expression


def projective_base_locus_is_empty(
    echelon: list[tuple[int, np.ndarray]], dimension: int
) -> tuple[bool, list[bool]]:
    variables = sp.symbols(f"a0:{dimension}")
    equations = [row_to_sympy(row, variables) for _, row in echelon]
    patch_results = []
    for patch in range(dimension):
        patch_variables = variables[:patch] + variables[patch + 1 :]
        patch_equations = [equation.subs(variables[patch], 1) for equation in equations]
        groebner = sp.groebner(patch_equations, *patch_variables, modulus=P)
        is_unit = len(groebner.polys) == 1 and groebner.polys[0].as_expr() == 1
        patch_results.append(is_unit)
    return all(patch_results), patch_results


def main() -> None:
    # Exact characteristic-zero multiplicities, independently obtained from the
    # ordinary character table.  They agree with the modular Reynolds ranks.
    multiplicities = {1: 1, 2: 0, 3: 0, 4: 2, 5: 1, 6: 2, 7: 4, 8: 5, 9: 6, 10: 10}
    print(f"group_order={len(GROUP)} invariant_cubic_terms={len(F)}")
    for degree, dimension in multiplicities.items():
        if not dimension:
            print(f"degree={degree} covariants=0")
            continue
        seeds = covariant_basis(degree, dimension)
        echelon, used_points = landing_equations(seeds)
        print(
            f"degree={degree} covariants={dimension} "
            f"symmetric_cube={math.comb(dimension + 2, 3)} "
            f"landing_rank={len(echelon)} witnesses={len(used_points)}"
        )
        if 7 <= degree <= 9:
            empty, patches = projective_base_locus_is_empty(echelon, dimension)
            print(f"  projective_base_locus_empty={empty} patches={patches}")
            assert empty
        elif degree <= 6:
            # Injectivity of Sym^3(Cov_d) -> polynomials already rules out a
            # nonzero pure cube, hence a landing covariant.
            assert len(echelon) == math.comb(dimension + 2, 3)
    print("PASS no homogeneous polynomial self-covariant of degree <= 9 lands in X")


if __name__ == "__main__":
    main()
