#!/usr/bin/env python3
"""Exact low-degree Klein-covariant exclusions, plus a mod-11 screen.

Let

    F = x^3 y + y^3 z + z^3 x,

and let D, C be the classical invariants of degrees 6 and 14.  Classical
Klein invariant theory says that Q[F,D,C] is the invariant ring of the
order-336 reflection extension and that the PSL(2,7)-covariant module is
free over this ring on generators of degrees 1, 8, 9, 11, 16, and 18.

For a homogeneous covariant p: V -> V of degree d, a lift to

    S : w^2 = F

requires F(p) to be the square of an invariant of degree 2d.  This script
does two deliberately separate things.

EXACT (characteristic zero): it excludes the complete covariant spaces in
degrees 9, 11, 15, 18, and 22.  All polynomial decompositions and support
arguments are checked over Z/Q.

HEURISTIC ONLY: over F_11 it screens every nonzero complete covariant space
through degree 22.  Absence of F_11-rational coefficient vectors is not a
characteristic-zero obstruction and is never reported as one.

SymPy is the only non-standard dependency.
"""

from __future__ import annotations

from collections import defaultdict
from itertools import product
from math import prod
from random import Random

import sympy as sp


x, y, z = sp.symbols("x y z")
XYZ = (x, y, z)

F = x**3 * y + y**3 * z + z**3 * x
D = x**5 * z - 5 * x**2 * y**2 * z**2 + x * y**5 + y * z**5
C = (
    x**14 - 34*x**11*y**2*z - 250*x**9*y*z**4
    + 375*x**8*y**4*z**2 + 18*x**7*y**7 + 18*x**7*z**7
    - 126*x**6*y**3*z**5 - 126*x**5*y**6*z**3
    - 250*x**4*y**9*z + 375*x**4*y**2*z**8
    - 126*x**3*y**5*z**6 + 375*x**2*y**8*z**4
    - 34*x**2*y*z**11 - 34*x*y**11*z**2 - 250*x*y**4*z**9
    + y**14 + 18*y**7*z**7 + z**14
)


def grad(poly: sp.Expr) -> sp.Matrix:
    return sp.Matrix([sp.diff(poly, variable) for variable in XYZ])


psi = grad(F).cross(grad(D))       # degree 8
phi = grad(F).cross(grad(C))       # degree 16
f18 = grad(D).cross(grad(C))       # degree 18
identity = sp.Matrix(XYZ)

# Primitive odd covariants.  These are reconstructed independently below
# from divisibility by Phi_21; keeping the compact formulas makes the later
# exact and finite-field checks fast.
g9 = sp.Matrix([
    -(x**7*y**2 + 38*x**5*y*z**3 - 25*x**4*y**4*z - 2*x**3*z**6
      - 25*x**2*y**3*z**4 + 19*x*y**6*z**2 - y**9 - 9*y**2*z**7),
    9*x**7*z**2 + 2*x**6*y**3 + 25*x**4*y**2*z**3
    - 38*x**3*y**5*z - 19*x**2*y*z**6 + 25*x*y**4*z**4
    - y**7*z**2 + z**9,
    x**9 - 19*x**6*y**2*z + 25*x**4*y*z**4
    + 25*x**3*y**4*z**2 + 9*x**2*y**7 - x**2*z**7
    - 38*x*y**3*z**5 + 2*y**6*z**3,
])

g11 = sp.Matrix([
    -(12*x**9*y*z + 23*x**7*z**4 - 114*x**6*y**3*z**2
      - 10*x**5*y**6 - 37*x**4*y**2*z**5 + 40*x**3*y**5*z**3
      + 34*x**2*y**8*z + x**2*y*z**8 + 67*x*y**4*z**6
      - 11*y**7*z**4 - z**11),
    x**11 - x**8*y**2*z - 67*x**6*y*z**4 + 37*x**5*y**4*z**2
    - 23*x**4*y**7 + 11*x**4*z**7 - 40*x**3*y**3*z**5
    + 114*x**2*y**6*z**3 - 12*x*y**9*z - 34*x*y**2*z**8
    + 10*y**5*z**6,
    -(34*x**8*y*z**2 - 11*x**7*y**4 - 10*x**6*z**5
      + 40*x**5*y**3*z**3 + 67*x**4*y**6*z - 114*x**3*y**2*z**6
      - 37*x**2*y**5*z**4 + x*y**8*z**2 + 12*x*y*z**9
      - y**11 + 23*y**4*z**7),
])


def invariant_monomials(weight: int) -> list[tuple[int, int, int]]:
    """Return (a,b,c) such that 4a+6b+14c=weight."""
    if weight < 0:
        return []
    answer = []
    for c in range(weight // 14 + 1):
        for b in range(weight // 6 + 1):
            remainder = weight - 14*c - 6*b
            if remainder >= 0 and remainder % 4 == 0:
                answer.append((remainder // 4, b, c))
    return answer


def invariant_expr(label: tuple[int, int, int]) -> sp.Expr:
    a, b, c = label
    return sp.expand(F**a * D**b * C**c)


def xyz_dict(poly: sp.Expr) -> dict[tuple[int, int, int], int]:
    return {monomial: int(coeff) for monomial, coeff in sp.Poly(poly, *XYZ).terms()}


def sparse_mul(
    left: dict[tuple[int, ...], int],
    right: dict[tuple[int, ...], int],
) -> dict[tuple[int, ...], int]:
    answer: defaultdict[tuple[int, ...], int] = defaultdict(int)
    for lm, lc in left.items():
        for rm, rc in right.items():
            answer[tuple(lm[i] + rm[i] for i in range(len(lm)))] += lc * rc
    return {monomial: coeff for monomial, coeff in answer.items() if coeff}


def sparse_add_into(
    target: dict[tuple[int, ...], int],
    source: dict[tuple[int, ...], int],
) -> None:
    for monomial, coeff in source.items():
        target[monomial] = target.get(monomial, 0) + coeff
        if target[monomial] == 0:
            del target[monomial]


CoeffDict = dict[tuple[int, ...], int]
InvariantCoefficients = dict[tuple[int, int, int], CoeffDict]


def pullback_coefficients(
    basis: list[sp.Matrix], degree: int
) -> InvariantCoefficients:
    """Decompose F(sum t_i basis_i) exactly in Q[F,D,C].

    The sparse polynomial has variables (x,y,z,t_0,...,t_{m-1}).  Distinct
    leading monomials of F^a D^b C^c give a small exact triangular solve.
    The final reconstruction assertion checks the entire polynomial identity,
    not merely the selected leading coefficients.
    """
    parameter_count = len(basis)
    encoded = []
    for coordinate in range(3):
        coordinate_dict: dict[tuple[int, ...], int] = {}
        for basis_index, vector in enumerate(basis):
            parameter_exp = tuple(
                1 if i == basis_index else 0 for i in range(parameter_count)
            )
            for xyz_exp, coeff in xyz_dict(sp.expand(vector[coordinate])).items():
                coordinate_dict[xyz_exp + parameter_exp] = coeff
        encoded.append(coordinate_dict)

    pullback: dict[tuple[int, ...], int] = {}
    for first, second in ((0, 1), (1, 2), (2, 0)):
        term = sparse_mul(
            sparse_mul(encoded[first], encoded[first]),
            sparse_mul(encoded[first], encoded[second]),
        )
        sparse_add_into(pullback, term)

    labels = invariant_monomials(4 * degree)
    invariant_dicts = [xyz_dict(invariant_expr(label)) for label in labels]
    leading_xyz = [max(poly_dict) for poly_dict in invariant_dicts]
    leading_matrix = sp.Matrix([
        [poly_dict.get(monomial, 0) for poly_dict in invariant_dicts]
        for monomial in leading_xyz
    ])
    leading_inverse = leading_matrix.inv()

    parameter_exponents = sorted({key[3:] for key in pullback})
    coefficients: InvariantCoefficients = {}
    for parameter_exp in parameter_exponents:
        rhs = sp.Matrix([
            pullback.get(xyz_exp + parameter_exp, 0) for xyz_exp in leading_xyz
        ])
        solved = leading_inverse * rhs
        for label, value in zip(labels, solved):
            if value:
                value = sp.Rational(value)
                assert value.q == 1
                coefficients.setdefault(label, {})[parameter_exp] = int(value)

    reconstructed: dict[tuple[int, ...], int] = {}
    for label, parameter_poly in coefficients.items():
        invariant_dict = invariant_dicts[labels.index(label)]
        for parameter_exp, first_coeff in parameter_poly.items():
            for xyz_exp, second_coeff in invariant_dict.items():
                key = xyz_exp + parameter_exp
                reconstructed[key] = (
                    reconstructed.get(key, 0) + first_coeff * second_coeff
                )
                if reconstructed[key] == 0:
                    del reconstructed[key]
    assert reconstructed == pullback
    return coefficients


def coefficient_expr(coefficients: CoeffDict, variables: tuple[sp.Symbol, ...]) -> sp.Expr:
    return sp.factor(sum(
        coeff * prod(variable**power for variable, power in zip(variables, powers))
        for powers, coeff in coefficients.items()
    ))


def specialize_coefficients(
    coefficients: InvariantCoefficients,
    values: tuple[int, ...],
) -> dict[tuple[int, int, int], int]:
    answer = {}
    for label, parameter_poly in coefficients.items():
        value = sum(
            coeff * prod(base**power for base, power in zip(values, powers))
            for powers, coeff in parameter_poly.items()
        )
        if value:
            answer[label] = value
    return answer


def impossible_support(degree: int) -> list[tuple[int, int, int]]:
    half = invariant_monomials(2 * degree)
    square_support = {
        tuple(left[i] + right[i] for i in range(3))
        for left in half for right in half
    }
    return [
        label for label in invariant_monomials(4 * degree)
        if label not in square_support
    ]


def reconstruct_odd_covariants_and_syzygy() -> sp.Expr:
    """Check Phi_21, the g9/g11 divisibility formulas, and the key syzygy."""
    jacobian = sp.Matrix([
        [sp.diff(poly, variable) for variable in XYZ]
        for poly in (F, D, C)
    ]).det()
    assert sp.rem(jacobian, 14) == 0
    X21 = sp.expand(jacobian / 14)

    degree_30_terms = [
        F**4*D*psi,
        F*D**3*psi,
        F**2*C*psi,
        F**2*D*phi,
        C*phi,
        F**3*f18,
        D**2*f18,
    ]
    numerator_9 = sum(
        (coefficient * vector for coefficient, vector in zip(
            (448, -2048, -48, 0, -1, 0, 12), degree_30_terms
        )),
        sp.zeros(3, 1),
    )
    assert all(
        sp.expand(numerator_9[i] - 14*X21*g9[i]) == 0 for i in range(3)
    )

    degree_32_terms = [
        F**6*psi,
        F**3*D**2*psi,
        D**4*psi,
        F*D*C*psi,
        F**4*phi,
        F*D**2*phi,
        F**2*D*f18,
        C*f18,
    ]
    numerator_11 = sum(
        (coefficient * vector for coefficient, vector in zip(
            (128, -160, -336, -236, -16, 104, 0, 1), degree_32_terms
        )),
        sp.zeros(3, 1),
    )
    assert all(
        sp.expand(numerator_11[i] - 14*X21*g11[i]) == 0 for i in range(3)
    )

    assert all(
        sp.expand(
            7*X21*identity[i]
            - (7*C*psi[i] - 3*D*phi[i] + 2*F*f18[i])
        ) == 0
        for i in range(3)
    )
    print("EXACT generators: g9/g11 divisibility and degree-22 syzygy PASS")
    return X21


def exact_exclusions() -> None:
    a, b, c, d = sp.symbols("a b c d")

    # Degree 9: a F^2 id + b g9.
    degree_9 = pullback_coefficients([F**2*identity, g9], 9)
    assert impossible_support(9) == [(9, 0, 0)]
    assert coefficient_expr(degree_9[(9, 0, 0)], (a, b)) == a**4
    g9_pullback = specialize_coefficients(degree_9, (0, 1))
    # If A D^3 + B F^3 D + C F C were squared, its D^6,
    # F^3 D^4 and F^6 D^2 coefficients would obey middle^2=4*ends.
    assert g9_pullback[(0, 6, 0)] == 768
    assert g9_pullback[(3, 4, 0)] == 176
    assert g9_pullback[(6, 2, 0)] == -64
    assert 176**2 != 4 * 768 * (-64)
    print("EXACT d=9: full 2-dimensional covariant space EXCLUDED")

    # Degree 11: a F D id + b g11.
    degree_11 = pullback_coefficients([F*D*identity, g11], 11)
    assert coefficient_expr(degree_11[(11, 0, 0)], (a, b)) == -1792*b**4
    assert coefficient_expr(degree_11[(0, 5, 1)], (a, b)) == 44*b**4
    assert coefficient_expr(degree_11[(1, 2, 2)], (a, b)) == b**3*(a - 34*b)
    scalar_11 = specialize_coefficients(degree_11, (1, 0))
    assert scalar_11 == {(5, 4, 0): 1}  # F(FD)^4 has odd F exponent.
    print("EXACT d=11: full 2-dimensional covariant space EXCLUDED")

    # Degree 15: a F^2D id + b C id + c D g9 + d F g11.
    degree_15 = pullback_coefficients([
        F**2*D*identity, C*identity, D*g9, F*g11
    ], 15)
    assert coefficient_expr(degree_15[(15, 0, 0)], (a, b, c, d)) == -1792*d**4
    assert coefficient_expr(degree_15[(1, 0, 4)], (a, b, c, d)) == b**3*(b + d)
    # Thus d=b=0.  The remaining map is D(a F^2 id+c g9), and the
    # d=9 impossible coefficient is merely shifted by D^4.
    assert coefficient_expr(degree_15[(9, 4, 0)], (a, b, c, d)).subs({b: 0, d: 0}) == a**4
    print("EXACT d=15: full 4-dimensional covariant space EXCLUDED")

    # Degree 18: a F D psi + b f18.
    degree_18 = pullback_coefficients([F*D*psi, f18], 18)
    assert coefficient_expr(degree_18[(0, 5, 3)], (a, b)) == -2919616*b**4
    # Once b=0, divide the evident square (FD)^4.  The remaining F(psi)
    # has a nonzero C term, while an invariant of degree 16 uses only
    # F^4 and F D^2 and hence its square has C-degree zero.
    psi_pullback = pullback_coefficients([psi], 8)
    assert psi_pullback[(3, 1, 1)] == {(4,): 32}
    assert all(label[2] == 0 for label in {
        tuple(left[i] + right[i] for i in range(3))
        for left in invariant_monomials(16)
        for right in invariant_monomials(16)
    })
    print("EXACT d=18: full 2-dimensional covariant space EXCLUDED")

    # Degree 22: a C psi + b F^2D psi + c D phi + d F f18.
    degree_22 = pullback_coefficients([
        C*psi, F**2*D*psi, D*phi, F*f18
    ], 22)
    forbidden_22 = impossible_support(22)
    assert forbidden_22 == [(1, 14, 0), (3, 1, 5), (0, 3, 5), (1, 0, 6)]
    expected_forbidden = {
        (1, 14, 0): -265531392*c**3*(c + 2*d),
        (3, 1, 5): 2*(
            16*a**4 - 6*a**3*b + 400*a**3*c - 856*a**3*d
            + 21*a**2*b*d - 3360*a**2*c*d + 5838*a**2*d**2
            + 12348*a*c*d**2 - 6860*a*d**3 - 19208*c*d**3
        ),
        (0, 3, 5): -4*a*(3*a + 7*c)**2*(3*a + 14*c),
        (1, 0, 6): -a**3*(3*a - 14*d),
    }
    for label, expected in expected_forbidden.items():
        assert sp.expand(
            coefficient_expr(degree_22[label], (a, b, c, d)) - expected
        ) == 0

    big = expected_forbidden[(3, 1, 5)] / 2
    assert sp.factor(big.subs(a, 0)) == -19208*c*d**3
    assert sp.factor(big.subs({c: -3*a/7, d: 3*a/14})) == (
        a**3 * (116*a - 21*b) / 14
    )
    # The forbidden equations have two branches:
    # (i) a=c=0, reducing after a common F to the excluded d=18 family;
    # (ii) the single projective point [42:232:-18:9].
    isolated = specialize_coefficients(degree_22, (42, 232, -18, 9))
    assert isolated.get((22, 0, 0), 0) == 0
    assert isolated[(19, 2, 0)] == 4129544208384
    assert max(isolated) == (19, 2, 0)
    assert any(exponent % 2 for exponent in max(isolated))
    print("EXACT d=22: full 4-dimensional covariant space EXCLUDED")


GENERATORS = (
    (1, identity),
    (8, psi),
    (9, g9),
    (11, g11),
    (16, phi),
    (18, f18),
)


def mod_rank(matrix: list[list[int]], prime: int) -> int:
    work = [[entry % prime for entry in row] for row in matrix]
    rank = 0
    column_count = len(work[0]) if work else 0
    for column in range(column_count):
        pivot = next(
            (row for row in range(rank, len(work)) if work[row][column]), None
        )
        if pivot is None:
            continue
        work[rank], work[pivot] = work[pivot], work[rank]
        inverse = pow(work[rank][column], prime - 2, prime)
        work[rank] = [(entry * inverse) % prime for entry in work[rank]]
        for row in range(rank + 1, len(work)):
            if work[row][column]:
                multiple = work[row][column]
                work[row] = [
                    (work[row][i] - multiple*work[rank][i]) % prime
                    for i in range(column_count)
                ]
        rank += 1
    return rank


def mod_inverse_matrix(matrix: list[list[int]], prime: int) -> list[list[int]]:
    size = len(matrix)
    work = [
        [entry % prime for entry in matrix[row]]
        + [1 if row == column else 0 for column in range(size)]
        for row in range(size)
    ]
    for column in range(size):
        pivot = next(row for row in range(column, size) if work[row][column])
        work[column], work[pivot] = work[pivot], work[column]
        inverse = pow(work[column][column], prime - 2, prime)
        work[column] = [(entry * inverse) % prime for entry in work[column]]
        for row in range(size):
            if row != column and work[row][column]:
                multiple = work[row][column]
                work[row] = [
                    (work[row][i] - multiple*work[column][i]) % prime
                    for i in range(2*size)
                ]
    return [row[size:] for row in work]


def mod_poly_terms(poly: sp.Expr) -> list[tuple[tuple[int, int, int], int]]:
    return [(monomial, int(coeff)) for monomial, coeff in sp.Poly(poly, *XYZ).terms()]


def mod_eval(
    terms: list[tuple[tuple[int, int, int], int]],
    point: tuple[int, int, int],
    prime: int,
) -> int:
    return sum(
        coeff
        * pow(point[0], monomial[0], prime)
        * pow(point[1], monomial[1], prime)
        * pow(point[2], monomial[2], prime)
        for monomial, coeff in terms
    ) % prime


def mod_sqrt(value: int, prime: int) -> int | None:
    return next((root for root in range(prime) if root*root % prime == value), None)


def formal_square_root_mod(
    polynomial: dict[tuple[int, int, int], int], prime: int
) -> dict[tuple[int, int, int], int] | None:
    """Square root in F_p[F,D,C] by descending lexicographic terms."""
    remainder = {
        monomial: coeff % prime for monomial, coeff in polynomial.items()
        if coeff % prime
    }
    root: dict[tuple[int, int, int], int] = {}
    while remainder:
        leading = max(remainder)
        coefficient = remainder[leading]
        if any(exponent % 2 for exponent in leading):
            return None
        half = tuple(exponent // 2 for exponent in leading)
        root_coefficient = mod_sqrt(coefficient, prime)
        if root_coefficient is None:
            return None
        remainder[leading] = (
            remainder[leading] - root_coefficient**2
        ) % prime
        if remainder[leading] == 0:
            del remainder[leading]
        for old_monomial, old_coefficient in list(root.items()):
            monomial = tuple(half[i] + old_monomial[i] for i in range(3))
            remainder[monomial] = (
                remainder.get(monomial, 0)
                - 2*root_coefficient*old_coefficient
            ) % prime
            if remainder[monomial] == 0:
                del remainder[monomial]
        root[half] = root_coefficient
    return root


def covariant_basis(degree: int) -> list[sp.Matrix]:
    answer = []
    for generator_degree, generator in GENERATORS:
        for label in invariant_monomials(degree - generator_degree):
            answer.append(invariant_expr(label) * generator)
    return answer


def projective_vectors(prime: int, dimension: int):
    for leading_zeroes in range(dimension):
        prefix = [0]*leading_zeroes + [1]
        for tail in product(range(prime), repeat=dimension-leading_zeroes-1):
            yield tuple(prefix + list(tail))


def finite_field_screen(
    degrees: tuple[int, ...] = (
        1, 5, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22
    ),
    prime: int = 11,
) -> None:
    """Non-lifting heuristic over a chosen finite prime field."""
    invariant_terms = [mod_poly_terms(poly) for poly in (F, D, C)]
    generator_term_cache = {
        degree: [[mod_poly_terms(vector[i]) for i in range(3)]]
        for degree, vector in GENERATORS
    }
    del generator_term_cache  # keep the construction below explicit

    points = [point for point in product(range(prime), repeat=3) if point != (0, 0, 0)]
    Random(808).shuffle(points)

    for degree in degrees:
        basis = covariant_basis(degree)
        dimension = len(basis)
        target_labels = invariant_monomials(4*degree)
        half_labels = invariant_monomials(2*degree)
        possible_square_support = {
            tuple(left[i] + right[i] for i in range(3))
            for left in half_labels for right in half_labels
        }
        forbidden_labels = [
            label for label in target_labels if label not in possible_square_support
        ]
        basis_terms = [
            [mod_poly_terms(vector[i]) for i in range(3)] for vector in basis
        ]

        rows: list[list[int]] = []
        basis_values: list[list[list[int]]] = []
        for point in points:
            f_value, d_value, c_value = [
                mod_eval(terms, point, prime) for terms in invariant_terms
            ]
            row = [
                pow(f_value, a, prime)
                * pow(d_value, b, prime)
                * pow(c_value, c, prime) % prime
                for a, b, c in target_labels
            ]
            if mod_rank(rows + [row], prime) > len(rows):
                rows.append(row)
                basis_values.append([
                    [mod_eval(terms, point, prime) for terms in vector_terms]
                    for vector_terms in basis_terms
                ])
            if len(rows) == len(target_labels):
                break
        assert len(rows) == len(target_labels)
        inverse = mod_inverse_matrix(rows, prime)
        forbidden_rows = [inverse[target_labels.index(label)] for label in forbidden_labels]

        solution_count = 0
        for parameters in projective_vectors(prime, dimension):
            values = []
            for point_basis_values in basis_values:
                image = [
                    sum(
                        parameters[j] * point_basis_values[j][coordinate]
                        for j in range(dimension)
                    ) % prime
                    for coordinate in range(3)
                ]
                values.append((
                    image[0]**3*image[1]
                    + image[1]**3*image[2]
                    + image[2]**3*image[0]
                ) % prime)
            if any(
                sum(row[j]*values[j] for j in range(len(values))) % prime
                for row in forbidden_rows
            ):
                continue
            coefficient_vector = [
                sum(inverse[i][j]*values[j] for j in range(len(values))) % prime
                for i in range(len(target_labels))
            ]
            candidate = {
                label: coeff for label, coeff in zip(target_labels, coefficient_vector)
                if coeff
            }
            if formal_square_root_mod(candidate, prime) is not None:
                solution_count += 1
        assert solution_count == 0
        print(
            f"HEURISTIC mod {prime} d={degree:2d}: dim={dimension}, "
            f"F_{prime}-rational landing vectors=0"
        )


def main() -> None:
    reconstruct_odd_covariants_and_syzygy()
    exact_exclusions()
    print("EXACT_EXCLUSIONS_OK degrees=9,11,15,18,22")
    print(
        "HEURISTIC ONLY: the following mod-11 screen is not a "
        "characteristic-zero proof"
    )
    finite_field_screen()
    print("MOD11_SCREEN_OK degrees<=22")
    print("WP3_COVARIANT_EXCLUSIONS_OK")


if __name__ == "__main__":
    main()
